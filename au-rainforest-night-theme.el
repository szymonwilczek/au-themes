;;; au-rainforest-night-theme.el --- Deep nocturnal rainy forest theme for Au-themes -*- lexical-binding:t -*-

(require 'ef-themes)

(defconst au-rainforest-night-palette-partial
  '(;; Canvas & Chrome (Deep ef-autumn nocturnal forest baseline)
    (cursor "#4e92a8")        ; Mineral steel-rain blue: soothing raindrop glint in the wet forest
    (bg-main "#0f0e06")
    (bg-dim "#26211d")
    (bg-alt "#36322f")
    (fg-main "#9ca69e")       ; Tranquil silver-mist quartz
    (fg-dim "#58685a")        ; Damp quiet pine needles
    (fg-alt "#a08c4a")        ; Warm forest lichen
    (fg-var "#a2ada4")        ; Birch mist quartz: variable definitions
    (bg-active "#56524f")
    (bg-inactive "#25241d")
    (border "#58514f")

    ;; Deep Temperate Rainforest Palette (Terrestrial Greens, Cedar Bark, Mountain Waters)
    (red "#b6463e")           ; Mountain yew crimson: alerts, errors, negation !
    (red-warmer "#b26236")    ; Warm cedar resin amber: strings ("strings")
    (red-cooler "#b6463e")
    (red-faint "#6c806e")     ; Damp wet spruce twigs: brackets ( ) [ ] { }

    (green "#7aa854")         ; Wet canopy moss: data types (int, size_t, uint32_t)
    (green-warmer "#869c44")  ; Sunlit forest olive foliage: constants (LOTA_PCR_COUNT, NULL)
    (green-cooler "#388844")  ; Wet terrestrial fir needle green: keywords (static, while, return, struct)
    (green-faint "#58685a")   ; Quiet pine needles in mist: comments

    (yellow "#388844")        ; Keyword alias: wet terrestrial fir needle green
    (yellow-warmer "#caa240") ; Warm golden forest honey: numbers (0, 24, 32 in buf[0])
    (yellow-cooler "#8c5020") ; Weathered cedar tree bark brown: preprocessor (#define)
    (yellow-faint "#58685a")  ; Quiet pine needles in mist

    (blue "#3e84be")          ; Mountain river stream water: function definitions (is_write_open_flags)
    (blue-warmer "#66a4d2")   ; Nocturnal rain cascade: function calls (bpf_map_lookup_elem, BPF_CORE_READ)
    (blue-cooler "#6e867c")   ; Neutral river slate quartz: operators (?, &, :, +, -, *, ->)
    (blue-faint "#60a28c")    ; Soft mountain sage / tree lichen: builtins (__always_inline, sizeof)

    (magenta "#869c44")       ; Forest olive foliage: constants (LOTA_PCR_COUNT, NULL)
    (magenta-warmer "#60a28c")
    (magenta-cooler "#60a28c") ; Soft mountain sage: builtins (__always_inline)
    (magenta-faint "#58685a")

    (cyan "#388844")          ; Wet terrestrial fir needle green (keywords)
    (cyan-warmer "#8c5020")   ; Weathered cedar tree bark brown: preprocessor
    (cyan-cooler "#6e867c")   ; Neutral river slate quartz
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
    (bg-hl-line "#18201a")
    (bg-paren-match "#2f6c4a")
    (bg-err "#461204")
    (bg-warning "#353504")
    (bg-info "#1f3b0a")
    (bg-region "#3f1324")
    (fg-line-number-inactive "#887c8a")))

(defconst au-rainforest-night-palette-mappings-partial
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
    (keyword cyan)
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
    (accent-2 yellow-warmer)
    (accent-3 green-warmer)))

(defconst au-rainforest-night-palette
  (modus-themes-generate-palette
   au-rainforest-night-palette-partial
   nil
   nil
   (append au-rainforest-night-palette-mappings-partial ef-themes-palette-common)))

;;;###theme-autoload
(modus-themes-theme
 'au-rainforest-night
 'ef-themes
 "Au Rainforest Night: deep nocturnal rainy forest theme calibrated for autistic sensory-profile and photophobia."
 'dark
 'au-rainforest-night-palette
 nil
 nil)

(defvaralias 'rainforest-night-palette 'au-rainforest-night-palette)
(defvaralias 'rainforest-night-palette-partial 'au-rainforest-night-palette-partial)

(provide 'au-rainforest-night-theme)
(provide 'rainforest-night-theme)
;;; au-rainforest-night-theme.el ends here
