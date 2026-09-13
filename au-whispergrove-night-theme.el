;;; au-whispergrove-night-theme.el --- Deep nocturnal whisper grove theme for Au-themes -*- lexical-binding:t -*-

;; Copyright (C) 2026  Szymon Wilczek

;; Author: Szymon Wilczek <swilczek.lx@gmail.com>
;; Maintainer: Szymon Wilczek <swilczek.lx@gmail.com>
;; URL: https://github.com/szymonwilczek/au-themes
;; Keywords: faces, themes, accessibility, autism, neurodivergence

;; This file is NOT part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; Deep nocturnal whisper grove sanctuary (LCD/OLED calibrated). Part of the
;; `au-themes' collection engineered for sensory-safe autistic and
;; neurodivergent visual perception.

;;; Code:

(require 'ef-themes)

(defconst au-whispergrove-night-palette-partial
  '(;; Canvas & Chrome
    (cursor "#4a9cb2")                 ; Point / cursor indicator
    (bg-main "#0a0d08")                ; Primary canvas background
    (bg-dim "#1a1e17")                 ; Inactive windows, dim canvas
    (bg-alt "#282e24")                 ; Subtle borders, alternating stripes
    (fg-main "#9ca69e")                ; Default buffer text
    (fg-dim "#586c5a")                 ; Comments, metadata
    (fg-alt "#6ea288")                 ; Struct properties
    (fg-var "#98aba0")                 ; Variable definitions
    (bg-active "#3e463a")              ; Active modeline frame, focused bars
    (bg-inactive "#1a1e17")            ; Inactive modeline
    (border "#424a3e")                 ; Window dividers

    ;; Basic Chromatic Scale
    (red "#b6463e")                    ; Errors, critical warnings
    (red-warmer "#9e604e")             ; String literals
    (red-cooler "#a44a42")             ; Diff deletions, removal markers
    (red-faint "#687e6b")              ; Structural brackets

    (green "#5ca660")                  ; Primitive types
    (green-warmer "#b05c70")           ; Constant values
    (green-cooler "#a47028")           ; Control keywords
    (green-faint "#586c5a")            ; Documentation strings, inline comments

    (yellow "#a47028")                 ; Keyword alias
    (yellow-warmer "#bca03c")          ; Numeric literals
    (yellow-cooler "#7e5a28")          ; Preprocessor directives
    (yellow-faint "#647062")           ; Informational tooltips, fringe markers

    (blue "#227086")                   ; Function definitions
    (blue-warmer "#4e92a4")            ; Function calls
    (blue-cooler "#5e8274")            ; Binary and unary operators
    (blue-faint "#398a80")             ; Built-in functions

    (magenta "#8c6238")                ; Composite types: struct, union, enum
    (magenta-warmer "#62a28c")         ; Extended library types
    (magenta-cooler "#72627e")         ; Rare syntax nodes, special escapes
    (magenta-faint "#586c5a")          ; Inactive conditional blocks

    (cyan "#a47028")                   ; Keyword fallback w extractorze
    (cyan-warmer "#7e5a28")            ; Preprocessor alias
    (cyan-cooler "#5e8274")            ; Operator alias
    (cyan-faint "#6c786e")             ; Punctuation delimiters (:delimiter)

    ;; Panels, Diffs and Structural Highlights
    (bg-red-intense "#741d1a")         ; Blocking errors, fatal assertion panel
    (bg-green-intense "#1e5224")       ; Success banner, terminal green state
    (bg-yellow-intense "#604210")      ; Warning banner, review request
    (bg-blue-intense "#1a4658")        ; Info banner, active selections
    (bg-magenta-intense "#502842")     ; Special prompt background
    (bg-cyan-intense "#14484c")        ; Incsearch current match target

    (bg-red-subtle "#381614")          ; Diff context deletion background
    (bg-green-subtle "#122a18")        ; Diff context addition background
    (bg-yellow-subtle "#34200e")       ; Diff whitespace/context change
    (bg-blue-subtle "#102832")         ; Mode-line subtle indicators
    (bg-magenta-subtle "#2c1626")      ; Matching paren context background
    (bg-cyan-subtle "#102c2e")         ; Structural block highlight

    (bg-added "#17360f")               ; Diff added line baseline
    (bg-added-faint "#0a2900")         ; Diff added unchanged context
    (bg-added-refine "#204810")        ; Diff added word-level highlight
    (fg-added "#9ed4a2")               ; Diff added foreground text

    (bg-changed "#363300")             ; Diff changed line baseline
    (bg-changed-faint "#2a1f00")       ; Diff changed unchanged context
    (bg-changed-refine "#4a4a00")      ; Diff changed word-level highlight
    (fg-changed "#dcd478")             ; Diff changed foreground text

    (bg-removed "#4b120a")             ; Diff removed line baseline
    (bg-removed-faint "#3a0a00")       ; Diff removed unchanged context
    (bg-removed-refine "#6f1a16")      ; Diff removed word-level highlight
    (fg-removed "#ffbfbf")             ; Diff removed foreground text

    (bg-mode-line-active "#1e2420")    ; Active modeline surface
    (fg-mode-line-active "#9ca69e")    ; Active modeline primary text
    (bg-completion "#202622")          ; Minibuffer completion selected row
    (bg-popup "#151912")               ; Autocomplete tooltip surface
    (bg-hover "#24382e")               ; Mouse hover overlay
    (bg-hover-secondary "#362a3c")     ; Secondary hover overlay
    (bg-hl-line "#12160f")             ; Current line indicator
    (bg-paren-match "#284c38")         ; Matching delimiter highlight
    (bg-err "#3a1210")                 ; Flymake error inline box
    (bg-warning "#30260a")             ; Flymake warning inline box
    (bg-info "#102816")                ; Flymake info inline box
    (bg-region "#1a3226")              ; Mouse/keyboard marked region
    (fg-line-number-inactive "#546458"))) ; Inactive line numbers margin

(defconst au-whispergrove-night-palette-mappings-partial
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
    (keyword green-cooler)             ; Mapped on #a47028
    (builtin blue-faint)               ; Mapped on #398a80
    (type green)                       ; Mapped on #5ca660
    (preprocessor yellow-cooler)       ; Mapped on #7e5a28
    (constant green-warmer)            ; Mapped on #b05c70
    (number yellow-warmer)             ; Mapped on #bca03c
    (fnname blue)                      ; Mapped on #227086
    (fnname-call blue-warmer)          ; Mapped on #4e92a4
    (string red-warmer)                ; Mapped on #9e604e
    (property fg-alt)                  ; Mapped on #6ea288
    (variable fg-var)                  ; Mapped on #98aba0
    (variable-use fg-main)             ; Variable usage -> #9ca69e
    (operator blue-cooler)             ; Mapped on #5e8274
    (bracket red-faint)                ; Mapped on #687e6b
    (delimiter cyan-faint)             ; Mapped on #6c786e
    (comment green-faint)              ; Buffer comments -> #586c5a
    (docstring green-faint)            ; In-source docstrings -> #586c5a
    (rx-backslash yellow-cooler)       ; Regex backslashes
    (rx-construct red)                 ; Regex constructs

    (accent-0 blue)
    (accent-1 green)
    (accent-2 yellow)
    (accent-3 green-warmer)))

(defconst au-whispergrove-night-palette
  (modus-themes-generate-palette
   au-whispergrove-night-palette-partial
   nil
   nil
   (append au-whispergrove-night-palette-mappings-partial ef-themes-palette-common)))

;;;###theme-autoload
(modus-themes-theme
 'au-whispergrove-night
 'ef-themes
 "Au Whispergrove Night: deep nocturnal rainy forest theme calibrated for autistic sensory-profile and photophobia."
 'dark
 'au-whispergrove-night-palette
 nil
 nil)

(provide 'au-whispergrove-night-theme)
;;; au-whispergrove-night-theme.el ends here
