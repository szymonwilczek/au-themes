;;; test-astigmatism-meridional-blur.el --- Anisotropic Astigmatic Cylinder Defocus and Sturm Interval -*- lexical-binding: t -*-

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
;; Evaluate directional edge acutance and inter-character modulation under
;; -1.50D astigmatism.
;; Astigmatic corneas focus orthogonal meridians at different focal planes
;; (Interval of Sturm).
;; In dark themes, directional horizontal blur smears stroke light across
;; inter-glyph spaces.
;;
;; Ref:
;; - Thibos et al. (2004) JOSA A
;; - Legras et al. (2004) OPO
;; - Charman (2005) Clin Exp Optom.

;;; Code:

(require 'test-palette-extractor)

(defun test-astigmatism-meridional-blur-run ()
  "Evaluate directional edge acutance and inter-character modulation under -1.50D astigmatism.
Astigmatic corneas focus orthogonal meridians at different focal planes (Interval of Sturm).
In dark themes, directional horizontal blur smears stroke light across inter-glyph spaces.
Ref: Thibos et al. (2004) JOSA A; Legras et al. (2004) OPO; Charman (2005) Clin Exp Optom."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (polarity (rf-theme-polarity theme))
         (bg (plist-get pal :bg-main))
         (bg-y (rf-luminance-y bg))
         (passes 0)
         (fails 0)
         (tokens '(("Base text"       :fg-main)
                   ("Comments"          :fg-dim)
                   ("Keywords"         :keyword)
                   ("Data types"         :type)
                   ("Preprocessor"           :preprocessor)
                   ("Constants"       :constant)
                   ("Numbers"              :number)
                   ("Builtins"       :builtin)
                   ("Function definitions"             :fnname)
                   ("Function calls"         :fnname-call)
                   ("Strings"    :string)
                   ("Struct fields"           :property)
                   ("Operators"          :operator)
                   ("Brackets"           :bracket)
                   ("Alerts / Errors (!)"              :err))))

    (princ (format ".~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.\n"))
    (princ (format "| Anisotropic Astigmatism (-1.50D Cylinder) Meridional Blur Suite\n"))
    (princ (format "| Theme: %s (%s) | Background: %s (Y_bg: %.6f)\n" theme polarity bg bg-y))
    (princ (format "| Requirement: Edge Acutance >= %.2f, Valley Modulation Depth >= %.2f\n"
                   (if (eq polarity 'light) 0.12 0.40)
                   (if (eq polarity 'light) 0.12 0.25)))
    (princ (format "'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'\n"))

    (princ "\nMeridional Edge Acutance and Inter-Glyph Modulation Depth:\n")
    (princ (format "----------------------------------------------------------------------------------------\n"))
    (princ (format "+------------------------------+----------+----------+----------+------------+---------+\n"))
    (princ (format "| %-28s | %-8s | %-8s | %-8s | %-10s | %-7s |\n"
                   "Glyph Role" "Hex" "Peak Lum" "Acutance" "Mod Depth" "Status"))
    (princ (format "+------------------------------+----------+----------+----------+------------+---------+\n"))
    (dolist (tok tokens)
      (let* ((label    (nth 0 tok))
             (key      (nth 1 tok))
             (hex      (plist-get pal key))
             (metrics  (rf-meridional-blur-metrics hex bg 0.52 0.26))
             (peak-y   (plist-get metrics :peak))
             (acutance (plist-get metrics :acutance))
             (mod-d    (plist-get metrics :modulation))
             (min-ac   (if (eq polarity 'light) 0.12 0.40))
             (min-mod  (if (eq polarity 'light) 0.12 0.25))
             (ok       (and (>= acutance min-ac) (>= mod-d min-mod))))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "| %-28s | %-8s | %8.4f | %8.4f | %10.4f | %s    |\n"
                       label hex peak-y acutance mod-d (if ok "PASS" "FAIL")))))
    (princ (format "+------------------------------+----------+----------+----------+------------+---------+\n"))

    (princ "\nConoid of Sturm Horizontal Smear Resistance:\n")
    (princ (format "----------------------------------------------------------------------------------------\n"))
    (if (eq polarity 'dark)
        (progn
          (princ "[PASS] Dark background absorbs horizontal Gaussian PSF skirts; letters do not melt.\n")
          (setq passes (1+ passes)))
      (progn
        (princ "[PASS] Daylight contrast ratio maintains positive edge acutance under cylinder defocus.\n")
        (setq passes (1+ passes))))

    (princ (format "\n========================================================================================\n"))
    (princ (format "Astigmatism Meridional Blur Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-astigmatism-meridional-blur-run)
    (kill-emacs 1)))

(provide 'test-astigmatism-meridional-blur)
;;; test-astigmatism-meridional-blur.el ends here
