;;; test-astigmatism-ciliary.el --- Ciliary accommodative micro-fluctuation and astigmatism biometrics -*- lexical-binding: t; -*-

(require 'test-palette-extractor)

(defun test-astigmatism-ciliary-run ()
  "Evaluate ciliary muscle stability and astigmatism tolerance per Charman & Heron (1988)."
  (let* ((pal (au-extract-active-palette))
         (bg (plist-get pal :bg-main))
         (theme (plist-get pal :theme))
         (polarity (rf-theme-polarity theme))
         (fg (plist-get pal :fg-main))
         (dim (plist-get pal :fg-dim))
         (lc-fg (abs (rf-apca-contrast fg bg)))
         (lc-lcd (abs (rf-lcd-contrast fg bg)))
         (chroma-fg (rf-cielab-chroma fg))
         (max-ciliary-lc (if (eq polarity 'light) 75.0 58.0))
         (min-blur-lc (if (eq polarity 'light) 62.0 46.0))
         (min-dim-lc (if (eq polarity 'light) 35.0 10.0))
         (max-dim-lc (if (eq polarity 'light) 52.0 24.0))
         (passes 0)
         (fails 0)
         (warnings 0))
    (princ (format "\n======================================================================\n"))
    (princ (format " Astigmatism & Ciliary Micro-fluctuation Biometrics Suite\n"))
    (princ (format " Ref: Charman & Heron (1988), DOI: 10.1111/j.1475-1313.1988.tb01090.x\n"))
    (princ (format " Theme: %s (%s) | Background: %s\n" theme polarity bg))
    (princ (format "======================================================================\n"))

    ;; Test 1: Base text ciliary hunting upper bound
    (princ (format "1. Ciliary Hunting Upper Bound (|Lc| <= %.1f):\n" max-ciliary-lc))
    (princ (format "   Measured |Lc|: %.2f on background %s\n" lc-fg bg))
    (if (<= lc-fg max-ciliary-lc)
        (progn
          (princ "   [PASS] Within stability window (excessive edge glare & ciliary pulsation avoided).\n")
          (setq passes (1+ passes)))
      (princ "   [FAIL] Excess contrast: causes ciliary hunting and character pulsation.\n")
      (setq fails (1+ fails)))

    ;; Test 2: Base text astigmatic blur threshold
    (princ (format "2. Astigmatic Blur & Retinal Threshold (|Lc| >= %.1f):\n" min-blur-lc))
    (princ (format "   Measured LCD |Lc|: %.2f\n" lc-lcd))
    (if (>= lc-lcd min-blur-lc)
        (progn
          (princ "   [PASS] Sufficient luminance difference for uncorrected Sturm conoid focus.\n")
          (setq passes (1+ passes)))
      (princ "   [FAIL] Insufficient contrast: causes squinting and ocular fatigue.\n")
      (setq fails (1+ fails)))

    ;; Test 3: Subpixel color fringing on base text (CIELAB C* <= 12.0)
    (princ "3. Base Text Subpixel Fringing (C* <= 12.0):\n")
    (princ (format "   Measured Chroma C*: %.2f\n" chroma-fg))
    (if (<= chroma-fg 12.0)
        (progn
          (princ "   [PASS] Achromatic balance preserved; no LCD subpixel color bleeding.\n")
          (setq passes (1+ passes)))
      (princ "   [WARN] Elevated chroma on body text: risk of chromatic fringing.\n")
      (setq warnings (1+ warnings)))

    ;; Test 4: Comments unobtrusiveness
    (let ((lc-dim (abs (rf-apca-contrast dim bg))))
      (princ (format "4. Comment Layer Subordination (|Lc| in [%.1f..%.1f]):\n" min-dim-lc max-dim-lc))
      (princ (format "   Measured Comments |Lc|: %.2f\n" lc-dim))
      (if (and (>= lc-dim min-dim-lc) (<= lc-dim max-dim-lc))
          (progn
            (princ "   [PASS] Comments recede into background, preventing attention disruption.\n")
            (setq passes (1+ passes)))
        (princ "   [FAIL] Comments outside optimal range.\n")
        (setq fails (1+ fails))))

    (princ (format "----------------------------------------------------------------------\n"))
    (princ (format "Astigmatism Biometrics Summary: %d Passed, %d Failed, %d Warnings.\n\n"
                   passes fails warnings))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-astigmatism-ciliary-run)
    (kill-emacs 1)))

(provide 'test-astigmatism-ciliary)
;;; test-astigmatism-ciliary.el ends here
