;;; rainforest-night-theme.el --- Deep rainy forest shelter theme -*- lexical-binding:t -*-

(require 'ef-themes)

(defconst rainforest-night-palette-partial
  '(;; Canvas & Chrome (Deep ef-autumn nocturnal forest baseline)
    (cursor "#d89020")
    (bg-main "#0f0e06")
    (bg-dim "#26211d")
    (bg-alt "#36322f")
    (fg-main "#b2a09c")
    (fg-dim "#58685a")
    (fg-alt "#a08c4a")        ; Warm forest lichen
    (fg-var "#aba094")        ; Light birch quartz: variable definitions
    (bg-active "#56524f")
    (bg-inactive "#25241d")
    (border "#58514f")

    ;; Deep Temperate Rainforest Palette (Pure Forest Greens, Authentic Cedar Bark, Atmospheric Rain Blues)
    (red "#b6463e")           ; Deep mountain yew crimson: alerts, errors, negation !
    (red-warmer "#b26236")    ; Luminous warm amber / chestnut resin: strings ("strings")
    (red-cooler "#b6463e")
    (red-faint "#6c806e")     ; Damp wet spruce twigs: brackets ( ) [ ] { }

    (green "#7aa854")         ; Warm wet forest moss / fern: data types (int, size_t, uint32_t)
    (green-warmer "#869c44")  ; Deep forest olive foliage / lichen: constants (LOTA_PCR_COUNT, NULL)
    (green-cooler "#368846")  ; Deep terrestrial fir / pine needle green: keywords (static, while, return, struct)
    (green-faint "#58685a")   ; Quiet forest needles: comments

    (yellow "#368846")        ; Keyword alias: deep terrestrial fir needle green
    (yellow-warmer "#caa240") ; Warm golden forest honey: numbers (0, 24, 32 in buf[0])
    (yellow-cooler "#885226") ; Weathered dark cedar tree bark brown: preprocessor (#define)
    (yellow-faint "#58685a")  ; Quiet forest needles

    (blue "#3e84be")          ; Mountain river stream water: function definitions (is_write_open_flags)
    (blue-warmer "#66a4d2")   ; Nocturnal rain cascade: function calls (bpf_map_lookup_elem, BPF_CORE_READ)
    (blue-cooler "#6c8278")   ; Mountain river slate quartz / flint: operators (?, &, :, +, -, *, ->)
    (blue-faint "#60a28c")    ; Soft mountain sage / tree lichen: builtins (__always_inline, sizeof)

    (magenta "#869c44")       ; Forest olive foliage: constants (LOTA_PCR_COUNT, NULL)
    (magenta-warmer "#60a28c")
    (magenta-cooler "#60a28c") ; Soft mountain sage: builtins (__always_inline)
    (magenta-faint "#58685a")

    (cyan "#368846")          ; Deep terrestrial fir needle green (keywords)
    (cyan-warmer "#885226")   ; Weathered dark cedar tree bark brown: preprocessor
    (cyan-cooler "#6c8278")   ; Mountain river slate quartz / flint
    (cyan-faint "#7c7672")    ; Muted river pebble / flint: delimiters (, ;)

    ;; Panels and Diffs
    (bg-red-intense "#b02930")
    (bg-green-intense "#4a7000")
    (bg-yellow-intense "#8f5040")
    (bg-blue-intense "#4648d0")
    (bg-magenta-intense "#804fd5")
    (bg-cyan-intense "#2270be")

    (bg-red-subtle "#651f2a")
    (bg-green-subtle "#11422f")
    (bg-yellow-subtle "#583020")
    (bg-blue-subtle "#2f3069")
    (bg-magenta-subtle "#542657")
    (bg-cyan-subtle "#123e55")

    (bg-added "#17360f")
    (bg-added-faint "#0a2900")
    (bg-added-refine "#204810")
    (fg-added "#a0e0a0")

    (bg-changed "#363300")
    (bg-changed-faint "#2a1f00")
    (bg-changed-refine "#4a4a00")
    (fg-changed "#efef80")

    (bg-removed "#4b120a")
    (bg-removed-faint "#3a0a00")
    (bg-removed-refine "#6f1a16")
    (fg-removed "#ffbfbf")

    (bg-mode-line-active "#692a12")
    (fg-mode-line-active "#feeeca")
    (bg-completion "#392942")
    (bg-popup "#201e16")
    (bg-hover "#265f4a")
    (bg-hover-secondary "#55345a")
    (bg-hl-line "#28241e")
    (bg-paren-match "#2f6c4a")
    (bg-err "#461204")
    (bg-warning "#353504")
    (bg-info "#1f3b0a")
    (bg-region "#3f1324")
    (fg-line-number-inactive "#887c8a")))

(defconst rainforest-night-palette-mappings-partial
  '((err red)
    (warning yellow-warmer)
    (info green)

    (fg-link blue-warmer)
    (fg-link-visited blue)
    (name blue)
    (keybind red)
    (identifier fg-alt)
    (fg-prompt blue)

    ;; Syntax Mappings:
    (keyword cyan)               ; #368846 - Deep forest fir needle green (static, struct, while, return)
    (builtin blue-faint)         ; #60a28c - Soft mountain sage / tree lichen (__always_inline, sizeof)
    (type green)                 ; #7aa854 - Warm wet forest moss / fern (int, void, size_t, uint32_t)
    (preprocessor yellow-cooler) ; #885226 - Weathered dark cedar bark brown (#define, macro directives)
    (constant green-warmer)      ; #869c44 - Forest olive foliage (LOTA_PCR_COUNT, NULL)
    (number yellow-warmer)       ; #caa240 - Warm golden forest honey (0, 24, 32 in buf[0])
    (fnname blue)                ; #3e84be - Mountain river stream water (is_write_open_flags)
    (fnname-call blue-warmer)    ; #66a4d2 - Nocturnal rain cascade (bpf_map_lookup_elem, BPF_CORE_READ)
    (string red-warmer)          ; #b26236 - Luminous warm amber / chestnut resin ("strings")
    (property fg-alt)            ; #a08c4a - Warm forest lichen (->tgid, .field)
    (variable fg-var)            ; #aba094 - Light birch quartz (variable definitions/names)
    (variable-use fg-main)       ; #b2a09c - Base text (variable usages)
    (operator blue-cooler)       ; #6c8278 - Mountain river slate / flint quartz (?, &, :, +, -, *, ->)
    (bracket red-faint)          ; #6c806e - Damp wet spruce twigs (( ) [ ] { })
    (delimiter cyan-faint)       ; #7c7672 - Muted river pebble / flint (;, ,)
    (comment green-faint)        ; #58685a - Quiet forest needles (italic)
    (docstring green-faint)      ; #58685a - Documentation strings (italic)
    (rx-backslash yellow-cooler)
    (rx-construct red)

    (accent-0 blue)
    (accent-1 green)
    (accent-2 yellow-warmer)
    (accent-3 green-warmer)))

