;;; test-lca-chromatic.el --- Longitudinal Chromatic Aberration & Common Focal Plane -*- lexical-binding: t; -*-

(require 'test-palette-extractor)

(defun test-lca-chromatic-run ()
  "Evaluate LCA chromatic dispersion per Thibos et al. (1992)."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (base (plist-get pal :fg-main))
         (base-d (rf-thibos-diopters base))
         (base-wave (rf-effective-wavelength base))
         (passes 0)
         (fails 0)
         (tokens '(("Preprocessor (#define)"           :preprocessor)
                   ("Keywords (struct, while)"         :keyword)
                   ("Data types (int, size_t)"         :type)
                   ("Constants (LOTA_PCR_COUNT)"       :constant)
                   ("Numbers (0, 24, 32)"              :number)
                   ("Builtins (__always_inline)"       :builtin)
                   ("Function definitions"             :fnname)
                   ("Function calls (bpf_...)"         :fnname-call)
                   ("Strings (\"string literals\")"    :string)
                   ("Struct fields (->tgid)"           :property)
                   ("Operators (+, -, *, >>)"          :operator)
                   ("Brackets (( ) [ ] { })"           :bracket)
                   ("Comments (Damp needles)"          :fg-dim)
                   ("Alerts / Errors (!)"              :err))))
    (princ (format "\n======================================================================\n"))
    (princ (format " Longitudinal Chromatic Aberration (LCA) & Common Focal Plane Suite\n"))
    (princ (format " Ref: Thibos et al. (1992) Applied Optics 31(19), DOI: 10.1364/AO.31.003594\n"))
    (princ (format " Theme: %s | Base Text: %s (Eff Wave: %.1fnm, Refraction: %.3fD)\n"
                   theme base base-wave base-d))
    (princ (format "======================================================================\n"))
    (princ (format "%-32s | %-8s | %-8s | %-8s | %-7s | %-8s\n"
                   "Token Role" "Hex" "Eff Wave" "D(lambda)" "Delta-D" "Status"))
    (princ (format "---------------------------------+----------+----------+----------+---------+----------\n"))
    (dolist (tok tokens)
      (let* ((name (nth 0 tok))
             (key  (nth 1 tok))
             (hex (plist-get pal key))
             (wave (rf-effective-wavelength hex))
             (d (rf-thibos-diopters hex))
             (delta-d (rf-lca-disparity hex base))
             (ok (<= delta-d 0.250)))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "%-32s | %-8s | %6.1fnm | %+7.3fD | %6.3fD  | %s\n"
                       name hex wave d delta-d
                       (if ok "PASS" "FAIL (>0.25D)")))))
    (princ (format "---------------------------------+----------+----------+----------+---------+----------\n"))
    (princ (format "LCA Common Focal Plane Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-lca-chromatic-run)
    (kill-emacs 1)))

(provide 'test-lca-chromatic)
;;; test-lca-chromatic.el ends here
