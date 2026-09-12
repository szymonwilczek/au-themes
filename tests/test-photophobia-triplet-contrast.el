;;; test-photophobia-triplet-contrast.el --- Triplet Contrast Shock & Micro-Saccadic Flicker -*- lexical-binding: t; -*-

(require 'test-palette-extractor)

(defun test-photophobia-triplet-contrast-run ()
  "Evaluate local luminance shock and micro-saccadic flicker in triplet syntax sequences.
In photophobia, high contrast jumps between adjacent syntax tokens (e.g. keyword -> bracket -> literal)
cause retinal micro-flicker during fixational eye movements and micro-saccades.
Ref: Martinez-Conde et al. (2004) Nature Rev. Neurosci.; APCA Guidelines (Somers 2022)."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (polarity (rf-theme-polarity theme))
         (bg (plist-get pal :bg-main))
         (bg-y (rf-luminance-y bg))
         (passes 0)
         (fails 0)
         (triplet-pairs
          '(("keyword (struct) vs type (int)"           :keyword     :type)
            ("keyword (static) vs builtin (__always)"   :keyword     :builtin)
            ("builtin vs fnname (def)"                  :builtin     :fnname)
            ("fnname (def) vs fnname-call (call)"       :fnname      :fnname-call)
            ("fnname vs type"                           :fnname      :type)
            ("fnname-call vs type"                      :fnname-call :type)
            ("type vs property (*state)"                :type        :property)
            ("property vs operator (->, =)"             :property    :operator)
            ("operator vs number (0, 24)"               :operator    :number)
            ("operator vs string (\"literal\")"         :operator    :string)
            ("operator vs bracket ([ ])"                :operator    :bracket)
            ("bracket vs delimiter (, ;)"               :bracket     :delimiter)
            ("keyword vs bracket"                       :keyword     :bracket)
            ("type vs bracket"                          :type        :bracket)
            ("base text vs operator"                    :fg-main     :operator)
            ("base text vs bracket"                     :fg-main     :bracket)
            ("base text vs property"                    :fg-main     :property)
            ("base text vs keyword"                     :fg-main     :keyword)
            ("base text vs type"                        :fg-main     :type)
            ("base text vs builtin"                     :fg-main     :builtin))))

    (princ (format "\n======================================================================\n"))
    (princ (format " Photophobia Triplet Contrast & Micro-Saccadic Flicker Suite\n"))
    (princ (format " Ref: Martinez-Conde et al. (2004); APCA 0.98G Delta-Lc Boundary\n"))
    (princ (format " Theme: %s (%s) | Background: %s (Y_bg: %.6f)\n" theme polarity bg bg-y))
    (princ (format " Requirement: Adjacent token contrast delta Delta-Lc <= 22.5\n"))
    (princ (format "======================================================================\n"))

    (princ (format "%-42s | %-8s | %-8s | %-7s | %-7s | %-8s | %-8s\n"
                   "Adjacent Syntax Pair" "Color 1" "Color 2" "|Lc 1|" "|Lc 2|" "Delta-Lc" "Status"))
    (princ (format "-------------------------------------------+----------+----------+---------+---------+----------+----------\n"))
    (dolist (p triplet-pairs)
      (let* ((label (nth 0 p))
             (k1    (nth 1 p))
             (k2    (nth 2 p))
             (h1    (plist-get pal k1))
             (h2    (plist-get pal k2))
             (lc1   (abs (rf-apca-contrast h1 bg)))
             (lc2   (abs (rf-apca-contrast h2 bg)))
             (dlc   (abs (- lc1 lc2)))
             (ok    (<= dlc 22.5)))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "%-42s | %-8s | %-8s | %7.1f | %7.1f | %8.2f | %s\n"
                       label h1 h2 lc1 lc2 dlc (if ok "PASS" "FAIL")))))
    (princ (format "-------------------------------------------+----------+----------+---------+---------+----------+----------\n"))

    (princ (format "Triplet Contrast Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-photophobia-triplet-contrast-run)
    (kill-emacs 1)))

(provide 'test-photophobia-triplet-contrast)
;;; test-photophobia-triplet-contrast.el ends here
