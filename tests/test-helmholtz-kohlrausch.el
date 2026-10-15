;;; test-helmholtz-kohlrausch.el --- Helmholtz-Kohlrausch chromatic brightness boost -*- lexical-binding: t -*-

;; Copyright (C) 2026  Szymon Wilczek

;; Author: Szymon Wilczek <swilczek.lx@gmail.com>
;; URL: https://github.com/szymonwilczek/au-themes

;; This file is not part of GNU Emacs.

;; This file is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this file.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; Evaluate the Helmholtz-Kohlrausch effect: chromatic colours look
;; lighter than achromatic ones of the same luminance.  Each role's
;; equivalent achromatic lightness L** is computed and gated by polarity:
;;
;; - Dark themes: no syntax role may look lighter than body text by more
;;   than 8 L** units, so chroma does not lift a token above the text it
;;   annotates.  Cursor and error faces are meant to stand out and are
;;   reported but not gated.
;; - Light themes: the H-K lift pulls a token towards the background, so
;;   the L* gap to the canvas overstates the perceived gap.  That erosion
;;   (L* gap minus L** gap) must stay at or under 12 units for every role.
;;
;; Basis: L** is Fairchild & Pirrotta (1991).  The 8 and 12 unit limits
;; are au-themes heuristics fitted to the shipped palettes.
;;
;; Ref:
;; Fairchild & Pirrotta (1991) Color Res. Appl. 16(6):385-393.

;;; Code:

(require 'test-palette-extractor)

(defun test-helmholtz-kohlrausch-run ()
  "Evaluate Helmholtz-Kohlrausch perceived brightness."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (polarity (rf-theme-polarity theme))
         (bg (plist-get pal :bg-main))
         (bg-l (nth 0 (rf-hex-to-cielab bg)))
         (bg-l2 (rf-fairchild-pirrotta-lightness bg))
         (fg-l2 (rf-fairchild-pirrotta-lightness (plist-get pal :fg-main)))
         (max-lift 8.0)
         (max-erosion 12.0)
         (passes 0)
         (fails 0)
         (tokens '(("Base text"            :fg-main)
                   ("Comments"             :comment)
                   ("Cursor"               :cursor)
                   ("Preprocessor"         :preprocessor)
                   ("Keywords"             :keyword)
                   ("Data types"           :type)
                   ("Constants"            :constant)
                   ("Numbers"              :number)
                   ("Builtins"             :builtin)
                   ("Function definitions" :fnname)
                   ("Function calls"       :fnname-call)
                   ("Strings"              :string)
                   ("Struct fields"        :property)
                   ("Variables"            :variable)
                   ("Operators"            :operator)
                   ("Brackets"             :bracket)
                   ("Alerts / Errors (!)"  :err))))
    (princ (format ".~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.\n"))
    (princ (format " Helmholtz-Kohlrausch (H-K) Chromatic Lightness & Brightness Suite\n"))
    (princ (format " Theme: %s (%s) | Base text L**: %.1f | Background L**: %.1f\n"
                   theme polarity fg-l2 bg-l2))
    (princ (format " Gate: %s\n"
                   (if (eq polarity 'dark)
                       (format "role L** <= base text L** + %.0f (cursor and errors exempt)" max-lift)
                     (format "H-K erosion of the L* gap to the canvas <= %.0f" max-erosion))))
    (princ (format "'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'\n"))
    (princ (format "\n+----------------------+---------+------+------+-------+------+---------+---------+----------+--------+\n"))
    (princ (format "%-22s | %-7s | %-4s | %-4s | %-5s | %-4s | %-7s | %-7s | %-8s | %-6s |\n"
                   "| Token Role" "Hex" "L*" "C*" "hab" "L**" "Phot Y" "B/Y" "Y** (eq)" "Status"))
    (princ (format "+----------------------+---------+------+------+-------+------+---------+---------+----------+--------+\n"))
    (dolist (tok tokens)
      (let* ((name (nth 0 tok))
             (key  (nth 1 tok))
             (hex (plist-get pal key))
             (lab (rf-hex-to-cielab hex))
             (l-star (nth 0 lab))
             (a-star (nth 1 lab))
             (b-star (nth 2 lab))
             (c-star (sqrt (+ (* a-star a-star) (* b-star b-star))))
             (h-rad (atan b-star a-star))
             (h-deg (let ((d (* h-rad (/ 180.0 float-pi))))
                      (if (< d 0.0) (+ d 360.0) d)))
             (l-double-star (rf-fairchild-pirrotta-lightness hex))
             (y   (rf-luminance-y hex))
             (hk-factor (rf-helmholtz-kohlrausch-factor hex))
             (perceived (* y hk-factor))
             ;; Dark: lift above body text.
             ;; Light: how much of the L* gap to the canvas the H-K
             ;; lift takes away.
             (lift (- l-double-star fg-l2))
             (erosion (- (abs (- bg-l l-star)) (abs (- bg-l2 l-double-star))))
             (status
              (cond
               ((eq key :fg-main) "REF")
               ((eq polarity 'dark)
                (cond ((memq key '(:cursor :err)) "EXEMPT")
                      ((<= lift max-lift) "PASS")
                      (t "FAIL")))
               ((<= erosion max-erosion) "PASS")
               (t "FAIL"))))
        (cond ((string= status "PASS") (setq passes (1+ passes)))
              ((string= status "FAIL") (setq fails (1+ fails))))
        (princ (format "| %-20s | %-7s | %4.1f | %4.1f | %5.1f | %4.1f | %7.4f | %7.3f | %7.4f  | %-6s |\n"
                       name hex l-star c-star h-deg l-double-star y hk-factor perceived status))))
    (princ (format "+----------------------+---------+------+------+-------+------+---------+---------+----------+--------+\n"))
    (princ (format "\n=======================================================================================================\n"))
    (princ (format "Helmholtz-Kohlrausch Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-helmholtz-kohlrausch-run)
    (kill-emacs 1)))

(provide 'test-helmholtz-kohlrausch)
;;; test-helmholtz-kohlrausch.el ends here
