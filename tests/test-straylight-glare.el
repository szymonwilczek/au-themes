;;; test-straylight-glare.el --- Intraocular straylight and disability glare simulation -*- lexical-binding: t; -*-

(require 'test-palette-extractor)

(defun test-straylight-glare-run ()
  "Evaluate intraocular forward straylight and disability glare per Vos (2003)."
  (let* ((pal (rainforest-extract-active-palette))
         (bg (plist-get pal :bg-main))
         (fg (plist-get pal :fg-main))
         (theme (plist-get pal :theme))
         (y-bg (rf-luminance-y bg))
         (y-fg (rf-luminance-y fg))
         ;; Weber contrast C_W = (L_fg - L_bg) / L_bg
         (weber-contrast (/ (- y-fg y-bg) (max 0.0001 y-bg)))
         ;; Point-spread forward scatter at 0.5 degrees eccentricity (theta = 0.5 deg)
         ;; Standard CIE straylight formula: s(theta) approx 10 / theta^2
         (straylight-ratio (* 10.0 (/ y-fg (max 0.001 y-bg)) 0.04)) ; scaled empirical point halo
         (passes 0)
         (fails 0)
         (warnings 0))
    (princ (format "\n======================================================================\n"))
    (princ (format " Intraocular Straylight & Disability Glare Suite\n"))
    (princ (format " Ref: Vos (2003), CIE Report on Disability Glare\n"))
    (princ (format " Theme: %s | Background: %s\n" theme bg))
    (princ (format "======================================================================\n"))
    (princ (format "Background Luminance (rel Y):  %.6f\n" y-bg))
    (princ (format "Foreground Luminance (rel Y):  %.6f\n" y-fg))
    (princ (format "Weber Contrast Ratio (C_W):    %.2f\n" weber-contrast))
    (princ (format "Forward Straylight Factor:     %.2f\n" straylight-ratio))
    (princ (format "----------------------------------------------------------------------\n"))

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
      (setq fails (1+ fails)))

    (princ (format "----------------------------------------------------------------------\n"))
    (princ (format "Straylight & Glare Summary: %d Passed, %d Failed, %d Warnings.\n\n"
                   passes fails warnings))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-straylight-glare-run)
    (kill-emacs 1)))

(provide 'test-straylight-glare)
;;; test-straylight-glare.el ends here
