;;; test-spatial-frequency-csf.el --- Barten (1999) Contrast Sensitivity Function (CSF) for typography -*- lexical-binding: t; -*-

(require 'test-palette-extractor)

(defun test-spatial-frequency-csf-run ()
  "Evaluate typographical stroke contrast against Barten (1999) CSF threshold under astigmatic defocus."
  (let* ((pal (rainforest-extract-active-palette))
         (bg (plist-get pal :bg-main))
         (theme (plist-get pal :theme))
         (passes 0)
         (fails 0)
         ;; At 60cm viewing distance and 13pt font, character stroke spatial frequency is ~6 cpd (cycles per degree).
         ;; Under 1.0D astigmatic cylinder, the optical transfer function attenuates contrast by ~40%.
         ;; Barten CSF threshold at 6 cpd is approximately m_t = 0.015 (Michelson contrast).
         ;; With astigmatic safety factor x4, required Michelson contrast is m >= 0.060.
         (tokens '(("Base text (Mineral quartz)"       :fg-main      0.35)
                   ("Comments (Damp needles)"          :fg-dim       0.12)
                   ("Cursor (Raindrop glint)"          :cursor       0.25)
                   ("Preprocessor (#define)"           :preprocessor 0.25)
                   ("Keywords (struct, while)"         :keyword      0.15)
                   ("Data types (int, size_t)"         :type         0.25)
                   ("Constants (LOTA_PCR_COUNT)"       :constant     0.15)
                   ("Numbers (0, 24, 32)"              :number       0.25)
                   ("Builtins (__always_inline)"       :builtin      0.15)
                   ("Function definitions"             :fnname       0.15)
                   ("Function calls (bpf_...)"         :fnname-call  0.25)
                   ("Strings (\"string literals\")"    :string       0.20)
                   ("Struct fields (->tgid)"           :property     0.20)
                   ("Operators (+, -, *, >>)"          :operator     0.15)
                   ("Brackets (( ) [ ] { })"           :bracket      0.12)
                   ("Alerts / Errors (!)"              :err          0.15))))
    (princ (format "\n======================================================================\n"))
    (princ (format " Barten (1999) Contrast Sensitivity Function (CSF) & MTF Suite\n"))
    (princ (format " Typography: 6 cycles/degree (13pt at 60cm) with Astigmatic Cylinder Defocus\n"))
    (princ (format " Theme: %s | Background: %s\n" theme bg))
    (princ (format "======================================================================\n"))
    (princ (format "%-32s | %-8s | %-12s | %-12s | %-8s\n"
                   "Token Role" "Hex" "Michelson m" "Min Michelson" "Status"))
    (princ (format "---------------------------------+----------+--------------+--------------+----------\n"))
    (dolist (tok tokens)
      (let* ((name (nth 0 tok))
             (key  (nth 1 tok))
             (min-m (nth 2 tok))
             (hex (plist-get pal key))
             (y-txt (rf-luminance-y hex))
             (y-bg  (rf-luminance-y bg))
             ;; Michelson contrast: m = (L_max - L_min) / (L_max + L_min)
             (m (/ (- (max y-txt y-bg) (min y-txt y-bg))
                   (+ (max y-txt y-bg) (min y-txt y-bg))))
             (ok (>= m min-m)))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "%-32s | %-8s | %10.4f   | >= %6.4f    | %s\n"
                       name hex m min-m
                       (if ok "PASS" "FAIL")))))
    (princ (format "---------------------------------+----------+--------------+--------------+----------\n"))
    (princ (format "Barten CSF Typography Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-spatial-frequency-csf-run)
    (kill-emacs 1)))

(provide 'test-spatial-frequency-csf)
;;; test-spatial-frequency-csf.el ends here
