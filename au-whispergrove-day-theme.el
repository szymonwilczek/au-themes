;;; au-whispergrove-day-theme.el --- Misty temperate whisper grove daylight theme for Au-themes -*- lexical-binding:t -*-

(require 'ef-themes)

(defconst au-whispergrove-day-palette-partial
  '(;; Canvas & Chrome
    (cursor "#0e648a")                 ; Point / cursor indicator
    (bg-main "#cfd1c9")                ; Primary canvas background
    (bg-dim "#c1c3bb")                 ; Inactive windows, dim canvas
    (bg-alt "#b3b5ad")                 ; Subtle borders, alternating stripes
    (fg-main "#242d26")                ; Default buffer text
    (fg-dim "#59665b")                 ; Comments, metadata
    (fg-alt "#5c4b69")                 ; Struct properties
    (fg-var "#19544e")                 ; Variable definitions
    (bg-active "#b1b3ab")              ; Active modeline, focused bars
    (bg-inactive "#c1c3bb")            ; Inactive modeline
    (border "#90938a")                 ; Window dividers

    ;; Basic Chromatic Scale
    (red "#a13b32")                    ; Errors, critical warnings
    (red-warmer "#682617")             ; String literals
    (red-cooler "#87312a")             ; Diff deletions, removal markers
    (red-faint "#47564d")              ; Structural brackets ( ) [ ] { }

    (green "#146441")                  ; Primitive types (int, size_t, struct)
    (green-warmer "#682045")           ; Constant values and macros (NULL, CONST)
    (green-cooler "#5b381a")           ; Control keywords (if, while, for, return)
    (green-faint "#59665b")            ; Documentation strings, inline comments

    (yellow "#5b381a")                 ; Keyword alias
    (yellow-warmer "#685a0b")          ; Numeric literals (0, 24, 32)
    (yellow-cooler "#3f3d19")          ; Preprocessor directives (#define, #include)
    (yellow-faint "#60584b")           ; Informational tooltips, fringe markers

    (blue "#39405e")                   ; Function definitions
    (blue-warmer "#155c82")            ; Function calls
    (blue-cooler "#435056")            ; Operators (=, +, -, *, ->, ==, <, >)
    (blue-faint "#185a52")             ; Built-in functions (sizeof, typeof, alignof)

    (magenta "#5f321d")                ; Composite types: struct, union, enum
    (magenta-warmer "#185c56")         ; Extended library types
    (magenta-cooler "#532c46")         ; Rare syntax nodes, special escapes
    (magenta-faint "#556257")          ; Inactive conditional blocks

    (cyan "#5b381a")                   ; Keyword fallback
    (cyan-warmer "#3f3d19")            ; Preprocessor alias
    (cyan-cooler "#435056")            ; Operator alias
    (cyan-faint "#434d47")             ; Punctuation delimiters (, ;)

    ;; Panels, Diffs and Structural Highlights
    (bg-added "#c3e8c3")               ; Diff added line baseline
    (bg-added-faint "#d7f2d7")         ; Diff added unchanged context
    (bg-added-refine "#b1deb0")        ; Diff added word-level highlight
    (fg-added "#0b581a")               ; Diff added foreground text

    (bg-changed "#f0dfa8")             ; Diff changed line baseline
    (bg-changed-faint "#faf0c9")       ; Diff changed unchanged context
    (bg-changed-refine "#e4cf94")      ; Diff changed word-level highlight
    (fg-changed "#604609")             ; Diff changed foreground text

    (bg-removed "#eec9c9")             ; Diff removed line baseline
    (bg-removed-faint "#f9dfdf")       ; Diff removed unchanged context
    (bg-removed-refine "#e2b3b3")      ; Diff removed word-level highlight
    (fg-removed "#7b1d1c")             ; Diff removed foreground text

    (bg-mode-line-active "#b1b5ad")    ; Active modeline surface
    (fg-mode-line-active "#17251c")    ; Active modeline primary text
    (bg-completion "#c3c7bf")          ; Minibuffer completion selected row
    (bg-popup "#d6d9d3")               ; Autocomplete tooltip surface
    (bg-hover "#bbbfb7")               ; Mouse hover overlay
    (bg-hover-secondary "#c1bdc7")     ; Secondary hover overlay
    (bg-hl-line "#c5c7bf")             ; Current line indicator
    (bg-paren-match "#abcbb3")         ; Matching delimiter highlight
    (bg-err "#ebc1c1")                 ; Flymake error inline box
    (bg-warning "#ebddb0")             ; Flymake warning inline box
    (bg-info "#bbe0c3")                ; Flymake info inline box
    (bg-region "#9cc5af")))            ; Mouse/keyboard marked region

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
