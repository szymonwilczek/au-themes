;;; rainforest-night-theme.el --- Deep rainy forest shelter theme -*- lexical-binding:t -*-

(require 'ef-themes)

(defconst rainforest-night-palette-partial
  '((cursor "#ffaa33")
    (bg-main "#0f0e06")
    (bg-dim "#26211d")
    (bg-alt "#36322f")
    (fg-main "#cfbcba")
    (fg-dim "#887c8a")
    (fg-alt "#a0924a")        ; Warm golden lichen: struct fields and parameters
    (bg-active "#56524f")
    (bg-inactive "#25241d")
    (border "#58514f")

    (red "#be4a44")           ; Dark yew berry: alerts, negation !
    (red-warmer "#c8524c")
    (red-cooler "#b4423c")
    (red-faint "#607868")     ; Wet twigs: brackets ( ) [ ] { }

    (green "#5ea050")         ; Deep wet forest moss: data types (int, size_t, uint32_t)
    (green-warmer "#7ab65e")
    (green-cooler "#5e9846")
    (green-faint "#4a6250")

    (yellow "#966919")        ; Warm golden oak resin: strings ("strings")
    (yellow-warmer "#bfa03c") ; Wet amber resin: numbers (0, 24, 32 in buf[0])
    (yellow-cooler "#aa7234")
    (yellow-faint "#cf9f7f")  ; ef-autumn comment yellow-faint

    (blue "#327c9e")          ; Deep mountain stream: function definitions (is_write_open_flags)
    (blue-warmer "#469cd8")   ; Cold rain water pool: function calls (bpf_map_lookup_elem, BPF_CORE_READ)
    (blue-cooler "#6c8676")   ; Dark wet slate: operators (+, -, *, >>, &)
    (blue-faint "#2c5672")

    (magenta "#8c72b4")       ; Deep mountain bellflower: constants and macros (LOTA_PCR_COUNT, NULL)
    (magenta-warmer "#8cd0e4")
    (magenta-cooler "#1e9c92") ; Cold forest viridian: builtins and attributes (__always_inline, bpf_map_lookup_elem)
    (magenta-faint "#64aebb")

    (cyan "#c48702")          ; ef-autumn golden yellow: keywords (static, struct, while, return)
    (cyan-warmer "#9c5424")   ; Deep wet chestnut elm bark: preprocessor and macro directives (__uint, #define)
    (cyan-cooler "#2a8044")
    (cyan-faint "#5a7062")    ; Damp pine needles: delimiters (, ;)

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

    ;; 1:1 Keyface Determinism Mappings:
    (preprocessor cyan-warmer)   ; #9c5424 - Deep wet chestnut elm bark (__uint, BPF_CORE_READ, #define)
    (keyword cyan)               ; #c48702 - ef-autumn golden yellow (static, struct, while, return)
    (type green)                 ; #5ea050 - Deep wet forest moss (int, size_t, uint32_t)
    (constant magenta)           ; #8c72b4 - Deep mountain bellflower (LOTA_PCR_COUNT, NULL)
    (number yellow-warmer)       ; #bfa03c - Wet amber resin (0, 24, 32 in buf[0])
    (builtin magenta-cooler)     ; #1e9c92 - Cold forest viridian (__always_inline, bpf_map_lookup_elem)
    (fnname blue)                ; #327c9e - Deep mountain stream (is_write_open_flags)
    (fnname-call blue-warmer)    ; #469cd8 - Cold rain water pool (bpf_map_lookup_elem, BPF_CORE_READ)
    (string yellow)              ; #966919 - Warm golden oak resin ("strings")
    (property fg-alt)            ; #a0924a - Warm golden lichen (->tgid, .field)
    (variable fg-main)           ; #cfbcba - Base text (variables)
    (variable-use fg-main)       ; #cfbcba - Variable usages
    (operator blue-cooler)       ; #6c8676 - Dark wet slate (+, -, *, >>, &)
    (bracket red-faint)          ; #607868 - Wet twigs (( ) [ ] { })
    (delimiter cyan-faint)       ; #5a7062 - Damp needles (, ;)
    (comment yellow-faint)       ; #cf9f7f - ef-autumn quiet comment
    (docstring green-faint)      ; #5f9f6f - ef-autumn docstring
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
 "Deep nocturnal rainy forest theme - ef-autumn baseline with calibrated syntax determinism."
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
 '(font-lock-preprocessor-face ((t (:foreground "#9c5424"))))
 '(font-lock-keyword-face ((t (:foreground "#c48702"))))
 '(font-lock-type-face ((t (:foreground "#5ea050"))))
 '(font-lock-constant-face ((t (:foreground "#8c72b4"))))
 '(font-lock-number-face ((t (:foreground "#bfa03c"))))
 '(font-lock-builtin-face ((t (:foreground "#1e9c92"))))
 '(font-lock-function-name-face ((t (:foreground "#327c9e"))))
 '(font-lock-function-call-face ((t (:foreground "#469cd8"))))
 '(font-lock-string-face ((t (:foreground "#966919"))))
 '(font-lock-variable-name-face ((t (:foreground "#cfbcba"))))
 '(font-lock-variable-use-face ((t (:foreground "#cfbcba"))))
 '(font-lock-property-name-face ((t (:foreground "#a0924a"))))
 '(font-lock-property-use-face ((t (:foreground "#a0924a"))))
 '(font-lock-operator-face ((t (:foreground "#6c8676"))))
 '(font-lock-bracket-face ((t (:foreground "#607868"))))
 '(font-lock-delimiter-face ((t (:foreground "#5a7062"))))
 '(font-lock-warning-face ((t (:foreground "#be4a44"))))
 '(region ((t (:background "#3f1324" :extend t))))
 '(line-number ((t (:foreground "#887c8a")))))

(provide 'rainforest-night-theme)
;;; rainforest-night-theme.el ends here
