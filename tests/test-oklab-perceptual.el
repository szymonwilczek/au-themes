;;; test-oklab-perceptual.el --- Oklab / Oklch perceptual uniformity and faded color diagnosis -*- lexical-binding: t -*-

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
;; Evaluate Oklch perceptual parameters [L C h] per Ottosson (2020).

;;; Code:

(require 'test-palette-extractor)

(defun test-oklab-perceptual-run ()
  "Evaluate Oklch perceptual parameters [L C h] per Ottosson (2020)."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (bg (plist-get pal :bg-main))
         (polarity (rf-theme-polarity theme))
         (bg-oklch (rf-hex-to-oklch bg))
         (passes 0)
         (warnings 0)
         (fails 0)
         (tokens
          (if (eq polarity 'light)
              '(("Base text (Conifer bark shadow)"  :fg-main      0.20 0.35 0.01 0.08)
                ("Comments (Misty lichen mulch)"    :fg-dim       0.40 0.55 0.01 0.08)
                ("Cursor (Mountain rain glint)"     :cursor       0.35 0.60 0.05 0.20)
                ("Preprocessor (#define)"           :preprocessor 0.30 0.50 0.04 0.20)
                ("Keywords (struct, while)"         :keyword      0.34 0.50 0.06 0.22)
                ("Data types (int, size_t)"         :type         0.35 0.50 0.06 0.22)
                ("Constants (LOTA_PCR_COUNT)"       :constant     0.30 0.50 0.06 0.22)
                ("Numbers (0, 24, 32)"              :number       0.34 0.50 0.05 0.22)
                ("Builtins (__always_inline)"       :builtin      0.30 0.50 0.04 0.20)
                ("Function definitions"             :fnname       0.34 0.50 0.04 0.20)
                ("Function calls (bpf_...)"         :fnname-call  0.34 0.50 0.05 0.20)
                ("Strings (\"string literals\")"    :string       0.30 0.50 0.05 0.20)
                ("Struct fields (->tgid)"           :property     0.30 0.50 0.03 0.16)
                ("Operators (+, -, *, >>)"          :operator     0.30 0.50 0.01 0.10)
                ("Brackets (( ) [ ] { })"           :bracket      0.30 0.50 0.01 0.10)
                ("Alerts / Errors (!)"              :err          0.35 0.55 0.08 0.25))
            '(("Base text (Mineral quartz)"       :fg-main      0.60 0.85 0.01 0.08)
              ("Comments (Damp needles)"          :fg-dim       0.30 0.55 0.01 0.08)
              ("Cursor (Raindrop glint)"          :cursor       0.50 0.75 0.06 0.20)
              ("Preprocessor (#define)"           :preprocessor 0.48 0.75 0.03 0.22)
              ("Keywords (struct, while)"         :keyword      0.40 0.65 0.08 0.25)
              ("Data types (int, size_t)"         :type         0.50 0.75 0.09 0.25)
              ("Constants (LOTA_PCR_COUNT)"       :constant     0.40 0.80 0.08 0.25)
              ("Numbers (0, 24, 32)"              :number       0.55 0.78 0.10 0.25)
              ("Builtins (__always_inline)"       :builtin      0.45 0.68 0.06 0.20)
              ("Function definitions"             :fnname       0.40 0.65 0.05 0.18)
              ("Function calls (bpf_...)"         :fnname-call  0.50 0.75 0.07 0.20)
              ("Strings (\"string literals\")"    :string       0.48 0.72 0.08 0.25)
              ("Struct fields (->tgid)"           :property     0.50 0.72 0.04 0.16)
              ("Operators (+, -, *, >>)"          :operator     0.42 0.65 0.01 0.08)
              ("Brackets (( ) [ ] { })"           :bracket      0.35 0.58 0.01 0.08)
              ("Alerts / Errors (!)"              :err          0.40 0.65 0.10 0.28)))))
    (princ (format "\n======================================================================\n"))
    (princ (format " Oklab / Oklch Perceptual Uniformity & Faded Color Diagnosis Suite\n"))
    (princ (format " Ref: Björn Ottosson (2020), A Perceptual Color Space for Computer Graphics\n"))
    (princ (format " Theme: %s (%s) | Background: %s (Oklab L: %.3f)\n" theme polarity bg (nth 0 bg-oklch)))
    (princ (format "======================================================================\n"))
    (princ (format "%-32s | %-8s | %-6s | %-6s | %-6s | %-6s | %-8s\n"
                   "Token Role" "Hex" "Oklab-L" "Chroma" "Hue(°)" "C/L" "Diagnosis"))
    (princ (format "---------------------------------+----------+--------+--------+--------+--------+----------\n"))
    (dolist (tok tokens)
      (let* ((name (nth 0 tok))
             (key  (nth 1 tok))
             (min-l (nth 2 tok))
             (max-l (nth 3 tok))
             (min-c (nth 4 tok))
             (max-c (nth 5 tok))
             (hex (plist-get pal key))
             (oklch (rf-hex-to-oklch hex))
             (l (nth 0 oklch))
             (c (nth 1 oklch))
             (h (nth 2 oklch))
             (c-over-l (if (> l 0.001) (/ c l) 0.0))
             (status "OPTIMAL"))

        ;; Diagnose if color is faded (too low chroma for its lightness)
        (cond
         ((< l min-l)
          (setq status "TOO DARK")
          (setq fails (1+ fails)))
         ((> l max-l)
          (setq status "TOO LIGHT")
          (setq fails (1+ fails)))
         ((< c min-c)
          (setq status "WASHED OUT")
          (setq warnings (1+ warnings)))
         ((> c max-c)
          (setq status "OVER-SAT")
          (setq warnings (1+ warnings)))
         (t
          (setq passes (1+ passes))))

        (princ (format "%-32s | %-8s | %6.3f | %6.3f | %5.1f° | %6.3f | %s\n"
                       name hex l c h c-over-l status))))
    (princ (format "---------------------------------+----------+--------+--------+--------+--------+----------\n"))
    (princ "Optical Diagnosis Insight for 'ssize_t / types':\n")
    (princ "To increase brightness WITHOUT washing out into gray haze:\n")
    (princ "Increase Oklch L while simultaneously increasing Chroma C proportionally.\n")
    (princ "Never increase L alone via sRGB addition (which dilutes purity with white).\n")
    (princ (format "----------------------------------------------------------------------\n"))
    (princ (format "Oklab Diagnosis Summary: %d Optimal, %d Warnings, %d Failed.\n\n"
                   passes warnings fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-oklab-perceptual-run)
    (kill-emacs 1)))

(provide 'test-oklab-perceptual)
;;; test-oklab-perceptual.el ends here
