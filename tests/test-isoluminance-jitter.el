;;; test-isoluminance-jitter.el --- Isoluminance Boundary Jitter in Contiguous Syntax -*- lexical-binding: t -*-

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
;; Evaluate isoluminance boundary jitter between contiguous or adjacent
;; syntax tokens.
;; While words in code are separated by whitespace, adjacent operators,
;; brackets, pointers, and identifiers (e.g. `*ptr`, `->field`, `fn(`) form
;; direct or closely packed boundaries.
;; When adjacent syntax colors share identical luminance (Delta-Y ~ 0),
;; the achromatic magnocellular edge detection system fails, producing chromatic
;; contour jitter and blur.
;; A non-zero separation deadband (Delta-Y >= 0.0050) maintains distinct contour
;; sharpness.
;;
;; Ref:
;; - Livingstone & Hubel (1987) J. Neurosci.
;; - Mullen (1985) J. Physiol.
;; - Gegenfurtner (2003)

;;; Code:

(require 'test-palette-extractor)

(defun test-isoluminance-jitter-run ()
  "Evaluate isoluminance boundary jitter between contiguous or adjacent syntax tokens.
While words in code are separated by whitespace, adjacent operators, brackets, pointers,
and identifiers (e.g. `*ptr`, `->field`, `fn(`) form direct or closely packed boundaries.
When adjacent syntax colors share identical luminance (Delta-Y ~ 0), the achromatic
magnocellular edge detection system fails, producing chromatic contour jitter and blur.
A non-zero separation deadband (Delta-Y >= 0.0050) maintains distinct contour sharpness.
Ref: Livingstone & Hubel (1987) J. Neurosci.; Mullen (1985) J. Physiol.; Gegenfurtner (2003)."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (polarity (rf-theme-polarity theme))
         (bg (plist-get pal :bg-main))
         (bg-y (rf-luminance-y bg))
         (passes 0)
         (fails 0)
         (touching-pairs
          '(("keyword (struct) vs type (int)"             :keyword     :type)
            ("keyword (static) vs builtin (__always)"     :keyword     :builtin)
            ("builtin vs fnname (def)"                    :builtin     :fnname)
            ("fnname (def) vs fnname-call (call)"         :fnname      :fnname-call)
            ("fnname vs type"                             :fnname      :type)
            ("keyword vs base text"                       :keyword     :fg-main)
            ("builtin vs base text"                       :builtin     :fg-main)
            ("type vs base text"                          :type        :fg-main)
            ("constant vs base text"                      :constant    :fg-main)
            ("number vs base text"                        :number      :fg-main)
            ("string vs base text"                        :string      :fg-main)
            ("operator vs property"                       :operator    :property)
            ("operator vs base text"                      :operator    :fg-main)
            ("operator vs number"                         :operator    :number)
            ("bracket vs base text"                       :bracket     :fg-main)
            ("bracket vs type"                            :bracket     :type)
            ("bracket vs keyword"                         :bracket     :keyword))))

    (princ (format "\n======================================================================\n"))
    (princ (format " Isoluminance Boundary Jitter & Contiguous Syntax Suite\n"))
    (princ (format " Ref: Livingstone & Hubel (1987); Mullen (1985); Gegenfurtner (2003)\n"))
    (princ (format " Theme: %s (%s) | Background: %s (Y_bg: %.6f)\n" theme polarity bg bg-y))
    (princ (format " Requirement: Contiguous syntax pairs maintain Delta-Y >= 0.0050\n"))
    (princ (format "======================================================================\n"))

    (princ (format "%-42s | %-8s | %-8s | %-8s | %-8s | %-8s | %-8s\n"
                   "Adjacent Syntax Pair" "Color 1" "Color 2" "Y 1" "Y 2" "Delta-Y" "Status"))
    (princ (format "-------------------------------------------+----------+----------+----------+----------+----------+----------\n"))
    (dolist (p touching-pairs)
      (let* ((label (nth 0 p))
             (k1    (nth 1 p))
             (k2    (nth 2 p))
             (h1    (plist-get pal k1))
             (h2    (plist-get pal k2))
             (y1    (rf-luminance-y h1))
             (y2    (rf-luminance-y h2))
             (dy    (abs (- y1 y2)))
             (min-dy 0.0050)
             (ok    (>= dy min-dy)))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "%-42s | %-8s | %-8s | %8.4f | %8.4f | %8.4f | %s\n"
                       label h1 h2 y1 y2 dy (if ok "PASS" "FAIL")))))
    (princ (format "-------------------------------------------+----------+----------+----------+----------+----------+----------\n"))

    (princ (format "Isoluminance Jitter Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-isoluminance-jitter-run)
    (kill-emacs 1)))

(provide 'test-isoluminance-jitter)
;;; test-isoluminance-jitter.el ends here
