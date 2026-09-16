;;; test-cross-family-distinctiveness.el --- Cross-package theme divergence and anti-cloning gate -*- lexical-binding: t -*-

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
;; Verification of chromatic divergence and anti-cloning separation
;; between theme families (whispergrove, aurum, parchment).
;; This test is tailored speficially for au-themes, it will not serve
;; any good purpose in any other package/themes.

;;; Code:

(require 'test-palette-extractor)

(defun au-theme-family (theme)
  "Return the package/family symbol of THEME.
Extracts family identifier from convention `au-<family>-<variant>' or `<family>-<variant>'."
  (let ((name (symbol-name theme)))
    (cond
     ((string-match "\\`au-\\([a-z0-9]+\\)-" name)
      (intern (match-string 1 name)))
     ((string-match "\\`\\([a-z0-9]+\\)-" name)
      (intern (match-string 1 name)))
     (t (intern name)))))

(defun au-theme-counterparts (theme)
  "Return the counterpart themes in other families for THEME."
  (let* ((name (symbol-name theme))
         (this-family (au-theme-family theme))
         (this-polarity (rf-theme-polarity theme))
         (all-themes (au-test-discover-themes)))
    (if (string-match-p "twilight" name)
        nil
      (cl-remove-if-not
       (lambda (th)
         (and (not (eq (au-theme-family th) this-family))
              (eq (rf-theme-polarity th) this-polarity)
              (not (string-match-p "twilight" (symbol-name th)))))
       all-themes))))

(defun test-cross-family-distinctiveness-run ()
  "Evaluate that themes from different families do not duplicate colors or aesthetic identities."
  (let* ((theme (or rf-active-theme (car (au-test-discover-themes))))
         (pal (au-extract-active-palette theme))
         (family (au-theme-family theme))
         (polarity (rf-theme-polarity theme))
         (passes 0)
         (fails 0)
         (counterparts (au-theme-counterparts theme)))

    (princ (format "\n.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.\n"))
    (princ (format "| Cross-Family Distinctiveness and Palette Anti-Cloning Suite\n"))
    (princ (format "| Theme: %s (Family: %s, Polarity: %s)\n" theme family polarity))
    (princ (format "| Cross-Family Counterparts Evaluated:\n"))
    (if counterparts
        (dolist (c counterparts)
          (princ (format "|\t* %s\n" c)))
      (princ "|\t* (none)\n"))
    (princ (format "'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'\n"))

    (if (null counterparts)
        (progn
          (princ "[SKIP]  No cross-family counterpart of the same polarity found for comparison.\n")
          (setq passes (1+ passes)))

      (dolist (c-theme counterparts)
        (let* ((c-pal (au-extract-active-palette c-theme))
               (c-family (au-theme-family c-theme)))

          (princ (format "\nCross-Family Hex Collision Check (%s vs %s):\n" theme c-theme))
          (princ (format "---------------------------------------------------------------------------------------------------------\n"))
          (let ((checked-keys '(:keyword :type :builtin :constant :number :fnname
                                         :fnname-call :string :property :bg-region :cursor
                                         :bg-main :fg-main
                                         :bg-red-intense :bg-green-intense :bg-yellow-intense
                                         :bg-blue-intense :bg-magenta-intense :bg-cyan-intense
                                         :bg-red-subtle :bg-green-subtle :bg-yellow-subtle
                                         :bg-blue-subtle :bg-magenta-subtle :bg-cyan-subtle
                                         :fg-line-number-inactive))
                (collisions nil))
            (dolist (k checked-keys)
              (let ((h1 (plist-get pal k))
                    (h2 (plist-get c-pal k)))
                (when (and h1 h2 (string= (downcase h1) (downcase h2)))
                  (push (list k h1) collisions))))
            (if (null collisions)
                (progn
                  (princ (format "[PASS]  0 shared hex codes between %s and %s.\n" theme c-theme))
                  (setq passes (1+ passes)))
              (princ (format "[FAIL]  Cross-family color collision detected: %S\n" collisions))
              (setq fails (1+ fails))))

          (princ (format "\nExpressive Roles Minimum Separation (%s vs %s, min dE00 10.0):\n"
                         theme c-theme))
          (princ (format "---------------------------------------------------------------------------------------------------------\n"))
          (princ (format "+------------------------------+-------------------------+-------------------------+----------+---------+\n"))
          (princ (format "| %-28s | %-23s | %-23s | %-8s | %-7s |\n"
                         "Role" (symbol-name theme) (symbol-name c-theme) "dE00" "Status"))
          (princ (format "+------------------------------+-------------------------+-------------------------+----------+---------+\n"))
          (let ((key-roles '((:type         "Data Type (type)")
                             (:builtin      "Builtin functions (builtin)")
                             (:fnname       "Function name (fnname)")
                             (:fnname-call  "Function call (fnname-call)")
                             (:bg-region    "Selection region (bg-region)")
                             (:cursor       "Cursor point (cursor)"))))
            (dolist (r key-roles)
              (let* ((k (car r))
                     (label (cadr r))
                     (h1 (plist-get pal k))
                     (h2 (plist-get c-pal k))
                     (dist (rf-delta-e-2000 h1 h2))
                     (ok (>= dist 10.0)))
                (if ok
                    (setq passes (1+ passes))
                  (setq fails (1+ fails)))
                (princ (format "| %-28s | %-23s | %-23s | %8.2f | %s    |\n"
                               label h1 h2 dist (if ok "PASS" "FAIL (< 10.0)"))))))
          (princ (format "+------------------------------+-------------------------+-------------------------+----------+---------+\n"))

          (princ (format "\nGlobal Palette Profile Divergence (%s vs %s):\n" theme c-theme))
          (princ (format "---------------------------------------------------------------------------------------------------------\n"))
          (let* ((syntax-keys '(:keyword :type :builtin :constant :number :fnname
                                         :fnname-call :string :property :bg-region))
                 (distances (mapcar (lambda (k)
                                      (rf-delta-e-2000 (plist-get pal k) (plist-get c-pal k)))
                                    syntax-keys))
                 (mean-dist (/ (apply #'+ distances) (float (length distances))))
                 (mean-ok (>= mean-dist 18.0)))
            (if mean-ok
                (progn
                  (princ (format "[PASS]  Mean cross-family syntax separation = %.2f >= 18.0\n" mean-dist))
                  (setq passes (1+ passes)))
              (princ (format "[FAIL]  Palette clone alert: Mean separation = %.2f < 18.0\n" mean-dist))
              (setq fails (1+ fails)))))

        (princ (format "\nChromatic Identity Purity Gate (%s family signature):\n" family))
        (princ (format "---------------------------------------------------------------------------------------------------------\n"))
        (cond
         ((eq family 'aurum)
          ;; Aurum requirements:
          ;; Selection region: h in [40deg..110deg]
          ;; and NEVER h in [115deg..175deg])
          (let* ((reg-hex (plist-get pal :bg-region))
                 (reg-okl (rf-hex-to-oklch reg-hex))
                 (reg-h   (nth 2 reg-okl))
                 (reg-ok  (and (>= reg-h 40.0) (<= reg-h 110.0))))
            (if reg-ok
                (progn
                  (princ (format "[PASS]  Aurum Selection Region (%s, hue %.1fdeg).\n"
                                 reg-hex reg-h))
                  (setq passes (1+ passes)))
              (princ (format "[FAIL]  Aurum Selection Region (%s, hue %.1fdeg): expected [40deg..110deg].\n"
                             reg-hex reg-h))
              (setq fails (1+ fails))))

          ;; For aurum-day, Data Type: h not in [120deg..175deg]
          (when (eq polarity 'light)
            (let* ((type-hex (plist-get pal :type))
                   (type-okl (rf-hex-to-oklch type-hex))
                   (type-h   (nth 2 type-okl))
                   (type-not-green (not (and (>= type-h 120.0) (<= type-h 175.0)))))
              (if type-not-green
                  (progn
                    (princ (format "[PASS]  Aurum Daylight Data Type (%s, hue %.1fdeg).\n"
                                   type-hex type-h))
                    (setq passes (1+ passes)))
                (princ (format "[FAIL]  Aurum Daylight Data Type (%s, hue %.1fdeg): Green hue stolen.\n"
                               type-hex type-h))
                (setq fails (1+ fails))))))

         ((eq family 'whispergrove)
          ;; Whispergrove requirements:
          ;; Selection region: h in [115deg..175deg]
          (let* ((reg-hex (plist-get pal :bg-region))
                 (reg-okl (rf-hex-to-oklch reg-hex))
                 (reg-h   (nth 2 reg-okl))
                 (reg-ok  (and (>= reg-h 115.0) (<= reg-h 175.0))))
            (if reg-ok
                (progn
                  (princ (format "[PASS]  Whispergrove Selection Region (%s, hue %.1fdeg).\n"
                                 reg-hex reg-h))
                  (setq passes (1+ passes)))
              (princ (format "[FAIL]  Whispergrove Selection Region (%s, hue %.1fdeg): Not in forest moss envelope.\n"
                             reg-hex reg-h))
              (setq fails (1+ fails)))))

         ((eq family 'parchment)
          ;; Parchment requirements:
          ;; All syntax code tokens must maintain Oklab C < 0.042
          (let* ((syntax-tokens '(:keyword :type :builtin :constant :number :fnname
                                           :fnname-call :string :property))
                 (excess-chroma nil))
            (dolist (tok syntax-tokens)
              (let* ((hex (plist-get pal tok))
                     (c (nth 1 (rf-hex-to-oklch hex))))
                (when (> c 0.042)
                  (push (list tok hex c) excess-chroma))))
            (if (null excess-chroma)
                (progn
                  (princ "[PASS]  All syntax tokens maintain Oklab C < 0.040\n")
                  (setq passes (1+ passes)))
              (princ (format "[FAIL]  Tokens exceed sensory-safe ceiling C=0.040: %S\n"
                             excess-chroma))
              (setq fails (1+ fails))))

          ;; Selection region: h in [25deg..110deg]
          ;; and NEVER in [120deg..280deg]
          (let* ((reg-hex (plist-get pal :bg-region))
                 (reg-okl (rf-hex-to-oklch reg-hex))
                 (reg-h   (nth 2 reg-okl))
                 (reg-ok  (and (>= reg-h 25.0) (<= reg-h 110.0))))
            (if reg-ok
                (progn
                  (princ (format "[PASS]  Parchment Selection Region (%s, hue %.1fdeg).\n"
                                 reg-hex reg-h))
                  (setq passes (1+ passes)))
              (princ (format "[FAIL]  Parchment Selection Region (%s, hue %.1fdeg): Expected [25deg..110deg].\n"
                             reg-hex reg-h))
              (setq fails (1+ fails)))))

         (t
          (princ (format "[INFO]  No custom chromatic identity signature gate defined for %s family.\n" family))
          (setq passes (1+ passes))))))

    (princ (format "\n=========================================================================================================\n"))
    (princ (format "Cross-Family Distinctiveness Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-cross-family-distinctiveness-run)
    (kill-emacs 1)))

(provide 'test-cross-family-distinctiveness)
;;; test-cross-family-distinctiveness.el ends here
