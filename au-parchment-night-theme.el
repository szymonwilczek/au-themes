;;; au-parchment-night-theme.el --- Low-chroma nocturnal theme with typographic emphasis -*- lexical-binding:t -*-

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
;; Monochrome-leaning dark theme with low chromatic entropy.
;; Uses typographic italics and luminance steps instead of color contrasts
;; to suppress visual noise.
;; Part of the `au-themes' collection.

;;; Code:

(require 'ef-themes)

(defconst au-parchment-night-palette-partial
  '(;; Canvas & Chrome
    (cursor "#beaa84")                    ; Point / cursor indicator
    (bg-main "#18130e")                   ; Primary canvas background
    (bg-dim "#221b14")                    ; Inactive windows, dim canvas
    (bg-alt "#2c221a")                    ; Subtle borders, alternating stripes
    (fg-main "#a29a88")                   ; Default buffer text
    (fg-dim "#665c4e")                    ; Comments, metadata
    (fg-alt "#987e72")                    ; Struct properties
    (fg-var "#a89880")                    ; Variable definitions
    (bg-active "#34281e")                 ; Active modeline frame, focused bars
    (bg-inactive "#221b14")               ; Inactive modeline
    (border "#443426")                    ; Window dividers

    ;; Basic Chromatic Scale
    (red "#aa4238")                       ; Errors, critical warnings
    (red-warmer "#88737c")                ; String literals
    (red-cooler "#9e3e34")                ; Diff deletions, removal markers
    (red-faint "#736b5d")                 ; Structural brackets

    (green "#88967e")                     ; Primitive types
    (green-warmer "#b4bea6")              ; Constant values and macros
    (green-cooler "#6c7158")              ; Control keywords
    (green-faint "#665c4e")               ; Documentation strings, inline comments

    (yellow "#6c7158")                    ; Keyword alias
    (yellow-warmer "#b2959c")             ; Numeric literals
    (yellow-cooler "#706556")             ; Preprocessor directives
    (yellow-faint "#786c5c")              ; Informational tooltips, fringe markers

    (blue "#646c5a")                      ; Function definitions
    (blue-warmer "#80646f")               ; Function calls
    (blue-cooler "#787062")               ; Binary and unary operators
    (blue-faint "#9e8184")                ; Built-in functions

    (magenta "#88967e")                   ; Composite types: struct, union, enum
    (magenta-warmer "#80646f")            ; Extended library types
    (magenta-cooler "#706556")            ; Rare syntax nodes, special escapes
    (magenta-faint "#665c4e")             ; Inactive conditional blocks

    (cyan "#6c7158")                      ; Keyword fallback
    (cyan-warmer "#706556")               ; Preprocessor alias
    (cyan-cooler "#787062")               ; Operator alias
    (cyan-faint "#686054")                ; Punctuation delimiters

    ;; Panels, Diffs and Structural Highlights
    (bg-red-intense "#5a1e18")            ; Blocking errors, fatal assertion panel
    (bg-green-intense "#26361e")          ; Success banner
    (bg-yellow-intense "#463414")         ; Warning banner, review request
    (bg-blue-intense "#28323c")           ; Info banner, active selections
    (bg-magenta-intense "#3c2438")        ; Special prompt background
    (bg-cyan-intense "#203834")           ; Incsearch current match target

    (bg-red-subtle "#321a16")             ; Diff context deletion background
    (bg-green-subtle "#1c241a")           ; Diff context addition background
    (bg-yellow-subtle "#2a2414")          ; Diff whitespace/context change
    (bg-blue-subtle "#1e2024")            ; Mode-line subtle indicators
    (bg-magenta-subtle "#281e26")         ; Matching paren context background
    (bg-cyan-subtle "#1a2422")            ; Structural block highlight

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

    (bg-mode-line-active "#261e16")       ; Active modeline surface
    (fg-mode-line-active "#a89880")       ; Active modeline primary text
    (bg-completion "#2c2218")             ; Minibuffer completion selected row
    (bg-popup "#1e1610")                  ; Autocomplete tooltip surface
    (bg-hover "#382c20")                  ; Mouse hover overlay
    (bg-hover-secondary "#423226")        ; Secondary hover overlay
    (bg-hl-line "#221a14")                ; Current line indicator
    (bg-paren-match "#443422")            ; Matching delimiter highlight
    (bg-err "#3e1612")                    ; Flymake error inline box
    (bg-warning "#38280c")                ; Flymake warning inline box
    (bg-info "#202e14")                   ; Flymake info inline box
    (bg-region "#343311")                 ; Marked region
    (fg-line-number-inactive "#665c4e"))) ; Inactive line numbers margin

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
  '(`(font-lock-keyword-face ((,c :slant italic :foreground ,keyword)))
    `(font-lock-builtin-face ((,c :slant italic :foreground ,builtin)))
    `(font-lock-comment-face ((,c :slant italic :foreground ,comment)))
    `(font-lock-doc-face ((,c :slant italic :foreground ,docstring)))
    `(font-lock-type-face ((,c :slant italic :foreground ,type)))))

;;;###theme-autoload
(modus-themes-theme
 'au-parchment-night
 'ef-themes
 "Low-chroma nocturnal theme with typographic italics and minimal color variance."
 'dark
 'au-parchment-night-palette
 nil
 nil
 'au-parchment-night-custom-faces)

(provide 'au-parchment-night-theme)
;;; au-parchment-night-theme.el ends here
