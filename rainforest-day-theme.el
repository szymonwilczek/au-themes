;;; rainforest-day-theme.el --- Misty temperate rainforest daylight theme -*- lexical-binding:t -*-

(require 'ef-themes)

(defconst rainforest-day-palette-partial
  '(;; Canvas: misty coniferous canopy day, soft lichen-granite mist
    (cursor "#1c6488")        ; Clear mountain rain glint
    (bg-main "#cbd5c5")       ; Misty canopy air / lichen-tinted wet stone
    (bg-dim "#c0ccbc")        ; Damp bark shadow
    (bg-alt "#b6c4b2")        ; Deep canopy daylight shadow
    (fg-main "#223226")       ; Soft conifer bark shadow: glare-free, ciliary-safe base text
    (fg-dim "#5a6f62")        ; Misty lichen mulch: quiet italic comments
    (fg-alt "#22564e")        ; Damp river stone: struct fields and parameters

    (bg-active "#9eb09a")
    (bg-inactive "#b5c4b2")
    (border "#8a9e86")

    ;; 1:1 Keyface Determinism Palette (Forest layers hierarchy)
    (red "#8a3024")           ; Dark yew berry: alerts, negation !
    (red-warmer "#96382a")
    (red-cooler "#842820")
    (red-faint "#4c554e")     ; Wet twigs: brackets ( ) [ ] { }

    (green "#487434")         ; Rich forest moss: data types (int, size_t, uint32_t)
    (green-warmer "#527c3a")
    (green-cooler "#3e6e2e")
    (green-faint "#3b5632")

    (yellow "#764612")        ; Wet oak wood / fallen leaves: strings ("strings")
    (yellow-warmer "#7c4806") ; Wet amber resin: numbers (0, 24, 32 in buf[0])
    (yellow-cooler "#6e4210")
    (yellow-faint "#5a452a")

    (blue "#145472")          ; Deep mountain stream: function definitions (is_write_open_flags)
    (blue-warmer "#266ea0")   ; Cold rain pool water: function calls (bpf_map_lookup_elem)
    (blue-cooler "#425648")   ; Dark wet slate: operators (+, -, *, >>, &)
    (blue-faint "#2a4c5e")

    (magenta "#763a7c")       ; Wet heather violet: constants and macros (LOTA_PCR_COUNT, NULL)
    (magenta-warmer "#824288")
    (magenta-cooler "#703e20") ; Wet cedar wood bark: builtins and attributes (__always_inline, :keywords)
    (magenta-faint "#583c5e")

    (cyan "#105e30")          ; Deep conifer pine: keywords (struct, while, static, return)
    (cyan-warmer "#106c64")   ; Deep boreal spruce-lake: preprocessor directives (#define, #include, #endif)
    (cyan-cooler "#14582c")
    (cyan-faint "#425447")    ; Damp pine needles: delimiters (, ;)

    ;; Diffs and panels
    (bg-added "#b2d4b8")
    (bg-added-faint "#c2dec6")
    (bg-added-refine "#a0c8a6")
    (fg-added "#124e1e")

    (bg-changed "#dcd29a")
    (bg-changed-faint "#e6deae")
    (bg-changed-refine "#cfc482")
    (fg-changed "#564402")

    (bg-removed "#dcbeb6")
    (bg-removed-faint "#e8cec6")
    (bg-removed-refine "#cfaaa0")
    (fg-removed "#74221a")

    (bg-mode-line-active "#9cb29e")
    (fg-mode-line-active "#1c3222")
    (bg-completion "#b0c4b2")
    (bg-popup "#c2d0c0")
    (bg-hover "#acc0ae")
    (bg-hover-secondary "#a2b8a4")
    (bg-hl-line "#c0cbba")
    (bg-paren-match "#9ab69e")
    (bg-err "#dab8b0")
    (bg-warning "#dad2a4")
    (bg-info "#a8d0b2")
    (bg-region "#b2c8b4")))

(defconst rainforest-day-palette-mappings-partial
  '(;; Statuses
    (err red)
    (warning yellow-warmer)
    (info green)

    (fg-link blue-warmer)
    (fg-link-visited magenta)
    (name blue)
    (keybind red-warmer)
    (identifier fg-alt)
    (fg-prompt blue)

    ;; 1:1 Keyface Determinism Mappings:
    (preprocessor cyan-warmer)   ; #106c64 - Deep boreal spruce-lake (#define, #include, #endif)
    (keyword cyan)               ; #105e30 - Deep conifer pine (struct, while, static, return)
    (type green)                 ; #487434 - Rich forest moss (int, size_t, uint32_t)
    (constant magenta)           ; #763a7c - Wet heather violet (LOTA_PCR_COUNT, NULL)
    (number yellow-warmer)       ; #7c4806 - Wet amber resin (0, 24, 32 in buf[0])
    (builtin magenta-cooler)     ; #703e20 - Wet cedar wood bark (__always_inline, :keywords)
    (fnname blue)                ; #145472 - Deep mountain stream (is_write_open_flags)
    (fnname-call blue-warmer)    ; #266ea0 - Cold rain pool water (bpf_map_lookup_elem)
    (string yellow)              ; #764612 - Wet oak wood ("strings")
    (property fg-alt)            ; #22564e - Damp river stone (->tgid, .field)
    (variable fg-main)           ; #223226 - Soft conifer bark shadow (variables)
    (variable-use fg-main)       ; #223226 - Variable usages
    (operator blue-cooler)       ; #425648 - Dark wet slate (+, -, *, >>, &)
    (bracket red-faint)          ; #4c554e - Wet twigs (( ) [ ] { })
    (delimiter cyan-faint)       ; #425447 - Damp needles (, ;)
    (comment fg-dim)             ; #5a6f62 - Misty lichen mulch (pure italic)
    (docstring fg-dim)           ; #5a6f62 - Documentation strings
    (rx-backslash yellow-cooler)
    (rx-construct red)

    (accent-0 blue)
    (accent-1 yellow)
    (accent-2 green)
    (accent-3 cyan)))

