;;; test-macular-hazard-blue-light.el --- IEC 62471 Retinal Blue Light Hazard & RPE Phototoxicity -*- lexical-binding: t; -*-

(require 'test-palette-extractor)

(defun test-macular-hazard-blue-light-run ()
  "Evaluate retinal blue light photochemical hazard E_B per IEC 62471 / CIE S 009.
High-Energy Visible (HEV) blue light (415-455 nm) induces oxidative stress in retinal
pigment epithelium (RPE) cells and lipofuscin phototoxicity (A2E generation).
Ref: IEC 62471:2006; Algvere et al. (2006) Acta Ophthalmol; Margrain et al. (2004) Eye."
  (let* ((pal (rainforest-extract-active-palette))
         (theme (plist-get pal :theme))
         (polarity (rf-theme-polarity theme))
         (bg (plist-get pal :bg-main))
         (bg-y (rf-luminance-y bg))
         (passes 0)
         (fails 0)
         (tokens '(("Base text (Mineral quartz)"       :fg-main)
                   ("Comments (Damp needles)"          :fg-dim)
                   ("Cursor (Raindrop glint)"          :cursor)
                   ("Preprocessor (#define)"           :preprocessor)
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
                   ("Alerts / Errors (!)"              :err))))

    (princ (format "\n======================================================================\n"))
    (princ (format " IEC 62471 Retinal Blue Light Photochemical Hazard & RPE Gate Suite\n"))
    (princ (format " Ref: IEC 62471:2006; CIE S 009; Algvere, Marshall & Seregard (2006)\n"))
    (princ (format " Theme: %s (%s) | Background: %s (Y_bg: %.6f)\n" theme polarity bg bg-y))
    (princ (format "======================================================================\n"))

    ;; Part 1: Retinal Blue Light Hazard (E_B) per Token
    (princ "\nPart 1: Retinal Blue Light Hazard Irradiance E_B [B(lambda) weighted]:\n")
    (princ (format "%-30s | %-8s | %-8s | %-8s | %-7s | %-10s | %-8s\n"
                   "Token Role" "Hex" "Lum (Y)" "E_B" "K_B" "Target E_B" "Status"))
    (princ (format "-------------------------------+----------+----------+----------+---------+------------+----------\n"))
    (dolist (tok tokens)
      (let* ((label (car tok))
             (key   (cadr tok))
             (hex   (plist-get pal key))
             (y-val (rf-luminance-y hex))
             (eb    (rf-blue-light-hazard-eb hex))
             (kb    (if (> y-val 1e-6) (/ eb y-val) 0.0))
             (max-eb (if (eq polarity 'light)
                         0.20
                       (cond
                        ;; Warm and neutral tokens: strictly shielded against HEV blue light
                        ((memq key '(:string :number :builtin :err :fg-dim :type :keyword :preprocessor :operator :bracket)) 0.25)
                        ;; Short-wavelength tokens: safe nocturnal limits
                        (t 0.55))))
             (max-kb (if (eq polarity 'light) 5.0 2.05))
             (ok (and (<= eb max-eb) (<= kb max-kb))))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "%-30s | %-8s | %8.4f | %8.4f | %6.2fx | <= %6.2f  | %s\n"
                       label hex y-val eb kb max-eb (if ok "PASS" "FAIL")))))
    (princ (format "-------------------------------+----------+----------+----------+---------+------------+----------\n"))

    ;; Part 2: Background Canvas Blue Light Hazard
    (princ "\nPart 2: Background Canvas HEV Phototoxicity Check:\n")
    (let* ((bg-eb (rf-blue-light-hazard-eb bg))
           (max-bg-eb (if (eq polarity 'light) 0.50 0.020))
           (bg-ok (<= bg-eb max-bg-eb)))
      (if bg-ok
          (progn
            (princ (format "   [PASS] Background E_B = %.6f <= %.4f: No nocturnal RPE photo-oxidation hazard.\n"
                           bg-eb max-bg-eb))
            (setq passes (1+ passes)))
        (princ (format "   [FAIL] Background E_B = %.6f > %.4f: High blue light background exposure.\n"
                       bg-eb max-bg-eb))
        (setq fails (1+ fails))))

    (princ (format "\n----------------------------------------------------------------------\n"))
    (princ (format "IEC 62471 Blue Light Hazard Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-macular-hazard-blue-light-run)
    (kill-emacs 1)))

(provide 'test-macular-hazard-blue-light)
;;; test-macular-hazard-blue-light.el ends here
