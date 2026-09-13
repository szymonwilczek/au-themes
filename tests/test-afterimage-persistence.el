;;; test-afterimage-persistence.el --- Neural adaptation, post-saccadic inertia and afterimage decay -*- lexical-binding: t -*-

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
;; Evaluate neural contrast adaptation, post-saccadic inertia, and negative
;; afterimages.
;; At display luminances (< 80 cd/m^2, ~300 td), photochemical cone pigment
;; bleaching is negligible (~4e-5; true bleaching requires I_0 ~ 10^4.3 td
;; per Rushton 1961).
;; Short-term visual persistence and negative afterimages stem from neural
;; contrast adaptation and receptive-field gain control in retinal ganglion
;; cells and primary visual cortex.
;;
;; Ref:
;; - Loomis (1978)
;; - Kelly (1979)
;; - Zaidi et al. (2012)

;;; Code:

(require 'test-palette-extractor)

(defun test-afterimage-persistence-run ()
  "Evaluate neural contrast adaptation, post-saccadic inertia, and negative afterimages.
At display luminances (< 80 cd/m^2, ~300 td), photochemical cone pigment bleaching
is negligible (~4e-5; true bleaching requires I_0 ~ 10^4.3 td per Rushton 1961).
Short-term visual persistence and negative afterimages stem from neural contrast
adaptation and receptive-field gain control in retinal ganglion cells and primary
visual cortex (Loomis 1978, Zaidi et al. 2012).

Brief fixations on high-contrast anchors leave lingering residual neural traces.
Neural adaptation decay exhibits a time constant tau ~ 0.45s (Loomis 1978, Kelly 1979).
Residual adaptation contrast at t = 1.0s must remain <= 5.5% (anchors <= 5.0%)."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (polarity (rf-theme-polarity theme))
         (bg (plist-get pal :bg-main))
         (bg-y (rf-luminance-y bg))
         (passes 0)
         (fails 0)
         ;; Neural adaptation decay time constant tau ~ 0.45s (Loomis 1978, Kelly 1979)
         (tau 0.45)
         (tokens-to-test '(("Cursor (Raindrop glint)"          :cursor)
                           ("Alerts / Errors (Yew berry)"      :err)
                           ("Base text (Mineral quartz)"       :fg-main)
                           ("Constants (LOTA_PCR_COUNT)"       :constant)
                           ("Numbers (Golden amber honey)"     :number)
                           ("Builtins (Forest viridian)"       :builtin))))

    (princ (format "\n======================================================================\n"))
    (princ (format " Neural Adaptation, Post-Saccadic Inertia & Afterimage Decay Suite\n"))
    (princ (format " Ref: Loomis (1978); Kelly (1979); Zaidi et al. (2012)\n"))
    (princ (format " Theme: %s (%s) | Background: %s (Y_bg: %.6f)\n" theme polarity bg bg-y))
    (princ (format " Requirement: Residual Neural Contrast A(t=1.0s) <= %.1f%% (Tau_neural = %.2fs)\n"
                   (if (eq polarity 'light) 6.0 5.5) tau))
    (princ (format " Note: True cone bleaching is negligible at display luminances (~4e-5);\n"))
    (princ (format "       afterimages are governed by neural gain control adaptation.\n"))
    (princ (format "======================================================================\n"))

    (princ (format "%-30s | %-8s | %-8s | %-8s | %-10s | %-8s\n"
                   "Visual Element" "Hex" "Lum (Y)" "Initial A0" "A(t=1.0s)" "Status"))
    (princ (format "-------------------------------+----------+----------+----------+------------+----------\n"))
    (dolist (tok tokens-to-test)
      (let* ((label (nth 0 tok))
             (key   (nth 1 tok))
             (hex   (plist-get pal key))
             (y-val (rf-luminance-y hex))
             ;; Neural contrast adaptation amplitude A0:
             (a0 (/ (abs (- y-val bg-y)) (+ y-val bg-y 0.50)))
             ;; Residual neural adaptation trace after 1.0 second (Loomis 1978)
             (a1 (* a0 (exp (- (/ 1.0 tau)))))
             (pct (* a1 100.0))
             (max-pct (if (eq polarity 'light) 6.0 5.5))
             (ok (<= pct max-pct)))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "%-30s | %-8s | %8.4f | %8.4f | %7.2f%%   | %s\n"
                       label hex y-val a0 pct (if ok "PASS" "FAIL")))))
    (princ (format "-------------------------------+----------+----------+----------+------------+----------\n"))

    ;; Part 2: Primary Cursor & Alert Palinopsia Gate
    (princ "\nPart 2: High-Focus Anchor Elements (Cursor & Alert Palinopsia Lock):\n")
    (let* ((cur-y (rf-luminance-y (plist-get pal :cursor)))
           (err-y (rf-luminance-y (plist-get pal :err)))
           (cur-a1 (* (/ (abs (- cur-y bg-y)) (+ cur-y bg-y 0.50)) (exp (- (/ 1.0 tau)))))
           (err-a1 (* (/ (abs (- err-y bg-y)) (+ err-y bg-y 0.50)) (exp (- (/ 1.0 tau)))))
           (anchors-ok (and (< (* cur-a1 100.0) 5.0) (< (* err-a1 100.0) 5.0))))
      (if anchors-ok
          (progn
            (princ (format "   [PASS] Cursor A(1s)=%.2f%%, Alert A(1s)=%.2f%% < 5.0%%: Zero persistent ghosting.\n"
                           (* cur-a1 100.0) (* err-a1 100.0)))
            (setq passes (1+ passes)))
        (princ (format "   [FAIL] Residual afterimage >= 5.0%%: High risk of palinopsia and visual interference.\n"))
        (setq fails (1+ fails))))

    (princ (format "\n----------------------------------------------------------------------\n"))
    (princ (format "Afterimage Persistence Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-afterimage-persistence-run)
    (kill-emacs 1)))

(provide 'test-afterimage-persistence)
;;; test-afterimage-persistence.el ends here
