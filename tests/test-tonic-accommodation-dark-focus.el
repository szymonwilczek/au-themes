;;; test-tonic-accommodation-dark-focus.el --- Tonic Accommodation & Dark Focus Anchoring -*- lexical-binding: t; -*-

(require 'test-palette-extractor)

(defun test-tonic-accommodation-dark-focus-run ()
  "Evaluate ciliary muscle tonic accommodation anchoring and dark focus prevention.
In dark rooms with astigmatism/photophobia, lack of crisp edge contrast causes the ciliary
muscle to relax into tonic dark focus (resting point ~80-100cm instead of screen 50-60cm).
High-frequency edge contrast on fg-main must provide an unambiguous accommodation lock.
Ref: Leibowitz & Owens (1978) Science; Charman (1982) OPO; Heath (1956) JOSA."
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

    (princ (format "\n======================================================================\n"))
    (princ (format " Tonic Accommodation & Dark Focus Anchoring Suite\n"))
    (princ (format " Ref: Leibowitz & Owens (1978) Science; Charman (1982)\n"))
    (princ (format " Theme: %s (%s) | Canvas: %s | Base Text: %s\n" theme polarity bg fg))
    (princ (format "======================================================================\n"))

    ;; Part 1: High Spatial Frequency Edge Energy Gate
    (princ "\nPart 1: Edge Energy Gradient (Spatial Frequency Stimulus):\n")
    (let* ((min-energy (if (eq polarity 'light) 0.200 0.150))
           (energy-ok (>= edge-energy min-energy)))
      (if energy-ok
          (progn
            (princ (format "   [PASS] Edge Energy E_hf = %.4f >= %.3f: Anchors ciliary muscle at 50-60cm screen plane.\n"
                           edge-energy min-energy))
            (setq passes (1+ passes)))
        (princ (format "   [FAIL] Edge Energy E_hf = %.4f < %.3f: Insufficient stimulus; eyes drift into dark focus (~1.5 D, ~67cm).\n"
                       edge-energy min-energy))
        (setq fails (1+ fails))))

    ;; Part 2: APCA Base Text Readability Contrast Gate
    (princ "\nPart 2: APCA Base Text Legibility Contrast:\n")
    (let* ((min-lc (if (eq polarity 'light) 58.0 45.0))
           (lc-ok (>= apca-lc min-lc)))
      (if lc-ok
          (progn
            (princ (format "   [PASS] Base Text APCA |Lc| = %.1f >= %.1f: Crisp foveal micro-edge acuity.\n"
                           apca-lc min-lc))
            (setq passes (1+ passes)))
        (princ (format "   [FAIL] Base Text APCA |Lc| = %.1f < %.1f: Fuzzy, indistinct letter edges in darkness.\n"
                           apca-lc min-lc))
        (setq fails (1+ fails))))

    ;; Part 3: Ciliary Rest State Prevention (Michelson >= 0.85)
    (princ "\nPart 3: Michelson Edge Contrast Gradient (C_M >= 0.85):\n")
    (let* ((min-cm (if (eq polarity 'light) 0.85 0.90))
           (cm-ok (>= michelson min-cm)))
      (if cm-ok
          (progn
            (princ (format "   [PASS] Michelson Contrast C_M = %.4f >= %.2f: Eliminates twilight myopia hunting.\n"
                           michelson min-cm))
            (setq passes (1+ passes)))
        (princ (format "   [FAIL] Michelson Contrast C_M = %.4f < %.2f: Weak gradient triggers accommodation oscillation.\n"
                       michelson min-cm))
        (setq fails (1+ fails))))

    (princ (format "\n----------------------------------------------------------------------\n"))
    (princ (format "Tonic Accommodation Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-tonic-accommodation-dark-focus-run)
    (kill-emacs 1)))

(provide 'test-tonic-accommodation-dark-focus)
;;; test-tonic-accommodation-dark-focus.el ends here
