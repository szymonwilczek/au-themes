;;; test-pupil-spasm-adaptation.el --- Saccadic Foveal Adaptation and Palette Energy Variance -*- lexical-binding: t -*-

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
;; Evaluate saccadic foveal adaptation steps and palette luminance
;; homogeneity.
;;
;; Note:
;; Pupillary hippus (~0.2 Hz) is a spontaneous autonomic oscillation.
;; During reading, saccadic eye movements between syntax tokens produce
;; transient foveal luminance steps.
;; Bounding local adaptation deltas and overall palette luminance variance
;; (sigma^2) prevents excessive post-saccadic retinal adaptation transients
;; and asthenopia.
;;
;; Ref:
;; - Loewenfeld (1993) The Pupil
;; - Binda & Murray (2015) PNAS
;; - Mathôt (2018) JoV

;;; Code:

(require 'test-palette-extractor)

(defun test-pupil-spasm-adaptation-run ()
  "Evaluate saccadic foveal adaptation steps and palette luminance homogeneity."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (polarity (rf-theme-polarity theme))
         (bg (plist-get pal :bg-main))
         (bg-y (rf-luminance-y bg))
         (passes 0)
         (fails 0)
         (keys '(:fg-main :fg-dim :preprocessor :keyword :type :constant :number
                          :builtin :fnname :fnname-call :string :property :operator :bracket :err))
         (lums (mapcar (lambda (k) (rf-luminance-y (plist-get pal k))) keys))
         (n (length lums))
         (mean-y (/ (apply #'+ lums) (float n)))
         (variance (/ (apply #'+ (mapcar (lambda (y) (expt (- y mean-y) 2)) lums)) (float n)))
         (syntax-pairs
          '(("keyword vs type"       :keyword     :type)
            ("keyword vs builtin"    :keyword   :builtin)
            ("builtin vs fnname"     :builtin     :fnname)
            ("fnname vs fnname-call" :fnname      :fnname-call)
            ("type vs property"      :type        :property)
            ("base text vs keyword"  :fg-main     :keyword)
            ("base text vs type"     :fg-main     :type)
            ("base text vs builtin"  :fg-main     :builtin)
            ("base text vs number"   :fg-main     :number)
            ("base text vs string"   :fg-main     :string)
            ("base text vs comments" :fg-main     :fg-dim)
            ("base text vs operator" :fg-main     :operator)
            ("base text vs bracket"  :fg-main     :bracket))))

    (princ (format "\n.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.\n"))
    (princ (format "| Saccadic Foveal Adaptation & Palette Energy Variance Suite\n"))
    (princ (format "| Theme: %s (%s) | Background: %s (Y_bg: %.6f)\n" theme polarity bg bg-y))
    (princ (format "| Requirement:  Saccadic delta Delta-L < 0.0400,\n\t\tVariance sigma^2 <= 0.0250\n"))
    (princ (format "'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'\n"))

    (princ "\nSaccadic Foveal Adaptation Jumps (Delta-L < 0.0400):\n")
    (princ (format "+----------------------------+---------+---------+---------+--------+\n"))
    (princ (format "| %-26s | %-7s | %-7s | %-7s | %-7s|\n"
                   "Adjacent Syntax Transition" "Color 1" "Color 2" "Delta-L" "Status"))
    (princ (format "+----------------------------+---------+---------+---------+--------+\n"))
    (dolist (p syntax-pairs)
      (let* ((label (car p))
             (k1    (cadr p))
             (k2    (nth 2 p))
             (h1    (plist-get pal k1))
             (h2    (plist-get pal k2))
             (dl    (rf-saccadic-adaptation-delta h1 h2 0.15))
             (ok    (< dl 0.0400)))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "| %-26s | %-7s | %-7s | %7.4f |  %s  |\n"
                       label h1 h2 dl (if ok "PASS" "FAIL")))))
    (princ (format "+----------------------------+---------+---------+---------+--------+\n"))

    (princ "\nPalette Energy Variance (sigma^2 <= 0.0250):\n")
    (princ (format "---------------------------------------------------------------------\n"))

    (let ((var-ok (<= variance 0.0250)))
      (if var-ok
          (progn
            (princ (format "[PASS]  Mean Y = %.4f, Variance sigma^2 = %.6f <= 0.0250:\n\tCohesive energy distribution.\n"
                           mean-y variance))
            (setq passes (1+ passes)))
        (princ (format "[FAIL]  Variance sigma^2 = %.6f > 0.0250:\n\tExcessive luminance dispersion triggers hippus.\n"
                       variance))
        (setq fails (1+ fails))))

    (princ "\nPupillary Steady-State Deadband Check:\n")
    (princ (format "---------------------------------------------------------------------\n"))
    ;; Adapting field:
    ;; the viewport at the IEC 61966-2-1 reference white plus the reference
    ;; display veiling glare (0.2 cd/m2)
    (let* ((pupil-mm (rf-pupil-diameter
                      (+ (* (rf-viewport-mean-luminance-y pal) rf-display-white-luminance)
                         rf-reference-veiling-glare)))
           (deadband-ok (and (>= pupil-mm 2.0) (<= pupil-mm 7.5))))
      (if deadband-ok
          (progn
            (princ (format "[PASS]  Steady-state pupil diameter = %.2f mm in [2.0..7.5 mm]:\n\tStable iris posture.\n"
                           pupil-mm))
            (setq passes (1+ passes)))
        (princ (format "[FAIL]  Pupil diameter = %.2f mm outside physiological operating window.\n"
                       pupil-mm))
        (setq fails (1+ fails))))

    (princ (format "\n=====================================================================\n"))
    (princ (format "Pupil Spasm and Adaptation Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-pupil-spasm-adaptation-run)
    (kill-emacs 1)))

(provide 'test-pupil-spasm-adaptation)
;;; test-pupil-spasm-adaptation.el ends here
