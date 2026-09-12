;;; rainforest-night-theme.el --- Deep rainy forest shelter theme -*- lexical-binding:t -*-

(require 'ef-themes)

(defconst rainforest-night-palette-partial
  '(;; Canvas & Surfaces
    (cursor "#ffaa33")
    (bg-main "#0f0e06")
    (bg-dim "#26211d")
    (bg-alt "#36322f")
    (fg-main "#cfbcba")
    (fg-dim "#887c8a")
    (fg-alt "#baa03c")        ; Luminous golden lichen
    (bg-active "#56524f")
    (bg-inactive "#25241d")
    (border "#58514f")

    ;; Syntactic Forest Layers (Adjacency-Dispersed, Brighter Rain Palette)
    (red "#d84c44")           ; Dark yew berry crimson: alerts, errors, negation !
    (red-warmer "#e0743a")    ; Rowan amber coral: strings ("strings")
    (red-cooler "#d84c44")
    (red-faint "#688674")     ; Damp wet twigs: brackets ( ) [ ] { }

    (green "#54ba48")         ; Wet rain moss emerald: data types (int, size_t, uint32_t)
    (green-warmer "#baa03c")  ; Luminous golden lichen: struct fields and properties (->tgid)
    (green-cooler "#56c49e")  ; Luminous rain jade: numbers (0, 24, 32 in buf[0])
    (green-faint "#607c6c")   ; Damp pine needles: delimiters (, ;)

    (yellow "#cf982c")        ; Golden canopy cedar: keywords (static, while, return, struct)
    (yellow-warmer "#baa03c")
    (yellow-cooler "#b45e28") ; Wet chestnut elm bark: preprocessor (#define, macro directives)
    (yellow-faint "#cf9f7f")  ; Quiet rainy canopy comments

    (blue "#36a2dc")          ; Deep mountain torrent: function definitions (is_write_open_flags)
    (blue-warmer "#56ace8")   ; Rain water pool blue: function calls (bpf_map_lookup_elem, BPF_CORE_READ)
    (blue-cooler "#789886")   ; Wet river slate: operators (+, -, *, >>, &)
    (blue-faint "#6a84af")

    (magenta "#a47ec8")       ; Rain forest bellflower amethyst: constants and macros (LOTA_PCR_COUNT, NULL)
    (magenta-warmer "#e580ea")
    (magenta-cooler "#22bca6") ; Cold spruce viridian: builtins and attributes (__always_inline)
    (magenta-faint "#c590af")

    (cyan "#36a2dc")
    (cyan-warmer "#56ace8")
    (cyan-cooler "#22bca6")
    (cyan-faint "#82a0af")

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
    (fg-link-visited magenta)
    (name blue)
    (keybind red-warmer)
    (identifier fg-alt)
    (fg-prompt blue)

    ;; 1:1 Keyface Determinism Mappings (Adjacency-Dispersed):
    (keyword yellow)             ; #cf982c - Golden canopy cedar (static, struct, while, return)
    (builtin magenta-cooler)     ; #22bca6 - Cold spruce viridian (__always_inline, bpf_map_lookup_elem)
    (type green)                 ; #54ba48 - Wet rain moss emerald (int, size_t, uint32_t)
    (preprocessor yellow-cooler) ; #b45e28 - Wet chestnut elm bark (__uint, BPF_CORE_READ, #define)
    (constant magenta)           ; #a47ec8 - Rain forest bellflower amethyst (LOTA_PCR_COUNT, NULL)
    (number green-cooler)        ; #56c49e - Luminous rain jade (0, 24, 32 in buf[0])
    (fnname blue)                ; #36a2dc - Deep mountain torrent (is_write_open_flags)
    (fnname-call blue-warmer)    ; #56ace8 - Rain water pool blue (bpf_map_lookup_elem, BPF_CORE_READ)
    (string red-warmer)          ; #e0743a - Rowan amber coral ("strings")
    (property fg-alt)            ; #baa03c - Luminous golden lichen (->tgid, .field)
    (variable fg-main)           ; #cfbcba - Base text (variables)
    (variable-use fg-main)       ; #cfbcba - Variable usages
    (operator blue-cooler)       ; #789886 - Wet river slate (+, -, *, >>, &)
    (bracket red-faint)          ; #688674 - Damp wet twigs (( ) [ ] { })
    (delimiter green-faint)      ; #607c6c - Damp pine needles (, ;)
    (comment yellow-faint)       ; #cf9f7f - Quiet rainy canopy comments
    (docstring green-faint)      ; #5f9f6f - Documentation strings
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
 "Deep nocturnal rainy forest theme - luminous rain canopy with statistical adjacency dispersion."
 'dark
 'rainforest-night-palette
 nil
 nil)

;; Universal standard font-lock faces:
(custom-theme-set-faces
 'rainforest-night
 '(font-lock-comment-face ((t (:foreground "#cf9f7f" :slant italic))))
 '(font-lock-comment-delimiter-face ((t (:foreground "#cf9f7f" :slant italic))))
 '(font-lock-doc-face ((t (:foreground "#5f9f6f" :slant italic))))
 '(font-lock-preprocessor-face ((t (:foreground "#b45e28"))))
 '(font-lock-keyword-face ((t (:foreground "#cf982c"))))
 '(font-lock-type-face ((t (:foreground "#54ba48"))))
 '(font-lock-constant-face ((t (:foreground "#a47ec8"))))
 '(font-lock-number-face ((t (:foreground "#56c49e"))))
 '(font-lock-builtin-face ((t (:foreground "#22bca6"))))
 '(font-lock-function-name-face ((t (:foreground "#36a2dc"))))
 '(font-lock-function-call-face ((t (:foreground "#56ace8"))))
 '(font-lock-string-face ((t (:foreground "#e0743a"))))
 '(font-lock-variable-name-face ((t (:foreground "#cfbcba"))))
 '(font-lock-variable-use-face ((t (:foreground "#cfbcba"))))
 '(font-lock-property-name-face ((t (:foreground "#baa03c"))))
 '(font-lock-property-use-face ((t (:foreground "#baa03c"))))
 '(font-lock-operator-face ((t (:foreground "#789886"))))
 '(font-lock-bracket-face ((t (:foreground "#688674"))))
 '(font-lock-delimiter-face ((t (:foreground "#607c6c"))))
 '(font-lock-warning-face ((t (:foreground "#d84c44"))))
 '(region ((t (:background "#3f1324" :extend t))))
 '(line-number ((t (:foreground "#887c8a")))))

(provide 'rainforest-night-theme)
;;; rainforest-night-theme.el ends here
