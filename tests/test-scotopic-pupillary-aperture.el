;;; test-scotopic-pupillary-aperture.el --- Stiles-Crawford Effect and Scopic Load Ratio -*- lexical-binding: t -*-

;; Copyright (C) 2026  Szymon Wilczek

;; Author: Szymon Wilczek <swilczek.lx@gmail.com>
;; Maintainer: Szymon Wilczek <swilczek.lx@gmail.com>
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
;; Evaluate Stiles-Crawford effect (SCE-I) and 80x40 viewport Scopic Load
;; Ratio.
;; In dark rooms with wide pupils (6.5-7.5mm), peripheral rays cause spherical
;; aberrations.
;; In ASD, prolonged pupillary latency impairs light constriction.
;; Viewport total energy must not cross the photopic activation threshold
;; (~10 cd/m2 on 100 cd/m2 displays).
;;
;; Ref:
;; - Stiles & Crawford (1933) Proc. R. Soc.
;; - Fan & Yao (2011) Autism Res.
;; - Westheimer (1967)

;;; Code:

(require 'test-palette-extractor)

(defun test-scotopic-pupillary-aperture-run ()
  "Evaluate Stiles-Crawford effect (SCE-I) and 80x40 viewport Scopic Load Ratio."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (polarity (rf-theme-polarity theme))
         (bg (plist-get pal :bg-main))
         (bg-y (rf-luminance-y bg))
         (hl-y (rf-luminance-y (plist-get pal :bg-hl-line)))
         (passes 0)
         (fails 0)
         ;; Standard 80x40 viewport with ~20% typographic ink coverage
         (mean-viewport-y (rf-viewport-mean-luminance-y pal))
         ;; Reference 80 cd/m2 white display calibration
         (mean-viewport-cd (* mean-viewport-y rf-display-white-luminance)))

    (princ "\n.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.\n")
    (princ (format "| Stiles-Crawford (SCE-I) and Viewport Scopic Load Ratio Suite\n"))
    (princ (format "| Theme: %s (%s)\n" theme polarity bg bg-y))
    (princ (format "| Background: %s (Y_bg: %.6f)\n" bg bg-y))
    (princ (format "| Model: 80x40 Viewport\n|\t (3200 cells, 20%% glyph ink fill, White: %.0f cd/m2)\n"
                   rf-display-white-luminance))
    (princ "'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'\n")

    (princ "\n80x40 Viewport Scopic Load & Photopic Threshold Check:\n")
    (princ "----------------------------------------------------------------\n")
    (if (eq polarity 'dark)
        (let* ((max-mesopic-cd 5.0) ; CIE 191:2010 mesopic/photopic transition threshold
               (max-mean-y (/ max-mesopic-cd rf-display-white-luminance))
               (ok (<= mean-viewport-cd max-mesopic-cd)))
          (if ok
              (progn
                (princ (format "[PASS]  Mean Viewport Lum = %.2f cd/m2 (Y=%.4f) <= %.1f cd/m2:\n\tSafely in soothing mesopic range.\n"
                               mean-viewport-cd mean-viewport-y max-mesopic-cd))
                (setq passes (1+ passes)))
            (princ (format "[FAIL]  Mean Viewport Lum = %.2f cd/m2 (Y=%.4f) > %.1f cd/m2:\n\tEnters photopic glare range in dark ambient.\n"
                           mean-viewport-cd mean-viewport-y max-mesopic-cd))
            (setq fails (1+ fails))))
      ;; Daylight mode
      (let* ((max-mean-y 0.750)
             (ok (<= mean-viewport-y max-mean-y)))
        (if ok
            (progn
              (princ (format "[PASS]  Daylight Viewport Lum = %.2f cd/m2 (Y=%.4f) <= %.3f:\n\t Soft canopy daylight.\n"
                             mean-viewport-cd mean-viewport-y max-mean-y))
              (setq passes (1+ passes)))
          (princ (format "[FAIL] Daylight Viewport Lum Y = %.4f > %.3f:\n\t Blinding daylight glare.\n"
                         mean-viewport-y max-mean-y))
          (setq fails (1+ fails)))))

    (princ "\nStiles-Crawford Directional Sensitivity (SCE-I) at Pupil Margin:\n")
    (princ "----------------------------------------------------------------\n")
    (let* ((pupil-diam (rf-pupil-diameter
                        (+ (* mean-viewport-y rf-display-white-luminance)
                           rf-reference-veiling-glare)))
           (pupil-radius (/ pupil-diam 2.0))
           ;; Stiles-Crawford directional sensitivity formula:
           ;; eta(r) = 10^(-rho * r_max^2) with rho ~ 0.05 mm^-2
           ;; and peak decentration x0 ~ 0.5 mm nasal
           (rho 0.05)
           (x0 0.50)
           (r-max (+ pupil-radius x0))
           (eta-margin (expt 10.0 (* (- rho) r-max r-max)))
           (ok (>= eta-margin 0.30)))
      (if ok
          (progn
            (princ (format "[PASS]  Pupil r = %.2f mm (r_max = %.2f mm with nasal offset),\n\tMarginal SCE-I eta = %.3f >= 0.300.\n"
                           pupil-radius r-max eta-margin))
            (setq passes (1+ passes)))
        (princ (format "[FAIL] Marginal SCE-I eta = %.3f < 0.300:\n\tHigh peripheral ray degradation.\n"
                       eta-margin))
        (setq fails (1+ fails))))

    (princ "\nUI Chrome Energy Balance (hl-line to background):\n")
    (princ "----------------------------------------------------------------\n")
    (let* ((hl-ratio (/ (max 0.0001 hl-y) (max 0.0001 bg-y)))
           (ok (if (eq polarity 'light) (<= hl-ratio 1.5) (<= hl-ratio 5.0))))
      (if ok
          (progn
            (princ (format "[PASS] hl-line / bg-main ratio = %.2f: Chrome is subtle.\n"
                           hl-ratio))
            (setq passes (1+ passes)))
        (princ (format "   [FAIL] hl-line / bg-main ratio = %.2f: Chrome creates excessive photonic spike.\n"
                       hl-ratio))
        (setq fails (1+ fails))))

    (princ "\n================================================================\n")
    (princ (format "Stiles-Crawford Scopic Load Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-scotopic-pupillary-aperture-run)
    (kill-emacs 1)))

(provide 'test-scotopic-pupillary-aperture)
;;; test-scotopic-pupillary-aperture.el ends here
