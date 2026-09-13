;;; au-parchment-day-theme.el --- Low-chroma daylight theme with typographic emphasis -*- lexical-binding:t -*-

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
;; Monochrome-leaning light theme with low chromatic entropy.
;; Uses typographic italics and luminance steps instead of color contrasts
;; to suppress visual noise.
;; Part of the `au-themes' collection.

;;; Code:

(require 'ef-themes)

(defconst au-parchment-day-palette-partial
  '(;; Canvas & Chrome
    (cursor "#62564c")                 ; Point / cursor indicator
    (bg-main "#ded6c4")                ; Primary canvas background
    (bg-dim "#d2cbba")                 ; Inactive windows, dim canvas
    (bg-alt "#c6bfad")                 ; Subtle borders, alternating stripes
    (fg-main "#282420")                ; Default buffer text
    (fg-dim "#685e50")                 ; Comments, metadata
    (fg-alt "#645962")                 ; Struct properties
    (fg-var "#282420")                 ; Variable definitions
    (bg-active "#c8c0ae")              ; Active modeline frame, focused bars
    (bg-inactive "#d2cbba")            ; Inactive modeline
    (border "#a49b88")                 ; Window dividers

    ;; Basic Chromatic Scale
    (red "#9e3a2a")                    ; Errors, critical warnings
    (red-warmer "#463726")             ; String literals
    (red-cooler "#9e3a2a")             ; Diff deletions, removal markers
    (red-faint "#4e4840")              ; Structural brackets

    (green "#665f48")                  ; Primitive types
    (green-warmer "#5c634e")           ; Constant values and macros
    (green-cooler "#363f2c")           ; Control keywords
    (green-faint "#685e50")            ; Documentation strings, inline comments

    (yellow "#363f2c")                 ; Keyword alias
    (yellow-warmer "#6e594c")          ; Numeric literals
    (yellow-cooler "#442b28")          ; Preprocessor directives
    (yellow-faint "#726858")           ; Informational tooltips, fringe markers

    (blue "#404138")                   ; Function definitions
    (blue-warmer "#564740")            ; Function calls
    (blue-cooler "#524c44")            ; Binary and unary operators
    (blue-faint "#765b5c")             ; Built-in functions

    (magenta "#665f48")                ; Composite types: struct, union, enum
    (magenta-warmer "#564740")         ; Extended library types
    (magenta-cooler "#442b28")         ; Rare syntax nodes, special escapes
    (magenta-faint "#685e50")          ; Inactive conditional blocks

    (cyan "#363f2c")                   ; Keyword fallback
    (cyan-warmer "#442b28")            ; Preprocessor alias
    (cyan-cooler "#524c44")            ; Operator alias
    (cyan-faint "#625c52")             ; Punctuation delimiters

    ;; Panels, Diffs and Structural Highlights
    (bg-added "#c8e4c4")               ; Diff added line baseline
    (bg-added-faint "#daf0d8")         ; Diff added unchanged context
    (bg-added-refine "#b6dbb0")        ; Diff added word-level highlight
    (fg-added "#185422")               ; Diff added foreground text

    (bg-changed "#ede0b0")             ; Diff changed line baseline
    (bg-changed-faint "#f6edd0")       ; Diff changed unchanged context
    (bg-changed-refine "#e2d098")      ; Diff changed word-level highlight
    (fg-changed "#5c4208")             ; Diff changed foreground text

    (bg-removed "#eecac4")             ; Diff removed line baseline
    (bg-removed-faint "#f8e2de")       ; Diff removed unchanged context
    (bg-removed-refine "#e2b5ad")      ; Diff removed word-level highlight
    (fg-removed "#78201a")             ; Diff removed foreground text

    (bg-mode-line-active "#c8c0ae")    ; Active modeline surface
    (fg-mode-line-active "#282420")    ; Active modeline primary text
    (bg-completion "#cbc2b0")          ; Minibuffer completion selected row
    (bg-popup "#e4dcce")               ; Autocomplete tooltip surface
    (bg-hover "#ccc4b2")               ; Mouse hover overlay
    (bg-hover-secondary "#d2cab8")     ; Secondary hover overlay
    (bg-hl-line "#ccc2ae")             ; Current line indicator
    (bg-paren-match "#c8b898")         ; Matching delimiter highlight
    (bg-err "#ebcec8")                 ; Flymake error inline box
    (bg-warning "#ebdab0")             ; Flymake warning inline box
    (bg-info "#dcd0b8")                ; Flymake info inline box
    (bg-region "#b0a48e")              ; Marked region
    (fg-line-number-inactive "#8c8272"))) ; Inactive line numbers margin

(defconst au-parchment-day-palette-mappings-partial
  '((err red)
    (warning yellow-warmer)
    (info green)

    (fg-link blue-warmer)
    (fg-link-visited blue)
    (name blue)
    (keybind red)
    (identifier fg-alt)
    (fg-prompt blue)

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

(defconst au-parchment-day-palette
  (modus-themes-generate-palette
   au-parchment-day-palette-partial
   nil
   nil
   (append au-parchment-day-palette-mappings-partial ef-themes-palette-common)))

(defconst au-parchment-day-custom-faces
  '(`(font-lock-keyword-face ((,c :slant italic :foreground ,keyword)))
    `(font-lock-builtin-face ((,c :slant italic :foreground ,builtin)))
    `(font-lock-comment-face ((,c :slant italic :foreground ,comment)))
    `(font-lock-doc-face ((,c :slant italic :foreground ,docstring)))
    `(font-lock-type-face ((,c :slant italic :foreground ,type)))))

;;;###theme-autoload
(modus-themes-theme
 'au-parchment-day
 'ef-themes
 "Low-chroma daylight theme with typographic italics and minimal color variance."
 'light
 'au-parchment-day-palette
 nil
 nil
 'au-parchment-day-custom-faces)

(provide 'au-parchment-day-theme)
;;; au-parchment-day-theme.el ends here
