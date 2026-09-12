;;; au-rainforest-day-theme.el --- Misty temperate rainforest daylight theme for Au-themes -*- lexical-binding:t -*-

(require 'ef-themes)

(defconst au-rainforest-day-palette-partial
  '(;; Canvas: misty coniferous canopy day, soft lichen-granite mist under steady rain
    (cursor "#105476")        ; Clear mountain rain glint
    (bg-main "#b2beaf")       ; Overcast canopy air / wet lichen-slate stone (Y=0.4939)
    (bg-dim "#a6b4a4")        ; Damp bark shadow
    (bg-alt "#9eb09e")        ; Deep canopy daylight shadow
    (fg-main "#0e2016")       ; Deep conifer bark shadow: glare-free, ciliary-safe base text
    (fg-dim "#485a4c")        ; Misty lichen needles: quiet italic comments
    (fg-alt "#295540")        ; Birch jade / mountain lichen: struct fields and parameters
    (fg-var "#2c4a38")        ; Variable definitions

    (bg-active "#8ea28c")
    (bg-inactive "#a2b4a0")
    (border "#7a9078")

    ;; 1:1 Keyface Determinism Palette (Forest layers hierarchy)
    (red "#843428")           ; Dark yew berry: alerts, negation !
    (red-warmer "#551a0c")    ; Deep cedar clay: string literals ("strings")
    (red-cooler "#7c2e22")    ; Diff deletions
    (red-faint "#354437")     ; Wet twigs: brackets ( ) [ ] { }

    (green "#005d39")         ; Wet canopy moss: primitive types (int, size_t, uint32_t)
    (green-warmer "#79243e")  ; Wild heather / rosehip: constants and macros (LOTA_PCR_COUNT, NULL)
    (green-cooler "#4e3111")  ; Deep amber oak: control keywords (struct, while, static, return, if)
    (green-faint "#485a4c")   ; Documentation strings, inline comments

    (yellow "#4e3111")        ; Keyword alias
    (yellow-warmer "#555400") ; Golden amber honey: numeric literals (0, 24, 32 in buf[0])
    (yellow-cooler "#393000") ; Deep olive bronze wood: preprocessor directives (#define, #include)
    (yellow-faint "#4a4436")  ; Informational tooltips, fringe markers

    (blue "#2e3b50")          ; Boreal spruce lake: function definitions (is_write_open_flags)
    (blue-warmer "#225176")   ; Cold rain pool blue: function calls (bpf_map_lookup_elem, BPF_CORE_READ)
    (blue-cooler "#2c493e")   ; Wet slate needle: operators (+, -, *, >>, ==, &)
    (blue-faint "#004b44")    ; Pine creek viridian: built-in functions (sizeof, typeof, alignof)

    (magenta "#5a2e18")       ; Composite types fallback
    (magenta-warmer "#295540")
    (magenta-cooler "#502842")
    (magenta-faint "#485a4c")

    (cyan "#4e3111")          ; Keyword fallback
    (cyan-warmer "#393000")   ; Preprocessor alias
    (cyan-cooler "#2c493e")   ; Operator alias
    (cyan-faint "#3b463d")    ; Damp pine needles: punctuation delimiters (, ;)

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
    (fg-link-visited blue)
    (name blue)
    (keybind red)
    (identifier fg-alt)
    (fg-prompt blue)

    ;; 1:1 Keyface Determinism Mappings:
    (keyword green-cooler)
    (builtin blue-faint)
    (type green)
    (preprocessor yellow-cooler)
    (constant green-warmer)
    (number yellow-warmer)
    (fnname blue)
    (fnname-call blue-warmer)
    (string red-warmer)
    (property fg-alt)
    (variable fg-var)
    (variable-use fg-main)
    (operator blue-cooler)
    (bracket red-faint)
    (delimiter cyan-faint)
    (comment green-faint)
    (docstring green-faint)
    (rx-backslash yellow-cooler)
    (rx-construct red)

    (accent-0 blue)
    (accent-1 green)
    (accent-2 yellow)
    (accent-3 green-warmer)))

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
