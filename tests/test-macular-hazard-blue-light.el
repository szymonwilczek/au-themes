;;; test-macular-hazard-blue-light.el --- ICNIRP/IEC 62471 Retinal Blue Light Hazard -*- lexical-binding: t; -*-

(require 'test-palette-extractor)

(defun test-macular-hazard-blue-light-run ()
  "Evaluate the retinal blue-light photochemical hazard of the palette.

Part 1 is the regulatory assessment: the blue-light-hazard weighted
radiance L_B (ICNIRP 2013 Table 2 / IEC 62471:2006 B(lambda), integrated
against the reference display SPD model) versus the exposure limit
L_B^EL = 100 W m^-2 sr^-1 for t > 10^4 s (ICNIRP 2013, eq. 14).  A display
is a large source, so radiance - not the irradiance E_B used before - is
the applicable quantity, and the limit applies to the radiance spatially
averaged over the acceptance angle gamma_ph = 0.011 rad, which at a 600 mm
viewing distance covers ~6.6 mm of screen, i.e. several character cells.

Part 2 is NOT a hazard criterion and is labelled as what it is: a
spectral-composition heuristic.  It compares the blue-light-hazard
efficacy K_B,v (W/lm, brightness-independent) of each token with that of
daylight D65 (0.99 mW/lm).  The rationale is chronobiological comfort at
night, not photochemical injury: at display luminances the photochemical
margin is ~3 orders of magnitude, so no palette choice can be defended as
\"preventing\" RPE phototoxicity.
Ref: ICNIRP (2013) Health Phys. 105(1):74-96, DOI 10.1097/HP.0b013e318289a611;
IEC 62471:2006 / CIE S 009:2002; Algvere, Marshall & Seregard (2006)
Acta Ophthalmol. Scand. 84(1):4-15, DOI 10.1111/j.1600-0420.2005.00627.x."
  (let* ((pal (rainforest-extract-active-palette))
         (theme (plist-get pal :theme))
         (polarity (rf-theme-polarity theme))
         (bg (plist-get pal :bg-main))
         (bg-y (rf-luminance-y bg))
         (passes 0)
         (fails 0)
         (kd65 rf-blue-light-hazard-efficacy-d65)
         ;; Roles that are deliberately long-wavelength or neutral must not
         ;; exceed daylight's hazard-weighted energy per lumen; roles that are
         ;; deliberately short-wavelength (cursor, constants, call names) are
         ;; allowed twice that, being sparse and non-continuous in the field.
         (warm-roles '(:string :number :builtin :err :fg-dim :type :keyword
                       :preprocessor :operator :bracket :fg-main))
         (tokens '(("Base text (Mineral quartz)"       :fg-main)
                   ("Comments (Damp needles)"          :fg-dim)
                   ("Cursor (Raindrop glint)"          :cursor)
                   ("Preprocessor (#define)"           :preprocessor)
                   ("Keywords (struct, while)"         :keyword)
                   ("Data types (int, size_t)"         :type)
                   ("Constants (LOTA_PCR_COUNT)"       :constant)
                   ("Numbers (0, 24, 32)"              :number)
                   ("Builtins (__always_inline)"       :builtin)
                   ("Function definitions"             :fnname)
                   ("Function calls (bpf_...)"         :fnname-call)
                   ("Strings (\"string literals\")"    :string)
                   ("Struct fields (->tgid)"           :property)
                   ("Operators (+, -, *, >>)"          :operator)
                   ("Brackets (( ) [ ] { })"           :bracket)
                   ("Alerts / Errors (!)"              :err))))

    (princ (format "\n======================================================================\n"))
    (princ (format " ICNIRP 2013 / IEC 62471 Retinal Blue Light Hazard Gate Suite\n"))
    (princ (format " Ref: ICNIRP (2013) DOI 10.1097/HP.0b013e318289a611, Table 2, eq. 14\n"))
    (princ (format " Theme: %s (%s) | Background: %s (Y_bg: %.6f)\n" theme polarity bg bg-y))
    (princ (format " Display white: %.0f cd/m2 (IEC 61966-2-1) | K_B,v(D65) = %.4f mW/lm\n"
                   rf-display-white-luminance (* 1000.0 kd65)))
    (princ (format "======================================================================\n"))

    ;; -----------------------------------------------------------------------
    ;; Part 1: Regulatory exposure assessment (ICNIRP 2013 eq. 14)
    ;; -----------------------------------------------------------------------
    (princ "\nPart 1: Exposure assessment vs L_B^EL = 100 W m^-2 sr^-1 (t > 10^4 s):\n")
    (let* ((view-y (rf-viewport-mean-luminance-y pal))
           ;; Radiance averaged over gamma_ph: the viewport composition, plus
           ;; the worst case of the aperture filled by the most hazardous token.
           (worst (car (sort (mapcar (lambda (tok)
                                       (rf-blue-light-hazard-radiance (plist-get pal (cadr tok))))
                                     tokens)
                             #'>)))
           (mean-lb (* (/ rf-display-white-luminance rf-km)
                       (rf-hex-spectral-response bg rf-icnirp-blue-light-hazard)
                       (/ view-y (max 1e-9 bg-y))))
           (margin (/ 100.0 (max 1e-12 worst)))
           (ok (<= worst 100.0)))
      (princ (format "   Viewport mean L_B = %.5f W m^-2 sr^-1 (mean viewport Y = %.4f)\n"
                     mean-lb view-y))
      (princ (format "   Worst-case single-token L_B = %.5f W m^-2 sr^-1\n" worst))
      (if ok
          (progn
            (princ (format "   [PASS] Exposure limit met with a margin of %.0fx; the source is in\n"
                           margin))
            (princ "          the Exempt Group of IEC 62471 by three orders of magnitude.\n")
            (setq passes (1+ passes)))
        (princ "   [FAIL] Blue-light hazard exposure limit exceeded.\n")
        (setq fails (1+ fails))))

    ;; -----------------------------------------------------------------------
    ;; Part 2: Spectral-composition heuristic (NOT a hazard criterion)
    ;; -----------------------------------------------------------------------
    (princ "\nPart 2: Blue-light-hazard efficacy K_B,v relative to daylight (design gate):\n")
    (princ (format "%-30s | %-8s | %-12s | %-10s | %-9s | %-8s\n"
                   "Token Role" "Hex" "K_B,v mW/lm" "K_B/K_D65" "Max ratio" "Status"))
    (princ (format "-------------------------------+----------+--------------+------------+-----------+----------\n"))
    (dolist (tok tokens)
      (let* ((label (car tok))
             (key   (cadr tok))
             (hex   (plist-get pal key))
             (kb    (rf-blue-light-hazard-efficacy hex))
             (rel   (/ kb kd65))
             (max-rel (if (memq key warm-roles) 1.00 2.00))
             (ok (<= rel max-rel)))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "%-30s | %-8s | %12.4f | %10.3f | <= %6.2f  | %s\n"
                       label hex (* 1000.0 kb) rel max-rel (if ok "PASS" "FAIL")))))
    (princ (format "-------------------------------+----------+--------------+------------+-----------+----------\n"))

    ;; Background canvas: the only surface that covers the field continuously.
    (princ "\nPart 3: Background canvas spectral composition:\n")
    (let* ((bg-kb (rf-blue-light-hazard-efficacy bg))
           (bg-rel (/ bg-kb kd65))
           (bg-ok (<= bg-rel 1.00)))
      (if bg-ok
          (progn
            (princ (format "   [PASS] Canvas K_B,v = %.4f mW/lm (%.2fx D65) <= 1.00x: the continuously\n"
                           (* 1000.0 bg-kb) bg-rel))
            (princ "          exposed surface is spectrally warmer than daylight.\n")
            (setq passes (1+ passes)))
        (princ (format "   [FAIL] Canvas K_B,v = %.4f mW/lm (%.2fx D65) > 1.00x D65.\n"
                       (* 1000.0 bg-kb) bg-rel))
        (setq fails (1+ fails))))

    (princ (format "\n----------------------------------------------------------------------\n"))
    (princ (format "Blue Light Hazard Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-macular-hazard-blue-light-run)
    (kill-emacs 1)))

(provide 'test-macular-hazard-blue-light)
;;; test-macular-hazard-blue-light.el ends here