(defconst rainforest-night-palette
  (modus-themes-generate-palette
   rainforest-night-palette-partial
   nil
   nil
   (append rainforest-night-palette-mappings-partial ef-themes-palette-common)))

;;;###theme-autoload
(modus-themes-theme
 'rainforest-night
 'ef-themes
 "Deep nocturnal rainy forest theme - pure greens, authentic bark browns, atmospheric rain blues."
 'dark
 'rainforest-night-palette
 nil
 nil)

;; Universal standard font-lock faces and LSP Eglot overrides:
(custom-theme-set-faces
 'rainforest-night
 '(default ((t (:background "#0f0e06" :foreground "#b2a09c"))))
 '(font-lock-comment-face ((t (:foreground "#58685a" :slant italic))))
 '(font-lock-comment-delimiter-face ((t (:foreground "#58685a" :slant italic))))
 '(font-lock-doc-face ((t (:foreground "#58685a" :slant italic))))
 '(font-lock-preprocessor-face ((t (:foreground "#885226"))))
 '(font-lock-keyword-face ((t (:foreground "#368846"))))
 '(font-lock-type-face ((t (:foreground "#7aa854"))))
 '(font-lock-constant-face ((t (:foreground "#869c44"))))
 '(font-lock-number-face ((t (:foreground "#caa240"))))
 '(font-lock-builtin-face ((t (:foreground "#60a28c"))))
 '(font-lock-function-name-face ((t (:foreground "#3e84be"))))
 '(font-lock-function-call-face ((t (:foreground "#66a4d2"))))
 '(font-lock-string-face ((t (:foreground "#b26236"))))
 '(font-lock-variable-name-face ((t (:foreground "#aba094"))))
 '(font-lock-variable-use-face ((t (:foreground "#b2a09c"))))
 '(font-lock-property-name-face ((t (:foreground "#a08c4a"))))
 '(font-lock-property-use-face ((t (:foreground "#a08c4a"))))
 '(font-lock-operator-face ((t (:foreground "#6c8278"))))
 '(font-lock-bracket-face ((t (:foreground "#6c806e"))))
 '(font-lock-delimiter-face ((t (:foreground "#7c7672"))))
 '(font-lock-warning-face ((t (:foreground "#b6463e"))))

 ;; Eglot LSP semantic tokens - ensure function calls NEVER get masked by variable faces:
 '(eglot-semantic-variable ((t (:inherit nil :foreground nil))))
 '(eglot-semantic-defaultLibrary ((t (:inherit nil :foreground nil))))
 '(eglot-semantic-readonly ((t (:inherit nil :foreground nil))))
 '(eglot-semantic-function ((t (:inherit font-lock-function-call-face :foreground "#66a4d2"))))
 '(eglot-semantic-method ((t (:inherit font-lock-function-call-face :foreground "#66a4d2"))))
 '(eglot-semantic-macro ((t (:inherit font-lock-preprocessor-face :foreground "#885226"))))

 '(region ((t (:background "#3f1324" :extend t))))
 '(line-number ((t (:foreground "#887c8a")))))

(provide 'rainforest-night-theme)
;;; rainforest-night-theme.el ends here
