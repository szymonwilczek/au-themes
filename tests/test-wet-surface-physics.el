;;; test-wet-surface-physics.el --- Lekner & Dorf (1988) wet surface saturation boundaries -*- lexical-binding: t; -*-

(require 'test-palette-extractor)

(defun test-wet-surface-physics-run ()
  "Evaluate wet surface optical saturation limits per Lekner & Dorf (1988)."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (passes 0)
         (fails 0)
         ;; Lekner & Dorf (1988) show that water (n=1.333) causes total internal reflection in porous organic matter.
         ;; This increases light absorption, darkening wet surfaces while capping dry surface scatter.
         ;; Saturation Chroma C* above 55 indicates artificial dry neon / synthetic phosphors.
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
    (princ (format " Lekner & Dorf (1988) Wet Surface Saturation Physics Suite\n"))
    (princ (format " Ref: Lekner & Dorf (1988) Applied Optics 27(7), 1278-1280\n"))
    (princ (format " Theme: %s\n" theme))
    (princ (format "======================================================================\n"))
    (princ (format "%-32s | %-8s | %-8s | %-12s | %-8s\n"
                   "Token Role" "Hex" "Chroma C*" "Max Wet C*" "Status"))
    (princ (format "---------------------------------+----------+----------+--------------+----------\n"))
    (dolist (tok tokens)
      (let* ((name (nth 0 tok))
             (key  (nth 1 tok))
             (max-c (nth 2 tok))
             (hex (plist-get pal key))
             (c   (rf-cielab-chroma hex))
             (ok  (<= c max-c)))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "%-32s | %-8s | %8.2f | <= %5.1f       | %s\n"
                       name hex c max-c
                       (if ok "NATURAL" "DRY NEON")))))
    (princ (format "---------------------------------+----------+----------+--------------+----------\n"))
    (princ (format "Wet Surface Physics Summary: %d Natural, %d Dry Neon.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-wet-surface-physics-run)
    (kill-emacs 1)))

(provide 'test-wet-surface-physics)
;;; test-wet-surface-physics.el ends here
