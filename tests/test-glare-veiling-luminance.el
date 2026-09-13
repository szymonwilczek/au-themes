;;; test-glare-veiling-luminance.el --- Intraocular Veiling Glare & Straylight Integral -*- lexical-binding: t; -*-

(require 'test-palette-extractor)

(defun test-glare-veiling-luminance-run ()
  "Evaluate intraocular veiling glare spatial integral and token contrast retention.
Ref: CIE 112-1994; Vos & van den Berg (1999); IESNA TM-12-12."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (polarity (rf-theme-polarity theme))
         (bg (plist-get pal :bg-main))
         (bg-y (rf-luminance-y bg))
         ;; Veiling luminance is physical (cd/m2) from CIE 146 straylight integral
         (lv-cd (rf-veiling-glare-luminance pal))
         (lv (/ lv-cd rf-display-white-luminance))
         (passes 0)
         (fails 0)
         (tokens
          (if (eq polarity 'light)
              '(("Comments (Misty lichen mulch)"    :fg-dim       35.0 52.0)
                ("Brackets (( ) [ ] { })"           :bracket      45.0 68.0)
                ("Keywords (struct, while)"         :keyword      45.0 68.0)
                ("Data types (int, size_t)"         :type         45.0 68.0)
                ("Preprocessor (#define)"           :preprocessor 45.0 68.0)
                ("Base text (Conifer bark shadow)"  :fg-main      58.0 75.0))
            '(("Comments (Damp needles)"          :fg-dim       10.0 28.0)
              ("Brackets (( ) [ ] { })"           :bracket      14.0 40.0)
              ("Keywords (struct, while)"         :keyword      16.0 55.0)
              ("Data types (int, size_t)"         :type         16.0 55.0)
              ("Preprocessor (#define)"           :preprocessor 16.0 55.0)
              ("Base text (Mineral quartz)"       :fg-main      46.0 62.0)))))
    (princ (format "\n======================================================================\n"))
    (princ (format " Intraocular Veiling Glare & Corneal Straylight Spatial Integral Suite\n"))
    (princ (format " Ref: CIE 146:2002 General Disability Glare Equation (Vos & van den Berg);\n"))
    (princ (format "      Vos (2003) Clin. Exp. Optom. 86(6):363; IESNA TM-12-12\n"))
    (princ (format " Theme: %s (%s) | Background: %s (Lum Y: %.6f)\n" theme polarity bg bg-y))
    (princ (format " Straylight integral (1 deg .. field edge, age %.0f, p = %.1f): %.4f\n"
                   rf-observer-age rf-eye-pigmentation (rf-straylight-integral)))
    (princ (format " Veiling Luminance Lv: %.4f cd/m2 (%.6f of display white)\n" lv-cd lv))
    (princ (format " Note: APCA intrinsically models display black floor (blkThrs/blkClmp).\n"))
    (princ (format "       Veiling glare impact is evaluated via retinal Michelson contrast retention.\n"))
    (princ (format "======================================================================\n"))
    (princ (format "%-30s | %-8s | %-7s | %-12s | %-10s | %-8s\n"
                   "Token Role" "Hex" "|Lc|" "Nominal C_M" "Retinal C_M" "Status"))
    (princ (format "-------------------------------+----------+---------+--------------+------------+----------\n"))
    (dolist (tok tokens)
      (let* ((label    (nth 0 tok))
             (key      (nth 1 tok))
             (min-lc   (nth 2 tok))
             (max-lc   (nth 3 tok))
             (hex      (plist-get pal key))
             (y-tok    (rf-luminance-y hex))
             (lc       (abs (rf-apca-contrast hex bg)))
             ;; Nominal Michelson contrast on panel surface:
             (cm-nom   (/ (abs (- y-tok bg-y)) (max 1e-6 (+ y-tok bg-y))))
             ;; Retinal Michelson contrast with intraocular veiling luminance Lv:
             (cm-ret   (/ (abs (- y-tok bg-y)) (max 1e-6 (+ y-tok bg-y (* 2.0 lv)))))
             ;; Contrast retention ratio: must retain >= 70% under ocular veiling glare
             (retention (/ cm-ret (max 1e-6 cm-nom)))
             (ok       (and (>= lc min-lc) (<= lc max-lc) (>= retention 0.65))))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "%-30s | %-8s | %7.2f | %12.4f | %8.4f   | %s\n"
                       label hex lc cm-nom cm-ret
                       (if ok "PASS" "FAIL")))))
    (princ (format "-------------------------------+----------+---------+--------------+------------+----------\n"))
    (princ (format "Veiling Glare Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-glare-veiling-luminance-run)
    (kill-emacs 1)))

(provide 'test-glare-veiling-luminance)
;;; test-glare-veiling-luminance.el ends here
