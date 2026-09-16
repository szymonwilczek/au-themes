;;; run-all-tests.el --- Master test suite runner -*- lexical-binding: t -*-

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
;; Master test suite runner executing all biophysical, optical,
;; and ergonomic validation modules across configured au-themes.

;;; Code:

(let ((dir (file-name-directory (or load-file-name buffer-file-name default-directory))))
  (when dir
    (add-to-list 'load-path (expand-file-name ".." dir))
    (add-to-list 'load-path dir)))

(require 'test-palette-extractor)

(defvar rf-running-all-tests t
  "Flag indicating that master test suite runner is active.")

(defvar rf-test-modules
  '(test-apca-contrast
    test-wcag21-ratios
    test-astigmatism-ciliary
    test-pupil-aberrations
    test-straylight-glare
    test-lca-chromatic
    test-chromostereopsis
    test-foveal-scotopic-macula
    test-cvd-colorblindness
    test-mesopic-purkinje-shift
    test-toric-blur-astigmatism
    test-glare-veiling-luminance
    test-oklab-perceptual
    test-helmholtz-kohlrausch
    test-spectral-coherence
    test-lcd-black-bleed
    test-oled-irradiance
    test-spatial-frequency-csf
    test-determinism-1to1
    test-wet-surface-physics
    test-photophobia-glare
    test-pattern-glare-cortical
    test-macular-hazard-blue-light
    test-pupil-spasm-adaptation
    test-astigmatism-meridional-blur
    test-asd-semantic-entropy
    test-photophobia-triplet-contrast
    test-trigeminal-nerve-excitation
    test-scotopic-pupillary-aperture
    test-magnocellular-parvocellular-balance
    test-tonic-accommodation-dark-focus
    test-crowding-effect-foveal
    test-isoluminance-jitter
    test-afterimage-persistence
    test-cross-family-distinctiveness))

(defvar au-test-themes
  (let ((env (or (getenv "AU_TEST_THEMES") (getenv "RF_TEST_THEMES"))))
    (if (and env (not (string-empty-p env)))
        (mapcar #'intern (split-string env "[, ]+" t))
      '(au-whispergrove-night au-whispergrove-evening au-whispergrove-morning au-whispergrove-day
                              au-aurum-twilight au-aurum-night au-aurum-day
                              au-parchment-night au-parchment-day)))
  "Themes evaluated by `run-all-au-tests'.
Override with the AU_TEST_THEMES or RF_TEST_THEMES environment variable, e.g.
AU_TEST_THEMES=au-whispergrove-night to gate a single variant.")

(defvaralias 'rf-test-themes 'au-test-themes)

(defun run-all-au-tests ()
  "Execute all test suites across `au-test-themes' and compile diagnostic report."
  (interactive)
  (let ((run-body
         (lambda ()
           (let* ((themes au-test-themes)
                  (total-modules (* (length rf-test-modules) (length themes)))
                  (passed-modules 0)
                  (failed-modules nil))
             (princ "\n+---------------------------------------------------------------------+\n")
             (princ "| AU THEMES: AUTOMATED TEST SUITE                                     |\n")
             (princ "+---------------------------------------------------------------------+\n")
             (princ (format "Themes: %s\n"
                            (mapconcat #'symbol-name themes ", ")))
             (princ "+---------------------------------------------------------------------+\n")

             (dolist (theme themes)
               (setq rf-active-theme theme)
               (princ (format "\n+----------------------------------------------------+\n"))
               (princ (format " RUNNING TEST SUITES FOR THEME: %s\n" theme))
               (princ (format "+----------------------------------------------------+\n"))
               (dolist (mod rf-test-modules)
                 (require mod)
                 (let* ((fn-name (intern (format "%s-run" (symbol-name mod))))
                        (res (funcall fn-name)))
                   (if res
                       (setq passed-modules (1+ passed-modules))
                     (push (cons theme mod) failed-modules)))))

             (princ "\n+-------------------------------------+\n")
             (princ "| EXECUTIVE MASTER TEST SUITE SUMMARY |\n")
             (princ "+-------------------------------------+\n")
             (princ (format "Total Test Executions:       %d (%d modules x %d themes)\n"
                            total-modules (length rf-test-modules) (length themes)))
             (princ (format "Passed Test Executions:      %d\n" passed-modules))
             (princ (format "Failed Test Executions:      %d\n" (length failed-modules)))
             (if failed-modules
                 (progn
                   (princ (format "Failing Modules:             %S\n" (nreverse failed-modules)))
                   (princ "+-------------------------------------+\n")
                   (princ "Status: FAILING GATES DETECTED\n")
                   nil)
               (princ "+-------------------------------------+\n")
               (princ (format "Status: ALL %d GATES PASSED\n" total-modules))
               t)))))
    (if (called-interactively-p 'any)
        (with-output-to-temp-buffer "*Au Themes Test Results*"
          (funcall run-body))
      (funcall run-body))))

(defalias 'run-all-whispergrove-tests #'run-all-au-tests)

(when noninteractive
  (unless (run-all-au-tests)
    (kill-emacs 1)))

(provide 'run-all-tests)
;;; run-all-tests.el ends here
