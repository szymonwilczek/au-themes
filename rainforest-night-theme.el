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
    (red "#c04840")           ; Deep mountain yew berry crimson: alerts, errors, negation !
    (red-warmer "#c48420")    ; Glistening wet oak wood resin: strings ("strings")
    (red-cooler "#c04840")
    (red-faint "#54826e")     ; Wet spruce twigs: brackets ( ) [ ] { }

    (green "#5ecd38")         ; Deep wet soaked forest moss emerald: data types (int, size_t, uint32_t)
    (green-warmer "#86b432")  ; Wet forest lichen foliage: constants (LOTA_PCR_COUNT, NULL)
    (green-cooler "#2aa86c")  ; Deep wet conifer pine needle green: keywords (static, while, return, struct)
    (green-faint "#687c6e")   ; Quiet forest needles: comments

    (yellow "#2aa86c")        ; Keyword alias: deep wet conifer pine needle green
    (yellow-warmer "#d2a42e") ; Wet glowing amber resin: numbers (0, 24, 32 in buf[0])
    (yellow-cooler "#ab6426") ; Rain-soaked dark cedar bark brown: preprocessor (#define)
    (yellow-faint "#687c6e")  ; Quiet forest needles

    (blue "#2aa0e4")          ; Crystalline mountain torrent cascade: function definitions (is_write_open_flags)
    (blue-warmer "#4ea2dc")   ; Pure nocturnal rain water stream: function calls (bpf_map_lookup_elem, BPF_CORE_READ)
    (blue-cooler "#52a8b4")   ; Wet glistening river slate quartz: operators (?, &, :, +, -, *, ->)
    (blue-faint "#3284c8")    ; Deep mountain glacial lake blue: builtins (__always_inline, sizeof)

    (magenta "#86b432")       ; Forest olive foliage: constants (LOTA_PCR_COUNT, NULL)
    (magenta-warmer "#3284c8")
    (magenta-cooler "#3284c8") ; Mountain lake blue: builtins (__always_inline)
    (magenta-faint "#687c6e")

    (cyan "#2aa86c")          ; Deep wet conifer pine needle green (keywords)
    (cyan-warmer "#ab6426")   ; Rain-soaked dark cedar bark brown: preprocessor
    (cyan-cooler "#52a8b4")   ; Wet glistening river slate quartz
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
    (keyword cyan)               ; #2aa86c - Deep wet conifer pine needle green (static, struct, while, return)
    (builtin blue-faint)         ; #3284c8 - Deep mountain glacial lake blue (__always_inline, sizeof)
    (type green)                 ; #5ecd38 - Deep wet soaked forest moss emerald (int, void, size_t, uint32_t)
    (preprocessor yellow-cooler) ; #ab6426 - Rain-soaked dark cedar bark brown (#define, macro directives)
    (constant green-warmer)      ; #86b432 - Wet forest lichen foliage (LOTA_PCR_COUNT, NULL)
    (number yellow-warmer)       ; #d2a42e - Wet glowing amber resin (0, 24, 32 in buf[0])
    (fnname blue)                ; #2aa0e4 - Crystalline mountain torrent cascade (is_write_open_flags)
    (fnname-call blue-warmer)    ; #4ea2dc - Pure nocturnal rain water stream (bpf_map_lookup_elem, BPF_CORE_READ)
    (string red-warmer)          ; #c48420 - Glistening wet oak wood resin ("strings")
    (property fg-alt)            ; #a48e38 - Warm forest lichen (->tgid, .field)
    (variable fg-main)           ; #cfbcba - Base text (variables)
    (variable-use fg-main)       ; #cfbcba - Variable usages
    (operator blue-cooler)       ; #52a8b4 - Wet glistening river slate quartz (?, &, :, +, -, *, ->)
    (bracket red-faint)          ; #54826e - Wet spruce twigs (( ) [ ] { })
    (delimiter fg-main)          ; #cfbcba - Exact same as base text (;, ,)
    (comment green-faint)        ; #687c6e - Quiet forest needles (italic)
    (docstring green-faint)      ; #687c6e - Documentation strings (italic)
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
 '(font-lock-comment-face ((t (:foreground "#687c6e" :slant italic))))
 '(font-lock-comment-delimiter-face ((t (:foreground "#687c6e" :slant italic))))
 '(font-lock-doc-face ((t (:foreground "#687c6e" :slant italic))))
 '(font-lock-preprocessor-face ((t (:foreground "#ab6426"))))
 '(font-lock-keyword-face ((t (:foreground "#2aa86c"))))
 '(font-lock-type-face ((t (:foreground "#5ecd38"))))
 '(font-lock-constant-face ((t (:foreground "#86b432"))))
 '(font-lock-number-face ((t (:foreground "#d2a42e"))))
 '(font-lock-builtin-face ((t (:foreground "#3284c8"))))
 '(font-lock-function-name-face ((t (:foreground "#2aa0e4"))))
 '(font-lock-function-call-face ((t (:foreground "#4ea2dc"))))
 '(font-lock-string-face ((t (:foreground "#c48420"))))
 '(font-lock-variable-name-face ((t (:foreground "#cfbcba"))))
 '(font-lock-variable-use-face ((t (:foreground "#cfbcba"))))
 '(font-lock-property-name-face ((t (:foreground "#a48e38"))))
 '(font-lock-property-use-face ((t (:foreground "#a48e38"))))
 '(font-lock-operator-face ((t (:foreground "#52a8b4"))))
 '(font-lock-bracket-face ((t (:foreground "#54826e"))))
 '(font-lock-delimiter-face ((t (:foreground "#cfbcba"))))
 '(font-lock-warning-face ((t (:foreground "#d2a42e"))))
 '(region ((t (:background "#3f1324" :extend t))))
 '(line-number ((t (:foreground "#887c8a")))))

(provide 'rainforest-night-theme)
;;; rainforest-night-theme.el ends here
