;;; test-oled-irradiance.el --- OLED true black & optical point irradiation simulation -*- lexical-binding: t; -*-

(require 'test-palette-extractor)

(defun test-oled-irradiance-run ()
  "Evaluate legibility on an emissive OLED panel.
OLED black is emissive-off, so the only floor is the ambient light reflected
by the front surface, L_reflected = R_d E/pi = 0.102 cd/m^2 (R_d = 0.5 %,
IEC 61966-2-1 reference ambient 64 lx).  The previous model multiplied text
luminance by 0.94 as \"optical point irradiation\"; no such attenuation exists -
irradiation is an apparent-size illusion, not a loss of emitted luminance -
and it depressed every OLED contrast figure by about 2 Lc."
  (let* ((pal (au-extract-active-palette))
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
    (princ (format " Emissive OLED (True Black + Ambient Reflection) Legibility Suite\n"))
    (princ (format " Theme: %s (%s) | Background: %s\n" theme (rf-theme-polarity theme) bg))
    (princ (format " Emissive black, reflected ambient %.5f of white (64 lx, R_d %.1f%%)\n"
                   (rf-reflected-luminance-y) (* 100.0 rf-panel-diffuse-reflectance)))
    (princ (format "======================================================================\n"))
    (princ (format "%-32s | %-8s | %-8s | %-8s | %-8s | %-8s\n"
                   "Token Role" "Hex" "Pure |Lc|" "OLED |Lc|" "Min |Lc|" "Status"))
    (princ (format "---------------------------------+----------+----------+----------+----------+----------\n"))
    (dolist (tok tokens)
      (let* ((name (nth 0 tok))
             (key  (nth 1 tok))
             (polarity (rf-theme-polarity theme))
             (min-lc (if (eq polarity 'light)
                         (cond ((eq key :fg-main) 60.0)
                               ((eq key :fg-dim) 30.0)
                               ((eq key :cursor) 35.0)
                               (t 45.0))
                       (nth 2 tok)))
             (hex (plist-get pal key))
             (pure-lc (abs (rf-apca-contrast hex bg)))
             (oled-lc (abs (rf-oled-contrast hex bg)))
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
