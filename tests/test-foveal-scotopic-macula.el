;;; test-foveal-scotopic-macula.el --- Foveal macular tritanopia and L+M cone fraction -*- lexical-binding: t -*-

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
;; Evaluate foveal non-S (R+G) luminance fraction for high-frequency
;; glyphs.
;;
;; Ref:
;; - Curcio et al. (1991)
;; - Bone et al. (1988)
;; - Stockman & Sharpe (2000)

;;; Code:

(require 'test-palette-extractor)

(defun test-foveal-scotopic-macula-run ()
  "Evaluate foveal non-S (R+G) luminance fraction for high-frequency glyphs.
Ref: Curcio et al. (1991), Bone et al. (1988), Stockman & Sharpe (2000)."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (passes 0)
         (fails 0)
         (tokens '(("Base text (Mineral quartz)"       :fg-main      0.850)
                   ("Operators (+, -, *, >>)"          :operator     0.850)
                   ("Brackets (( ) [ ] { })"           :bracket      0.850)
                   ("Delimiters (, ;)"                 :delimiter    0.850)
                   ("Struct fields (->tgid)"           :property     0.850)
                   ("Keywords (struct, while)"         :keyword      0.850)
                   ("Data types (int, size_t)"         :type         0.850)
                   ("Comments (Damp needles)"          :fg-dim       0.850))))
    (princ (format "\n======================================================================\n"))
    (princ (format " Foveal S-Cone Exclusion & Macular Pigment Transmission Suite\n"))
    (princ (format " Ref: Curcio et al. (1991) J. Comp. Neurol (0.1 mm S-free foveola);\n"))
    (princ (format "      Bone et al. (1988) Vision Res (macular lutein/zeaxanthin absorption)\n"))
    (princ (format " Requirement: Non-S (R+G) photopic luminance fraction F_(L+M) >= 85.0%%\n"))
    (princ (format " Theme: %s\n" theme))
    (princ (format "======================================================================\n"))
    (princ (format "%-32s | %-8s | %-12s | %-12s | %-8s\n"
                   "High-Frequency Glyph Role" "Hex" "F_(L+M)" "Min Req" "Status"))
    (princ (format "---------------------------------+----------+--------------+--------------+----------\n"))
    (dolist (tok tokens)
      (let* ((label (nth 0 tok))
             (key   (nth 1 tok))
             (min-f (nth 2 tok))
             (hex   (plist-get pal key))
             (frac  (rf-foveal-lm-fraction hex))
             (ok    (>= frac min-f)))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "%-32s | %-8s | %10.2f%% | %10.2f%% | %s\n"
                       label hex (* frac 100.0) (* min-f 100.0)
                       (if ok "PASS" "FAIL")))))
    (princ (format "---------------------------------+----------+--------------+--------------+----------\n"))
    (princ (format "Foveal Macular Tritanopia Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-foveal-scotopic-macula-run)
    (kill-emacs 1)))

(provide 'test-foveal-scotopic-macula)
;;; test-foveal-scotopic-macula.el ends here
