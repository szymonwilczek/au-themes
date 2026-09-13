;;; test-crowding-effect-foveal.el --- Typographical Visual Crowding and Flanker Contrast Disparity -*- lexical-binding: t -*-

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
;; Evaluate typographical visual crowding and delimiter flanker contrast
;; disparity.
;; Visual crowding degrades letter and word recognition when flankers interfere
;; with targets.
;; Kooi et al. (1994) and Levi (2008) showed that disparity in luminance contrast
;; between target and flankers markedly reduces visual crowding.
;; In code reading, punctuation, brackets, and operators act as flankers adjacent
;; to identifiers;
;; subordinating delimiter contrast mitigates flanker interference and supports
;; local detail processing.
;;
;; Ref:
;; Kooi et al. (1994) Vision Res.
;; 34:269-276; Levi (2008) Vision Res. 48:635-654; Pelli et al. (2004);
;; Baldassi et al. (2009) Hum.  Brain Mapp.

;;; Code:

(require 'test-palette-extractor)

(defun test-crowding-effect-foveal-run ()
  "Evaluate typographical visual crowding and delimiter flanker contrast disparity.
Visual crowding degrades letter and word recognition when flankers interfere with targets.
Kooi et al. (1994) and Levi (2008) showed that disparity in luminance contrast between
target and flankers markedly reduces visual crowding. In code reading, punctuation, brackets,
and operators act as flankers adjacent to identifiers; subordinating delimiter contrast
mitigates flanker interference and supports local detail processing.
Ref: Kooi et al. (1994) Vision Res. 34:269-276; Levi (2008) Vision Res. 48:635-654;
     Pelli et al. (2004); Baldassi et al. (2009) Hum. Brain Mapp."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (polarity (rf-theme-polarity theme))
         (bg (plist-get pal :bg-main))
         (bg-y (rf-luminance-y bg))
         (passes 0)
         (fails 0)
         (delim-hex   (plist-get pal :delimiter))
         (bracket-hex (plist-get pal :bracket))
         (op-hex      (plist-get pal :operator))
         (core-fg-hex (plist-get pal :fg-main))
         (type-hex    (plist-get pal :type))
         (prop-hex    (plist-get pal :property)))

    (princ (format "\n======================================================================\n"))
    (princ (format " Typographical Visual Crowding & Flanker Contrast Disparity Suite\n"))
    (princ (format " Ref: Kooi et al. (1994); Levi (2008); Pelli et al. (2004)\n"))
    (princ (format " Theme: %s (%s) | Background: %s (Y_bg: %.6f)\n" theme polarity bg bg-y))
    (princ (format "======================================================================\n"))

    (if (eq polarity 'dark)
        (progn
          ;; Part 1: Delimiter Energy Subordination to Core Identifiers
          (princ "\nPart 1: Delimiter vs Core Identifiers Contrast Hierarchy:\n")
          (let* ((lc-delim (abs (rf-apca-contrast delim-hex bg)))
                 (lc-core  (abs (rf-apca-contrast core-fg-hex bg)))
                 (ratio-delim (/ lc-delim (max 1.0 lc-core)))
                 (ok (<= ratio-delim 0.75)))
            (if ok
                (progn
                  (princ (format "   [PASS] Delimiters (|Lc|=%.1f) vs Base Text (|Lc|=%.1f): Ratio = %.2f <= 0.75: Prevents glyph clumping.\n"
                                 lc-delim lc-core ratio-delim))
                  (setq passes (1+ passes)))
              (princ (format "   [FAIL] Delimiters (|Lc|=%.1f) compete equally with Base Text (|Lc|=%.1f): Ratio = %.2f > 0.75: Visual crowding.\n"
                             lc-delim lc-core ratio-delim))
              (setq fails (1+ fails))))

          ;; Part 2: Bracket Energy Subordination to Types & Properties
          (princ "\nPart 2: Brackets vs Types/Properties Hierarchy:\n")
          (let* ((lc-bracket (abs (rf-apca-contrast bracket-hex bg)))
                 (lc-type    (abs (rf-apca-contrast type-hex bg)))
                 (ratio-bracket (/ lc-bracket (max 1.0 lc-type)))
                 (ok (<= ratio-bracket 0.75)))
            (if ok
                (progn
                  (princ (format "   [PASS] Brackets (|Lc|=%.1f) vs Types (|Lc|=%.1f): Ratio = %.2f <= 0.75: Clean boundary demarcation.\n"
                                 lc-bracket lc-type ratio-bracket))
                  (setq passes (1+ passes)))
              (princ (format "   [FAIL] Brackets (|Lc|=%.1f) vs Types (|Lc|=%.1f): Ratio = %.2f > 0.75: Cluttered syntax integration.\n"
                             lc-bracket lc-type ratio-bracket))
              (setq fails (1+ fails))))

          ;; Part 3: Operator Energy Subordination
          (princ "\nPart 3: Operators vs Properties/Variables Hierarchy:\n")
          (let* ((lc-op   (abs (rf-apca-contrast op-hex bg)))
                 (lc-prop (abs (rf-apca-contrast prop-hex bg)))
                 (ratio-op (/ lc-op (max 1.0 lc-prop)))
                 (ok (<= ratio-op 0.85)))
            (if ok
                (progn
                  (princ (format "   [PASS] Operators (|Lc|=%.1f) vs Properties (|Lc|=%.1f): Ratio = %.2f <= 0.85: Identifiers pop forward.\n"
                                 lc-op lc-prop ratio-op))
                  (setq passes (1+ passes)))
              (princ (format "   [FAIL] Operators (|Lc|=%.1f) vs Properties (|Lc|=%.1f): Ratio = %.2f > 0.85: Overcrowded symbol noise.\n"
                             lc-op lc-prop ratio-op))
              (setq fails (1+ fails)))))

      ;; Daylight Mode baseline check
      (progn
        (princ "\nDaylight Mode Punctuation Acuity Baseline Check:\n")
        (let* ((lc-delim   (abs (rf-apca-contrast delim-hex bg)))
               (lc-bracket (abs (rf-apca-contrast bracket-hex bg)))
               (ok (and (>= lc-delim 40.0) (>= lc-bracket 40.0))))
          (if ok
              (progn
                (princ (format "   [PASS] Daylight Delimiters (|Lc|=%.1f) & Brackets (|Lc|=%.1f) maintain baseline acuity >= 40.0.\n"
                               lc-delim lc-bracket))
                (setq passes (1+ passes)))
            (princ "   [FAIL] Daylight delimiters lack basic legibility.\n")
            (setq fails (1+ fails))))))

    (princ (format "\n----------------------------------------------------------------------\n"))
    (princ (format "Foveal Visual Crowding Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-crowding-effect-foveal-run)
    (kill-emacs 1)))

(provide 'test-crowding-effect-foveal)
;;; test-crowding-effect-foveal.el ends here
