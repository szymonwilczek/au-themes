;;; test-astigmatism-ciliary.el --- Ciliary accommodative micro-fluctuation and astigmatism biometrics -*- lexical-binding: t -*-

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
;; Evaluate ciliary muscle stability and astigmatism tolerance.
;;
;; Ref:
;; Charman & Heron (1988), DOI: 10.1111/j.1475-1313.1988.tb01090.x

;;; Code:

(require 'test-palette-extractor)

(defun test-astigmatism-ciliary-run ()
  "Evaluate ciliary muscle stability and astigmatism tolerance."
  (let* ((pal (au-extract-active-palette))
         (bg (plist-get pal :bg-main))
         (theme (plist-get pal :theme))
         (polarity (rf-theme-polarity theme))
         (fg (plist-get pal :fg-main))
         (dim (plist-get pal :fg-dim))
         (lc-fg (abs (rf-apca-contrast fg bg)))
         (lc-lcd (abs (rf-lcd-contrast fg bg)))
         (chroma-fg (rf-cielab-chroma fg))
         (max-ciliary-lc (if (eq polarity 'light) 85.0 58.0))
         (min-blur-lc (if (eq polarity 'light)
                          (if (< (rf-luminance-y bg) 0.420) 48.0 58.0)
                        46.0))
         (min-dim-lc (if (eq polarity 'light)
                         (if (< (rf-luminance-y bg) 0.420) 30.0 35.0)
                       10.0))
         (max-dim-lc (if (eq polarity 'light)
                         60.0
                       (if (> (rf-luminance-y bg) 0.010) 28.0 24.0)))
         (passes 0)
         (fails 0)
         (warnings 0))
    (princ (format "\n.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.\n"))
    (princ (format "| Astigmatism & Ciliary Micro-fluctuation Biometrics Suite\n"))
    (princ (format "| Theme: %s (%s) | Background: %s\n" theme polarity bg))
    (princ (format "'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'\n"))

    (princ (format "\nAccommodative Stability Threshold (|Lc| >= %.1f):\n" min-blur-lc))
    (princ (format "---------------------------------------------------------------------------\n"))
    (princ (format "Measured LCD |Lc|: %.2f on background %s\n" lc-lcd bg))
    (if (>= lc-lcd min-blur-lc)
        (progn
          (princ "[PASS]  Sufficient edge gradient to suppress ciliary hunting\n\tand maintain focus.\n")
          (setq passes (1+ passes)))
      (princ " [FAIL]  Insufficient contrast: triggers accommodative hunting\n\tand ocular strain.\n")
      (setq fails (1+ fails)))

    ;; Note:
    ;; In literature (Charman & Heron 1988, Gray et al. 1993), hunting does
    ;; NOT increase with high contrast. An upper bound serves to prevent
    ;; high-luminance edge irradiation in photophobic / migraine states.
    (princ (format "\nPhotophobic Edge Irradiation Ceiling (|Lc| <= %.1f):\n" max-ciliary-lc))
    (princ (format "---------------------------------------------------------------------------\n"))
    (princ (format "Measured |Lc|: %.2f\n" lc-fg))
    (if (<= lc-fg max-ciliary-lc)
        (progn
          (princ "[PASS]  Within photophobic comfort window; excessive irradiation spreading\n\tavoided.\n")
          (setq passes (1+ passes)))
      (princ "[WARN] High contrast: risk of glare irradiation in photophobia.\n")
      (setq warnings (1+ warnings)))

    (princ "\nBase Text Subpixel Fringing (C* <= 12.0):\n")
    (princ (format "---------------------------------------------------------------------------\n"))
    (princ (format "Measured Chroma C*: %.2f\n" chroma-fg))
    (if (<= chroma-fg 12.0)
        (progn
          (princ "[PASS] Achromatic balance preserved; no LCD subpixel color bleeding.\n")
          (setq passes (1+ passes)))
      (princ "[WARN] Elevated chroma on body text: risk of chromatic fringing.\n")
      (setq warnings (1+ warnings)))

    (let ((lc-dim (abs (rf-apca-contrast dim bg))))
      (princ (format "\nComment Layer Subordination (|Lc| in [%.1f..%.1f]):\n" min-dim-lc max-dim-lc))
      (princ (format "---------------------------------------------------------------------------\n"))
      (princ (format "Measured Comments |Lc|: %.2f\n" lc-dim))
      (if (and (>= lc-dim min-dim-lc) (<= lc-dim max-dim-lc))
          (progn
            (princ "[PASS] Comments recede into background, preventing attention disruption.\n")
            (setq passes (1+ passes)))
        (princ "[FAIL] Comments outside optimal range.\n")
        (setq fails (1+ fails))))

    (princ (format "\n===========================================================================\n"))
    (princ (format "Astigmatism Biometrics Summary: %d Passed, %d Failed, %d Warnings.\n\n"
                   passes fails warnings))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-astigmatism-ciliary-run)
    (kill-emacs 1)))

(provide 'test-astigmatism-ciliary)
;;; test-astigmatism-ciliary.el ends here
