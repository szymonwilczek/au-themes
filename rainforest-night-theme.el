;;; rainforest-night-theme.el --- Deep rainy forest shelter theme -*- lexical-binding:t -*-

(require 'ef-themes)

(defconst rainforest-night-palette-partial
  '(;; Canvas & Chrome (Deep nocturnal black with an incredibly subtle pine night tint)
    (cursor "#ffaa33")
    (bg-main "#0b110c")
    (bg-dim "#161e18")
    (bg-alt "#222c24")
    (fg-main "#cfbcba")
    (fg-dim "#627464")
    (fg-alt "#a48e38")        ; Warm golden lichen
    (fg-var "#b8ae9c")        ; Light birch quartz: variable definitions
    (bg-active "#304034")
    (bg-inactive "#151c16")
    (border "#36443a")

    ;; Deep Temperate Rainforest Palette (Pure Forest Greens, Deep Cedar Bark, Warm Amber Resin)
    (red "#b8443c")           ; Deep mountain yew crimson: alerts, errors, negation !
    (red-warmer "#caa034")    ; Luminous golden amber tree resin: strings ("strings")
    (red-cooler "#b8443c")
    (red-faint "#526856")     ; Damp wet spruce twigs: brackets ( ) [ ] { }

    (green "#6aa834")         ; Warm wet forest moss / fern: data types (int, size_t, uint32_t)
    (green-warmer "#7ea82e")  ; Deep forest olive foliage / lichen: constants (LOTA_PCR_COUNT, NULL)
    (green-cooler "#38944c")  ; Deep terrestrial fir / pine needle green: keywords (static, while, return, struct)
    (green-faint "#627464")   ; Quiet forest needles: comments

    (yellow "#38944c")        ; Keyword alias: deep terrestrial fir needle green
    (yellow-warmer "#cca434") ; Warm golden forest honey: numbers (0, 24, 32 in buf[0])
    (yellow-cooler "#88542c") ; Weathered dark cedar tree bark brown: preprocessor (#define)
    (yellow-faint "#627464")  ; Quiet forest needles

    (blue "#388ec8")          ; Mountain torrent water: function definitions (is_write_open_flags)
    (blue-warmer "#4e9ad2")   ; Nocturnal rain cascade: function calls (bpf_map_lookup_elem, BPF_CORE_READ)
    (blue-cooler "#84988e")   ; Mountain river slate quartz / flint: operators (?, &, :, +, -, *, ->)
    (blue-faint "#7ca68a")    ; Soft mountain sage / tree lichen: builtins (__always_inline, sizeof)

    (magenta "#7ea82e")       ; Forest olive foliage: constants (LOTA_PCR_COUNT, NULL)
    (magenta-warmer "#7ca68a")
    (magenta-cooler "#7ca68a") ; Soft mountain sage: builtins (__always_inline)
    (magenta-faint "#627464")

    (cyan "#38944c")          ; Deep terrestrial fir needle green (keywords)
    (cyan-warmer "#88542c")   ; Weathered dark cedar tree bark brown: preprocessor
    (cyan-cooler "#84988e")   ; Mountain river slate quartz / flint
    (cyan-faint "#cfbcba")    ; Base text: delimiters (, ;)

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
    (bg-popup "#161e18")
    (bg-hover "#203024")
    (bg-hover-secondary "#354538")
    (bg-hl-line "#162018")
    (bg-paren-match "#284430")
    (bg-err "#461204")
    (bg-warning "#353504")
    (bg-info "#1f3b0a")
    (bg-region "#203024")
    (fg-line-number-inactive "#3e4e42")))

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
    (keyword cyan)               ; #38944c - Deep forest fir needle green (static, struct, while, return)
    (builtin blue-faint)         ; #7ca68a - Soft mountain sage / tree lichen (__always_inline, sizeof)
    (type green)                 ; #6aa834 - Warm wet forest moss / fern (int, void, size_t, uint32_t)
    (preprocessor yellow-cooler) ; #88542c - Weathered dark cedar bark brown (#define, macro directives)
    (constant green-warmer)      ; #7ea82e - Forest olive foliage (LOTA_PCR_COUNT, NULL)
    (number yellow-warmer)       ; #cca434 - Warm golden forest honey (0, 24, 32 in buf[0])
    (fnname blue)                ; #388ec8 - Mountain stream water (is_write_open_flags)
    (fnname-call blue-warmer)    ; #4e9ad2 - Nocturnal rain cascade (bpf_map_lookup_elem, BPF_CORE_READ)
    (string red-warmer)          ; #caa034 - Luminous golden amber resin ("strings")
    (property fg-alt)            ; #a48e38 - Warm forest lichen (->tgid, .field)
    (variable fg-var)            ; #b8ae9c - Light birch quartz (variable definitions/names)
    (variable-use fg-main)       ; #cfbcba - Base text (variable usages)
    (operator blue-cooler)       ; #84988e - Mountain river slate / flint quartz (?, &, :, +, -, *, ->)
    (bracket red-faint)          ; #526856 - Damp wet spruce twigs (( ) [ ] { })
    (delimiter fg-main)          ; #cfbcba - Exact same as base text (;, ,)
    (comment green-faint)        ; #627464 - Quiet forest needles (italic)
    (docstring green-faint)      ; #627464 - Documentation strings (italic)
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
 "Deep nocturnal rainy forest theme - pure greens, authentic bark browns, deep rain blues."
 'dark
 'rainforest-night-palette
 nil
 nil)

