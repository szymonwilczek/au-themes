;;; test-theme-integrity.el --- Theme declaration and palette integrity -*- lexical-binding: t -*-

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
;; Check that what a theme declares about itself matches its palette.
;;
;; Every other module selects its thresholds by the polarity the theme
;; declares to `modus-themes-theme', and `au-themes' groups its pickers
;; by it.  A theme declared `dark' whose text is darker than its canvas
;; would therefore be gated against the wrong limits without any module
;; noticing.  Contrast polarity needs no threshold: a theme is light
;; exactly when its canvas is more luminous than its body text.

;;; Code:

(require 'test-palette-extractor)

;; Keys whose palette comment legitimately differs between themes,
;; because the colour serves a different role.
(defconst au-integrity-comment-variants
  '((cyan "Keyword fallback" "Builtin fallback"))
  "Allowed palette comments per key besides the collection majority.")

(defun au-integrity-theme-lines (theme)
  "Return the source lines of THEME's theme file."
  (with-temp-buffer
    (insert-file-contents (locate-library (format "%s-theme.el" theme)))
    (split-string (buffer-string) "\n")))

(defun au-integrity-palette-comments (lines)
  "Return ((KEY COLUMN COMMENT) ...) for the hex palette entries in LINES."
  (let ((res nil))
    (dolist (l lines)
      (when (string-match "\\`    (\\([a-z0-9-]+\\) \"#[0-9a-fA-F]\\{6\\}\")\\( *\\); \\(.*\\)\\'" l)
        (push (list (intern (match-string 1 l))
                    (1+ (match-end 2))
                    (match-string 3 l))
              res)))
    (nreverse res)))

(defun au-integrity-canonical-comments ()
  "Return a hash of KEY -> the palette comment most themes use for it."
  (let ((counts (make-hash-table :test 'equal))
        (best (make-hash-table)))
    (dolist (th (au-test-discover-themes))
      (dolist (e (au-integrity-palette-comments (au-integrity-theme-lines th)))
        (let ((k (cons (nth 0 e) (nth 2 e))))
          (puthash k (1+ (gethash k counts 0)) counts))))
    (maphash (lambda (k n)
               (let ((cur (gethash (car k) best)))
                 (when (or (null cur) (> n (cdr cur)))
                   (puthash (car k) (cons (cdr k) n) best))))
             counts)
    best))

(defun au-integrity-commentary (lines)
  "Return the commentary lines between `;;; Commentary:' and `;;; Code:'."
  (let ((in nil) (res nil))
    (dolist (l lines)
      (cond ((string= l ";;; Commentary:") (setq in t))
            ((string= l ";;; Code:") (setq in nil))
            (in (push l res))))
    (nreverse res)))

(defun test-theme-integrity-run ()
  "Check the declared polarity of the active theme against its palette."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (declared (rf-theme-declared-polarity theme))
         (bg (plist-get pal :bg-main))
         (fg (plist-get pal :fg-main))
         (bg-y (rf-luminance-y bg))
         (fg-y (rf-luminance-y fg))
         (measured (if (> bg-y fg-y) 'light 'dark))
         (passes 0)
         (fails 0))
    (princ (format "\n.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.\n"))
    (princ (format "| Theme Declaration & Palette Integrity Suite\n"))
    (princ (format "| Theme: %s\n" theme))
    (princ (format "'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'\n"))

    (princ "\nDeclared Polarity vs Contrast Polarity:\n")
    (princ (format "---------------------------------------------------------------------\n"))
    (princ (format "Declared background mode: %S\n" declared))
    (princ (format "bg-main %s (Y=%.4f) vs fg-main %s (Y=%.4f) -> %s\n"
                   bg bg-y fg fg-y measured))
    (if (eq declared measured)
        (progn
          (princ "[PASS]  Declared polarity matches the palette.\n")
          (setq passes (1+ passes)))
      (princ (format "[FAIL]  Theme declares %S but its palette is %S.\n" declared measured))
      (setq fails (1+ fails)))

    (princ "\nSource Layout:\n")
    (princ (format "---------------------------------------------------------------------\n"))
    (let* ((lines (au-integrity-theme-lines theme))
           (ref-theme (car (au-test-discover-themes)))
           (header (cl-subseq lines 1 22))
           (ref-header (cl-subseq (au-integrity-theme-lines ref-theme) 1 22))
           (comm (cl-remove-if (lambda (l) (member l '(";;" ""))) (au-integrity-commentary lines)))
           (opener (format ";; %s theme " (capitalize (symbol-name declared))))
           (canon (au-integrity-canonical-comments))
           (bad-comments nil)
           (doubled nil)
           (checks nil))
      (dolist (e (au-integrity-palette-comments lines))
        (let* ((key (nth 0 e))
               (want (car (gethash key canon)))
               (allowed (cons want (cdr (assq key au-integrity-comment-variants)))))
          (unless (and (= (nth 1 e) 43) (member (nth 2 e) allowed))
            (push (format "%s (col %d) %S" key (nth 1 e) (nth 2 e)) bad-comments))))
      (let ((prev nil))
        (dolist (l lines)
          (when (and (equal l "") (equal prev "")) (setq doubled t))
          (setq prev l)))
      (setq checks
            (list (list (format "Header and licence block match %s" ref-theme)
                        (equal header ref-header) "lines 2-22 differ")
                  (list (format "Commentary opens with '%s...'" (string-trim-right opener))
                        (and comm (string-prefix-p opener (car comm)))
                        (format "%S" (car comm)))
                  (list "Commentary closes with the collection line"
                        (equal (car (last comm)) ";; Part of the `au-themes' collection.")
                        (format "%S" (car (last comm))))
                  (list "Palette comments at column 43 with collection wording"
                        (null bad-comments)
                        (mapconcat #'identity (nreverse bad-comments) "; "))
                  (list "No doubled blank lines" (not doubled) "found")))
      (dolist (c checks)
        (if (nth 1 c)
            (progn
              (princ (format "[PASS]  %s.\n" (nth 0 c)))
              (setq passes (1+ passes)))
          (princ (format "[FAIL]  %s: %s.\n" (nth 0 c) (nth 2 c)))
          (setq fails (1+ fails)))))

    (princ (format "\n=====================================================================\n"))
    (princ (format "Theme Integrity Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-theme-integrity-run)
    (kill-emacs 1)))

(provide 'test-theme-integrity)
;;; test-theme-integrity.el ends here
