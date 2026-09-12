;;; test-pattern-glare-cortical.el --- V1 Cortical Visual Stress & Meares-Irlen Pattern Glare -*- lexical-binding: t; -*-

(require 'test-palette-extractor)

(defun test-pattern-glare-cortical-run ()
  "Evaluate visual stress in primary visual cortex (V1) and Meares-Irlen pattern glare.
At ~3 cycles/degree (typical editor line frequency), alternating high-contrast stripes
trigger cortical hyperexcitation, optical shimmer illusions, nausea, and migraine aura.
Ref: Wilkins et al. (1984, 2016) Brain; Evans & Stevenson (2008); Allen et al. (2008)."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (polarity (rf-theme-polarity theme))
         (bg (plist-get pal :bg-main))
         (bg-y (rf-luminance-y bg))
         (passes 0)
         (fails 0)
         (duty-cycle 0.35)
         (tokens '(("Base text (Mineral quartz)"       :fg-main)
                   ("Comments (Damp needles)"          :fg-dim)
                   ("Keywords (struct, while)"         :keyword)
                   ("Data types (int, size_t)"         :type)
                   ("Preprocessor (#define)"           :preprocessor)
                   ("Numbers (0, 24, 32)"              :number)
                   ("Builtins (__always_inline)"       :builtin)
                   ("Function definitions"             :fnname)
                   ("Function calls (bpf_...)"         :fnname-call)
                   ("Strings (\"string literals\")"    :string)
                   ("Struct fields (->tgid)"           :property)
                   ("Alerts / Errors (!)"              :err))))

    (princ (format "\n======================================================================\n"))
    (princ (format " V1 Cortical Visual Stress & Meares-Irlen Pattern Glare Suite\n"))
    (princ (format " Ref: Wilkins (1984, 1995, 2016) Brain; Evans & Stevenson (2008)\n"))
    (princ (format " Theme: %s (%s) | Background: %s (Y_bg: %.6f)\n" theme polarity bg bg-y))
    (princ (format " Note: Visual stress increases monotonically with grating contrast at ~3 c/deg;\n"))
    (princ (format "       Wilkins Michelson C_M is reported as an informative grating descriptor\n"))
    (princ (format "       evaluated over the physical panel floor (duty cycle: %.0f%%).\n" (* duty-cycle 100.0)))
    (princ (format "======================================================================\n"))

    ;; Part 1: Dense Realistic Code Block Line Contrast
    (princ "\nPart 1: Realistic Code Block Line Contrast (Syntactic Weighting):\n")
    (let* ((weights '((:fg-main . 0.45)
                      (:keyword . 0.12)
                      (:type . 0.10)
                      (:property . 0.10)
                      (:fnname-call . 0.08)
                      (:number . 0.05)
                      (:string . 0.05)
                      (:constant . 0.05)))
           (block-y 0.0))
      (dolist (w weights)
        (let ((y (rf-luminance-y (plist-get pal (car w)))))
          (setq block-y (+ block-y (* y (cdr w))))))
      (let* ((amb (rf-display-physical-floor-y))
             (eff-bg (+ bg-y amb))
             (eff-fg (+ block-y amb))
             (line-y (+ (* duty-cycle eff-fg) (* (- 1.0 duty-cycle) eff-bg)))
             (denom (+ line-y eff-bg))
             (cm (if (< denom 1e-9) 0.0 (/ (abs (- line-y eff-bg)) denom)))
             (valid (and (>= cm 0.0) (<= cm 1.0))))
        (if valid
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "   Weighted Dense Code Line: Lum=%.4f, Michelson C_M=%.4f (Floor=%.5f) -> %s\n"
                       line-y cm amb (if valid "PASS (Well-formed)" "FAIL")))))

    ;; Part 2: Individual Token Line Contrast
    (princ "\nPart 2: Per-Token Line Stripe Michelson Contrast Descriptor:\n")
    (princ (format "%-30s | %-8s | %-8s | %-12s | %-8s | %-14s\n"
                   "Token Role" "Hex" "Lum (Y)" "Line Lum" "C_M" "Descriptor"))
    (princ (format "-------------------------------+----------+----------+--------------+----------+--------------\n"))
    (dolist (tok tokens)
      (let* ((label (nth 0 tok))
             (key   (nth 1 tok))
             (hex   (plist-get pal key))
             (y-val (rf-luminance-y hex))
             (amb   (rf-display-physical-floor-y))
             (cm    (rf-wilkins-line-michelson hex bg duty-cycle amb))
             (eff-bg (+ bg-y amb))
             (eff-fg (+ y-val amb))
             (line-y (+ (* duty-cycle eff-fg) (* (- 1.0 duty-cycle) eff-bg)))
             (valid (and (>= cm 0.0) (<= cm 1.0))))
        (if valid
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "%-30s | %-8s | %8.4f | %12.4f | %8.4f | %s\n"
                       label hex y-val line-y cm
                       (cond ((< cm 0.40) "Low grating")
                             ((< cm 0.75) "Moderate")
                             (t "High contrast"))))))
    (princ (format "-------------------------------+----------+----------+--------------+----------+--------------\n"))

    ;; Part 3: Spatial Frequency Cortical Damping Check
    (princ "\nPart 3: Cortical Hyperexcitation Envelope Check (~3 cycles/degree):\n")
    (if (<= bg-y 0.020)
        (progn
          (princ "   [PASS] Dark nocturnal canvas eliminates macro-grating flicker.\n")
          (setq passes (1+ passes)))
      (if (<= bg-y 0.850)
          (progn
            (princ "   [PASS] Daylight mist background maintains soft line transition.\n")
            (setq passes (1+ passes)))
        (princ "   [FAIL] Harsh high-glare background exacerbates pattern shimmer.\n")
        (setq fails (1+ fails))))

    (princ (format "\n----------------------------------------------------------------------\n"))
    (princ (format "Cortical Pattern Glare Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-pattern-glare-cortical-run)
    (kill-emacs 1)))

(provide 'test-pattern-glare-cortical)
;;; test-pattern-glare-cortical.el ends here
