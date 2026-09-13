;;; test-cross-family-distinctiveness.el --- Cross-package theme divergence and anti-cloning gate -*- lexical-binding: t; -*-

;; Author: Szymon Wilczek <swilczek.lx@gmail.com>
;; Keywords: faces, themes, accessibility, autism, neurodivergence

(require 'test-palette-extractor)

(defun au-theme-family (theme)
  "Return the package/family symbol of THEME ('whispergrove or 'aurum)."
  (let ((name (symbol-name theme)))
    (cond
     ((string-match-p "whispergrove" name) 'whispergrove)
     ((string-match-p "aurum" name) 'aurum)
     (t (error "Unknown theme family for: %s" theme)))))

(defun au-theme-counterparts (theme)
  "Return the counterpart themes in other families for THEME."
  (cond
   ((memq theme '(au-whispergrove-day whispergrove-day))
    '(au-aurum-day))
   ((memq theme '(au-whispergrove-morning whispergrove-morning))
    '(au-aurum-day))
   ((memq theme '(au-aurum-day aurum-day))
    '(au-whispergrove-day au-whispergrove-morning))
   ((memq theme '(au-whispergrove-night whispergrove-night))
    '(au-aurum-night))
   ((memq theme '(au-whispergrove-evening whispergrove-evening))
    '(au-aurum-night))
   ((memq theme '(au-aurum-night aurum-night))
    '(au-whispergrove-night au-whispergrove-evening))
   ((memq theme '(au-aurum-twilight aurum-twilight))
    nil)))

(defun test-cross-family-distinctiveness-run ()
  "Evaluate that themes from different families do not duplicate colors or aesthetic identities.
Themes within the same package share a mineral or botanical lineage (e.g. all whispergrove
variants share misty forest tones; all aurum variants share gold and volcanic basalt).
However, themes across different families of the same polarity (e.g. au-aurum-day vs
au-whispergrove-day) must maintain strict categorical, perceptual, and chromatic divergence:
  - Part 1: Zero shared hex codes between cross-family counterpart roles.
  - Part 2: Per-token minimum CIEDE2000 distance dE00 >= 10.0 for key expressive roles.
  - Part 3: Global palette divergence: mean pairwise dE00 >= 18.0 across core syntax.
  - Part 4: Family-specific chromatic identity purity (e.g. aurum must use golden/amber
    region and non-green types, preserving the gold/basalt heritage)."
  (let* ((theme (or rf-active-theme 'au-whispergrove-night))
         (pal (au-extract-active-palette theme))
         (family (au-theme-family theme))
         (polarity (rf-theme-polarity theme))
         (passes 0)
         (fails 0)
         (counterparts (au-theme-counterparts theme)))

    (princ (format "\n======================================================================\n"))
    (princ (format " Cross-Family Distinctiveness & Palette Anti-Cloning Suite\n"))
    (princ (format " Theme: %s (Family: %s, Polarity: %s)\n" theme family polarity))
    (princ (format " Cross-Family Counterparts Evaluated: %S\n" counterparts))
    (princ (format "======================================================================\n"))

    (if (null counterparts)
        (progn
          (princ "   [SKIP] No cross-family counterpart of the same polarity found for comparison.\n")
          (setq passes (1+ passes)))

      (dolist (c-theme counterparts)
        (let* ((c-pal (au-extract-active-palette c-theme))
               (c-family (au-theme-family c-theme)))

          ;; -------------------------------------------------------------------
          ;; Part 1: Strict Hex Uniqueness Across Families
          ;; -------------------------------------------------------------------
          (princ (format "\nPart 1: Cross-Family Hex Collision Check (%s vs %s):\n" theme c-theme))
          (let ((checked-keys '(:keyword :type :builtin :constant :number :fnname
                                :fnname-call :string :property :bg-region :cursor
                                :bg-main :fg-main))
                (collisions nil))
            (dolist (k checked-keys)
              (let ((h1 (plist-get pal k))
                    (h2 (plist-get c-pal k)))
                (when (and h1 h2 (string= (downcase h1) (downcase h2)))
                  (push (list k h1) collisions))))
            (if (null collisions)
                (progn
                  (princ (format "   [PASS] 0 shared hex codes between %s and %s.\n" theme c-theme))
                  (setq passes (1+ passes)))
              (princ (format "   [FAIL] Cross-family color collision detected: %S\n" collisions))
              (setq fails (1+ fails))))

          ;; -------------------------------------------------------------------
          ;; Part 2: Per-Token Minimum Separation Gate (dE00 >= 10.0)
          ;; -------------------------------------------------------------------
          (princ (format "\nPart 2: Expressive Roles Minimum Separation (%s vs %s, min dE00 10.0):\n"
                         theme c-theme))
          (princ (format "%-24s | %-8s | %-8s | %-8s | %-8s\n"
                         "Role" (symbol-name theme) (symbol-name c-theme) "dE00" "Status"))
          (princ (format "-------------------------+----------+----------+----------+----------\n"))
          (let ((key-roles '((:type         "Data Type (type)")
                             (:builtin      "Builtin functions (builtin)")
                             (:fnname       "Function name (fnname)")
                             (:fnname-call  "Function call (fnname-call)")
                             (:bg-region    "Selection region (bg-region)")
                             (:cursor       "Cursor point (cursor)"))))
            (dolist (r key-roles)
              (let* ((k (car r))
                     (label (cadr r))
                     (h1 (plist-get pal k))
                     (h2 (plist-get c-pal k))
                     (dist (rf-delta-e-2000 h1 h2))
                     (ok (>= dist 10.0)))
                (if ok
                    (setq passes (1+ passes))
                  (setq fails (1+ fails)))
                (princ (format "%-24s | %-8s | %-8s | %8.2f | %s\n"
                               label h1 h2 dist (if ok "PASS" "FAIL (< 10.0)"))))))
          (princ (format "-------------------------+----------+----------+----------+----------\n"))

          ;; -------------------------------------------------------------------
          ;; Part 3: Global Palette Profile Divergence (Mean dE00 >= 18.0)
          ;; -------------------------------------------------------------------
          (princ (format "\nPart 3: Global Palette Profile Divergence (%s vs %s):\n" theme c-theme))
          (let* ((syntax-keys '(:keyword :type :builtin :constant :number :fnname
                                :fnname-call :string :property :bg-region))
                 (distances (mapcar (lambda (k)
                                      (rf-delta-e-2000 (plist-get pal k) (plist-get c-pal k)))
                                    syntax-keys))
                 (mean-dist (/ (apply #'+ distances) (float (length distances))))
                 (mean-ok (>= mean-dist 18.0)))
            (if mean-ok
                (progn
                  (princ (format "   [PASS] Mean cross-family syntax separation = %.2f >= 18.0\n" mean-dist))
                  (princ "          Clean global stylistic independence across theme packages.\n")
                  (setq passes (1+ passes)))
              (princ (format "   [FAIL] Palette clone alert: Mean separation = %.2f < 18.0\n" mean-dist))
              (setq fails (1+ fails)))))

          ;; -------------------------------------------------------------------
          ;; Part 4: Family-Specific Chromatic Identity Purity Gate
          ;; -------------------------------------------------------------------
          (princ (format "\nPart 4: Chromatic Identity Purity Gate (%s family signature):\n" family))
          (cond
           ((eq family 'aurum)
            ;; Aurum requirements:
            ;; 1. Selection region MUST be warm gold / amber / quartz sand (h in [40°..110°])
            ;;    and NEVER cool forest green / moss (h in [115°..175°]).
            (let* ((reg-hex (plist-get pal :bg-region))
                   (reg-okl (rf-hex-to-oklch reg-hex))
                   (reg-h   (nth 2 reg-okl))
                   (reg-ok  (and (>= reg-h 40.0) (<= reg-h 110.0))))
              (if reg-ok
                  (progn
                    (princ (format "   [PASS] Aurum Selection Region (%s, hue %.1f°): Genuine warm golden amber / quartz sand.\n"
                                   reg-hex reg-h))
                    (setq passes (1+ passes)))
                (princ (format "   [FAIL] Aurum Selection Region (%s, hue %.1f°): Inauthentic chromatic identity (expected [40°..110°], got forest/cool hue).\n"
                               reg-hex reg-h))
                (setq fails (1+ fails))))

            ;; 2. For aurum-day, Data Type must NOT be cool green (h not in [120°..175°])
            ;;    Aurum uses warm bronze, terracotta, amber, or peach sandstone for types.
            (when (eq polarity 'light)
              (let* ((type-hex (plist-get pal :type))
                     (type-okl (rf-hex-to-oklch type-hex))
                     (type-h   (nth 2 type-okl))
                     (type-not-green (not (and (>= type-h 120.0) (<= type-h 175.0)))))
                (if type-not-green
                    (progn
                      (princ (format "   [PASS] Aurum Daylight Data Type (%s, hue %.1f°): Warm bronze / sandstone / amber (non-green).\n"
                                     type-hex type-h))
                      (setq passes (1+ passes)))
                  (princ (format "   [FAIL] Aurum Daylight Data Type (%s, hue %.1f°): Green hue stolen from forest palette.\n"
                                 type-hex type-h))
                  (setq fails (1+ fails))))))

           ((eq family 'whispergrove)
            ;; Whispergrove requirements:
            ;; Selection region MUST be temperate forest moss/conifer (h in [115°..175°])
            (let* ((reg-hex (plist-get pal :bg-region))
                   (reg-okl (rf-hex-to-oklch reg-hex))
                   (reg-h   (nth 2 reg-okl))
                   (reg-ok  (and (>= reg-h 115.0) (<= reg-h 175.0))))
              (if reg-ok
                  (progn
                    (princ (format "   [PASS] Whispergrove Selection Region (%s, hue %.1f°): Temperate forest moss.\n"
                                   reg-hex reg-h))
                    (setq passes (1+ passes)))
                (princ (format "   [FAIL] Whispergrove Selection Region (%s, hue %.1f°): Not in forest moss envelope [115°..175°].\n"
                               reg-hex reg-h))
                (setq fails (1+ fails))))))))

    (princ (format "\n----------------------------------------------------------------------\n"))
    (princ (format "Cross-Family Distinctiveness Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-cross-family-distinctiveness-run)
    (kill-emacs 1)))

(provide 'test-cross-family-distinctiveness)
;;; test-cross-family-distinctiveness.el ends here
