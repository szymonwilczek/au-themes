;;; au-perseida-night-theme.el --- Optically black dark theme of an August meteor night -*- lexical-binding:t -*-

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
;; Dark theme on an optically black canvas: the moonless sky of the
;; Perseid maximum.  The canvas adds about as much light as the panel
;; already shows at black, the darkest canvas the halation and pattern
;; glare gates allow, and the header line, tab bar and fringe share it,
;; so the frame edge fades into the bezel.  Text is dimmed to match, so
;; letters do not spread on the black.  Four syntax roles take the
;; colours of named stars, held in their spectral order on the
;; Planckian locus; keywords glow in the H-alpha rose of the California
;; Nebula, the preprocessor in the [O III] teal of the Ring Nebula and
;; builtins in the green of a Perseid, and a blue-white star marks
;; the cursor.
;; Part of the `au-themes' collection.

;;; Code:

(require 'ef-themes)

(defconst au-perseida-night-palette-partial
  '(;; Canvas & Chrome
    (cursor "#8ea9c5")                    ; Point / cursor indicator
    (bg-main "#080808")                   ; Primary canvas background
    (bg-dim "#101114")                    ; Inactive windows, dim canvas
    (bg-alt "#18191c")                    ; Subtle borders, alternating stripes
    (fg-main "#84878a")                   ; Default buffer text
    (fg-dim "#5a564f")                    ; Comments, metadata
    (fg-alt "#6d7bad")                    ; Section headings
    (fg-prop "#837436")                   ; Struct properties
    (fg-var "#397289")                    ; Variable definitions
    (bg-active "#24262c")                 ; Active modeline frame, focused bars
    (bg-inactive "#18191c")               ; Inactive modeline
    (border "#27292e")                    ; Window dividers

    ;; Basic Chromatic Scale
    (red "#c04b55")                       ; Errors, critical warnings
    (red-warmer "#9b5244")                ; String literals
    (red-cooler "#c67676")                ; Diff deletions, removal markers
    (red-faint "#52575d")                 ; Structural brackets

    (green "#a3794b")                     ; Primitive types
    (green-warmer "#506086")              ; Constant values and macros
    (green-cooler "#84526a")              ; Control keywords
    (green-faint "#57534c")               ; Documentation strings, inline comments

    (yellow "#ae772f")                    ; Keyword alias
    (yellow-warmer "#847564")             ; Numeric literals
    (yellow-cooler "#498282")             ; Preprocessor directives
    (yellow-faint "#5c8193")              ; Informational tooltips, fringe markers

    (blue "#857492")                      ; Function definitions
    (blue-warmer "#6e73b4")               ; Function calls
    (blue-cooler "#5b5f64")               ; Binary and unary operators
    (blue-faint "#588c66")                ; Built-in functions

    (magenta "#8e6a44")                   ; Composite types: struct, union, enum
    (magenta-warmer "#846851")            ; Extended library types
    (magenta-cooler "#4f7c7f")            ; Rare syntax nodes, special escapes
    (magenta-faint "#504d48")             ; Inactive conditional blocks

    (cyan "#68615c")                      ; Keyword fallback
    (cyan-warmer "#3f726e")               ; Preprocessor alias
    (cyan-cooler "#686c71")               ; Operator alias
    (cyan-faint "#60656b")                ; Punctuation delimiters

    ;; Panels, Diffs and Structural Highlights
    (bg-red-intense "#4f1a18")            ; Blocking errors, fatal assertion panel
    (bg-green-intense "#18361a")          ; Success banner
    (bg-yellow-intense "#3c2f04")         ; Warning banner, review request
    (bg-blue-intense "#282d4e")           ; Info banner, active selections
    (bg-magenta-intense "#442032")        ; Special prompt background
    (bg-cyan-intense "#033633")           ; Incsearch current match target

    (bg-red-subtle "#240f0e")             ; Diff context deletion background
    (bg-green-subtle "#0d1a0d")           ; Diff context addition background
    (bg-yellow-subtle "#1b1505")          ; Diff whitespace/context change
    (bg-blue-subtle "#111526")            ; Mode-line subtle indicators
    (bg-magenta-subtle "#201018")         ; Matching paren context background
    (bg-cyan-subtle "#071a18")            ; Structural block highlight

    (bg-added "#112812")                  ; Diff added line baseline
    (bg-added-faint "#0d1d0e")            ; Diff added unchanged context
    (bg-added-refine "#163918")           ; Diff added word-level highlight
    (fg-added "#69a26b")                  ; Diff added foreground text

    (bg-changed "#2c2303")                ; Diff changed line baseline
    (bg-changed-faint "#1d1804")          ; Diff changed unchanged context
    (bg-changed-refine "#3d3200")         ; Diff changed word-level highlight
    (fg-changed "#be9042")                ; Diff changed foreground text

    (bg-removed "#391415")                ; Diff removed line baseline
    (bg-removed-faint "#281011")          ; Diff removed unchanged context
    (bg-removed-refine "#511c1f")         ; Diff removed word-level highlight
    (fg-removed "#cf7f7e")                ; Diff removed foreground text

    (bg-mode-line-active "#17181c")       ; Active modeline surface
    (fg-mode-line-active "#8b8f95")       ; Active modeline primary text
    (bg-completion "#1e212e")             ; Minibuffer completion selected row
    (bg-popup "#0e0f12")                  ; Autocomplete tooltip surface
    (bg-hover "#282c42")                  ; Mouse hover overlay
    (bg-hover-secondary "#37273a")        ; Secondary hover overlay
    (bg-hl-line "#141517")                ; Current line indicator
    (bg-paren-match "#3c2e14")            ; Matching delimiter highlight
    (bg-err "#2b0e0c")                    ; Flymake error inline box
    (bg-warning "#231502")                ; Flymake warning inline box
    (bg-info "#0f1c10")                   ; Flymake info inline box
    (bg-region "#31303c")                 ; Marked region
    (fg-line-number-inactive "#53555a"))) ; Inactive line numbers margin

(defconst au-perseida-night-palette-mappings-partial
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

(defconst au-perseida-night-palette
  (modus-themes-generate-palette
   au-perseida-night-palette-partial
   nil
   nil
   (append au-perseida-night-palette-mappings-partial ef-themes-palette-common)))

;;;###theme-autoload
(modus-themes-theme
 'au-perseida-night
 'ef-themes
 "Optically black dark theme of an August meteor night, with star-coloured syntax."
 'dark
 'au-perseida-night-palette
 nil
 nil)

(provide 'au-perseida-night-theme)
;;; au-perseida-night-theme.el ends here
