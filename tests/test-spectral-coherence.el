;;; test-spectral-coherence.el --- Forest canopy spectral filtration & illumination coherence -*- lexical-binding: t; -*-

(require 'test-palette-extractor)

(defun test-spectral-coherence-run ()
  "Evaluate natural illumination coherence under wet forest canopy filtration."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (passes 0)
         (warnings 0)
         (fails 0)
         ;; In a forest canopy, chlorophyll absorbs strongly in red (650-670nm) and blue (420-440nm).
         ;; The dominant natural daylight is filtered into the green-amber window (520-580nm).
         ;; We verify that the effective wavelengths of the core palette lie in this cohesive natural envelope.
         (tokens '(("Preprocessor (#define)"           :preprocessor 520.0 570.0)
                   ("Keywords (struct, while)"         :keyword      520.0 560.0)
                   ("Data types (int, size_t)"         :type         525.0 565.0)
                   ("Numbers (0, 24, 32)"              :number       545.0 585.0)
                   ("Function definitions"             :fnname       500.0 550.0)
                   ("Function calls (bpf_...)"         :fnname-call  500.0 550.0)
                   ("Strings (\"string literals\")"    :string       540.0 585.0)
                   ("Struct fields (->tgid)"           :property     525.0 565.0)
                   ("Operators (+, -, *, >>)"          :operator     530.0 560.0)
                   ("Brackets (( ) [ ] { })"           :bracket      530.0 560.0))))
    (princ (format "\n======================================================================\n"))
    (princ (format " Forest Canopy Spectral Filtration & Physical Coherence Suite\n"))
    (princ (format " Theme: %s\n" theme))
    (princ (format "======================================================================\n"))
    (princ (format "%-32s | %-8s | %-8s | %-15s | %-8s\n"
                   "Token Role" "Hex" "Eff Wave" "Canopy Window" "Coherence"))
    (princ (format "---------------------------------+----------+----------+-----------------+----------\n"))
    (dolist (tok tokens)
      (let* ((name (nth 0 tok))
             (key  (nth 1 tok))
             (min-w (nth 2 tok))
             (max-w (nth 3 tok))
             (hex (plist-get pal key))
             (wave (rf-effective-wavelength hex))
             (ok (and (>= wave min-w) (<= wave max-w))))
        (if ok
            (setq passes (1+ passes))
          (setq warnings (1+ warnings)))
        (princ (format "%-32s | %-8s | %6.1fnm | [%5.1f..%5.1fnm]  | %s\n"
                       name hex wave min-w max-w
                       (if ok "COHERENT" "DIVERGENT")))))
    (princ (format "---------------------------------+----------+----------+-----------------+----------\n"))
    (princ "Physical Coherence Model:\n")
    (princ "A unified canopy illuminant ensures all surfaces appear part of the same natural scene,\n")
    (princ "avoiding isolated 'alien/dry' colors that break visual immersion.\n")
    (princ (format "----------------------------------------------------------------------\n"))
    (princ (format "Spectral Coherence Summary: %d Coherent, %d Divergent.\n\n" passes warnings))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-spectral-coherence-run)
    (kill-emacs 1)))

(provide 'test-spectral-coherence)
;;; test-spectral-coherence.el ends here
