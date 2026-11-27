;;; test-hover-highlight.el --- Mouse hover stands apart from selection and surfaces -*- lexical-binding: t -*-

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
;; Evaluate how clearly the mouse hover stands out.  Through
;; modus-themes, `highlight' draws `bg-hover' under the mouse: it is the
;; mouse face of candidates in *Completions*, Vertico (vertico-mouse)
;; and many other buffers, and `company-tooltip-mouse' uses it inside
;; the Company popup.  A hovered candidate must not look like the
;; selected one, and the hover must show on the surfaces it is drawn
;; on.
;;
;; The module asks for `bg-hover' at least 4.0 dE00 from
;; `bg-completion' (the selected candidate), from `bg-popup' and from
;; `bg-main', and for body text on `bg-hover' at the floor the APCA
;; module holds for body text within the selection (Lc 40, moved down
;; with the body-text floor on an optically black canvas), since
;; `highlight' draws `fg-main' on it.
;;
;; The 4.0 floor sits under the 6.0 of `test-completion-selection': the
;; hover is a passing state under the pointer.  It may sit on either
;; side of the selection, in lightness or in chroma, but is never
;; mistaken for it.
;;
;; Basis: the colour difference is CIEDE2000 (CIE 142:2001) and Lc is
;; APCA 0.0.98G-4g.  The 4.0 dE00 floor and the Lc floor are au-themes
;; heuristics.
;;
;; Ref:
;; CIE 142:2001, Improvement to industrial colour-difference evaluation.
;; Somers, A. APCA 0.0.98G-4g, apca-w3 (github.com/Myndex/apca-w3).

;;; Code:

(require 'test-palette-extractor)

(defconst test-hover-highlight-floor 4.0
  "Minimum dE00 between `bg-hover' and the selection, popup and canvas.")

(defun test-hover-highlight-run ()
  "Evaluate how clearly the mouse hover stands out."
  (let* ((theme (or rf-active-theme (car (au-test-discover-themes))))
         (alist (au-test-theme-palette-alist theme))
         (colour (lambda (sym)
                   (or (au-test-resolve-color alist sym)
                       (error "Theme %s does not define %s" theme sym))))
         (polarity (rf-theme-polarity theme))
         (main (funcall colour 'bg-main))
         (hover (funcall colour 'bg-hover))
         (base-band (rf-base-text-lc-band polarity main))
         (floor-shift (if (eq polarity 'light) 0.0 (- 46.0 (car base-band))))
         (text-floor (- 40.0 floor-shift))
         (passes 0)
         (fails 0)
         (row (lambda (label value floor-text ok)
                (if ok (setq passes (1+ passes)) (setq fails (1+ fails)))
                (princ (format "| %-22s | %-15s | %-13s | %-6s |\n"
                               label value floor-text (if ok "PASS" "FAIL"))))))
    (princ (format "\n.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.\n"))
    (princ (format "| Hover Highlight Suite\n"))
    (princ (format "| Theme: %s (%s) | Hover %s | Floor: %.1f dE00\n"
                   theme polarity hover test-hover-highlight-floor))
    (princ (format "'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'\n"))
    (princ (format "+------------------------+-----------------+---------------+--------+\n"))
    (princ (format "| %-22s | %-15s | %-13s | %-6s |\n" "Check" "Value" "Floor" "Status"))
    (princ (format "+------------------------+-----------------+---------------+--------+\n"))
    (dolist (pair '(("Hover vs selected" . bg-completion)
                    ("Hover vs popup" . bg-popup)
                    ("Hover vs canvas" . bg-main)))
      (let ((de (rf-delta-e-2000 hover (funcall colour (cdr pair)))))
        (funcall row (car pair) (format "%.2f dE00" de)
                 (format ">= %.1f" test-hover-highlight-floor)
                 (>= de test-hover-highlight-floor))))
    (let ((lc (abs (rf-apca-contrast (funcall colour 'fg-main) hover))))
      (funcall row "Body text on hover" (format "Lc %.2f" lc)
               (format ">= %.1f" text-floor) (>= lc text-floor)))
    (princ (format "+------------------------+-----------------+---------------+--------+\n"))
    (princ (format "\n===================================================================\n"))
    (princ (format "Hover Highlight Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-hover-highlight-run)
    (kill-emacs 1)))

(provide 'test-hover-highlight)
;;; test-hover-highlight.el ends here
