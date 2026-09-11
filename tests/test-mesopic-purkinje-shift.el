;;; test-mesopic-purkinje-shift.el --- CIE 191:2010 Mesopic Vision & Purkinje Shift -*- lexical-binding: t; -*-

(require 'test-palette-extractor)

(defun test-mesopic-purkinje-shift-run ()
  "Evaluate mesopic luminance and Purkinje rod-shift per CIE 191:2010.
Ref: CIE Publication 191 (2010); Rea, Freyssinier-Nova & Bullough (2004)."
  (let* ((pal (rainforest-extract-active-palette))
         (theme (plist-get pal :theme))
         (passes 0)
         (fails 0)
         (m-coef 0.45) ; mesopic adaptation coefficient for 0.1 cd/m2 nocturnal ambient
         (tokens '(("Alerts / Errors (!)"              :err          0.020 1.50)
                   ("Keywords (struct, while)"         :keyword      0.020 1.50)
                   ("Data types (int, size_t)"         :type         0.020 1.50)
                   ("Preprocessor (#define)"           :preprocessor 0.020 1.50)
                   ("Function definitions"             :fnname       0.020 1.50)
                   ("Constants (LOTA_PCR_COUNT)"       :constant     0.020 1.50)
                   ("Base text (Mineral quartz)"       :fg-main      0.020 1.50))))
    (princ (format "\n======================================================================\n"))
    (princ (format " CIE 191:2010 Mesopic Photometry & Purkinje Rod Shift Gate Suite\n"))
    (princ (format " Ambient Adaptation: La = 0.1 cd/m2, Mesopic Parameter m = %.2f\n" m-coef))
    (princ (format " Gates: Mesopic Lum Y_mes >= 0.020 (Red Survival), Ratio <= 1.50 (Non-Bloom)\n"))
    (princ (format " Theme: %s\n" theme))
    (princ (format "======================================================================\n"))
    (princ (format "%-30s | %-8s | %-8s | %-8s | %-7s | %-8s\n"
                   "Token Role" "Hex" "Y_phot" "Y_mes" "Ratio" "Status"))
    (princ (format "-------------------------------+----------+----------+----------+---------+----------\n"))
    (dolist (tok tokens)
      (let* ((label    (nth 0 tok))
             (key      (nth 1 tok))
             (min-lum  (nth 2 tok))
             (max-rat  (nth 3 tok))
             (hex      (plist-get pal key))
             (y-phot   (rf-luminance-y hex))
             (y-mes    (rf-mesopic-luminance hex m-coef))
             (ratio    (/ y-mes (max 1e-5 y-phot)))
             (ok       (and (>= y-mes min-lum) (<= ratio max-rat))))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "%-30s | %-8s | %8.4f | %8.4f | %6.2fx  | %s\n"
                       label hex y-phot y-mes ratio
                       (if ok "PASS" "FAIL")))))
    (princ (format "-------------------------------+----------+----------+----------+---------+----------\n"))
    (princ (format "Mesopic Purkinje Shift Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-mesopic-purkinje-shift-run)
    (kill-emacs 1)))

(provide 'test-mesopic-purkinje-shift)
;;; test-mesopic-purkinje-shift.el ends here
