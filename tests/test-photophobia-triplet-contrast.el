;;; test-photophobia-triplet-contrast.el --- Triplet Contrast Shock and Micro-Saccadic Flicker -*- lexical-binding: t -*-

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
;; Evaluate local luminance shock and micro-saccadic flicker in triplet
;; syntax sequences.
;; In photophobia, high contrast jumps between adjacent syntax tokens
;; (e.g. keyword -> bracket -> literal) cause retinal micro-flicker during
;; fixational eye movements and micro-saccades.
;;
;; Ref:
;; - Martinez-Conde et al. (2004) Nature Rev. Neurosci.
;; - APCA Guidelines (Somers 2022)

;;; Code:

(require 'test-palette-extractor)

(defun test-photophobia-triplet-contrast-run ()
  "Evaluate local luminance shock and micro-saccadic flicker in triplet syntax sequences."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (polarity (rf-theme-polarity theme))
         (bg (plist-get pal :bg-main))
         (bg-y (rf-luminance-y bg))
         (passes 0)
         (fails 0)
         (triplet-pairs
          '(("keyword vs type"       :keyword     :type)
            ("keyword vs builtin"    :keyword     :builtin)
            ("builtin vs fnname"     :builtin     :fnname)
            ("fnname vs fnname-call" :fnname      :fnname-call)
            ("fnname vs type"        :fnname      :type)
            ("fnname-call vs type"   :fnname-call :type)
            ("type vs property"      :type        :property)
            ("property vs operator"  :property    :operator)
            ("operator vs number"    :operator    :number)
            ("operator vs string"    :operator    :string)
            ("operator vs bracket"   :operator    :bracket)
            ("bracket vs delimiter"  :bracket     :delimiter)
            ("keyword vs bracket"    :keyword     :bracket)
            ("type vs bracket"       :type        :bracket)
            ("base text vs operator" :fg-main     :operator)
            ("base text vs bracket"  :fg-main     :bracket)
            ("base text vs property" :fg-main     :property)
            ("base text vs keyword"  :fg-main     :keyword)
            ("base text vs type"     :fg-main     :type)
            ("base text vs builtin"  :fg-main     :builtin))))

    (princ (format "\n.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.\n"))
    (princ (format " Photophobia Triplet Contrast and Micro-Saccadic Flicker Suite\n"))
    (princ (format " Theme: %s (%s) | Background: %s (Y_bg: %.6f)\n" theme polarity bg bg-y))
    (princ (format " Requirement: Adjacent token contrast delta Delta-Lc <= 22.5\n"))
    (princ (format "'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'\n\n"))
    (princ (format "+-----------------------+---------+---------+--------+--------+----------+--------+\n"))
    (princ (format "| %-21s | %-7s | %-7s | %-6s | %-6s | %-8s | %-7s|\n"
                   "Adjacent Syntax Pair" "Color 1" "Color 2" "|Lc 1|" "|Lc 2|" "Delta-Lc" "Status"))
    (princ (format "+-----------------------+---------+---------+--------+--------+----------+--------+\n"))
    (dolist (p triplet-pairs)
      (let* ((label (nth 0 p))
             (k1    (nth 1 p))
             (k2    (nth 2 p))
             (h1    (plist-get pal k1))
             (h2    (plist-get pal k2))
             (lc1   (abs (rf-apca-contrast h1 bg)))
             (lc2   (abs (rf-apca-contrast h2 bg)))
             (dlc   (abs (- lc1 lc2)))
             (ok    (<= dlc 22.5)))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "| %-21s | %-7s | %-7s | %6.1f | %6.1f | %8.2f |  %s  |\n"
                       label h1 h2 lc1 lc2 dlc (if ok "PASS" "FAIL")))))
    (princ (format "+-----------------------+---------+---------+--------+--------+----------+--------+\n"))
    (princ (format "\n===================================================================================\n"))
    (princ (format "Triplet Contrast Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-photophobia-triplet-contrast-run)
    (kill-emacs 1)))

(provide 'test-photophobia-triplet-contrast)
;;; test-photophobia-triplet-contrast.el ends here
