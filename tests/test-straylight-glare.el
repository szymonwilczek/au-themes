;;; test-straylight-glare.el --- Intraocular straylight and disability glare simulation -*- lexical-binding: t; -*-

(require 'test-palette-extractor)

(defun test-straylight-glare-run ()
  "Evaluate intraocular forward straylight and disability glare per Vos (2003)."
  (let* ((pal (au-extract-active-palette))
         (bg (plist-get pal :bg-main))
         (fg (plist-get pal :fg-main))
         (theme (plist-get pal :theme))
         (polarity (rf-theme-polarity theme))
         (y-bg (rf-luminance-y bg))
         (y-fg (rf-luminance-y fg))
         ;; Weber contrast magnitude
         (weber-contrast (if (eq polarity 'light)
                             (/ (- y-bg y-fg) (max 0.0001 y-bg))
                           (/ (- y-fg y-bg) (max 0.0001 y-bg))))
         ;; Clinical ocular straylight parameter s at 10 deg per Vos (2003) / CIE 146:2002
         (s-10 (* 100.0 (rf-glare-spread-function 10.0)))
         (log-s (log s-10 10))
         (passes 0)
         (fails 0)
         (warnings 0))
    (princ (format "\n======================================================================\n"))
    (princ (format " Intraocular Straylight & Disability Glare Suite\n"))
    (princ (format " Ref: Vos (2003), CIE Report on Disability Glare (CIE 146:2002)\n"))
    (princ (format " Theme: %s (%s) | Background: %s\n" theme polarity bg))
    (princ (format "======================================================================\n"))
    (princ (format "Background Luminance (rel Y):  %.6f\n" y-bg))
    (princ (format "Foreground Luminance (rel Y):  %.6f\n" y-fg))
    (princ (format "Weber Contrast Ratio (|C_W|):  %.2f\n" weber-contrast))
    (princ (format "Ocular Straylight s(10 deg):   %.2f deg^2/sr [log(s) = %.2f]\n" s-10 log-s))
    (princ (format "----------------------------------------------------------------------\n"))

    (if (eq polarity 'light)
        (progn
          ;; Test 1: Muted canopy daylight background (Y_bg <= 0.85)
          (princ "1. Photopic Glare Avoidance (Background Y_bg <= 0.8500):\n")
          (if (<= y-bg 0.8500)
              (progn
                (princ "   [PASS] Background is soft canopy mist; avoids stark white corneal glare.\n")
                (setq passes (1+ passes)))
            (princ "   [WARN] Blinding bright background: risk of photophobia and pupillary strain.\n")
            (setq warnings (1+ warnings)))

          ;; Test 2: Controlled contrast against harsh black (Weber |C_W| <= 0.98)
          (princ "2. Non-Harsh Edge Contrast (|C_W| <= 0.98):\n")
          (if (<= weber-contrast 0.98)
              (progn
                (princ "   [PASS] Contrast balanced; avoids harsh letter-edge glare and irradiation halo.\n")
                (setq passes (1+ passes)))
            (princ "   [FAIL] Harsh contrast divergence: text is too black against background.\n")
            (setq fails (1+ fails))))
      ;; Dark mode
      ;; Test 1: Weber contrast divergence avoidance (C_W <= 60.0)
      (princ "1. Character Edge Haloing (Weber C_W <= 60.0):\n")
      (if (<= weber-contrast 60.0)
          (progn
            (princ "   [PASS] Weber contrast controlled; no intraocular halo glowing at letter edges.\n")
            (setq passes (1+ passes)))
        (princ "   [WARN] High Weber contrast: risk of disability glare on older eyes / astigmatism.\n")
        (setq warnings (1+ warnings)))

      ;; Test 2: Minimum luminance floor (Y_bg >= 0.0010)
      (princ "2. Absolute Black Hole Avoidance (Y_bg >= 0.0010):\n")
      (if (>= y-bg 0.0010)
          (progn
            (princ "   [PASS] Background provides adequate luminance floor to prevent contrast divergence.\n")
            (setq passes (1+ passes)))
        (princ "   [FAIL] Background too dark (< 0.0010): creates infinite Weber contrast.\n")
        (setq fails (1+ fails))))

    (princ (format "----------------------------------------------------------------------\n"))
    (princ (format "Straylight & Glare Summary: %d Passed, %d Failed, %d Warnings.\n\n"
                   passes fails warnings))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-straylight-glare-run)
    (kill-emacs 1)))

(provide 'test-straylight-glare)
;;; test-straylight-glare.el ends here
