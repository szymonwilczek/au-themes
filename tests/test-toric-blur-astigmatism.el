;;; test-toric-blur-astigmatism.el --- Toric Blur PSF & Astigmatic Glyph Legibility -*- lexical-binding: t; -*-

(require 'test-palette-extractor)

(defun test-toric-blur-astigmatism-run ()
  "Evaluate blurred edge Michelson contrast under 1.25D toric astigmatic defocus.
Ref: Legras et al. (2004) Ophthalmic Physiol Opt; Charman (2005) Clin Exp Optom."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (bg (plist-get pal :bg-main))
         (polarity (rf-theme-polarity theme))
         ;; Geometric optics: beta = d*C/2; for d=4.3mm, C=1.25D, w=1.6', eta = 4w/(pi*beta) ~= 0.22
         (blur-factor 0.22)
         (passes 0)
         (fails 0)
         (tokens '(("Base text"                 :fg-main)
                   ("Keywords (struct, while)"   :keyword)
                   ("Data types (int, size_t)"   :type)
                   ("Preprocessor (#define)"     :preprocessor)
                   ("Function definitions"       :fnname)
                   ("Numbers (0, 24, 32)"        :number)
                   ("Builtins (__always_inline)" :builtin)
                   ("Brackets (( ) [ ] { })"     :bracket)
                   ("Comments (Damp needles)"    :fg-dim))))
    (princ (format "\n======================================================================\n"))
    (princ (format " Toric Blur Astigmatism PSF Suite (1.25D Cylinder Defocus)\n"))
    (princ (format " Ref: Legras et al. (2004); Charman (2005); Thibos (2004)\n"))
    (princ (format " Theme: %s (%s) | Background: %s (Lum: %.6f)\n" theme polarity bg (rf-luminance-y bg)))
    (princ (format "======================================================================\n"))
    (princ (format "%-30s | %-8s | %-8s | %-12s | %-8s | %-8s\n"
                   "Glyph Role" "Hex" "Y_token" "Cm (Blurred)" "Min Req" "Status"))
    (princ (format "-------------------------------+----------+----------+--------------+----------+----------\n"))
    (dolist (tok tokens)
      (let* ((label   (nth 0 tok))
             (key     (nth 1 tok))
             (min-cm  (if (eq polarity 'light)
                          ;; For dark strokes on light background, maximum theoretical Cm is eta/(2-eta) ~= 0.1236.
                          ;; Detection threshold at 6 cpd is mt = 0.015; Cm >= 0.08 is >5x suprathreshold.
                          (if (eq key :fg-main) 0.10 0.08)
                        (if (eq key :fg-main) 0.70 0.45)))
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
