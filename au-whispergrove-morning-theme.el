;;; au-whispergrove-morning-theme.el --- Subdued daylight theme with reduced canvas luminance -*- lexical-binding:t -*-

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
;; Light theme with subdued canvas luminance.
;; Designed for sensitive eyes in early daylight or low ambient illumination.
;; Part of the `au-themes' collection.

;;; Code:

(require 'ef-themes)

(defconst au-whispergrove-morning-palette-partial
  '(;; Canvas & Chrome
    (cursor "#06566c")                 ; Point / cursor indicator
    (bg-main "#9aa29c")                ; Primary canvas background
    (bg-dim "#8c948e")                 ; Inactive windows, dim canvas
    (bg-alt "#7e8680")                 ; Subtle borders, alternating stripes
    (fg-main "#141c16")                ; Default buffer text
    (fg-dim "#425046")                 ; Comments, metadata
    (fg-alt "#503c5a")                 ; Struct properties
    (fg-var "#0e4a42")                 ; Variable definitions
    (bg-active "#808882")              ; Active modeline frame, focused bars
    (bg-inactive "#8c948e")            ; Inactive modeline
    (border "#626a64")                 ; Window dividers


    ;; Basic Chromatic Scale
    (red "#94322a")                    ; Errors, critical warnings
    (red-warmer "#5c1e10")             ; String literals
    (red-cooler "#7a2822")             ; Diff deletions, removal markers
    (red-faint "#32443a")              ; Structural brackets

    (green "#085a38")                  ; Primitive types
    (green-warmer "#541434")           ; Constant values and macros
    (green-cooler "#502f12")           ; Control keywords
    (green-faint "#425046")            ; Documentation strings, inline comments

    (yellow "#502f12")                 ; Keyword alias
    (yellow-warmer "#5e5000")          ; Numeric literals
    (yellow-cooler "#363412")          ; Preprocessor directives
    (yellow-faint "#4a4438")           ; Informational tooltips, fringe markers

    (blue "#303753")                   ; Function definitions
    (blue-warmer "#085474")            ; Function calls
    (blue-cooler "#324244")            ; Binary and unary operators
    (blue-faint "#085046")             ; Built-in functions

    (magenta "#502f12")                ; Composite types: struct, union, enum
    (magenta-warmer "#0e4a42")         ; Extended library types
    (magenta-cooler "#48243c")         ; Rare syntax nodes, special escapes
    (magenta-faint "#425046")          ; Inactive conditional blocks

    (cyan "#502f12")                   ; Keyword fallback
    (cyan-warmer "#363412")            ; Preprocessor alias
    (cyan-cooler "#324244")            ; Operator alias
    (cyan-faint "#2a3832")             ; Punctuation delimiters

    ;; Panels, Diffs and Structural Highlights
    (bg-red-intense "#e09d9c")         ; Blocking errors, fatal assertion panel
    (bg-green-intense "#90b987")       ; Success banner
    (bg-yellow-intense "#caaa66")      ; Warning banner, review request
    (bg-blue-intense "#72b7d2")        ; Info banner, active selections
    (bg-magenta-intense "#d19fc5")     ; Special prompt background
    (bg-cyan-intense "#6fbcad")        ; Incsearch current match target

    (bg-red-subtle "#ac9494")          ; Diff context deletion background
    (bg-green-subtle "#91ac8b")        ; Diff context addition background
    (bg-yellow-subtle "#b6a98e")       ; Diff whitespace/context change
    (bg-blue-subtle "#92b4c2")         ; Mode-line subtle indicators
    (bg-magenta-subtle "#b8a4b4")      ; Matching paren context background
    (bg-cyan-subtle "#92bbb2")         ; Structural block highlight

    (bg-added "#8eb88e")               ; Diff added line baseline
    (bg-added-faint "#a2c6a2")         ; Diff added unchanged context
    (bg-added-refine "#7cae7c")        ; Diff added word-level highlight
    (fg-added "#00400e")               ; Diff added foreground text

    (bg-changed "#c0b07a")             ; Diff changed line baseline
    (bg-changed-faint "#ccbe90")       ; Diff changed unchanged context
    (bg-changed-refine "#b29e64")      ; Diff changed word-level highlight
    (fg-changed "#403000")             ; Diff changed foreground text

    (bg-removed "#be9898")             ; Diff removed line baseline
    (bg-removed-faint "#cbaeae")       ; Diff removed unchanged context
    (bg-removed-refine "#b08080")      ; Diff removed word-level highlight
    (fg-removed "#500a0a")             ; Diff removed foreground text

    (bg-mode-line-active "#848c86")    ; Active modeline surface
    (fg-mode-line-active "#08100a")    ; Active modeline primary text
    (bg-completion "#929a94")          ; Minibuffer completion selected row
    (bg-popup "#a2aaa4")               ; Autocomplete tooltip surface
    (bg-hover "#889098")               ; Mouse hover overlay
    (bg-hover-secondary "#908c9c")     ; Secondary hover overlay
    (bg-hl-line "#8e9690")             ; Current line indicator
    (bg-paren-match "#749c86")         ; Matching delimiter highlight
    (bg-err "#b88686")                 ; Flymake error inline box
    (bg-warning "#b8a876")             ; Flymake warning inline box
    (bg-info "#84aa8e")                ; Flymake info inline box
    (bg-region "#6cb296")              ; Marked region
    (fg-line-number-inactive "#46504a"))) ; Inactive line numbers margin

(defconst au-whispergrove-morning-palette-mappings-partial
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

(defconst au-whispergrove-morning-palette
  (modus-themes-generate-palette
   au-whispergrove-morning-palette-partial
   nil
   nil
   (append au-whispergrove-morning-palette-mappings-partial ef-themes-palette-common)))

;;;###theme-autoload
(modus-themes-theme
 'au-whispergrove-morning
 'ef-themes
 "Subdued daylight theme with reduced canvas luminance for sensitive eyes."
 'light
 'au-whispergrove-morning-palette
 nil
 nil)

(provide 'au-whispergrove-morning-theme)
;;; au-whispergrove-morning-theme.el ends here
