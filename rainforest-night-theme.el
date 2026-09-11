;;; rainforest-night-theme.el --- Deep rainy forest shelter theme -*- lexical-binding:t -*-

(require 'ef-themes)

(defconst rainforest-night-palette-partial
  '(;; Canvas: deep nocturnal forest humus under steady midnight rain
    (cursor "#4e8ca8")        ; Night rain droplet glint
    (bg-main "#080b09")       ; Soaked midnight forest humus
    (bg-dim "#0f1310")        ; Damp bark shadow
    (bg-alt "#161a17")        ; Deep canopy shadow
    (fg-main "#96a89c")       ; Soft river quartz: calm, glare-free base text
    (fg-dim "#425246")        ; Dark damp needle mulch: quiet italic comments
    (fg-alt "#5c8882")        ; Damp river stone: struct fields and parameters

    (bg-active "#1c221e")
    (bg-inactive "#0c0f0d")
    (border "#141815")

    ;; 1:1 Keyface Determinism Palette (Forest layers hierarchy)
    (red "#9e3834")           ; Dark yew berry: alerts, negation !
    (red-warmer "#a8403a")
    (red-cooler "#943230")
    (red-faint "#4c5c50")     ; Wet twigs: brackets ( ) [ ] { }

    (green "#5c9648")         ; Rich forest moss: data types (int, size_t, uint32_t)
    (green-warmer "#649e4e")
    (green-cooler "#488c42")
    (green-faint "#3a6836")

    (yellow "#a46e38")        ; Wet oak wood / fallen leaves: strings ("strings")
    (yellow-warmer "#ba8432") ; Wet amber resin: numbers (0, 24, 32 in buf[0])
    (yellow-cooler "#966432")
    (yellow-faint "#7c542c")

    (blue "#30607e")          ; Deep mountain stream: function definitions (is_write_open_flags)
    (blue-warmer "#5088ae")   ; Nocturnal rain water: function calls (bpf_map_lookup_elem)
    (blue-cooler "#586c60")   ; Dark wet slate: operators (+, -, *, >>, &)
    (blue-faint "#264a62")

    (magenta "#7e528a")       ; Wet heather violet: constants and macros (LOTA_PCR_COUNT, NULL)
    (magenta-warmer "#8a5c96")
    (magenta-cooler "#8e5e48") ; Wet cedar wood bark: builtins and attributes (__always_inline, :keywords)
    (magenta-faint "#5e3e68")

    (cyan "#206c3a")          ; Deep conifer pine: keywords (struct, while, static, return)
    (cyan-warmer "#4aa47c")   ; Pine canopy / spruce crown: preprocessor directives (#define, #include)
    (cyan-cooler "#1a5e32")
    (cyan-faint "#4c5a50")    ; Damp pine needles: delimiters (, ;)

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

    (bg-mode-line-active "#101412")
    (fg-mode-line-active "#98a89c")
    (bg-completion "#0c100e")
    (bg-popup "#0a0e0c")
    (bg-hover "#141a16")
    (bg-hover-secondary "#1c141c")
    (bg-hl-line "#0d120f")
    (bg-paren-match "#122216")
    (bg-err "#1e0808")
    (bg-warning "#181004")
    (bg-info "#08140c")
    (bg-region "#121e14")))

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
    (preprocessor cyan-warmer)   ; #4aa47c - Pine canopy (#define, #include)
    (keyword cyan)               ; #206c3a - Deep conifer pine (struct, while, static, return)
    (type green)                 ; #5c9648 - Rich forest moss (int, size_t, uint32_t)
    (constant magenta)           ; #7e528a - Wet heather violet (LOTA_PCR_COUNT, NULL)
    (number yellow-warmer)       ; #ba8432 - Wet amber resin (0, 24, 32 in buf[0])
    (builtin magenta-cooler)     ; #8e5e48 - Wet cedar wood bark (__always_inline, :keywords)
    (fnname blue)                ; #30607e - Deep mountain stream (is_write_open_flags)
    (fnname-call blue-warmer)    ; #5088ae - Nocturnal rain water (bpf_map_lookup_elem)
    (string yellow)              ; #a46e38 - Wet oak wood ("strings")
    (property fg-alt)            ; #5c8882 - Damp river stone (->tgid, .field)
    (variable fg-main)           ; #96a89c - Soft river quartz (variables)
    (variable-use fg-main)       ; #96a89c - Variable usages
    (operator blue-cooler)       ; #586c60 - Dark wet slate (+, -, *, >>, &)
    (bracket red-faint)          ; #4c5c50 - Wet twigs (( ) [ ] { })
    (delimiter cyan-faint)       ; #4c5a50 - Damp needles (, ;)
    (comment fg-dim)             ; #425246 - Dark needle mulch (pure italic)
    (docstring fg-dim)           ; #425246 - Documentation strings
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
 '(font-lock-comment-face ((t (:foreground "#425246" :slant italic))))
 '(font-lock-comment-delimiter-face ((t (:foreground "#425246" :slant italic))))
 '(font-lock-doc-face ((t (:foreground "#425246" :slant italic))))
 '(font-lock-preprocessor-face ((t (:foreground "#4aa47c"))))
 '(font-lock-keyword-face ((t (:foreground "#206c3a"))))
 '(font-lock-type-face ((t (:foreground "#5c9648"))))
 '(font-lock-constant-face ((t (:foreground "#7e528a"))))
 '(font-lock-number-face ((t (:foreground "#ba8432"))))
 '(font-lock-builtin-face ((t (:foreground "#8e5e48"))))
 '(font-lock-function-name-face ((t (:foreground "#30607e"))))
 '(font-lock-function-call-face ((t (:foreground "#5088ae"))))
 '(font-lock-string-face ((t (:foreground "#a46e38"))))
 '(font-lock-property-name-face ((t (:foreground "#5c8882"))))
 '(font-lock-property-use-face ((t (:foreground "#5c8882"))))
 '(font-lock-operator-face ((t (:foreground "#586c60"))))
 '(font-lock-bracket-face ((t (:foreground "#4c5c50"))))
 '(font-lock-delimiter-face ((t (:foreground "#4c5a50"))))
 '(font-lock-warning-face ((t (:foreground "#9e3834")))))

(provide 'rainforest-night-theme)
;;; rainforest-night-theme.el ends here
