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
;; Gate: a dense code block is modelled as a line grating whose bright
;; bars are text rows at a 35% duty cycle, with the panel floor added to
;; both bars and gaps.  Its Michelson contrast must stay at or under 0.90.
;; With dark text on a light canvas the duty cycle alone caps the grating
;; at d/(2-d) = 0.21, so the gate only binds on dark themes, where it
;; keeps the canvas from dropping to black under bright text.  The
;; per-token stripe contrasts are reported for reference only.
;;
;; Basis: grating contrast as the driver of pattern glare is Wilkins et
;; al. (1984).  The 0.90 ceiling and the syntax weights are au-themes
;; heuristics.
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
         (max-cm 0.90)
         (tokens '(("Base text"            :fg-main)
                   ("Comments"             :comment)
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
    (princ (format ">\tthe dense code line is gated at C_M <= %.2f over the physical panel\n" max-cm))
    (princ (format ">\tfloor (duty cycle: %.0f%%); per-token stripes are descriptive.\n" (* duty-cycle 100.0)))
    (princ (format "'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'\n"))

    (princ (format "\nDense Code Line Grating Contrast (C_M <= %.2f, Syntactic Weighting):\n" max-cm))
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
             (ok (<= cm max-cm)))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "Weighted Dense Code Line:\n\tLum=%.4f, Michelson C_M=%.4f (Floor=%.5f) -> %s\n"
                       line-y cm amb (if ok "PASS" "FAIL")))))

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
             (line-y (+ (* duty-cycle eff-fg) (* (- 1.0 duty-cycle) eff-bg))))
        (princ (format "| %-20s | %-7s | %7.4f | %8.4f | %6.4f | %s |\n"
                       label hex y-val line-y cm
                       (cond ((< cm 0.40) "Low grating")
                             ((< cm 0.75) "Moderate")
                             (t "High contrast"))))))
    (princ (format "+----------------------+---------+---------+----------+--------+---------------+\n"))

    (princ (format "\n================================================================================\n"))
    (princ (format "Cortical Pattern Glare Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-pattern-glare-cortical-run)
    (kill-emacs 1)))

(provide 'test-pattern-glare-cortical)
;;; test-pattern-glare-cortical.el ends here
