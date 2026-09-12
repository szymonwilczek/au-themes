;;; test-crowding-effect-foveal.el --- Foveal Visual Crowding & Bouma Window in ASD -*- lexical-binding: t; -*-

(require 'test-palette-extractor)

(defun test-crowding-effect-foveal-run ()
  "Evaluate foveal visual crowding and Bouma's spatial integration window in ASD.
In autism, the cortical integration field (Bouma's window) is broader and lacks lateral inhibition.
When punctuation, brackets, and operators have equal luminance to identifiers, Bouma's window
merges adjacent tokens into a solid clump. Delimiters must maintain subordinate energy.
Ref: Levi (2008) Vision Res.; Pelli et al. (2004); Bouma (1970) Nature; Baldassi et al. (2009)."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (polarity (rf-theme-polarity theme))
         (bg (plist-get pal :bg-main))
         (bg-y (rf-luminance-y bg))
         (passes 0)
         (fails 0)
         (delim-hex   (plist-get pal :delimiter))
         (bracket-hex (plist-get pal :bracket))
         (op-hex      (plist-get pal :operator))
         (core-fg-hex (plist-get pal :fg-main))
         (type-hex    (plist-get pal :type))
         (prop-hex    (plist-get pal :property)))

    (princ (format "\n======================================================================\n"))
    (princ (format " Foveal Visual Crowding & Bouma Window Integration Suite\n"))
    (princ (format " Ref: Bouma (1970) Nature; Levi (2008); Baldassi et al. (2009) ASD Vision\n"))
    (princ (format " Theme: %s (%s) | Background: %s (Y_bg: %.6f)\n" theme polarity bg bg-y))
    (princ (format "======================================================================\n"))

    (if (eq polarity 'dark)
        (progn
          ;; Part 1: Delimiter Energy Subordination to Core Identifiers
          (princ "\nPart 1: Delimiter vs Core Identifiers Contrast Hierarchy:\n")
          (let* ((lc-delim (abs (rf-apca-contrast delim-hex bg)))
                 (lc-core  (abs (rf-apca-contrast core-fg-hex bg)))
                 (ratio-delim (/ lc-delim (max 1.0 lc-core)))
                 (ok (<= ratio-delim 0.75)))
            (if ok
                (progn
                  (princ (format "   [PASS] Delimiters (|Lc|=%.1f) vs Base Text (|Lc|=%.1f): Ratio = %.2f <= 0.75: Prevents glyph clumping.\n"
                                 lc-delim lc-core ratio-delim))
                  (setq passes (1+ passes)))
              (princ (format "   [FAIL] Delimiters (|Lc|=%.1f) compete equally with Base Text (|Lc|=%.1f): Ratio = %.2f > 0.75: Visual crowding.\n"
                             lc-delim lc-core ratio-delim))
              (setq fails (1+ fails))))

          ;; Part 2: Bracket Energy Subordination to Types & Properties
          (princ "\nPart 2: Brackets vs Types/Properties Hierarchy:\n")
          (let* ((lc-bracket (abs (rf-apca-contrast bracket-hex bg)))
                 (lc-type    (abs (rf-apca-contrast type-hex bg)))
                 (ratio-bracket (/ lc-bracket (max 1.0 lc-type)))
                 (ok (<= ratio-bracket 0.75)))
            (if ok
                (progn
                  (princ (format "   [PASS] Brackets (|Lc|=%.1f) vs Types (|Lc|=%.1f): Ratio = %.2f <= 0.75: Clean boundary demarcation.\n"
                                 lc-bracket lc-type ratio-bracket))
                  (setq passes (1+ passes)))
              (princ (format "   [FAIL] Brackets (|Lc|=%.1f) vs Types (|Lc|=%.1f): Ratio = %.2f > 0.75: Cluttered syntax integration.\n"
                             lc-bracket lc-type ratio-bracket))
              (setq fails (1+ fails))))

          ;; Part 3: Operator Energy Subordination
          (princ "\nPart 3: Operators vs Properties/Variables Hierarchy:\n")
          (let* ((lc-op   (abs (rf-apca-contrast op-hex bg)))
                 (lc-prop (abs (rf-apca-contrast prop-hex bg)))
                 (ratio-op (/ lc-op (max 1.0 lc-prop)))
                 (ok (<= ratio-op 0.85)))
            (if ok
                (progn
                  (princ (format "   [PASS] Operators (|Lc|=%.1f) vs Properties (|Lc|=%.1f): Ratio = %.2f <= 0.85: Identifiers pop forward.\n"
                                 lc-op lc-prop ratio-op))
                  (setq passes (1+ passes)))
              (princ (format "   [FAIL] Operators (|Lc|=%.1f) vs Properties (|Lc|=%.1f): Ratio = %.2f > 0.85: Overcrowded symbol noise.\n"
                             lc-op lc-prop ratio-op))
              (setq fails (1+ fails)))))

      ;; Daylight Mode baseline check
      (progn
        (princ "\nDaylight Mode Punctuation Acuity Baseline Check:\n")
        (let* ((lc-delim   (abs (rf-apca-contrast delim-hex bg)))
               (lc-bracket (abs (rf-apca-contrast bracket-hex bg)))
               (ok (and (>= lc-delim 40.0) (>= lc-bracket 40.0))))
          (if ok
              (progn
                (princ (format "   [PASS] Daylight Delimiters (|Lc|=%.1f) & Brackets (|Lc|=%.1f) maintain baseline acuity >= 40.0.\n"
                               lc-delim lc-bracket))
                (setq passes (1+ passes)))
            (princ "   [FAIL] Daylight delimiters lack basic legibility.\n")
            (setq fails (1+ fails))))))

    (princ (format "\n----------------------------------------------------------------------\n"))
    (princ (format "Foveal Visual Crowding Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-crowding-effect-foveal-run)
    (kill-emacs 1)))

(provide 'test-crowding-effect-foveal)
;;; test-crowding-effect-foveal.el ends here
