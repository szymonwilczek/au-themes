;;; au-herbarium-night-theme.el --- Nocturnal herbal theme with dried botanicals and pressed leaves -*- lexical-binding:t -*-

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
;; Nocturnal herbal theme inspired by darkened botanical herbariums, pressed sage leaves,
;; dried lavender petals, oak-gall ink, terracotta flora, and chamomile pollen.
;; Calibrated to minimize visual glare and photophobic strain for autistic
;; and neurodivergent sensory profiles.
;; Part of the `au-themes' collection.

;;; Code:

(require 'ef-themes)

(defconst au-herbarium-night-palette-partial
  '(;; Canvas & Chrome
    (cursor "#9670aa")                    ; Point / cursor indicator
    (bg-main "#141312")                   ; Primary canvas background
    (bg-dim "#1a1816")                    ; Inactive windows, dim canvas
    (bg-alt "#242220")                    ; Subtle borders, alternating stripes
    (fg-main "#969e90")                   ; Default buffer text
    (fg-dim "#5e5850")                    ; Comments, metadata
    (fg-alt "#727e6e")                    ; Struct properties
    (fg-var "#84725c")                    ; Variable definitions
    (bg-active "#242220")                 ; Active modeline frame, focused bars
    (bg-inactive "#1a1816")               ; Inactive modeline
    (border "#36322e")                    ; Window dividers

    ;; Basic Chromatic Scale
    (red "#ba483e")                       ; Errors, critical warnings
    (red-warmer "#446c54")                ; Dried rosemary herbal string literals
    (red-cooler "#a23c34")                ; Diff deletions, removal markers
    (red-faint "#687066")                 ; Structural brackets

    (green "#728c56")                     ; Primitive types
    (green-warmer "#8e709e")              ; Constant values and macros
    (green-cooler "#ac5872")              ; Control keywords
    (green-faint "#5a5e54")               ; Documentation strings, inline comments

    (yellow "#ac5872")                    ; Keyword alias
    (yellow-warmer "#b48e3c")             ; Numeric literals
    (yellow-cooler "#3c7674")             ; Preprocessor directives
    (yellow-faint "#6e6856")              ; Informational tooltips, fringe markers

    (blue "#5c5c82")                      ; Function definitions
    (blue-warmer "#b28448")               ; Function calls
    (blue-cooler "#6c7068")               ; Binary and unary operators
    (blue-faint "#927658")                ; Built-in functions

    (magenta "#728c56")                   ; Composite types: struct, union, enum
    (magenta-warmer "#b28448")            ; Extended library types
    (magenta-cooler "#3c7674")            ; Rare syntax nodes, special escapes
    (magenta-faint "#5e6056")             ; Inactive conditional blocks

    (cyan "#927658")                      ; Builtin fallback
    (cyan-warmer "#3c7674")               ; Preprocessor alias
    (cyan-cooler "#6c7068")               ; Operator alias
    (cyan-faint "#687066")                ; Punctuation delimiters

    ;; Panels, Diffs and Structural Highlights
    (bg-red-intense "#4e1a18")            ; Blocking errors, fatal assertion panel
    (bg-green-intense "#223620")          ; Success banner
    (bg-yellow-intense "#403012")         ; Warning banner, review request
    (bg-blue-intense "#1e2a38")           ; Info banner, active selections
    (bg-magenta-intense "#361e32")        ; Special prompt background
    (bg-cyan-intense "#18302c")           ; Incsearch current match target

    (bg-red-subtle "#321412")             ; Diff context deletion background
    (bg-green-subtle "#182218")           ; Diff context addition background
    (bg-yellow-subtle "#242012")          ; Diff whitespace/context change
    (bg-blue-subtle "#181e24")            ; Mode-line subtle indicators
    (bg-magenta-subtle "#281a28")         ; Matching paren context background
    (bg-cyan-subtle "#14201e")            ; Structural block highlight

    (bg-added "#163018")                  ; Diff added line baseline
    (bg-added-faint "#102212")            ; Diff added unchanged context
    (bg-added-refine "#204422")           ; Diff added word-level highlight
    (fg-added "#a2d8a8")                  ; Diff added foreground text

    (bg-changed "#32280c")                ; Diff changed line baseline
    (bg-changed-faint "#221a08")          ; Diff changed unchanged context
    (bg-changed-refine "#463614")         ; Diff changed word-level highlight
    (fg-changed "#d8be6e")                ; Diff changed foreground text

    (bg-removed "#361412")                ; Diff removed line baseline
    (bg-removed-faint "#260c0a")          ; Diff removed unchanged context
    (bg-removed-refine "#4e1c18")         ; Diff removed word-level highlight
    (fg-removed "#ec8e88")                ; Diff removed foreground text

    (bg-mode-line-active "#242220")       ; Active modeline surface
    (fg-mode-line-active "#b0aaa0")       ; Active modeline primary text
    (bg-completion "#1c1a18")             ; Minibuffer completion selected row
    (bg-popup "#1e1c1a")                  ; Autocomplete tooltip surface
    (bg-hover "#262422")                  ; Mouse hover overlay
    (bg-hover-secondary "#2a242c")        ; Secondary hover overlay
    (bg-hl-line "#181614")                ; Current line indicator
    (bg-paren-match "#342838")            ; Matching delimiter highlight
    (bg-err "#3a1614")                    ; Flymake error inline box
    (bg-warning "#322410")                ; Flymake warning inline box
    (bg-info "#143020")                   ; Flymake info inline box
    (bg-region "#3c2842")                 ; Marked region
    (fg-line-number-inactive "#5a564e"))) ; Inactive line numbers margin

(defconst au-herbarium-night-palette-mappings-partial
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

(defconst au-herbarium-night-palette
  (modus-themes-generate-palette
   au-herbarium-night-palette-partial
   nil
   nil
   (append au-herbarium-night-palette-mappings-partial ef-themes-palette-common)))

;;;###theme-autoload
(modus-themes-theme
 'au-herbarium-night
 'ef-themes
 "Nocturnal herbal theme with dried botanicals and pressed leaves."
 'dark
 'au-herbarium-night-palette
 nil
 nil)

(provide 'au-herbarium-night-theme)
;;; au-herbarium-night-theme.el ends here
