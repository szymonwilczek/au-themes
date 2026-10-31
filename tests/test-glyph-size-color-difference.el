;;; test-glyph-size-color-difference.el --- Colour difference at glyph size -*- lexical-binding: t -*-

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
;; Evaluate whether every pair of syntax roles stays apart at the size
;; of a glyph, not only as large patches.
;;
;; CIEDE2000 and plain CIELAB are scaled for large uniform fields.  As a
;; target shrinks, the difference needed to see two colours apart grows,
;; and it grows far more along the chromatic axes than along lightness.
;; Two dark colours that differ only in hue then pass the dE00 gates
;; while reading as the same ink on a light canvas.
;;
;; The size model is the crowdsourced fit for point marks in Szafir
;; (2018), replicating Stone, Szafir & Setlur (2014).  For a target of
;; s degrees of visual angle, the 50% noticeable difference along each
;; CIELAB axis is
;;
;;   ND_L(s) = 5.095 + 0.80 / s
;;   ND_a(s) = 5.089 + 2.69 / s
;;   ND_b(s) = 6.786 + 3.20 / s
;;
;; and the scaled difference is
;;
;;   dE_s = sqrt ((dL / ND_L)^2 + (da / ND_a)^2 + (db / ND_b)^2)
;;
;; so that dE_s = 1.0 is a difference half of the viewers notice.
;;
;; The size is 0.25 degrees: about the cap height of a 14 px coding
;; font at a 60 cm viewing distance, and the smallest size the model
;; was fitted on, so the fit is not extrapolated.  At that size ND is
;; 8.3 along L*, 15.8 along a* and 19.6 along b*, against 5.1, 5.1
;; and 6.8 for large fields.
;;
;; Families in `au-test-strict-families' are checked on every pair of
;; roles; the neutral roles in `au-test-receding-roles' form one grey
;; ladder and are not compared with each other.  Other families skip
;; this module until they are retuned.
;;
;; Basis: the size model and its coefficients are Szafir (2018); the
;; 0.25 degree size and the 1.0 floor are au-themes choices.
;;
;; Ref:
;; - Stone, Szafir & Setlur (2014) An engineering model for color
;;   difference as a function of size.  22nd Color and Imaging
;;   Conference (IS&T).
;; - Szafir (2018) Modeling color difference for visualization design.
;;   IEEE Trans. Vis. Comput. Graph. 24(1):392ff.  doi:10.1109/TVCG.2017.2744359

;;; Code:

(require 'test-palette-extractor)

(defconst au-glyph-size-degrees 0.25
  "Visual angle of a glyph, in degrees, for the size-dependent model.")

(defconst au-glyph-size-min-difference 1.0
  "Lowest scaled difference allowed between two syntax roles.")

(defun au-glyph-size-noticeable-differences (s)
  "Return the 50% noticeable differences (L a b) for a target of S degrees."
  (list (+ 5.095 (/ 0.80 s))
        (+ 5.089 (/ 2.69 s))
        (+ 6.786 (/ 3.20 s))))

(defun au-glyph-size-delta-e (hex1 hex2 &optional s)
  "Scaled CIELAB difference between HEX1 and HEX2 for a target of S degrees."
  (let ((lab1 (rf-hex-to-cielab hex1))
        (lab2 (rf-hex-to-cielab hex2))
        (nd (au-glyph-size-noticeable-differences
             (or s au-glyph-size-degrees)))
        (sum 0.0))
    (dotimes (i 3)
      (setq sum (+ sum (expt (/ (- (nth i lab1) (nth i lab2)) (nth i nd)) 2))))
    (sqrt sum)))

(defun test-glyph-size-color-difference-run ()
  "Evaluate scaled colour difference at glyph size for every pair of roles."
  (let* ((theme (or rf-active-theme (car (au-test-discover-themes))))
         (pal (au-extract-active-palette theme))
         (passes 0)
         (fails 0)
         (roles '(:preprocessor :keyword :type :constant :number
                                :builtin :fnname :fnname-call :string :property
                                :operator :bracket :delimiter :err :comment :fg-main
                                :variable)))
    (princ (format "\n.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.\n"))
    (princ (format "| Glyph-Size Colour Difference Suite (Szafir 2018, s = %.2f deg, min. dE_s %.1f)\n"
                   au-glyph-size-degrees au-glyph-size-min-difference))
    (princ (format "| Theme: %s\n" theme))
    (princ (format "'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'\n"))
    (if (not (au-test-strict-family-p theme))
        (progn
          (princ "\n[SKIP]  Glyph-size separation applies to the strict families only.\n")
          (princ (format "\n===========================================================================================\n"))
          (princ "Glyph-Size Summary: skipped (family not in au-test-strict-families).\n\n")
          'skip)
      (princ (format "+--------------------------------------+-------------+-------------+-----------+----------+\n"))
      (princ (format "| %-36s |   %-10s|   %-10s|  %-7s  |  %-6s  |\n"
                     "Role Comparison" "Color 1" "Color 2" " dE_s" "Status"))
      (princ (format "+--------------------------------------+-------------+-------------+-----------+----------+\n"))
      (dolist (pair (au-test-all-role-pairs roles))
        (let* ((h1 (plist-get pal (nth 1 pair)))
               (h2 (plist-get pal (nth 2 pair)))
               (dist (au-glyph-size-delta-e h1 h2))
               (ok (>= dist au-glyph-size-min-difference)))
          (if ok
              (setq passes (1+ passes))
            (setq fails (1+ fails)))
          (princ (format "| %-36s |   %-10s|   %-10s|%8.2f   |   %s   |\n"
                         (nth 0 pair) h1 h2 dist
                         (if ok "PASS" "FAIL")))))
      (princ (format "+--------------------------------------+-------------+-------------+-----------+----------+\n"))
      (princ (format "\n===========================================================================================\n"))
      (princ (format "Glyph-Size Summary: %d Passed, %d Failed.\n\n" passes fails))
      (zerop fails))))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-glyph-size-color-difference-run)
    (kill-emacs 1)))

(provide 'test-glyph-size-color-difference)
;;; test-glyph-size-color-difference.el ends here
