;;; test-diff-refine-separation.el --- Refine highlight separation from diff lines -*- lexical-binding: t -*-

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
;; Evaluate how far each word-level refine background sits from the
;; background of its diff line.  Diff-mode, Magit and Ediff mark the
;; changed words inside an added, changed or removed line with
;; `bg-added-refine', `bg-changed-refine' and `bg-removed-refine'; when
;; one of them comes too close to its line background the changed words
;; can no longer be found.  Each pair must stay at least 3.5 dE00 apart.
;;
;; Basis: the colour difference is CIEDE2000 (CIE 142:2001).  The
;; 3.5 dE00 floor is an au-themes heuristic.
;;
;; Ref:
;; CIE 142:2001, Improvement to industrial colour-difference evaluation.

;;; Code:

(require 'test-palette-extractor)

(defconst test-diff-refine-separation-floor 3.5
  "Minimum dE00 between a diff line background and its refine background.")

(defun test-diff-refine-separation-run ()
  "Evaluate separation of refine backgrounds from their diff lines."
  (let* ((theme (or rf-active-theme (car (au-test-discover-themes))))
         (alist (au-test-theme-palette-alist theme))
         (colour (lambda (sym)
                   (or (au-test-resolve-color alist sym)
                       (error "Theme %s does not define %s" theme sym))))
         (passes 0)
         (fails 0))
    (princ (format "\n.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.\n"))
    (princ (format "| Diff Refine Separation Suite\n"))
    (princ (format "| Theme: %s | Floor: %.1f dE00\n" theme test-diff-refine-separation-floor))
    (princ (format "'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'\n"))
    (princ (format "+-----------+---------+---------+-------+--------+\n"))
    (princ (format "| %-9s | %-7s | %-7s | %-5s | %-6s |\n" "Diff" "Line" "Refine" "dE00" "Status"))
    (princ (format "+-----------+---------+---------+-------+--------+\n"))
    (dolist (k '(added changed removed))
      (let* ((line (funcall colour (intern (format "bg-%s" k))))
             (refine (funcall colour (intern (format "bg-%s-refine" k))))
             (de (rf-delta-e-2000 line refine))
             (ok (>= de test-diff-refine-separation-floor)))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "| %-9s | %-7s | %-7s | %5.2f | %-6s |\n"
                       k line refine de (if ok "PASS" "FAIL")))))
    (princ (format "+-----------+---------+---------+-------+--------+\n"))
    (princ (format "\n===============================================================\n"))
    (princ (format "Diff Refine Separation Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-diff-refine-separation-run)
    (kill-emacs 1)))

(provide 'test-diff-refine-separation)
;;; test-diff-refine-separation.el ends here