(defconst rainforest-day-palette
  (modus-themes-generate-palette
   rainforest-day-palette-partial
   nil
   nil
   (append rainforest-day-palette-mappings-partial ef-themes-palette-common)))

;;;###theme-autoload
(modus-themes-theme
 'rainforest-day
 'ef-themes
 "Misty temperate rainforest daylight theme with organic forest layers and 1:1 keyface determinism."
 'light
 'rainforest-day-palette
 nil
 nil)

;; Universal standard font-lock faces:
(custom-theme-set-faces
 'rainforest-day
 '(font-lock-comment-face ((t (:foreground "#5a6f62" :slant italic))))
 '(font-lock-comment-delimiter-face ((t (:foreground "#5a6f62" :slant italic))))
 '(font-lock-doc-face ((t (:foreground "#5a6f62" :slant italic))))
 '(font-lock-preprocessor-face ((t (:foreground "#106c64"))))
 '(font-lock-keyword-face ((t (:foreground "#105e30"))))
 '(font-lock-type-face ((t (:foreground "#487434"))))
 '(font-lock-constant-face ((t (:foreground "#763a7c"))))
 '(font-lock-number-face ((t (:foreground "#7c4806"))))
 '(font-lock-builtin-face ((t (:foreground "#703e20"))))
 '(font-lock-function-name-face ((t (:foreground "#145472"))))
 '(font-lock-function-call-face ((t (:foreground "#266ea0"))))
 '(font-lock-string-face ((t (:foreground "#764612"))))
 '(font-lock-property-name-face ((t (:foreground "#22564e"))))
 '(font-lock-property-use-face ((t (:foreground "#22564e"))))
 '(font-lock-operator-face ((t (:foreground "#425648"))))
 '(font-lock-bracket-face ((t (:foreground "#4c554e"))))
 '(font-lock-delimiter-face ((t (:foreground "#425447"))))
 '(font-lock-warning-face ((t (:foreground "#8a3024")))))

(provide 'rainforest-day-theme)
;;; rainforest-day-theme.el ends here
