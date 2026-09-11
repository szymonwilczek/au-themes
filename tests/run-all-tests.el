;;; run-all-tests.el --- Master test suite runner -*- lexical-binding: t; -*-
(require 'test-palette-extractor)

(defvar rf-running-all-tests t
  "Flag indicating that master test suite runner is active.")

(defvar rf-test-modules
  '(test-apca-contrast
    test-wcag21-ratios
    test-astigmatism-ciliary
    test-pupil-aberrations
    test-straylight-glare
    test-lca-chromatic
    test-chromostereopsis
    test-foveal-scotopic-macula
    test-cvd-colorblindness
    test-mesopic-purkinje-shift
    test-toric-blur-astigmatism
    test-glare-veiling-luminance
    test-oklab-perceptual
    test-helmholtz-kohlrausch
    test-spectral-coherence
    test-lcd-black-bleed
    test-oled-irradiance
    test-spatial-frequency-csf
    test-determinism-1to1
    test-wet-surface-physics
    test-photophobia-glare
    test-pattern-glare-cortical
    test-macular-hazard-blue-light
    test-pupil-spasm-adaptation
    test-astigmatism-meridional-blur
    test-asd-semantic-entropy
    test-photophobia-triplet-contrast
    test-trigeminal-nerve-excitation
    test-scotopic-pupillary-aperture
    test-magnocellular-parvocellular-balance
    test-tonic-accommodation-dark-focus
    test-crowding-effect-foveal
    test-isoluminance-jitter
    test-afterimage-persistence))

(defvar rf-test-themes
  (let ((env (getenv "RF_TEST_THEMES")))
    (if (and env (not (string-empty-p env)))
        (mapcar #'intern (split-string env "[, ]+" t))
      '(rainforest-night rainforest-day)))
  "Themes evaluated by `run-all-rainforest-tests'.
Override with the RF_TEST_THEMES environment variable, e.g.
RF_TEST_THEMES=rainforest-night to gate a single variant.")

(defun run-all-rainforest-tests ()
  "Execute all test suites across `rf-test-themes' and compile executive master diagnostic report."
  (let* ((themes rf-test-themes)
         (total-modules (* (length rf-test-modules) (length themes)))
         (passed-modules 0)
         (failed-modules nil))
    (princ "\n######################################################################\n")
    (princ " RAINFOREST THEMES: AUTOMATED SCIENTIFIC & ERGONOMIC TEST SUITE\n")
    (princ (format " Themes: %s\n" (mapconcat #'symbol-name themes ", ")))
    (princ "######################################################################\n")

    (dolist (theme themes)
      (setq rf-active-theme theme)
      (princ (format "\n======================================================================\n"))
      (princ (format " RUNNING TEST SUITES FOR THEME: %s\n" theme))
      (princ (format "======================================================================\n"))
      (dolist (mod rf-test-modules)
        (require mod)
        (let* ((fn-name (intern (format "%s-run" (symbol-name mod))))
               (res (funcall fn-name)))
          (if res
              (setq passed-modules (1+ passed-modules))
            (push (cons theme mod) failed-modules)))))

    (princ "\n======================================================================\n")
    (princ " EXECUTIVE MASTER TEST SUITE SUMMARY\n")
    (princ "======================================================================\n")
    (princ (format "Total Test Executions:       %d (%d modules x %d themes)\n"
                   total-modules (length rf-test-modules) (length themes)))
    (princ (format "Passed Test Executions:      %d\n" passed-modules))
    (princ (format "Failed Test Executions:      %d\n" (length failed-modules)))
    (if failed-modules
        (progn
          (princ (format "Failing Modules:             %S\n" (nreverse failed-modules)))
          (princ "Status: FAILING GATES DETECTED\n")
          nil)
      (princ (format "Status: ALL %d PHYSICAL, OPTICAL & ERGONOMIC GATES PASSED!\n" total-modules))
      t)))

(when noninteractive
  (unless (run-all-rainforest-tests)
    (kill-emacs 1)))

(provide 'run-all-tests)
;;; run-all-tests.el ends here
