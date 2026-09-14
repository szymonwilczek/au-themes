;;; test-cvd-colorblindness.el --- Congenital Color Vision Deficiency (CVD) Simulation -*- lexical-binding: t -*-

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
;; Evaluate syntax token discriminability under Protanopia, Deuteranopia,
;; and Tritanopia.
;; Dichromat appearance is simulated with the two half-plane LMS projection
;; using the Smith & Pokorny (1975) cone fundamentals over Judd-Vos corrected XYZ.
;;
;; Ref:
;; - Brettel, Viénot & Mollon (1997) J. Opt. Soc. Am. A 14(10):2647-2655
;; - Viénot, Brettel & Mollon (1999) Color Res. Appl. 24(4):243-252
;; - Smith & Pokorny (1975)

;;; Code:

(require 'test-palette-extractor)

(defun test-cvd-colorblindness-run ()
  "Evaluate syntax token discriminability under Protanopia, Deuteranopia, and Tritanopia."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (passes 0)
         (fails 0)
         ;; Discriminability gate: CIEDE2000 (CIE 142:2001 / ISO-CIE 11664-6)
         ;; 1 unit is ~1 JND for large uniform patches; thin antialiased glyphs
         ;; inspected in passing need a large margin, so a 10x design factor is
         ;; required.
         (min-de 10.0)
         (cvd-modes '((protan . "Protanopia (Red-Blind)")
                      (deutan . "Deuteranopia (Green-Blind)")
                      (tritan . "Tritanopia (Blue-Blind)")))
         (pairs '(("Keyword vs Data Type"        :keyword      :type)
                  ("Keyword vs Builtin"          :keyword      :builtin)
                  ("Keyword vs Number"           :keyword      :number)
                  ("Data Type vs String"         :type         :string)
                  ("Preprocessor vs Constant"    :preprocessor :constant)
                  ("Function Def vs Data Type"   :fnname       :type)
                  ("Alert / Error vs Base Text"  :err          :fg-main))))
    (princ (format "\n.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.\n"))
    (princ (format "| Color Vision Deficiency (CVD) Accessibility Gate Suite\n"))
    (princ (format "| Requirement: Minimum pairwise CIEDE2000 dE00 >= %.1f in all CVD modes\n" min-de))
    (princ (format "| Theme: %s\n" theme))
    (princ (format "'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'\n"))
    (dolist (mode-spec cvd-modes)
      (let ((mode (car mode-spec))
            (label (cdr mode-spec)))
        (princ (format "\nMode: %s\n" label))

        (princ (format "+----------------------------+--------------------+--------------------+----------+--------+\n"))
        (princ (format "| %-26s | %-18s | %-18s | %-8s | %-7s|\n"
                       "Syntax Pair" "Simulated 1" "Simulated 2" "dE00" "Status"))
        (princ (format "+----------------------------+--------------------+--------------------+----------+--------+\n"))
        (dolist (p pairs)
          (let* ((p-label (nth 0 p))
                 (k1      (nth 1 p))
                 (k2      (nth 2 p))
                 (c1      (plist-get pal k1))
                 (c2      (plist-get pal k2))
                 (sim1    (rf-cvd-simulate c1 mode))
                 (sim2    (rf-cvd-simulate c2 mode))
                 (dist    (rf-delta-e-2000 sim1 sim2))
                 (ok      (>= dist min-de)))
            (if ok
                (setq passes (1+ passes))
              (setq fails (1+ fails)))
            (princ (format "| %-26s | %-8s (%s) | %-8s (%s) | %8.2f | %s   |\n"
                           p-label c1 sim1 c2 sim2 dist
                           (if ok "PASS" "FAIL")))))
        (princ (format "+----------------------------+--------------------+--------------------+----------+--------+\n"))))
    (princ (format "\nCVD Simulation Summary: %d Passed, %d Failed across all 3 modes.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-cvd-colorblindness-run)
    (kill-emacs 1)))

(provide 'test-cvd-colorblindness)
;;; test-cvd-colorblindness.el ends here
