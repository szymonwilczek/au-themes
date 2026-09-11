;;; test-glare-veiling-luminance.el --- Intraocular Veiling Glare & Straylight Integral -*- lexical-binding: t; -*-

(require 'test-palette-extractor)

(defun test-glare-veiling-luminance-run ()
  "Evaluate intraocular veiling glare spatial integral and token contrast retention.
Ref: CIE 112-1994; Vos & van den Berg (1999); IESNA TM-12-12."
  (let* ((pal (rainforest-extract-active-palette))
         (theme (plist-get pal :theme))
         (polarity (rf-theme-polarity theme))
         (bg (plist-get pal :bg-main))
         (bg-y (rf-apca-screen-y bg))
         (lv (rf-veiling-glare-luminance pal))
         (eff-bg-y (+ bg-y lv))
         (passes 0)
         (fails 0)
         (tokens
          (if (eq polarity 'light)
              '(("Comments (Misty lichen mulch)"    :fg-dim       35.0 52.0)
                ("Brackets (( ) [ ] { })"           :bracket      48.0 68.0)
                ("Keywords (struct, while)"         :keyword      48.0 68.0)
                ("Data types (int, size_t)"         :type         48.0 68.0)
                ("Preprocessor (#define)"           :preprocessor 48.0 68.0)
                ("Base text (Conifer bark shadow)"  :fg-main      62.0 75.0))
            '(("Comments (Damp needles)"          :fg-dim       12.0 28.0)
              ("Brackets (( ) [ ] { })"           :bracket      14.0 40.0)
              ("Keywords (struct, while)"         :keyword      16.0 55.0)
              ("Data types (int, size_t)"         :type         16.0 55.0)
              ("Preprocessor (#define)"           :preprocessor 16.0 55.0)
              ("Base text (Mineral quartz)"       :fg-main      46.0 62.0)))))
    (princ (format "\n======================================================================\n"))
    (princ (format " Intraocular Veiling Glare & Corneal Straylight Spatial Integral Suite\n"))
    (princ (format " Ref: CIE 112-1994; Vos & van den Berg (1999) CIE Report on Disability Glare\n"))
    (princ (format " Theme: %s (%s) | Background: %s (Lum: %.6f)\n" theme polarity bg bg-y))
    (princ (format " Veiling Luminance (Lv): %.6f\n" lv))
    (princ (format "======================================================================\n"))
    (princ (format "%-30s | %-8s | %-7s | %-12s | %-12s | %-8s\n"
                   "Token Role" "Hex" "|Lc(eff)|" "Raw |Lc|" "Target |Lc|" "Status"))
    (princ (format "-------------------------------+----------+---------+--------------+--------------+----------\n"))
    (dolist (tok tokens)
      (let* ((label    (nth 0 tok))
             (key      (nth 1 tok))
             (min-lc   (nth 2 tok))
             (max-lc   (nth 3 tok))
             (hex      (plist-get pal key))
             (raw-y    (rf-apca-screen-y hex))
             (raw-lc   (abs (rf-apca-contrast hex bg)))
             (eff-tok-y (+ raw-y lv))
             (eff-lc   (abs (rf-apca-from-luminance eff-tok-y eff-bg-y)))
             (ok       (and (>= eff-lc min-lc) (<= eff-lc max-lc))))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "%-30s | %-8s | %7.2f | %12.2f | [%4.1f..%4.1f]   | %s\n"
                       label hex eff-lc raw-lc min-lc max-lc
                       (if ok "PASS" "FAIL")))))
    (princ (format "-------------------------------+----------+---------+--------------+--------------+----------\n"))
    (princ (format "Veiling Glare Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-glare-veiling-luminance-run)
    (kill-emacs 1)))

(provide 'test-glare-veiling-luminance)
;;; test-glare-veiling-luminance.el ends here
