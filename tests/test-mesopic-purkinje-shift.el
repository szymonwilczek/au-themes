;;; test-mesopic-purkinje-shift.el --- CIE 191:2010 Mesopic Vision & Purkinje Shift -*- lexical-binding: t; -*-

(require 'test-palette-extractor)

(defun test-mesopic-purkinje-shift-run ()
  "Evaluate mesopic luminance and Purkinje rod shift per CIE 191:2010.

Method (corrected 2026 audit):
  - The adaptation coefficient m is a property of the ADAPTATION FIELD, not
    of a single token.  It is obtained from the mean luminance of an 80x40
    viewport via the iterative MES-2 procedure of CIE 191:2010 (m_0 = 0.5,
    a = 0.767, b = 0.3334), not fixed at an arbitrary 0.45.
  - Luminances are absolute (cd/m^2).  The scotopic luminance is the
    V'(lambda)-weighted radiance of the reference display model, so the
    display S/P ratio (2.54) enters the rod term; the previous normalised
    RGB weights implied S/P = 1 and suppressed the rod contribution by a
    factor of ~2.5.
  - CIE 191 is defined only for adaptation luminances in [0.005, 5] cd/m^2.
    Because the mesopic state depends on display brightness, the gate is
    evaluated at a nocturnal setting that places the adaptation field inside
    that domain (worst case for rod intrusion), and the brightness at which
    the theme leaves the mesopic domain is reported.
Ref: CIE 191:2010 Recommended System for Mesopic Photometry Based on Visual
Performance, ISBN 978-3-901906-88-6; Rea, Bullough, Freyssinier-Nova &
Bierman (2004) Lighting Res. Technol. 36(2):85-109,
DOI: 10.1191/1365782804li114oa."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (polarity (rf-theme-polarity theme))
         (passes 0)
         (fails 0)
         ;; Nocturnal display setting: 25 % of the IEC 61966-2-1 reference
         ;; white (80 cd/m2).  Chosen so the adaptation field of a dark theme
         ;; falls inside the CIE 191 mesopic domain.
         (white-cd (* 0.25 rf-display-white-luminance))
         (view-y (rf-viewport-mean-luminance-y pal))
         (la-p (* view-y white-cd))
         ;; S/P ratio of the field, taken from the dominant canvas colour.
         (sp-ratio (/ (rf-scotopic-luminance (plist-get pal :bg-main) white-cd)
                      (max 1e-9 (rf-luminance-cd (plist-get pal :bg-main) white-cd))))
         (la-s (* sp-ratio la-p))
         (m (rf-mesopic-adaptation-coefficient la-p la-s))
         ;; Display brightness at which the viewport reaches the 5 cd/m2
         ;; photopic boundary of the CIE 191 domain.
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
    (princ (format " Gate: Purkinje luminance shift |L_mes/L_p - 1| <= 0.25 per token\n"))
    (princ (format "======================================================================\n"))
    (princ (format "%-30s | %-8s | %-10s | %-10s | %-7s | %-8s\n"
                   "Token Role" "Hex" "L_p cd/m2" "L_mes" "Shift" "Status"))
    (princ (format "-------------------------------+----------+------------+------------+---------+----------\n"))
    (dolist (tok tokens)
      (let* ((label    (nth 0 tok))
             (key      (nth 1 tok))
             (hex      (plist-get pal key))
             (lp       (rf-luminance-cd hex white-cd))
             (lmes     (rf-mesopic-luminance hex m white-cd))
             (shift    (- (/ lmes (max 1e-9 lp)) 1.0))
             (ok       (<= (abs shift) 0.25)))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "%-30s | %-8s | %10.4f | %10.4f | %+6.1f%% | %s\n"
                       label hex lp lmes (* 100.0 shift)
                       (if ok "PASS" "FAIL")))))
    (princ (format "-------------------------------+----------+------------+------------+---------+----------\n"))
    (princ "Interpretation: a negative shift means the token loses luminance when rods\n")
    (princ "contribute (long-wavelength reds); a positive shift means rod-driven gain\n")
    (princ "(short-wavelength blues).  Bounding the shift keeps the syntactic luminance\n")
    (princ "hierarchy stable as the eye drifts between photopic and mesopic adaptation.\n")
    (princ (format "Mesopic Purkinje Shift Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-mesopic-purkinje-shift-run)
    (kill-emacs 1)))

(provide 'test-mesopic-purkinje-shift)
;;; test-mesopic-purkinje-shift.el ends here
