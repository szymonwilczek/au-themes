;;; au-perseida-day-theme.el --- Pearl light theme of the dawn after a meteor night -*- lexical-binding:t -*-

;; Copyright (C) 2026  Szymon Wilczek

;; Author: Szymon Wilczek <swilczek.lx@gmail.com>
;; URL: https://github.com/szymonwilczek/au-themes
;; Keywords: faces, themes, accessibility, autism, neurodivergence

;; This file is not part of GNU Emacs.

;; This file is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this file.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; Light theme of the dawn after a night of Perseid watching.
;; The canvas is a cool pearl, the sky at nautical dawn before the sun
;; colours it, and the current line is the brightening band above the
;; horizon.  The same objects as in `au-perseida-night' keep their
;; hues: four syntax roles take the colours of named stars, held in
;; their spectral order on the Planckian locus; keywords take the
;; H-alpha rose of the California Nebula, the preprocessor the [O III]
;; teal of the Ring Nebula and builtins the green of a Perseid.
;; Comments are the fading stars, the selection the first light,
;; and Venus, the morning star, marks the cursor.
;; Part of the `au-themes' collection.

;;; Code:

(require 'modus-themes)
(require 'au-themes)

(defconst au-themes-perseida-day-palette-partial
  '(;; Canvas & Chrome
    (cursor "#7e6f03")                    ; Point / cursor indicator
    (bg-main "#d3d5d7")                   ; Primary canvas background
    (bg-dim "#c7cace")                    ; Inactive windows, dim canvas
    (bg-alt "#b9bcc1")                    ; Subtle borders, alternating stripes
    (fg-main "#201d19")                   ; Default buffer text
    (fg-dim "#706b65")                    ; Comments, metadata
    (fg-alt "#604304")                    ; Section headings
    (fg-prop "#365e60")                   ; Struct properties
    (fg-var "#3e3b1b")                    ; Variable definitions
    (bg-active "#b9bec4")                 ; Active modeline frame, focused bars
    (bg-inactive "#c7cace")               ; Inactive modeline
    (border "#9ba0a7")                    ; Window dividers

    ;; Basic Chromatic Scale
    (red "#99312f")                       ; Errors, critical warnings
    (red-warmer "#531b05")                ; String literals
    (red-cooler "#7f292c")                ; Diff deletions, removal markers
    (red-faint "#4a4947")                 ; Structural brackets

    (green "#8b4716")                     ; Primitive types
    (green-warmer "#515b77")              ; Constant values and macros
    (green-cooler "#671d3d")              ; Control keywords
    (green-faint "#706b65")               ; Documentation strings, inline comments

    (yellow "#7c4d01")                    ; Keyword alias
    (yellow-warmer "#6b5440")             ; Numeric literals
    (yellow-cooler "#013c37")             ; Preprocessor directives
    (yellow-faint "#4c452d")              ; Informational tooltips, fringe markers

    (blue "#512e56")                      ; Function definitions
    (blue-warmer "#3c3f65")               ; Function calls
    (blue-cooler "#444442")               ; Binary and unary operators
    (blue-faint "#256039")                ; Built-in functions

    (magenta "#63492e")                   ; Composite types: struct, union, enum
    (magenta-warmer "#694d37")            ; Extended library types
    (magenta-cooler "#2c595c")            ; Rare syntax nodes, special escapes
    (magenta-faint "#7d7974")             ; Inactive conditional blocks

    (cyan "#58524e")                      ; Keyword fallback
    (cyan-warmer "#225552")               ; Preprocessor alias
    (cyan-cooler "#505359")               ; Operator alias
    (cyan-faint "#4d4d4b")                ; Punctuation delimiters

    ;; Panels, Diffs and Structural Highlights
    (bg-red-intense "#e0a29c")            ; Blocking errors, fatal assertion panel
    (bg-green-intense "#9cbfa2")          ; Success banner
    (bg-yellow-intense "#d0ba84")         ; Warning banner, review request
    (bg-blue-intense "#a6b3db")           ; Info banner, active selections
    (bg-magenta-intense "#d6a3be")        ; Special prompt background
    (bg-cyan-intense "#89c2c0")           ; Incsearch current match target

    (bg-red-subtle "#dec8c4")             ; Diff context deletion background
    (bg-green-subtle "#c1d6c3")           ; Diff context addition background
    (bg-yellow-subtle "#daceb2")          ; Diff whitespace/context change
    (bg-blue-subtle "#c9cfe2")            ; Mode-line subtle indicators
    (bg-magenta-subtle "#dac7d1")         ; Matching paren context background
    (bg-cyan-subtle "#bad6d4")            ; Structural block highlight

    (bg-added "#c2e6c6")                  ; Diff added line baseline
    (bg-added-faint "#d6efd9")            ; Diff added unchanged context
    (bg-added-refine "#afdeb4")           ; Diff added word-level highlight
    (fg-added "#04501d")                  ; Diff added foreground text

    (bg-changed "#ede0ae")                ; Diff changed line baseline
    (bg-changed-faint "#f8efcd")          ; Diff changed unchanged context
    (bg-changed-refine "#e1d299")         ; Diff changed word-level highlight
    (fg-changed "#583f03")                ; Diff changed foreground text

    (bg-removed "#edcac8")                ; Diff removed line baseline
    (bg-removed-faint "#f7dedc")          ; Diff removed unchanged context
    (bg-removed-refine "#e6bbb9")         ; Diff removed word-level highlight
    (fg-removed "#73171b")                ; Diff removed foreground text

    (bg-mode-line-active "#b6bbc1")       ; Active modeline surface
    (fg-mode-line-active "#14171d")       ; Active modeline primary text
    (bg-completion "#c1c5d3")             ; Minibuffer completion selected row
    (bg-popup "#d4d7da")                  ; Autocomplete tooltip surface
    (bg-hover "#b7bfd7")                  ; Mouse hover overlay
    (bg-hover-secondary "#ccbdca")        ; Secondary hover overlay
    (bg-hl-line "#c6cad9")                ; Current line indicator
    (bg-paren-match "#cdbb9e")            ; Matching delimiter highlight
    (bg-err "#eac4c0")                    ; Flymake error inline box
    (bg-warning "#edddb3")                ; Flymake warning inline box
    (bg-info "#bcdcc6")                   ; Flymake info inline box
    (bg-region "#a9b0e1")                 ; Marked region
    (fg-line-number-inactive "#777a80"))) ; Inactive line numbers margin

(defconst au-themes-perseida-day-palette-mappings-partial
  '((err red)
    (warning yellow)
    (info yellow-faint)

    ;; The canvas reaches the frame edge:
    (bg-tab-bar bg-main)
    (bg-tab-current bg-alt)
    (bg-tab-other bg-main)

    (fg-link blue-warmer)
    (fg-link-visited blue)
    (name blue)
    (keybind red)
    (identifier blue-warmer)
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
    (property fg-prop)
    (variable fg-var)
    (variable-use fg-main)
    (operator blue-cooler)
    (bracket red-faint)
    (delimiter cyan-faint)
    (comment green-faint)
    (docstring green-faint)
    (rx-backslash yellow-cooler)
    (rx-construct red)

    (accent-0 yellow)
    (accent-1 yellow-cooler)
    (accent-2 blue-faint)
    (accent-3 green-warmer)))

(defconst au-themes-perseida-day-palette
  (modus-themes-generate-palette
   au-themes-perseida-day-palette-partial
   nil
   nil
   (append au-themes-perseida-day-palette-mappings-partial au-themes-palette-common)))

;;;###theme-autoload
(modus-themes-theme
 'au-perseida-day
 'au-themes
 "Pearl light theme of the dawn after a meteor night, with star-coloured syntax."
 'light
 'au-themes-perseida-day-palette
 nil
 nil)

(provide 'au-perseida-day-theme)
;;; au-perseida-day-theme.el ends here
