;;; install-deps.el --- Install the theme dependencies for a test run -*- lexical-binding: t -*-

;; Copyright (C) 2026  Szymon Wilczek

;; This file is not part of GNU Emacs.

;; This file is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;;; Commentary:
;;
;; Installs ef-themes and modus-themes from GNU ELPA into the directory
;; named by EMACS_ELPA_DIR, where tests/test-palette-extractor.el looks
;; for them.  Used by CI on a clean machine:
;;
;;   EMACS_ELPA_DIR=/tmp/elpa emacs -Q --batch -l tests/install-deps.el

;;; Code:

(require 'package)
(require 'subr-x)

(let ((dir (getenv "EMACS_ELPA_DIR")))
  (unless (and dir (not (string-empty-p dir)))
    (error "Set EMACS_ELPA_DIR to the install directory"))
  (setq package-user-dir (expand-file-name dir)))

(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(package-refresh-contents)

(dolist (pkg '(modus-themes ef-themes))
  (package-install pkg))

(message "Installed: %s"
         (mapconcat (lambda (pkg)
                      (format "%s %s" pkg
                              (package-version-join
                               (package-desc-version
                                (cadr (assq pkg package-alist))))))
                    '(modus-themes ef-themes) ", "))

;;; install-deps.el ends here
