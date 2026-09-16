;;; au-herbarium-day-theme.el --- Herbal daylight theme with dried botanicals and pressed leaves -*- lexical-binding:t -*-

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
;; Herbal daylight theme inspired by botanical herbariums, pressed sage leaves,
;; dried lavender petals, oak-bark ink, and chamomile pollen.
;; Calibrated to minimize visual noise and photophobic fatigue for autistic
;; and neurodivergent sensory profiles.
;; Part of the `au-themes' collection.

;;; Code:

(require 'ef-themes)

(defconst au-herbarium-day-palette-partial
  '(;; Canvas & Chrome
    (cursor "#286440")                    ; Point / cursor indicator
    (bg-main "#d6d8c8")                   ; Primary canvas background
    (bg-dim "#c8cac0")                    ; Inactive windows, dim canvas
    (bg-alt "#babbb0")                    ; Subtle borders, alternating stripes
    (fg-main "#242820")                   ; Default buffer text
    (fg-dim "#5c6454")                    ; Comments, metadata
    (fg-alt "#46543c")                    ; Struct properties
    (fg-var "#1c5234")                    ; Variable definitions
    (bg-active "#babbb0")                 ; Active modeline frame, focused bars
    (bg-inactive "#c8cac0")               ; Inactive modeline
    (border "#9aa08e")                    ; Window dividers

    ;; Basic Chromatic Scale
    (red "#9a3c2e")                       ; Errors, critical warnings
    (red-warmer "#143c22")                ; String literals
    (red-cooler "#843026")                ; Diff deletions, removal markers
    (red-faint "#4a5444")                 ; Structural brackets

    (green "#466618")                     ; Primitive types
    (green-warmer "#54285a")              ; Constant values and macros
    (green-cooler "#6c223a")              ; Control keywords
    (green-faint "#5c6454")               ; Documentation strings, inline comments

    (yellow "#6c223a")                    ; Keyword alias
    (yellow-warmer "#944818")             ; Numeric literals
    (yellow-cooler "#1c3838")             ; Preprocessor directives
    (yellow-faint "#605c48")              ; Informational tooltips, fringe markers

    (blue "#184668")                      ; Function definitions
    (blue-warmer "#805412")               ; Function calls
    (blue-cooler "#444e44")               ; Binary and unary operators
    (blue-faint "#4a3410")                ; Built-in functions

    (magenta "#466618")                   ; Composite types: struct, union, enum
    (magenta-warmer "#805412")            ; Extended library types
    (magenta-cooler "#1c3838")            ; Rare syntax nodes, special escapes
    (magenta-faint "#586050")             ; Inactive conditional blocks

    (cyan "#4a3410")                      ; Builtin fallback
    (cyan-warmer "#1c3838")               ; Preprocessor alias
    (cyan-cooler "#444e44")               ; Operator alias
    (cyan-faint "#464e44")                ; Punctuation delimiters

    ;; Panels, Diffs and Structural Highlights
    (bg-red-intense "#dea094")            ; Blocking errors, fatal assertion panel
    (bg-green-intense "#96bc8e")          ; Success banner
    (bg-yellow-intense "#ceb070")         ; Warning banner, review request
    (bg-blue-intense "#8cbac8")           ; Info banner, active selections
    (bg-magenta-intense "#cca0c0")        ; Special prompt background
    (bg-cyan-intense "#84c0a4")           ; Incsearch current match target

    (bg-red-subtle "#dac6be")             ; Diff context deletion background
    (bg-green-subtle "#c6d8c0")           ; Diff context addition background
    (bg-yellow-subtle "#ded0b0")          ; Diff whitespace/context change
    (bg-blue-subtle "#b8ced6")            ; Mode-line subtle indicators
    (bg-magenta-subtle "#d2c2ce")         ; Matching paren context background
    (bg-cyan-subtle "#c0d6ca")            ; Structural block highlight

    (bg-added "#c6e4c4")                  ; Diff added line baseline
    (bg-added-faint "#d8eed8")            ; Diff added unchanged context
    (bg-added-refine "#b2dcaf")           ; Diff added word-level highlight
    (fg-added "#12541a")                  ; Diff added foreground text

    (bg-changed "#ece2ac")                ; Diff changed line baseline
    (bg-changed-faint "#f6eec8")          ; Diff changed unchanged context
    (bg-changed-refine "#ded296")         ; Diff changed word-level highlight
    (fg-changed "#5c440a")                ; Diff changed foreground text

    (bg-removed "#eec8c4")                ; Diff removed line baseline
    (bg-removed-faint "#f8dedc")          ; Diff removed unchanged context
    (bg-removed-refine "#e0b4ae")         ; Diff removed word-level highlight
    (fg-removed "#781e18")                ; Diff removed foreground text

    (bg-mode-line-active "#b6b8aa")       ; Active modeline surface
    (fg-mode-line-active "#1e221a")       ; Active modeline primary text
    (bg-completion "#c4c6b8")             ; Minibuffer completion selected row
    (bg-popup "#d6d8cc")                  ; Autocomplete tooltip surface
    (bg-hover "#bebfb0")                  ; Mouse hover overlay
    (bg-hover-secondary "#c2bfc2")        ; Secondary hover overlay
    (bg-hl-line "#c8c8b4")                ; Current line indicator
    (bg-paren-match "#abc69a")            ; Matching delimiter highlight
    (bg-err "#e8c2be")                    ; Flymake error inline box
    (bg-warning "#eadeb0")                ; Flymake warning inline box
    (bg-info "#b8dcb8")                   ; Flymake info inline box
    (bg-region "#c8bed0")                 ; Marked region
    (fg-line-number-inactive "#767e72"))) ; Inactive line numbers margin

(defconst au-herbarium-day-palette-mappings-partial
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

(defconst au-herbarium-day-palette
  (modus-themes-generate-palette
   au-herbarium-day-palette-partial
   nil
   nil
   (append au-herbarium-day-palette-mappings-partial ef-themes-palette-common)))

(defconst au-herbarium-day-custom-faces
  '(`(font-lock-keyword-face ((,c :slant italic :foreground ,keyword)))
    `(font-lock-builtin-face ((,c :slant italic :foreground ,builtin)))
    `(font-lock-comment-face ((,c :slant italic :foreground ,comment)))
    `(font-lock-doc-face ((,c :slant italic :foreground ,docstring)))
    `(font-lock-type-face ((,c :slant italic :foreground ,type)))))

;;;###theme-autoload
(modus-themes-theme
 'au-herbarium-day
 'ef-themes
 "Herbal daylight theme with dried botanicals and pressed leaves."
 'light
 'au-herbarium-day-palette
 nil
 nil
 'au-herbarium-day-custom-faces)

(provide 'au-herbarium-day-theme)
;;; au-herbarium-day-theme.el ends here
