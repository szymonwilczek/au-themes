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
    (cursor "#b484cc")                    ; Point / cursor indicator
    (bg-main "#11140e")                   ; Primary canvas background
    (bg-dim "#1b2016")                    ; Inactive windows, dim canvas
    (bg-alt "#252c20")                    ; Subtle borders, alternating stripes
    (fg-main "#9aaaa0")                   ; Default buffer text
    (fg-dim "#606a5a")                    ; Comments, metadata
    (fg-alt "#7c8e6a")                    ; Struct properties
    (fg-var "#629e72")                    ; Variable definitions
    (bg-active "#252c20")                 ; Active modeline frame, focused bars
    (bg-inactive "#1b2016")               ; Inactive modeline
    (border "#384232")                    ; Window dividers

    ;; Basic Chromatic Scale
    (red "#ba483e")                       ; Errors, critical warnings
    (red-warmer "#50906c")                ; String literals
    (red-cooler "#a83832")                ; Diff deletions, removal markers
    (red-faint "#707e6c")                 ; Structural brackets

    (green "#869c3c")                     ; Primitive types
    (green-warmer "#9a70b2")              ; Constant values and macros
    (green-cooler "#b66086")              ; Control keywords
    (green-faint "#606a5a")               ; Documentation strings, inline comments

    (yellow "#b66086")                    ; Keyword alias
    (yellow-warmer "#bc983c")             ; Numeric literals
    (yellow-cooler "#3c7a7a")             ; Preprocessor directives
    (yellow-faint "#706850")              ; Informational tooltips, fringe markers

    (blue "#526294")                      ; Function definitions
    (blue-warmer "#ba8046")               ; Function calls
    (blue-cooler "#70806c")               ; Binary and unary operators
    (blue-faint "#6e8046")                ; Built-in functions

    (magenta "#869c3c")                   ; Composite types: struct, union, enum
    (magenta-warmer "#ba8046")            ; Extended library types
    (magenta-cooler "#3c7a7a")            ; Rare syntax nodes, special escapes
    (magenta-faint "#626a5c")             ; Inactive conditional blocks

    (cyan "#6e8046")                      ; Builtin fallback
    (cyan-warmer "#3c7a7a")               ; Preprocessor alias
    (cyan-cooler "#70806c")               ; Operator alias
    (cyan-faint "#6e7e68")                ; Punctuation delimiters

    ;; Panels, Diffs and Structural Highlights
    (bg-red-intense "#541c16")            ; Blocking errors, fatal assertion panel
    (bg-green-intense "#223c20")          ; Success banner
    (bg-yellow-intense "#443412")         ; Warning banner, review request
    (bg-blue-intense "#1a3430")           ; Info banner, active selections
    (bg-magenta-intense "#381e34")        ; Special prompt background
    (bg-cyan-intense "#18362a")           ; Incsearch current match target

    (bg-red-subtle "#2e1814")             ; Diff context deletion background
    (bg-green-subtle "#162216")           ; Diff context addition background
    (bg-yellow-subtle "#262010")          ; Diff whitespace/context change
    (bg-blue-subtle "#14201e")            ; Mode-line subtle indicators
    (bg-magenta-subtle "#281a26")         ; Matching paren context background
    (bg-cyan-subtle "#12221c")            ; Structural block highlight

    (bg-added "#18341a")                  ; Diff added line baseline
    (bg-added-faint "#122614")            ; Diff added unchanged context
    (bg-added-refine "#244a26")           ; Diff added word-level highlight
    (fg-added "#a8deb0")                  ; Diff added foreground text

    (bg-changed "#362c0e")                ; Diff changed line baseline
    (bg-changed-faint "#261e0a")          ; Diff changed unchanged context
    (bg-changed-refine "#4a3c14")         ; Diff changed word-level highlight
    (fg-changed "#dec474")                ; Diff changed foreground text

    (bg-removed "#3a1614")                ; Diff removed line baseline
    (bg-removed-faint "#2a0e0c")          ; Diff removed unchanged context
    (bg-removed-refine "#52201c")         ; Diff removed word-level highlight
    (fg-removed "#f0948e")                ; Diff removed foreground text

    (bg-mode-line-active "#252c20")       ; Active modeline surface
    (fg-mode-line-active "#aebcb2")       ; Active modeline primary text
    (bg-completion "#1e261a")             ; Minibuffer completion selected row
    (bg-popup "#20281c")                  ; Autocomplete tooltip surface
    (bg-hover "#263422")                  ; Mouse hover overlay
    (bg-hover-secondary "#2c3024")        ; Secondary hover overlay
    (bg-hl-line "#171c12")                ; Current line indicator
    (bg-paren-match "#2a4834")            ; Matching delimiter highlight
    (bg-err "#3c1816")                    ; Flymake error inline box
    (bg-warning "#362810")                ; Flymake warning inline box
    (bg-info "#163424")                   ; Flymake info inline box
    (bg-region "#3a2c46")                 ; Marked region
    (fg-line-number-inactive "#566250"))) ; Inactive line numbers margin

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

(defconst au-herbarium-night-custom-faces
  '(`(font-lock-keyword-face ((,c :slant italic :foreground ,keyword)))
    `(font-lock-builtin-face ((,c :slant italic :foreground ,builtin)))
    `(font-lock-comment-face ((,c :slant italic :foreground ,comment)))
    `(font-lock-doc-face ((,c :slant italic :foreground ,docstring)))
    `(font-lock-type-face ((,c :slant italic :foreground ,type)))))

;;;###theme-autoload
(modus-themes-theme
 'au-herbarium-night
 'ef-themes
 "Nocturnal herbal theme with dried botanicals and pressed leaves."
 'dark
 'au-herbarium-night-palette
 nil
 nil
 'au-herbarium-night-custom-faces)

(provide 'au-herbarium-night-theme)
;;; au-herbarium-night-theme.el ends here
