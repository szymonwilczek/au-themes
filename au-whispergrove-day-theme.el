;;; au-whispergrove-day-theme.el --- Misty temperate whisper grove daylight theme for Au-themes -*- lexical-binding:t -*-

(require 'ef-themes)

(defconst au-whispergrove-day-palette-partial
  '(;; Canvas & Chrome
    (cursor "#005878")                 ; Point / cursor indicator
    (bg-main "#b6beb4")                ; Primary canvas background
    (bg-dim "#a8b0a6")                 ; Inactive windows, dim canvas
    (bg-alt "#9aa298")                 ; Subtle borders, alternating stripes
    (fg-main "#18201a")                ; Default buffer text
    (fg-dim "#4a564c")                 ; Comments, metadata
    (fg-alt "#52425e")                 ; Struct properties
    (fg-var "#104a44")                 ; Variable definitions
    (bg-active "#949e93")              ; Active modeline, focused bars
    (bg-inactive "#a8b0a7")            ; Inactive modeline
    (border "#7e867d")                 ; Window dividers


    ;; Basic Chromatic Scale
    (red "#82322a")                    ; Errors, critical warnings
    (red-warmer "#5c1e10")             ; String literals
    (red-cooler "#7a2822")             ; Diff deletions, removal markers
    (red-faint "#3e4c44")              ; Structural brackets ( ) [ ] { }

    (green "#085a38")                  ; Primitive types (int, size_t, struct)
    (green-warmer "#5c183c")           ; Constant values and macros (NULL, CONST)
    (green-cooler "#502f12")           ; Control keywords (if, while, for, return)
    (green-faint "#4a564c")            ; Documentation strings, inline comments

    (yellow "#502f12")                 ; Keyword alias
    (yellow-warmer "#5e5000")          ; Numeric literals (0, 24, 32)
    (yellow-cooler "#363412")          ; Preprocessor directives (#define, #include)
    (yellow-faint "#564e42")           ; Informational tooltips, fringe markers

    (blue "#303753")                   ; Function definitions
    (blue-warmer "#0a5276")            ; Function calls
    (blue-cooler "#3a464c")            ; Operators (=, +, -, *, ->, ==, <, >)
    (blue-faint "#0e5048")             ; Built-in functions (sizeof, typeof, alignof)

    (magenta "#542a16")                ; Composite types: struct, union, enum
    (magenta-warmer "#0e524c")         ; Extended library types
    (magenta-cooler "#48243c")         ; Rare syntax nodes, special escapes
    (magenta-faint "#4c584e")          ; Inactive conditional blocks

    (cyan "#502f12")                   ; Keyword fallback
    (cyan-warmer "#363412")            ; Preprocessor alias
    (cyan-cooler "#3a464c")            ; Operator alias
    (cyan-faint "#3a443e")             ; Punctuation delimiters (, ;)

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
    (bg-hl-line "#aab2a8")             ; Current line indicator
    (bg-paren-match "#a0c0a8")         ; Matching delimiter highlight
    (bg-err "#dfb6b6")                 ; Flymake error inline box
    (bg-warning "#dfd2a6")             ; Flymake warning inline box
    (bg-info "#b0d4b8")                ; Flymake info inline box
    (bg-region "#88ba9e")))            ; Mouse/keyboard marked region

(defconst au-whispergrove-day-palette-mappings-partial
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

(defconst au-whispergrove-day-palette
  (modus-themes-generate-palette
   au-whispergrove-day-palette-partial
   nil
   nil
   (append au-whispergrove-day-palette-mappings-partial ef-themes-palette-common)))

;;;###theme-autoload
(modus-themes-theme
 'au-whispergrove-day
 'ef-themes
 "Au Whispergrove Day: daylight theme with clean, single-point palette configuration."
 'light
 'au-whispergrove-day-palette
 nil
 nil)

(provide 'au-whispergrove-day-theme)
;;; au-whispergrove-day-theme.el ends here
