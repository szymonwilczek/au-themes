;;; test-pupil-spasm-adaptation.el --- Saccadic Foveal Adaptation & Palette Energy Variance -*- lexical-binding: t; -*-

(require 'test-palette-extractor)

(defun test-pupil-spasm-adaptation-run ()
  "Evaluate saccadic foveal adaptation steps and palette luminance homogeneity.
Note: Pupillary hippus (~0.2 Hz) is a spontaneous autonomic oscillation. During reading,
saccadic eye movements between syntax tokens produce transient foveal luminance steps.
Bounding local adaptation deltas and overall palette luminance variance (sigma^2) prevents
excessive post-saccadic retinal adaptation transients and asthenopia.
Ref: Loewenfeld (1993) The Pupil; Binda & Murray (2015) PNAS; Mathôt (2018) JoV."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (polarity (rf-theme-polarity theme))
         (bg (plist-get pal :bg-main))
         (bg-y (rf-luminance-y bg))
         (passes 0)
         (fails 0)
         (keys '(:fg-main :fg-dim :preprocessor :keyword :type :constant :number
                 :builtin :fnname :fnname-call :string :property :operator :bracket :err))
         (lums (mapcar (lambda (k) (rf-luminance-y (plist-get pal k))) keys))
         (n (length lums))
         (mean-y (/ (apply #'+ lums) (float n)))
         (variance (/ (apply #'+ (mapcar (lambda (y) (expt (- y mean-y) 2)) lums)) (float n)))
         (syntax-pairs
          '(("keyword (struct) vs type (int)"              :keyword     :type)
            ("keyword (static) vs builtin (__always_inline)" :keyword   :builtin)
            ("builtin vs fnname (def)"                     :builtin     :fnname)
            ("fnname (def) vs fnname-call (call)"          :fnname      :fnname-call)
            ("type (u32) vs variable/property (*state)"    :type        :property)
            ("base text vs keyword (struct)"               :fg-main     :keyword)
            ("base text vs type (int)"                     :fg-main     :type)
            ("base text vs builtin (__always_inline)"      :fg-main     :builtin)
            ("base text vs number (0, 24)"                 :fg-main     :number)
            ("base text vs string (\"literal\")"           :fg-main     :string)
            ("base text vs comments (// note)"             :fg-main     :fg-dim)
            ("base text vs operator (->, =)"               :fg-main     :operator)
            ("base text vs bracket ([ { } ])"              :fg-main     :bracket))))

    (princ (format "\n======================================================================\n"))
    (princ (format " Saccadic Foveal Adaptation & Palette Energy Variance Suite\n"))
    (princ (format " Ref: Binda & Murray (2015) PNAS; Mathot (2018) JoV; Loewenfeld (1993)\n"))
    (princ (format " Theme: %s (%s) | Background: %s (Y_bg: %.6f)\n" theme polarity bg bg-y))
    (princ (format " Requirement: Saccadic delta Delta-L < 0.0400, Variance sigma^2 <= 0.0250\n"))
    (princ (format "======================================================================\n"))

    ;; Part 1: Saccadic Token-to-Token Local Adaptation Delta
    (princ "\nPart 1: Saccadic Foveal Adaptation Jumps (Delta-L < 0.0400):\n")
    (princ (format "%-45s | %-8s | %-8s | %-8s | %-8s\n"
                   "Adjacent Syntax Transition" "Color 1" "Color 2" "Delta-L" "Status"))
    (princ (format "----------------------------------------------+----------+----------+----------+----------\n"))
    (dolist (p syntax-pairs)
      (let* ((label (car p))
             (k1    (cadr p))
             (k2    (nth 2 p))
             (h1    (plist-get pal k1))
             (h2    (plist-get pal k2))
             (dl    (rf-saccadic-adaptation-delta h1 h2 0.15))
             (ok    (< dl 0.0400)))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "%-45s | %-8s | %-8s | %8.4f | %s\n"
                       label h1 h2 dl (if ok "PASS" "FAIL")))))
    (princ (format "----------------------------------------------+----------+----------+----------+----------\n"))

    ;; Part 2: Palette Energy / Luminance Variance
    (princ "\nPart 2: Palette Energy Variance (sigma^2 <= 0.0250):\n")
    (let ((var-ok (<= variance 0.0250)))
      (if var-ok
          (progn
            (princ (format "   [PASS] Mean Y = %.4f, Variance sigma^2 = %.6f <= 0.0250: Cohesive energy distribution.\n"
                           mean-y variance))
            (setq passes (1+ passes)))
        (princ (format "   [FAIL] Variance sigma^2 = %.6f > 0.0250: Excessive luminance dispersion triggers hippus.\n"
                       variance))
        (setq fails (1+ fails))))

    ;; Part 3: Pupillary Steady-State Deadband
    (princ "\nPart 3: Pupillary Steady-State Deadband Check:\n")
    ;; Adapting field: the viewport at the IEC 61966-2-1 reference white plus
    ;; the reference display veiling glare (0.2 cd/m2); the previous ad-hoc
    ;; 1.5 / 50 cd/m2 ambient terms had no standard basis.
    (let* ((pupil-mm (rf-pupil-diameter
                      (+ (* (rf-viewport-mean-luminance-y pal) rf-display-white-luminance)
                         rf-reference-veiling-glare)))
           (deadband-ok (and (>= pupil-mm 2.0) (<= pupil-mm 7.5))))
      (if deadband-ok
          (progn
            (princ (format "   [PASS] Steady-state pupil diameter = %.2f mm in [2.0..7.5 mm]: Stable iris posture.\n"
                           pupil-mm))
            (setq passes (1+ passes)))
        (princ (format "   [FAIL] Pupil diameter = %.2f mm outside physiological operating window.\n"
                       pupil-mm))
        (setq fails (1+ fails))))

    (princ (format "\n----------------------------------------------------------------------\n"))
    (princ (format "Pupil Spasm & Adaptation Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-pupil-spasm-adaptation-run)
    (kill-emacs 1)))

(provide 'test-pupil-spasm-adaptation)
;;; test-pupil-spasm-adaptation.el ends here
