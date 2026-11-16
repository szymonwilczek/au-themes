;;; au-pluvia-night-theme.el --- Dark theme of a rainy night at home -*- lexical-binding:t -*-

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
;; Dark theme of a rainy night at home, seen through the window.
;; The canvas is the black of a wet night and the text the plain grey
;; light of rain.  Keywords are wet stone, types the sky in a puddle
;; and function definitions a deep puddle; calls are rain on the pane,
;; strings the stream along the kerb and properties water in the
;; gutter.  The warmth is light reflected in the wet: numbers are the
;; bulb behind a curtain, constants lamplight on the curtain and
;; preprocessor directives wet brick.  Builtins are a plum umbrella,
;; variables mist, operators and brackets the drizzle, comments wet
;; asphalt, errors a tail light, the cursor a raindrop and the
;; selection a fogged window pane.
;; Part of the `au-themes' collection.

;;; Code:

(require 'modus-themes)
(require 'au-themes)

(defconst au-pluvia-night-palette-partial
  '(;; Canvas & Chrome
    (cursor "#518892")                    ; Point / cursor indicator
    (bg-main "#0e1011")                   ; Primary canvas background
    (bg-dim "#131517")                    ; Inactive windows, dim canvas
    (bg-alt "#1e2021")                    ; Subtle borders, alternating stripes
    (fg-main "#9e9e9e")                   ; Default buffer text
    (fg-dim "#525961")                    ; Comments, metadata
    (fg-alt "#72a1a8")                    ; Section headings
    (fg-prop "#528b96")                   ; Struct properties
    (fg-var "#8fadc6")                    ; Variable definitions
    (bg-active "#1c1f20")                 ; Active modeline frame, focused bars
    (bg-inactive "#131517")               ; Inactive modeline
    (border "#343637")                    ; Window dividers

    ;; Basic Chromatic Scale
    (red "#cb6d67")                       ; Errors, critical warnings
    (red-warmer "#4c716c")                ; String literals
    (red-cooler "#d08a78")                ; Diff deletions, removal markers
    (red-faint "#767676")                 ; Structural brackets

    (green "#72a1a8")                     ; Primitive types
    (green-warmer "#baab92")              ; Constant values and macros
    (green-cooler "#8a8b7d")              ; Control keywords
    (green-faint "#525961")               ; Documentation strings, inline comments

    (yellow "#8a8b7d")                    ; Keyword alias
    (yellow-warmer "#b9956c")             ; Numeric literals
    (yellow-cooler "#7b6252")             ; Preprocessor directives
    (yellow-faint "#8e866b")              ; Informational tooltips, fringe markers

    (blue "#2b75a8")                      ; Function definitions
    (blue-warmer "#6d94bf")               ; Function calls
    (blue-cooler "#737373")               ; Binary and unary operators
    (blue-faint "#927485")                ; Built-in functions

    (magenta "#72a1a8")                   ; Composite types: struct, union, enum
    (magenta-warmer "#9d8068")            ; Extended library types
    (magenta-cooler "#7b6252")            ; Rare syntax nodes, special escapes
    (magenta-faint "#697479")             ; Inactive conditional blocks

    (cyan "#8a8b7d")                      ; Keyword fallback
    (cyan-warmer "#7b6252")               ; Preprocessor alias
    (cyan-cooler "#737373")               ; Operator alias
    (cyan-faint "#767676")                ; Punctuation delimiters

    ;; Panels, Diffs and Structural Highlights
    (bg-red-intense "#5b342a")            ; Blocking errors, fatal assertion panel
    (bg-green-intense "#1f4935")          ; Success banner
    (bg-yellow-intense "#4e3d16")         ; Warning banner, review request
    (bg-blue-intense "#1b455b")           ; Info banner, active selections
    (bg-magenta-intense "#4e3553")        ; Special prompt background
    (bg-cyan-intense "#0c4a44")           ; Incsearch current match target

    (bg-red-subtle "#2d1b17")             ; Diff context deletion background
    (bg-green-subtle "#13251b")           ; Diff context addition background
    (bg-yellow-subtle "#271f0f")          ; Diff whitespace/context change
    (bg-blue-subtle "#11232d")            ; Mode-line subtle indicators
    (bg-magenta-subtle "#271c29")         ; Matching paren context background
    (bg-cyan-subtle "#0e2522")            ; Structural block highlight

    (bg-added "#16261d")                  ; Diff added line baseline
    (bg-added-faint "#141c17")            ; Diff added unchanged context
    (bg-added-refine "#21392c")           ; Diff added word-level highlight
    (fg-added "#98bea8")                  ; Diff added foreground text

    (bg-changed "#2a2009")                ; Diff changed line baseline
    (bg-changed-faint "#1e190d")          ; Diff changed unchanged context
    (bg-changed-refine "#3f3109")         ; Diff changed word-level highlight
    (fg-changed "#ceb67d")                ; Diff changed foreground text

    (bg-removed "#301b16")                ; Diff removed line baseline
    (bg-removed-faint "#221613")          ; Diff removed unchanged context
    (bg-removed-refine "#492921")         ; Diff removed word-level highlight
    (fg-removed "#e1a89a")                ; Diff removed foreground text

    (bg-mode-line-active "#1f2122")       ; Active modeline surface
    (fg-mode-line-active "#9e9e9e")       ; Active modeline primary text
    (bg-completion "#1a262c")             ; Minibuffer completion selected row
    (bg-popup "#17191a")                  ; Autocomplete tooltip surface
    (bg-hover "#1b2f38")                  ; Mouse hover overlay
    (bg-hover-secondary "#30241a")        ; Secondary hover overlay
    (bg-hl-line "#131719")                ; Current line indicator
    (bg-paren-match "#3b3312")            ; Matching delimiter highlight
    (bg-err "#2f1a15")                    ; Flymake error inline box
    (fg-warning "#d2ac5a")
    (bg-warning "#281f0b")                ; Flymake warning inline box
    (bg-info "#26200c")                   ; Flymake info inline box
    (bg-region "#2f3a41")                 ; Marked region
    (fg-line-number-inactive "#565c60"))) ; Inactive line numbers margin

(defconst au-pluvia-night-palette-mappings-partial
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

(defconst au-pluvia-night-palette
  (modus-themes-generate-palette
   au-pluvia-night-palette-partial
   nil
   nil
   (append au-pluvia-night-palette-mappings-partial au-themes-palette-common)))

;;;###theme-autoload
(modus-themes-theme
 'au-pluvia-night
 'au-themes
 "Dark theme of a rainy night at home."
 'dark
 'au-pluvia-night-palette
 nil
 nil)

(provide 'au-pluvia-night-theme)
;;; au-pluvia-night-theme.el ends here
