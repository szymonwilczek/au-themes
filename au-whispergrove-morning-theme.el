;;; au-whispergrove-morning-theme.el --- Misty temperate whisper grove morning dawn theme for Au-themes -*- lexical-binding:t -*-

(require 'ef-themes)

(defconst au-whispergrove-morning-palette-partial
  '(;; Canvas & Chrome
    (cursor "#005a7e")                 ; Point / cursor indicator
    (bg-main "#aeb0a8")                ; Primary canvas background
    (bg-dim "#a0a29a")                 ; Inactive windows, dim canvas
    (bg-alt "#92948c")                 ; Subtle borders, alternating stripes
    (fg-main "#121814")                ; Default buffer text
    (fg-dim "#48544a")                 ; Comments, metadata
    (fg-alt "#52425e")                 ; Struct properties
    (fg-var "#104a44")                 ; Variable definitions
    (bg-active "#90928a")              ; Active modeline, focused bars
    (bg-inactive "#a0a29a")            ; Inactive modeline
    (border "#70726a")                 ; Window dividers


    ;; Basic Chromatic Scale
    (red "#94322a")                    ; Errors, critical warnings
    (red-warmer "#5c1e10")             ; String literals
    (red-cooler "#7a2822")             ; Diff deletions, removal markers
    (red-faint "#3e4c44")              ; Structural brackets ( ) [ ] { }

    (green "#085a38")                  ; Primitive types (int, size_t, struct)
    (green-warmer "#5c183c")           ; Constant values and macros (NULL, CONST)
    (green-cooler "#502f12")           ; Control keywords (if, while, for, return)
    (green-faint "#48544a")            ; Documentation strings, inline comments

    (yellow "#502f12")                 ; Keyword alias
    (yellow-warmer "#5e5000")          ; Numeric literals (0, 24, 32)
    (yellow-cooler "#363412")          ; Preprocessor directives (#define, #include)
    (yellow-faint "#544c40")           ; Informational tooltips, fringe markers

    (blue "#303753")                   ; Function definitions
    (blue-warmer "#0a5276")            ; Function calls
    (blue-cooler "#3a464c")            ; Operators (=, +, -, *, ->, ==, <, >)
    (blue-faint "#0e5048")             ; Built-in functions (sizeof, typeof, alignof)

    (magenta "#542a16")                ; Composite types: struct, union, enum
    (magenta-warmer "#0e524c")         ; Extended library types
    (magenta-cooler "#48243c")         ; Rare syntax nodes, special escapes
    (magenta-faint "#48544a")          ; Inactive conditional blocks

    (cyan "#502f12")                   ; Keyword fallback
    (cyan-warmer "#363412")            ; Preprocessor alias
    (cyan-cooler "#3a464c")            ; Operator alias
    (cyan-faint "#3a443e")             ; Punctuation delimiters (, ;)

    ;; Panels, Diffs and Structural Highlights
    (bg-added "#a4c8a4")               ; Diff added line baseline
    (bg-added-faint "#b8d4b8")         ; Diff added unchanged context
    (bg-added-refine "#92be92")        ; Diff added word-level highlight
    (fg-added "#004810")               ; Diff added foreground text

    (bg-changed "#d0c08a")             ; Diff changed line baseline
    (bg-changed-faint "#dcceaa")       ; Diff changed unchanged context
    (bg-changed-refine "#c4b076")      ; Diff changed word-level highlight
    (fg-changed "#4a3600")             ; Diff changed foreground text

    (bg-removed "#ceaaaa")             ; Diff removed line baseline
    (bg-removed-faint "#dac0c0")       ; Diff removed unchanged context
    (bg-removed-refine "#c29494")      ; Diff removed word-level highlight
    (fg-removed "#5e1010")             ; Diff removed foreground text

    (bg-mode-line-active "#92968e")    ; Active modeline surface
    (fg-mode-line-active "#0e1810")    ; Active modeline primary text
    (bg-completion "#a4a8a0")          ; Minibuffer completion selected row
    (bg-popup "#b6b8b0")               ; Autocomplete tooltip surface
    (bg-hover "#9c9ea6")               ; Mouse hover overlay
    (bg-hover-secondary "#a29eac")     ; Secondary hover overlay
    (bg-hl-line "#a4a69e")             ; Current line indicator
    (bg-paren-match "#8cb094")         ; Matching delimiter highlight
    (bg-err "#cb9696")                 ; Flymake error inline box
    (bg-warning "#cbba8a")             ; Flymake warning inline box
    (bg-info "#98bca0")                ; Flymake info inline box
    (bg-region "#76a288")))            ; Mouse/keyboard marked region

(defconst au-whispergrove-morning-palette-mappings-partial
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

(defconst au-whispergrove-morning-palette
  (modus-themes-generate-palette
   au-whispergrove-morning-palette-partial
   nil
   nil
   (append au-whispergrove-morning-palette-mappings-partial ef-themes-palette-common)))

;;;###theme-autoload
(modus-themes-theme
 'au-whispergrove-morning
 'ef-themes
 "Au Whispergrove Morning: dewy dawn mist daylight theme with clean, single-point palette configuration."
 'light
 'au-whispergrove-morning-palette
 nil
 nil)

(provide 'au-whispergrove-morning-theme)
;;; au-whispergrove-morning-theme.el ends here
