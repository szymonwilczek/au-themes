;;; au-aurum-day-theme.el --- Warm daylight theme without blue-light hazard -*- lexical-binding:t -*-

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
;; Light theme with warm earth tones and no blue-light emission.
;; Calibrated for severe photophobia, ocular migraine, and daytime readability.
;; Part of the `au-themes' collection.

;;; Code:

(require 'ef-themes)

(defconst au-aurum-day-palette-partial
  '(;; Canvas & Chrome
    (cursor "#8c5a08")                 ; Point / cursor indicator
    (bg-main "#ded8cc")                ; Primary canvas background
    (bg-dim "#d2cbbe")                 ; Inactive windows, dim canvas
    (bg-alt "#c6bfb0")                 ; Subtle borders, alternating stripes
    (fg-main "#2b2720")                ; Default buffer text
    (fg-dim "#625d54")                 ; Comments, metadata
    (fg-alt "#605644")                 ; Struct properties
    (fg-var "#2b2720")                 ; Variable definitions
    (bg-active "#c8c0b2")              ; Active modeline frame, focused bars
    (bg-inactive "#d2cbbe")            ; Inactive modeline
    (border "#a49c8c")                 ; Window dividers

    ;; Basic Chromatic Scale
    (red "#a54b32")                    ; Errors, critical warnings
    (red-warmer "#50240c")             ; String literals
    (red-cooler "#9e422c")             ; Diff deletions, removal markers
    (red-faint "#544e45")              ; Structural brackets

    (green "#7c5610")                  ; Primitive types
    (green-warmer "#761814")           ; Constant values and macros
    (green-cooler "#4a3400")           ; Control keywords
    (green-faint "#625d54")            ; Documentation strings, inline comments

    (yellow "#4a3400")                 ; Keyword alias
    (yellow-warmer "#6c6400")          ; Numeric literals
    (yellow-cooler "#674759")          ; Preprocessor directives
    (yellow-faint "#70685a")           ; Informational tooltips, fringe markers

    (blue "#483620")                   ; Function definitions
    (blue-warmer "#8e402a")            ; Function calls
    (blue-cooler "#585248")            ; Binary and unary operators
    (blue-faint "#50543a")             ; Built-in functions

    (magenta "#7c5610")                ; Composite types: struct, union, enum
    (magenta-warmer "#8e402a")         ; Extended library types
    (magenta-cooler "#743a18")         ; Rare syntax nodes, special escapes
    (magenta-faint "#625d54")          ; Inactive conditional blocks

    (cyan "#4a3400")                   ; Keyword fallback
    (cyan-warmer "#674759")            ; Preprocessor alias
    (cyan-cooler "#585248")            ; Operator alias
    (cyan-faint "#665f54")             ; Punctuation delimiters

    ;; Panels, Diffs and Structural Highlights
    (bg-red-intense "#e89e8e")         ; Blocking errors, fatal assertion panel
    (bg-green-intense "#a2cc94")       ; Success banner
    (bg-yellow-intense "#deb658")      ; Warning banner, review request
    (bg-blue-intense "#caa4cc")        ; Info banner, active selections
    (bg-magenta-intense "#d0a6bc")     ; Special prompt background
    (bg-cyan-intense "#94caa0")        ; Incsearch current match target

    (bg-red-subtle "#e6c4ba")          ; Diff context deletion background
    (bg-green-subtle "#d2e4ca")        ; Diff context addition background
    (bg-yellow-subtle "#ece0b8")       ; Diff whitespace/context change
    (bg-blue-subtle "#ded2de")         ; Mode-line subtle indicators
    (bg-magenta-subtle "#e2ced8")      ; Matching paren context background
    (bg-cyan-subtle "#c6d8c0")         ; Structural block highlight

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

    (bg-mode-line-active "#c8c0b2")    ; Active modeline surface
    (fg-mode-line-active "#1f1c16")    ; Active modeline primary text
    (bg-completion "#cbcdb8")          ; Minibuffer completion selected row
    (bg-popup "#e6e0d4")               ; Autocomplete tooltip surface
    (bg-hover "#ccc6b8")               ; Mouse hover overlay
    (bg-hover-secondary "#d2ccc0")     ; Secondary hover overlay
    (bg-hl-line "#d5cfc2")             ; Current line indicator
    (bg-paren-match "#d4ba8a")         ; Matching delimiter highlight
    (bg-err "#ebd0c8")                 ; Flymake error inline box
    (bg-warning "#ebddb0")             ; Flymake warning inline box
    (bg-info "#dcd4b8")                ; Flymake info inline box
    (bg-region "#d8be78")              ; Marked region
    (fg-line-number-inactive "#867e70"))) ; Inactive line numbers margin

(defconst au-aurum-day-palette-mappings-partial
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

(defconst au-aurum-day-palette
  (modus-themes-generate-palette
   au-aurum-day-palette-partial
   nil
   nil
   (append au-aurum-day-palette-mappings-partial ef-themes-palette-common)))

;;;###theme-autoload
(modus-themes-theme
 'au-aurum-day
 'ef-themes
 "Warm daylight theme with zero blue-light hazard, calibrated for photophobia."
 'light
 'au-aurum-day-palette
 nil
 nil)

(provide 'au-aurum-day-theme)
;;; au-aurum-day-theme.el ends here
