;;; test-select-restore.el --- Preview restore on abort and modus-themes registration -*- lexical-binding: t -*-

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
;; Validate that au-themes-select previews and restores themes,
;; and that every theme is declared to modus-themes.
;;
;; Test 1 : Consult path: `au-themes--select' limits `consult-theme'
;; to the au-themes and records only a selected au-theme as loaded.
;; Preview and restore on abort are consult's own.
;;
;; Test 2 : completing-read abort: call `au-themes--read-theme'
;; (no consult), signal quit, and verify the theme enabled before
;; the prompt (here a modus theme) is restored via the unwind-protect.
;;
;; Test 3 : Plain preview: an input naming a theme shows it; once the
;; input no longer names a theme, the previous theme is shown again.
;;
;; Test 4 : Modus registration: after loading au-themes inside
;; a with-eval-after-load for modus-themes, verify every discovered
;; au-theme has been declared and registered with modus-themes.

;;; Code:

(require 'test-palette-extractor)

;;; Test 1
(cl-defun test-select-restore--consult ()
  "Check that the consult path hands THEMES to `consult-theme'.
Stub `consult-theme' so that it either enables a theme (a selection)
or leaves the old one enabled (an abort, which consult restores
itself).  Only a selected au-theme may be recorded as loaded."
  (let* ((themes (au-themes-get-themes))
         (chosen (car themes))
         (seen nil)
         (noted nil)
         (result nil))
    (unless chosen
      (princ "[SKIP]  No themes discovered for consult test\n")
      (cl-return-from test-select-restore--consult 'skip))
    (dolist (outcome (list chosen 'modus-vivendi))
      (let ((custom-enabled-themes '(modus-vivendi)))
        (setq seen nil noted nil)
        (cl-letf (((symbol-function 'consult-theme)
                   (lambda (_theme)
                     (interactive (list nil))
                     (setq seen consult-themes)
                     (setq custom-enabled-themes (list outcome))))
                  ((symbol-function 'au-themes--note-loaded)
                   (lambda (th) (setq noted th))))
          (au-themes--select themes "Test"))
        (push (and (equal seen themes)
                   (eq noted (and (memq outcome themes) outcome)))
              result)))
    (if (and (car result) (cadr result))
        (progn
          (princ "[PASS]  Consult path limits consult-theme to au-themes\n")
          t)
      (princ (format "[FAIL]  Consult path: consult-themes=%S, noted=%S\n" seen noted))
      nil)))

;;; Test 2
(cl-defun test-select-restore--completing-read-abort ()
  "Verify that aborting the completing-read picker restores the theme.
The theme enabled before the prompt is not an au-theme, as in issue #4.
Override `completing-read' to signal `quit' immediately, then check
that `au-themes--apply-theme' was called with that theme."
  (let* ((themes (au-themes-get-themes))
         (saved-theme 'modus-vivendi)
         (applied-log nil))
    (unless themes
      (princ "[SKIP]  No themes discovered for completing-read abort test\n")
      (cl-return-from test-select-restore--completing-read-abort 'skip))
    (let ((custom-enabled-themes (list saved-theme)))
      (cl-letf (((symbol-function 'au-themes--apply-theme)
                 (lambda (th &optional _force)
                   (push th applied-log)))
                ((symbol-function 'completing-read)
                 (lambda (&rest _) (signal 'quit nil))))
        (condition-case nil
            (au-themes--read-theme themes "Test")
          (quit nil))))
    (let ((last-applied (car applied-log)))
      (if (eq last-applied saved-theme)
          (progn
            (princ (format "[PASS]  completing-read abort restores saved theme (%s)\n"
                           saved-theme))
            t)
        (princ (format "[FAIL]  After quit, expected %s but last applied was %s\n"
                       saved-theme last-applied))
        nil))))

;;; Test 3
(cl-defun test-select-restore--preview-input ()
  "Verify that the plain minibuffer preview follows exact input only.
An input naming a theme shows it; editing the input so that it no
longer names a theme goes back to the theme enabled before."
  (let* ((themes (au-themes-get-themes))
         (theme (car themes))
         (fallback 'modus-vivendi)
         (applied nil))
    (unless theme
      (princ "[SKIP]  No themes discovered for preview input test\n")
      (cl-return-from test-select-restore--preview-input 'skip))
    (cl-letf (((symbol-function 'au-themes--apply-theme)
               (lambda (th &optional _force) (setq applied th))))
      (with-temp-buffer
        (insert (symbol-name theme))
        (au-themes--preview-input themes fallback)
        (let ((on-match applied))
          (delete-char -1)
          (au-themes--preview-input themes fallback)
          (if (and (eq on-match theme) (eq applied fallback))
              (progn
                (princ "[PASS]  Preview follows exact input and reverts on edit\n")
                t)
            (princ (format "[FAIL]  Preview showed %s on match and %s after edit\n"
                           on-match applied))
            nil))))))

;;; Test 4
(defun test-select-restore--modus-registration ()
  "Verify that every au-theme is declared to modus-themes.
Each theme must be registered (known to `modus-themes-get-all-known-themes')
and its :background-mode property must match the palette polarity."
  (unless (and (fboundp 'modus-themes-declare)
               (fboundp 'modus-themes-register)
               (fboundp 'modus-themes-get-all-known-themes))
    (princ "[SKIP]  modus-themes version too old for declare/register API\n")
    (return-from test-select-restore--modus-registration 'skip))
  (require 'modus-themes)
  (require 'au-themes)
  (let* ((known (modus-themes-get-all-known-themes 'au-themes))
         (all (au-themes-get-themes))
         (passes 0)
         (fails 0))
    (princ "\nModus-themes Registration Check:\n")
    (dolist (theme all)
      (let* ((registered (memq theme known))
             (props (get theme 'theme-properties))
             (declared-mode (plist-get props :background-mode))
             (polarity (au-themes--theme-polarity theme))
             (mode-ok (or (null declared-mode) (eq declared-mode polarity))))
        (cond
         ((not registered)
          (princ (format "[FAIL]  %s not registered with modus-themes\n" theme))
          (setq fails (1+ fails)))
         ((not mode-ok)
          (princ (format "[FAIL]  %s declared %s but palette says %s\n"
                         theme declared-mode polarity))
          (setq fails (1+ fails)))
         (t
          (princ (format "[PASS]  %s registered (%s)\n" theme declared-mode))
          (setq passes (1+ passes))))))
    (princ (format "\nRegistration Summary: %d passed, %d failed out of %d themes.\n"
                   passes fails (length all)))
    (zerop fails)))

;;; Runner
(defun test-select-restore-run ()
  "Run all select-restore tests.  Return t if all pass, nil if any fail."
  (let ((passes 0)
        (fails 0)
        (skips 0))
    (princ "\n.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.\n")
    (princ "| Select Restore & Modus Registration Suite\n")
    (princ "'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'\n\n")

    (dolist (test '(test-select-restore--consult
                    test-select-restore--completing-read-abort
                    test-select-restore--preview-input
                    test-select-restore--modus-registration))
      (let ((res (funcall test)))
        (cond ((eq res 'skip) (setq skips (1+ skips)))
              (res            (setq passes (1+ passes)))
              (t              (setq fails (1+ fails))))))

    (princ (format "\n===========================================================================================\n"))
    (princ (format "Select Restore Summary: %d passed, %d failed, %d skipped.\n\n" passes fails skips))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-select-restore-run)
    (kill-emacs 1)))

(provide 'test-select-restore)
;;; test-select-restore.el ends here
