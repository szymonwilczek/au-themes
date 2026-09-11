;;; rainforest-night-theme.el --- Deep rainy forest shelter theme -*- lexical-binding:t -*-

(require 'ef-themes)

(defconst rainforest-night-palette-partial
  '(;; Canvas: deep nocturnal forest humus under steady midnight rain
    (cursor "#4d93b3")        ; Night rain droplet glint
    (bg-main "#060706")       ; Deep nocturnal forest humus under midnight rain
    (bg-dim "#0a0c0a")        ; Damp bark shadow
    (bg-alt "#111412")        ; Deep canopy shadow
    (fg-main "#90a297")       ; Calm river quartz: glare-free, ciliary-safe base text
    (fg-dim "#48574c")        ; Dark damp needle mulch: quiet italic comments
    (fg-alt "#56938b")        ; Damp river stone: struct fields and parameters

    (bg-active "#141815")
    (bg-inactive "#080a09")
    (border "#101311")

    ;; 1:1 Keyface Determinism Palette (Forest layers hierarchy)
    (red "#b0423d")           ; Dark yew berry: alerts, negation !
    (red-warmer "#ba4b45")
    (red-cooler "#a43935")
    (red-faint "#4e6053")     ; Wet twigs: brackets ( ) [ ] { }

    (green "#639c4c")         ; Rich forest moss: data types (int, size_t, uint32_t)
    (green-warmer "#6ea454")
    (green-cooler "#569242")
    (green-faint "#426e38")

    (yellow "#b27536")        ; Wet oak wood / fallen leaves: strings ("strings")
    (yellow-warmer "#bc842f") ; Wet amber resin: numbers (0, 24, 32 in buf[0])
    (yellow-cooler "#9e6e30")
    (yellow-faint "#845a2a")

    (blue "#2e7092")          ; Deep mountain stream: function definitions (is_write_open_flags)
    (blue-warmer "#4f92be")   ; Nocturnal rain water: function calls (bpf_map_lookup_elem)
    (blue-cooler "#5b7264")   ; Dark wet slate: operators (+, -, *, >>, &)
    (blue-faint "#2a526d")

    (magenta "#745c18")       ; Ancient golden lichen: constants and macros (LOTA_PCR_COUNT, NULL)
    (magenta-warmer "#7e641e")
    (magenta-cooler "#a46344") ; Wet cedar wood bark: builtins and attributes (__always_inline, :keywords)
    (magenta-faint "#5c4610")

    (cyan "#2a7c40")          ; Deep conifer pine: keywords (struct, while, static, return)
    (cyan-warmer "#288c86")   ; Wet boreal spruce-lake: preprocessor directives (#define, #include, #endif)
    (cyan-cooler "#29733c")
    (cyan-faint "#4c5e52")    ; Damp pine needles: delimiters (, ;)

    ;; Diffs and panels
    (bg-added "#0a1c10")
    (bg-added-faint "#06120a")
    (bg-added-refine "#102816")
    (fg-added "#4ea85c")

    (bg-changed "#1c1606")
    (bg-changed-faint "#120e03")
    (bg-changed-refine "#261e08")
    (fg-changed "#b89a32")

    (bg-removed "#200a08")
    (bg-removed-faint "#140504")
    (bg-removed-refine "#2c0e0c")
    (fg-removed "#b44a42")

    (bg-mode-line-active "#0e110f")
    (fg-mode-line-active "#98a89c")
    (bg-completion "#0a0c0a")
    (bg-popup "#080a09")
    (bg-hover "#111412")
    (bg-hover-secondary "#141715")
    (bg-hl-line "#0e110f")
    (bg-paren-match "#101a12")
    (bg-err "#1e0808")
    (bg-warning "#181004")
    (bg-info "#08140c")
    (bg-region "#101812")))

(defconst rainforest-night-palette-mappings-partial
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
    (preprocessor cyan-warmer)   ; #288c86 - Wet boreal spruce-lake (#define, #include, #endif)
    (keyword cyan)               ; #2a7c40 - Deep conifer pine (struct, while, static, return)
    (type green)                 ; #639c4c - Rich forest moss (int, size_t, uint32_t)
    (constant magenta)           ; #745c18 - Ancient golden lichen (LOTA_PCR_COUNT, NULL)
    (number yellow-warmer)       ; #bc842f - Wet amber resin (0, 24, 32 in buf[0])
    (builtin magenta-cooler)     ; #a46344 - Wet cedar wood bark (__always_inline, :keywords)
    (fnname blue)                ; #2e7092 - Deep mountain stream (is_write_open_flags)
    (fnname-call blue-warmer)    ; #4f92be - Nocturnal rain water (bpf_map_lookup_elem)
    (string yellow)              ; #b27536 - Wet oak wood ("strings")
    (property fg-alt)            ; #56938b - Damp river stone (->tgid, .field)
    (variable fg-main)           ; #90a297 - Soft river quartz (variables)
    (variable-use fg-main)       ; #90a297 - Variable usages
    (operator blue-cooler)       ; #5b7264 - Dark wet slate (+, -, *, >>, &)
    (bracket red-faint)          ; #4e6053 - Wet twigs (( ) [ ] { })
    (delimiter cyan-faint)       ; #4c5e52 - Damp needles (, ;)
    (comment fg-dim)             ; #48574c - Dark needle mulch (pure italic)
    (docstring fg-dim)           ; #48574c - Documentation strings
    (rx-backslash yellow-cooler)
    (rx-construct red)

    (accent-0 blue)
    (accent-1 yellow)
    (accent-2 green)
    (accent-3 cyan)))

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
 "Deep nocturnal rainy forest theme with organic forest layers and 1:1 keyface determinism."
 'dark
 'rainforest-night-palette
 nil
 nil)

;; Universal standard font-lock faces:
(custom-theme-set-faces
 'rainforest-night
 '(font-lock-comment-face ((t (:foreground "#48574c" :slant italic))))
 '(font-lock-comment-delimiter-face ((t (:foreground "#48574c" :slant italic))))
 '(font-lock-doc-face ((t (:foreground "#48574c" :slant italic))))
 '(font-lock-preprocessor-face ((t (:foreground "#288c86"))))
 '(font-lock-keyword-face ((t (:foreground "#2a7c40"))))
 '(font-lock-type-face ((t (:foreground "#639c4c"))))
 '(font-lock-constant-face ((t (:foreground "#745c18"))))
 '(font-lock-number-face ((t (:foreground "#bc842f"))))
 '(font-lock-builtin-face ((t (:foreground "#a46344"))))
 '(font-lock-function-name-face ((t (:foreground "#2e7092"))))
 '(font-lock-function-call-face ((t (:foreground "#4f92be"))))
 '(font-lock-string-face ((t (:foreground "#b27536"))))
 '(font-lock-property-name-face ((t (:foreground "#56938b"))))
 '(font-lock-property-use-face ((t (:foreground "#56938b"))))
 '(font-lock-operator-face ((t (:foreground "#5b7264"))))
 '(font-lock-bracket-face ((t (:foreground "#4e6053"))))
 '(font-lock-delimiter-face ((t (:foreground "#4c5e52"))))
 '(font-lock-warning-face ((t (:foreground "#b0423d")))))

(provide 'rainforest-night-theme)
;;; rainforest-night-theme.el ends here
