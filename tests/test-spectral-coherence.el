;;; test-spectral-coherence.el --- Forest canopy spectral filtration and illumination coherence -*- lexical-binding: t -*-

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
;; Evaluate palette illumination coherence under simulated forest canopy
;; filtration.
;;
;; Note:
;; Evaluates the display luminance centroid lambda_bar_Y (weighted by primary
;; luminances where green dominates Y with ~71.5%), rather than CIE 15 dominant
;; wavelength lambda_d.
;; Under an overcast forest canopy, chlorophyll absorbs red (650-670 nm)
;; and blue (420-440 nm), filtering light into a 520-580 nm green-amber window
;; (Endler 1993).
;;
;; Ref:
;; Endler (1993) Ecol.  Monogr. 63(1):1-27 ('The color of light in forests').

;;; Code:

(require 'test-palette-extractor)

(defun test-spectral-coherence-run ()
  "Evaluate palette illumination coherence under simulated forest canopy filtration."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (passes 0)
         (warnings 0)
         (fails 0)
         (tokens '(("Preprocessor"         :preprocessor 520.0 570.0)
                   ("Keywords"             :keyword      520.0 570.0)
                   ("Data types"           :type         525.0 565.0)
                   ("Numbers"              :number       545.0 585.0)
                   ("Function definitions" :fnname       500.0 550.0)
                   ("Function calls"       :fnname-call  500.0 550.0)
                   ("Strings"              :string       540.0 585.0)
                   ("Struct fields"        :property     525.0 565.0)
                   ("Operators"            :operator     530.0 560.0)
                   ("Brackets"             :bracket      530.0 560.0))))
    (princ (format "\n.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.\n"))
    (princ (format "| Forest Canopy Spectral Filtration and Physical Coherence Suite\n"))
    (princ (format "| Theme: %s\n" theme))
    (princ (format "> Note:  Metric is display luminance centroid lambda_bar_Y\n\t (not CIE 15 lambda_d)\n"))
    (princ (format "'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'\n"))
    (princ (format "\n+----------------------+---------+----------+------------------+-------------+\n"))
    (princ (format "| %-20s | %-7s | %-8s | %-16s | %-11s |\n"
                   "Token Role" "Hex" "Eff Wave" "Canopy Window" "Coherence"))
    (princ (format "+----------------------+---------+----------+------------------+-------------+\n"))
    (dolist (tok tokens)
      (let* ((name (nth 0 tok))
             (key  (nth 1 tok))
             (min-w (nth 2 tok))
             (max-w (nth 3 tok))
             (hex (plist-get pal key))
             (wave (rf-effective-wavelength hex))
             (ok (and (>= wave min-w) (<= wave max-w))))
        (if ok
            (setq passes (1+ passes))
          (setq warnings (1+ warnings)))
        (princ (format "| %-20s | %-7s | %6.1fnm | [%5.1f..%5.1fnm] |  %-9s  |\n"
                       name hex wave min-w max-w
                       (if ok "COHERENT" "DIVERGENT")))))
    (princ (format "+----------------------+---------+----------+------------------+-------------+\n"))
    (princ (format "\n==============================================================================\n"))
    (princ (format "Spectral Coherence Summary: %d Coherent, %d Divergent.\n\n" passes warnings))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-spectral-coherence-run)
    (kill-emacs 1)))

(provide 'test-spectral-coherence)
;;; test-spectral-coherence.el ends here
