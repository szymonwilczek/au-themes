;;; test-cvd-colorblindness.el --- Congenital Color Vision Deficiency (CVD) Simulation -*- lexical-binding: t; -*-

(require 'test-palette-extractor)

(defun test-cvd-colorblindness-run ()
  "Evaluate syntax token discriminability under Protanopia, Deuteranopia, and Tritanopia.
Ref: Machado et al. (2009) IEEE TVCG, Brettel et al. (1997) JOSA A."
  (let* ((pal (rainforest-extract-active-palette))
         (theme (plist-get pal :theme))
         (passes 0)
         (fails 0)
         (min-distance 3500)
         (cvd-modes '((protan . "Protanopia (Red-Blind)")
                      (deutan . "Deuteranopia (Green-Blind)")
                      (tritan . "Tritanopia (Blue-Blind)")))
         (pairs '(("Keyword vs Data Type"        :keyword      :type)
                  ("Keyword vs Builtin"          :keyword      :builtin)
                  ("Keyword vs Number"           :keyword      :number)
                  ("Data Type vs String"         :type         :string)
                  ("Preprocessor vs Constant"    :preprocessor :constant)
                  ("Function Def vs Data Type"   :fnname       :type)
                  ("Alert / Error vs Base Text"  :err          :fg-main))))
    (princ (format "\n======================================================================\n"))
    (princ (format " Color Vision Deficiency (CVD) Accessibility Gate Suite\n"))
    (princ (format " Ref: Machado, Oliveira & Fernandes (2009); Brettel et al. (1997)\n"))
    (princ (format " Requirement: Minimum Pairwise Emacs Distance >= %d in all CVD modes\n" min-distance))
    (princ (format " Theme: %s\n" theme))
    (princ (format "======================================================================\n"))
    (dolist (mode-spec cvd-modes)
      (let ((mode (car mode-spec))
            (label (cdr mode-spec)))
        (princ (format "\nMode: %s\n" label))
        (princ (format "%-28s | %-16s | %-16s | %-8s | %-8s\n"
                       "Syntax Pair" "Simulated 1" "Simulated 2" "Distance" "Status"))
        (princ (format "-----------------------------+------------------+------------------+----------+----------\n"))
        (dolist (p pairs)
          (let* ((p-label (nth 0 p))
                 (k1      (nth 1 p))
                 (k2      (nth 2 p))
                 (c1      (plist-get pal k1))
                 (c2      (plist-get pal k2))
                 (sim1    (rf-cvd-simulate c1 mode))
                 (sim2    (rf-cvd-simulate c2 mode))
                 (dist    (rf-color-distance sim1 sim2))
                 (ok      (>= dist min-distance)))
            (if ok
                (setq passes (1+ passes))
              (setq fails (1+ fails)))
            (princ (format "%-28s | %-8s (%s) | %-8s (%s) | %8d | %s\n"
                           p-label c1 sim1 c2 sim2 dist
                           (if ok "PASS" "FAIL")))))
        (princ (format "-----------------------------+------------------+------------------+----------+----------\n"))))
    (princ (format "\nCVD Simulation Summary: %d Passed, %d Failed across all 3 modes.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-cvd-colorblindness-run)
    (kill-emacs 1)))

(provide 'test-cvd-colorblindness)
;;; test-cvd-colorblindness.el ends here