;; Universal standard font-lock faces and LSP Eglot overrides:
(custom-theme-set-faces
 'rainforest-night
 '(default ((t (:background "#0b110c" :foreground "#cfbcba"))))
 '(font-lock-comment-face ((t (:foreground "#627464" :slant italic))))
 '(font-lock-comment-delimiter-face ((t (:foreground "#627464" :slant italic))))
 '(font-lock-doc-face ((t (:foreground "#627464" :slant italic))))
 '(font-lock-preprocessor-face ((t (:foreground "#88542c"))))
 '(font-lock-keyword-face ((t (:foreground "#38944c"))))
 '(font-lock-type-face ((t (:foreground "#6aa834"))))
 '(font-lock-constant-face ((t (:foreground "#7ea82e"))))
 '(font-lock-number-face ((t (:foreground "#cca434"))))
 '(font-lock-builtin-face ((t (:foreground "#7ca68a"))))
 '(font-lock-function-name-face ((t (:foreground "#388ec8"))))
 '(font-lock-function-call-face ((t (:foreground "#4e9ad2"))))
 '(font-lock-string-face ((t (:foreground "#caa034"))))
 '(font-lock-variable-name-face ((t (:foreground "#b8ae9c"))))
 '(font-lock-variable-use-face ((t (:foreground "#cfbcba"))))
 '(font-lock-property-name-face ((t (:foreground "#a48e38"))))
 '(font-lock-property-use-face ((t (:foreground "#a48e38"))))
 '(font-lock-operator-face ((t (:foreground "#84988e"))))
 '(font-lock-bracket-face ((t (:foreground "#526856"))))
 '(font-lock-delimiter-face ((t (:foreground "#cfbcba"))))
 '(font-lock-warning-face ((t (:foreground "#cca434"))))

 ;; Eglot LSP semantic tokens - ensure function calls NEVER get masked by variable faces:
 '(eglot-semantic-variable ((t (:inherit nil :foreground nil))))
 '(eglot-semantic-defaultLibrary ((t (:inherit nil :foreground nil))))
 '(eglot-semantic-readonly ((t (:inherit nil :foreground nil))))
 '(eglot-semantic-function ((t (:inherit font-lock-function-call-face :foreground "#4e9ad2"))))
 '(eglot-semantic-method ((t (:inherit font-lock-function-call-face :foreground "#4e9ad2"))))
 '(eglot-semantic-macro ((t (:inherit font-lock-preprocessor-face :foreground "#88542c"))))

 '(region ((t (:background "#203024" :extend t))))
 '(line-number ((t (:foreground "#3e4e42")))))

(provide 'rainforest-night-theme)
;;; rainforest-night-theme.el ends here
