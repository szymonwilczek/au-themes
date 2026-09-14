;;; au-whispergrove-evening-theme.el --- Elevated dark theme for intermediate ambient lighting -*- lexical-binding:t -*-

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
;; Dark theme with elevated background luminance.
;; Calibrated for moderate evening ambient light to prevent pupil dilation
;; strain.
;; Part of the `au-themes' collection.

;;; Code:

(require 'ef-themes)

(defconst au-whispergrove-evening-palette-partial
  '(;; Canvas & Chrome
    (cursor "#54a8be")                    ; Point / cursor indicator
    (bg-main "#1a221c")                   ; Primary canvas background
    (bg-dim "#242c26")                    ; Inactive windows, dim canvas
    (bg-alt "#303a32")                    ; Subtle borders, alternating stripes
    (fg-main "#9ea8a0")                   ; Default buffer text
    (fg-dim "#627666")                    ; Comments, metadata
    (fg-alt "#7cb098")                    ; Struct properties
    (fg-var "#a0b8ac")                    ; Variable definitions
    (bg-active "#424e44")                 ; Active modeline frame, focused bars
    (bg-inactive "#242c26")               ; Inactive modeline
    (border "#48544a")                    ; Window dividers

    ;; Basic Chromatic Scale
    (red "#c24e46")                       ; Errors, critical warnings
    (red-warmer "#aa6a58")                ; String literals
    (red-cooler "#b2564e")                ; Diff deletions, removal markers
    (red-faint "#6a806d")                 ; Structural brackets

    (green "#66b06a")                     ; Primitive types
    (green-warmer "#bc6478")              ; Constant values and macros
    (green-cooler "#ae7a32")              ; Control keywords
    (green-faint "#627666")               ; Documentation strings, inline comments

    (yellow "#ae7a32")                    ; Keyword alias
    (yellow-warmer "#c2a640")             ; Numeric literals
    (yellow-cooler "#887028")             ; Preprocessor directives
    (yellow-faint "#707c6e")              ; Informational tooltips, fringe markers

    (blue "#308096")                      ; Function definitions
    (blue-warmer "#569cb0")               ; Function calls
    (blue-cooler "#688c7e")               ; Binary and unary operators
    (blue-faint "#42948a")                ; Built-in functions

    (magenta "#966c42")                   ; Composite types: struct, union, enum
    (magenta-warmer "#6cb09a")            ; Extended library types
    (magenta-cooler "#7c6c88")            ; Rare syntax nodes, special escapes
    (magenta-faint "#627666")             ; Inactive conditional blocks

    (cyan "#ae7a32")                      ; Keyword fallback
    (cyan-warmer "#887028")               ; Preprocessor alias
    (cyan-cooler "#688c7e")               ; Operator alias
    (cyan-faint "#748276")                ; Punctuation delimiters

    ;; Panels, Diffs and Structural Highlights
    (bg-red-intense "#7e221e")            ; Blocking errors, fatal assertion panel
    (bg-green-intense "#245c2a")          ; Success banner
    (bg-yellow-intense "#6a4a16")         ; Warning banner, review request
    (bg-blue-intense "#204e62")           ; Info banner, active selections
    (bg-magenta-intense "#5a2e4c")        ; Special prompt background
    (bg-cyan-intense "#1a5056")           ; Incsearch current match target

    (bg-red-subtle "#401c1a")             ; Diff context deletion background
    (bg-green-subtle "#183220")           ; Diff context addition background
    (bg-yellow-subtle "#3a2614")          ; Diff whitespace/context change
    (bg-blue-subtle "#16303c")            ; Mode-line subtle indicators
    (bg-magenta-subtle "#321c2e")         ; Matching paren context background
    (bg-cyan-subtle "#163438")            ; Structural block highlight

    (bg-added "#204218")                  ; Diff added line baseline
    (bg-added-faint "#14330c")            ; Diff added unchanged context
    (bg-added-refine "#2c561a")           ; Diff added word-level highlight
    (fg-added "#a6e0aa")                  ; Diff added foreground text

    (bg-changed "#44400a")                ; Diff changed line baseline
    (bg-changed-faint "#342c06")          ; Diff changed unchanged context
    (bg-changed-refine "#56560c")         ; Diff changed word-level highlight
    (fg-changed "#e4dc84")                ; Diff changed foreground text

    (bg-removed "#581a12")                ; Diff removed line baseline
    (bg-removed-faint "#441208")          ; Diff removed unchanged context
    (bg-removed-refine "#7c221a")         ; Diff removed word-level highlight
    (fg-removed "#ffc8c8")                ; Diff removed foreground text

    (bg-mode-line-active "#263028")       ; Active modeline surface
    (fg-mode-line-active "#9ea8a0")       ; Active modeline primary text
    (bg-completion "#2a342c")             ; Minibuffer completion selected row
    (bg-popup "#1e2820")                  ; Autocomplete tooltip surface
    (bg-hover "#304438")                  ; Mouse hover overlay
    (bg-hover-secondary "#423448")        ; Secondary hover overlay
    (bg-hl-line "#202a22")                ; Current line indicator
    (bg-paren-match "#345842")            ; Matching delimiter highlight
    (bg-err "#481a18")                    ; Flymake error inline box
    (bg-warning "#3c3010")                ; Flymake warning inline box
    (bg-info "#183220")                   ; Flymake info inline box
    (bg-region "#284436")                 ; Marked region
    (fg-line-number-inactive "#5e7062"))) ; Inactive line numbers margin

(defconst au-whispergrove-evening-palette-mappings-partial
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

    (accent-0 blue)
    (accent-1 green)
    (accent-2 yellow)
    (accent-3 green-warmer)))

(defconst au-whispergrove-evening-palette
  (modus-themes-generate-palette
   au-whispergrove-evening-palette-partial
   nil
   nil
   (append au-whispergrove-evening-palette-mappings-partial ef-themes-palette-common)))

;;;###theme-autoload
(modus-themes-theme
 'au-whispergrove-evening
 'ef-themes
 "Elevated dark theme for intermediate ambient lighting and reduced pupil strain."
 'dark
 'au-whispergrove-evening-palette
 nil
 nil)

(provide 'au-whispergrove-evening-theme)
;;; au-whispergrove-evening-theme.el ends here
