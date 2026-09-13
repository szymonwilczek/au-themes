;;; test-spatial-frequency-csf.el --- Typographic spatial frequency contrast sensitivity thresholds (~6 cpd) -*- lexical-binding: t -*-

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
;; Evaluate typographical stroke contrast against spatial frequency
;; visibility thresholds (~6 cpd).
;;
;; Ref:
;; - Campbell & Robson (1968) J. Physiol.
;; - Legge et al. (1985) Psychophysics of Reading

;;; Code:

(require 'test-palette-extractor)

(defun test-spatial-frequency-csf-run ()
  "Evaluate typographical stroke contrast against spatial frequency visibility thresholds (~6 cpd).
Ref: Campbell & Robson (1968) J. Physiol.; Legge et al. (1985) Psychophysics of Reading."
  (let* ((pal (au-extract-active-palette))
         (bg (plist-get pal :bg-main))
         (theme (plist-get pal :theme))
         (passes 0)
         (fails 0)
         ;; At 60cm viewing distance and 13pt font, character stroke spatial frequency is ~6 cpd.
         ;; To maintain high reading speed and combat astigmatic optical degradation,
         ;; typography requires Michelson contrast substantially above threshold:
         ;; m >= 0.12 for subordinate comments, m >= 0.35 for primary code text.
         (tokens '(("Base text (Mineral quartz)"       :fg-main      0.35)
                   ("Comments (Damp needles)"          :fg-dim       0.12)
                   ("Cursor (Raindrop glint)"          :cursor       0.25)
                   ("Preprocessor (#define)"           :preprocessor 0.25)
                   ("Keywords (struct, while)"         :keyword      0.15)
                   ("Data types (int, size_t)"         :type         0.25)
                   ("Constants (LOTA_PCR_COUNT)"       :constant     0.15)
                   ("Numbers (0, 24, 32)"              :number       0.25)
                   ("Builtins (__always_inline)"       :builtin      0.15)
                   ("Function definitions"             :fnname       0.15)
                   ("Function calls (bpf_...)"         :fnname-call  0.25)
                   ("Strings (\"string literals\")"    :string       0.20)
                   ("Struct fields (->tgid)"           :property     0.20)
                   ("Operators (+, -, *, >>)"          :operator     0.15)
                   ("Brackets (( ) [ ] { })"           :bracket      0.12)
                   ("Alerts / Errors (!)"              :err          0.15))))
    (princ (format "\n======================================================================\n"))
    (princ (format " Typographic Spatial Frequency Contrast Sensitivity Suite (~6 cpd)\n"))
    (princ (format " Ref: Campbell & Robson (1968); Legge et al. (1985) Psychophysics of Reading\n"))
    (princ (format " Theme: %s | Background: %s\n" theme bg))
    (princ (format "======================================================================\n"))
    (princ (format "%-32s | %-8s | %-12s | %-12s | %-8s\n"
                   "Token Role" "Hex" "Michelson m" "Min Michelson" "Status"))
    (princ (format "---------------------------------+----------+--------------+--------------+----------\n"))
    (dolist (tok tokens)
      (let* ((name (nth 0 tok))
             (key  (nth 1 tok))
             (min-m (nth 2 tok))
             (hex (plist-get pal key))
             (y-txt (rf-luminance-y hex))
             (y-bg  (rf-luminance-y bg))
             ;; Michelson contrast: m = (L_max - L_min) / (L_max + L_min)
             (denom (+ (max y-txt y-bg) (min y-txt y-bg)))
             (m (if (< denom 1e-9) 0.0 (/ (- (max y-txt y-bg) (min y-txt y-bg)) denom)))
             (ok (>= m min-m)))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "%-32s | %-8s | %10.4f   | >= %6.4f    | %s\n"
                       name hex m min-m
                       (if ok "PASS" "FAIL")))))
    (princ (format "---------------------------------+----------+--------------+--------------+----------\n"))
    (princ (format "Spatial Frequency Typography Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-spatial-frequency-csf-run)
    (kill-emacs 1)))

(provide 'test-spatial-frequency-csf)
;;; test-spatial-frequency-csf.el ends here
