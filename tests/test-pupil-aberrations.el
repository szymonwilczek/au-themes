;;; test-pupil-aberrations.el --- Pupil dynamics and r^4 spherical aberration scaling -*- lexical-binding: t -*-

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
;; Evaluate pupil aperture and 4th-order spherical aberration scaling.
;; The adapting field is the whole 80x40 viewport at the IEC 61966-2-1 reference
;; white luminance, not the background colour alone: the pupil integrates
;; corneal flux over the field (Stanley & Davies 1995), so using only the canvas
;; luminance under-drives the model.
;;
;; Ref:
;; - Liang & Williams (1997) JOSA A 14:2873-2883
;; - Watson & Yellott (2012) J. Vis. 12(10):12
;; - Stanley & Davies (1995)

;;; Code:

(require 'test-palette-extractor)

(defun test-pupil-aberrations-run ()
  "Evaluate pupil aperture and 4th-order spherical aberration scaling."
  (let* ((pal (au-extract-active-palette))
         (bg (plist-get pal :bg-main))
         (theme (plist-get pal :theme))
         (view-y (rf-viewport-mean-luminance-y pal))
         (l-bg (* view-y rf-display-white-luminance))
         (field-deg2 (rf-display-field-area-deg2))
         (pupil-diam (rf-pupil-diameter l-bg))
         (aber-factor (rf-wavefront-aberration-factor pupil-diam))
         (passes 0)
         (fails 0)
         (warnings 0))
    (princ (format "\n.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.\n"))
    (princ (format "| Pupil Dynamics & 4th-Order Spherical Wavefront Aberration Suite\n"))
    (princ (format "| Theme: %s | Background: %s\n" theme bg))
    (princ (format "'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'\n"))
    (princ (format "\nAdapting field: %.0f deg2 at %.0f cd/m2 white -> %.4f cd/m2\n"
                   field-deg2 rf-display-white-luminance l-bg))
    (princ (format "Pupil Diameter (Watson-Yellott, age %.0f):  %.2f mm\n"
                   rf-observer-age pupil-diam))
    (princ (format "4th-Order Spherical Aberration Factor: %.2fx (vs 4.0mm pupil)\n" aber-factor))
    (princ (format "--------------------------------------------------------------------\n"))

    ;; Pupil over-dilation threshold
    (let ((max-d (if (eq (rf-theme-polarity theme) 'light) 4.50 5.50))
          (min-d (if (eq (rf-theme-polarity theme) 'light) 2.00 2.50)))
      (princ (format "\nSafe Pupil Dilation Threshold (d <= %.2f mm):\n" max-d))
      (if (<= pupil-diam max-d)
          (progn
            (princ (format "[PASS]  Pupil (%.2f mm) remains in optimal optical zone (< %.2f mm).\n" pupil-diam max-d))
            (princ "\tAstigmatic cylinder defocus and spherical aberration remain\n\tcontained.\n")
            (setq passes (1+ passes)))
        (princ "[WARN]  Pupil exceeds limit: r^4 scaling increases blur halo.\n")
        (setq warnings (1+ warnings)))

      ;; Pupil diffraction limit lower bound
      (princ (format "\nDiffraction Blur Avoidance (d >= %.2f mm):\n" min-d))
      (if (>= pupil-diam min-d)
          (progn
            (princ (format "[PASS]  Above Airy disk diffraction limit (d >= %.2f mm).\n" min-d))
            (setq passes (1+ passes)))
        (princ "[FAIL]  Pupil constricted below diffraction limit.\n")
        (setq fails (1+ fails))))

    (princ (format "\n====================================================================\n"))
    (princ (format "Pupil Aberrations Summary: %d Passed, %d Failed, %d Warnings.\n\n"
                   passes fails warnings))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-pupil-aberrations-run)
    (kill-emacs 1)))

(provide 'test-pupil-aberrations)
;;; test-pupil-aberrations.el ends here
