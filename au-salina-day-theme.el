;;; au-salina-day-theme.el --- Coastal daylight theme with sea-salt and dune tones -*- lexical-binding:t -*-

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
;; Coastal daylight theme inspired by sea-salt flats, wind-swept sand dunes,
;; deep cobalt ocean water, and weathered driftwood.
;; Calibrated to minimize visual noise and photophobic strain for autistic
;; and neurodivergent sensory profiles.
;; Part of the `au-themes' collection.

;;; Code:

(require 'ef-themes)

(defconst au-salina-day-palette-partial
  '(;; Canvas & Chrome
    (cursor "#924626")                    ; Point / cursor indicator
    (bg-main "#dad8cf")                   ; Primary canvas background
    (bg-dim "#cccac0")                    ; Inactive windows, dim canvas
    (bg-alt "#bebcb2")                    ; Subtle borders, alternating stripes
    (fg-main "#202826")                   ; Default buffer text
    (fg-dim "#56625e")                    ; Comments, metadata
    (fg-alt "#384620")                    ; Struct properties
    (fg-var "#185068")                    ; Variable definitions
    (bg-active "#bebcb2")                 ; Active modeline frame, focused bars
    (bg-inactive "#cccac0")               ; Inactive modeline
    (border "#9ca098")                    ; Window dividers

    ;; Basic Chromatic Scale
    (red "#9c3a2e")                       ; Errors, critical warnings
    (red-warmer "#523614")                ; Driftwood string literals
    (red-cooler "#842e26")                ; Diff deletions, removal markers
    (red-faint "#444e48")                 ; Structural brackets

    (green "#084e4a")                     ; Primitive types
    (green-warmer "#783c1e")              ; Constant values and macros
    (green-cooler "#6c203a")              ; Control keywords
    (green-faint "#56625e")               ; Documentation strings, inline comments

    (yellow "#6c203a")                    ; Keyword alias
    (yellow-warmer "#725c10")             ; Numeric literals
    (yellow-cooler "#442a36")             ; Preprocessor directives
    (yellow-faint "#5e584a")              ; Informational tooltips, fringe markers

    (blue "#286496")                      ; Function definitions
    (blue-warmer "#106e7d")               ; Function calls
    (blue-cooler "#3e4a4e")               ; Binary and unary operators
    (blue-faint "#6c4e16")                ; Built-in functions

    (magenta "#084e4a")                   ; Composite types: struct, union, enum
    (magenta-warmer "#106e7d")            ; Extended library types
    (magenta-cooler "#442a36")            ; Rare syntax nodes, special escapes
    (magenta-faint "#56625e")             ; Inactive conditional blocks

    (cyan "#6c4e16")                      ; Builtin fallback
    (cyan-warmer "#442a36")               ; Preprocessor alias
    (cyan-cooler "#3e4a4e")               ; Operator alias
    (cyan-faint "#424a46")                ; Punctuation delimiters

    ;; Panels, Diffs and Structural Highlights
    (bg-red-intense "#e2a298")            ; Blocking errors, fatal assertion panel
    (bg-green-intense "#98bea2")          ; Success banner
    (bg-yellow-intense "#d2b87e")         ; Warning banner, review request
    (bg-blue-intense "#8abed4")           ; Info banner, active selections
    (bg-magenta-intense "#d4a2c4")        ; Special prompt background
    (bg-cyan-intense "#82c4be")           ; Incsearch current match target

    (bg-red-subtle "#dec8c2")             ; Diff context deletion background
    (bg-green-subtle "#c0d6be")           ; Diff context addition background
    (bg-yellow-subtle "#e0d2b6")          ; Diff whitespace/context change
    (bg-blue-subtle "#bad4dc")            ; Mode-line subtle indicators
    (bg-magenta-subtle "#d8c6d2")         ; Matching paren context background
    (bg-cyan-subtle "#bedcd6")            ; Structural block highlight

    (bg-added "#c2e6c4")                  ; Diff added line baseline
    (bg-added-faint "#d6f0d8")            ; Diff added unchanged context
    (bg-added-refine "#b0deb2")           ; Diff added word-level highlight
    (fg-added "#0e561e")                  ; Diff added foreground text

    (bg-changed "#eee0ac")                ; Diff changed line baseline
    (bg-changed-faint "#f8f0cc")          ; Diff changed unchanged context
    (bg-changed-refine "#e2d298")         ; Diff changed word-level highlight
    (fg-changed "#5e440c")                ; Diff changed foreground text

    (bg-removed "#eecac6")                ; Diff removed line baseline
    (bg-removed-faint "#f8dedc")          ; Diff removed unchanged context
    (bg-removed-refine "#e2b6b0")         ; Diff removed word-level highlight
    (fg-removed "#7a1e1c")                ; Diff removed foreground text

    (bg-mode-line-active "#bcbab0")       ; Active modeline surface
    (fg-mode-line-active "#1c2422")       ; Active modeline primary text
    (bg-completion "#c8c6bc")             ; Minibuffer completion selected row
    (bg-popup "#dcdad0")                  ; Autocomplete tooltip surface
    (bg-hover "#c2c0b6")                  ; Mouse hover overlay
    (bg-hover-secondary "#c6c2c8")        ; Secondary hover overlay
    (bg-hl-line "#cec8bc")                ; Current line indicator
    (bg-paren-match "#a2c4c2")            ; Matching delimiter highlight
    (bg-err "#ebc4be")                    ; Flymake error inline box
    (bg-warning "#ecdeb2")                ; Flymake warning inline box
    (bg-info "#b8dcc8")                   ; Flymake info inline box
    (bg-region "#a0bcc2")                 ; Marked region
    (fg-line-number-inactive "#74807c"))) ; Inactive line numbers margin

(defconst au-salina-day-palette-mappings-partial
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

(defconst au-salina-day-palette
  (modus-themes-generate-palette
   au-salina-day-palette-partial
   nil
   nil
   (append au-salina-day-palette-mappings-partial ef-themes-palette-common)))

;;;###theme-autoload
(modus-themes-theme
 'au-salina-day
 'ef-themes
 "Coastal daylight theme with sea-salt and dune tones."
 'light
 'au-salina-day-palette
 nil
 nil)

(provide 'au-salina-day-theme)
;;; au-salina-day-theme.el ends here
