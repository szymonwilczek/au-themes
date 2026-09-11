;;; rainforest-night-theme.el --- Deep rainy forest shelter theme -*- lexical-binding:t -*-

(require 'ef-themes)

(defconst rainforest-night-palette-partial
  '(;; Canvas: deep nocturnal forest humus under steady midnight rain
    (cursor "#56a0c4")        ; Mountain rain glint cursor
    (bg-main "#0c0b08")       ; Deep nocturnal peat charcoal: warm brownish-black tone
    (bg-dim "#080705")        ; Damp bark shadow
    (bg-alt "#11100d")        ; Deep canopy shadow
    (fg-main "#9c9a96")       ; Soft river slate: calm, glare-free, ciliary-safe base text
    (fg-dim "#526456")        ; Dark damp needle mulch: quiet italic comments
    (fg-alt "#5e9f96")        ; Damp river stone: struct fields and parameters

    (bg-active "#1a1815")
    (bg-inactive "#060504")
    (border "#1c1a17")

    ;; 1:1 Keyface Determinism Palette (Forest layers hierarchy)
    (red "#be4a44")           ; Dark yew berry: alerts, negation !
    (red-warmer "#c8524c")
    (red-cooler "#b4423c")
    (red-faint "#5a7061")     ; Wet twigs: brackets ( ) [ ] { }

    (green "#6ca253")         ; Rich forest moss: data types (int, size_t, uint32_t)
    (green-warmer "#7ab65e")
    (green-cooler "#5e9846")
    (green-faint "#4a6250")

    (yellow "#bd803e")        ; Wet oak wood / fallen leaves: strings ("strings")
    (yellow-warmer "#c69038") ; Wet amber resin: numbers (0, 24, 32 in buf[0])
    (yellow-cooler "#aa7234")
    (yellow-faint "#8c5e2a")

    (blue "#2c7094")          ; Deep mountain stream: function definitions (is_write_open_flags)
    (blue-warmer "#469cd8")   ; Cold rain water pool: function calls (bpf_map_lookup_elem, BPF_CORE_READ)
    (blue-cooler "#688272")   ; Dark wet slate: operators (+, -, *, >>, &)
    (blue-faint "#2c5672")

    (magenta "#7ec4da")       ; Clear glacial polar ice: constants and macros (LOTA_PCR_COUNT, NULL)
    (magenta-warmer "#8cd0e4")
    (magenta-cooler "#b26e4e") ; Wet cedar wood bark: builtins and attributes (__always_inline, :keywords)
    (magenta-faint "#64aebb")

    (cyan "#2c8446")          ; Deep conifer pine: keywords (struct, while, static, return)
    (cyan-warmer "#7a6450")   ; Dark walnut elm bark: preprocessor and macro directives (__uint, #define)
    (cyan-cooler "#2a8044")
    (cyan-faint "#586e60")    ; Damp pine needles: delimiters (, ;)

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

    (bg-mode-line-active "#151310")
    (fg-mode-line-active "#9c9a96")
    (bg-completion "#12110e")
    (bg-popup "#0f0e0c")
    (bg-hover "#1b1916")
    (bg-hover-secondary "#201d19")
    (bg-hl-line "#28241e")
    (bg-paren-match "#22201a")
    (bg-err "#1e0808")
    (bg-warning "#181004")
    (bg-info "#08140c")
    (bg-region "#223648")))

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
    (preprocessor cyan-warmer)   ; #7a6450 - Dark walnut elm bark (__uint, BPF_CORE_READ, #define)
    (keyword cyan)               ; #2c8446 - Deep conifer pine (struct, while, static, return)
    (type green)                 ; #6ca253 - Rich forest moss (int, size_t, uint32_t)
    (constant magenta)           ; #7ec4da - Clear glacial polar ice (LOTA_PCR_COUNT, NULL)
    (number yellow-warmer)       ; #c69038 - Wet amber resin (0, 24, 32 in buf[0])
    (builtin magenta-cooler)     ; #b26e4e - Wet cedar wood bark (__always_inline, :keywords)
    (fnname blue)                ; #2c7094 - Deep mountain stream (is_write_open_flags)
    (fnname-call blue-warmer)    ; #469cd8 - Cold rain water pool (bpf_map_lookup_elem, BPF_CORE_READ)
    (string yellow)              ; #bd803e - Wet oak wood ("strings")
    (property fg-alt)            ; #5e9f96 - Damp river stone (->tgid, .field)
    (variable fg-main)           ; #9c9a96 - Soft river slate (variables)
    (variable-use fg-main)       ; #9c9a96 - Variable usages
    (operator blue-cooler)       ; #688272 - Dark wet slate (+, -, *, >>, &)
    (bracket red-faint)          ; #5a7061 - Wet twigs (( ) [ ] { })
    (delimiter cyan-faint)       ; #586e60 - Damp needles (, ;)
    (comment fg-dim)             ; #526456 - Dark needle mulch (pure italic)
    (docstring fg-dim)           ; #526456 - Documentation strings
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
 '(font-lock-comment-face ((t (:foreground "#526456" :slant italic))))
 '(font-lock-comment-delimiter-face ((t (:foreground "#526456" :slant italic))))
 '(font-lock-doc-face ((t (:foreground "#526456" :slant italic))))
 '(font-lock-preprocessor-face ((t (:foreground "#7a6450"))))
 '(font-lock-keyword-face ((t (:foreground "#2c8446"))))
 '(font-lock-type-face ((t (:foreground "#6ca253"))))
 '(font-lock-constant-face ((t (:foreground "#7ec4da"))))
 '(font-lock-number-face ((t (:foreground "#c69038"))))
 '(font-lock-builtin-face ((t (:foreground "#b26e4e"))))
 '(font-lock-function-name-face ((t (:foreground "#2c7094"))))
 '(font-lock-function-call-face ((t (:foreground "#469cd8"))))
 '(font-lock-string-face ((t (:foreground "#bd803e"))))
 '(font-lock-variable-name-face ((t (:foreground "#9c9a96"))))
 '(font-lock-variable-use-face ((t (:foreground "#9c9a96"))))
 '(font-lock-property-name-face ((t (:foreground "#5e9f96"))))
 '(font-lock-property-use-face ((t (:foreground "#5e9f96"))))
 '(font-lock-operator-face ((t (:foreground "#688272"))))
 '(font-lock-bracket-face ((t (:foreground "#5a7061"))))
 '(font-lock-delimiter-face ((t (:foreground "#586e60"))))
 '(font-lock-warning-face ((t (:foreground "#be4a44"))))
 '(region ((t (:background "#223648" :extend t)))))

(provide 'rainforest-night-theme)
;;; rainforest-night-theme.el ends here
