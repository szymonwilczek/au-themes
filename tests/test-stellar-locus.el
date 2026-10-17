;;; test-stellar-locus.el --- Stellar roles on the Planckian locus in spectral sequence -*- lexical-binding: t -*-

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
;; Evaluate the stellar syntax roles of the perseida family against the
;; colour of the stars they are named after.
;;
;; Scope:
;; Applies exclusively to the star-sky family (currently `perseida').
;; Other themes are skipped, since their roles do not stand for stars.
;;
;; Seven syntax roles stand for seven stars of the August sky:
;;
;;   fnname-call  Algol A (beta Per)    12550 K   Kolbas et al. (2015)
;;   constant     Vega (alpha Lyr)       9640 K   Smalley (2005)
;;   fnname       Mirfak (alpha Per)     6350 K   Lyubimkov et al. (2010)
;;   keyword      Polaris (alpha UMi)    6017 K   Usenko et al. (2016)
;;   number       Capella (alpha Aur)    4970-5730 K (Aa, Ab)  Torres et al. (2015)
;;   type         Arcturus (alpha Boo)   4286 K   Ramirez & Allende Prieto (2011)
;;   string       Antares (alpha Sco)    3660 K   Ohnaka et al. (2013)
;;
;; A star's colour is close to that of a black body at its effective
;; temperature (Harre & Heller 2021), but drawn at its true chromaticity
;; nearly every star in the list falls within one Oklab JND of the
;; display white and the roles could not be told apart.  The module
;; therefore checks the properties that survive a saturation stretch
;; along the locus, rather than the chromaticity itself:
;;
;;  1. Locus: each role lies on the Planckian locus, |Duv| <= 0.010
;;     in the CIE 1960 UCS (Ohno 2014).
;;  2. Sequence: the roles' correlated colour temperatures (CCT) rank
;;     in the same order as the stars' effective temperatures.
;;  3. White side: each role is bluer than the display white (D65)
;;     exactly when its star is hotter than the white's CCT, so a star
;;     cooler than the adapting white is never drawn bluish and vice
;;     versa.
;;
;; The Planckian locus is integrated from Planck's law with
;; c2 = 1.4388e-2 m K over the CIE 1931 2-degree colour-matching
;; functions (CIE 015:2018), and CCT is the temperature of the nearest
;; locus point in the CIE 1960 (u, v) diagram, found on a 0.5 mired
;; grid and refined parabolically.  The computation is checked against
;; CIE illuminant A (x, y) = (0.44757, 0.40745), a Planckian radiator
;; at 2856 K, and against the CCT of D65 (6504 K) before any role is
;; evaluated.
;;
;; Basis: Planck's law, the colour-matching functions and the CCT/Duv
;; definitions are CIE 015:2018; the stellar temperatures are the
;; published measurements above.  The 0.010 Duv tolerance (about 1.7x
;; the ANSI C78.377 white-light tolerance of 0.006) and the use of a
;; saturation stretch are au-themes heuristics.
;;
;; Ref:
;; CIE 015:2018 Colorimetry, 4th ed., DOI: 10.25039/TR.015.2018.
;; Ohno (2014) LEUKOS 10(1):47-55, DOI: 10.1080/15502724.2014.839020.
;; Harre & Heller (2021) Astron. Nachr. 342:578, arXiv:2101.06254.
;; Kolbas et al. (2015) MNRAS 451:4150, arXiv:1506.01254 (Algol A).
;; Smalley (2005) Mem. S.A.It. Suppl. 8:130, arXiv:astro-ph/0509535 (Vega).
;; Lyubimkov et al. (2010) MNRAS 402:1369, arXiv:0911.1335 (Mirfak).
;; Usenko et al. (2016) Odessa Astron. Publ. 29, arXiv:1610.03813 (Polaris).
;; Torres et al. (2015) ApJ 807:26, DOI: 10.1088/0004-637X/807/1/26 (Capella).
;; Ramirez & Allende Prieto (2011) ApJ 743:135, arXiv:1109.4425 (Arcturus).
;; Ohnaka et al. (2013) A&A 555:A24, arXiv:1304.4800 (Antares).

;;; Code:

(require 'test-palette-extractor)

(defconst rf-planck-c2 1.4388e-2
  "Second radiation constant c2 in m K, as CIE 015:2018 prescribes.")

(defconst rf-duv-tolerance 0.010
  "Largest |Duv| a stellar role may have; au-themes heuristic.")

(defconst rf-stellar-roles
  '((:fnname-call "Algol A"   12550.0 12550.0)
    (:constant    "Vega"       9640.0  9640.0)
    (:fnname      "Mirfak"     6350.0  6350.0)
    (:keyword     "Polaris"    6017.0  6017.0)
    (:number      "Capella"    4970.0  5730.0)
    (:type        "Arcturus"   4286.0  4286.0)
    (:string      "Antares"    3660.0  3660.0))
  "Stellar roles as (KEY STAR TEFF-MIN TEFF-MAX), hottest first.
Capella is an unresolved pair, so it carries the range of its two
components.")

(defun rf-xyz-to-uv1960 (xyz)
  "Return CIE 1960 UCS (u v) of tristimulus XYZ."
  (let* ((x (nth 0 xyz)) (y (nth 1 xyz)) (z (nth 2 xyz))
         (d (+ x (* 15.0 y) (* 3.0 z))))
    (list (/ (* 4.0 x) d) (/ (* 6.0 y) d))))

(defun rf-planck-xyz (temp)
  "Return CIE 1931 XYZ (arbitrary scale) of a black body at TEMP kelvin."
  (let ((x 0.0) (y 0.0) (z 0.0))
    (dotimes (i rf-spectral-samples)
      (let* ((lam (* (rf--spectral-lambda i) 1e-9))
             (m (/ (expt lam -5.0) (- (exp (/ rf-planck-c2 (* lam temp))) 1.0))))
        (setq x (+ x (* m (aref rf-cie1931-xbar i)))
              y (+ y (* m (aref rf-cie1931-ybar i)))
              z (+ z (* m (aref rf-cie1931-zbar i))))))
    (list x y z)))

(defvar rf--planck-locus-table nil
  "Vector of (MIRED U V) on a 0.5 mired grid, built on first use.")

(defun rf-planck-locus-table ()
  "Return the Planckian locus table, computing it once."
  (or rf--planck-locus-table
      (setq rf--planck-locus-table
            (vconcat
             (cl-loop for mired from 10.0 to 1000.0 by 0.5
                      collect (cons mired
                                    (rf-xyz-to-uv1960
                                     (rf-planck-xyz (/ 1e6 mired)))))))))

(defun rf-uv-cct-duv (uv)
  "Return (CCT DUV) of chromaticity UV, CIE 1960 (u v).
CCT is the temperature of the nearest Planckian locus point, refined
by a parabola through the three nearest grid points; DUV is the signed
distance to the locus, positive above it."
  (let* ((table (rf-planck-locus-table))
         (n (length table))
         (dist (lambda (i)
                 (let ((p (aref table i)))
                   (sqrt (+ (expt (- (car uv) (nth 1 p)) 2)
                            (expt (- (cadr uv) (nth 2 p)) 2))))))
         (best 0)
         (best-d (funcall dist 0)))
    (cl-loop for i from 1 below n
             for d = (funcall dist i)
             when (< d best-d) do (setq best i best-d d))
    (let* ((i (min (max best 1) (- n 2)))
           (d0 (funcall dist (1- i)))
           (d1 (funcall dist i))
           (d2 (funcall dist (1+ i)))
           (denom (+ d0 (* -2.0 d1) d2))
           (shift (if (> (abs denom) 1e-15) (/ (* 0.5 (- d0 d2)) denom) 0.0))
           (mired (+ (car (aref table i)) (* 0.5 shift)))
           (p (rf-xyz-to-uv1960 (rf-planck-xyz (/ 1e6 mired))))
           (dv (- (cadr uv) (cadr p)))
           (dmin (sqrt (+ (expt (- (car uv) (car p)) 2) (expt dv 2)))))
      (list (/ 1e6 mired) (if (< dv 0.0) (- dmin) dmin)))))

(defun rf-hex-cct-duv (hex)
  "Return (CCT DUV) of HEX under the sRGB/D65 model."
  (rf-uv-cct-duv (rf-xyz-to-uv1960 (rf-hex-to-xyz hex))))

(defun rf-planck-self-check ()
  "Verify the locus against CIE illuminant A and the CCT of D65.
Signal an error when illuminant A (2856 K) misses its published (x, y)
by more than 0.0005 or when the sRGB white is not within 10 K of 6504 K."
  (let* ((xyz (rf-planck-xyz 2856.0))
         (s (apply #'+ xyz))
         (x (/ (nth 0 xyz) s))
         (y (/ (nth 1 xyz) s))
         (white (car (rf-hex-cct-duv "#ffffff"))))
    (when (or (> (abs (- x 0.44757)) 0.0005) (> (abs (- y 0.40745)) 0.0005))
      (error "Planckian locus: illuminant A at (%.5f, %.5f), CIE gives (0.44757, 0.40745)"
             x y))
    (when (> (abs (- white 6504.0)) 10.0)
      (error "Planckian locus: CCT of D65 white = %.0f K, expected 6504 K" white))
    white))

(defun test-stellar-locus-run ()
  "Evaluate stellar roles against the Planckian locus and the spectral sequence.
Applies exclusively to the star-sky family (currently `perseida')."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (passes 0)
         (fails 0))
    (princ (format "\n.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.\n"))
    (princ (format "| Stellar Planckian Locus and Spectral Sequence Suite\n"))
    (princ (format "| Theme: %s\n" theme))
    (princ (format "| Scope: Star-sky themes only (currently perseida family)\n"))
    (princ (format "'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'\n"))
    (if (not (string-match-p "perseida" (symbol-name theme)))
        (progn
          (princ "\n[SKIP]  The stellar locus applies exclusively to star-sky\n\tthemes (perseida family).\n")
          (princ (format "\n======================================================================================\n"))
          (princ "Stellar Locus Summary: skipped (not a star-sky theme).\n\n")
          'skip)
      (let* ((white-cct (rf-planck-self-check))
             (rows (mapcar (lambda (r)
                             (let ((hex (plist-get pal (nth 0 r))))
                               (append r (list hex) (rf-hex-cct-duv hex))))
                           rf-stellar-roles)))
        (princ (format "\nDisplay white (D65) CCT: %.0f K; illuminant A self-check passed.\n" white-cct))
        (princ (format "\n+--------------+----------+-------------+---------+----------+---------+--------+--------+\n"))
        (princ (format "| %-12s | %-8s | %-11s | %-7s | %-8s | %-7s | %-6s | %-6s |\n"
                       "Role" "Star" "Teff (K)" "Hex" "CCT (K)" "Duv" "Locus" "Side"))
        (princ (format "+--------------+----------+-------------+---------+----------+---------+--------+--------+\n"))
        (dolist (row rows)
          (let* ((key (nth 0 row))
                 (star (nth 1 row))
                 (t-lo (nth 2 row))
                 (t-hi (nth 3 row))
                 (hex (nth 4 row))
                 (cct (nth 5 row))
                 (duv (nth 6 row))
                 (locus-ok (<= (abs duv) rf-duv-tolerance))
                 (side-ok (cond ((> t-lo white-cct) (> cct white-cct))
                                ((< t-hi white-cct) (< cct white-cct))
                                (t t))))
            (setq passes (+ passes (if locus-ok 1 0) (if side-ok 1 0))
                  fails (+ fails (if locus-ok 0 1) (if side-ok 0 1)))
            (princ (format "| %-12s | %-8s | %-11s | %-7s | %8.0f | %+7.4f | %-6s | %-6s |\n"
                           (substring (symbol-name key) 1) star
                           (if (= t-lo t-hi) (format "%.0f" t-lo) (format "%.0f-%.0f" t-lo t-hi))
                           hex cct duv
                           (if locus-ok "PASS" "FAIL") (if side-ok "PASS" "FAIL")))))
        (princ (format "+--------------+----------+-------------+---------+----------+---------+--------+--------+\n"))

        (princ "\nSpectral Sequence (CCT ranks as Teff, hottest star first):\n")
        (cl-loop for (a b) on rows while b do
                 (let ((ok (> (nth 5 a) (nth 5 b))))
                   (if ok
                       (setq passes (1+ passes))
                     (setq fails (1+ fails)))
                   (princ (format "[%s]  %-8s (%5.0f K) above %-8s (%5.0f K)\n"
                                  (if ok "PASS" "FAIL")
                                  (nth 1 a) (nth 5 a) (nth 1 b) (nth 5 b)))))

        (princ (format "\n======================================================================================\n"))
        (princ (format "Stellar Locus Summary: %d Passed, %d Failed.\n\n" passes fails))
        (zerop fails)))))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-stellar-locus-run)
    (kill-emacs 1)))

(provide 'test-stellar-locus)
;;; test-stellar-locus.el ends here
