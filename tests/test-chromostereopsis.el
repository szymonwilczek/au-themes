;;; test-chromostereopsis.el --- Chromostereopsis and binocular chromatic dispersion -*- lexical-binding: t; -*-

(require 'test-palette-extractor)

(defun test-chromostereopsis-run ()
  "Evaluate chromostereopsis and binocular chromatic dispersion per Thibos (1992)."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (passes 0)
         (fails 0)
         (max-allowed-delta-d 0.350)
         (pairs '(("Alert / Error vs Function Def"      :err          :fnname)
                  ("Alert / Error vs Function Call"     :err          :fnname-call)
                  ("Alert / Error vs Preprocessor"      :err          :preprocessor)
                  ("Constants vs Function Def"          :constant     :fnname)
                  ("Constants vs Keyword"               :constant     :keyword)
                  ("Numbers vs Function Def"            :number       :fnname)
                  ("Strings vs Function Def"            :string       :fnname)
                  ("Builtins vs Function Def"           :builtin      :fnname)
                  ("Alert / Error vs Keyword"           :err          :keyword)
                  ("Alert / Error vs Base Text"         :err          :fg-main)
                  ("Preprocessor vs Keyword"            :preprocessor :keyword))))
    (princ (format "\n======================================================================\n"))
    (princ (format " Chromostereopsis & Binocular Chromatic Dispersion Suite\n"))
    (princ (format " Ref: Thibos et al. (1992), Vos (1960), Allen (1974)\n"))
    (princ (format " Gate: Delta-D <= %.3f D (Common Binocular Accommodative Range)\n" max-allowed-delta-d))
    (princ (format " Theme: %s\n" theme))
    (princ (format "======================================================================\n"))
    (princ (format "%-33s | %-19s | %-19s | %-8s | %-8s\n"
                   "Interacting Syntax Pair" "Role 1 (Hex, Wave)" "Role 2 (Hex, Wave)" "Delta-D" "Status"))
    (princ (format "----------------------------------+---------------------+---------------------+----------+----------\n"))
    (dolist (p pairs)
      (let* ((label (nth 0 p))
             (k1 (nth 1 p))
             (k2 (nth 2 p))
             (c1 (plist-get pal k1))
             (c2 (plist-get pal k2))
             (w1 (rf-effective-wavelength c1))
             (w2 (rf-effective-wavelength c2))
             (d1 (rf-thibos-diopters c1))
             (d2 (rf-thibos-diopters c2))
             (delta-d (abs (- d1 d2)))
             (ok (<= delta-d max-allowed-delta-d)))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "%-33s | %-7s (%5.1fnm) | %-7s (%5.1fnm) | %6.3fD  | %s\n"
                       label c1 w1 c2 w2 delta-d
                       (if ok "PASS" "FAIL")))))
    (princ (format "----------------------------------+---------------------+---------------------+----------+----------\n"))
    (princ (format "Chromostereopsis Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-chromostereopsis-run)
    (kill-emacs 1)))

(provide 'test-chromostereopsis)
;;; test-chromostereopsis.el ends here
