;;; au-yerba-night-theme.el --- Dark theme of a yerba mate gourd at night -*- lexical-binding:t -*-

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
;; Dark theme of a yerba mate gourd at night.  The canvas is a dark,
;; faintly olive night, and the text is the foam of the brew.
;; Keywords are a fresh leaf, variables a young shoot and types orange
;; peel.  Function definitions and builtins are overripe holly
;; berries, calls peperina flowers and strings the alpaca silver of
;; the bombilla.  Numbers are rosehip, constants yerba dust,
;; preprocessor directives cinnamon bark and properties holly
;; flowers.  Operators are steam over the water, brackets a boldo
;; leaf, comments the spent leaf, errors a ripe berry, the cursor the
;; brew and the selection a dried leaf.
;; Part of the `au-themes' collection.

;;; Code:

(require 'modus-themes)
(require 'au-themes)

(defconst au-themes-yerba-night-palette-partial
  '(;; Canvas & Chrome
    (cursor "#bbac55")                    ; Point / cursor indicator
    (bg-main "#0d0e0a")                   ; Primary canvas background
    (bg-dim "#13130f")                    ; Inactive windows, dim canvas
    (bg-alt "#1d1d19")                    ; Subtle borders, alternating stripes
    (fg-main "#a19f8a")                   ; Default buffer text
    (fg-dim "#5f624f")                    ; Comments, metadata
    (fg-alt "#ce8844")                    ; Section headings
    (fg-prop "#8a8c6c")                   ; Struct properties
    (fg-var "#7da346")                    ; Variable definitions
    (bg-active "#1c1c18")                 ; Active modeline frame, focused bars
    (bg-inactive "#13130f")               ; Inactive modeline
    (border "#33332f")                    ; Window dividers

    ;; Basic Chromatic Scale
    (red "#b85454")                       ; Errors, critical warnings
    (red-warmer "#898c8f")                ; String literals
    (red-cooler "#d6857f")                ; Diff deletions, removal markers
    (red-faint "#6d7559")                 ; Structural brackets

    (green "#ce8844")                     ; Primitive types
    (green-warmer "#afae7b")              ; Constant values and macros
    (green-cooler "#477c3b")              ; Control keywords
    (green-faint "#5f624f")               ; Documentation strings, inline comments

    (yellow "#477c3b")                    ; Keyword alias
    (yellow-warmer "#ba6e62")             ; Numeric literals
    (yellow-cooler "#96624e")             ; Preprocessor directives
    (yellow-faint "#938969")              ; Informational tooltips, fringe markers

    (blue "#8e5e74")                      ; Function definitions
    (blue-warmer "#776793")               ; Function calls
    (blue-cooler "#707879")               ; Binary and unary operators
    (blue-faint "#ae7f9c")                ; Built-in functions

    (magenta "#ce8844")                   ; Composite types: struct, union, enum
    (magenta-warmer "#9a7d65")            ; Extended library types
    (magenta-cooler "#96624e")            ; Rare syntax nodes, special escapes
    (magenta-faint "#6f7066")             ; Inactive conditional blocks

    (cyan "#477c3b")                      ; Keyword fallback
    (cyan-warmer "#96624e")               ; Preprocessor alias
    (cyan-cooler "#767e7f")               ; Operator alias
    (cyan-faint "#6d7559")                ; Punctuation delimiters

    ;; Panels, Diffs and Structural Highlights
    (bg-red-intense "#683834")            ; Blocking errors, fatal assertion panel
    (bg-green-intense "#2e522f")          ; Success banner
    (bg-yellow-intense "#544714")         ; Warning banner, review request
    (bg-blue-intense "#284a6c")           ; Info banner, active selections
    (bg-magenta-intense "#613854")        ; Special prompt background
    (bg-cyan-intense "#015353")           ; Incsearch current match target

    (bg-red-subtle "#36201e")             ; Diff context deletion background
    (bg-green-subtle "#1b2b1c")           ; Diff context addition background
    (bg-yellow-subtle "#2c2612")          ; Diff whitespace/context change
    (bg-blue-subtle "#192837")            ; Mode-line subtle indicators
    (bg-magenta-subtle "#32202c")         ; Matching paren context background
    (bg-cyan-subtle "#0e2c2c")            ; Structural block highlight

    (bg-added "#132a14")                  ; Diff added line baseline
    (bg-added-faint "#0f1c10")            ; Diff added unchanged context
    (bg-added-refine "#1b3f1d")           ; Diff added word-level highlight
    (fg-added "#88c28a")                  ; Diff added foreground text

    (bg-changed "#2c2303")                ; Diff changed line baseline
    (bg-changed-faint "#1d1807")          ; Diff changed unchanged context
    (bg-changed-refine "#403400")         ; Diff changed word-level highlight
    (fg-changed "#c5b164")                ; Diff changed foreground text

    (bg-removed "#391917")                ; Diff removed line baseline
    (bg-removed-faint "#251311")          ; Diff removed unchanged context
    (bg-removed-refine "#542523")         ; Diff removed word-level highlight
    (fg-removed "#ea9891")                ; Diff removed foreground text

    (bg-mode-line-active "#1e1e1a")       ; Active modeline surface
    (fg-mode-line-active "#a19f8a")       ; Active modeline primary text
    (bg-completion "#222317")             ; Minibuffer completion selected row
    (bg-popup "#161612")                  ; Autocomplete tooltip surface
    (bg-hover "#2a2a19")                  ; Mouse hover overlay
    (bg-hover-secondary "#2d2118")        ; Secondary hover overlay
    (bg-hl-line "#14140e")                ; Current line indicator
    (bg-paren-match "#38300f")            ; Matching delimiter highlight
    (bg-err "#321a18")                    ; Flymake error inline box
    (bg-warning "#282109")                ; Flymake warning inline box
    (bg-info "#152715")                   ; Flymake info inline box
    (bg-region "#282e0f")                 ; Marked region
    (fg-line-number-inactive "#585952"))) ; Inactive line numbers margin

(defconst au-themes-yerba-night-palette-mappings-partial
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

(defconst au-themes-yerba-night-palette
  (modus-themes-generate-palette
   au-themes-yerba-night-palette-partial
   nil
   nil
   (append au-themes-yerba-night-palette-mappings-partial au-themes-palette-common)))

;;;###theme-autoload
(modus-themes-theme
 'au-yerba-night
 'au-themes
 "Dark theme of a yerba mate gourd at night."
 'dark
 'au-themes-yerba-night-palette
 nil
 nil)

(provide 'au-yerba-night-theme)
;;; au-yerba-night-theme.el ends here
