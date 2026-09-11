;;; test-toric-blur-astigmatism.el --- Toric Blur PSF & Astigmatic Glyph Legibility -*- lexical-binding: t; -*-

(require 'test-palette-extractor)

(defun test-toric-blur-astigmatism-run ()
  "Evaluate blurred edge Michelson contrast under 1.25D toric astigmatic defocus.
Ref: Legras et al. (2004) Ophthalmic Physiol Opt; Charman (2005) Clin Exp Optom."
  (let* ((pal (rainforest-extract-active-palette))
         (theme (plist-get pal :theme))
         (bg (plist-get pal :bg-main))
         (blur-factor 0.60) ; cylinder 1.25D stroke peak attenuation
         (passes 0)
         (fails 0)
         (tokens '(("Base text (Mineral quartz)"       :fg-main      0.70)
                   ("Keywords (struct, while)"         :keyword      0.45)
                   ("Data types (int, size_t)"         :type         0.45)
                   ("Preprocessor (#define)"           :preprocessor 0.45)
                   ("Function definitions"             :fnname       0.45)
                   ("Numbers (0, 24, 32)"              :number       0.45)
                   ("Builtins (__always_inline)"       :builtin      0.45)
                   ("Brackets (( ) [ ] { })"           :bracket      0.45)
                   ("Comments (Damp needles)"          :fg-dim       0.45))))
    (princ (format "\n======================================================================\n"))
    (princ (format " Toric Blur Astigmatism PSF Suite (1.25D Cylinder Defocus)\n"))
    (princ (format " Ref: Legras et al. (2004); Charman (2005); Thibos (2004)\n"))
    (princ (format " Gate: Post-Blur Michelson Contrast Cm >= 0.70 (Base Text), >= 0.45 (Syntax)\n"))
    (princ (format " Theme: %s | Background: %s (Lum: %.6f)\n" theme bg (rf-luminance-y bg)))
    (princ (format "======================================================================\n"))
    (princ (format "%-30s | %-8s | %-8s | %-12s | %-8s | %-8s\n"
                   "Glyph Role" "Hex" "Y_token" "Cm (Blurred)" "Min Req" "Status"))
    (princ (format "-------------------------------+----------+----------+--------------+----------+----------\n"))
    (dolist (tok tokens)
      (let* ((label   (nth 0 tok))
             (key     (nth 1 tok))
             (min-cm  (nth 2 tok))
             (hex     (plist-get pal key))
             (y-tok   (rf-luminance-y hex))
             (cm      (rf-toric-blur-michelson hex bg blur-factor))
             (ok      (>= cm min-cm)))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "%-30s | %-8s | %8.4f | %12.4f | %8.2f | %s\n"
                       label hex y-tok cm min-cm
                       (if ok "PASS" "FAIL")))))
    (princ (format "-------------------------------+----------+----------+--------------+----------+----------\n"))
    (princ (format "Toric Blur Astigmatism Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-toric-blur-astigmatism-run)
    (kill-emacs 1)))

(provide 'test-toric-blur-astigmatism)
;;; test-toric-blur-astigmatism.el ends here
