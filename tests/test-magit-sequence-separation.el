;;; test-magit-sequence-separation.el --- Magit rebase sequence states apart at glyph size -*- lexical-binding: t -*-

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
;; Evaluate whether the states of a Magit rebase sequence stay apart
;; at the size of a glyph. While a rebase stops, the sequence section
;; lists the commit HEAD points at as "done" in `magit-sequence-head',
;; the commits rebased before it as "done" in `magit-sequence-done'
;; and the base as "onto" in `magit-sequence-onto'.
;; After an amend the old commit shows as "gone" right above the new
;; one, so the only thing that tells the current commit from the ones
;; already done is the colour of a four-letter word.
;;
;; The faces take their colours from the palette: the head is
;; `accent-0', done is `info' and onto is `fg-dim'. Each pair of the
;; three must keep a scaled difference at glyph size (see
;; `test-glyph-size-color-difference') of at least 2.0, twice the
;; floor of the syntax roles, because the word is short and the reader
;; has to find it at a glance. The module covers every family.
;;
;; Basis: the size model is Szafir (2018); the 2.0 floor is an
;; au-themes choice.
;;
;; Ref:
;; - Szafir (2018) Modeling color difference for visualization design.
;;   IEEE Trans. Vis. Comput. Graph. 24(1):392ff.  doi:10.1109/TVCG.2017.2744359

;;; Code:

(require 'test-palette-extractor)
(require 'test-glyph-size-color-difference)

(defconst test-magit-sequence-separation-floor 2.0
  "Lowest scaled glyph-size difference between two rebase sequence states.")

(defconst test-magit-sequence-separation-states
  '(("head" . accent-0) ("done" . info) ("onto" . fg-dim))
  "Rebase sequence states and the palette entries their faces use.")

(defun test-magit-sequence-separation-run ()
  "Evaluate separation of the rebase sequence states at glyph size."
  (let* ((theme (or rf-active-theme (car (au-test-discover-themes))))
         (alist (au-test-theme-palette-alist theme))
         (states (mapcar (lambda (s)
                           (cons (car s)
                                 (or (au-test-resolve-color alist (cdr s))
                                     (error "Theme %s does not define %s"
                                            theme (cdr s)))))
                         test-magit-sequence-separation-states))
         (passes 0)
         (fails 0))
    (princ (format "\n.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.\n"))
    (princ (format "| Magit Sequence Separation Suite\n"))
    (princ (format "| Theme: %s | Floor: dE_s %.1f\n" theme test-magit-sequence-separation-floor))
    (princ (format "'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'\n"))
    (princ (format "+--------------+---------+---------+-------+--------+\n"))
    (princ (format "| %-12s | %-7s | %-7s | %-5s | %-6s |\n" "States" "Color 1" "Color 2" "dE_s" "Status"))
    (princ (format "+--------------+---------+---------+-------+--------+\n"))
    (dolist (pair '(("head" . "done") ("head" . "onto") ("done" . "onto")))
      (let* ((h1 (cdr (assoc (car pair) states)))
             (h2 (cdr (assoc (cdr pair) states)))
             (d (au-glyph-size-delta-e h1 h2))
             (ok (>= d test-magit-sequence-separation-floor)))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "| %-12s | %-7s | %-7s | %5.2f | %-6s |\n"
                       (format "%s vs %s" (car pair) (cdr pair))
                       h1 h2 d (if ok "PASS" "FAIL")))))
    (princ (format "+--------------+---------+---------+-------+--------+\n"))
    (princ (format "\n===============================================================\n"))
    (princ (format "Magit Sequence Separation Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-magit-sequence-separation-run)
    (kill-emacs 1)))

(provide 'test-magit-sequence-separation)
;;; test-magit-sequence-separation.el ends here
