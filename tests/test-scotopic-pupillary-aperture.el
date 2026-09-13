;;; test-scotopic-pupillary-aperture.el --- Stiles-Crawford Effect & Scopic Load Ratio -*- lexical-binding: t; -*-

(require 'test-palette-extractor)

(defun test-scotopic-pupillary-aperture-run ()
  "Evaluate Stiles-Crawford effect (SCE-I) and 80x40 viewport Scopic Load Ratio.
In dark rooms with wide pupils (6.5-7.5mm), peripheral rays cause spherical aberrations.
In ASD, prolonged pupillary latency impairs light constriction. Viewport total energy
must not cross the photopic activation threshold (~10 cd/m2 on 100 cd/m2 displays).
Ref: Stiles & Crawford (1933) Proc. R. Soc.; Fan & Yao (2011) Autism Res.; Westheimer (1967)."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (polarity (rf-theme-polarity theme))
         (bg (plist-get pal :bg-main))
         (bg-y (rf-luminance-y bg))
         (hl-y (rf-luminance-y (plist-get pal :bg-hl-line)))
         (passes 0)
         (fails 0)
         ;; Standard 80x40 viewport with ~20% typographic ink coverage
         (mean-viewport-y (rf-viewport-mean-luminance-y pal))
         ;; Reference 80 cd/m2 white display calibration
         (mean-viewport-cd (* mean-viewport-y rf-display-white-luminance)))

    (princ (format "\n======================================================================\n"))
    (princ (format " Stiles-Crawford (SCE-I) & Viewport Scopic Load Ratio Suite\n"))
    (princ (format " Ref: Stiles & Crawford (1933); CIE 191:2010; Fan & Yao (2011)\n"))
    (princ (format " Theme: %s (%s) | Background: %s (Y_bg: %.6f)\n" theme polarity bg bg-y))
    (princ (format " Model: 80x40 Viewport (3200 cells, 20%% glyph ink fill, White: %.0f cd/m2)\n"
                   rf-display-white-luminance))
    (princ (format "======================================================================\n"))

    ;; Part 1: Viewport Total Photonic Emission
    (princ "\nPart 1: 80x40 Viewport Scopic Load & Photopic Threshold Check:\n")
    (if (eq polarity 'dark)
        (let* ((max-mesopic-cd 5.0) ; CIE 191:2010 mesopic/photopic transition threshold
               (max-mean-y (/ max-mesopic-cd rf-display-white-luminance))
               (ok (<= mean-viewport-cd max-mesopic-cd)))
          (if ok
              (progn
                (princ (format "   [PASS] Mean Viewport Lum = %.2f cd/m2 (Y=%.4f) <= %.1f cd/m2: Safely in soothing mesopic range.\n"
                               mean-viewport-cd mean-viewport-y max-mesopic-cd))
                (setq passes (1+ passes)))
            (princ (format "   [FAIL] Mean Viewport Lum = %.2f cd/m2 (Y=%.4f) > %.1f cd/m2: Enters photopic glare range in dark ambient.\n"
                           mean-viewport-cd mean-viewport-y max-mesopic-cd))
            (setq fails (1+ fails))))
      ;; Daylight mode
      (let* ((max-mean-y 0.750)
             (ok (<= mean-viewport-y max-mean-y)))
        (if ok
            (progn
              (princ (format "   [PASS] Daylight Viewport Lum = %.2f cd/m2 (Y=%.4f) <= %.3f: Soft canopy daylight.\n"
                             mean-viewport-cd mean-viewport-y max-mean-y))
              (setq passes (1+ passes)))
          (princ (format "   [FAIL] Daylight Viewport Lum Y = %.4f > %.3f: Blinding daylight glare.\n"
                         mean-viewport-y max-mean-y))
          (setq fails (1+ fails)))))

    ;; Part 2: Stiles-Crawford Marginal Pupil Aberration Attenuation
    (princ "\nPart 2: Stiles-Crawford Directional Sensitivity (SCE-I) at Pupil Margin:\n")
    (let* ((pupil-diam (rf-pupil-diameter
                        (+ (* mean-viewport-y rf-display-white-luminance)
                           rf-reference-veiling-glare)))
           (pupil-radius (/ pupil-diam 2.0))
           ;; Stiles-Crawford directional sensitivity formula: eta(r) = 10^(-rho * r_max^2)
           ;; with rho ~ 0.05 mm^-2 and peak decentration x0 ~ 0.5 mm nasal (Rynders et al. 1995).
           (rho 0.05)
           (x0 0.50)
           (r-max (+ pupil-radius x0))
           (eta-margin (expt 10.0 (* (- rho) r-max r-max)))
           (ok (>= eta-margin 0.30)))
      (if ok
          (progn
            (princ (format "   [PASS] Pupil r = %.2f mm (r_max = %.2f mm with nasal offset), Marginal SCE-I eta = %.3f >= 0.300.\n"
                           pupil-radius r-max eta-margin))
            (princ "          Peripheral rays attenuated by photoreceptor directional tuning, containing aberrations.\n")
            (setq passes (1+ passes)))
        (princ (format "   [FAIL] Marginal SCE-I eta = %.3f < 0.300: High peripheral ray degradation.\n"
                       eta-margin))
        (setq fails (1+ fails))))

    ;; Part 3: Minibuffer & Window Chrome Balance
    (princ "\nPart 3: UI Chrome Energy Balance (hl-line to background):\n")
    (let* ((hl-ratio (/ (max 0.0001 hl-y) (max 0.0001 bg-y)))
           (ok (if (eq polarity 'light) (<= hl-ratio 1.5) (<= hl-ratio 5.0))))
      (if ok
          (progn
            (princ (format "   [PASS] hl-line / bg-main ratio = %.2f: Chrome is subtle, non-disruptive to scopic balance.\n"
                           hl-ratio))
            (setq passes (1+ passes)))
        (princ (format "   [FAIL] hl-line / bg-main ratio = %.2f: Chrome creates excessive photonic spike.\n"
                       hl-ratio))
        (setq fails (1+ fails))))

    (princ (format "\n----------------------------------------------------------------------\n"))
    (princ (format "Stiles-Crawford Scopic Load Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-scotopic-pupillary-aperture-run)
    (kill-emacs 1)))

(provide 'test-scotopic-pupillary-aperture)
;;; test-scotopic-pupillary-aperture.el ends here
