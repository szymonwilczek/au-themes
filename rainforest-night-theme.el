;;; rainforest-night-theme.el --- Deep rainy forest shelter theme -*- lexical-binding:t -*-

(require 'ef-themes)

(defconst rainforest-night-palette-partial
  '(;; Canvas: dark wet forest floor with luminance pedestal (L*=4.78 to prevent pupil over-dilation and r^4 wavefront aberration)
    (cursor "#54a8be")        ; Raindrop glint highlight
    (bg-main "#0e110f")       ; Wet forest soil with pedestal (L*=4.78, prevents straylight halo and edge shock)
    (bg-dim "#141715")        ; Damp bark shadow
    (bg-alt "#1a1e1b")        ; Deep canopy shadow
    (fg-main "#9aa49c")       ; Mineral quartz: balanced base text (Lc=49.6, C*=5.9, prevents ciliary hunting)
    (fg-dim "#526456")        ; Damp conifer needles: comments in italic (Lc=18.9, discrete background)
    (fg-alt "#609886")        ; Wet stone: struct fields and parameters (Lc=39.4, delta to base = 10,247)

    (bg-active "#1c221e")
    (bg-inactive "#121513")
    (border "#181c19")

    ;; 1:1 Keyface Determinism Palette (Lekner & Dorf 1988 C* <= 38.0, Thibos delta-D <= 0.25 D, delta >= 8000)
    (red "#a05450")           ; Yew berry: errors, alerts, negation ! (Lc=23.5, C*=35.1)
    (red-warmer "#aa5a54")
    (red-cooler "#964e4a")
    (red-faint "#607266")     ; Larch twig: brackets ( ) [ ] { } (Lc=24.8)

    (green "#64925a")         ; Forest moss: data types (int, size_t, struct Type) (Lc=36.2, C*=36.7)
    (green-warmer "#6e9c62")
    (green-cooler "#5a8850")
    (green-faint "#527848")

    (yellow "#ba726c")        ; Forest lingonberry: string literals ("strings") (Lc=35.7, C*=31.7)
    (yellow-warmer "#aa8a4c") ; Amber resin: numeric literals (0, 24, 32 in buf[0]) (Lc=40.1, C*=37.7)
    (yellow-cooler "#a46a84")
    (yellow-faint "#8e586e")

    (blue "#267a9e")          ; Mountain stream: function definitions (is_write_open_flags) (Lc=27.0, C*=29.2)
    (blue-warmer "#54aaca")   ; Drizzle splash: function calls (bpf_map_lookup_elem) (Lc=48.9, C*=29.3)
    (blue-cooler "#6c8074")   ; Dark slate: operators (+, -, *, >>, &) (Lc=30.8, C*=10.6)
    (blue-faint "#206886")

    (magenta "#946ca2")       ; Heather violet: constants and macros (LOTA_PCR_COUNT, NULL) (Lc=30.6, C*=34.6)
    (magenta-warmer "#9e74ac")
    (magenta-cooler "#967464") ; Pine and cedar bark: builtins and attributes (__always_inline, :keywords) (Lc=30.9, C*=17.8)
    (magenta-faint "#76584c")

    (cyan "#288e72")          ; Deep conifer emerald: keywords (struct, while, static, return) (Lc=32.6, C*=36.4)
    (cyan-warmer "#4eb294")   ; Spruce crown: preprocessor directives (#define, #include) (Lc=49.7, C*=37.1)
    (cyan-cooler "#208468")
    (cyan-faint "#627268")    ; Subtle needles: delimiters (, ;)

    ;; Diffs and panels
    (bg-added "#0e2214")
    (bg-added-faint "#08160d")
    (bg-added-refine "#122e1b")
    (fg-added "#58b260")

    (bg-changed "#201c08")
    (bg-changed-faint "#141205")
    (bg-changed-refine "#2a240c")
    (fg-changed "#bca436")

    (bg-removed "#240e0c")
    (bg-removed-faint "#160807")
    (bg-removed-refine "#301210")
    (fg-removed "#c0524a")

    (bg-mode-line-active "#141816")
    (fg-mode-line-active "#9aa89e")
    (bg-completion "#121614")
    (bg-popup "#101412")
    (bg-hover "#18201a")
    (bg-hover-secondary "#201820")
    (bg-hl-line "#121614")
    (bg-paren-match "#16241a")
    (bg-err "#220e0c")
    (bg-warning "#1c1405")
    (bg-info "#0a1a10")
    (bg-region "#162218")))

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

    ;; 1:1 Keyface Determinism Mappings (distinct color per syntax role):
    (preprocessor cyan-warmer)   ; #4eb294 - Preprocessor directives (#define, #include)
    (keyword cyan)               ; #288e72 - Language keywords (struct, while, static, return)
    (type green)                 ; #64925a - Data types (int, size_t, struct Type)
    (constant magenta)           ; #946ca2 - Constants and enums (LOTA_PCR_COUNT, NULL)
    (number yellow-warmer)       ; #aa8a4c - Numeric literals (0, 24, 32 in buf[0])
    (builtin magenta-cooler)     ; #967464 - Builtins and attributes (__always_inline, :keywords)
    (fnname blue)                ; #267a9e - Function definitions (is_write_open_flags)
    (fnname-call blue-warmer)    ; #54aaca - Function calls (bpf_map_lookup_elem)
    (string yellow)              ; #ba726c - String literals ("strings")
    (property fg-alt)            ; #609886 - Struct fields and properties (->tgid, .field)
    (variable fg-main)           ; #9aa49c - Variables and identifiers
    (variable-use fg-main)       ; #9aa49c - Variable usages
    (operator blue-cooler)       ; #6c8074 - Operators (+, -, *, >>, &)
    (bracket red-faint)          ; #607266 - Brackets and delimiters (( ) [ ] { })
    (delimiter cyan-faint)       ; #627268 - Separators (, ;)
    (comment fg-dim)             ; #526456 - Comments (pure italic)
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
 "Deep rainy forest shelter night theme (APCA Lc / WCAG 3, 1:1 determinism, luminance pedestal against pupil aberration)."
 'dark
 'rainforest-night-palette
 nil
 nil)

