;;; test-oled-irradiance.el --- OLED true black & optical point irradiation simulation -*- lexical-binding: t; -*-

(require 'test-palette-extractor)

(defun test-oled-irradiance-run ()
  "Evaluate OLED contrast and point irradiation factor (0.94) on emissive panels."
  (let* ((pal (rainforest-extract-active-palette))
         (bg (plist-get pal :bg-main))
         (theme (plist-get pal :theme))
         (passes 0)
         (fails 0)
         (tokens '(("Base text (Mineral quartz)"       :fg-main      46.0)
                   ("Comments (Damp needles)"          :fg-dim       10.0)
                   ("Cursor (Raindrop glint)"          :cursor       28.0)
                   ("Preprocessor (#define)"           :preprocessor 15.0)
                   ("Keywords (struct, while)"         :keyword      15.0)
                   ("Data types (int, size_t)"         :type         15.0)
                   ("Constants (LOTA_PCR_COUNT)"       :constant     15.0)
                   ("Numbers (0, 24, 32)"              :number       15.0)
                   ("Builtins (__always_inline)"       :builtin      15.0)
                   ("Function definitions"             :fnname       15.0)
                   ("Function calls (bpf_...)"         :fnname-call  15.0)
                   ("Strings (\"string literals\")"    :string       15.0)
                   ("Struct fields (->tgid)"           :property     15.0)
                   ("Operators (+, -, *, >>)"          :operator     14.0)
                   ("Brackets (( ) [ ] { })"           :bracket      13.0)
                   ("Alerts / Errors (!)"              :err          15.0))))
    (princ (format "\n======================================================================\n"))
    (princ (format " OLED Optical Irradiation (Factor = 0.94) Simulation Suite\n"))
    (princ (format " Theme: %s | Background: %s\n" theme bg))
    (princ (format "======================================================================\n"))
    (princ (format "%-32s | %-8s | %-8s | %-8s | %-8s | %-8s\n"
                   "Token Role" "Hex" "Pure Lc" "OLED Lc" "Min Lc" "Status"))
    (princ (format "---------------------------------+----------+----------+----------+----------+----------\n"))
    (dolist (tok tokens)
      (let* ((name (nth 0 tok))
             (key  (nth 1 tok))
             (min-lc (nth 2 tok))
             (hex (plist-get pal key))
             (pure-lc (rf-apca-contrast hex bg))
             (oled-lc (rf-oled-contrast hex bg))
             (ok (>= oled-lc min-lc)))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "%-32s | %-8s | %8.2f | %8.2f | >= %4.1f  | %s\n"
                       name hex pure-lc oled-lc min-lc
                       (if ok "PASS" "FAIL")))))
    (princ (format "---------------------------------+----------+----------+----------+----------+----------\n"))
    (princ (format "OLED Irradiance Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-oled-irradiance-run)
    (kill-emacs 1)))

(provide 'test-oled-irradiance)
;;; test-oled-irradiance.el ends here
