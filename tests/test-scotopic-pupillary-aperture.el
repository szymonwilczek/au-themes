;;; test-scotopic-pupillary-aperture.el --- Stiles-Crawford Effect & Scopic Load Ratio -*- lexical-binding: t; -*-

(require 'test-palette-extractor)

(defun test-scotopic-pupillary-aperture-run ()
  "Evaluate Stiles-Crawford effect (SCE-I) and 80x40 viewport Scopic Load Ratio.
In dark rooms with wide pupils (6.5-7.5mm), peripheral rays cause spherical aberrations.
In ASD, prolonged pupillary latency impairs light constriction. Viewport total energy
must not cross the photopic activation threshold (~10 cd/m2 on 100 cd/m2 displays).
Ref: Stiles & Crawford (1933) Proc. R. Soc.; Fan & Yao (2011) Autism Res.; Westheimer (1967)."
  (let* ((pal (rainforest-extract-active-palette))
         (theme (plist-get pal :theme))
         (polarity (rf-theme-polarity theme))
         (bg (plist-get pal :bg-main))
         (bg-y (rf-luminance-y bg))
         (hl-y (rf-luminance-y (plist-get pal :bg-hl-line)))
         (passes 0)
         (fails 0)
         ;; Standard 80x40 viewport = 3200 character cells
         (total-cells 3200)
         (code-cells 1050)
         (hl-cells 80)
         (bg-cells (- total-cells code-cells hl-cells))
         (syntax-keys '(:fg-main :keyword :type :property :fnname-call :number :string :constant))
         (syntax-lums (mapcar (lambda (k) (rf-luminance-y (plist-get pal k))) syntax-keys))
         (mean-syntax-y (/ (apply #'+ syntax-lums) (float (length syntax-lums))))
         (total-energy (+ (* code-cells mean-syntax-y)
                          (* hl-cells hl-y)
                          (* bg-cells bg-y)))
         (mean-viewport-y (/ total-energy total-cells))
         ;; Peak 100 cd/m2 monitor calibration
         (mean-viewport-cd (* mean-viewport-y 100.0)))

    (princ (format "\n======================================================================\n"))
    (princ (format " Stiles-Crawford (SCE-I) & Viewport Scopic Load Ratio Suite\n"))
    (princ (format " Ref: Stiles & Crawford (1933); Fan & Yao (2011) Pupillary Latency in ASD\n"))
    (princ (format " Theme: %s (%s) | Background: %s (Y_bg: %.6f)\n" theme polarity bg bg-y))
    (princ (format " Model: 80x40 Viewport (3200 cells: 1050 code, 80 hl-line, 2070 bg)\n"))
    (princ (format "======================================================================\n"))

    ;; Part 1: Viewport Total Photonic Emission
    (princ "\nPart 1: 80x40 Viewport Scopic Load & Photopic Threshold Check:\n")
    (if (eq polarity 'dark)
        (let* ((max-mean-y 0.100) ; 10 cd/m2 scotopic/mesopic boundary
               (ok (<= mean-viewport-y max-mean-y)))
          (if ok
              (progn
                (princ (format "   [PASS] Mean Viewport Lum Y = %.4f (%.2f cd/m2) <= %.3f: Stays safely below photopic saturation.\n"
                               mean-viewport-y mean-viewport-cd max-mean-y))
                (setq passes (1+ passes)))
            (princ (format "   [FAIL] Mean Viewport Lum Y = %.4f (%.2f cd/m2) > %.3f: Overwhelms dark-adapted retina in ASD.\n"
                           mean-viewport-y mean-viewport-cd max-mean-y))
            (setq fails (1+ fails))))
      ;; Daylight mode
      (let* ((max-mean-y 0.750)
             (ok (<= mean-viewport-y max-mean-y)))
        (if ok
            (progn
              (princ (format "   [PASS] Daylight Viewport Lum Y = %.4f (%.2f cd/m2) <= %.3f: Soft canopy daylight.\n"
                             mean-viewport-y mean-viewport-cd max-mean-y))
              (setq passes (1+ passes)))
          (princ (format "   [FAIL] Daylight Viewport Lum Y = %.4f > %.3f: Blinding daylight glare.\n"
                         mean-viewport-y max-mean-y))
          (setq fails (1+ fails)))))

    ;; Part 2: Stiles-Crawford Marginal Pupil Aberration Attenuation
    (princ "\nPart 2: Stiles-Crawford Directional Sensitivity (SCE-I) at Pupil Margin:\n")
    (let* ((ambient-cd (if (eq polarity 'light) 50.0 1.5))
           (pupil-diam (rf-pupil-diameter (+ (* bg-y 100.0) ambient-cd)))
           (pupil-radius (/ pupil-diam 2.0))
           ;; Stiles-Crawford directional sensitivity formula: eta(r) = 10^(-rho * r^2) with rho ~ 0.05
           (rho 0.05)
           (eta-margin (expt 10.0 (* (- rho) pupil-radius pupil-radius)))
           (ok (>= eta-margin 0.30)))
      (if ok
          (progn
            (princ (format "   [PASS] Pupil r = %.2f mm, Marginal SCE-I eta = %.3f >= 0.300: Controlled peripheral aberration.\n"
                           pupil-radius eta-margin))
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