;; Deterministic universal face mappings (standard font-lock faces):
(custom-theme-set-faces
 'rainforest-night
 '(font-lock-comment-face ((t (:foreground "#526456" :slant italic))))
 '(font-lock-comment-delimiter-face ((t (:foreground "#526456" :slant italic))))
 '(font-lock-doc-face ((t (:foreground "#526456" :slant italic))))
 '(font-lock-preprocessor-face ((t (:foreground "#4eb294"))))
 '(font-lock-keyword-face ((t (:foreground "#288e72"))))
 '(font-lock-type-face ((t (:foreground "#64925a"))))
 '(font-lock-constant-face ((t (:foreground "#946ca2"))))
 '(font-lock-number-face ((t (:foreground "#aa8a4c"))))
 '(font-lock-builtin-face ((t (:foreground "#967464"))))
 '(font-lock-function-name-face ((t (:foreground "#267a9e"))))
 '(font-lock-function-call-face ((t (:foreground "#54aaca"))))
 '(font-lock-string-face ((t (:foreground "#ba726c"))))
 '(font-lock-property-name-face ((t (:foreground "#609886"))))
 '(font-lock-property-use-face ((t (:foreground "#609886"))))
 '(font-lock-operator-face ((t (:foreground "#6c8074"))))
 '(font-lock-bracket-face ((t (:foreground "#607266"))))
 '(font-lock-delimiter-face ((t (:foreground "#627268"))))
 '(font-lock-warning-face ((t (:foreground "#a05450")))))

(provide 'rainforest-night-theme)
;;; rainforest-night-theme.el ends here
