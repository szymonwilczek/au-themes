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
;; Evaluate Helmholtz-Kohlrausch perceived brightness.
;; Uses the published model of Fairchild & Pirrotta (1991).

;;; Code:

(require 'test-palette-extractor)

(defun test-helmholtz-kohlrausch-run ()
  "Evaluate Helmholtz-Kohlrausch perceived brightness.
Uses the published model of Fairchild & Pirrotta (1991)."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (passes 0)
         (tokens '(("Base text (Mineral quartz)"       :fg-main)
                   ("Comments (Damp needles)"          :fg-dim)
                   ("Cursor (Raindrop glint)"          :cursor)
                   ("Preprocessor (#define)"           :preprocessor)
                   ("Keywords (struct, while)"         :keyword)
                   ("Data types (int, size_t)"         :type)
                   ("Constants (LOTA_PCR_COUNT)"       :constant)
                   ("Numbers (0, 24, 32)"              :number)
                   ("Builtins (__always_inline)"       :builtin)
                   ("Function definitions"             :fnname)
                   ("Function calls (bpf_...)"         :fnname-call)
                   ("Strings (\"string literals\")"    :string)
                   ("Struct fields (->tgid)"           :property)
                   ("Operators (+, -, *, >>)"          :operator)
                   ("Brackets (( ) [ ] { })"           :bracket)
                   ("Alerts / Errors (!)"              :err))))
    (princ (format "\n======================================================================\n"))
    (princ (format " Helmholtz-Kohlrausch (H-K) Chromatic Lightness & Brightness Suite\n"))
    (princ (format " Ref: Fairchild & Pirrotta (1991) Color Res. Appl. 16(6):385-393\n"))
    (princ (format " Theme: %s\n" theme))
    (princ (format "======================================================================\n"))
    (princ (format "%-28s | %-7s | %-4s | %-4s | %-5s | %-4s | %-7s | %-7s | %-7s\n"
                   "Token Role" "Hex" "L*" "C*" "hab" "L**" "Phot Y" "B/Y" "Y** (eq)"))
    (princ (format "-----------------------------+---------+------+------+-------+------+---------+---------+--------\n"))
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
             (perceived (* y hk-factor)))
        (setq passes (1+ passes))
        (princ (format "%-28s | %-7s | %4.1f | %4.1f | %5.1f | %4.1f | %7.4f | %7.3f | %7.4f\n"
                       name hex l-star c-star h-deg l-double-star y hk-factor perceived))))
    (princ (format "-----------------------------+---------+------+------+-------+------+---------+---------+--------\n"))
    (princ "Biophysical Principle (Fairchild & Pirrotta 1991):\n")
    (princ "Saturated colors stimulate human brightness perception (L-M, S-(L+M) opponent channels)\n")
    (princ "yielding an equivalent achromatic lightness L** > L* and luminance multiplier B/Y > 1.0.\n")
    (princ "Blue (hab ~ 270 deg) and Red (hab ~ 30 deg) induce the strongest H-K boost.\n")
    (princ (format "----------------------------------------------------------------------\n"))
    (princ (format "Helmholtz-Kohlrausch Summary: %d Evaluated.\n\n" passes))
    t))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-helmholtz-kohlrausch-run)
    (kill-emacs 1)))

(provide 'test-helmholtz-kohlrausch)
;;; test-helmholtz-kohlrausch.el ends here
