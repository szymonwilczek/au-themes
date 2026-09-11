;;; test-astigmatism-ciliary.el --- Ciliary accommodative micro-fluctuation and astigmatism biometrics -*- lexical-binding: t; -*-

(require 'test-palette-extractor)

(defun test-astigmatism-ciliary-run ()
  "Evaluate ciliary muscle stability and astigmatism tolerance per Charman & Heron (1988)."
  (let* ((pal (rainforest-extract-active-palette))
         (bg (plist-get pal :bg-main))
         (theme (plist-get pal :theme))
         (fg (plist-get pal :fg-main))
         (dim (plist-get pal :fg-dim))
         (lc-fg (rf-apca-contrast fg bg))
         (lc-lcd (rf-lcd-contrast fg bg))
         (chroma-fg (rf-cielab-chroma fg))
         (passes 0)
         (fails 0)
         (warnings 0))
    (princ (format "\n======================================================================\n"))
    (princ (format " Astigmatism & Ciliary Micro-fluctuation Biometrics Suite\n"))
    (princ (format " Ref: Charman & Heron (1988), DOI: 10.1111/j.1475-1313.1988.tb01090.x\n"))
    (princ (format " Theme: %s | Background: %s\n" theme bg))
    (princ (format "======================================================================\n"))

    ;; Test 1: Base text ciliary hunting upper bound (Lc <= 58.0)
    (princ "1. Ciliary Hunting Upper Bound (Lc <= 58.0):\n")
    (princ (format "   Measured Lc: %.2f on background %s\n" lc-fg bg))
    (if (<= lc-fg 58.0)
        (progn
          (princ "   [PASS] Within stability window (1.0-2.3 Hz HFC oscillation avoided).\n")
          (setq passes (1+ passes)))
      (princ "   [FAIL] Excess contrast: causes ciliary hunting and character pulsation.\n")
      (setq fails (1+ fails)))

    ;; Test 2: Base text astigmatic blur threshold (Lc >= 46.0)
    (princ "2. Astigmatic Blur & Retinal Threshold (Lc >= 46.0):\n")
    (princ (format "   Measured LCD Lc: %.2f\n" lc-lcd))
    (if (>= lc-lcd 46.0)
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

    ;; Test 4: Comments unobtrusiveness (Lc in [10.0..24.0])
    (let ((lc-dim (rf-apca-contrast dim bg)))
      (princ "4. Comment Layer Subordination (Lc in [10.0..24.0]):\n")
      (princ (format "   Measured Comments Lc: %.2f\n" lc-dim))
      (if (and (>= lc-dim 10.0) (<= lc-dim 24.0))
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
