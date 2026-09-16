;;; au-salina-night-theme.el --- Nocturnal coastal theme with deep oceanic and coral tones -*- lexical-binding:t -*-

;; Copyright (C) 2026  Szymon Wilczek

;; Author: Szymon Wilczek <swilczek.lx@gmail.com>
;; URL: https://github.com/szymonwilczek/au-themes
;; Keywords: faces, themes, accessibility, autism, neurodivergence

;; This file is not part of GNU Emacs.

;; This file is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this file.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; Nocturnal coastal theme inspired by midnight ocean waters, dark basalt,
;; phosphorescent turquoise, and maritime coral.
;; Calibrated to minimize visual glare and photophobic strain for autistic
;; and neurodivergent sensory profiles.
;; Part of the `au-themes' collection.

;;; Code:

(require 'ef-themes)

(defconst au-salina-night-palette-partial
  '(;; Canvas & Chrome
    (cursor "#cc7844")                    ; Point / cursor indicator
    (bg-main "#101414")                   ; Primary canvas background
    (bg-dim "#181e22")                    ; Inactive windows, dim canvas
    (bg-alt "#222a2e")                    ; Subtle borders, alternating stripes
    (fg-main "#98a2a6")                   ; Default buffer text
    (fg-dim "#5c6a70")                    ; Comments, metadata
    (fg-alt "#8aa05e")                    ; Struct properties
    (fg-var "#4a9cb4")                    ; Variable definitions
    (bg-active "#263238")                 ; Active modeline frame, focused bars
    (bg-inactive "#181e22")               ; Inactive modeline
    (border "#364248")                    ; Window dividers

    ;; Basic Chromatic Scale
    (red "#ba483e")                       ; Errors, critical warnings
    (red-warmer "#aa7c52")                ; String literals
    (red-cooler "#a24238")                ; Diff deletions, removal markers
    (red-faint "#687880")                 ; Structural brackets

    (green "#16ae96")                     ; Primitive types
    (green-warmer "#c26842")              ; Constant values and macros
    (green-cooler "#b6507a")              ; Control keywords
    (green-faint "#5c6a70")               ; Documentation strings, inline comments

    (yellow "#b6507a")                    ; Keyword alias
    (yellow-warmer "#baa046")             ; Numeric literals
    (yellow-cooler "#84546c")             ; Preprocessor directives
    (yellow-faint "#747868")              ; Informational tooltips, fringe markers

    (blue "#3c76b2")                      ; Function definitions
    (blue-warmer "#7486d2")               ; Function calls
    (blue-cooler "#70828a")               ; Binary and unary operators
    (blue-faint "#8c7834")                ; Built-in functions

    (magenta "#16ae96")                   ; Composite types: struct, union, enum
    (magenta-warmer "#7486d2")            ; Extended library types
    (magenta-cooler "#84546c")            ; Rare syntax nodes, special escapes
    (magenta-faint "#647474")             ; Inactive conditional blocks

    (cyan "#8c7834")                      ; Builtin fallback
    (cyan-warmer "#84546c")               ; Preprocessor alias
    (cyan-cooler "#70828a")               ; Operator alias
    (cyan-faint "#687880")                ; Punctuation delimiters

    ;; Panels, Diffs and Structural Highlights
    (bg-red-intense "#561e18")            ; Blocking errors, fatal assertion panel
    (bg-green-intense "#1a3c2c")          ; Success banner
    (bg-yellow-intense "#463814")         ; Warning banner, review request
    (bg-blue-intense "#1c3848")           ; Info banner, active selections
    (bg-magenta-intense "#3a2034")        ; Special prompt background
    (bg-cyan-intense "#183c3e")           ; Incsearch current match target

    (bg-red-subtle "#301814")             ; Diff context deletion background
    (bg-green-subtle "#14241c")           ; Diff context addition background
    (bg-yellow-subtle "#282212")          ; Diff whitespace/context change
    (bg-blue-subtle "#14222a")            ; Mode-line subtle indicators
    (bg-magenta-subtle "#261824")         ; Matching paren context background
    (bg-cyan-subtle "#122426")            ; Structural block highlight

    (bg-added "#163422")                  ; Diff added line baseline
    (bg-added-faint "#102618")            ; Diff added unchanged context
    (bg-added-refine "#244a30")           ; Diff added word-level highlight
    (fg-added "#aae0b8")                  ; Diff added foreground text

    (bg-changed "#362e10")                ; Diff changed line baseline
    (bg-changed-faint "#26200a")          ; Diff changed unchanged context
    (bg-changed-refine "#4a4018")         ; Diff changed word-level highlight
    (fg-changed "#e0c878")                ; Diff changed foreground text

    (bg-removed "#3a1816")                ; Diff removed line baseline
    (bg-removed-faint "#2a100e")          ; Diff removed unchanged context
    (bg-removed-refine "#522420")         ; Diff removed word-level highlight
    (fg-removed "#f09892")                ; Diff removed foreground text

    (bg-mode-line-active "#263238")       ; Active modeline surface
    (fg-mode-line-active "#b4c0be")       ; Active modeline primary text
    (bg-completion "#1c262c")             ; Minibuffer completion selected row
    (bg-popup "#1e282e")                  ; Autocomplete tooltip surface
    (bg-hover "#243038")                  ; Mouse hover overlay
    (bg-hover-secondary "#2a2c36")        ; Secondary hover overlay
    (bg-hl-line "#161e22")                ; Current line indicator
    (bg-paren-match "#284c56")            ; Matching delimiter highlight
    (bg-err "#3c1a18")                    ; Flymake error inline box
    (bg-warning "#362a14")                ; Flymake warning inline box
    (bg-info "#1a3832")                   ; Flymake info inline box
    (bg-region "#1e324a")                 ; Marked region
    (fg-line-number-inactive "#4c5e5c"))) ; Inactive line numbers margin

(defconst au-salina-night-palette-mappings-partial
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

(defconst au-salina-night-palette
  (modus-themes-generate-palette
   au-salina-night-palette-partial
   nil
   nil
   (append au-salina-night-palette-mappings-partial ef-themes-palette-common)))

(defconst au-salina-night-custom-faces
  '(`(font-lock-keyword-face ((,c :slant italic :foreground ,keyword)))
    `(font-lock-builtin-face ((,c :slant italic :foreground ,builtin)))
    `(font-lock-comment-face ((,c :slant italic :foreground ,comment)))
    `(font-lock-doc-face ((,c :slant italic :foreground ,docstring)))
    `(font-lock-type-face ((,c :slant italic :foreground ,type)))))

;;;###theme-autoload
(modus-themes-theme
 'au-salina-night
 'ef-themes
 "Nocturnal coastal theme with deep oceanic and coral tones."
 'dark
 'au-salina-night-palette
 nil
 nil
 'au-salina-night-custom-faces)

(provide 'au-salina-night-theme)
;;; au-salina-night-theme.el ends here
