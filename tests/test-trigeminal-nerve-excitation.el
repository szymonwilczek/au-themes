;;; test-trigeminal-nerve-excitation.el --- Retino-Thalamic Trigeminovascular Photophobia -*- lexical-binding: t -*-

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
;; Evaluate retino-thalamic trigeminovascular photophobia exacerbation from
;; long-wavelength red.
;; Photophobia in migraine is mediated by retinal projections converging onto
;; dura-sensitive thalamic trigeminovascular neurons (Noseda et al. 2010, 2016).
;; Narrowband long-wavelength red and short-wavelength blue maximally exacerbate
;; headache pain, whereas green (~530 nm) shows minimal exacerbation.
;;
;; Ref:
;; Noseda et al. (2010) Nat. Neurosci. 13:239-245; Noseda et al. (2016) Brain
;; 139:1971-1986; Burstein et al. (2015) Nature Rev.  Neurosci.; Digre & Brennan
;; (2012).

;;; Code:

(require 'test-palette-extractor)

(defun test-trigeminal-nerve-excitation-run ()
  "Evaluate retino-thalamic trigeminovascular photophobia exacerbation from long-wavelength red.
Photophobia in migraine is mediated by retinal projections converging onto dura-sensitive
thalamic trigeminovascular neurons (Noseda et al. 2010, 2016). Narrowband long-wavelength red
and short-wavelength blue maximally exacerbate headache pain, whereas green (~530 nm) shows
minimal exacerbation.
Ref: Noseda et al. (2010) Nat. Neurosci. 13:239-245; Noseda et al. (2016) Brain 139:1971-1986;
     Burstein et al. (2015) Nature Rev. Neurosci.; Digre & Brennan (2012)."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (polarity (rf-theme-polarity theme))
         (bg (plist-get pal :bg-main))
         (passes 0)
         (fails 0)
         (warm-tokens '(("Alerts / Errors (Yew berry)"        :err)
                        ("Strings (Burnt oak)"                :string)
                        ("Builtins"                           :builtin)
                        ("Numbers (Golden amber honey)"       :number)
                        ("Preprocessor (#define)"             :preprocessor))))

    (princ (format "\n======================================================================\n"))
    (princ (format " Retino-Thalamic Trigeminovascular Red Photophobia Suite\n"))
    (princ (format " Ref: Noseda et al. (2010, 2016); Burstein (2015); Digre & Brennan (2012)\n"))
    (princ (format " Theme: %s (%s) | Background: %s\n" theme polarity bg))
    (princ (format " Requirements: Red Channel Frac <= 0.850, Muted Red Lum Y <= 0.250 (Dark mode)\n"))
    (princ (format "======================================================================\n"))

    (princ (format "%-32s | %-8s | %-8s | %-10s | %-8s | %-8s\n"
                   "Warm / Red Token" "Hex" "Lum (Y)" "Red Frac" "R/G Ratio" "Status"))
    (princ (format "---------------------------------+----------+----------+------------+----------+----------\n"))
    (dolist (tok warm-tokens)
      (let* ((label (car tok))
             (key   (cadr tok))
             (hex   (plist-get pal key))
             (rgb   (rf-hex-to-rgb hex))
             (r     (rf-srgb-to-linear (nth 0 rgb)))
             (g     (rf-srgb-to-linear (nth 1 rgb)))
             (b     (rf-srgb-to-linear (nth 2 rgb)))
             (y-val (rf-luminance-y hex))
             (purity (/ r (max 1e-4 (+ r g b))))
             (rg-ratio (/ r (max 1e-4 g)))
             (max-purity (if (eq polarity 'light) 0.880 0.850))
             (max-lum    (if (eq polarity 'light) 0.400 (if (eq key :number) 0.400 0.250)))
             (ok (and (<= purity max-purity)
                      (if (> purity 0.400) (<= y-val max-lum) t))))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "%-32s | %-8s | %8.4f | %10.4f | %8.2f | %s\n"
                       label hex y-val purity rg-ratio (if ok "PASS" "FAIL")))))
    (princ (format "---------------------------------+----------+----------+------------+----------+----------\n"))

    ;; Part 2: Monochromatic Laser Spike Absence Check
    (princ "\nPart 2: Monochromatic Laser-Red Absence Check (Green Grounding):\n")
    (let* ((err-hex (plist-get pal :err))
           (err-rgb (rf-hex-to-rgb err-hex))
           (err-g   (rf-srgb-to-linear (nth 1 err-rgb)))
           (err-b   (rf-srgb-to-linear (nth 2 err-rgb)))
           (grounding-ok (> (+ err-g err-b) 0.050)))
      (if grounding-ok
          (progn
            (princ (format "   [PASS] Alert token maintains green/blue grounding (G+B = %.4f > 0.050): Prevents pure laser red.\n"
                           (+ err-g err-b)))
            (setq passes (1+ passes)))
        (princ (format "   [FAIL] Alert token is pure monochromatic red (G+B = %.4f <= 0.050): Severe trigeminal migraine risk.\n"
                       (+ err-g err-b)))
        (setq fails (1+ fails))))

    (princ (format "\n----------------------------------------------------------------------\n"))
    (princ (format "Trigeminal Nerve Excitation Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-trigeminal-nerve-excitation-run)
    (kill-emacs 1)))

(provide 'test-trigeminal-nerve-excitation)
;;; test-trigeminal-nerve-excitation.el ends here
