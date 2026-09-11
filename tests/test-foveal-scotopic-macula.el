;;; test-foveal-scotopic-macula.el --- Foveal macular tritanopia & L+M cone fraction -*- lexical-binding: t; -*-

(require 'test-palette-extractor)

(defun test-foveal-scotopic-macula-run ()
  "Evaluate foveal L+M cone luminance fraction for high-frequency glyphs.
Ref: Curcio et al. (1991), Bone et al. (1988), Stockman & Sharpe (2000)."
  (let* ((pal (rainforest-extract-active-palette))
         (theme (plist-get pal :theme))
         (passes 0)
         (fails 0)
         (tokens '(("Base text (Mineral quartz)"       :fg-main      0.850)
                   ("Operators (+, -, *, >>)"          :operator     0.850)
                   ("Brackets (( ) [ ] { })"           :bracket      0.850)
                   ("Delimiters (, ;)"                 :delimiter    0.850)
                   ("Struct fields (->tgid)"           :property     0.850)
                   ("Keywords (struct, while)"         :keyword      0.850)
                   ("Data types (int, size_t)"         :type         0.850)
                   ("Comments (Damp needles)"          :fg-dim       0.850))))
    (princ (format "\n======================================================================\n"))
    (princ (format " Foveal S-Cone Deficiency & Macular Tritanopia Gate Suite\n"))
    (princ (format " Ref: Curcio et al. (1991) J. Comp. Neurol; Bone et al. (1988) Vision Res\n"))
    (princ (format " Requirement: L+M cone luminance fraction F_(L+M) >= 85.0%%\n"))
    (princ (format " Theme: %s\n" theme))
    (princ (format "======================================================================\n"))
    (princ (format "%-32s | %-8s | %-12s | %-12s | %-8s\n"
                   "High-Frequency Glyph Role" "Hex" "F_(L+M)" "Min Req" "Status"))
    (princ (format "---------------------------------+----------+--------------+--------------+----------\n"))
    (dolist (tok tokens)
      (let* ((label (nth 0 tok))
             (key   (nth 1 tok))
             (min-f (nth 2 tok))
             (hex   (plist-get pal key))
             (frac  (rf-foveal-lm-fraction hex))
             (ok    (>= frac min-f)))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "%-32s | %-8s | %10.2f%% | %10.2f%% | %s\n"
                       label hex (* frac 100.0) (* min-f 100.0)
                       (if ok "PASS" "FAIL")))))
    (princ (format "---------------------------------+----------+--------------+--------------+----------\n"))
    (princ (format "Foveal Macular Tritanopia Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-foveal-scotopic-macula-run)
    (kill-emacs 1)))

(provide 'test-foveal-scotopic-macula)
;;; test-foveal-scotopic-macula.el ends here
