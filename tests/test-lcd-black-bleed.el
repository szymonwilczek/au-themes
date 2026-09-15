;;; test-lcd-black-bleed.el --- LCD matrix backlight leakage and bleed simulation -*- lexical-binding: t -*-

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
;; Evaluate legibility on an IPS LCD with native black level and ambient
;; reflection.
;; The panel model is L(Y) = L_black + (L_white - L_black) Y + L_reflected
;; with L_black = L_white/1000 (typical IPS native contrast)
;; and L_reflected = R_d E/pi = 0.102 cd/m^2 for R_d = 0.5 % under the IEC
;; 61966-2-1 reference ambient of 64 lx.
;; The previous additive constant of 0.008 (a contrast ratio of 125:1)
;; corresponded to no measurable panel property.

;;; Code:

(require 'test-palette-extractor)

(defun test-lcd-black-bleed-run ()
  "Evaluate legibility on an IPS LCD with native black level and ambient reflection."
  (let* ((pal (au-extract-active-palette))
         (bg (plist-get pal :bg-main))
         (theme (plist-get pal :theme))
         (passes 0)
         (fails 0)
         (tokens '(("Base text"            :fg-main      46.0)
                   ("Comments"             :fg-dim       10.0)
                   ("Cursor"               :cursor       28.0)
                   ("Preprocessor"         :preprocessor 15.0)
                   ("Keywords"             :keyword      15.0)
                   ("Data types"           :type         15.0)
                   ("Constants"            :constant     15.0)
                   ("Numbers"              :number       15.0)
                   ("Builtins"             :builtin      15.0)
                   ("Function definitions" :fnname       15.0)
                   ("Function calls"       :fnname-call  15.0)
                   ("Strings"              :string       15.0)
                   ("Struct fields"        :property     15.0)
                   ("Operators"            :operator     14.0)
                   ("Brackets"             :bracket      13.0)
                   ("Alerts / Errors (!)"  :err          15.0))))
    (princ (format "\n======================================================================\n"))
    (princ (format " IPS LCD Black Level + Ambient Reflection Legibility Suite\n"))
    (princ (format " Theme: %s (%s) | Background: %s\n" theme (rf-theme-polarity theme) bg))
    (princ (format " Black level 1/%.0f, reflected ambient %.5f of white (64 lx, R_d %.1f%%)\n"
                   rf-lcd-contrast-ratio (rf-reflected-luminance-y)
                   (* 100.0 rf-panel-diffuse-reflectance)))
    (princ (format "======================================================================\n"))
    (princ (format "+----------------------+----------+-----------+----------+----------+--------+\n"))
    (princ (format "| %-20s | %-8s | %-8s | %-8s | %-8s | %-7s|\n"
                   "Token Role" "Hex" "Pure |Lc|" "LCD |Lc|" "Min |Lc|" "Status"))
    (princ (format "+----------------------+----------+-----------+----------+----------+--------+\n"))
    (dolist (tok tokens)
      (let* ((name (nth 0 tok))
             (key  (nth 1 tok))
             (polarity (rf-theme-polarity theme))
             (min-lc (if (eq polarity 'light)
                         (if (< (rf-luminance-y bg) 0.420)
                             (cond ((eq key :fg-main) 48.0)
                                   ((eq key :fg-dim) 25.0)
                                   ((eq key :cursor) 20.0)
                                   (t 30.0))
                           (cond ((eq key :fg-main) 58.0)
                                 ((eq key :fg-dim) 30.0)
                                 ((eq key :cursor) 35.0)
                                 (t 40.0)))
                       (nth 2 tok)))
             (hex (plist-get pal key))
             (pure-lc (abs (rf-apca-contrast hex bg)))
             (lcd-lc  (abs (rf-lcd-contrast hex bg)))
             (ok (>= lcd-lc min-lc)))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "| %-20s | %-8s |%8.2f   | %8.2f | >= %4.1f  |  %s  |\n"
                       name hex pure-lc lcd-lc min-lc
                       (if ok "PASS" "FAIL")))))
    (princ (format "+----------------------+----------+-----------+----------+----------+--------+\n"))
    (princ (format "\n==============================================================================\n"))
    (princ (format "LCD Bleed Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-lcd-black-bleed-run)
    (kill-emacs 1)))

(provide 'test-lcd-black-bleed)
;;; test-lcd-black-bleed.el ends here
