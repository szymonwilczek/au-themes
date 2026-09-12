;;; au-rainforest-day-theme.el --- Misty temperate rainforest daylight theme for Au-themes -*- lexical-binding:t -*-

(require 'ef-themes)

(defconst au-rainforest-day-palette-partial
  '(;; Canvas & Chrome
    (cursor "#005a82")                 ; Point / cursor indicator
    (bg-main "#c5cec4")                ; Primary canvas background
    (bg-dim "#b6c0b5")                 ; Inactive windows, dim canvas
    (bg-alt "#98a695")                 ; Subtle borders, alternating stripes
    (fg-main "#0e1810")                ; Default buffer text
    (fg-dim "#546456")                 ; Comments, metadata
    (fg-alt "#106248")                 ; Struct properties (e.g. ->field, .param)
    (fg-var "#085c3c")                 ; Variable definitions
    (bg-active "#95ac97")              ; Active modeline, focused bars
    (bg-inactive "#b2beb2")            ; Inactive modeline
    (border "#849686")                 ; Window dividers


    ;; Basic Chromatic Scale
    (red "#9e261e")                    ; Errors, critical warnings
    (red-warmer "#8a2c14")             ; String literals
    (red-cooler "#8c2822")             ; Diff deletions, removal markers
    (red-faint "#4a584e")              ; Structural brackets ( ) [ ] { }

    (green "#007424")                  ; Primitive types (int, size_t, struct)
    (green-warmer "#821a52")           ; Constant values and macros (NULL, CONST)
    (green-cooler "#883800")           ; Control keywords (if, while, for, return)
    (green-faint "#505e54")            ; Documentation strings, inline comments

    (yellow "#883800")                 ; Keyword alias
    (yellow-warmer "#785800")          ; Numeric literals (0, 24, 32)
    (yellow-cooler "#564800")          ; Preprocessor directives (#define, #include)
    (yellow-faint "#5a5040")           ; Informational tooltips, fringe markers

    (blue "#005488")                   ; Function definitions
    (blue-warmer "#006490")            ; Function calls
    (blue-cooler "#445458")            ; Operators (=, +, -, *, ->, ==, <, >)
    (blue-faint "#006c56")             ; Built-in functions (sizeof, typeof, alignof)

    (magenta "#5a2e18")                ; Composite types: struct, union, enum
    (magenta-warmer "#006466")         ; Extended library types
    (magenta-cooler "#502842")         ; Rare syntax nodes, special escapes
    (magenta-faint "#505e54")          ; Inactive conditional blocks

    (cyan "#883800")                   ; Keyword fallback
    (cyan-warmer "#564800")            ; Preprocessor alias
    (cyan-cooler "#445458")            ; Operator alias
    (cyan-faint "#445046")             ; Punctuation delimiters (, ;)

    ;; Panels, Diffs and Structural Highlights
    (bg-added "#b8dcb8")               ; Diff added line baseline
    (bg-added-faint "#cce6cc")         ; Diff added unchanged context
    (bg-added-refine "#a6d2a6")        ; Diff added word-level highlight
    (fg-added "#004e12")               ; Diff added foreground text

    (bg-changed "#e4d49e")             ; Diff changed line baseline
    (bg-changed-faint "#eee4be")       ; Diff changed unchanged context
    (bg-changed-refine "#d8c48a")      ; Diff changed word-level highlight
    (fg-changed "#553d00")             ; Diff changed foreground text

    (bg-removed "#e2bebe")             ; Diff removed line baseline
    (bg-removed-faint "#edd4d4")       ; Diff removed unchanged context
    (bg-removed-refine "#d6a8a8")      ; Diff removed word-level highlight
    (fg-removed "#6e1414")             ; Diff removed foreground text

    (bg-mode-line-active "#a6aaa2")    ; Active modeline surface
    (fg-mode-line-active "#101c14")    ; Active modeline primary text
    (bg-completion "#b8bcb4")          ; Minibuffer completion selected row
    (bg-popup "#cbcec8")               ; Autocomplete tooltip surface
    (bg-hover "#b0b4ac")               ; Mouse hover overlay
    (bg-hover-secondary "#b6b2bc")     ; Secondary hover overlay
    (bg-hl-line "#b8bab4")             ; Current line indicator
    (bg-paren-match "#a0c0a8")         ; Matching delimiter highlight
    (bg-err "#dfb6b6")                 ; Flymake error inline box
    (bg-warning "#dfd2a6")             ; Flymake warning inline box
    (bg-info "#b0d4b8")                ; Flymake info inline box
    (bg-region "#b2bebc")))            ; Mouse/keyboard marked region

(defconst au-rainforest-day-palette-mappings-partial
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
 "Au Rainforest Day: daylight theme with clean, single-point palette configuration."
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
