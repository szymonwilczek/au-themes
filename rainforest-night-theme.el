;;; rainforest-night-theme.el --- Deep rainy forest shelter theme -*- lexical-binding:t -*-

(require 'ef-themes)

(defconst rainforest-night-palette-partial
  '(;; Canvas & Chrome
    (cursor "#ffaa33")
    (bg-main "#0f0e06")
    (bg-dim "#26211d")
    (bg-alt "#36322f")
    (fg-main "#cfbcba")
    (fg-dim "#887c8a")
    (fg-alt "#a48e38")        ; Warm golden lichen
    (bg-active "#56524f")
    (bg-inactive "#25241d")
    (border "#58514f")

    ;; Deep Temperate Rainforest Palette (Pure Greens, Real Bark Browns, Deep Rain Blues)
    (red "#b43a34")           ; Deep yew berry crimson: alerts, errors, negation !
    (red-warmer "#966919")    ; Deep oak wood resin: strings ("strings")
    (red-cooler "#b43a34")
    (red-faint "#567060")     ; Damp wet twigs: brackets ( ) [ ] { }

    (green "#54a648")         ; Rich wet moss emerald: data types (int, size_t, uint32_t)
    (green-warmer "#6e9a38")  ; Deep forest olive foliage: constants (LOTA_PCR_COUNT, NULL)
    (green-cooler "#2c8446")  ; Deep conifer pine: keywords (static, while, return, struct)
    (green-faint "#6a7e70")   ; Quiet forest needles: comments

    (yellow "#2c8446")        ; Keyword alias: deep conifer pine green (original)
    (yellow-warmer "#bfa03c") ; Warm golden amber resin: numbers (0, 24, 32 in buf[0])
    (yellow-cooler "#7a5028") ; Authentic dark wood bark brown: preprocessor (#define)
    (yellow-faint "#6a7e70")  ; Quiet forest needles

    (blue "#1e72cc")          ; Deep mountain torrent blue: function definitions (is_write_open_flags)
    (blue-warmer "#3282dc")   ; Pure rain water blue: function calls (bpf_map_lookup_elem, BPF_CORE_READ)
    (blue-cooler "#587462")   ; Wet river slate: operators (+, -, *, >>, &)
    (blue-faint "#286cb8")    ; Deep mountain glacial blue: builtins (__always_inline, sizeof)

    (magenta "#6e9a38")       ; Forest olive foliage: constants (LOTA_PCR_COUNT, NULL)
    (magenta-warmer "#286cb8")
    (magenta-cooler "#286cb8") ; Deep glacial rain blue: builtins (__always_inline)
    (magenta-faint "#6a7e70")

    (cyan "#2c8446")          ; Deep conifer pine green (original static)
    (cyan-warmer "#7a5028")   ; Authentic dark bark brown: preprocessor
    (cyan-cooler "#587462")
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
    (bg-popup "#201e16")
    (bg-hover "#265f4a")
    (bg-hover-secondary "#55345a")
    (bg-hl-line "#302a3a")
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
    (keyword cyan)               ; #2c8446 - Deep conifer pine green (original static, struct, while)
    (builtin blue-faint)         ; #286cb8 - Deep mountain glacial blue (__always_inline, sizeof)
    (type green)                 ; #54a648 - Rich wet moss emerald (int, size_t, uint32_t)
    (preprocessor yellow-cooler) ; #7a5028 - Authentic dark wood bark brown (#define, macro directives)
    (constant green-warmer)      ; #6e9a38 - Deep forest olive foliage (LOTA_PCR_COUNT, NULL)
    (number yellow-warmer)       ; #bfa03c - Warm golden amber resin (0, 24, 32 in buf[0])
    (fnname blue)                ; #1e72cc - Deep mountain torrent blue (is_write_open_flags)
    (fnname-call blue-warmer)    ; #3282dc - Pure rain water blue (bpf_map_lookup_elem, BPF_CORE_READ)
    (string red-warmer)          ; #966919 - Deep oak wood resin ("strings")
    (property fg-alt)            ; #a48e38 - Warm forest lichen (->tgid, .field)
    (variable fg-main)           ; #cfbcba - Base text (variables)
    (variable-use fg-main)       ; #cfbcba - Variable usages
    (operator blue-cooler)       ; #587462 - Wet river slate (+, -, *, >>, &)
    (bracket red-faint)          ; #567060 - Damp wet twigs (( ) [ ] { })
    (delimiter fg-main)          ; #cfbcba - Same as base text (;, ,)
    (comment green-faint)        ; #6a7e70 - Quiet forest needles (italic)
    (docstring green-faint)      ; #6a7e70 - Documentation strings (italic)
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

;; Universal standard font-lock faces:
(custom-theme-set-faces
 'rainforest-night
 '(font-lock-comment-face ((t (:foreground "#6a7e70" :slant italic))))
 '(font-lock-comment-delimiter-face ((t (:foreground "#6a7e70" :slant italic))))
 '(font-lock-doc-face ((t (:foreground "#6a7e70" :slant italic))))
 '(font-lock-preprocessor-face ((t (:foreground "#7a5028"))))
 '(font-lock-keyword-face ((t (:foreground "#2c8446"))))
 '(font-lock-type-face ((t (:foreground "#54a648"))))
 '(font-lock-constant-face ((t (:foreground "#6e9a38"))))
 '(font-lock-number-face ((t (:foreground "#bfa03c"))))
 '(font-lock-builtin-face ((t (:foreground "#286cb8"))))
 '(font-lock-function-name-face ((t (:foreground "#1e72cc"))))
 '(font-lock-function-call-face ((t (:foreground "#3282dc"))))
 '(font-lock-string-face ((t (:foreground "#966919"))))
 '(font-lock-variable-name-face ((t (:foreground "#cfbcba"))))
 '(font-lock-variable-use-face ((t (:foreground "#cfbcba"))))
 '(font-lock-property-name-face ((t (:foreground "#a48e38"))))
 '(font-lock-property-use-face ((t (:foreground "#a48e38"))))
 '(font-lock-operator-face ((t (:foreground "#587462"))))
 '(font-lock-bracket-face ((t (:foreground "#567060"))))
 '(font-lock-delimiter-face ((t (:foreground "#cfbcba"))))
 '(font-lock-warning-face ((t (:foreground "#b43a34"))))
 '(region ((t (:background "#3f1324" :extend t))))
 '(line-number ((t (:foreground "#887c8a")))))

(provide 'rainforest-night-theme)
;;; rainforest-night-theme.el ends here
