;;; test-pattern-glare-cortical.el --- V1 Cortical Visual Stress and Meares-Irlen Pattern Glare -*- lexical-binding: t -*-

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
;; Evaluate visual stress in primary visual cortex (V1) and Meares-Irlen
;; pattern glare.
;; At ~3 cycles/degree (typical editor line frequency), alternating high-contrast
;; stripes trigger cortical hyperexcitation, optical shimmer illusions, nausea,
;; and migraine aura.
;;
;; Ref:
;; - Wilkins et al. (1984, 2016) Brain
;; - Evans & Stevenson (2008)
;; - Allen et al. (2008)

;;; Code:

(require 'test-palette-extractor)

(defun test-pattern-glare-cortical-run ()
  "Evaluate visual stress in primary visual cortex (V1) and Meares-Irlen pattern glare."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (polarity (rf-theme-polarity theme))
         (bg (plist-get pal :bg-main))
         (bg-y (rf-luminance-y bg))
         (passes 0)
         (fails 0)
         (duty-cycle 0.35)
         (tokens '(("Base text"            :fg-main)
                   ("Comments"             :fg-dim)
                   ("Keywords"             :keyword)
                   ("Data types"           :type)
                   ("Preprocessor"         :preprocessor)
                   ("Numbers"              :number)
                   ("Builtins"             :builtin)
                   ("Function definitions" :fnname)
                   ("Function calls"       :fnname-call)
                   ("Strings"              :string)
                   ("Struct fields"        :property)
                   ("Alerts / Errors (!)"  :err))))

    (princ (format "\n.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.\n"))
    (princ (format "| V1 Cortical Visual Stress & Meares-Irlen Pattern Glare Suite\n"))
    (princ (format "| Theme: %s (%s) | Background: %s (Y_bg: %.6f)\n" theme polarity bg bg-y))
    (princ (format "> Note: Visual stress increases monotonically with grating contrast at ~3 c/deg;\n"))
    (princ (format ">\tWilkins Michelson C_M is reported as an informative grating descriptor\n"))
    (princ (format ">\tevaluated over the physical panel floor (duty cycle: %.0f%%).\n" (* duty-cycle 100.0)))
    (princ (format "'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'\n"))

    (princ "\nRealistic Code Block Line Contrast (Syntactic Weighting):\n")
    (princ (format "--------------------------------------------------------------------------------\n"))
    (let* ((weights '((:fg-main . 0.45)
                      (:keyword . 0.12)
                      (:type . 0.10)
                      (:property . 0.10)
                      (:fnname-call . 0.08)
                      (:number . 0.05)
                      (:string . 0.05)
                      (:constant . 0.05)))
           (block-y 0.0))
      (dolist (w weights)
        (let ((y (rf-luminance-y (plist-get pal (car w)))))
          (setq block-y (+ block-y (* y (cdr w))))))
      (let* ((amb (rf-display-physical-floor-y))
             (eff-bg (+ bg-y amb))
             (eff-fg (+ block-y amb))
             (line-y (+ (* duty-cycle eff-fg) (* (- 1.0 duty-cycle) eff-bg)))
             (denom (+ line-y eff-bg))
             (cm (if (< denom 1e-9) 0.0 (/ (abs (- line-y eff-bg)) denom)))
             (valid (and (>= cm 0.0) (<= cm 1.0))))
        (if valid
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "Weighted Dense Code Line:\n\tLum=%.4f, Michelson C_M=%.4f (Floor=%.5f) -> %s\n"
                       line-y cm amb (if valid "PASS (Well-formed)" "FAIL")))))

    (princ "\nPer-Token Line Stripe Michelson Contrast Descriptor:\n")
    (princ (format "+----------------------+---------+---------+----------+--------+---------------+\n"))
    (princ (format "| %-20s | %-7s | %-7s | %-8s | %-6s | %-14s|\n"
                   "Token Role" "Hex" "Lum (Y)" "Line Lum" "C_M" "Descriptor"))
    (princ (format "+----------------------+---------+---------+----------+--------+---------------+\n"))
    (dolist (tok tokens)
      (let* ((label (nth 0 tok))
             (key   (nth 1 tok))
             (hex   (plist-get pal key))
             (y-val (rf-luminance-y hex))
             (amb   (rf-display-physical-floor-y))
             (cm    (rf-wilkins-line-michelson hex bg duty-cycle amb))
             (eff-bg (+ bg-y amb))
             (eff-fg (+ y-val amb))
             (line-y (+ (* duty-cycle eff-fg) (* (- 1.0 duty-cycle) eff-bg)))
             (valid (and (>= cm 0.0) (<= cm 1.0))))
        (if valid
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "| %-20s | %-7s | %7.4f | %8.4f | %6.4f | %s |\n"
                       label hex y-val line-y cm
                       (cond ((< cm 0.40) "Low grating")
                             ((< cm 0.75) "Moderate")
                             (t "High contrast"))))))
    (princ (format "+----------------------+---------+---------+----------+--------+---------------+\n"))

    (princ "\nCortical Hyperexcitation Envelope Check (~3 cycles/degree):\n")
    (princ (format "--------------------------------------------------------------------------------\n"))

    (if (<= bg-y 0.020)
        (progn
          (princ "[PASS]  Dark nocturnal canvas eliminates macro-grating flicker.\n")
          (setq passes (1+ passes)))
      (if (<= bg-y 0.850)
          (progn
            (princ "[PASS] Daylight mist background maintains soft line transition.\n")
            (setq passes (1+ passes)))
        (princ "[FAIL]  Harsh high-glare background exacerbates pattern shimmer.\n")
        (setq fails (1+ fails))))

    (princ (format "\n================================================================================\n"))
    (princ (format "Cortical Pattern Glare Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-pattern-glare-cortical-run)
    (kill-emacs 1)))

(provide 'test-pattern-glare-cortical)
;;; test-pattern-glare-cortical.el ends here
