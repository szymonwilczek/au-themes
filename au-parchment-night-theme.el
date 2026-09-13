;;; au-parchment-night-theme.el --- Deep antique leather binding, aged vellum, and oak gall ink nocturnal theme -*- lexical-binding:t -*-

;; Author: Szymon Wilczek <swilczek.lx@gmail.com>
;; Keywords: faces, themes, accessibility, autism, neurodivergence

(require 'ef-themes)

(defconst au-parchment-night-palette-partial
  '(;; Canvas & Chrome
    (cursor "#bf782c")                 ; Point / cursor indicator
    (bg-main "#13110e")                ; Primary canvas background
    (bg-dim "#1c1915")                 ; Inactive windows, dim canvas
    (bg-alt "#24201b")                 ; Subtle borders, alternating stripes
    (fg-main "#a89880")                ; Default buffer text
    (fg-dim "#665c4e")                 ; Comments, metadata
    (fg-alt "#987e72")                 ; Struct properties
    (fg-var "#a89880")                 ; Variable definitions
    (bg-active "#2c2620")              ; Active modeline frame
    (bg-inactive "#1c1915")            ; Inactive modeline
    (border "#3e362e")                 ; Window dividers

    ;; Basic Chromatic Scale
    (red "#aa4238")                    ; Errors, critical warnings
    (red-warmer "#88737c")             ; String literals
    (red-cooler "#9e3e34")             ; Diff deletions, removal markers
    (red-faint "#736b5d")              ; Structural brackets

    (green "#8e9984")                  ; Primitive types
    (green-warmer "#a0a39a")           ; Constant values and macros
    (green-cooler "#6c7158")           ; Control keywords
    (green-faint "#665c4e")            ; Inline commentary and marginalia

    (yellow "#6c7158")                 ; Keyword alias
    (yellow-warmer "#b2959c")          ; Numeric literals
    (yellow-cooler "#706556")          ; Preprocessor directives
    (yellow-faint "#786c5c")           ; Informational tooltips, fringe markers

    (blue "#646c5a")                   ; Function definitions
    (blue-warmer "#80646f")            ; Function calls
    (blue-cooler "#787062")            ; Binary and unary operators
    (blue-faint "#9e8184")             ; Built-in functions

    (magenta "#8e9984")                ; Composite types: struct, union, enum
    (magenta-warmer "#80646f")         ; Extended library types
    (magenta-cooler "#706556")         ; Rare syntax nodes, special escapes
    (magenta-faint "#665c4e")          ; Inactive conditional blocks

    (cyan "#6c7158")                   ; Keyword fallback
    (cyan-warmer "#706556")            ; Preprocessor alias
    (cyan-cooler "#787062")            ; Operator alias
    (cyan-faint "#686054")             ; Punctuation delimiters (, ;)

    ;; Panels, Diffs and Structural Highlights
    (bg-red-intense "#6a1c16")         ; Blocking errors, fatal assertion panel
    (bg-green-intense "#342e14")       ; Success banner
    (bg-yellow-intense "#583e10")      ; Warning banner, review request
    (bg-blue-intense "#483018")        ; Info banner, active selections
    (bg-magenta-intense "#422018")     ; Special prompt background
    (bg-cyan-intense "#483614")        ; Incsearch current match target

    (bg-red-subtle "#341612")          ; Diff context deletion background
    (bg-green-subtle "#221e10")        ; Diff context addition background
    (bg-yellow-subtle "#2e2210")       ; Diff whitespace/context change
    (bg-blue-subtle "#2e2216")         ; Mode-line subtle indicators
    (bg-magenta-subtle "#2c1c16")      ; Matching paren context background
    (bg-cyan-subtle "#262012")         ; Structural block highlight

    (bg-added "#1e3412")               ; Diff added line baseline
    (bg-added-faint "#12260a")         ; Diff added unchanged context
    (bg-added-refine "#2c481a")        ; Diff added word-level highlight
    (fg-added "#b2d88c")               ; Diff added foreground text

    (bg-changed "#362e08")             ; Diff changed line baseline
    (bg-changed-faint "#262004")       ; Diff changed unchanged context
    (bg-changed-refine "#4a420e")      ; Diff changed word-level highlight
    (fg-changed "#e6c86a")             ; Diff changed foreground text

    (bg-removed "#46140e")             ; Diff removed line baseline
    (bg-removed-faint "#320c08")       ; Diff removed unchanged context
    (bg-removed-refine "#641c14")      ; Diff removed word-level highlight
    (fg-removed "#ffb8b0")             ; Diff removed foreground text

    (bg-mode-line-active "#221c18")    ; Active modeline surface
    (fg-mode-line-active "#baa88c")    ; Active modeline primary text
    (bg-completion "#26201a")          ; Minibuffer completion selected row
    (bg-popup "#181412")               ; Autocomplete tooltip surface
    (bg-hover "#342a22")               ; Mouse hover overlay
    (bg-hover-secondary "#3e2e38")     ; Secondary hover overlay
    (bg-hl-line "#1c1915")             ; Current line indicator
    (bg-paren-match "#3c3422")         ; Matching delimiter highlight
    (bg-err "#3a1410")                 ; Flymake error inline box
    (bg-warning "#34260a")             ; Flymake warning inline box
    (bg-info "#1e2c14")                ; Flymake info inline box
    (bg-region "#4e281a")              ; Marked region
    (fg-line-number-inactive "#62584c"))) ; Inactive line numbers margin

(defconst au-parchment-night-palette-mappings-partial
  '((err red)
    (warning yellow-warmer)
    (info green)

    (fg-link blue-warmer)
    (fg-link-visited blue)
    (name blue)
    (keybind red)
    (identifier fg-alt)
    (fg-prompt yellow-warmer)

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

    (accent-0 yellow-warmer)
    (accent-1 green)
    (accent-2 blue)
    (accent-3 green-warmer)))

(defconst au-parchment-night-palette
  (modus-themes-generate-palette
   au-parchment-night-palette-partial
   nil
   nil
   (append au-parchment-night-palette-mappings-partial ef-themes-palette-common)))

(defconst au-parchment-night-custom-faces
  '(`(font-lock-keyword-face ((,c :inherit modus-themes-slant :foreground ,keyword)))
    `(font-lock-builtin-face ((,c :inherit modus-themes-slant :foreground ,builtin)))
    `(font-lock-comment-face ((,c :inherit modus-themes-slant :foreground ,comment)))
    `(font-lock-doc-face ((,c :inherit modus-themes-slant :foreground ,docstring)))))

;;;###theme-autoload
(modus-themes-theme
 'au-parchment-night
 'ef-themes
 "Au Parchment Night: antique tanned leather binding and aged vellum nocturnal sanctuary with minimal chroma entropy and typographic hierarchy."
 'dark
 'au-parchment-night-palette
 nil
 nil
 'au-parchment-night-custom-faces)

(provide 'au-parchment-night-theme)
;;; au-parchment-night-theme.el ends here
