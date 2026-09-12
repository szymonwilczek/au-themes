;;; au-rainforest-night-theme.el --- Deep nocturnal rainy forest theme for Au-themes -*- lexical-binding:t -*-

(require 'ef-themes)

(defconst au-rainforest-night-palette-partial
  '(;; Canvas & Chrome
    (cursor "#4a9cb2")                 ; Point / cursor indicator
    (bg-main "#0f0e06")                ; Primary canvas background
    (bg-dim "#26211d")                 ; Inactive windows, dim canvas
    (bg-alt "#36322f")                 ; Subtle borders, alternating stripes
    (fg-main "#9ca69e")                ; Default buffer text
    (fg-dim "#546656")                 ; Comments, metadata
    (fg-alt "#a68846")                 ; Struct properties
    (fg-var "#98aba0")                 ; Variable definitions
    (bg-active "#56524f")              ; Active modeline, focused bars
    (bg-inactive "#25241d")            ; Inactive modeline
    (border "#58514f")                 ; Window dividers

    ;; Basic Chromatic Scale
    (red "#b6463e")                    ; Errors, critical warnings
    (red-warmer "#9e604e")             ; String literals
    (red-cooler "#a44a42")             ; Diff deletions, removal markers
    (red-faint "#687e6b")              ; Structural brackets

    (green "#869e42")                  ; Primitive types
    (green-warmer "#a46c76")           ; Constant values
    (green-cooler "#a47028")           ; Control keywords
    (green-faint "#546656")            ; Documentation strings, inline comments

    (yellow "#a47028")                 ; Keyword alias
    (yellow-warmer "#bca03c")          ; Numeric literals
    (yellow-cooler "#7e5a28")          ; Preprocessor directives
    (yellow-faint "#647062")           ; Informational tooltips, fringe markers

    (blue "#227086")                   ; Function definitions
    (blue-warmer "#4e92a4")            ; Function calls
    (blue-cooler "#5e8274")            ; Binary and unary operators
    (blue-faint "#4a7852")             ; Built-in functions

    (magenta "#8c6238")                ; Composite types: struct, union, enum
    (magenta-warmer "#62a28c")         ; Extended library types
    (magenta-cooler "#72627e")         ; Rare syntax nodes, special escapes
    (magenta-faint "#546656")          ; Inactive conditional blocks

    (cyan "#a47028")                   ; Keyword fallback w extractorze
    (cyan-warmer "#7e5a28")            ; Preprocessor alias
    (cyan-cooler "#5e8274")            ; Operator alias
    (cyan-faint "#6c786e")             ; Punctuation delimiters (:delimiter)

    ;; Panels, Diffs and Structural Highlights
    (bg-red-intense "#741d1a")         ; Blocking errors, fatal assertion panel
    (bg-green-intense "#1e5224")       ; Success banner, terminal green state
    (bg-yellow-intense "#604210")      ; Warning banner, review request
    (bg-blue-intense "#1a4658")        ; Info banner, active selections
    (bg-magenta-intense "#502842")     ; Special prompt background
    (bg-cyan-intense "#14484c")        ; Incsearch current match target

    (bg-red-subtle "#381614")          ; Diff context deletion background
    (bg-green-subtle "#122a18")        ; Diff context addition background
    (bg-yellow-subtle "#34200e")       ; Diff whitespace/context change
    (bg-blue-subtle "#102832")         ; Mode-line subtle indicators
    (bg-magenta-subtle "#2c1626")      ; Matching paren context background
    (bg-cyan-subtle "#102c2e")         ; Structural block highlight

    (bg-added "#17360f")               ; Diff added line baseline
    (bg-added-faint "#0a2900")         ; Diff added unchanged context
    (bg-added-refine "#204810")        ; Diff added word-level highlight
    (fg-added "#9ed4a2")               ; Diff added foreground text

    (bg-changed "#363300")             ; Diff changed line baseline
    (bg-changed-faint "#2a1f00")       ; Diff changed unchanged context
    (bg-changed-refine "#4a4a00")      ; Diff changed word-level highlight
    (fg-changed "#dcd478")             ; Diff changed foreground text

    (bg-removed "#4b120a")             ; Diff removed line baseline
    (bg-removed-faint "#3a0a00")       ; Diff removed unchanged context
    (bg-removed-refine "#6f1a16")      ; Diff removed word-level highlight
    (fg-removed "#ffbfbf")             ; Diff removed foreground text

    (bg-mode-line-active "#382c26")    ; Active modeline surface
    (fg-mode-line-active "#d8d4ca")    ; Active modeline primary text
    (bg-completion "#202622")          ; Minibuffer completion selected row
    (bg-popup "#1c1e18")               ; Autocomplete tooltip surface
    (bg-hover "#24382e")               ; Mouse hover overlay
    (bg-hover-secondary "#362a3c")     ; Secondary hover overlay
    (bg-hl-line "#161c16")             ; Current line indicator
    (bg-paren-match "#284c38")         ; Matching delimiter highlight
    (bg-err "#3a1210")                 ; Flymake error inline box
    (bg-warning "#30260a")             ; Flymake warning inline box
    (bg-info "#102816")                ; Flymake info inline box
    (bg-region "#1a3226")              ; Mouse/keyboard marked region
    (fg-line-number-inactive "#546458"))) ; Inactive line numbers margin

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
    (keyword green-cooler)             ; Mapped on #a47028
    (builtin blue-faint)               ; Mapped on #4a7852
    (type green)                       ; Mapped on #869e42
    (preprocessor yellow-cooler)       ; Mapped on #7e5a28
    (constant green-warmer)            ; Mapped on #a46c76
    (number yellow-warmer)             ; Mapped on #bca03c
    (fnname blue)                      ; Mapped on #227086
    (fnname-call blue-warmer)          ; Mapped on #4e92a4
    (string red-warmer)                ; Mapped on #9e604e
    (property fg-alt)                  ; Mapped on #a68846
    (variable fg-var)                  ; Mapped on #98aba0
    (variable-use fg-main)             ; Variable usage -> #9ca69e
    (operator blue-cooler)             ; Mapped on #5e8274
    (bracket red-faint)                ; Mapped on #687e6b
    (delimiter cyan-faint)             ; Mapped on #6c786e
    (comment green-faint)              ; Buffer comments -> #546656
    (docstring green-faint)            ; In-source docstrings -> #546656
    (rx-backslash yellow-cooler)       ; Regex backslashes
    (rx-construct red)                 ; Regex constructs

    (accent-0 blue)
    (accent-1 green)
    (accent-2 yellow)
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

;; Backward-compatibility aliases
(defvaralias 'rainforest-night-palette 'au-rainforest-night-palette)
(defvaralias 'rainforest-night-palette-partial 'au-rainforest-night-palette-partial)

(provide 'au-rainforest-night-theme)
(provide 'rainforest-night-theme)
;;; au-rainforest-night-theme.el ends here
