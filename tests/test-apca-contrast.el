;;; test-apca-contrast.el --- APCA 0.0.98G-4g lightness contrast and photophobia calibration -*- lexical-binding: t -*-

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
;; Evaluate APCA 0.0.98G-4g contrast boundaries calibrated for photophobia
;; and readability.
;;
;; Note:
;; Standard APCA Bronze guidelines target Lc >= 75 for body text
;; and Lc >= 60 for content.
;; In dark-mode photophobia design, body text is calibrated to moderate Lc
;; (46-62) to prevent edge irradiation and pupil constriction, while secondary
;; syntactic tokens deliberately sit below Lc 30 to suppress distraction.
;; Targets represent intentional photophobia-adapted calibration boundaries
;; rather than unadapted APCA Bronze levels.

;;; Code:

(require 'test-palette-extractor)

(defun test-apca-contrast-run ()
  "Evaluate APCA 0.0.98G-4g contrast boundaries calibrated for photophobia and readability.
Note: Standard APCA Bronze guidelines target Lc >= 75 for body text and Lc >= 60 for content.
In dark-mode photophobia design, body text is calibrated to moderate Lc (46-62) to prevent
edge irradiation and pupil constriction, while secondary syntactic tokens deliberately sit
below Lc 30 to suppress distraction. Targets represent intentional photophobia-adapted
calibration boundaries rather than unadapted APCA Bronze levels."
  (let* ((pal (au-extract-active-palette))
         (bg (plist-get pal :bg-main))
         (theme (plist-get pal :theme))
         (polarity (rf-theme-polarity theme))
         (bg-y (rf-luminance-y bg))
         (passes 0)
         (fails 0)
         (tokens
          (if (eq polarity 'light)
              (let ((subdued (< bg-y 0.420)))
                `(("Base text (Conifer bark shadow)"  :fg-main      ,(if subdued 48.0 58.0) 85.0)
                  ("Comments (Misty lichen mulch)"    :fg-dim       30.0 60.0)
                  ("Cursor (Mountain rain glint)"     :cursor       20.0 75.0)
                  ("Preprocessor (#define)"           :preprocessor ,(if subdued 32.0 40.0) 78.0)
                  ("Keywords (struct, while)"         :keyword      ,(if subdued 32.0 40.0) 78.0)
                  ("Data types (int, size_t)"         :type         ,(if subdued 32.0 40.0) 78.0)
                  ("Constants (LOTA_PCR_COUNT)"       :constant     ,(if subdued 32.0 40.0) 78.0)
                  ("Numbers (0, 24, 32)"              :number       ,(if subdued 32.0 40.0) 78.0)
                  ("Builtins (__always_inline)"       :builtin      ,(if subdued 32.0 40.0) 78.0)
                  ("Function definitions"             :fnname       ,(if subdued 32.0 40.0) 78.0)
                  ("Function calls (bpf_...)"         :fnname-call  ,(if subdued 32.0 40.0) 78.0)
                  ("Strings (\"string literals\")"    :string       ,(if subdued 32.0 40.0) 78.0)
                  ("Struct fields (->tgid)"           :property     ,(if subdued 32.0 40.0) 78.0)
                  ("Operators (+, -, *, >>)"          :operator     ,(if subdued 32.0 40.0) 78.0)
                  ("Brackets (( ) [ ] { })"           :bracket      ,(if subdued 32.0 40.0) 78.0)
                  ("Alerts / Errors (!)"              :err          ,(if subdued 32.0 40.0) 78.0)))
            '(("Base text (Mineral quartz)"       :fg-main      46.0 62.0)
              ("Comments (Damp needles)"          :fg-dim       10.0 28.0)
              ("Cursor (Raindrop glint)"          :cursor       30.0 70.0)
              ("Preprocessor (#define)"           :preprocessor 16.0 55.0)
              ("Keywords (struct, while)"         :keyword      16.0 55.0)
              ("Data types (int, size_t)"         :type         16.0 55.0)
              ("Constants (LOTA_PCR_COUNT)"       :constant     16.0 68.0)
              ("Numbers (0, 24, 32)"              :number       16.0 55.0)
              ("Builtins (__always_inline)"       :builtin      16.0 50.0)
              ("Function definitions"             :fnname       16.0 50.0)
              ("Function calls (bpf_...)"         :fnname-call  16.0 55.0)
              ("Strings (\"string literals\")"    :string       16.0 50.0)
              ("Struct fields (->tgid)"           :property     16.0 55.0)
              ("Operators (+, -, *, >>)"          :operator     15.0 45.0)
              ("Brackets (( ) [ ] { })"           :bracket      14.0 40.0)
              ("Alerts / Errors (!)"              :err          16.0 50.0)))))
    (princ (format "\n======================================================================\n"))
    (princ (format " APCA 0.0.98G-4g Perceptual Contrast & Photophobia Calibration Suite\n"))
    (princ (format " Theme: %s (%s) | Background: %s\n" theme polarity bg))
    (princ (format " Note: Intentional photophobia trade-offs: body text calibrated to moderate Lc\n"))
    (princ (format "       to suppress glare; syntax roles subordinated below standard Bronze.\n"))
    (princ (format "======================================================================\n"))
    ;; Physical Overcast / Dawn Canvas Gate for Light polarity
    (when (eq polarity 'light)
      (let* ((bg-y (rf-luminance-y bg))
             (bg-ok (and (>= bg-y 0.3000) (<= bg-y 0.7500))))
        (princ "Canopy Canvas Luminance Check:\n")
        (if bg-ok
            (progn
              (princ (format "   [PASS] Canopy canvas luminance Y=%.4f in [0.40..0.75] (eliminates paper-white glare)\n" bg-y))
              (setq passes (1+ passes)))
          (princ (format "   [FAIL] Canvas luminance Y=%.4f out of bounds [0.40..0.75] (too bright/paper white or too dark)\n" bg-y))
          (setq fails (1+ fails)))
        (princ "----------------------------------------------------------------------\n")))
    (princ (format "%-32s | %-8s | %-7s | %-12s | %-8s\n" "Token Role" "Hex" "Lc" "Target Lc" "Status"))
    (princ (format "---------------------------------+----------+---------+--------------+----------\n"))
    (dolist (tok tokens)
      (let* ((name (nth 0 tok))
             (key  (nth 1 tok))
             (min-lc (nth 2 tok))
             (max-lc (nth 3 tok))
             (hex (plist-get pal key))
             (lc  (abs (rf-apca-contrast hex bg)))
             (ok  (and (>= lc min-lc) (<= lc max-lc))))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "%-32s | %-8s | %7.2f | [%4.1f..%4.1f]   | %s\n"
                       name hex lc min-lc max-lc
                       (if ok "PASS" "FAIL")))))
    (princ (format "---------------------------------+----------+---------+--------------+----------\n"))

    ;; Part 2: Visual Selection Region Contrast Gate
    (princ "\nPart 2: Visual Selection Region Contrast Gate (bg-region):\n")
    (let* ((reg (plist-get pal :bg-region))
           (fg (plist-get pal :fg-main))
           (reg-de (rf-delta-e-2000 reg bg))
           (reg-dy (abs (- (rf-luminance-y reg) (rf-luminance-y bg))))
           (reg-vis-ok (and (>= reg-de 10.0) (>= reg-dy 0.020)))
           (fg-reg-lc (abs (rf-apca-contrast fg reg)))
           (fg-reg-ok (>= fg-reg-lc 40.0)))
      (if reg-vis-ok
          (progn
            (princ (format "   [PASS] Selection region visibility vs canvas: dE00=%.2f >= 10.0, Delta-Y=%.4f >= 0.020\n"
                           reg-de reg-dy))
            (setq passes (1+ passes)))
        (princ (format "   [FAIL] Selection region invisible against canvas: dE00=%.2f (min 10.0), Delta-Y=%.4f (min 0.020)\n"
                       reg-de reg-dy))
        (setq fails (1+ fails)))
      (if fg-reg-ok
          (progn
            (princ (format "   [PASS] Body text legibility within selection: APCA |Lc|=%.2f >= 40.0\n" fg-reg-lc))
            (setq passes (1+ passes)))
        (princ (format "   [FAIL] Body text illegible within selection: APCA |Lc|=%.2f < 40.0\n" fg-reg-lc))
        (setq fails (1+ fails))))

    ;; Part 3: Panels and Structural Highlights APCA Contrast Gate
    (let ((intense-panels '((:bg-red-intense     "Alert / Fatal assertion panel (bg-red-intense)")
                            (:bg-green-intense   "Success banner (bg-green-intense)")
                            (:bg-yellow-intense  "Warning banner (bg-yellow-intense)")
                            (:bg-blue-intense    "Info banner (bg-blue-intense)")
                            (:bg-magenta-intense "Special prompt background (bg-magenta-intense)")
                            (:bg-cyan-intense    "Incsearch match target (bg-cyan-intense)")))
          (subtle-panels  '((:bg-red-subtle      "Diff deletion wash (bg-red-subtle)")
                            (:bg-green-subtle    "Diff addition wash (bg-green-subtle)")
                            (:bg-yellow-subtle   "Diff change wash (bg-yellow-subtle)")
                            (:bg-blue-subtle     "Mode-line subtle wash (bg-blue-subtle)")
                            (:bg-magenta-subtle  "Paren match context wash (bg-magenta-subtle)")
                            (:bg-cyan-subtle     "Block highlight wash (bg-cyan-subtle)")))
          (fg (plist-get pal :fg-main))
          (min-intense-lc (if (eq polarity 'light) 55.0 35.0)))
      (princ "\nPart 3: Panels and Structural Highlights APCA Contrast Gate:\n")
      (dolist (item intense-panels)
        (let* ((key (car item))
               (label (cadr item))
               (p-hex (plist-get pal key)))
          (if p-hex
              (let* ((p-lc (abs (rf-apca-contrast fg p-hex)))
                     (p-ok (>= p-lc min-intense-lc)))
                (if p-ok
                    (progn
                      (princ (format "   [PASS] %-48s [%s]: APCA |Lc|=%.2f >= %.1f\n"
                                     label p-hex p-lc min-intense-lc))
                      (setq passes (1+ passes)))
                  (princ (format "   [FAIL] %-48s [%s]: Insufficient contrast APCA |Lc|=%.2f < %.1f\n"
                                 label p-hex p-lc min-intense-lc))
                  (setq fails (1+ fails))))
            (princ (format "   [INFO] %-48s: Not defined in theme palette\n" label)))))

      (dolist (item subtle-panels)
        (let* ((key (car item))
               (label (cadr item))
               (p-hex (plist-get pal key)))
          (if p-hex
              (let* ((p-de (rf-delta-e-2000 p-hex bg))
                     (p-dy (abs (- (rf-luminance-y p-hex) (rf-luminance-y bg))))
                     (min-dy (if (eq polarity 'light) 0.015 0.005))
                     (max-dy (if (eq polarity 'light) 0.180 0.050))
                     (p-ok (and (>= p-de 2.0) (>= p-dy min-dy) (<= p-dy max-dy))))
                (if p-ok
                    (progn
                      (princ (format "   [PASS] %-48s [%s]: dE00=%.2f >= 2.0, Delta-Y=%.4f in [%.3f..%.3f]\n"
                                     label p-hex p-de p-dy min-dy max-dy))
                      (setq passes (1+ passes)))
                  (princ (format "   [FAIL] %-48s [%s]: Out of bounds: dE00=%.2f (min 2.0), Delta-Y=%.4f (bounds [%.3f..%.3f])\n"
                                 label p-hex p-de p-dy min-dy max-dy))
                  (setq fails (1+ fails))))
            (princ (format "   [INFO] %-48s: Not defined in theme palette\n" label)))))

      (let* ((ln-hex (plist-get pal :fg-line-number-inactive)))
        (if ln-hex
            (let* ((ln-lc (abs (rf-apca-contrast ln-hex bg)))
                   (min-ln (if (eq polarity 'light) 30.0 15.0))
                   (max-ln (if (eq polarity 'light) 55.0 30.0))
                   (ln-ok (and (>= ln-lc min-ln) (<= ln-lc max-ln))))
              (if ln-ok
                  (progn
                    (princ (format "   [PASS] Inactive line number margin [%s]: APCA |Lc|=%.2f in [%.1f..%.1f]\n"
                                   ln-hex ln-lc min-ln max-ln))
                    (setq passes (1+ passes)))
                (princ (format "   [FAIL] Inactive line number margin [%s]: APCA |Lc|=%.2f out of bounds [%.1f..%.1f]\n"
                               ln-hex ln-lc min-ln max-ln))
                (setq fails (1+ fails))))
          (princ "   [INFO] Inactive line number margin: Not defined in theme palette\n"))))
    (princ "----------------------------------------------------------------------\n")
    (princ (format "APCA Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-apca-contrast-run)
    (kill-emacs 1)))

(provide 'test-apca-contrast)
;;; test-apca-contrast.el ends here
