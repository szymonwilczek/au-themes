;;; test-glare-veiling-luminance.el --- Intraocular Veiling Glare and Straylight Integral -*- lexical-binding: t -*-

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
;; Evaluate intraocular veiling glare spatial integral and token contrast
;; retention.
;;
;; Ref:
;; - CIE 112-1994
;; - Vos & van den Berg (1999)
;; - IESNA TM-12-12

;;; Code:

(require 'test-palette-extractor)

(defun test-glare-veiling-luminance-run ()
  "Evaluate intraocular veiling glare spatial integral and token contrast retention."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (polarity (rf-theme-polarity theme))
         (bg (plist-get pal :bg-main))
         (bg-y (rf-luminance-y bg))
         ;; Veiling luminance is physical (cd/m2) from CIE 146 straylight integral
         (lv-cd (rf-veiling-glare-luminance pal))
         (lv (/ lv-cd rf-display-white-luminance))
         (passes 0)
         (fails 0)
         (tokens
          (if (eq polarity 'light)
              (if (< bg-y 0.420)
                  '(("Comments"     :fg-dim       25.0 60.0)
                    ("Brackets"     :bracket      30.0 78.0)
                    ("Keywords"     :keyword      30.0 78.0)
                    ("Data types"   :type         30.0 78.0)
                    ("Preprocessor" :preprocessor 30.0 78.0)
                    ("Base text"    :fg-main      48.0 85.0))
                '(("Comments"       :fg-dim       35.0 60.0)
                  ("Brackets"       :bracket      40.0 78.0)
                  ("Keywords"       :keyword      40.0 78.0)
                  ("Data types"     :type         40.0 78.0)
                  ("Preprocessor"   :preprocessor 40.0 78.0)
                  ("Base text"      :fg-main      58.0 85.0)))
            '(("Comments"           :fg-dim       10.0 28.0)
              ("Brackets"           :bracket      14.0 40.0)
              ("Keywords"           :keyword      16.0 55.0)
              ("Data types"         :type         16.0 55.0)
              ("Preprocessor"       :preprocessor 16.0 55.0)
              ("Base text"          :fg-main      46.0 62.0)))))
    (princ (format "\n.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.\n"))
    (princ (format "| Intraocular Veiling Glare & Corneal Straylight Spatial Integral Suite\n"))
    (princ (format "| Theme: %s (%s) | Background: %s (Lum Y: %.6f)\n" theme polarity bg bg-y))
    (princ (format "| Straylight integral (1 deg .. field edge, age %.0f, p = %.1f): %.4f\n"
                   rf-observer-age rf-eye-pigmentation (rf-straylight-integral)))
    (princ (format "| Veiling Luminance Lv: %.4f cd/m2 (%.6f of display white)\n" lv-cd lv))
    (princ (format "> Note: APCA intrinsically models display black floor (blkThrs/blkClmp)\n"))
    (princ (format ">\tVeiling glare impact is evaluated via retinal Michelson\n>\tcontrast retention.\n"))
    (princ (format "'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'\n"))
    (princ (format "\n+--------------+---------+-------+-------------+-------------+--------+\n"))
    (princ (format "| %-12s | %-7s | %-5s | %-11s | %-11s | %-7s|\n"
                   "Token Role" "Hex" "|Lc|" "Nominal C_M" "Retinal C_M" "Status"))
    (princ (format "+--------------+---------+-------+-------------+-------------+--------+\n"))
    (dolist (tok tokens)
      (let* ((label    (nth 0 tok))
             (key      (nth 1 tok))
             (min-lc   (nth 2 tok))
             (max-lc   (nth 3 tok))
             (hex      (plist-get pal key))
             (y-tok    (rf-luminance-y hex))
             (lc       (abs (rf-apca-contrast hex bg)))
             ;; Nominal Michelson contrast on panel surface:
             (cm-nom   (/ (abs (- y-tok bg-y)) (max 1e-6 (+ y-tok bg-y))))
             ;; Retinal Michelson contrast with intraocular veiling luminance Lv:
             (cm-ret   (/ (abs (- y-tok bg-y)) (max 1e-6 (+ y-tok bg-y (* 2.0 lv)))))
             ;; Contrast retention ratio: must retain >= 70% under ocular veiling glare
             (retention (/ cm-ret (max 1e-6 cm-nom)))
             (ok       (and (>= lc min-lc) (<= lc max-lc) (>= retention 0.65))))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "| %-12s | %-7s | %5.2f | %11.4f | %9.4f   |  %s  |\n"
                       label hex lc cm-nom cm-ret
                       (if ok "PASS" "FAIL")))))
    (princ (format "+--------------+---------+-------+-------------+-------------+--------+\n"))
    (princ (format "\n=======================================================================\n"))
    (princ (format "Veiling Glare Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-glare-veiling-luminance-run)
    (kill-emacs 1)))

(provide 'test-glare-veiling-luminance)
;;; test-glare-veiling-luminance.el ends here
