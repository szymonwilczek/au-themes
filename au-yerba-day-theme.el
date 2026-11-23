;;; au-yerba-day-theme.el --- Light theme of a yerba mate gourd in daylight -*- lexical-binding:t -*-

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
;; Light theme of a yerba mate gourd in daylight.  The canvas is
;; dried yerba leaf, a pale greyish green, and the text is spent leaf
;; at the bottom of the gourd.  Keywords and the cursor are a fresh
;; leaf, variables a young shoot and types the gourd itself.  Function
;; definitions and builtins are overripe holly berries, calls lemon
;; verbena flowers and strings the alpaca silver of the bombilla.
;; Numbers are rosehip, constants the brew, preprocessor directives
;; yerba dust and properties cinnamon bark.  Operators are steam over
;; the water, brackets holly flowers, comments the foam, errors a ripe
;; berry and the selection a dried leaf.
;; Part of the `au-themes' collection.

;;; Code:

(require 'modus-themes)
(require 'au-themes)

(defconst au-themes-yerba-day-palette-partial
  '(;; Canvas & Chrome
    (cursor "#2f6323")                    ; Point / cursor indicator
    (bg-main "#dbd9c9")                   ; Primary canvas background
    (bg-dim "#d3d1c1")                    ; Inactive windows, dim canvas
    (bg-alt "#c4c2b3")                    ; Subtle borders, alternating stripes
    (fg-main "#2e3120")                   ; Default buffer text
    (fg-dim "#767351")                    ; Comments, metadata
    (fg-alt "#825a22")                    ; Section headings
    (fg-prop "#5e2e1d")                   ; Struct properties
    (fg-var "#3e5b00")                    ; Variable definitions
    (bg-active "#c6c4b5")                 ; Active modeline frame, focused bars
    (bg-inactive "#d3d1c1")               ; Inactive modeline
    (border "#a9a798")                    ; Window dividers

    ;; Basic Chromatic Scale
    (red "#a8454d")                       ; Errors, critical warnings
    (red-warmer "#4e5054")                ; String literals
    (red-cooler "#7a3430")                ; Diff deletions, removal markers
    (red-faint "#60614d")                 ; Structural brackets

    (green "#825a22")                     ; Primitive types
    (green-warmer "#6e6505")              ; Constant values and macros
    (green-cooler "#0d4604")              ; Control keywords
    (green-faint "#767351")               ; Documentation strings, inline comments

    (yellow "#0d4604")                    ; Keyword alias
    (yellow-warmer "#843d32")             ; Numeric literals
    (yellow-cooler "#4d4d19")             ; Preprocessor directives
    (yellow-faint "#5a4a17")              ; Informational tooltips, fringe markers

    (blue "#6d3052")                      ; Function definitions
    (blue-warmer "#534d6f")               ; Function calls
    (blue-cooler "#5d6565")               ; Binary and unary operators
    (blue-faint "#7e4f63")                ; Built-in functions

    (magenta "#825a22")                   ; Composite types: struct, union, enum
    (magenta-warmer "#775b45")            ; Extended library types
    (magenta-cooler "#4d4d19")            ; Rare syntax nodes, special escapes
    (magenta-faint "#69685e")             ; Inactive conditional blocks

    (cyan "#0d4604")                      ; Keyword fallback
    (cyan-warmer "#4d4d19")               ; Preprocessor alias
    (cyan-cooler "#5d6565")               ; Operator alias
    (cyan-faint "#60614d")                ; Punctuation delimiters

    ;; Panels, Diffs and Structural Highlights
    (bg-red-intense "#dca49c")            ; Blocking errors, fatal assertion panel
    (bg-green-intense "#99c097")          ; Success banner
    (bg-yellow-intense "#c1b380")         ; Warning banner, review request
    (bg-blue-intense "#93b7dc")           ; Info banner, active selections
    (bg-magenta-intense "#d3a3c0")        ; Special prompt background
    (bg-cyan-intense "#7dc2bf")           ; Incsearch current match target

    (bg-red-subtle "#e2c5c0")             ; Diff context deletion background
    (bg-green-subtle "#bfd3bd")           ; Diff context addition background
    (bg-yellow-subtle "#d4cdb2")          ; Diff whitespace/context change
    (bg-blue-subtle "#bccfe1")            ; Mode-line subtle indicators
    (bg-magenta-subtle "#ddc5d1")         ; Matching paren context background
    (bg-cyan-subtle "#b4d5d1")            ; Structural block highlight

    (bg-added "#c6e2c4")                  ; Diff added line baseline
    (bg-added-faint "#dbecd8")            ; Diff added unchanged context
    (bg-added-refine "#b1daaf")           ; Diff added word-level highlight
    (fg-added "#1d5522")                  ; Diff added foreground text

    (bg-changed "#e3dab3")                ; Diff changed line baseline
    (bg-changed-faint "#ece6ce")          ; Diff changed unchanged context
    (bg-changed-refine "#dbcd98")         ; Diff changed word-level highlight
    (fg-changed "#554702")                ; Diff changed foreground text

    (bg-removed "#f9cec6")                ; Diff removed line baseline
    (bg-removed-faint "#fadfda")          ; Diff removed unchanged context
    (bg-removed-refine "#f7bcb4")         ; Diff removed word-level highlight
    (fg-removed "#742e2b")                ; Diff removed foreground text

    (bg-mode-line-active "#c2c1b2")       ; Active modeline surface
    (fg-mode-line-active "#2e3120")       ; Active modeline primary text
    (bg-completion "#bebcab")             ; Minibuffer completion selected row
    (bg-popup "#ceccbd")                  ; Autocomplete tooltip surface
    (bg-hover "#b6b39c")                  ; Mouse hover overlay
    (bg-hover-secondary "#c5b5a8")        ; Secondary hover overlay
    (bg-hl-line "#d2cfbd")                ; Current line indicator
    (bg-paren-match "#b2aa85")            ; Matching delimiter highlight
    (bg-err "#e9c7c1")                    ; Flymake error inline box
    (bg-warning "#d8d1b1")                ; Flymake warning inline box
    (bg-info "#c1d8be")                   ; Flymake info inline box
    (bg-region "#afb792")                 ; Marked region
    (fg-line-number-inactive "#969487"))) ; Inactive line numbers margin

(defconst au-themes-yerba-day-palette-mappings-partial
  '((err red)
    (warning yellow)
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

(defconst au-themes-yerba-day-palette
  (modus-themes-generate-palette
   au-themes-yerba-day-palette-partial
   nil
   nil
   (append au-themes-yerba-day-palette-mappings-partial au-themes-palette-common)))

;;;###theme-autoload
(modus-themes-theme
 'au-yerba-day
 'au-themes
 "Light theme of a yerba mate gourd in daylight."
 'light
 'au-themes-yerba-day-palette
 nil
 nil)

(provide 'au-yerba-day-theme)
;;; au-yerba-day-theme.el ends here
