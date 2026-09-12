;;; au-rainforest-night-theme.el --- Deep nocturnal rainy forest theme for Au-themes -*- lexical-binding:t -*-

(require 'ef-themes)

(defconst au-rainforest-night-palette-partial
  '(;; Canvas & Chrome
    (cursor "#4e92a8")
    (bg-main "#0f0e06")
    (bg-dim "#26211d")
    (bg-alt "#36322f")
    (fg-main "#9ca69e")
    (fg-dim "#58685a")
    (fg-alt "#a08c4a")
    (fg-var "#a2ada4")
    (bg-active "#56524f")
    (bg-inactive "#25241d")
    (border "#58514f")

    (red "#d15f55")
    (red-warmer "#b26236")
    (red-cooler "#d15f55")
    (red-faint "#6c806e")

    (green "#7aa854")
    (green-warmer "#869c44")
    (green-cooler "#3b8c49")
    (green-faint "#58685a")

    (yellow "#3b8c49")
    (yellow-warmer "#caa240")
    (yellow-cooler "#8c5020")
    (yellow-faint "#58685a")

    (blue "#3e84be")
    (blue-warmer "#66a4d2")
    (blue-cooler "#6e867c")
    (blue-faint "#63a58f")

    (magenta "#869c44")
    (magenta-warmer "#63a58f")
    (magenta-cooler "#63a58f")
    (magenta-faint "#58685a")

    (cyan "#3b8c49")
    (cyan-warmer "#8c5020")
    (cyan-cooler "#6e867c")
    (cyan-faint "#8e8884")

    ;; Panels and Diffs
    (bg-red-intense "#b02930")
    (bg-green-intense "#4a7000")
    (bg-yellow-intense "#8f5040")
    (bg-blue-intense "#4648d0")
    (bg-magenta-intense "#804fd5")
    (bg-cyan-intense "#2270be")

    (bg-red-subtle "#651f2a")
    (bg-green-subtle "#11422f")
    (bg-yellow-subtle "#583020")
    (bg-blue-subtle "#2f3069")
    (bg-magenta-subtle "#542657")
    (bg-cyan-subtle "#123e55")

    (bg-added "#17360f")
    (bg-added-faint "#0a2900")
    (bg-added-refine "#204810")
    (fg-added "#a0e0a0")

    (bg-changed "#363300")
    (bg-changed-faint "#2a1f00")
    (bg-changed-refine "#4a4a00")
    (fg-changed "#efef80")

    (bg-removed "#4b120a")
    (bg-removed-faint "#3a0a00")
    (bg-removed-refine "#6f1a16")
    (fg-removed "#ffbfbf")

    (bg-mode-line-active "#692a12")
    (fg-mode-line-active "#feeeca")
    (bg-completion "#392942")
    (bg-popup "#201e16")
    (bg-hover "#265f4a")
    (bg-hover-secondary "#55345a")
    (bg-hl-line "#141c16")
    (bg-paren-match "#2f6c4a")
    (bg-err "#461204")
    (bg-warning "#353504")
    (bg-info "#1f3b0a")
    (bg-region "#3f1324")
    (fg-line-number-inactive "#887c8a")))

(defconst au-rainforest-night-palette-mappings-partial
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
    (keyword cyan)
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
    (accent-2 yellow-warmer)
    (accent-3 green-warmer)))

(defconst au-rainforest-night-palette
  (modus-themes-generate-palette
   au-rainforest-night-palette-partial
   nil
   nil
   (append au-rainforest-night-palette-mappings-partial ef-themes-palette-common)))

;;;###theme-autoload
(modus-themes-theme
 'au-rainforest-night
 'ef-themes
 "Au Rainforest Night: deep nocturnal rainy forest theme calibrated for autistic sensory-profile and photophobia."
 'dark
 'au-rainforest-night-palette
 nil
 nil)

;; Backward-compatibility aliases
(defvaralias 'rainforest-night-palette 'au-rainforest-night-palette)
(defvaralias 'rainforest-night-palette-partial 'au-rainforest-night-palette-partial)

(provide 'au-rainforest-night-theme)
(provide 'rainforest-night-theme)
;;; au-rainforest-night-theme.el ends here
