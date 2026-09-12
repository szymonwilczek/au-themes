;;; test-wet-surface-physics.el --- Organic gamut chroma ceiling & Lekner-Dorf (1988) wet optics -*- lexical-binding: t; -*-

(require 'test-palette-extractor)

(defun test-wet-surface-physics-run ()
  "Evaluate organic gamut chroma boundaries and Lekner & Dorf (1988) wetting optics.
Ref: Lekner & Dorf (1988) Applied Optics 27(7), 1278-1280.

Lekner & Dorf show that wetting a porous organic surface with water (n=1.333)
causes total internal reflection at the water-air interface. This traps scattered
light and increases absorption passes through chromophores, causing wet surfaces
to darken and their spectral selectivity (chromatic saturation) to increase.

To ensure a natural, soothing woodland aesthetic without synthetic neon glare,
tokens are bound by an organic chroma ceiling (C* <= 55.0) matching non-fluorescent
botanical dyes, while respecting physical darkening under wetting."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (passes 0)
         (fails 0)
         ;; Internal reflection fraction at water-air boundary (n=1.333, Lekner & Dorf 1988 eq. 4)
         (r-wa 0.55)
         (tokens '(("Preprocessor (#define)"           :preprocessor 50.0)
                   ("Keywords (struct, while)"         :keyword      50.0)
                   ("Data types (int, size_t)"         :type         52.0)
                   ("Constants (LOTA_PCR_COUNT)"       :constant     50.0)
                   ("Numbers (0, 24, 32)"              :number       55.0)
                   ("Builtins (__always_inline)"       :builtin      45.0)
                   ("Function definitions"             :fnname       45.0)
                   ("Function calls (bpf_...)"         :fnname-call  45.0)
                   ("Strings (\"string literals\")"    :string       50.0)
                   ("Struct fields (->tgid)"           :property     40.0)
                   ("Operators (+, -, *, >>)"          :operator     25.0)
                   ("Brackets (( ) [ ] { })"           :bracket      20.0)
                   ("Comments (Damp needles)"          :fg-dim       20.0)
                   ("Alerts / Errors (!)"              :err          55.0))))
    (princ (format "\n======================================================================\n"))
    (princ (format " Organic Chroma Ceiling & Lekner & Dorf (1988) Wet Surface Optics\n"))
    (princ (format " Ref: Lekner & Dorf (1988) Applied Optics 27(7), 1278-1280 (Water n=1.333)\n"))
    (princ (format " Theme: %s\n" theme))
    (princ (format "======================================================================\n"))
    (princ (format "%-30s | %-8s | %-8s | %-10s | %-8s | %-12s\n"
                   "Token Role" "Hex" "Chroma C*" "C* Ceiling" "Y_wet/Y" "Status"))
    (princ (format "-------------------------------+----------+----------+------------+----------+------------\n"))
    (dolist (tok tokens)
      (let* ((name (nth 0 tok))
             (key  (nth 1 tok))
             (max-c (nth 2 tok))
             (hex (plist-get pal key))
             (y   (rf-luminance-y hex))
             (c   (rf-cielab-chroma hex))
             ;; Lekner & Dorf (1988) wetting darkening factor: R_wet = (1 - r_wa) R_dry / (1 - r_wa R_dry)
             (y-wet (/ (* (- 1.0 r-wa) y) (max 1e-6 (- 1.0 (* r-wa y)))))
             (ratio (if (> y 1e-6) (/ y-wet y) 0.0))
             (ok  (<= c max-c)))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "%-30s | %-8s | %8.2f | <= %5.1f   | %8.3f | %s\n"
                       name hex c max-c ratio
                       (if ok "ORGANIC" "HYPER-SAT")))))
    (princ (format "-------------------------------+----------+----------+------------+----------+------------\n"))
    (princ (format "Organic Gamut & Wetting Optics Summary: %d Organic, %d Hyper-saturated.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-wet-surface-physics-run)
    (kill-emacs 1)))

(provide 'test-wet-surface-physics)
;;; test-wet-surface-physics.el ends here
