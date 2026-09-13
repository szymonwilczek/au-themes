;;; test-magnocellular-parvocellular-balance.el --- Magnocellular vs Parvocellular Pathway Balance -*- lexical-binding: t; -*-

(require 'test-palette-extractor)

(defun test-magnocellular-parvocellular-balance-run ()
  "Evaluate visual pathway balance between Magnocellular (M) and Parvocellular (P) systems.
In ASD, the M-pathway (sensitive to rapid motion, flicker, low spatial frequency luminance jumps)
is fragile and triggers involuntary saccadic micro-jitters when background surfaces pop.
Backgrounds (hl-line, region) must have minimal luminance contrast (Lc < 12.0), leaving
all semantic differentiation to the slow, detailed, color-sensitive P-pathway.
Ref: Livingstone & Hubel (1988) Science; Milne et al. (2002) NeuroReport; Merigan & Maunsell (1993)."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (polarity (rf-theme-polarity theme))
         (bg (plist-get pal :bg-main))
         (hl (plist-get pal :bg-hl-line))
         (bg-y (rf-luminance-y bg))
         (hl-y (rf-luminance-y hl))
         (passes 0)
         (fails 0))

    (princ (format "\n======================================================================\n"))
    (princ (format " Magnocellular (M) vs Parvocellular (P) Visual Pathway Balance Suite\n"))
    (princ (format " Ref: Livingstone & Hubel (1988); Milne et al. (2002) M-Pathway in ASD\n"))
    (princ (format " Theme: %s (%s) | Background: %s (Y_bg: %.6f)\n" theme polarity bg bg-y))
    (princ (format "======================================================================\n"))

    ;; Part 1: M-Pathway Background Luminance Contrast Gate (Lc < 12.0 & Michelson <= 0.35)
    ;; In APCA, |Lc| < 7.3 clamps to 0.0 (loClip); check photometric Michelson jump to ensure non-trivial gate.
    (princ "\nPart 1: Background UI Surfaces vs Canvas Luminance Shock (Michelson <= 0.35, Lc < 12.0):\n")
    (let* ((lc-hl (abs (rf-apca-contrast hl bg)))
           (m-hl (/ (abs (- hl-y bg-y)) (max 1e-6 (+ hl-y bg-y))))
           (hl-ok (and (< lc-hl 12.0) (<= m-hl 0.35))))
      (if hl-ok
          (progn
            (princ (format "   [PASS] bg-hl-line (%s) vs bg-main (%s): Michelson=%.4f <= 0.35, |Lc|=%.2f: Suppresses M-pathway jerk.\n"
                           hl bg m-hl lc-hl))
            (setq passes (1+ passes)))
        (princ (format "   [FAIL] bg-hl-line (%s) vs bg-main (%s): Michelson=%.4f, |Lc|=%.2f: Triggers M-pathway saccadic distractibility.\n"
                       hl bg m-hl lc-hl))
        (setq fails (1+ fails))))

    ;; Part 2: P-Pathway Semantic Chromatic Information Gate
    (princ "\nPart 2: P-Pathway High-Frequency Semantic Syntax Encoding (|Lc| >= 20.0):\n")
    (let ((syntax-tokens '((:fg-main . "Base text")
                           (:keyword . "Keywords")
                           (:type . "Data types")
                           (:constant . "Constants")
                           (:number . "Numbers")
                           (:fnname-call . "Function calls"))))
      (dolist (item syntax-tokens)
        (let* ((key (car item))
               (label (cdr item))
               (hex (plist-get pal key))
               (lc (abs (rf-apca-contrast hex bg)))
               (ok (>= lc 20.0)))
          (if ok
              (setq passes (1+ passes))
            (setq fails (1+ fails)))
          (princ (format "   %-18s (%s): APCA |Lc| = %5.1f >= 20.0 -> %s\n"
                         label hex lc (if ok "PASS" "FAIL"))))))

    ;; Part 3: M/P Luminance Gain Ratio Check
    (princ "\nPart 3: M/P Luminance Gain Ratio Check:\n")
    (let* ((delta-bg-y (abs (- hl-y bg-y)))
           (delta-fg-y (abs (- (rf-luminance-y (plist-get pal :fg-main)) bg-y)))
           (mp-gain-ratio (/ delta-bg-y (max 0.001 delta-fg-y)))
           ;; hl-line luminance change must be less than 35% of text luminance step
           (gain-ok (<= mp-gain-ratio 0.35)))
      (if gain-ok
          (progn
            (princ (format "   [PASS] M/P Luminance Gain Ratio = %.3f <= 0.350: Background stays quiet, text drives perception.\n"
                           mp-gain-ratio))
            (setq passes (1+ passes)))
        (princ (format "   [FAIL] M/P Luminance Gain Ratio = %.3f > 0.350: Background competes with text for attention.\n"
                       mp-gain-ratio))
        (setq fails (1+ fails))))

    (princ (format "\n----------------------------------------------------------------------\n"))
    (princ (format "M/P Visual Pathway Balance Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-magnocellular-parvocellular-balance-run)
    (kill-emacs 1)))

(provide 'test-magnocellular-parvocellular-balance)
;;; test-magnocellular-parvocellular-balance.el ends here
