;;; test-completion-selection.el --- Selected completion candidate stands out -*- lexical-binding: t -*-

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
;; Evaluate how clearly the selected completion candidate stands out.
;; Through modus-themes, `corfu-current' and `company-tooltip-selection'
;; draw the selected row in `bg-completion' inside a popup of
;; `bg-popup', while Vertico, Icomplete and `completions-highlight'
;; draw it in `bg-completion' on the canvas `bg-main'.  When
;; `bg-completion' comes close to either of them, the selected
;; candidate can no longer be found at a glance.
;;
;; The module checks four things:
;;
;; - `bg-completion' sits at least 6.0 dE00 from `bg-popup' and from
;;   `bg-main';
;; - the selected row is raised from the popup and from the canvas in
;;   the direction of the theme: lighter than `bg-popup' and `bg-main'
;;   on a dark canvas, darker on a light one;
;; - body text on `bg-completion' keeps the floor that the APCA module
;;   holds for body text within the selection (Lc 40, moved down with
;;   the body-text floor on an optically black canvas);
;; - the match highlights (`fg-completion-match-0' to 3) on
;;   `bg-completion' keep the syntax-role floor of the APCA module,
;;   less `test-completion-selection-match-allowance'.
;;
;; Basis: the colour difference is CIEDE2000 (CIE 142:2001) and Lc is
;; APCA 0.0.98G-4g.  The 6.0 dE00 floor, the direction and the Lc
;; floors are au-themes heuristics.
;;
;; Ref:
;; CIE 142:2001, Improvement to industrial colour-difference evaluation.
;; Somers, A. APCA 0.0.98G-4g, apca-w3 (github.com/Myndex/apca-w3).

;;; Code:

(require 'test-palette-extractor)

(defconst test-completion-selection-floor 6.0
  "Minimum dE00 between `bg-completion' and `bg-popup' or `bg-main'.")

(defconst test-completion-selection-match-allowance 6.0
  "Lc that match highlights on `bg-completion' may lose against the syntax floor.
This is the loss the APCA module allows body text within the selection
on a dark canvas (floor 46 on the canvas, 40 within the selection).
Light themes take the same 6 Lc rather than their own, larger loss of
body text (58 or 48 down to 40): match highlights are coloured and
start lower, so a larger loss would leave them too faint to read.")

(defun test-completion-selection-run ()
  "Evaluate how clearly the selected completion candidate stands out."
  (let* ((theme (or rf-active-theme (car (au-test-discover-themes))))
         (alist (au-test-theme-palette-alist theme))
         (colour (lambda (sym)
                   (or (au-test-resolve-color alist sym)
                       (error "Theme %s does not define %s" theme sym))))
         (polarity (rf-theme-polarity theme))
         (main (funcall colour 'bg-main))
         (popup (funcall colour 'bg-popup))
         (sel (funcall colour 'bg-completion))
         (base-band (rf-base-text-lc-band polarity main))
         (floor-shift (if (eq polarity 'light) 0.0 (- 46.0 (car base-band))))
         (text-floor (- 40.0 floor-shift))
         (match-floor (- (cond ((not (eq polarity 'light)) 16.0)
                               ((< (rf-luminance-y main) rf-subdued-canvas-y) 32.0)
                               (t 40.0))
                         test-completion-selection-match-allowance))
         (passes 0)
         (fails 0)
         (row (lambda (label value floor-text ok)
                (if ok (setq passes (1+ passes)) (setq fails (1+ fails)))
                (princ (format "| %-27s | %-15s | %-13s | %-6s |\n"
                               label value floor-text (if ok "PASS" "FAIL"))))))
    (princ (format "\n.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.\n"))
    (princ (format "| Completion Selection Suite\n"))
    (princ (format "| Theme: %s (%s) | Selected %s | Popup %s | Canvas %s\n"
                   theme polarity sel popup main))
    (princ (format "'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'\n"))
    (princ (format "+-----------------------------+-----------------+---------------+--------+\n"))
    (princ (format "| %-27s | %-15s | %-13s | %-6s |\n" "Check" "Value" "Floor" "Status"))
    (princ (format "+-----------------------------+-----------------+---------------+--------+\n"))
    (dolist (pair `(("Selected vs popup" . ,popup) ("Selected vs canvas" . ,main)))
      (let ((de (rf-delta-e-2000 sel (cdr pair))))
        (funcall row (car pair) (format "%.2f dE00" de)
                 (format ">= %.1f" test-completion-selection-floor)
                 (>= de test-completion-selection-floor))))
    (dolist (pair `(("Selected raised from popup" . ,popup)
                    ("Selected raised from canvas" . ,main)))
      (let* ((dy (- (rf-luminance-y sel) (rf-luminance-y (cdr pair))))
             (ok (if (eq polarity 'light) (< dy 0) (> dy 0))))
        (funcall row (car pair) (format "dY %+.4f" dy)
                 (if (eq polarity 'light) "darker" "lighter") ok)))
    (let ((lc (abs (rf-apca-contrast (funcall colour 'fg-main) sel))))
      (funcall row "Body text on selected" (format "Lc %.2f" lc)
               (format ">= %.1f" text-floor) (>= lc text-floor)))
    (dotimes (i 4)
      (let* ((sym (intern (format "fg-completion-match-%d" i)))
             (lc (abs (rf-apca-contrast (funcall colour sym) sel))))
        (funcall row (format "Match %d on selected" i) (format "Lc %.2f" lc)
                 (format ">= %.1f" match-floor) (>= lc match-floor))))
    (princ (format "+-----------------------------+-----------------+---------------+--------+\n"))
    (princ (format "\n=======================================================================\n"))
    (princ (format "Completion Selection Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-completion-selection-run)
    (kill-emacs 1)))

(provide 'test-completion-selection)
;;; test-completion-selection.el ends here
