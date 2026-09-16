;;; test-tonic-accommodation-dark-focus.el --- Tonic Accommodation and Dark Focus Anchoring -*- lexical-binding: t -*-

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
;; Evaluate ciliary muscle tonic accommodation anchoring and dark focus
;; prevention.
;; In dark rooms with astigmatism/photophobia, lack of crisp edge contrast
;; causes the ciliary muscle to relax into tonic dark focus (resting point
;; ~80-100cm instead of screen 50-60cm).
;; High-frequency edge contrast on fg-main must provide an unambiguous
;; accommodation lock.
;;
;; Ref:
;; - Leibowitz & Owens (1978) Science
;; - Charman (1982) OPO
;; - Heath (1956) JOSA

;;; Code:

(require 'test-palette-extractor)

(defun test-tonic-accommodation-dark-focus-run ()
  "Evaluate ciliary muscle tonic accommodation anchoring and dark focus prevention."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (polarity (rf-theme-polarity theme))
         (bg (plist-get pal :bg-main))
         (fg (plist-get pal :fg-main))
         (bg-y (rf-luminance-y bg))
         (fg-y (rf-luminance-y fg))
         (passes 0)
         (fails 0)
         (apca-lc (abs (rf-apca-contrast fg bg)))
         (denom (+ fg-y bg-y))
         (michelson (if (< denom 1e-9) 0.0 (/ (abs (- fg-y bg-y)) denom)))
         ;; Spatial frequency energy in glyph edge: Michelson contrast * peak stroke luminance
         (edge-energy (* michelson (max fg-y bg-y))))

    (princ (format "\n.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.\n"))
    (princ (format "| Tonic Accommodation & Dark Focus Anchoring Suite\n"))
    (princ (format "| Theme: %s (%s) | Canvas: %s | Base Text: %s\n" theme polarity bg fg))
    (princ (format "'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'\n"))

    (princ "\nEdge Energy Gradient (Spatial Frequency Stimulus):\n")
    (princ (format "--------------------------------------------------------------------\n"))
    (let* ((min-energy (if (eq polarity 'light) 0.200 0.150))
           (energy-ok (>= edge-energy min-energy)))
      (if energy-ok
          (progn
            (princ (format "[PASS]  Edge Energy E_hf = %.4f >= %.3f:\n\tAnchors ciliary muscle at 50-60cm screen plane.\n"
                           edge-energy min-energy))
            (setq passes (1+ passes)))
        (princ (format "[FAIL]  Edge Energy E_hf = %.4f < %.3f:\n\tInsufficient stimulus; eyes drift into dark focus (~1.5 D, ~67cm).\n"
                       edge-energy min-energy))
        (setq fails (1+ fails))))

    (princ "\nAPCA Base Text Legibility Contrast:\n")
    (princ (format "--------------------------------------------------------------------\n"))
    (let* ((min-lc (if (eq polarity 'light)
                       (if (< bg-y 0.420) 48.0 58.0)
                     45.0))
           (lc-ok (>= apca-lc min-lc)))
      (if lc-ok
          (progn
            (princ (format "[PASS]  Base Text APCA |Lc| = %.1f >= %.1f:\n\tCrisp foveal micro-edge acuity.\n"
                           apca-lc min-lc))
            (setq passes (1+ passes)))
        (princ (format "[FAIL]  Base Text APCA |Lc| = %.1f < %.1f:\n\tFuzzy, indistinct letter edges in darkness.\n"
                       apca-lc min-lc))
        (setq fails (1+ fails))))

    (princ "\nMichelson Edge Contrast Gradient (C_M >= 0.85):\n")
    (princ (format "--------------------------------------------------------------------\n"))
    (let* ((min-cm (if (eq polarity 'light) 0.85 0.90))
           (cm-ok (>= michelson min-cm)))
      (if cm-ok
          (progn
            (princ (format "[PASS]  Michelson Contrast C_M = %.4f >= %.2f:\n\tEliminates twilight myopia hunting.\n"
                           michelson min-cm))
            (setq passes (1+ passes)))
        (princ (format "[FAIL]  Michelson Contrast C_M = %.4f < %.2f:\n\tWeak gradient triggers accommodation oscillation.\n"
                       michelson min-cm))
        (setq fails (1+ fails))))

    (princ (format "\n====================================================================\n"))
    (princ (format "Tonic Accommodation Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-tonic-accommodation-dark-focus-run)
    (kill-emacs 1)))

(provide 'test-tonic-accommodation-dark-focus)
;;; test-tonic-accommodation-dark-focus.el ends here
