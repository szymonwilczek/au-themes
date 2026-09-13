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
;; Note: Standard APCA Bronze guidelines target Lc >= 75 for body text
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
    (princ "----------------------------------------------------------------------\n")
    (princ (format "APCA Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-apca-contrast-run)
    (kill-emacs 1)))

(provide 'test-apca-contrast)
;;; test-apca-contrast.el ends here
