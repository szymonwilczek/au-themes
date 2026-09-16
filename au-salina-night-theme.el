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
    (cursor "#ac6a3e")                    ; Point / cursor indicator
    (bg-main "#101414")                   ; Primary canvas background
    (bg-dim "#161c1c")                    ; Inactive windows, dim canvas
    (bg-alt "#1e2626")                    ; Subtle borders, alternating stripes
    (fg-main "#8e9fa2")                   ; Default buffer text
    (fg-dim "#566468")                    ; Comments, metadata
    (fg-alt "#587e8c")                    ; Struct properties
    (fg-var "#528ca0")                    ; Variable definitions
    (bg-active "#1e2626")                 ; Active modeline frame, focused bars
    (bg-inactive "#161c1c")               ; Inactive modeline
    (border "#283438")                    ; Window dividers

    ;; Basic Chromatic Scale
    (red "#ba483e")                       ; Errors, critical warnings
    (red-warmer "#846a58")                ; String literals
    (red-cooler "#a24238")                ; Diff deletions, removal markers
    (red-faint "#60747a")                 ; Structural brackets

    (green "#28968a")                     ; Primitive types
    (green-warmer "#b06e3e")              ; Constant values and macros
    (green-cooler "#a8545e")              ; Control keywords
    (green-faint "#546468")               ; Documentation strings, inline comments

    (yellow "#a8545e")                    ; Keyword alias
    (yellow-warmer "#9e8644")             ; Golden dune numeric literals
    (yellow-cooler "#207866")             ; Maritime petrol preprocessor directives
    (yellow-faint "#686858")              ; Informational tooltips, fringe markers

    (blue "#346698")                      ; Oceanic cobalt function definitions
    (blue-warmer "#6094ca")               ; Wave surf blue function calls
    (blue-cooler "#5a7276")               ; Slate oceanic operators
    (blue-faint "#827030")                ; Salted amber built-in functions

    (magenta "#28968a")                   ; Composite types: struct, union, enum
    (magenta-warmer "#6094ca")            ; Extended library types
    (magenta-cooler "#207866")            ; Rare syntax nodes, special escapes
    (magenta-faint "#546468")             ; Inactive conditional blocks

    (cyan "#827030")                      ; Builtin fallback
    (cyan-warmer "#207866")               ; Preprocessor alias
    (cyan-cooler "#5a7276")               ; Operator alias
    (cyan-faint "#60747a")                ; Punctuation delimiters

    ;; Panels, Diffs and Structural Highlights
    (bg-red-intense "#501c18")            ; Blocking errors, fatal assertion panel
    (bg-green-intense "#183828")          ; Success banner
    (bg-yellow-intense "#403212")         ; Warning banner, review request
    (bg-blue-intense "#183242")           ; Info banner, active selections
    (bg-magenta-intense "#361c30")        ; Special prompt background
    (bg-cyan-intense "#163638")           ; Incsearch current match target

    (bg-red-subtle "#341614")             ; Diff context deletion background
    (bg-green-subtle "#14221a")           ; Diff context addition background
    (bg-yellow-subtle "#241e10")          ; Diff whitespace/context change
    (bg-blue-subtle "#121e26")            ; Mode-line subtle indicators
    (bg-magenta-subtle "#281a26")         ; Matching paren context background
    (bg-cyan-subtle "#102022")            ; Structural block highlight

    (bg-added "#143020")                  ; Diff added line baseline
    (bg-added-faint "#0e2216")            ; Diff added unchanged context
    (bg-added-refine "#20462c")           ; Diff added word-level highlight
    (fg-added "#a2dab0")                  ; Diff added foreground text

    (bg-changed "#322a0e")                ; Diff changed line baseline
    (bg-changed-faint "#221c08")          ; Diff changed unchanged context
    (bg-changed-refine "#443a16")         ; Diff changed word-level highlight
    (fg-changed "#d8c272")                ; Diff changed foreground text

    (bg-removed "#361614")                ; Diff removed line baseline
    (bg-removed-faint "#260e0c")          ; Diff removed unchanged context
    (bg-removed-refine "#4e201c")         ; Diff removed word-level highlight
    (fg-removed "#ec928c")                ; Diff removed foreground text

    (bg-mode-line-active "#1e2626")       ; Active modeline surface
    (fg-mode-line-active "#a8b6ba")       ; Active modeline primary text
    (bg-completion "#182224")             ; Minibuffer completion selected row
    (bg-popup "#1a2426")                  ; Autocomplete tooltip surface
    (bg-hover "#202c30")                  ; Mouse hover overlay
    (bg-hover-secondary "#242832")        ; Secondary hover overlay
    (bg-hl-line "#141818")                ; Current line indicator
    (bg-paren-match "#22444e")            ; Matching delimiter highlight
    (bg-err "#3a1816")                    ; Flymake error inline box
    (bg-warning "#322612")                ; Flymake warning inline box
    (bg-info "#16342e")                   ; Flymake info inline box
    (bg-region "#1a344e")                 ; Marked region
    (fg-line-number-inactive "#46585c"))) ; Inactive line numbers margin

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

;;;###theme-autoload
(modus-themes-theme
 'au-salina-night
 'ef-themes
 "Nocturnal coastal theme with deep oceanic and coral tones."
 'dark
 'au-salina-night-palette
 nil
 nil)

(provide 'au-salina-night-theme)
;;; au-salina-night-theme.el ends here
