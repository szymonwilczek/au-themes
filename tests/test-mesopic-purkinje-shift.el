;;; test-mesopic-purkinje-shift.el --- CIE 191:2010 Mesopic Vision & Purkinje Shift -*- lexical-binding: t; -*-

(require 'test-palette-extractor)

(defun test-mesopic-purkinje-shift-run ()
  "Evaluate mesopic luminance and Purkinje rod shift per CIE 191:2010.

Note:
  - Foveolar reading is rod-free (~1 deg central zone has 0 rods per Curcio 1991).
    Purkinje shift and rod intrusion govern peripheral parafoveal adaptation and
    general ambient comfort rather than high-acuity glyph identification.
  - S/P ratio is evaluated across the composite 80x40 viewport field rather than
    the isolated background canvas.
  - CIE 191 is defined only for adaptation luminances in [0.005, 5] cd/m^2."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (polarity (rf-theme-polarity theme))
         (passes 0)
         (fails 0)
         ;; Nocturnal display setting: 25 % of reference white (80 cd/m2) = 20 cd/m2.
         (white-cd (* 0.25 rf-display-white-luminance))
         (view-y (rf-viewport-mean-luminance-y pal))
         (la-p (* view-y white-cd))
         ;; S/P ratio of the composite adaptation field (tokens + background)
         (keys '(:fg-main :keyword :type :property :fnname-call :number :string :constant))
         (ink-s (/ (cl-loop for k in keys sum (/ (rf-scotopic-luminance (plist-get pal k) white-cd) white-cd))
                   (float (length keys))))
         (bg-s (/ (rf-scotopic-luminance (plist-get pal :bg-main) white-cd) white-cd))
         (hl-s (/ (rf-scotopic-luminance (plist-get pal :bg-hl-line) white-cd) white-cd))
         (code-cell-s (+ (* rf-glyph-ink-coverage ink-s) (* (- 1.0 rf-glyph-ink-coverage) bg-s)))
         (view-s (/ (+ (* rf-viewport-code-cells code-cell-s)
                       (* rf-viewport-hl-cells hl-s)
                       (* (- rf-viewport-cells rf-viewport-code-cells rf-viewport-hl-cells) bg-s))
                    (float rf-viewport-cells)))
         (sp-ratio (/ view-s (max 1e-9 view-y)))
         (la-s (* sp-ratio la-p))
         (m (rf-mesopic-adaptation-coefficient la-p la-s))
         (photopic-onset-cd (/ 5.0 (max 1e-9 view-y)))
         (tokens '(("Alerts / Errors (!)"              :err)
                   ("Keywords (struct, while)"         :keyword)
                   ("Data types (int, size_t)"         :type)
                   ("Preprocessor (#define)"           :preprocessor)
                   ("Function definitions"             :fnname)
                   ("Constants (LOTA_PCR_COUNT)"       :constant)
                   ("Base text (Mineral quartz)"       :fg-main))))
    (princ (format "\n======================================================================\n"))
    (princ (format " CIE 191:2010 Mesopic Photometry & Purkinje Rod Shift Gate Suite\n"))
    (princ (format " Ref: CIE 191:2010 (MES-2); Rea et al. (2004) DOI 10.1191/1365782804li114oa\n"))
    (princ (format " Theme: %s (%s)\n" theme polarity))
    (princ (format " Nocturnal display white: %.1f cd/m2 | Viewport mean Y: %.4f\n" white-cd view-y))
    (princ (format " Adaptation field: L_p = %.4f cd/m2, L_s = %.4f scotopic cd/m2\n" la-p la-s))
    (princ (format " CIE 191 adaptation coefficient m = %.4f (m=1 photopic, m=0 scotopic)\n" m))
    (princ (format " Viewport leaves the mesopic domain above a display white of %.0f cd/m2\n"
                   photopic-onset-cd))
    (princ (format " Gates: Adaptation field in [0.005, 5] cd/m2 | Parafoveal contrast polarity preserved\n"))
    (princ (format " Note: Text reading is foveolar (rod-free, Curcio 1991); shifts describe parafoveal salience.\n"))
    (princ (format "======================================================================\n"))
    (let ((bg-lmes (rf-mesopic-luminance (plist-get pal :bg-main) m white-cd)))
      ;; Gate 1: Field adaptation inside CIE 191 mesopic bounds
      (let ((field-ok (and (>= la-p 0.005) (<= la-p 5.0) (>= m 0.0) (<= m 1.0))))
        (if field-ok (setq passes (1+ passes)) (setq fails (1+ fails)))
        (princ (format "Mesopic field adaptation state (L_a=%.3f, m=%.3f): %s\n"
                       la-p m (if field-ok "PASS" "FAIL"))))
      ;; Gate 2: Realistic photopic onset ceiling
      (let ((onset-ok (<= photopic-onset-cd 500.0)))
        (if onset-ok (setq passes (1+ passes)) (setq fails (1+ fails)))
        (princ (format "Photopic onset ceiling (%.0f cd/m2 <= 500 cd/m2): %s\n"
                       photopic-onset-cd (if onset-ok "PASS" "FAIL"))))
      (princ (format "----------------------------------------------------------------------\n"))
      (princ (format "%-28s | %-8s | %-8s | %-8s | %-7s | %-8s | %-6s\n"
                     "Token Role" "Hex" "L_p" "L_mes" "Shift" "CR_mes" "Status"))
      (princ (format "-----------------------------+----------+----------+----------+---------+----------+-------\n"))
      (dolist (tok tokens)
        (let* ((label    (nth 0 tok))
               (key      (nth 1 tok))
               (hex      (plist-get pal key))
               (lp       (rf-luminance-cd hex white-cd))
               (lmes     (rf-mesopic-luminance hex m white-cd))
               (shift    (- (/ lmes (max 1e-9 lp)) 1.0))
               (crmes    (/ lmes (max 1e-9 bg-lmes)))
               (ok       (if (eq polarity 'dark)
                             (> lmes bg-lmes)
                           (< lmes bg-lmes))))
          (if ok
              (setq passes (1+ passes))
            (setq fails (1+ fails)))
          (princ (format "%-28s | %-8s | %8.4f | %8.4f | %+6.1f%% | %7.2f:1 | %s\n"
                         label hex lp lmes (* 100.0 shift) crmes
                         (if ok "PASS" "FAIL"))))))
    (princ (format "-----------------------------+----------+----------+----------+---------+----------+-------\n"))
    (princ "Interpretation: shifts describe parafoveal luminance variation under rod\n")
    (princ "contribution. Contrast polarity retention ensures tokens remain distinct from\n")
    (princ "background during saccadic exploration without reverse-contrast distortion.\n")
    (princ (format "Mesopic Purkinje Shift Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-mesopic-purkinje-shift-run)
    (kill-emacs 1)))

(provide 'test-mesopic-purkinje-shift)
;;; test-mesopic-purkinje-shift.el ends here
