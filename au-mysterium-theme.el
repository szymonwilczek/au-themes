;;; au-mysterium-theme.el --- Dark Halloween theme of an old painted van -*- lexical-binding:t -*-

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
;; Dark theme for Halloween, the night of a haunted mansion and the old
;; painted van parked outside it: teal bodywork, violet, orange, dry
;; green and a gold tag on black.  A seasonal one-off with no day
;; variant, so its name carries no `-night' suffix.
;; Part of the `au-themes' collection.

;;; Code:

(require 'ef-themes)

(defconst au-mysterium-palette-partial
  '(;; Canvas & Chrome
    (cursor "#f68f1d")                    ; Point / cursor indicator
    (bg-main "#0e0d0d")                   ; Primary canvas background
    (bg-dim "#16171a")                    ; Inactive windows, dim canvas
    (bg-alt "#1e1f22")                    ; Subtle borders, alternating stripes
    (fg-main "#a49b90")                   ; Default buffer text
    (fg-dim "#795247")                    ; Comments, metadata
    (fg-alt "#9ba749")                    ; Section headings
    (fg-prop "#c8807d")                   ; Struct properties
    (fg-var "#b4b088")                    ; Variable definitions
    (bg-active "#2a2c33")                 ; Active modeline frame, focused bars
    (bg-inactive "#1e1f22")               ; Inactive modeline
    (border "#2e2f35")                    ; Window dividers

    ;; Basic Chromatic Scale
    (red "#da6257")                       ; Errors, critical warnings
    (red-warmer "#b66634")                ; String literals
    (red-cooler "#d0897d")                ; Diff deletions, removal markers
    (red-faint "#837059")                 ; Structural brackets

    (green "#9ba749")                     ; Primitive types
    (green-warmer "#b68ab9")              ; Constant values and macros
    (green-cooler "#3d9796")              ; Control keywords
    (green-faint "#795247")               ; Documentation strings, inline comments

    (yellow "#3d9796")                    ; Keyword alias
    (yellow-warmer "#b19730")             ; Numeric literals
    (yellow-cooler "#aa4b6a")             ; Preprocessor directives
    (yellow-faint "#7bc6ba")              ; Informational tooltips, fringe markers

    (blue "#9b64a7")                      ; Function definitions
    (blue-warmer "#b88b4f")               ; Function calls
    (blue-cooler "#827d6e")               ; Binary and unary operators
    (blue-faint "#926432")                ; Built-in functions

    (magenta "#9ba749")                   ; Composite types: struct, union, enum
    (magenta-warmer "#9a7d65")            ; Extended library types
    (magenta-cooler "#aa4b6a")            ; Rare syntax nodes, special escapes
    (magenta-faint "#776b6e")             ; Inactive conditional blocks

    (cyan "#3d9796")                      ; Keyword fallback
    (cyan-warmer "#aa4b6a")               ; Preprocessor alias
    (cyan-cooler "#827d6e")               ; Operator alias
    (cyan-faint "#837059")                ; Punctuation delimiters

    ;; Panels, Diffs and Structural Highlights
    (bg-red-intense "#5c3029")            ; Blocking errors, fatal assertion panel
    (bg-green-intense "#2a4726")          ; Success banner
    (bg-yellow-intense "#5c3127")         ; Warning banner, review request
    (bg-blue-intense "#14435c")           ; Info banner, active selections
    (bg-magenta-intense "#4e3354")        ; Special prompt background
    (bg-cyan-intense "#034943")           ; Incsearch current match target

    (bg-red-subtle "#2d1916")             ; Diff context deletion background
    (bg-green-subtle "#172315")           ; Diff context addition background
    (bg-yellow-subtle "#2d1a15")          ; Diff whitespace/context change
    (bg-blue-subtle "#0f222c")            ; Mode-line subtle indicators
    (bg-magenta-subtle "#261a29")         ; Matching paren context background
    (bg-cyan-subtle "#0b2421")            ; Structural block highlight

    (bg-added "#0b2908")                  ; Diff added line baseline
    (bg-added-faint "#0f1e0d")            ; Diff added unchanged context
    (bg-added-refine "#0d3e07")           ; Diff added word-level highlight
    (fg-added "#6cbf61")                  ; Diff added foreground text

    (bg-changed "#311d00")                ; Diff changed line baseline
    (bg-changed-faint "#231706")          ; Diff changed unchanged context
    (bg-changed-refine "#482c01")         ; Diff changed word-level highlight
    (fg-changed "#e3a34d")                ; Diff changed foreground text

    (bg-removed "#3c120c")                ; Diff removed line baseline
    (bg-removed-faint "#28120f")          ; Diff removed unchanged context
    (bg-removed-refine "#5b1911")         ; Diff removed word-level highlight
    (fg-removed "#f6826f")                ; Diff removed foreground text

    (bg-mode-line-active "#1d1e22")       ; Active modeline surface
    (fg-mode-line-active "#a49b90")       ; Active modeline primary text
    (bg-completion "#232835")             ; Minibuffer completion selected row
    (bg-popup "#141518")                  ; Autocomplete tooltip surface
    (bg-hover "#2d3349")                  ; Mouse hover overlay
    (bg-hover-secondary "#442f1f")        ; Secondary hover overlay
    (bg-hl-line "#1a1b1d")                ; Current line indicator
    (bg-paren-match "#43351b")            ; Matching delimiter highlight
    (bg-err "#2f1a16")                    ; Flymake error inline box
    (fg-warning "#b92e0e")
    (bg-warning "#2f1a15")                ; Flymake warning inline box
    (bg-info "#092622")                   ; Flymake info inline box
    (bg-region "#322b3b")                 ; Marked region
    (fg-line-number-inactive "#5c5d63"))) ; Inactive line numbers margin

(defconst au-mysterium-palette-mappings-partial
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

(defconst au-mysterium-palette
  (modus-themes-generate-palette
   au-mysterium-palette-partial
   nil
   nil
   (append au-mysterium-palette-mappings-partial ef-themes-palette-common)))

;;;###theme-autoload
(modus-themes-theme
 'au-mysterium
 'ef-themes
 "Dark Halloween theme of an old painted van."
 'dark
 'au-mysterium-palette
 nil
 nil)

(provide 'au-mysterium-theme)
;;; au-mysterium-theme.el ends here
