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
;; Validate that au-themes-select restores the previous theme when the
;; user aborts, and that every theme is declared to modus-themes.
;;
;; Test 1 : Consult state callback: simulate the 'preview → 'exit
;; sequence (C-g) and verify that the theme applied before the picker
;; opened is the one that ends up enabled.
;;
;; Test 2 : completing-read abort: call `au-themes--prompt-with-preview'
;; through the completing-read path (no consult), signal quit, and
;; verify the saved theme is restored via the unwind-protect.
;;
;; Test 3 : Modus registration: after loading au-themes inside a
;; with-eval-after-load for modus-themes, verify every discovered
;; au-theme has been declared and registered with modus-themes.

;;; Code:

(require 'test-palette-extractor)

;;; Test 1
(defun test-select-restore--consult-abort ()
  "Simulate the consult state callback lifecycle on C-g.
Build the same closure that `au-themes--prompt-with-preview' builds
for consult, drive it through preview → exit (no return), and check
that the saved theme is back."
  (let* ((themes (au-themes-get-themes))
         (saved-theme (car themes))
         (preview-theme (cadr themes))
         (applied nil))
    (unless (and saved-theme preview-theme (not (eq saved-theme preview-theme)))
      (princ "[SKIP]  Need at least two themes for consult abort test\n")
      (return-from test-select-restore--consult-abort 'skip))
    (cl-letf (((symbol-function 'au-themes--apply-theme)
               (lambda (th &optional _force)
                 (setq applied th))))
      (let* ((selected nil)
             (state-fn
              (lambda (action cand)
                (pcase action
                  ('preview
                   (when cand
                     (let ((th (if (symbolp cand) cand (intern-soft cand))))
                       (when (memq th themes)
                         (au-themes--apply-theme th)))))
                  ('return
                   (setq selected t)
                   (let ((final-th (or (and cand (if (symbolp cand) cand (intern-soft cand)))
                                       saved-theme)))
                     (when final-th
                       (au-themes--apply-theme final-th))))
                  ('exit
                   (unless selected
                     (when saved-theme
                       (au-themes--apply-theme saved-theme))))))))
        (funcall state-fn 'preview preview-theme)
        (unless (eq applied preview-theme)
          (princ (format "[FAIL]  Preview did not apply %s (got %s)\n"
                         preview-theme applied))
          (return-from test-select-restore--consult-abort nil))
        (funcall state-fn 'exit nil)
        (if (eq applied saved-theme)
            (progn
              (princ (format "[PASS]  Consult abort restores saved theme (%s)\n" saved-theme))
              t)
          (princ (format "[FAIL]  After exit, expected %s but got %s\n"
                         saved-theme applied))
          nil)))))

;;; Test 2
(defun test-select-restore--completing-read-abort ()
  "Verify that aborting the completing-read picker restores the theme.
Override `completing-read' to signal `quit' immediately, then check
that `au-themes--apply-theme' was called with the saved theme."
  (let* ((themes (au-themes-get-themes))
         (saved-theme (car themes))
         (applied-log nil))
    (unless saved-theme
      (princ "[SKIP]  No themes discovered for completing-read abort test\n")
      (return-from test-select-restore--completing-read-abort 'skip))
    (cl-letf (((symbol-function 'au-themes--apply-theme)
               (lambda (th &optional _force)
                 (push th applied-log)))
              ((symbol-function 'au-themes-get-current-theme)
               (lambda () saved-theme))
              ((symbol-function 'completing-read)
               (lambda (&rest _) (signal 'quit nil)))
              ((symbol-function 'consult--read)
               nil))
      (condition-case nil
          (au-themes--prompt-with-preview themes "Test: ")
        (quit nil)))
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

    (dolist (test '(test-select-restore--consult-abort
                    test-select-restore--completing-read-abort
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
