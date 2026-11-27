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
;; Calibrated for sensitive eyes in early daylight or low ambient
;; illumination.
;; Part of the `au-themes' collection.

;;; Code:

(require 'modus-themes)
(require 'au-themes)

(defconst au-themes-whispergrove-morning-palette-partial
  '(;; Canvas & Chrome
    (cursor "#06566c")                    ; Point / cursor indicator
    (bg-main "#9aa29c")                   ; Primary canvas background
    (bg-dim "#8c948e")                    ; Inactive windows, dim canvas
    (bg-alt "#919993")                    ; Subtle borders, alternating stripes
    (fg-main "#141c16")                   ; Default buffer text
    (fg-dim "#425046")                    ; Comments, metadata
    (fg-info "#01663b")                   ; Info notes, marks, rebase commits done
    (fg-accent "#303457")                 ; Accent: current rebase commit, completion match
    (fg-alt "#58415f")                    ; Struct properties
    (fg-var "#4b4e29")                    ; Variable definitions
    (bg-active "#808882")                 ; Active modeline frame, focused bars
    (bg-inactive "#8c948e")               ; Inactive modeline
    (border "#626a64")                    ; Window dividers

    ;; Basic Chromatic Scale
    (red "#94322a")                       ; Errors, critical warnings
    (red-warmer "#482509")                ; String literals
    (red-cooler "#7a2822")                ; Diff deletions, removal markers
    (red-faint "#353422")                 ; Structural brackets

    (green "#0e5937")                     ; Primitive types
    (green-warmer "#521236")              ; Constant values and macros
    (green-cooler "#473707")              ; Control keywords
    (green-faint "#4f5f53")               ; Documentation strings, inline comments

    (yellow "#502f12")                    ; Keyword alias
    (yellow-warmer "#6f4238")             ; Numeric literals
    (yellow-cooler "#1c3716")             ; Preprocessor directives
    (yellow-faint "#4a4438")              ; Informational tooltips, fringe markers

    (blue "#353757")                      ; Function definitions
    (blue-warmer "#055373")               ; Function calls
    (blue-cooler "#2d3d3f")               ; Binary and unary operators
    (blue-faint "#034d44")                ; Built-in functions

    (magenta "#502f12")                   ; Composite types: struct, union, enum
    (magenta-warmer "#0e4a42")            ; Extended library types
    (magenta-cooler "#48243c")            ; Rare syntax nodes, special escapes
    (magenta-faint "#425046")             ; Inactive conditional blocks

    (cyan "#502f12")                      ; Keyword fallback
    (cyan-warmer "#1c3716")               ; Preprocessor alias
    (cyan-cooler "#324244")               ; Operator alias
    (cyan-faint "#2c3b33")                ; Punctuation delimiters

    ;; Panels, Diffs and Structural Highlights
    (bg-red-intense "#e09d9c")            ; Blocking errors, fatal assertion panel
    (bg-green-intense "#90b987")          ; Success banner
    (bg-yellow-intense "#caaa66")         ; Warning banner, review request
    (bg-blue-intense "#72b7d2")           ; Info banner, active selections
    (bg-magenta-intense "#d19fc5")        ; Special prompt background
    (bg-cyan-intense "#6fbcad")           ; Incsearch current match target

    (bg-red-subtle "#ac9494")             ; Diff context deletion background
    (bg-green-subtle "#91ac8b")           ; Diff context addition background
    (bg-yellow-subtle "#b6a98e")          ; Diff whitespace/context change
    (bg-blue-subtle "#92b4c2")            ; Mode-line subtle indicators
    (bg-magenta-subtle "#b8a4b4")         ; Matching paren context background
    (bg-cyan-subtle "#92bbb2")            ; Structural block highlight

    (bg-added "#8eb88e")                  ; Diff added line baseline
    (bg-added-faint "#a2c6a2")            ; Diff added unchanged context
    (bg-added-refine "#7cae7c")           ; Diff added word-level highlight
    (fg-added "#00400e")                  ; Diff added foreground text

    (bg-changed "#c0b07a")                ; Diff changed line baseline
    (bg-changed-faint "#ccbe90")          ; Diff changed unchanged context
    (bg-changed-refine "#b29e64")         ; Diff changed word-level highlight
    (fg-changed "#403000")                ; Diff changed foreground text

    (bg-removed "#be9898")                ; Diff removed line baseline
    (bg-removed-faint "#cbaeae")          ; Diff removed unchanged context
    (bg-removed-refine "#b08080")         ; Diff removed word-level highlight
    (fg-removed "#500a0a")                ; Diff removed foreground text

    (bg-mode-line-active "#959d97")       ; Active modeline surface
    (fg-mode-line-active "#08100a")       ; Active modeline primary text
    (bg-completion "#888f8a")             ; Minibuffer completion selected row
    (bg-popup "#a2aaa4")                  ; Autocomplete tooltip surface
    (bg-hover "#889098")                  ; Mouse hover overlay
    (bg-hover-secondary "#908c9c")        ; Secondary hover overlay
    (bg-hl-line "#8e9690")                ; Current line indicator
    (bg-paren-match "#749c86")            ; Matching delimiter highlight
    (bg-err "#b88686")                    ; Flymake error inline box
    (bg-warning "#b8a876")                ; Flymake warning inline box
    (bg-info "#84aa8e")                   ; Flymake info inline box
    (bg-region "#6cb296")                 ; Marked region
    (fg-line-number-inactive "#46504a"))) ; Inactive line numbers margin

(defconst au-themes-whispergrove-morning-palette-mappings-partial
  '((err red)
    (warning yellow-warmer)
    (info fg-info)

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

    (accent-0 fg-accent)
    (accent-1 green)
    (accent-2 yellow)
    (accent-3 green-warmer)))

(defconst au-themes-whispergrove-morning-palette
  (modus-themes-generate-palette
   au-themes-whispergrove-morning-palette-partial
   nil
   nil
   (append au-themes-whispergrove-morning-palette-mappings-partial au-themes-palette-common)))

;;;###theme-autoload
(modus-themes-theme
 'au-whispergrove-morning
 'au-themes
 "Subdued daylight theme with reduced canvas luminance for sensitive eyes."
 'light
 'au-themes-whispergrove-morning-palette
 nil
 nil)

(provide 'au-whispergrove-morning-theme)
;;; au-whispergrove-morning-theme.el ends here
