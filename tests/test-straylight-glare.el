;;; test-straylight-glare.el --- Intraocular straylight and disability glare simulation -*- lexical-binding: t -*-

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
;; Evaluate intraocular forward straylight and disability glare.
;;
;; Ref:
;; Vos (2003) CIE Report on Disability Glare (CIE 146:2002).

;;; Code:

(require 'test-palette-extractor)

(defun test-straylight-glare-run ()
  "Evaluate intraocular forward straylight and disability glare."
  (let* ((pal (au-extract-active-palette))
         (bg (plist-get pal :bg-main))
         (fg (plist-get pal :fg-main))
         (theme (plist-get pal :theme))
         (polarity (rf-theme-polarity theme))
         (y-bg (rf-luminance-y bg))
         (y-fg (rf-luminance-y fg))
         ;; Physical display floor (black level + diffuse reflection)
         (floor-y (rf-display-physical-floor-y))
         ;; Retinal forward straylight veiling background
         (stray-y (* (rf-viewport-mean-luminance-y pal) (rf-straylight-integral)))
         (retinal-bg (+ y-bg floor-y stray-y))
         ;; Retinal Weber contrast: |Delta Y| / Y_retinal_bg
         (weber-contrast (/ (abs (- y-fg y-bg)) (max 1e-6 retinal-bg)))
         ;; Clinical ocular straylight parameter s at 10 deg
         ;; per Vos (2003) / CIE 146:2002
         (s-10 (* 100.0 (rf-glare-spread-function 10.0)))
         (log-s (log s-10 10))
         (passes 0)
         (fails 0)
         (warnings 0))
    (princ (format "\n.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.\n"))
    (princ (format "| Intraocular Straylight & Disability Glare Suite\n"))
    (princ (format "| Theme: %s (%s) | Background: %s\n" theme polarity bg))
    (princ (format "|~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|\n"))
    (princ (format "| Background Luminance (rel Y):  %.6f (Retinal Y_bg: %.6f)\n" y-bg retinal-bg))
    (princ (format "| Foreground Luminance (rel Y):  %.6f\n" y-fg))
    (princ (format "| Panel Physical Floor:          %.6f\n" floor-y))
    (princ (format "| Retinal Straylight Veiling:    %.6f\n" stray-y))
    (princ (format "| Retinal Weber Ratio (|C_W|):   %.2f\n" weber-contrast))
    (princ (format "| Ocular Straylight s(10 deg):   %.2f deg^2/sr [log(s) = %.2f]\n" s-10 log-s))
    (princ (format "'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'\n"))

    (if (eq polarity 'light)
        (progn
          (princ "\nPhotopic Glare Avoidance (Background Y_bg <= 0.8500):\n")
          (princ (format "------------------------------------------------------------------\n"))
          (if (<= y-bg 0.8500)
              (progn
                (princ "[PASS]  Background is soft canopy mist; avoids stark white corneal\n\tglare.\n")
                (setq passes (1+ passes)))
            (princ "[WARN]  Blinding bright background: risk of photophobia\n\tand pupillary strain.\n")
            (setq warnings (1+ warnings)))

          (princ "\nNon-Harsh Edge Contrast (|C_W| <= 0.98):\n")
          (princ (format "------------------------------------------------------------------\n"))
          (if (<= weber-contrast 0.98)
              (progn
                (princ "[PASS]  Contrast balanced; avoids harsh letter-edge glare\n\tand irradiation halo.\n")
                (setq passes (1+ passes)))
            (princ "[FAIL]  Harsh contrast divergence: text is too black against background.\n")
            (setq fails (1+ fails))))

      ;; Dark mode
      (princ "\nCharacter Edge Haloing (Weber C_W <= 60.0):\n")
      (princ (format "------------------------------------------------------------------\n"))
      (if (<= weber-contrast 60.0)
          (progn
            (princ "[PASS]  Weber contrast controlled; no intraocular halo glowing\n\tat letter edges.\n")
            (setq passes (1+ passes)))
        (princ "[WARN]  High Weber contrast: risk of disability glare on older eyes / astigmatism.\n")
        (setq warnings (1+ warnings)))

      (princ "\nAbsolute Black Hole Avoidance (Y_bg >= 0.0010):\n")
      (princ (format "------------------------------------------------------------------\n"))
      (if (>= y-bg 0.0010)
          (progn
            (princ "[PASS]  Background provides adequate luminance floor\n\tto prevent contrast divergence.\n")
            (setq passes (1+ passes)))
        (princ "[FAIL]  Background too dark (< 0.0010): creates infinite Weber contrast.\n")
        (setq fails (1+ fails))))

      (princ (format "\n==================================================================\n"))
    (princ (format "Straylight & Glare Summary: %d Passed, %d Failed, %d Warnings.\n\n"
                   passes fails warnings))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-straylight-glare-run)
    (kill-emacs 1)))

(provide 'test-straylight-glare)
;;; test-straylight-glare.el ends here
