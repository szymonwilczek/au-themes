;;; au-aurum-twilight-theme.el --- Intermediate dark theme with gold and purple accents -*- lexical-binding:t -*-

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
;; Dark theme with warm gold and subdued purple accents.
;; Calibrated for transitional ambient lighting and balanced visual pathway
;; excitation.
;; Part of the `au-themes' collection.

;;; Code:

(require 'ef-themes)

(defconst au-aurum-twilight-palette-partial
  '(;; Canvas & Chrome
    (cursor "#dca032")                    ; Point / cursor indicator
    (bg-main "#12100e")                   ; Primary canvas background
    (bg-dim "#1c1815")                    ; Inactive windows, dim canvas
    (bg-alt "#28221e")                    ; Subtle borders, alternating stripes
    (fg-main "#ada490")                   ; Default buffer text
    (fg-dim "#706658")                    ; Comments, metadata
    (fg-alt "#84967c")                    ; Struct properties
    (fg-var "#a89876")                    ; Variable definitions
    (bg-active "#3e3228")                 ; Active modeline frame, focused bars
    (bg-inactive "#1c1815")               ; Inactive modeline
    (border "#44382e")                    ; Window dividers

    ;; Basic Chromatic Scale
    (red "#b84c3e")                       ; Errors, critical warnings
    (red-warmer "#885c3c")                ; String literals
    (red-cooler "#a44638")                ; Diff deletions, removal markers
    (red-faint "#84786a")                 ; Structural brackets

    (green "#54a866")                     ; Primitive types
    (green-warmer "#9e4c38")              ; Constant values and macros
    (green-cooler "#b46a36")              ; Control keywords
    (green-faint "#706658")               ; Documentation strings, inline comments

    (yellow "#b46a36")                    ; Keyword alias
    (yellow-warmer "#c49c3e")             ; Numeric literals
    (yellow-cooler "#987a30")             ; Preprocessor directives
    (yellow-faint "#7a6e5c")              ; Informational tooltips, fringe markers

    (blue "#8e649a")                      ; Function definitions
    (blue-warmer "#ba90c8")               ; Function calls
    (blue-cooler "#847a6c")               ; Binary and unary operators
    (blue-faint "#4a8c72")                ; Built-in functions

    (magenta "#8e649a")                   ; Composite types: struct, union, enum
    (magenta-warmer "#ba90c8")            ; Extended library types
    (magenta-cooler "#765080")            ; Rare syntax nodes, special escapes
    (magenta-faint "#706658")             ; Inactive conditional blocks

    (cyan "#b46a36")                      ; Keyword fallback
    (cyan-warmer "#987a30")               ; Preprocessor alias
    (cyan-cooler "#847a6c")               ; Operator alias
    (cyan-faint "#7c7262")                ; Punctuation delimiters

    ;; Panels, Diffs and Structural Highlights
    (bg-red-intense "#6a1c16")            ; Blocking errors, fatal assertion panel
    (bg-green-intense "#2e4822")          ; Success banner
    (bg-yellow-intense "#583e10")         ; Warning banner, review request
    (bg-blue-intense "#40264a")           ; Info banner, active selections
    (bg-magenta-intense "#441e3e")        ; Special prompt background
    (bg-cyan-intense "#483614")           ; Incsearch current match target

    (bg-red-subtle "#341612")             ; Diff context deletion background
    (bg-green-subtle "#1c2a16")           ; Diff context addition background
    (bg-yellow-subtle "#2e2210")          ; Diff whitespace/context change
    (bg-blue-subtle "#281a30")            ; Mode-line subtle indicators
    (bg-magenta-subtle "#261628")         ; Matching paren context background
    (bg-cyan-subtle "#262012")            ; Structural block highlight

    (bg-added "#1e3412")                  ; Diff added line baseline
    (bg-added-faint "#12260a")            ; Diff added unchanged context
    (bg-added-refine "#2c481a")           ; Diff added word-level highlight
    (fg-added "#b2d88c")                  ; Diff added foreground text

    (bg-changed "#362e08")                ; Diff changed line baseline
    (bg-changed-faint "#262004")          ; Diff changed unchanged context
    (bg-changed-refine "#4a420e")         ; Diff changed word-level highlight
    (fg-changed "#e6c86a")                ; Diff changed foreground text

    (bg-removed "#46140e")                ; Diff removed line baseline
    (bg-removed-faint "#320c08")          ; Diff removed unchanged context
    (bg-removed-refine "#641c14")         ; Diff removed word-level highlight
    (fg-removed "#ffb8b0")                ; Diff removed foreground text

    (bg-mode-line-active "#221c18")       ; Active modeline surface
    (fg-mode-line-active "#b2a47e")       ; Active modeline primary text
    (bg-completion "#26201a")             ; Minibuffer completion selected row
    (bg-popup "#181412")                  ; Autocomplete tooltip surface
    (bg-hover "#342a22")                  ; Mouse hover overlay
    (bg-hover-secondary "#3e2e38")        ; Secondary hover overlay
    (bg-hl-line "#1e1915")                ; Current line indicator
    (bg-paren-match "#3c3822")            ; Matching delimiter highlight
    (bg-err "#3a1410")                    ; Flymake error inline box
    (bg-warning "#34260a")                ; Flymake warning inline box
    (bg-info "#1e2c14")                   ; Flymake info inline box
    (bg-region "#403222")                 ; Marked region
    (fg-line-number-inactive "#62584c"))) ; Inactive line numbers margin

(defconst au-aurum-twilight-palette-mappings-partial
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

(defconst au-aurum-twilight-palette
  (modus-themes-generate-palette
   au-aurum-twilight-palette-partial
   nil
   nil
   (append au-aurum-twilight-palette-mappings-partial ef-themes-palette-common)))

;;;###theme-autoload
(modus-themes-theme
 'au-aurum-twilight
 'ef-themes
 "Intermediate dark theme with gold and purple accents for transitional lighting."
 'dark
 'au-aurum-twilight-palette
 nil
 nil)

(provide 'au-aurum-twilight-theme)
;;; au-aurum-twilight-theme.el ends here
