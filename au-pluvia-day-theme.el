;;; au-pluvia-day-theme.el --- Light theme of a rainy day at home -*- lexical-binding:t -*-

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
;; Light theme of a rainy day at home, with grey daylight at the window.
;; The canvas is the overcast sky and the text ink in a notebook.
;; Keywords are the wet wood of the window frame, types a slate roof
;; and function definitions a blue umbrella; calls are rain ink,
;; strings wet brick and properties wet asphalt.  Numbers are a cup of
;; tea, constants a rusty gutter and preprocessor directives a clay pot
;; on the sill.  Builtins are a plum umbrella, variables rainwater in a
;; barrel, operators and brackets the drizzle, comments pencil, errors
;; a tail light, the cursor a raindrop and the selection a fogged
;; window pane.
;; Part of the `au-themes' collection.

;;; Code:

(require 'ef-themes)

(defconst au-pluvia-day-palette-partial
  '(;; Canvas & Chrome
    (cursor "#1e679a")                    ; Point / cursor indicator
    (bg-main "#b4b8bb")                   ; Primary canvas background
    (bg-dim "#acb0b3")                    ; Inactive windows, dim canvas
    (bg-alt "#9ea2a5")                    ; Subtle borders, alternating stripes
    (fg-main "#1a1a1b")                   ; Default buffer text
    (fg-dim "#5c5c5c")                    ; Comments, metadata
    (fg-alt "#3b494f")                    ; Section headings
    (fg-prop "#2f2c37")                   ; Struct properties
    (fg-var "#003c58")                    ; Variable definitions
    (bg-active "#a0a4a7")                 ; Active modeline frame, focused bars
    (bg-inactive "#acb0b3")               ; Inactive modeline
    (border "#83878a")                    ; Window dividers

    ;; Basic Chromatic Scale
    (red "#972a36")                       ; Errors, critical warnings
    (red-warmer "#442323")                ; String literals
    (red-cooler "#76382e")                ; Diff deletions, removal markers
    (red-faint "#576069")                 ; Structural brackets

    (green "#3b494f")                     ; Primitive types
    (green-warmer "#561401")              ; Constant values and macros
    (green-cooler "#3f3824")              ; Control keywords
    (green-faint "#5c5c5c")               ; Documentation strings, inline comments

    (yellow "#3f3824")                    ; Keyword alias
    (yellow-warmer "#5e4204")             ; Numeric literals
    (yellow-cooler "#79381c")             ; Preprocessor directives
    (yellow-faint "#19579f")              ; Informational tooltips, fringe markers

    (blue "#06537c")                      ; Function definitions
    (blue-warmer "#393f6a")               ; Function calls
    (blue-cooler "#5b5d5f")               ; Binary and unary operators
    (blue-faint "#5c3648")                ; Built-in functions

    (magenta "#3b494f")                   ; Composite types: struct, union, enum
    (magenta-warmer "#563c26")            ; Extended library types
    (magenta-cooler "#79381c")            ; Rare syntax nodes, special escapes
    (magenta-faint "#41494f")             ; Inactive conditional blocks

    (cyan "#3f3824")                      ; Keyword fallback
    (cyan-warmer "#79381c")               ; Preprocessor alias
    (cyan-cooler "#5b5d5f")               ; Operator alias
    (cyan-faint "#576069")                ; Punctuation delimiters

    ;; Panels, Diffs and Structural Highlights
    (bg-red-intense "#ce9e94")            ; Blocking errors, fatal assertion panel
    (bg-green-intense "#9db48d")          ; Success banner
    (bg-yellow-intense "#c3a681")         ; Warning banner, review request
    (bg-blue-intense "#86b2cc")           ; Info banner, active selections
    (bg-magenta-intense "#bc9fc3")        ; Special prompt background
    (bg-cyan-intense "#7fb8b0")           ; Incsearch current match target

    (bg-red-subtle "#bba39e")             ; Diff context deletion background
    (bg-green-subtle "#a2ae9a")           ; Diff context addition background
    (bg-yellow-subtle "#b5a795")          ; Diff whitespace/context change
    (bg-blue-subtle "#98adba")            ; Mode-line subtle indicators
    (bg-magenta-subtle "#b2a4b5")         ; Matching paren context background
    (bg-cyan-subtle "#95b0ac")            ; Structural block highlight

    (bg-added "#a4b995")                  ; Diff added line baseline
    (bg-added-faint "#adb8a5")            ; Diff added unchanged context
    (bg-added-refine "#9cb888")           ; Diff added word-level highlight
    (fg-added "#122500")                  ; Diff added foreground text

    (bg-changed "#c1af85")                ; Diff changed line baseline
    (bg-changed-faint "#bdb39c")          ; Diff changed unchanged context
    (bg-changed-refine "#c3ab72")         ; Diff changed word-level highlight
    (fg-changed "#231900")                ; Diff changed foreground text

    (bg-removed "#cca7a0")                ; Diff removed line baseline
    (bg-removed-faint "#c4afaa")          ; Diff removed unchanged context
    (bg-removed-refine "#d1a097")         ; Diff removed word-level highlight
    (fg-removed "#220000")                ; Diff removed foreground text

    (bg-mode-line-active "#adb1b4")       ; Active modeline surface
    (fg-mode-line-active "#1a1a1b")       ; Active modeline primary text
    (bg-completion "#919da7")             ; Minibuffer completion selected row
    (bg-popup "#a7abae")                  ; Autocomplete tooltip surface
    (bg-hover "#8295a3")                  ; Mouse hover overlay
    (bg-hover-secondary "#a49589")        ; Secondary hover overlay
    (bg-hl-line "#a8afb4")                ; Current line indicator
    (bg-paren-match "#928967")            ; Matching delimiter highlight
    (bg-err "#bea29c")                    ; Flymake error inline box
    (fg-warning "#7d5519")
    (bg-warning "#b7a692")                ; Flymake warning inline box
    (bg-info "#9babc0")                   ; Flymake info inline box
    (bg-region "#85929b")                 ; Marked region
    (fg-line-number-inactive "#6f757a"))) ; Inactive line numbers margin

(defconst au-pluvia-day-palette-mappings-partial
  '((err red)
    (warning fg-warning)
    (info yellow-faint)

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

(defconst au-pluvia-day-palette
  (modus-themes-generate-palette
   au-pluvia-day-palette-partial
   nil
   nil
   (append au-pluvia-day-palette-mappings-partial ef-themes-palette-common)))

;;;###theme-autoload
(modus-themes-theme
 'au-pluvia-day
 'ef-themes
 "Light theme of a rainy day at home."
 'light
 'au-pluvia-day-palette
 nil
 nil)

(provide 'au-pluvia-day-theme)
;;; au-pluvia-day-theme.el ends here
