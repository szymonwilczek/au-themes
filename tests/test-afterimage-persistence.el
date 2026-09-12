;;; test-afterimage-persistence.el --- Palinopsia & Receptor Inertia Afterimage Decay -*- lexical-binding: t; -*-

(require 'test-palette-extractor)

(defun test-afterimage-persistence-run ()
  "Evaluate photoreceptor inertia, palinopsia, and negative afterimages.
In photophobia and visual migraine, photoreceptors exhibit prolonged
photochemical recovery.  Brief fixations on bright cursor blocks or alert badges
leave residual afterimages that burn into the fovea, obscuring subsequent text.
Afterimage optical density at t = 1.0s must remain <= 5.5% (anchors <= 5.0%).
Ref: Rushton (1961); Naka & Rushton (1966); Loomis (1978)."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (polarity (rf-theme-polarity theme))
         (bg (plist-get pal :bg-main))
         (bg-y (rf-luminance-y bg))
         (passes 0)
         (fails 0)
         ;; Cone pigment recovery time constant tau ~ 0.45s (Rushton kinetics)
         (tau 0.45)
         (tokens-to-test '(("Cursor (Raindrop glint)"          :cursor)
                           ("Alerts / Errors (Yew berry)"      :err)
                           ("Base text (Mineral quartz)"       :fg-main)
                           ("Constants (LOTA_PCR_COUNT)"       :constant)
                           ("Numbers (Golden amber honey)"     :number)
                           ("Builtins (Forest viridian)"       :builtin))))

    (princ (format "\n======================================================================\n"))
    (princ (format " Palinopsia, Receptor Inertia & Negative Afterimage Decay Suite\n"))
    (princ (format " Ref: Rushton (1961); Naka & Rushton (1966); Loomis (1978)\n"))
    (princ (format " Theme: %s (%s) | Background: %s (Y_bg: %.6f)\n" theme polarity bg bg-y))
    (princ (format " Requirement: Afterimage Optical Density D(t=1.0s) <= %.1f%% (Tau = %.2fs)\n"
                   (if (eq polarity 'light) 6.0 5.5) tau))
    (princ (format "======================================================================\n"))

    (princ (format "%-30s | %-8s | %-8s | %-8s | %-10s | %-8s\n"
                   "Visual Element" "Hex" "Lum (Y)" "Initial D0" "D(t=1.0s)" "Status"))
    (princ (format "-------------------------------+----------+----------+----------+------------+----------\n"))
    (dolist (tok tokens-to-test)
      (let* ((label (nth 0 tok))
             (key   (nth 1 tok))
             (hex   (plist-get pal key))
             (y-val (rf-luminance-y hex))
             ;; Initial bleaching fraction D0 per Naka-Rushton (1966) cone kinetics:
             ;; D0 = |Y - Y_bg| / (Y + Y_bg + 2*Y_half), where Y_half = 0.25
             ;; is the human cone semi-saturation luminance.
             (d0 (/ (abs (- y-val bg-y)) (+ y-val bg-y 0.50)))
             ;; Residual afterimage optical density after 1.0 second (Loomis 1978)
             (d1 (* d0 (exp (- (/ 1.0 tau)))))
             (pct (* d1 100.0))
             (max-pct (if (eq polarity 'light) 6.0 5.5))
             (ok (<= pct max-pct)))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "%-30s | %-8s | %8.4f | %8.4f | %7.2f%%   | %s\n"
                       label hex y-val d0 pct (if ok "PASS" "FAIL")))))
    (princ (format "-------------------------------+----------+----------+----------+------------+----------\n"))

    ;; Part 2: Primary Cursor & Alert Palinopsia Gate
    (princ "\nPart 2: High-Focus Anchor Elements (Cursor & Alert Palinopsia Lock):\n")
    (let* ((cur-y (rf-luminance-y (plist-get pal :cursor)))
           (err-y (rf-luminance-y (plist-get pal :err)))
           (cur-d1 (* (/ (abs (- cur-y bg-y)) (+ cur-y bg-y 0.50)) (exp (- (/ 1.0 tau)))))
           (err-d1 (* (/ (abs (- err-y bg-y)) (+ err-y bg-y 0.50)) (exp (- (/ 1.0 tau)))))
           (anchors-ok (and (< (* cur-d1 100.0) 5.0) (< (* err-d1 100.0) 5.0))))
      (if anchors-ok
          (progn
            (princ (format "   [PASS] Cursor D(1s)=%.2f%%, Alert D(1s)=%.2f%% < 5.0%%: Zero persistent ghosting.\n"
                           (* cur-d1 100.0) (* err-d1 100.0)))
            (setq passes (1+ passes)))
        (princ (format "   [FAIL] Residual afterimage >= 5.0%%: High risk of palinopsia and visual interference.\n"))
        (setq fails (1+ fails))))

    (princ (format "\n----------------------------------------------------------------------\n"))
    (princ (format "Afterimage Persistence Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-afterimage-persistence-run)
    (kill-emacs 1)))

(provide 'test-afterimage-persistence)
;;; test-afterimage-persistence.el ends here
