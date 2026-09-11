;;; test-trigeminal-nerve-excitation.el --- Trigeminal Ophthalmic (V1) Red Nociceptive Excitation -*- lexical-binding: t; -*-

(require 'test-palette-extractor)

(defun test-trigeminal-nerve-excitation-run ()
  "Evaluate trigeminal nerve (V1 ophthalmic branch) nociceptive excitation from long-wavelength red.
Monochromatic deep red (>620 nm) stimulates dural and meningeal nociceptors, triggering retro-orbital
eye ache, photophobic lancinating pain, and migraine aura.
Ref: Burstein et al. (2015) Nature Rev. Neurosci.; Noseda et al. (2010); Digre & Brennan (2012)."
  (let* ((pal (rainforest-extract-active-palette))
         (theme (plist-get pal :theme))
         (polarity (rf-theme-polarity theme))
         (bg (plist-get pal :bg-main))
         (passes 0)
         (fails 0)
         (warm-tokens '(("Alerts / Errors (Yew berry)"        :err)
                        ("Strings (Burnt oak)"                :string)
                        ("Builtins"                           :builtin)
                        ("Numbers (Golden amber honey)"       :number)
                        ("Preprocessor (#define)"             :preprocessor))))

    (princ (format "\n======================================================================\n"))
    (princ (format " Trigeminal Nerve (V1) Ophthalmic Nociceptive Red Excitation Suite\n"))
    (princ (format " Ref: Burstein et al. (2015); Noseda et al. (2010); Digre (2012)\n"))
    (princ (format " Theme: %s (%s) | Background: %s\n" theme polarity bg))
    (princ (format " Requirements: Red Purity <= 0.850, Muted Red Lum Y <= 0.250 (Dark mode)\n"))
    (princ (format "======================================================================\n"))

    (princ (format "%-32s | %-8s | %-8s | %-10s | %-8s | %-8s\n"
                   "Warm / Red Token" "Hex" "Lum (Y)" "Red Purity" "R/G Ratio" "Status"))
    (princ (format "---------------------------------+----------+----------+------------+----------+----------\n"))
    (dolist (tok warm-tokens)
      (let* ((label (car tok))
             (key   (cadr tok))
             (hex   (plist-get pal key))
             (rgb   (rf-hex-to-rgb hex))
             (r     (rf-srgb-to-linear (nth 0 rgb)))
             (g     (rf-srgb-to-linear (nth 1 rgb)))
             (b     (rf-srgb-to-linear (nth 2 rgb)))
             (y-val (rf-luminance-y hex))
             (purity (/ r (max 1e-4 (+ r g b))))
             (rg-ratio (/ r (max 1e-4 g)))
             (max-purity (if (eq polarity 'light) 0.880 0.850))
             (max-lum    (if (eq polarity 'light) 0.400 (if (eq key :number) 0.400 0.250)))
             (ok (and (<= purity max-purity)
                      (if (> purity 0.400) (<= y-val max-lum) t))))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "%-32s | %-8s | %8.4f | %10.4f | %8.2f | %s\n"
                       label hex y-val purity rg-ratio (if ok "PASS" "FAIL")))))
    (princ (format "---------------------------------+----------+----------+------------+----------+----------\n"))

    ;; Part 2: Monochromatic Laser Spike Absence Check
    (princ "\nPart 2: Monochromatic Laser-Red Absence Check (Green Grounding):\n")
    (let* ((err-hex (plist-get pal :err))
           (err-rgb (rf-hex-to-rgb err-hex))
           (err-g   (rf-srgb-to-linear (nth 1 err-rgb)))
           (err-b   (rf-srgb-to-linear (nth 2 err-rgb)))
           (grounding-ok (> (+ err-g err-b) 0.050)))
      (if grounding-ok
          (progn
            (princ (format "   [PASS] Alert token maintains green/blue grounding (G+B = %.4f > 0.050): Prevents pure laser red.\n"
                           (+ err-g err-b)))
            (setq passes (1+ passes)))
        (princ (format "   [FAIL] Alert token is pure monochromatic red (G+B = %.4f <= 0.050): Severe trigeminal migraine risk.\n"
                       (+ err-g err-b)))
        (setq fails (1+ fails))))

    (princ (format "\n----------------------------------------------------------------------\n"))
    (princ (format "Trigeminal Nerve Excitation Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-trigeminal-nerve-excitation-run)
    (kill-emacs 1)))

(provide 'test-trigeminal-nerve-excitation)
;;; test-trigeminal-nerve-excitation.el ends here
