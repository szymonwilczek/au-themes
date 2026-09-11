;;; test-pupil-aberrations.el --- Pupil dynamics and r^4 wavefront aberration scaling -*- lexical-binding: t; -*-

(require 'test-palette-extractor)

(defun test-pupil-aberrations-run ()
  "Evaluate pupil aperture and higher-order wavefront aberrations per Liang & Williams (1997)."
  (let* ((pal (rainforest-extract-active-palette))
         (bg (plist-get pal :bg-main))
         (theme (plist-get pal :theme))
         ;; Assume typical calibrated desktop display peak white 120 cd/m2
         (y-bg (rf-luminance-y bg))
         (l-bg (* y-bg 120.0)) ; background luminance in cd/m2
         (pupil-diam (rf-pupil-diameter l-bg))
         (aber-factor (rf-wavefront-aberration-factor pupil-diam))
         (passes 0)
         (fails 0)
         (warnings 0))
    (princ (format "\n======================================================================\n"))
    (princ (format " Pupil Dynamics & r^4 Wavefront Aberration Suite\n"))
    (princ (format " Ref: Liang & Williams (1997), DOI: 10.1364/JOSAA.14.002873\n"))
    (princ (format " Ref: Piepenbrock et al. (2013), DOI: 10.1177/0018720813495537\n"))
    (princ (format " Theme: %s | Background: %s\n" theme bg))
    (princ (format "======================================================================\n"))
    (princ (format "Field Physical Luminance (120 cd/m2 peak): %.4f cd/m2\n" l-bg))
    (princ (format "Calculated Steady-State Pupil Diameter:   %.2f mm\n" pupil-diam))
    (princ (format "Higher-Order Wavefront Aberration Factor: %.2fx (vs 4.0mm pupil)\n" aber-factor))
    (princ (format "----------------------------------------------------------------------\n"))

    ;; Test 1: Pupil over-dilation threshold
    (let ((max-d (if (eq (rf-theme-polarity theme) 'light) 4.50 5.50))
          (min-d (if (eq (rf-theme-polarity theme) 'light) 2.00 2.50)))
      (princ (format "1. Safe Pupil Dilation Threshold (d <= %.2f mm):\n" max-d))
      (if (<= pupil-diam max-d)
          (progn
            (princ (format "   [PASS] Pupil (%.2f mm) remains in optimal optical zone (< %.2f mm).\n" pupil-diam max-d))
            (princ "          Astigmatic cylinder defocus and spherical aberration remain contained.\n")
            (setq passes (1+ passes)))
        (princ "   [WARN] Pupil exceeds limit: r^4 scaling increases blur halo.\n")
        (setq warnings (1+ warnings)))

      ;; Test 2: Pupil diffraction limit lower bound
      (princ (format "2. Diffraction Blur Avoidance (d >= %.2f mm):\n" min-d))
      (if (>= pupil-diam min-d)
          (progn
            (princ (format "   [PASS] Above Airy disk diffraction limit (d >= %.2f mm).\n" min-d))
            (setq passes (1+ passes)))
        (princ "   [FAIL] Pupil constricted below diffraction limit.\n")
        (setq fails (1+ fails))))

    (princ (format "----------------------------------------------------------------------\n"))
    (princ (format "Pupil Aberrations Summary: %d Passed, %d Failed, %d Warnings.\n\n"
                   passes fails warnings))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-pupil-aberrations-run)
    (kill-emacs 1)))

(provide 'test-pupil-aberrations)
;;; test-pupil-aberrations.el ends here
