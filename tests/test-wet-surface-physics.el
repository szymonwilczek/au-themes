;;; test-wet-surface-physics.el --- Organic gamut chroma ceiling and Lekner-Dorf (1988) wet optics -*- lexical-binding: t -*-

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
;; Evaluate organic gamut chroma boundaries and Lekner & Dorf (1988)
;; wetting optics.
;;
;; Ref:
;; Lekner & Dorf (1988) Applied Optics 27(7), 1278-1280.

;;; Code:

(require 'test-palette-extractor)

(defun test-wet-surface-physics-run ()
  "Evaluate organic gamut chroma boundaries and Lekner & Dorf (1988) wetting optics."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (passes 0)
         (fails 0)
         ;; Internal reflection fraction at water-air boundary
         ;; (n=1.333, Lekner & Dorf 1988 eq. 4)
         (r-wa 0.55)
         (tokens '(("Preprocessor"         :preprocessor 50.0)
                   ("Keywords"             :keyword      50.0)
                   ("Data types"           :type         52.0)
                   ("Constants"            :constant     50.0)
                   ("Numbers"              :number       55.0)
                   ("Builtins"             :builtin      45.0)
                   ("Function definitions" :fnname       45.0)
                   ("Function calls"       :fnname-call  45.0)
                   ("Strings"              :string       50.0)
                   ("Struct fields"        :property     40.0)
                   ("Operators"            :operator     25.0)
                   ("Brackets"             :bracket      20.0)
                   ("Comments"             :fg-dim       20.0)
                   ("Alerts / Errors (!)"  :err          55.0))))
    (princ (format "\n.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.\n"))
    (princ (format "| Organic Chroma Ceiling & Lekner & Dorf (1988) Wet Surface Optics\n"))
    (princ (format "| Theme: %s\n" theme))
    (princ (format "'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'\n"))
    (princ (format "\n+----------------------+---------+-----------+------------+---------+-----------+\n"))
    (princ (format "| %-20s | %-7s | %-8s | %-10s | %-7s | %-10s|\n"
                   "Token Role" "Hex" "Chroma C*" "C* Ceiling" "Y_wet/Y" "Status"))
    (princ (format "+----------------------+---------+-----------+------------+---------+-----------+\n"))
    (dolist (tok tokens)
      (let* ((name (nth 0 tok))
             (key  (nth 1 tok))
             (max-c (nth 2 tok))
             (hex (plist-get pal key))
             (y   (rf-luminance-y hex))
             (c   (rf-cielab-chroma hex))
             ;; Lekner & Dorf (1988) wetting darkening factor:
             ;; R_wet = (1 - r_wa) R_dry / (1 - r_wa R_dry)
             (y-wet (/ (* (- 1.0 r-wa) y) (max 1e-6 (- 1.0 (* r-wa y)))))
             (ratio (if (> y 1e-6) (/ y-wet y) 0.0))
             (ok  (<= c max-c)))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "| %-20s | %-7s | %9.2f | <= %5.1f   | %7.3f |  %s  |\n"
                       name hex c max-c ratio
                       (if ok "ORGANIC" "HYPER-SAT")))))
    (princ (format "+----------------------+---------+-----------+------------+---------+-----------+\n"))
    (princ (format "\n=================================================================================\n"))
    (princ (format "Organic Gamut & Wetting Optics Summary: %d Organic, %d Hyper-saturated.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-wet-surface-physics-run)
    (kill-emacs 1)))

(provide 'test-wet-surface-physics)
;;; test-wet-surface-physics.el ends here
