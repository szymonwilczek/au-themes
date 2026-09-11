;;; run-all-tests.el --- Master test suite runner -*- lexical-binding: t; -*-

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
    test-wet-surface-physics))

(defun run-all-rainforest-tests ()
  "Execute all test suites and compile executive master diagnostic report."
  (let ((total-modules (length rf-test-modules))
        (passed-modules 0)
        (failed-modules nil))
    (princ "\n######################################################################\n")
    (princ " RAINFOREST THEMES: AUTOMATED SCIENTIFIC & ERGONOMIC TEST SUITE\n")
    (princ "######################################################################\n")

    (dolist (mod rf-test-modules)
      (require mod)
      (let* ((fn-name (intern (format "%s-run" (symbol-name mod))))
             (res (funcall fn-name)))
        (if res
            (setq passed-modules (1+ passed-modules))
          (push mod failed-modules))))

    (princ "\n======================================================================\n")
    (princ " EXECUTIVE TEST SUITE SUMMARY\n")
    (princ "======================================================================\n")
    (princ (format "Total Test Modules Executed: %d\n" total-modules))
    (princ (format "Passed Modules:              %d\n" passed-modules))
    (princ (format "Failed Modules:              %d\n" (length failed-modules)))
    (if failed-modules
        (progn
          (princ (format "Failing Modules:             %S\n" (nreverse failed-modules)))
          (princ "Status: FAILING GATES DETECTED\n")
          nil)
      (princ "Status: ALL PHYSICAL, OPTICAL & ERGONOMIC GATES PASSED!\n")
      t)))

(when noninteractive
  (unless (run-all-rainforest-tests)
    (kill-emacs 1)))

(provide 'run-all-tests)
;;; run-all-tests.el ends here
