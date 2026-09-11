;;; test-palette-extractor.el --- Automated theme palette extraction and biophysical math -*- lexical-binding: t; -*-

(require 'cl-lib)
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
(require 'rainforest-day-theme)

(defvar rf-active-theme 'rainforest-night
  "Theme currently being evaluated by tests ('rainforest-night or 'rainforest-day).")

(defun rf-theme-polarity (&optional theme-name)
  "Return 'light or 'dark based on background luminance for THEME-NAME."
  (let* ((theme (or theme-name rf-active-theme 'rainforest-night))
         (pal (rainforest-extract-active-palette theme))
         (bg (plist-get pal :bg-main))
         (y (rf-luminance-y bg)))
    (if (> y 0.20) 'light 'dark)))

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

(defun rainforest-extract-bg-from-spec (spec)
  "Recursively search SPEC for :background value."
  (cond
   ((null spec) nil)
   ((and (consp spec) (eq (car spec) :background))
    (cadr spec))
   ((consp spec)
    (or (rainforest-extract-bg-from-spec (car spec))
        (rainforest-extract-bg-from-spec (cdr spec))))
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

(defun rainforest-get-theme-face-bg (theme face)
  "Extract background hex string for FACE from THEME's settings."
  (let ((settings (get theme 'theme-settings))
        result)
    (dolist (s settings result)
      (when (and (eq (car s) 'theme-face)
                 (eq (cadr s) face)
                 (null result))
        (let ((bg (rainforest-extract-bg-from-spec (nth 3 s))))
          (when (and bg (stringp bg) (string-prefix-p "#" bg))
            (setq result bg)))))))

(defun rainforest-extract-active-palette (&optional theme-name)
  "Extract complete semantic color dictionary directly from THEME-NAME (default `rf-active-theme')."
  (let* ((theme (or theme-name rf-active-theme 'rainforest-night)))
    (if (string-prefix-p "ef-" (symbol-name theme))
        (progn
          (require 'ef-themes nil t)
          (require (intern (format "%s-theme" theme)) nil t)
          (load-theme theme t)
          (let ((get-c (lambda (sym) (ignore-errors (ef-themes-get-color-value sym nil theme)))))
            (list
             :theme theme
             :bg-main (or (rainforest-get-theme-face-bg theme 'default) (funcall get-c 'bg-main) "#0f0e06")
             :bg-hl-line (or (rainforest-get-theme-face-bg theme 'hl-line) (funcall get-c 'bg-hl-line) "#302a3a")
             :fg-main (or (rainforest-get-theme-face-fg theme 'default) (funcall get-c 'fg-main) "#cfbcba")
             :fg-dim (or (rainforest-get-theme-face-fg theme 'line-number) (funcall get-c 'fg-dim) "#887c8a")
             :cursor (or (rainforest-get-theme-face-bg theme 'cursor) (funcall get-c 'cursor) "#ffaa33")
             :preprocessor (or (rainforest-get-theme-face-fg theme 'font-lock-preprocessor-face) (funcall get-c 'preprocessor) "#d570af")
             :keyword (or (rainforest-get-theme-face-fg theme 'font-lock-keyword-face) (funcall get-c 'keyword) "#c48702")
             :type (or (rainforest-get-theme-face-fg theme 'font-lock-type-face) (funcall get-c 'type) "#2fa526")
             :constant (or (rainforest-get-theme-face-fg theme 'font-lock-constant-face) (funcall get-c 'constant) "#64aa0f")
             :number (or (rainforest-get-theme-face-fg theme 'font-lock-number-face) (funcall get-c 'number) "#cfbcba")
             :builtin (or (rainforest-get-theme-face-fg theme 'font-lock-builtin-face) (funcall get-c 'builtin) "#ff7a7f")
             :fnname (or (rainforest-get-theme-face-fg theme 'font-lock-function-name-face) (funcall get-c 'fnname) "#3dbbb0")
             :fnname-call (or (rainforest-get-theme-face-fg theme 'font-lock-function-call-face) (funcall get-c 'fnname-call) "#82a0af")
             :string (or (rainforest-get-theme-face-fg theme 'font-lock-string-face) (funcall get-c 'string) "#f06a3f")
             :property (or (rainforest-get-theme-face-fg theme 'font-lock-property-name-face) (funcall get-c 'property) "#6fafff")
             :operator (or (rainforest-get-theme-face-fg theme 'font-lock-operator-face) (funcall get-c 'operator) "#cfbcba")
             :bracket (or (rainforest-get-theme-face-fg theme 'font-lock-bracket-face) (funcall get-c 'bracket) "#cfbcba")
             :delimiter (or (rainforest-get-theme-face-fg theme 'font-lock-delimiter-face) (funcall get-c 'delimiter) "#cfbcba")
             :err (or (rainforest-get-theme-face-fg theme 'font-lock-warning-face) (funcall get-c 'err) "#f06a3f"))))
      (let* ((partial (cond
                       ((eq theme 'rainforest-night) rainforest-night-palette-partial)
                       ((eq theme 'rainforest-day) rainforest-day-palette-partial)
                       ((boundp 'rainforest-day-palette-partial) (symbol-value 'rainforest-day-palette-partial))
                       (t nil)))
             (bg (or (cadr (assq 'bg-main partial)) (if (eq theme 'rainforest-day) "#b2beaf" "#0c0b08")))
             (fg (or (cadr (assq 'fg-main partial)) (if (eq theme 'rainforest-day) "#122216" "#9c9a96")))
             (dim (or (cadr (assq 'fg-dim partial)) (if (eq theme 'rainforest-day) "#485a4c" "#526456")))
             (cur (or (cadr (assq 'cursor partial)) (if (eq theme 'rainforest-day) "#105476" "#56a0c4")))
             (hl (or (cadr (assq 'bg-hl-line partial)) (if (eq theme 'rainforest-day) "#a2af9f" "#182026"))))
        (list
         :theme theme
         :bg-main bg
         :bg-hl-line hl
         :fg-main fg
         :fg-dim dim
         :cursor cur
         :preprocessor (or (rainforest-get-theme-face-fg theme 'font-lock-preprocessor-face)
                           (cadr (assq 'cyan-warmer partial)) "#7a6450")
         :keyword (or (rainforest-get-theme-face-fg theme 'font-lock-keyword-face)
                      (cadr (assq 'cyan partial)) "#2c8446")
         :type (or (rainforest-get-theme-face-fg theme 'font-lock-type-face)
                   (cadr (assq 'green partial)) "#6ca253")
         :constant (or (rainforest-get-theme-face-fg theme 'font-lock-constant-face)
                       (cadr (assq 'magenta partial)) "#7ec4da")
         :number (or (rainforest-get-theme-face-fg theme 'font-lock-number-face)
                     (cadr (assq 'yellow-warmer partial)) "#c69038")
         :builtin (or (rainforest-get-theme-face-fg theme 'font-lock-builtin-face)
                      (cadr (assq 'magenta-cooler partial)) "#b26e4e")
         :fnname (or (rainforest-get-theme-face-fg theme 'font-lock-function-name-face)
                     (cadr (assq 'blue partial)) "#2c7094")
         :fnname-call (or (rainforest-get-theme-face-fg theme 'font-lock-function-call-face)
                          (cadr (assq 'blue-warmer partial)) "#469cd8")
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
                  (cadr (assq 'red partial)) "#9e3834"))))))

;; =============================================================================
;; Color Conversion & Photometric Mathematics
;; =============================================================================

(defun rf-clean-hex (hex)
  "Normalise HEX to lowercase #rrggbb, signalling an error if it is not one.
A missing palette entry (nil) must never be silently evaluated as #000000:
every photometric gate would then measure pure black instead of the face."
  (let ((s (format "%s" hex)))
    (if (string-match "\\`#\\([0-9a-fA-F]\\{6\\}\\)\\'" s)
        (concat "#" (downcase (match-string 1 s)))
      (error "rf-clean-hex: not a #rrggbb colour: %S" hex))))

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

;; APCA / SAPC 0.0.98G-4g (Somers, A. "Accessible Perceptual Contrast
;; Algorithm", W3C Silver / WCAG 3 candidate).  Constants and control flow
;; follow the reference implementation apca-w3 0.1.9 (src/apca-w3.js,
;; functions `sRGBtoY' and `APCAcontrast'), https://github.com/Myndex/apca-w3.
;; Two properties of the reference are easy to get wrong and are load-bearing:
;;  1. Input is the APCA *estimated screen luminance* Ys, obtained with a pure
;;     2.4 power ("simpleExp", mainTRC) and NO IEC 61966-2-1 linear toe.
;;     Feeding the piecewise sRGB EOTF (`rf-luminance-y') inflates Y of dark
;;     colours by up to ~5x and shifts Lc on dark canvases.
;;  2. Polarity is signed: BoW (dark text on light) -> positive Lc,
;;     WoB (light text on dark) -> negative Lc.
(defconst rf-apca-main-trc 2.4 "APCA mainTRC exponent (apca-w3 0.1.9).")

(defun rf-apca-screen-y (hex)
  "Return APCA 0.0.98G-4g estimated screen luminance Ys of HEX.
Ys = 0.2126729 R^2.4 + 0.7151522 G^2.4 + 0.0721750 B^2.4 (apca-w3 `sRGBtoY')."
  (let ((rgb (rf-hex-to-rgb hex)))
    (+ (* 0.2126729 (expt (nth 0 rgb) rf-apca-main-trc))
       (* 0.7151522 (expt (nth 1 rgb) rf-apca-main-trc))
       (* 0.0721750 (expt (nth 2 rgb) rf-apca-main-trc)))))

(defun rf-apca-from-luminance (txt-y bg-y)
  "Return signed APCA 0.0.98G-4g Lc for screen luminances TXT-Y and BG-Y.
Positive for BoW (BG-Y > TXT-Y), negative for WoB.  Inputs outside
[0.0, 1.1] return 0.0 exactly as the reference implementation does."
  (if (or (< (min txt-y bg-y) 0.0) (> (max txt-y bg-y) 1.1))
      0.0
    (let* ((blk-thrs 0.022)
           (blk-clmp 1.414)
           (txt-c (if (> txt-y blk-thrs) txt-y (+ txt-y (expt (- blk-thrs txt-y) blk-clmp))))
           (bg-c  (if (> bg-y blk-thrs)  bg-y  (+ bg-y  (expt (- blk-thrs bg-y)  blk-clmp)))))
      (cond
       ((< (abs (- bg-c txt-c)) 0.0005) 0.0)
       ((> bg-c txt-c)
        ;; BoW: normBG 0.56, normTXT 0.57, scaleBoW 1.14, loBoWoffset 0.027
        (let ((sapc (* (- (expt bg-c 0.56) (expt txt-c 0.57)) 1.14)))
          (if (< sapc 0.1) 0.0 (* (- sapc 0.027) 100.0))))
       (t
        ;; WoB: revBG 0.65, revTXT 0.62, scaleWoB 1.14, loWoBoffset 0.027
        (let ((sapc (* (- (expt bg-c 0.65) (expt txt-c 0.62)) 1.14)))
          (if (> sapc -0.1) 0.0 (* (+ sapc 0.027) 100.0))))))))

(defun rf-apca-contrast (txt-hex bg-hex)
  "Return signed APCA 0.0.98G-4g Lc of TXT-HEX against BG-HEX."
  (rf-apca-from-luminance (rf-apca-screen-y txt-hex) (rf-apca-screen-y bg-hex)))

(defun rf-lcd-contrast (txt-hex bg-hex)
  "Calculate APCA Lc with LCD black bleed (0.008)."
  (rf-apca-from-luminance (+ (rf-apca-screen-y txt-hex) 0.008)
                          (+ (rf-apca-screen-y bg-hex) 0.008)))

(defun rf-oled-contrast (txt-hex bg-hex)
  "Calculate APCA Lc with OLED optical point irradiation (0.94)."
  (rf-apca-from-luminance (* (rf-apca-screen-y txt-hex) 0.94)
                          (rf-apca-screen-y bg-hex)))

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

;; CIE 1931 XYZ and CIE 1976 L*a*b* (CIE 15:2018, Colorimetry, 4th ed.,
;; DOI: 10.25039/TR.015.2018).  Emacs' own `color-srgb-to-lab' is NOT used:
;; as of Emacs 31.1 `color-srgb-to-xyz' divides the linear segment by 12.95
;; instead of the IEC 61966-2-1 value 12.92 (C0 discontinuity at 0.04045),
;; carries the typo 0.21266729 in the Y row, and normalises by a D65 white
;; (0.950455 1 1.088753) that is not the white of its own matrix, so sRGB
;; neutrals acquire non-zero a*, b*.
(defconst rf-srgb-to-xyz-matrix
  '((0.4124564 0.3575761 0.1804375)
    (0.2126729 0.7151522 0.0721750)
    (0.0193339 0.1191920 0.9503041))
  "Linear sRGB -> CIE 1931 XYZ, derived from IEC 61966-2-1:1999 primaries
and D65 (x=0.3127, y=0.3290); Y row equals `rf-luminance-y' weights.")

(defconst rf-d65-white-xyz
  (mapcar (lambda (row) (apply #'+ row)) rf-srgb-to-xyz-matrix)
  "Reference white of `rf-srgb-to-xyz-matrix' (RGB = 1,1,1), i.e. D65.")

(defun rf-hex-to-xyz (hex)
  "Convert HEX to CIE 1931 XYZ (Y of white = 1) via IEC 61966-2-1."
  (let* ((rgb (mapcar #'rf-srgb-to-linear (rf-hex-to-rgb hex))))
    (mapcar (lambda (row)
              (+ (* (nth 0 row) (nth 0 rgb))
                 (* (nth 1 row) (nth 1 rgb))
                 (* (nth 2 row) (nth 2 rgb))))
            rf-srgb-to-xyz-matrix)))

(defun rf-hex-to-cielab (hex)
  "Convert HEX to CIE 1976 L*a*b* relative to `rf-d65-white-xyz'."
  (let* ((eps (/ 216.0 24389.0))
         (kappa (/ 24389.0 27.0))
         (f (lambda (u) (if (> u eps) (expt u (/ 1.0 3.0))
                          (/ (+ (* kappa u) 16.0) 116.0))))
         (fxyz (cl-mapcar (lambda (c w) (funcall f (/ c w)))
                          (rf-hex-to-xyz hex) rf-d65-white-xyz)))
    (list (- (* 116.0 (nth 1 fxyz)) 16.0)
          (* 500.0 (- (nth 0 fxyz) (nth 1 fxyz)))
          (* 200.0 (- (nth 1 fxyz) (nth 2 fxyz))))))

;; CIELAB Chroma C*ab
(defun rf-cielab-chroma (hex)
  "Calculate CIE 1976 chroma C*ab = sqrt(a*^2 + b*^2) of HEX."
  (let* ((lab (rf-hex-to-cielab hex))
         (a (nth 1 lab))
         (b (nth 2 lab)))
    (sqrt (+ (* a a) (* b b)))))

;; =============================================================================
;; Reference Display Spectral Model
;; =============================================================================
;;
;; IEC 61966-2-1 defines sRGB primaries by chromaticity only; their spectral
;; power distributions (SPDs) are unspecified.  Any quantity weighted by an
;; action spectrum that is NOT a linear combination of the CIE 1931 CMFs -
;; scotopic V'(lambda), melanopic s_mel(lambda) (CIE S 026), blue-light hazard
;; B(lambda) (ICNIRP/IEC 62471), or the LCA defocus D(lambda) (Thibos 1992) -
;; is therefore undefined for an "sRGB colour" without a spectral model.
;; A least-squares projection of those spectra onto span{xbar,ybar,zbar}
;; (Cohen's fundamental metamer) leaves residuals of 21-55 % (L2), so an
;; explicit emitter model is unavoidable.
;;
;; Physical model: an RGB display emits through three emitter bands j (e.g.
;; OLED sub-pixel emitters, or LED/QD bands filtered by an LCD colour filter
;; array).  Every primary is a non-negative mixture of those bands:
;;   P_i(lambda) = sum_j C_ji G_j(lambda),   C = T^-1 M,
;; where T_kj = integral of CMF_k * G_j and M = `rf-srgb-to-xyz-matrix'.
;; This is the unique mixture that reproduces the IEC 61966-2-1 primaries and
;; D65 white *exactly*; the only free choice is the emitter bands.  C >= 0
;; (physically realisable, no negative light) is asserted.
;;
;; Default bands (Gaussian, peak/FWHM in nm): 460/25, 530/35, 620/35, a
;; representative RGB-OLED emitter set.  Sensitivity (per linear-RGB unit,
;; sweeping QD-LCD 450/530/630, OLED 455/525/615 and RGB-LED 465/525/625):
;; melanopic R 0.005-0.041, G 0.47-0.58, B 0.38-0.58; white S/P 2.40-2.94;
;; white BLH efficacy 0.80-0.85 mW/lm; blue-primary LCA -0.54..-0.62 D.
;; Gates that depend on the band choice must be read with this band in mind.

(require 'rf-spectral-data)

(defconst rf-km 683.002
  "Maximum photopic luminous efficacy K_m in lm/W (CIE 015:2018, sec. 5).")

(defconst rf-km-scotopic 1700.06
  "Maximum scotopic luminous efficacy K'_m in lm/W (CIE 015:2018, sec. 5).")

(defvar rf-display-emitter-bands
  '((460.0 . 25.0) (530.0 . 35.0) (620.0 . 35.0))
  "Reference display emitter bands as (PEAK-NM . FWHM-NM), blue, green, red.")

(defun rf--spectral-lambda (i)
  "Wavelength in nm of spectral sample I."
  (+ rf-spectral-lambda-min (* i rf-spectral-lambda-step)))

(defun rf--spectral-integral (u v)
  "Return sum_lambda U(lambda) V(lambda) dlambda for sampled vectors U, V."
  (let ((s 0.0))
    (dotimes (i rf-spectral-samples)
      (setq s (+ s (* (aref u i) (aref v i)))))
    (* s rf-spectral-lambda-step)))

(defun rf--gaussian-band (peak fwhm)
  "Return sampled unit-height Gaussian emitter band at PEAK nm with FWHM nm."
  (let ((sigma (/ fwhm (* 2.0 (sqrt (* 2.0 (log 2.0))))))
        (v (make-vector rf-spectral-samples 0.0)))
    (dotimes (i rf-spectral-samples v)
      (aset v i (exp (* -0.5 (expt (/ (- (rf--spectral-lambda i) peak) sigma) 2)))))))

(defun rf--mat3-inverse (m)
  "Return the inverse of 3x3 matrix M (list of rows) by cofactors."
  (let* ((a (nth 0 (nth 0 m))) (b (nth 1 (nth 0 m))) (c (nth 2 (nth 0 m)))
         (d (nth 0 (nth 1 m))) (e (nth 1 (nth 1 m))) (f (nth 2 (nth 1 m)))
         (g (nth 0 (nth 2 m))) (h (nth 1 (nth 2 m))) (k (nth 2 (nth 2 m)))
         (det (+ (* a (- (* e k) (* f h)))
                 (- (* b (- (* d k) (* f g))))
                 (* c (- (* d h) (* e g))))))
    (when (< (abs det) 1e-12)
      (error "rf--mat3-inverse: singular matrix"))
    (mapcar (lambda (row) (mapcar (lambda (x) (/ x det)) row))
            (list (list (- (* e k) (* f h)) (- (* c h) (* b k)) (- (* b f) (* c e)))
                  (list (- (* f g) (* d k)) (- (* a k) (* c g)) (- (* c d) (* a f)))
                  (list (- (* d h) (* e g)) (- (* b g) (* a h)) (- (* a e) (* b d)))))))

(defun rf--mat3-mul (a b)
  "Return the 3x3 matrix product A B (lists of rows)."
  (mapcar (lambda (row)
            (cl-loop for j below 3
                     collect (cl-loop for k below 3
                                      sum (* (nth k row) (nth j (nth k b))))))
          a))

(defvar rf--display-primary-cache nil
  "Cons (BANDS . PRIMARY-SPDS) memoising `rf-display-primary-spds'.")

(defun rf-display-primary-spds ()
  "Return sampled SPDs (R G B) of the reference display primaries.
Each P_i is scaled so that its CIE 1931 XYZ equals column i of
`rf-srgb-to-xyz-matrix' (hence sum_i Y_i = 1 for white)."
  (if (equal (car rf--display-primary-cache) rf-display-emitter-bands)
      (cdr rf--display-primary-cache)
    (let* ((bands (mapcar (lambda (b) (rf--gaussian-band (car b) (cdr b)))
                          rf-display-emitter-bands))
           (cmfs (list rf-cie1931-xbar rf-cie1931-ybar rf-cie1931-zbar))
           (tmat (mapcar (lambda (cmf)
                           (mapcar (lambda (g) (rf--spectral-integral cmf g)) bands))
                         cmfs))
           (mix (rf--mat3-mul (rf--mat3-inverse tmat) rf-srgb-to-xyz-matrix))
           (spds (cl-loop for i below 3
                          collect (let ((p (make-vector rf-spectral-samples 0.0)))
                                    (cl-loop for j below 3
                                             for c = (nth i (nth j mix))
                                             do (when (< c -1e-9)
                                                  (error "Emitter bands %S cannot realise sRGB primary %d without negative light (C=%g)"
                                                         rf-display-emitter-bands i c))
                                             (dotimes (l rf-spectral-samples)
                                               (aset p l (+ (aref p l) (* c (aref (nth j bands) l))))))
                                    p))))
      (setq rf--display-primary-cache (cons rf-display-emitter-bands spds))
      spds)))

(defun rf-spectral-rgb-weights (action)
  "Return (w_R w_G w_B): integral of ACTION times each display primary SPD.
For linear RGB c, sum_i c_i w_i is the ACTION-weighted radiance in units
of (display white luminance / K_m), i.e. W m^-2 sr^-1 per cd m^-2 x K_m."
  (mapcar (lambda (p) (rf--spectral-integral action p)) (rf-display-primary-spds)))

(defun rf-hex-spectral-response (hex action)
  "Return ACTION-weighted response of HEX under the reference display model."
  (let ((rgb (mapcar #'rf-srgb-to-linear (rf-hex-to-rgb hex))))
    (cl-loop for c in rgb for w in (rf-spectral-rgb-weights action) sum (* c w))))

(defconst rf-melanopic-efficacy-d65
  (/ (rf--spectral-integral rf-cie-s026-melanopic rf-cie-d65-spd)
     (* rf-km (rf--spectral-integral rf-cie1931-ybar rf-cie-d65-spd)))
  "Melanopic efficacy of luminous radiation for CIE D65, K_mel,v^D65 in W/lm.
Computed from the tabulated data; CIE S 026:2018 publishes 1.3262 mW/lm.")

(defun rf-spectral-model-self-check ()
  "Verify the reference display model against its defining standards.
Signals an error if the modelled primaries do not reproduce
`rf-srgb-to-xyz-matrix' or if K_mel,v^D65 deviates from CIE S 026 by
more than 0.5 %."
  (let ((cmfs (list rf-cie1931-xbar rf-cie1931-ybar rf-cie1931-zbar)))
    (cl-loop for p in (rf-display-primary-spds) for i from 0 do
             (cl-loop for cmf in cmfs for k from 0 do
                      (let ((got (rf--spectral-integral cmf p))
                            (want (nth i (nth k rf-srgb-to-xyz-matrix))))
                        (when (> (abs (- got want)) 1e-9)
                          (error "Display model: primary %d component %d = %g, expected %g"
                                 i k got want))))))
  (when (> (abs (- rf-melanopic-efficacy-d65 1.3262e-3)) (* 0.005 1.3262e-3))
    (error "Display model: K_mel,v^D65 = %g W/lm deviates from CIE S 026 (1.3262 mW/lm)"
           rf-melanopic-efficacy-d65))
  t)

(rf-spectral-model-self-check)

;; Longitudinal chromatic aberration of the human eye: chromatic reduced-eye
;; model of Thibos, Ye, Zhang & Bradley (1992) "The chromatic eye: a new
;; reduced-eye model of ocular chromatic aberration in humans", Appl. Opt.
;; 31(19):3594-3600, DOI: 10.1364/AO.31.003594.
;;   D(lambda) = p - q / (lambda_um - c),  p = 1.68524, q = 0.63346,
;;   c = 0.21410, zero at 589.3 nm (sodium D line).
(defconst rf-thibos-p 1.68524 "Thibos et al. (1992) chromatic eye constant p.")
(defconst rf-thibos-q 0.63346 "Thibos et al. (1992) chromatic eye constant q.")
(defconst rf-thibos-c 0.21410 "Thibos et al. (1992) chromatic eye constant c (um).")

(defun rf-thibos-defocus-at (lambda-nm)
  "Chromatic defocus D(lambda) in dioptres at LAMBDA-NM (Thibos et al. 1992)."
  (- rf-thibos-p (/ rf-thibos-q (- (/ lambda-nm 1000.0) rf-thibos-c))))

(defun rf--primary-luminance-moment (action-fn)
  "Return per-primary (ACTION-FN weighted by V(lambda)) / Y_i as a list."
  (let ((w (make-vector rf-spectral-samples 0.0)))
    (dotimes (i rf-spectral-samples)
      (aset w i (* (aref rf-cie1931-ybar i) (funcall action-fn (rf--spectral-lambda i)))))
    (cl-loop for p in (rf-display-primary-spds)
             for y in (nth 1 rf-srgb-to-xyz-matrix)
             collect (/ (rf--spectral-integral w p) y))))

(defvar rf--primary-defocus nil "Cached per-primary mean chromatic defocus (D).")
(defvar rf--primary-centroid nil "Cached per-primary luminance-weighted centroid (nm).")

(defun rf-primary-defocus ()
  "Per-primary luminance-weighted mean chromatic defocus in dioptres."
  (or rf--primary-defocus
      (setq rf--primary-defocus (rf--primary-luminance-moment #'rf-thibos-defocus-at))))

(defun rf-primary-centroid ()
  "Per-primary luminance-weighted spectral centroid in nm."
  (or rf--primary-centroid
      (setq rf--primary-centroid (rf--primary-luminance-moment #'identity))))

(defun rf--primary-luminance-weights (hex)
  "Return the per-primary luminance contributions (c_i Y_i) of HEX."
  (cl-loop for c in (mapcar #'rf-srgb-to-linear (rf-hex-to-rgb hex))
           for y in (nth 1 rf-srgb-to-xyz-matrix)
           collect (* c y)))

(defun rf-effective-wavelength (hex)
  "Luminance-weighted spectral centroid of HEX in nm under the display model.
Returns the centroid of display white for a colour of zero luminance."
  (let* ((w (rf--primary-luminance-weights hex))
         (sum (apply #'+ w)))
    (if (< sum 1e-9)
        (/ (cl-loop for l in (rf-primary-centroid)
                    for y in (nth 1 rf-srgb-to-xyz-matrix) sum (* l y))
           (apply #'+ (nth 1 rf-srgb-to-xyz-matrix)))
      (/ (cl-loop for l in (rf-primary-centroid) for wi in w sum (* l wi)) sum))))

(defun rf-thibos-diopters (hex)
  "Luminance-weighted mean chromatic defocus of HEX in dioptres.
The mean is taken over D(lambda), NOT of D evaluated at a mean wavelength:
D is strictly concave, so by Jensen's inequality the latter systematically
underestimates the defocus of broadband or mixed-primary colours (up to
0.11 D for red/blue mixtures at 5 nm sampling)."
  (let* ((w (rf--primary-luminance-weights hex))
         (sum (apply #'+ w)))
    (if (< sum 1e-9)
        (/ (cl-loop for d in (rf-primary-defocus)
                    for y in (nth 1 rf-srgb-to-xyz-matrix) sum (* d y))
           (apply #'+ (nth 1 rf-srgb-to-xyz-matrix)))
      (/ (cl-loop for d in (rf-primary-defocus) for wi in w sum (* d wi)) sum))))

(defun rf-lca-disparity (hex1 hex2)
  (abs (- (rf-thibos-diopters hex1) (rf-thibos-diopters hex2))))

;; Emacs 16-bit Riemersma color distance
(defun rf-color-distance (hex1 hex2)
  (color-distance (rf-hex-to-rgb16 hex1) (rf-hex-to-rgb16 hex2)))

;; Viewing geometry (declared assumption, used for every angular quantity).
(defconst rf-viewing-distance-mm 600.0
  "Eye-to-screen distance in mm (ISO 9241-303 recommends >= 400 mm).")
(defconst rf-display-width-mm 597.7
  "Active display width in mm (27-inch 16:9 panel).")
(defconst rf-display-height-mm 336.2
  "Active display height in mm (27-inch 16:9 panel).")
(defconst rf-observer-age 30.0
  "Observer age in years, used by the pupil model.")

(defun rf-degrees (opposite-mm)
  "Angle in degrees subtended by OPPOSITE-MM at `rf-viewing-distance-mm'."
  (* 2.0 (/ 180.0 float-pi) (atan (/ (* 0.5 opposite-mm) rf-viewing-distance-mm))))

(defun rf-display-field-area-deg2 ()
  "Solid-angle area of the display in square degrees."
  (* (rf-degrees rf-display-width-mm) (rf-degrees rf-display-height-mm)))

;; Pupil diameter: unified formula of Watson & Yellott (2012) "A unified
;; formula for light-adapted pupil size", J. Vis. 12(10):12,
;; DOI: 10.1167/12.10.12, which wraps Stanley & Davies (1995) corneal flux
;; density with the age term of Winn et al. (1994).  The formula previously
;; used here, d = 4.9 - 3 tanh[0.4 (log10 L + 1)], was attributed to
;; de Groot & Gebhard (1952) but is a shifted Moon & Spencer (1944)
;; expression: de Groot & Gebhard is d = 7.175 exp[-0.00092 (7.597 +
;; log10 L)^3], and Moon & Spencer carries no +1 decade offset for
;; luminance in cd/m^2 (cf. Watson & Yellott 2012, Table 1).  Neither
;; accounts for adapting field size, which for a screen is the dominant
;; term.
(defun rf-pupil-diameter (luminance-cd-m2 &optional field-deg2 age eyes)
  "Pupil diameter in mm for adapting LUMINANCE-CD-M2 (Watson & Yellott 2012).
FIELD-DEG2 defaults to the display field area, AGE to `rf-observer-age',
EYES to 2 (binocular; monocular viewing scales the flux by 0.1)."
  (let* ((l (max 1e-6 luminance-cd-m2))
         (a (or field-deg2 (rf-display-field-area-deg2)))
         (y (or age rf-observer-age))
         (e (if (eq (or eyes 2) 1) 0.1 1.0))
         (f (/ (* l a e) 846.0))
         (fp (expt f 0.41))
         (d-sd (- 7.75 (* 5.75 (/ fp (+ fp 2.0))))))
    (+ d-sd (* (- y 28.58) (- 0.021323 (* 0.0095623 d-sd))))))

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

;; Reference viewing conditions of IEC 61966-2-1:1999 (sRGB), clause 2:
;; display white luminance 80 cd/m^2, ambient illuminance 64 lx, veiling
;; glare 0.2 cd/m^2.  Every absolute photometric quantity in this suite is
;; anchored to these values instead of ad-hoc per-test constants.
(defconst rf-display-white-luminance 80.0
  "Luminance of display white in cd/m^2 (IEC 61966-2-1:1999 reference).")

(defconst rf-ambient-illuminance 64.0
  "Ambient illuminance at the observer in lx (IEC 61966-2-1:1999 reference).")

(defconst rf-reference-veiling-glare 0.2
  "Display veiling glare luminance in cd/m^2 (IEC 61966-2-1:1999 reference).")

(defun rf-luminance-cd (hex &optional white-cd)
  "Absolute luminance of HEX in cd/m^2 for a display white of WHITE-CD."
  (* (rf-luminance-y hex) (or white-cd rf-display-white-luminance)))

;; Scotopic & Mesopic Vision (CIE 191:2010 Purkinje Shift)
(defun rf-scotopic-luminance (hex &optional white-cd)
  "Scotopic luminance of HEX in scotopic cd/m^2, display white = WHITE-CD.
L' = K'_m Int V'(lambda) L_e(lambda) dlambda over the reference display
model, so display white yields L'/L = S/P = 2.54 for the default emitter
bands (2.46 for a true D65 spectrum), instead of the value 1.0 implied by
the previous normalised RGB weights."
  (* (or white-cd rf-display-white-luminance)
     (/ (* rf-km-scotopic (rf-hex-spectral-response hex rf-cie1951-vprime))
        rf-km)))

(defconst rf-mesopic-vprime-555 (/ rf-km rf-km-scotopic)
  "V'(lambda_0) = K_m/K'_m at lambda_0 = 555 nm, as used by CIE 191:2010.")

(defun rf-mesopic-adaptation-coefficient (lp ls)
  "Return CIE 191:2010 adaptation coefficient m for photopic LP and scotopic LS.
Both luminances are in cd/m^2.  Implements the iterative MES-2 procedure:
m_0 = 0.5, L_mes,n = [m L_p + (1-m) L_s V'(l_0)] / [m + (1-m) V'(l_0)],
m_n = 0.767 + 0.3334 log10(L_mes,n), clamped to m = 1 at or above
5 cd/m^2 (photopic) and m = 0 at or below 0.005 cd/m^2 (scotopic)."
  (let ((m 0.5)
        (vp rf-mesopic-vprime-555))
    (dotimes (_ 10 m)
      (let ((lmes (/ (+ (* m lp) (* (- 1.0 m) ls vp))
                     (+ m (* (- 1.0 m) vp)))))
        (setq m (cond ((>= lmes 5.0) 1.0)
                      ((<= lmes 0.005) 0.0)
                      (t (max 0.0 (min 1.0 (+ 0.767 (* 0.3334 (log lmes 10))))))))))))

(defun rf-mesopic-luminance (hex m &optional white-cd)
  "Mesopic luminance of HEX in cd/m^2 under adaptation coefficient M.
M describes the observer's adaptation state (see
`rf-mesopic-adaptation-coefficient'); it is a property of the adaptation
field, not of the individual stimulus."
  (let* ((lp (rf-luminance-cd hex white-cd))
         (ls (rf-scotopic-luminance hex white-cd))
         (vp rf-mesopic-vprime-555))
    (/ (+ (* m lp) (* (- 1.0 m) ls vp))
       (+ m (* (- 1.0 m) vp)))))

;; Standard 80x40 character viewport composition, shared by every test that
;; needs a field/adaptation luminance rather than a single colour.
(defconst rf-viewport-cells 3200 "Character cells in an 80x40 viewport.")
(defconst rf-viewport-code-cells 1050 "Cells covered by syntax ink.")
(defconst rf-viewport-hl-cells 80 "Cells covered by the hl-line band.")

(defun rf-viewport-mean-luminance-y (pal)
  "Mean relative luminance of an 80x40 viewport rendered with palette PAL."
  (let* ((keys '(:fg-main :keyword :type :property :fnname-call :number :string :constant))
         (ink (/ (cl-loop for k in keys sum (rf-luminance-y (plist-get pal k)))
                 (float (length keys))))
         (hl (rf-luminance-y (plist-get pal :bg-hl-line)))
         (bg (rf-luminance-y (plist-get pal :bg-main)))
         (bg-cells (- rf-viewport-cells rf-viewport-code-cells rf-viewport-hl-cells)))
    (/ (+ (* rf-viewport-code-cells ink)
          (* rf-viewport-hl-cells hl)
          (* bg-cells bg))
       (float rf-viewport-cells))))

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
      (/ (abs (- y-peak-blur y-bg)) (+ y-peak-blur y-bg)))))

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

;; Photophobia & Neuro-Ophthalmic Models: CIE S 026 & Hopkinson DGI
(defun rf-melanopic-irradiance (hex)
  "Return melanopic equivalent daylight luminance of HEX per unit display white.
Computed per CIE S 026:2018 as L_mel,EDI = L_mel / K_mel,v^D65 from the
melanopic-weighted radiance of the reference display model, normalised by
the luminance of display white.  Display white returns mel-DER(white)
(0.997 for the default OLED emitter bands), so the scale matches the
melanopic daylight (D65) equivalent, not an arbitrary unit."
  (/ (rf-hex-spectral-response hex rf-cie-s026-melanopic)
     (* rf-km rf-melanopic-efficacy-d65)))

(defun rf-melanopic-photopic-ratio (hex)
  "Return the melanopic daylight efficacy ratio mel-DER of HEX (CIE S 026:2018).
This is melanopic EDI divided by photopic luminance; D65 has mel-DER = 1
by definition."
  (let ((y (rf-luminance-y hex))
        (m (rf-melanopic-irradiance hex)))
    (if (< y 1e-6)
        0.0
      (/ m y))))

(defun rf-hopkinson-glare-constant (token-hex bg-hex &optional solid-angle ambient-lum)
  "Compute Hopkinson glare constant G for TOKEN-HEX against BG-HEX.
SOLID-ANGLE defaults to 0.00025 sr (typical word at 60cm).
AMBIENT-LUM defaults to 1.5 cd/m2 ambient field adaptation."
  (let* ((omega (or solid-angle 0.00025))
         (ambient (or ambient-lum 1.5))
         (peak-cd-m2 100.0)
         (ls (* (rf-luminance-y token-hex) peak-cd-m2))
         (lb (+ (* (rf-luminance-y bg-hex) peak-cd-m2) ambient)))
    (* 0.478 (/ (* (expt (max 0.001 ls) 1.6) (expt omega 0.8))
                (+ lb (* 0.07 (sqrt omega) ls))))))

(defun rf-hopkinson-dgi (tokens bg-hex &optional solid-angle ambient-lum)
  "Calculate cumulative CIE Discomfort Glare Index (DGI in dB) for TOKENS.
DGI = 10 * log10(sum(G_i))."
  (let ((sum-g 0.0))
    (dolist (tok tokens)
      (setq sum-g (+ sum-g (rf-hopkinson-glare-constant tok bg-hex solid-angle ambient-lum))))
    (if (< sum-g 1e-6)
        0.0
      (* 10.0 (log sum-g 10)))))

;; Wilkins Pattern Glare & Cortical Visual Stress (Wilkins 1995, 2016)
(defun rf-wilkins-line-michelson (token-hex bg-hex &optional duty-cycle ambient-lum)
  "Calculate local Michelson contrast C_M of a text line against background.
DUTY-CYCLE defaults to 0.35 (35% stroke fill on a line).
AMBIENT-LUM defaults to 0.025 (display veiling/ambient luminance floor)."
  (let* ((eta (or duty-cycle 0.35))
         (amb (or ambient-lum 0.025))
         (eff-bg (+ (rf-luminance-y bg-hex) amb))
         (eff-fg (+ (rf-luminance-y token-hex) amb))
         (line-y (+ (* eta eff-fg) (* (- 1.0 eta) eff-bg))))
    (/ (abs (- line-y eff-bg)) (+ line-y eff-bg))))

;; Retinal blue-light hazard, ICNIRP (2013) Table 2 / IEC 62471:2006 B(lambda).
;; A display is a large source, so the applicable quantity is the B-weighted
;; RADIANCE L_B (W m^-2 sr^-1) compared with L_B^EL = 100 W m^-2 sr^-1 for
;; t > 10^4 s (ICNIRP 2013, eq. 14) - not an irradiance in arbitrary units.
(defun rf-blue-light-hazard-radiance (hex &optional white-cd)
  "Blue-light-hazard weighted radiance L_B of HEX in W m^-2 sr^-1.
WHITE-CD defaults to `rf-display-white-luminance'."
  (* (/ (or white-cd rf-display-white-luminance) rf-km)
     (rf-hex-spectral-response hex rf-icnirp-blue-light-hazard)))

(defconst rf-blue-light-hazard-efficacy-d65
  (/ (rf--spectral-integral rf-icnirp-blue-light-hazard rf-cie-d65-spd)
     (* rf-km (rf--spectral-integral rf-cie1931-ybar rf-cie-d65-spd)))
  "Blue-light-hazard efficacy of luminous radiation K_B,v for D65, in W/lm.")

(defun rf-blue-light-hazard-efficacy (hex)
  "Blue-light-hazard efficacy K_B,v of HEX in W/lm (L_B per unit luminance).
Independent of display brightness; 0 for a black (zero luminance) colour."
  (let ((y (rf-luminance-cd hex)))
    (if (< y 1e-9)
        0.0
      (/ (rf-blue-light-hazard-radiance hex) y))))

;; Pupillary Hippus & Saccadic Local Adaptation (PLR micro-spasm model)
(defun rf-saccadic-adaptation-delta (hex1 hex2 &optional duty-cycle)
  "Calculate local foveal adaptation jump Delta-L during saccades between HEX1 and HEX2.
DUTY-CYCLE defaults to 0.25 (foveal ink coverage fraction)."
  (let* ((eta (or duty-cycle 0.25))
         (y1 (rf-luminance-y hex1))
         (y2 (rf-luminance-y hex2)))
    (* eta (abs (- y1 y2)))))

;; Astigmatic Anisotropic Cylinder (-1.50D) Meridional Blur & Edge Acutance
(defun rf-meridional-blur-metrics (token-hex bg-hex &optional peak-eta valley-beta)
  "Compute blurred peak luminance, valley fill, modulation depth, and Edge Acutance
under an uncorrected -1.50D astigmatic cylinder defocus.
PEAK-ETA defaults to 0.52 (core stroke peak retention).
VALLEY-BETA defaults to 0.26 (inter-character gap valley fill)."
  (let* ((eta (or peak-eta 0.52))
         (beta (or valley-beta 0.26))
         (bg-y (rf-luminance-y bg-hex))
         (tok-y (rf-luminance-y token-hex))
         (y-peak (+ bg-y (* (- tok-y bg-y) eta)))
         (y-valley (+ bg-y (* (- tok-y bg-y) beta)))
         (mod-depth (/ (abs (- y-peak y-valley)) (max 1e-4 (+ y-peak y-valley))))
         (acutance (/ (abs (- y-peak bg-y)) (* 1.8 (max 1e-4 (+ y-peak bg-y))))))
    (list :peak y-peak :valley y-valley :modulation mod-depth :acutance acutance)))

(provide 'test-palette-extractor)
;;; test-palette-extractor.el ends here
