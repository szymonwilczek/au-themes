;;; test-palette-extractor.el --- Automated theme palette extraction and biophysical math -*- lexical-binding: t; -*-

(require 'color)
(require 'subr-x)

;; Ensure paths to dependencies
(let ((dotfiles-dir "/home/wolfie/Dokumenty/GitHub/dotfiles/emacs/.config/emacs/elpa"))
  (dolist (pkg '("modus-themes-20260730.719" "ef-themes-2.2.0"))
    (let ((p (expand-file-name pkg dotfiles-dir)))
      (when (file-directory-p p)
        (add-to-list 'load-path p)))))

(add-to-list 'load-path default-directory)
(add-to-list 'custom-theme-load-path default-directory)

(require 'rainforest-night-theme)

(defun rainforest-extract-fg-from-spec (spec)
  "Recursively search SPEC for :foreground value."
  (cond
   ((null spec) nil)
   ((and (consp spec) (eq (car spec) :foreground))
    (cadr spec))
   ((consp spec)
    (or (rainforest-extract-fg-from-spec (car spec))
        (rainforest-extract-fg-from-spec (cdr spec))))
   (t nil)))

(defun rainforest-get-theme-face-fg (theme face)
  "Extract foreground hex string for FACE from THEME's settings."
  (let ((settings (get theme 'theme-settings))
        result)
    (dolist (s settings result)
      (when (and (eq (car s) 'theme-face)
                 (eq (cadr s) face)
                 (null result))
        (let ((fg (rainforest-extract-fg-from-spec (nth 3 s))))
          (when (and fg (stringp fg) (string-prefix-p "#" fg))
            (setq result fg)))))))

(defun rainforest-extract-active-palette (&optional theme-name)
  "Extract complete semantic color dictionary directly from THEME-NAME (default 'rainforest-night)."
  (let* ((theme (or theme-name 'rainforest-night))
         (partial (cond
                   ((eq theme 'rainforest-night) rainforest-night-palette-partial)
                   ((boundp 'rainforest-day-palette-partial) (symbol-value 'rainforest-day-palette-partial))
                   (t nil)))
         (bg (or (cadr (assq 'bg-main partial)) "#080b09"))
         (fg (or (cadr (assq 'fg-main partial)) "#90a297"))
         (dim (or (cadr (assq 'fg-dim partial)) "#48574c"))
         (cur (or (cadr (assq 'cursor partial)) "#4d93b3"))
         (hl (or (cadr (assq 'bg-hl-line partial)) "#101612")))
    (list
     :theme theme
     :bg-main bg
     :bg-hl-line hl
     :fg-main fg
     :fg-dim dim
     :cursor cur
     :preprocessor (or (rainforest-get-theme-face-fg theme 'font-lock-preprocessor-face)
                       (cadr (assq 'cyan-warmer partial)) "#4aa47c")
     :keyword (or (rainforest-get-theme-face-fg theme 'font-lock-keyword-face)
                  (cadr (assq 'cyan partial)) "#206c3a")
     :type (or (rainforest-get-theme-face-fg theme 'font-lock-type-face)
               (cadr (assq 'green partial)) "#5c9648")
     :constant (or (rainforest-get-theme-face-fg theme 'font-lock-constant-face)
                   (cadr (assq 'magenta partial)) "#7e528a")
     :number (or (rainforest-get-theme-face-fg theme 'font-lock-number-face)
                 (cadr (assq 'yellow-warmer partial)) "#ba8432")
     :builtin (or (rainforest-get-theme-face-fg theme 'font-lock-builtin-face)
                  (cadr (assq 'magenta-cooler partial)) "#8e5e48")
     :fnname (or (rainforest-get-theme-face-fg theme 'font-lock-function-name-face)
                 (cadr (assq 'blue partial)) "#30607e")
     :fnname-call (or (rainforest-get-theme-face-fg theme 'font-lock-function-call-face)
                      (cadr (assq 'blue-warmer partial)) "#5088ae")
     :string (or (rainforest-get-theme-face-fg theme 'font-lock-string-face)
                 (cadr (assq 'yellow partial)) "#a46e38")
     :property (or (rainforest-get-theme-face-fg theme 'font-lock-property-name-face)
                   (cadr (assq 'fg-alt partial)) "#5c8882")
     :operator (or (rainforest-get-theme-face-fg theme 'font-lock-operator-face)
                   (cadr (assq 'blue-cooler partial)) "#586c60")
     :bracket (or (rainforest-get-theme-face-fg theme 'font-lock-bracket-face)
                  (cadr (assq 'red-faint partial)) "#4c5c50")
     :delimiter (or (rainforest-get-theme-face-fg theme 'font-lock-delimiter-face)
                    (cadr (assq 'cyan-faint partial)) "#4c5a50")
     :err (or (rainforest-get-theme-face-fg theme 'font-lock-warning-face)
              (cadr (assq 'red partial)) "#9e3834"))))

;; =============================================================================
;; Color Conversion & Photometric Mathematics
;; =============================================================================

(defun rf-clean-hex (hex)
  (let ((s (format "%s" hex)))
    (if (string-match "#\\([0-9a-fA-F]\\{6\\}\\)" s)
        (concat "#" (downcase (match-string 1 s)))
      "#000000")))

(defun rf-hex-to-rgb (hex)
  (let ((c (rf-clean-hex hex)))
    (list (/ (string-to-number (substring c 1 3) 16) 255.0)
          (/ (string-to-number (substring c 3 5) 16) 255.0)
          (/ (string-to-number (substring c 5 7) 16) 255.0))))

(defun rf-hex-to-rgb16 (hex)
  (let ((c (rf-clean-hex hex)))
    (list (* (string-to-number (substring c 1 3) 16) 257)
          (* (string-to-number (substring c 3 5) 16) 257)
          (* (string-to-number (substring c 5 7) 16) 257))))

(defun rf-srgb-to-linear (c)
  (if (<= c 0.04045)
      (/ c 12.92)
    (expt (/ (+ c 0.055) 1.055) 2.4)))

(defun rf-linear-to-srgb (c)
  (if (<= c 0.0031308)
      (* c 12.92)
    (- (* 1.055 (expt c (/ 1.0 2.4))) 0.055)))

(defun rf-luminance-y (hex)
  "Calculate physical CIE Y luminance under sRGB D65."
  (let* ((rgb (rf-hex-to-rgb hex))
         (r (rf-srgb-to-linear (nth 0 rgb)))
         (g (rf-srgb-to-linear (nth 1 rgb)))
         (b (rf-srgb-to-linear (nth 2 rgb))))
    (+ (* r 0.2126729) (* g 0.7151522) (* b 0.0721750))))

(defun rf-apca-from-luminance (txt-y bg-y)
  "Calculate APCA Lc lightness contrast from raw luminances TXT-Y and BG-Y."
  (let* ((txt-c (if (> txt-y 0.022) txt-y (+ txt-y (expt (- 0.022 txt-y) 1.414))))
         (bg-c  (if (> bg-y 0.022)  bg-y  (+ bg-y  (expt (- 0.022 bg-y)  1.414)))))
    (if (< (abs (- bg-c txt-c)) 0.0005)
        0.0
      (if (> bg-c txt-c)
          (let* ((sapc (* (- (expt bg-c 0.56) (expt txt-c 0.57)) 1.14))
                 (out  (if (< sapc 0.1) 0.0 (* (- sapc 0.027) 100.0))))
            (- out))
        (let* ((sapc (* (- (expt txt-c 0.62) (expt bg-c 0.65)) 1.14))
               (mag  (if (< sapc 0.1) 0.0 (* (- sapc 0.027) 100.0))))
          mag)))))

;; APCA 0.98G-4g
(defun rf-apca-contrast (txt-hex bg-hex)
  "Calculate APCA Lc lightness contrast from TXT-HEX against BG-HEX."
  (rf-apca-from-luminance (rf-luminance-y txt-hex) (rf-luminance-y bg-hex)))

(defun rf-lcd-contrast (txt-hex bg-hex)
  "Calculate APCA Lc with LCD black bleed (0.008)."
  (rf-apca-from-luminance (+ (rf-luminance-y txt-hex) 0.008)
                          (+ (rf-luminance-y bg-hex) 0.008)))

(defun rf-oled-contrast (txt-hex bg-hex)
  "Calculate APCA Lc with OLED optical point irradiation (0.94)."
  (rf-apca-from-luminance (* (rf-luminance-y txt-hex) 0.94)
                          (rf-luminance-y bg-hex)))

;; WCAG 2.1 Relative Luminance Ratio
(defun rf-wcag-contrast-ratio (hex1 hex2)
  "Calculate standard WCAG 2.1 (L1 + 0.05)/(L2 + 0.05) contrast ratio."
  (let* ((y1 (rf-luminance-y hex1))
         (y2 (rf-luminance-y hex2))
         (lighter (max y1 y2))
         (darker  (min y1 y2)))
    (/ (+ lighter 0.05) (+ darker 0.05))))

;; Oklab and Oklch (Björn Ottosson, 2020)
(defun rf-hex-to-oklab (hex)
  "Convert HEX to Oklab coordinates [L a b]."
  (let* ((rgb (rf-hex-to-rgb hex))
         (r (rf-srgb-to-linear (nth 0 rgb)))
         (g (rf-srgb-to-linear (nth 1 rgb)))
         (b (rf-srgb-to-linear (nth 2 rgb)))
         (l (+ (* 0.4122214708 r) (* 0.5363325363 g) (* 0.0514459929 b)))
         (m (+ (* 0.2119034982 r) (* 0.6806995451 g) (* 0.1073969566 b)))
         (s (+ (* 0.0883024619 r) (* 0.2817188376 g) (* 0.6299787005 b)))
         (l_ (expt (max 0.0 l) (/ 1.0 3.0)))
         (m_ (expt (max 0.0 m) (/ 1.0 3.0)))
         (s_ (expt (max 0.0 s) (/ 1.0 3.0)))
         (L (+ (* 0.2104542553 l_) (* 0.7936177850 m_) (* -0.0040720468 s_)))
         (a (+ (* 1.9779984951 l_) (* -2.4285922050 m_) (* 0.4505937099 s_)))
         (b-val (+ (* 0.0259040371 l_) (* 0.7827717662 m_) (* -0.8086757660 s_))))
    (list L a b-val)))

(defun rf-hex-to-oklch (hex)
  "Convert HEX to Oklch coordinates [L C h] where h is in degrees [0..360)."
  (let* ((lab (rf-hex-to-oklab hex))
         (L (nth 0 lab))
         (a (nth 1 lab))
         (b (nth 2 lab))
         (C (sqrt (+ (* a a) (* b b))))
         (h-rad (atan b a))
         (h-deg (* (/ h-rad float-pi) 180.0))
         (h (if (< h-deg 0.0) (+ h-deg 360.0) h-deg)))
    (list L C h)))

;; CIELAB Chroma C*
(defun rf-cielab-chroma (hex)
  "Calculate CIELAB chroma C*."
  (let* ((rgb (rf-hex-to-rgb hex))
         (lab (apply #'color-srgb-to-lab rgb))
         (a (nth 1 lab))
         (b (nth 2 lab)))
    (sqrt (+ (* a a) (* b b)))))

;; Thibos (1992) Effective Wavelength and Diopters
(defun rf-effective-wavelength (hex)
  (let* ((rgb (rf-hex-to-rgb hex))
         (r (rf-srgb-to-linear (nth 0 rgb)))
         (g (rf-srgb-to-linear (nth 1 rgb)))
         (b (rf-srgb-to-linear (nth 2 rgb)))
         (y (+ (* r 0.2126729) (* g 0.7151522) (* b 0.0721750))))
    (if (< y 1e-6)
        555.0
      (* 1000.0 (/ (+ (* r 0.2126729 0.612)
                      (* g 0.7151522 0.535)
                      (* b 0.0721750 0.465))
                   y)))))

(defun rf-thibos-diopters (hex)
  (let ((lambda-um (/ (rf-effective-wavelength hex) 1000.0)))
    (- 1.6852 (/ 0.63346 (- lambda-um 0.21410)))))

(defun rf-lca-disparity (hex1 hex2)
  (abs (- (rf-thibos-diopters hex1) (rf-thibos-diopters hex2))))

;; Emacs 16-bit Riemersma color distance
(defun rf-color-distance (hex1 hex2)
  (color-distance (rf-hex-to-rgb16 hex1) (rf-hex-to-rgb16 hex2)))

;; Pupil diameter model (de Groot & Gebhard 1952)
(defun rf-pupil-diameter (bg-luminance-cd-m2)
  "Estimate pupil diameter in mm as a function of field luminance (cd/m2)."
  (let ((l (max 0.001 bg-luminance-cd-m2)))
    ;; d = 4.9 - 3 * tanh(0.4 * (log10(l) + 1.0))
    (- 4.9 (* 3.0 (/ (- (exp (* 0.4 (+ (log l 10) 1.0)))
                        (exp (- (* 0.4 (+ (log l 10) 1.0)))))
                     (+ (exp (* 0.4 (+ (log l 10) 1.0)))
                        (exp (- (* 0.4 (+ (log l 10) 1.0))))))))))

;; Wavefront aberration ratio scaling W proportional to r^4
(defun rf-wavefront-aberration-factor (pupil-diam-mm)
  "Wavefront aberration scales with 4th power of pupil radius (Liang & Williams 1997)."
  (let ((r (/ pupil-diam-mm 2.0)))
    (expt (/ r 2.0) 4.0))) ; Normalized to standard 4mm pupil (r=2mm)

;; Helmholtz-Kohlrausch brightness factor (Fairchild & Pirrotta 1991)
(defun rf-helmholtz-kohlrausch-factor (hex)
  "Compute perceived brightness multiplier B/Y due to chromatic saturation."
  (let* ((c (rf-cielab-chroma hex))
         ;; Empirical H-K multiplier: saturated colors stimulate human brightness channel
         (hk (+ 1.0 (* 0.012 c))))
    hk))

;; =============================================================================
;; Advanced Biophysical & Physiological Models
;; =============================================================================

;; Foveal Macular Tritanopia / L+M Cone Fraction
(defun rf-foveal-lm-fraction (hex)
  "Calculate the fraction of photopic luminance derived from L- and M-cones.
Central foveola (0.35 mm macular zone) lacks S-cones and contains macular pigment
absorbing short wavelengths. Fine strokes rely on L+M cone stimulation."
  (let* ((rgb (rf-hex-to-rgb hex))
         (rl (rf-srgb-to-linear (nth 0 rgb)))
         (gl (rf-srgb-to-linear (nth 1 rgb)))
         (bl (rf-srgb-to-linear (nth 2 rgb)))
         (y-total (+ (* rl 0.2126729) (* gl 0.7151522) (* bl 0.0721750))))
    (if (< y-total 1e-6)
        1.0
      (/ (+ (* rl 0.2126729) (* gl 0.7151522)) y-total))))

;; CVD (Color Vision Deficiency) Simulation Matrices (Machado et al. 2009 / Brettel 1997)
(defconst rf-cvd-matrix-protan
  '((0.56667 0.43333 0.00000)
    (0.55833 0.44167 0.00000)
    (0.00000 0.24167 0.75833))
  "Machado (2009) / Brettel linear sRGB projection matrix for Protanopia.")

(defconst rf-cvd-matrix-deutan
  '((0.62500 0.37500 0.00000)
    (0.70000 0.30000 0.00000)
    (0.00000 0.30000 0.70000))
  "Machado (2009) / Brettel linear sRGB projection matrix for Deuteranopia.")

(defconst rf-cvd-matrix-tritan
  '((0.95000 0.05000 0.00000)
    (0.00000 0.43333 0.56667)
    (0.00000 0.47500 0.52500))
  "Machado (2009) / Brettel linear sRGB projection matrix for Tritanopia.")

(defun rf-cvd-simulate (hex cvd-type)
  "Simulate CVD-transformed hex color under CVD-TYPE ('protan, 'deutan, or 'tritan)."
  (let* ((rgb (rf-hex-to-rgb hex))
         (rl (rf-srgb-to-linear (nth 0 rgb)))
         (gl (rf-srgb-to-linear (nth 1 rgb)))
         (bl (rf-srgb-to-linear (nth 2 rgb)))
         (m (cond
             ((eq cvd-type 'protan) rf-cvd-matrix-protan)
             ((eq cvd-type 'deutan) rf-cvd-matrix-deutan)
             ((eq cvd-type 'tritan) rf-cvd-matrix-tritan)
             (t (error "Unknown CVD type: %s" cvd-type))))
         (r-sim (max 0.0 (+ (* (nth 0 (nth 0 m)) rl) (* (nth 1 (nth 0 m)) gl) (* (nth 2 (nth 0 m)) bl))))
         (g-sim (max 0.0 (+ (* (nth 0 (nth 1 m)) rl) (* (nth 1 (nth 1 m)) gl) (* (nth 2 (nth 1 m)) bl))))
         (b-sim (max 0.0 (+ (* (nth 0 (nth 2 m)) rl) (* (nth 1 (nth 2 m)) gl) (* (nth 2 (nth 2 m)) bl))))
         (r-srgb (min 1.0 (max 0.0 (rf-linear-to-srgb r-sim))))
         (g-srgb (min 1.0 (max 0.0 (rf-linear-to-srgb g-sim))))
         (b-srgb (min 1.0 (max 0.0 (rf-linear-to-srgb b-sim)))))
    (format "#%02x%02x%02x"
            (round (* r-srgb 255.0))
            (round (* g-srgb 255.0))
            (round (* b-srgb 255.0)))))

;; Scotopic & Mesopic Vision (CIE 191:2010 Purkinje Shift)
(defun rf-scotopic-luminance (hex)
  "Calculate approximate CIE scotopic V'(lambda) luminance from HEX."
  (let* ((rgb (rf-hex-to-rgb hex))
         (rl (rf-srgb-to-linear (nth 0 rgb)))
         (gl (rf-srgb-to-linear (nth 1 rgb)))
         (bl (rf-srgb-to-linear (nth 2 rgb))))
    (+ (* rl 0.062) (* gl 0.608) (* bl 0.330))))

(defun rf-mesopic-luminance (hex &optional m-coef)
  "Calculate CIE 191:2010 mesopic luminance for HEX under mesopic coefficient M-COEF (default 0.45)."
  (let* ((m (or m-coef 0.45))
         (y-p (rf-luminance-y hex))
         (y-s (rf-scotopic-luminance hex))
         (ratio (/ 683.0 1700.0)))
    (/ (+ (* m y-p) (* (- 1.0 m) y-s ratio))
       (+ m (* (- 1.0 m) ratio)))))

;; Toric Blur Astigmatism PSF
(defun rf-toric-blur-michelson (hex bg-hex &optional blur-attenuation)
  "Calculate post-blur Michelson contrast for thin stroke under astigmatic blur.
BLUR-ATTENUATION defaults to 0.60 representing a 1.25D cylinder defocus on a 1.2px stroke."
  (let* ((eta (or blur-attenuation 0.60))
         (y-bg (rf-luminance-y bg-hex))
         (y-tok (rf-luminance-y hex))
         (y-peak-blur (+ y-bg (* (- y-tok y-bg) eta))))
    (if (< (+ y-peak-blur y-bg) 1e-6)
        0.0
      (/ (- y-peak-blur y-bg) (+ y-peak-blur y-bg)))))

;; Intraocular Veiling Glare (CIE 112 / Vos-van den Berg Straylight Spatial Integral)
(defun rf-veiling-glare-luminance (pal)
  "Estimate intraocular veiling luminance Lv from typical Emacs buffer geometry per Vos (1999)."
  (let* ((weights `((:bg-main . 0.850)
                    (:fg-main . 0.070)
                    (:type . 0.030)
                    (:keyword . 0.020)
                    (:bg-hl-line . 0.025)
                    (:cursor . 0.005)))
         (total-illum 0.0)
         (theta 8.0)
         (straylight-factor (/ 10.0 (* theta theta))))
    (dolist (w weights)
      (let* ((key (car w))
             (weight (cdr w))
             (hex (or (plist-get pal key) "#080b09"))
             (lum (rf-luminance-y hex)))
        (setq total-illum (+ total-illum (* lum weight)))))
    (* total-illum straylight-factor 0.01)))

(provide 'test-palette-extractor)
;;; test-palette-extractor.el ends here
