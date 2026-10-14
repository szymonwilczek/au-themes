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

    (princ (format "\n=====================================================================\n"))
    (princ (format "Theme Integrity Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-theme-integrity-run)
    (kill-emacs 1)))

(provide 'test-theme-integrity)
;;; test-theme-integrity.el ends here
