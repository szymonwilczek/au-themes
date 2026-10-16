;;; test-ui-text-contrast.el --- Diff and mode line text contrast -*- lexical-binding: t -*-

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
;; Evaluate APCA contrast of text drawn outside the code canvas: diff
;; lines and the mode line.  Diff hunks in diff-mode, Magit and Ediff
;; show whole lines of code in `fg-added', `fg-changed' and
;; `fg-removed', so they are held to the body-text band on both the line
;; background and the word-level refine background.  The active mode
;; line is read like body text and uses the same band.  The inactive
;; mode line is meant to recede and shares the band of inactive line
;; numbers.
;;
;; Basis: Lc is APCA 0.0.98G-4g.  The body-text band is
;; `rf-base-text-lc-band'; it and the inactive band are au-themes
;; heuristics.
;;
;; Ref:
;; Somers, APCA 0.0.98G-4g (apca-w3).

;;; Code:

(require 'test-palette-extractor)

(defun test-ui-text-contrast-run ()
  "Evaluate APCA contrast of diff and mode line text."
  (let* ((theme (or rf-active-theme (car (au-test-discover-themes))))
         (alist (au-test-theme-palette-alist theme))
         (colour (lambda (sym)
                   (or (au-test-resolve-color alist sym)
                       (error "Theme %s does not define %s" theme sym))))
         (polarity (rf-theme-polarity theme))
         (bg (funcall colour 'bg-main))
         (body (rf-base-text-lc-band polarity bg))
         (dim (if (eq polarity 'light) '(30.0 . 55.0) '(15.0 . 30.0)))
         (checks
          (append
           (mapcan (lambda (k)
                     (let ((fg (intern (format "fg-%s" k))))
                       (list (list (format "Diff %s line" k) fg (intern (format "bg-%s" k)) body)
                             (list (format "Diff %s refine" k) fg (intern (format "bg-%s-refine" k)) body))))
                   '(added changed removed))
           (list (list "Mode line active" 'fg-mode-line-active 'bg-mode-line-active body)
                 (list "Mode line inactive" 'fg-mode-line-inactive 'bg-mode-line-inactive dim))))
         (passes 0)
         (fails 0))
    (princ (format "\n.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.\n"))
    (princ (format "| Diff and Mode Line Text Contrast Suite\n"))
    (princ (format "| Theme: %s (%s) | Body-text band: Lc %.0f..%.0f\n"
                   theme polarity (car body) (cdr body)))
    (princ (format "'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'\n"))
    (princ (format "+----------------------+---------+---------+-------+-------------+--------+\n"))
    (princ (format "| %-20s | %-7s | %-7s | %-5s | %-11s | %-6s |\n"
                   "Text" "Fg" "Bg" "|Lc|" "Band" "Status"))
    (princ (format "+----------------------+---------+---------+-------+-------------+--------+\n"))
    (dolist (c checks)
      (let* ((fg (funcall colour (nth 1 c)))
             (bg2 (funcall colour (nth 2 c)))
             (band (nth 3 c))
             (lc (abs (rf-apca-contrast fg bg2)))
             (ok (and (>= lc (car band)) (<= lc (cdr band)))))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "| %-20s | %-7s | %-7s | %5.1f | %4.0f .. %-4.0f | %-6s |\n"
                       (nth 0 c) fg bg2 lc (car band) (cdr band)
                       (if ok "PASS" "FAIL")))))
    (princ (format "+----------------------+---------+---------+-------+-------------+--------+\n"))
    (princ (format "\n=========================================================================\n"))
    (princ (format "UI Text Contrast Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-ui-text-contrast-run)
    (kill-emacs 1)))

(provide 'test-ui-text-contrast)
;;; test-ui-text-contrast.el ends here
