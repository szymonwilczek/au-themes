;;; au-rainforest-day-theme.el --- Misty temperate rainforest daylight theme for Au-themes -*- lexical-binding:t -*-

(require 'ef-themes)

(defconst au-rainforest-day-palette-partial
  '(;; Canvas: misty coniferous canopy day, soft lichen-granite mist under steady rain
    (cursor "#105476")        ; Clear mountain rain glint
    (bg-main "#b2beaf")       ; Overcast canopy air / wet lichen-slate stone (Y=0.4939)
    (bg-dim "#a6b4a4")        ; Damp bark shadow
    (bg-alt "#9eb09e")        ; Deep canopy daylight shadow
    (fg-main "#122216")       ; Deep conifer bark shadow: glare-free, ciliary-safe base text
    (fg-dim "#485a4c")        ; Misty lichen needles: quiet italic comments
    (fg-alt "#1c443c")        ; Damp river stone: struct fields and parameters

    (bg-active "#8ea28c")
    (bg-inactive "#a2b4a0")
    (border "#7a9078")

    ;; 1:1 Keyface Determinism Palette (Forest layers hierarchy)
    (red "#843428")           ; Dark yew berry: alerts, negation !
    (red-warmer "#923c30")
    (red-cooler "#7c2e22")
    (red-faint "#344238")     ; Wet twigs: brackets ( ) [ ] { }

    (green "#6c3e00")         ; Deep amber resin: data types (int, size_t, uint32_t)
    (green-warmer "#764402")
    (green-cooler "#623800")
    (green-faint "#4c2806")

    (yellow "#4c2806")        ; Dark oak wood / fallen leaves: strings ("strings")
    (yellow-warmer "#084c68") ; Deep lake cyan: numbers (0, 24, 32 in buf[0])
    (yellow-cooler "#442404")
    (yellow-faint "#3a2004")

    (blue "#065842")          ; Boreal spruce lake: function definitions (is_write_open_flags)
    (blue-warmer "#124a76")   ; Cold rain pool blue: function calls (bpf_map_lookup_elem, BPF_CORE_READ)
    (blue-cooler "#2a3e30")   ; Dark wet slate: operators (+, -, *, >>, ==, &)
    (blue-faint "#183a48")

    (magenta "#541a58")       ; Deep heather plum: constants and macros (LOTA_PCR_COUNT, SI_KERNEL, NULL)
    (magenta-warmer "#5e1e62")
    (magenta-cooler "#5a240e") ; Deep cedar wood bark: builtins (sizeof, typeof, alignof, __always_inline)
    (magenta-faint "#421446")

    (cyan "#0a5022")          ; Deep pine green: keywords (struct, while, static, return, if)
    (cyan-warmer "#27346d")   ; Deep river slate: preprocessor directives (#define, #include, #endif)
    (cyan-cooler "#08461e")
    (cyan-faint "#2a3a30")    ; Damp pine needles: delimiters (, ;)

    ;; Diffs and panels
    (bg-added "#a2c8a8")
    (bg-added-faint "#b2d4b8")
    (bg-added-refine "#90bc96")
    (fg-added "#083e16")

    (bg-changed "#d0c48e")
    (bg-changed-faint "#dcd29e")
    (bg-changed-refine "#c4b67e")
    (fg-changed "#4a3a02")

    (bg-removed "#ccaeb2")
    (bg-removed-faint "#d8bec2")
    (bg-removed-refine "#bea0a4")
    (fg-removed "#641818")

    (bg-mode-line-active "#8ea490")
    (fg-mode-line-active "#102014")
    (bg-completion "#a0b4a2")
    (bg-popup "#b4c6b6")
    (bg-hover "#9ab09c")
    (bg-hover-secondary "#90a692")
    (bg-hl-line "#a2af9f")
    (bg-paren-match "#8aa890")
    (bg-err "#c8a8a4")
    (bg-warning "#c8c098")
    (bg-info "#98c2a2")
    (bg-region "#a0b8a4")))

(defconst au-rainforest-day-palette-mappings-partial
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
    (preprocessor cyan-warmer)   ; #27346d - Deep river slate (#define, #include, #endif)
    (keyword cyan)               ; #0a5022 - Deep pine green (struct, while, static, return, if)
    (type green)                 ; #6c3e00 - Deep amber resin (int, size_t, uint32_t)
    (constant magenta)           ; #541a58 - Deep heather plum (LOTA_PCR_COUNT, SI_KERNEL, NULL)
    (number yellow-warmer)       ; #084c68 - Deep lake cyan (0, 24, 32 in buf[0])
    (builtin magenta-cooler)     ; #5a240e - Deep cedar wood bark (sizeof, typeof, alignof, __always_inline)
    (fnname blue)                ; #065842 - Boreal spruce lake (is_write_open_flags)
    (fnname-call blue-warmer)    ; #124a76 - Cold rain pool blue (bpf_map_lookup_elem, BPF_CORE_READ)
    (string yellow)              ; #4c2806 - Dark oak wood ("strings")
    (property fg-alt)            ; #1c443c - Damp river stone (->tgid, .field)
    (variable fg-main)           ; #122216 - Deep conifer bark shadow (variables)
    (variable-use fg-main)       ; #122216 - Variable usages
    (operator blue-cooler)       ; #2a3e30 - Dark wet slate (+, -, *, >>, ==, &)
    (bracket red-faint)          ; #344238 - Wet twigs (( ) [ ] { })
    (delimiter cyan-faint)       ; #2a3a30 - Damp needles (, ;)
    (comment fg-dim)             ; #485a4c - Misty lichen needles (pure italic)
    (docstring fg-dim)           ; #485a4c - Documentation strings
    (rx-backslash yellow-cooler)
    (rx-construct red)

    (accent-0 blue)
    (accent-1 yellow)
    (accent-2 green)
    (accent-3 cyan)))

(defconst au-rainforest-day-palette
  (modus-themes-generate-palette
   au-rainforest-day-palette-partial
   nil
   nil
   (append au-rainforest-day-palette-mappings-partial ef-themes-palette-common)))

;;;###theme-autoload
(modus-themes-theme
 'au-rainforest-day
 'ef-themes
 "Au Rainforest Day: misty temperate rainforest daylight theme with organic forest layers."
 'light
 'au-rainforest-day-palette
 nil
 nil)

;; Backward-compatibility aliases
(defvaralias 'rainforest-day-palette 'au-rainforest-day-palette)
(defvaralias 'rainforest-day-palette-partial 'au-rainforest-day-palette-partial)

(provide 'au-rainforest-day-theme)
(provide 'rainforest-day-theme)
;;; au-rainforest-day-theme.el ends here
