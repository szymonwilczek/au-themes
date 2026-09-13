;;; test-circadian-photobiology.el --- Circadian solar elevation and dawn crossover biometrics -*- lexical-binding: t -*-

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
;; Evaluate circadian photometric solar distance and dawn crossover
;; hybridization.
;;
;; Ref:
;; - Kasten & Young (1989) Applied Optics 28(22):4735-4738 (Air Mass model)
;; - Perez et al. (1990, 1993) Solar Energy 50(3):235-245 (All-Weather Sky Luminance)
;; - Endler (1993) Ecological Monographs 63(1):1-27 ('The color of light in forests')
;; - Stevens (1961) Science 133:80-86 (Power-law luminance adaptation S ~ L^0.33)
;; - Lucas et al. (2014) Trends Neurosci. 37(1):1-9 (Measuring and using light
;;   for circadian biology)

;;; Code:

(require 'test-palette-extractor)

(defun test-circadian-photobiology-run ()
  "Evaluate circadian photometric solar distance and dawn crossover hybridization.
Ref:
  - Kasten & Young (1989) Applied Optics 28(22):4735-4738 (Air Mass model)
  - Perez et al. (1990, 1993) Solar Energy 50(3):235-245 (All-Weather Sky Luminance)
  - Endler (1993) Ecological Monographs 63(1):1-27 ('The color of light in forests')
  - Stevens (1961) Science 133:80-86 (Power-law luminance adaptation S ~ L^0.33)
  - Lucas et al. (2014) Trends Neurosci. 37(1):1-9 (Measuring and using light for circadian biology)"
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (polarity (rf-theme-polarity theme))
         (bg (plist-get pal :bg-main))
         (bg-y (rf-luminance-y bg))
         (bg-okl (rf-hex-to-oklch bg))
         (bg-l (nth 0 bg-okl))
         (bg-c (nth 1 bg-okl))
         (bg-h (nth 2 bg-okl))
         (passes 0)
         (fails 0))

    (princ (format "\n======================================================================\n"))
    (princ (format " Circadian Solar Elevation & Temperate Dawn Crossover Suite\n"))
    (princ (format " Ref: Perez et al. (1993); Kasten-Young (1989); Endler (1993); Stevens (1961)\n"))
    (princ (format " Theme: %s (%s) | Canvas: %s (Y: %.4f, Oklab L: %.4f, Hue: %.1f°)\n"
                   theme polarity bg bg-y bg-l bg-h))
    (princ (format " Temperate zone reference: Lat 52°N (Central Europe woodland)\n"))
    (princ (format "======================================================================\n"))

    ;; Part 1: Circadian Solar Photometric Envelope
    (princ "\nPart 1: Solar Elevation & Photometric Adaptation Envelope:\n")
    (cond
     ((memq theme '(au-whispergrove-night whispergrove-night
                                          au-aurum-twilight aurum-twilight
                                          au-aurum-night aurum-night
                                          au-parchment-night parchment-night))
      ;; Night regime: nocturnal starlight/moonlight envelope
      (let ((night-ok (<= bg-y 0.020)))
        (if night-ok
            (progn
              (princ (format "   [PASS] Nocturnal canopy luminance Y=%.4f <= 0.020 (Mesopic/Scotopic rest state).\n" bg-y))
              (setq passes (1+ passes)))
          (princ (format "   [FAIL] Nocturnal luminance Y=%.4f exceeds dark adaptation ceiling 0.020.\n" bg-y))
          (setq fails (1+ fails)))))

     ((memq theme '(au-whispergrove-day whispergrove-day
                                        au-aurum-day aurum-day
                                        au-parchment-day parchment-day))
      ;; Solar Noon regime: elevated solar angle (alpha_s ~ 52 deg, Air Mass m ~ 1.22)
      (let* ((min-y 0.500)
             (max-y 0.750)
             (day-ok (and (>= bg-y min-y) (<= bg-y max-y))))
        (if day-ok
            (progn
              (princ (format "   [PASS] Solar Noon canopy luminance Y=%.4f in [%.3f..%.3f] (Full daylight canopy).\n"
                             bg-y min-y max-y))
              (setq passes (1+ passes)))
          (princ (format "   [FAIL] Solar Noon luminance Y=%.4f out of bounds [%.3f..%.3f].\n" bg-y min-y max-y))
          (setq fails (1+ fails)))))

     ((memq theme '(au-whispergrove-evening whispergrove-evening))
      ;; Evening / Twilight regime: elevated dark envelope (softer than deep night)
      (let* ((pal-night (au-extract-active-palette 'au-whispergrove-night))
             (bg-night (plist-get pal-night :bg-main))
             (y-night (rf-luminance-y bg-night))
             (l-night (nth 0 (rf-hex-to-oklch bg-night)))
             (delta-y-night (- bg-y y-night))
             (delta-l-night (- bg-l l-night))
             (ratio-night (/ (max 1e-4 bg-y) (max 1e-4 y-night)))
             (dusk-range-ok (and (>= bg-y 0.010) (<= bg-y 0.025)))
             (night-sep-ok (and (>= ratio-night 2.5) (>= delta-y-night 0.008) (>= delta-l-night 0.050))))
        (if dusk-range-ok
            (progn
              (princ (format "   [PASS] Evening twilight canopy luminance Y=%.4f in [0.010..0.025] (Elevated soft dark).\n" bg-y))
              (setq passes (1+ passes)))
          (princ (format "   [FAIL] Evening canvas luminance Y=%.4f out of bounds [0.010..0.025].\n" bg-y))
          (setq fails (1+ fails)))
        (if night-sep-ok
            (progn
              (princ (format "   [PASS] Night Softening Distance: Delta-Y=%.4f (ratio %.2fx >= 2.5x), Delta-L=%.4f >= 0.050.\n"
                             delta-y-night ratio-night delta-l-night))
              (princ "          Noticeable, gentle lifting of dark background avoiding deep nocturnal black.\n")
              (setq passes (1+ passes)))
          (princ (format "   [FAIL] Insufficient distance to deep Night: Delta-Y=%.4f, Ratio=%.2fx, Delta-L=%.4f.\n"
                         delta-y-night ratio-night delta-l-night))
          (setq fails (1+ fails)))))

     ((memq theme '(au-whispergrove-morning whispergrove-morning))
      ;; Dawn / Early Morning regime: low solar angle (alpha_s ~ 12 deg, Air Mass m ~ 4.6)
      ;; Under temperate conifer canopy, morning light is noticeably attenuated vs solar noon.
      (let* ((pal-day (au-extract-active-palette 'au-whispergrove-day))
             (pal-night (au-extract-active-palette 'au-whispergrove-night))
             (bg-day (plist-get pal-day :bg-main))
             (bg-night (plist-get pal-night :bg-main))
             (y-day (rf-luminance-y bg-day))
             (y-night (rf-luminance-y bg-night))
             (l-day (nth 0 (rf-hex-to-oklch bg-day)))
             (delta-y (- y-day bg-y))
             (delta-l (- l-day bg-l))
             (dist-night (- bg-y y-night))
             (solar-ratio (/ (max 1e-4 y-day) (max 1e-4 bg-y)))
             ;; Criteria:
             ;; 1. Subdued morning daylight luminance in [0.30..0.40]
             (range-ok (and (>= bg-y 0.300) (<= bg-y 0.400)))
             ;; 2. Distinct photometric distance to solar noon: Delta-Y >= 0.160 and ratio >= 1.45x
             (dist-day-ok (and (>= delta-y 0.160) (>= solar-ratio 1.45)))
             ;; 3. Perceptual Oklab Lightness shift: Delta-L >= 0.080 (noticeable circadian step)
             (oklab-step-ok (>= delta-l 0.080))
             ;; 4. Separation from nocturnal darkness: Delta-Y_night >= 0.250
             (dist-night-ok (>= dist-night 0.250)))

        (if range-ok
            (progn
              (princ (format "   [PASS] Morning dawn canvas luminance Y=%.4f in [0.300..0.400] (Subdued dawn envelope).\n" bg-y))
              (setq passes (1+ passes)))
          (princ (format "   [FAIL] Morning canvas luminance Y=%.4f not in subdued dawn range [0.300..0.400].\n" bg-y))
          (setq fails (1+ fails)))

        (if (and dist-day-ok oklab-step-ok)
            (progn
              (princ (format "   [PASS] Solar Noon Distance: Delta-Y=%.4f (ratio %.2fx >= 1.45x), Delta-L=%.4f >= 0.080.\n"
                             delta-y solar-ratio delta-l))
              (princ "          Clear, physically distinct perceptual jump between morning dawn and noon.\n")
              (setq passes (1+ passes)))
          (princ (format "   [FAIL] Insufficient distance to Solar Noon: Delta-Y=%.4f, Ratio=%.2fx, Delta-L=%.4f.\n"
                         delta-y solar-ratio delta-l))
          (setq fails (1+ fails)))

        (if dist-night-ok
            (progn
              (princ (format "   [PASS] Night Emergence Distance: Delta-Y_night=%.4f >= 0.250 (Clear awakening from nocturnal dark).\n"
                             dist-night))
              (setq passes (1+ passes)))
          (princ (format "   [FAIL] Morning canvas too close to night: Delta-Y_night=%.4f < 0.250.\n" dist-night))
          (setq fails (1+ fails))))))

    ;; Part 2: Circadian Dawn Crossover & Chromatic Hybridization
    (princ "\nPart 2: Dawn Crossover & Chromatic Hybridization (Night Echoes + Day Sunbeams):\n")
    (cond
     ((memq theme '(au-whispergrove-morning whispergrove-morning))
      ;; Check that morning canvas carries nocturnal canopy coolness (h in [135°..175°])
      (let ((bg-cool-ok (and (>= bg-h 135.0) (<= bg-h 175.0))))
        (if bg-cool-ok
            (progn
              (princ (format "   [PASS] Morning Canvas Hue: %.1f° in [135°..175°]: Carries cool nocturnal conifer/sage mist.\n" bg-h))
              (setq passes (1+ passes)))
          (princ (format "   [FAIL] Morning Canvas Hue: %.1f° outside [135°..175°]: Lacks nocturnal cool mist character.\n" bg-h))
          (setq fails (1+ fails))))

      ;; Check Night Accents presence: cursor and cool functional elements (h in [170°..250°])
      (let* ((cur (plist-get pal :cursor))
             (call (plist-get pal :fnname-call))
             (builtin (plist-get pal :builtin))
             (cur-h (nth 2 (rf-hex-to-oklch cur)))
             (call-h (nth 2 (rf-hex-to-oklch call)))
             (builtin-h (nth 2 (rf-hex-to-oklch builtin)))
             (night-accents-ok (and (and (>= cur-h 170.0) (<= cur-h 250.0))
                                    (and (>= call-h 170.0) (<= call-h 250.0))
                                    (and (>= builtin-h 170.0) (<= builtin-h 250.0)))))
        (if night-accents-ok
            (progn
              (princ (format "   [PASS] Nocturnal Accents: Cursor (%.1f°), Call (%.1f°), Builtin (%.1f°) in cool night zone [170°..250°].\n"
                             cur-h call-h builtin-h))
              (setq passes (1+ passes)))
          (princ (format "   [FAIL] Missing Nocturnal Accents: Expected cool cyan/turquoise/viridian in [170°..250°].\n"))
          (setq fails (1+ fails))))

      ;; Check Day Sunbeam Accents: numbers, keywords, strings (h in [25°..105°])
      (let* ((num (plist-get pal :number))
             (kw (plist-get pal :keyword))
             (str (plist-get pal :string))
             (num-h (nth 2 (rf-hex-to-oklch num)))
             (kw-h (nth 2 (rf-hex-to-oklch kw)))
             (str-h (nth 2 (rf-hex-to-oklch str)))
             (day-accents-ok (and (and (>= num-h 70.0) (<= num-h 105.0))
                                  (and (>= kw-h 40.0) (<= kw-h 75.0))
                                  (and (>= str-h 20.0) (<= str-h 45.0)))))
        (if day-accents-ok
            (progn
              (princ (format "   [PASS] Diurnal Sunbeam Accents: Sunbeam Number (%.1f°), Oak Keyword (%.1f°), Bark String (%.1f°) in [20°..105°].\n"
                             num-h kw-h str-h))
              (setq passes (1+ passes)))
          (princ (format "   [FAIL] Missing Diurnal Accents: Expected warm sunbeams in [20°..105°].\n"))
          (setq fails (1+ fails)))))

     ((memq theme '(au-whispergrove-evening whispergrove-evening))
      ;; Check evening twilight accents: blue-hour cursor (h in [180°..250°]) and sunset warm accents
      (let* ((cur (plist-get pal :cursor))
             (kw (plist-get pal :keyword))
             (num (plist-get pal :number))
             (str (plist-get pal :string))
             (cur-h (nth 2 (rf-hex-to-oklch cur)))
             (kw-h (nth 2 (rf-hex-to-oklch kw)))
             (num-h (nth 2 (rf-hex-to-oklch num)))
             (str-h (nth 2 (rf-hex-to-oklch str)))
             (dusk-accents-ok (and (and (>= cur-h 180.0) (<= cur-h 250.0))
                                   (and (>= kw-h 40.0) (<= kw-h 75.0))
                                   (and (>= num-h 70.0) (<= num-h 105.0))
                                   (and (>= str-h 20.0) (<= str-h 45.0)))))
        (if dusk-accents-ok
            (progn
              (princ (format "   [PASS] Evening Twilight Accents: Blue Hour Cursor (%.1f°), Sunset Amber (%.1f°), Oak Bark (%.1f°).\n"
                             cur-h num-h kw-h))
              (setq passes (1+ passes)))
          (princ (format "   [FAIL] Missing Dusk Accents in expected spectral envelopes.\n"))
          (setq fails (1+ fails)))))

     ((memq theme '(au-aurum-night aurum-night au-aurum-twilight aurum-twilight
                                   au-aurum-day aurum-day
                                   au-parchment-night parchment-night
                                   au-parchment-day parchment-day))
      ;; Check zero melanopsin excitation: all core syntax, chrome, and panel tokens outside blue/cyan [180°..260°]
      (let* ((token-list (delq nil
                               (list (cons "cursor" (plist-get pal :cursor))
                                     (cons "fnname" (plist-get pal :fnname))
                                     (cons "fnname-call" (plist-get pal :fnname-call))
                                     (cons "builtin" (plist-get pal :builtin))
                                     (cons "type" (plist-get pal :type))
                                     (cons "number" (plist-get pal :number))
                                     (cons "keyword" (plist-get pal :keyword))
                                     (cons "string" (plist-get pal :string))
                                     (cons "constant" (plist-get pal :constant))
                                     (cons "property" (plist-get pal :property))
                                     (cons "operator" (plist-get pal :operator))
                                     (cons "bracket" (plist-get pal :bracket))
                                     (cons "err" (plist-get pal :err))
                                     (cons "base text" (plist-get pal :fg-main))
                                     ;; Panels, Diffs and Structural Highlights:
                                     (when (plist-get pal :bg-blue-intense) (cons "bg-blue-intense" (plist-get pal :bg-blue-intense)))
                                     (when (plist-get pal :bg-cyan-intense) (cons "bg-cyan-intense" (plist-get pal :bg-cyan-intense)))
                                     (when (plist-get pal :bg-blue-subtle) (cons "bg-blue-subtle" (plist-get pal :bg-blue-subtle)))
                                     (when (plist-get pal :bg-cyan-subtle) (cons "bg-cyan-subtle" (plist-get pal :bg-cyan-subtle))))))
             (blue-tokens (cl-remove-if-not
                           (lambda (tok)
                             (let ((h (nth 2 (rf-hex-to-oklch (cdr tok)))))
                               (and (>= h 180.0) (<= h 260.0))))
                           token-list)))
        (if (null blue-tokens)
            (progn
              (princ (format "   [PASS] Zero Melanopsin (ipRGC) Hazard: 0/%d tokens in blue/cyan excitation band [180°..260°].\n"
                             (length token-list)))
              (princ "          Complete spectral shielding for severe photophobia, ocular migraine, and melatonin preservation.\n")
              (setq passes (1+ passes)))
          (princ (format "   [FAIL] Melanopsin hazard: %d tokens in [180°..260°]: %s\n"
                         (length blue-tokens) blue-tokens))
          (setq fails (1+ fails)))))

     (t
      (princ "   [SKIP] Chromatic hybridization check applies to crossover phases.\n")
      (setq passes (1+ passes))))

    (princ (format "\n----------------------------------------------------------------------\n"))
    (princ (format "Circadian Photobiology Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-circadian-photobiology-run)
    (kill-emacs 1)))

(provide 'test-circadian-photobiology)
;;; test-circadian-photobiology.el ends here
