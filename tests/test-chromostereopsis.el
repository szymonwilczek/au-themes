;;; test-chromostereopsis.el --- Chromostereopsis and binocular chromatic dispersion -*- lexical-binding: t -*-

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
;; Evaluate chromostereopsis and binocular chromatic dispersion.
;;
;; Ref:
;; - Thibos et al. (1990, 1992)
;; - Vos (1960)
;; - Simonet & Campbell (1990)

;;; Code:

(require 'test-palette-extractor)

(defun test-chromostereopsis-run ()
  "Evaluate chromostereopsis and binocular chromatic dispersion per Thibos (1992)."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (passes 0)
         (fails 0)
         ;; Pupil entrance decentration relative to visual axis h = 0.5 mm = 0.0005 m (Thibos 1990, Vos 1960)
         (pupil-decentration-h 0.0005)
         ;; Conversion factor: radians to arcmin = (180 / pi) * 60 ~= 3437.7468 arcmin/rad
         (rad-to-arcmin (* (/ 180.0 float-pi) 60.0))
         ;; Max allowable binocular retinal disparity: 0.60 arcmin (limits disturbing pseudo-depth illusions)
         (max-allowed-tca 0.600)
         (pairs '(("Alert / Error vs Function Def"      :err          :fnname)
                  ("Alert / Error vs Function Call"     :err          :fnname-call)
                  ("Alert / Error vs Preprocessor"      :err          :preprocessor)
                  ("Constants vs Function Def"          :constant     :fnname)
                  ("Constants vs Keyword"               :constant     :keyword)
                  ("Numbers vs Function Def"            :number       :fnname)
                  ("Strings vs Function Def"            :string       :fnname)
                  ("Builtins vs Function Def"           :builtin      :fnname)
                  ("Alert / Error vs Keyword"           :err          :keyword)
                  ("Alert / Error vs Base Text"         :err          :fg-main)
                  ("Preprocessor vs Keyword"            :preprocessor :keyword))))
    (princ (format "\n======================================================================\n"))
    (princ (format " Chromostereopsis & Transverse Chromatic Aberration (TCA) Suite\n"))
    (princ (format " Ref: Thibos et al. (1990, 1992); Vos (1960); Simonet & Campbell (1990)\n"))
    (princ (format " Model: Retinal disparity TCA = h * Delta-D (pupil decentration h = 0.5 mm)\n"))
    (princ (format " Gate: TCA Disparity <= %.2f' arcmin (Threshold for disturbing depth illusion)\n" max-allowed-tca))
    (princ (format " Theme: %s\n" theme))
    (princ (format "======================================================================\n"))
    (princ (format "%-33s | %-19s | %-19s | %-8s | %-9s | %-8s\n"
                   "Interacting Syntax Pair" "Role 1 (Hex, Wave)" "Role 2 (Hex, Wave)" "Delta-D" "TCA Disp" "Status"))
    (princ (format "----------------------------------+---------------------+---------------------+----------+-----------+----------\n"))
    (dolist (p pairs)
      (let* ((label (nth 0 p))
             (k1 (nth 1 p))
             (k2 (nth 2 p))
             (c1 (plist-get pal k1))
             (c2 (plist-get pal k2))
             (w1 (rf-effective-wavelength c1))
             (w2 (rf-effective-wavelength c2))
             (d1 (rf-thibos-diopters c1))
             (d2 (rf-thibos-diopters c2))
             (delta-d (abs (- d1 d2)))
             ;; Retinal disparity in arcmin: TCA = h * Delta-D * rad-to-arcmin
             (tca-arcmin (* pupil-decentration-h delta-d rad-to-arcmin))
             (ok (<= tca-arcmin max-allowed-tca)))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "%-33s | %-7s (%5.1fnm) | %-7s (%5.1fnm) | %6.3fD  | %6.3f'   | %s\n"
                       label c1 w1 c2 w2 delta-d tca-arcmin
                       (if ok "PASS" "FAIL")))))
    (princ (format "----------------------------------+---------------------+---------------------+----------+-----------+----------\n"))
    (princ (format "Chromostereopsis Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-chromostereopsis-run)
    (kill-emacs 1)))

(provide 'test-chromostereopsis)
;;; test-chromostereopsis.el ends here
