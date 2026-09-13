;;; test-photophobia-glare.el --- Photophobia, Discomfort Glare and CIE S 026 Melanopic Irradiance -*- lexical-binding: t -*-

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
;; Evaluate clinical photophobia risk, CIE Discomfort Glare Index (DGI),
;; CIE S 026 melanopic irradiance, and photoreceptor saturation/bleaching
;; glare.
;;
;; Ref:
;; CIE Discomfort Glare Index; CIE S 026:2018; Noseda et al. (2010, 2017)
;; Nature Neurosci / Brain.

;;; Code:

(require 'test-palette-extractor)

(defun test-photophobia-glare-run ()
  "Evaluate clinical photophobia risk, CIE Discomfort Glare Index (DGI),
CIE S 026 melanopic irradiance, and photoreceptor saturation/bleaching glare.
Ref: CIE Discomfort Glare Index; CIE S 026:2018; Noseda et al. (2010, 2017) Nature Neurosci / Brain."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (polarity (rf-theme-polarity theme))
         (bg (plist-get pal :bg-main))
         (bg-y (rf-luminance-y bg))
         (passes 0)
         (fails 0)
         (tokens-to-test
          '(("Base text (Mineral quartz)"       :fg-main)
            ("Comments (Damp needles)"          :fg-dim)
            ("Cursor (Raindrop glint)"          :cursor)
            ("Preprocessor (#define)"           :preprocessor)
            ("Keywords (struct, while)"         :keyword)
            ("Data types (int, size_t)"         :type)
            ("Constants (LOTA_PCR_COUNT)"       :constant)
            ("Numbers (0, 24, 32)"              :number)
            ("Builtins (__always_inline)"       :builtin)
            ("Function definitions"             :fnname)
            ("Function calls (bpf_...)"         :fnname-call)
            ("Strings (\"string literals\")"    :string)
            ("Struct fields (->tgid)"           :property)
            ("Operators (+, -, *, >>)"          :operator)
            ("Brackets (( ) [ ] { })"           :bracket)
            ("Alerts / Errors (!)"              :err)))
         (tok-hexes (mapcar (lambda (item) (plist-get pal (cadr item))) tokens-to-test))
         ;; Standard buffer sample: 64 active tokens in viewport
         (buffer-tokens (append tok-hexes tok-hexes tok-hexes tok-hexes))
         (cumulative-dgi (rf-hopkinson-dgi buffer-tokens bg))
         (y-vals (mapcar #'rf-luminance-y tok-hexes))
         (y-max (apply #'max y-vals))
         (y-min (apply #'min y-vals)))

    (princ (format "\n======================================================================\n"))
    (princ (format " Clinical Photophobia, Discomfort Glare & CIE S 026 Irradiance Suite\n"))
    (princ (format " Ref: CIE S 026:2018; Hopkinson (1963, 1972) DGI; Brown et al. (2022) PLOS Biol\n"))
    (princ (format " Theme: %s (%s) | Background: %s (Y_bg: %.6f)\n" theme polarity bg bg-y))
    (princ (format "======================================================================\n"))

    ;; -------------------------------------------------------------------------
    ;; Part 1: Hopkinson / Cornell Discomfort Glare Index (DGI)
    ;; -------------------------------------------------------------------------
    (princ "\nPart 1: Hopkinson/Cornell Discomfort Glare Index (DGI) & Token Glare Hotspots:\n")
    (princ (format "%-30s | %-8s | %-8s | %-9s | %-9s | %-8s\n"
                   "Token Role" "Hex" "Lum (Y)" "Glare (G)" "Max G" "Status"))
    (princ (format "-------------------------------+----------+----------+-----------+-----------+----------\n"))
    (dolist (item tokens-to-test)
      (let* ((label (car item))
             (key   (cadr item))
             (hex   (plist-get pal key))
             (y-val (rf-luminance-y hex))
             (g-val (rf-hopkinson-glare-constant hex bg))
             (max-g (if (eq polarity 'light) 0.10 0.35))
             (ok    (<= g-val max-g)))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "%-30s | %-8s | %8.4f | %9.5f | <= %5.2f  | %s\n"
                       label hex y-val g-val max-g (if ok "PASS" "FAIL")))))
    (princ (format "-------------------------------+----------+----------+-----------+-----------+----------\n"))

    ;; Cumulative Buffer DGI Gate
    (let* ((max-dgi 16.0)
           (dgi-ok (<= cumulative-dgi max-dgi)))
      (if dgi-ok
          (setq passes (1+ passes))
        (setq fails (1+ fails)))
      (princ (format "Cumulative Buffer DGI: %.2f dB (Hopkinson Imperceptible Limit <= %.1f dB) -> %s\n"
                     cumulative-dgi max-dgi (if dgi-ok "PASS" "FAIL"))))

    ;; -------------------------------------------------------------------------
    ;; Part 2: CIE S 026 ipRGC Melanopic Irradiance & Corneal Mel-EDI (Brown 2022)
    ;; -------------------------------------------------------------------------
    (princ "\nPart 2: CIE S 026 ipRGC Melanopic Irradiance & Circadian Load:\n")
    (princ "Neuro-ocular protection: ipRGC excitation triggers retinal-thalamic migraine pathways.\n")
    (princ (format "%-30s | %-8s | %-9s | %-7s | %-11s | %-8s\n"
                   "Token Role" "Hex" "Melanopic" "M/P Rat" "Threshold" "Status"))
    (princ (format "-------------------------------+----------+-----------+---------+-------------+----------\n"))
    (dolist (item tokens-to-test)
      (let* ((label (car item))
             (key   (cadr item))
             (hex   (plist-get pal key))
             (m-val (rf-melanopic-irradiance hex))
             (mp    (or (rf-melanopic-photopic-ratio hex) 0.0))
             (max-m (if (eq polarity 'light)
                        0.25
                      (cond
                       ;; Warm / long-wavelength tokens: strictly subdued melanopic excitation
                       ((memq key '(:string :number :builtin :err :fg-dim :preprocessor)) 0.35)
                       ;; Short-wavelength tokens (constants, function calls, cursor): safe neuro threshold
                       (t 0.65))))
             (max-mp 2.00)
             (ok (and (<= m-val max-m) (<= mp max-mp))))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "%-30s | %-8s | %9.4f | %6.2fx  | M <= %5.2f   | %s\n"
                       label hex m-val mp max-m (if ok "PASS" "FAIL")))))
    (princ (format "-------------------------------+----------+-----------+---------+-------------+----------\n"))

    ;; Whole-viewport corneal melanopic EDI gate (Brown et al. 2022 PLOS Biol. 20(3): e3001571)
    ;; Display solid angle at 60cm: Omega ~= 0.482 sr. Evening indoor threshold: <= 10.0 lx.
    (let* ((solid-angle 0.482)
           (view-y (rf-viewport-mean-luminance-y pal))
           (corneal-mel-edi (* view-y rf-display-white-luminance solid-angle))
           (max-corneal (if (eq polarity 'dark) 10.0 50.0))
           (edi-ok (<= corneal-mel-edi max-corneal)))
      (if edi-ok
          (setq passes (1+ passes))
        (setq fails (1+ fails)))
      (princ (format "Corneal Melanopic EDI: %.2f lx (Brown et al. 2022 evening limit <= %.1f lx) -> %s\n"
                     corneal-mel-edi max-corneal (if edi-ok "PASS" "FAIL"))))

    ;; -------------------------------------------------------------------------
    ;; Part 3: Photoreceptor Bleaching & Scotopic/Mesopic Saturation Glare
    ;; -------------------------------------------------------------------------
    (princ "\nPart 3: Photoreceptor Bleaching & Scotopic/Mesopic Saturation Glare:\n")
    (if (eq polarity 'dark)
        (progn
          ;; Dark Gate 1: Rod Saturation & Scotopic Bleaching Avoidance
          (let ((rod-ok (and (<= bg-y 0.020) (>= bg-y 0.0010))))
            (if rod-ok
                (progn
                  (princ (format "   [PASS] Background Y_bg = %.6f <= 0.020: Rod photoreceptors protected from bleaching.\n" bg-y))
                  (setq passes (1+ passes)))
              (princ (format "   [FAIL] Background Y_bg = %.6f: Exceeds scotopic rhodopsin saturation threshold.\n" bg-y))
              (setq fails (1+ fails))))

          ;; Dark Gate 2: Saccadic Contrast Dynamic Range
          (let* ((cr (/ y-max (max 0.0001 bg-y)))
                 (cr-ok (<= cr 200.0)))
            (if cr-ok
                (progn
                  (princ (format "   [PASS] Peak Luminance Dynamic Range Y_max/Y_bg = %.2f <= 200.0: Prevents bleaching afterimages.\n" cr))
                  (setq passes (1+ passes)))
              (princ (format "   [FAIL] Dynamic Range Y_max/Y_bg = %.2f > 200.0: High risk of persistent afterimages.\n" cr))
              (setq fails (1+ fails)))))

      ;; Light Mode
      (progn
        ;; Light Gate 1: Daylight Canopy Cornea Comfort
        (let ((cornea-ok (and (<= bg-y 0.850) (>= bg-y 0.300))))
          (if cornea-ok
              (progn
                (princ (format "   [PASS] Background Y_bg = %.6f in [0.30..0.85]: Muted canopy daylight avoids corneal glare.\n" bg-y))
                (setq passes (1+ passes)))
            (princ (format "   [FAIL] Background Y_bg = %.6f outside [0.30..0.85]: Harsh blinding white or gloomy dark.\n" bg-y))
            (setq fails (1+ fails))))

        ;; Light Gate 2: Non-Saturating Daylight Dynamic Range
        (let* ((cr (/ bg-y (max 0.0001 y-min)))
               (cr-ok (<= cr 60.0)))
          (if cr-ok
              (progn
                (princ (format "   [PASS] Light Dynamic Range Y_bg/Y_min = %.2f <= 60.0: Optimal reading contrast without blinding glare.\n" cr))
                (setq passes (1+ passes)))
            (princ (format "   [FAIL] Dynamic Range Y_bg/Y_min = %.2f > 60.0: Extreme contrast saturation.\n" cr))
            (setq fails (1+ fails))))))

    (princ (format "\n----------------------------------------------------------------------\n"))
    (princ (format "Photophobia & Glare Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-photophobia-glare-run)
    (kill-emacs 1)))

(provide 'test-photophobia-glare)
;;; test-photophobia-glare.el ends here
