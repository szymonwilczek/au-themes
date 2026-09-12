;;; rainforest-night-theme.el --- Deep rainy forest shelter theme -*- lexical-binding:t -*-

(require 'ef-themes)

(defconst rainforest-night-palette-partial
  '((cursor "#ffaa33")
    (bg-main "#0f0e06")
    (bg-dim "#26211d")
    (bg-alt "#36322f")
    (fg-main "#cfbcba")
    (fg-dim "#887c8a")
    (fg-alt "#70a89f")
    (bg-active "#56524f")
    (bg-inactive "#25241d")
    (border "#58514f")

    (red "#ef656a")
    (red-warmer "#f06a3f")
    (red-cooler "#ff7a7f")
    (red-faint "#df7f7f")
    (green "#2fa526")
    (green-warmer "#64aa0f")
    (green-cooler "#00b066")
    (green-faint "#5f9f6f")
    (yellow "#c48702")
    (yellow-warmer "#d0730f")
    (yellow-cooler "#df8f6f")
    (yellow-faint "#cf9f7f")
    (blue "#379cf6")
    (blue-warmer "#6a88ff")
    (blue-cooler "#029fff")
    (blue-faint "#6a84af")
    (magenta "#d570af")
    (magenta-warmer "#e580ea")
    (magenta-cooler "#af8aff")
    (magenta-faint "#c590af")
    (cyan "#4fb0cf")
    (cyan-warmer "#6fafff")
    (cyan-cooler "#3dbbb0")
    (cyan-faint "#82a0af")

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
    (bg-hl-line "#302a3a")
    (bg-paren-match "#2f6c4a")
    (bg-err "#461204")
    (bg-warning "#353504")
    (bg-info "#1f3b0a")
    (bg-region "#3f1324")
    (fg-line-number-inactive "#887c8a")))

(defconst rainforest-night-palette-mappings-partial
  '((err red-warmer)
    (warning yellow)
    (info green-cooler)

    (fg-link yellow)
    (fg-link-visited cyan-cooler)
    (name green-warmer)
    (keybind red-warmer)
    (identifier magenta-faint)
    (fg-prompt cyan-cooler)

    (builtin red-cooler)
    (comment yellow-faint)
    (constant green-warmer)
    (fnname cyan-cooler)
    (fnname-call cyan-faint)
    (keyword yellow)
    (preprocessor magenta)
    (docstring green-faint)
    (string red-warmer)
    (type green)
    (variable cyan-warmer)
    (variable-use cyan-faint)
    (property variable)
    (number fg-main)
    (operator fg-main)
    (bracket fg-main)
    (delimiter fg-main)
    (rx-backslash green-cooler)
    (rx-construct magenta-cooler)

    (accent-0 green-cooler)
    (accent-1 yellow-warmer)
    (accent-2 cyan-cooler)
    (accent-3 magenta-cooler)))

(defconst rainforest-night-palette
  (modus-themes-generate-palette
   rainforest-night-palette-partial
   nil
   nil
   (append rainforest-night-palette-mappings-partial ef-themes-palette-common)))

;;;###theme-autoload
(modus-themes-theme
 'rainforest-night
 'ef-themes
 "Deep nocturnal rainy forest theme - ef-autumn recalibration baseline."
 'dark
 'rainforest-night-palette
 nil
 nil)

;; Universal standard font-lock faces (initialized from ef-autumn baseline):
(custom-theme-set-faces
 'rainforest-night
 '(font-lock-comment-face ((t (:foreground "#cf9f7f" :slant italic))))
 '(font-lock-comment-delimiter-face ((t (:foreground "#cf9f7f" :slant italic))))
 '(font-lock-doc-face ((t (:foreground "#5f9f6f" :slant italic))))
 '(font-lock-preprocessor-face ((t (:foreground "#d570af"))))
 '(font-lock-keyword-face ((t (:foreground "#c48702"))))
 '(font-lock-type-face ((t (:foreground "#2fa526"))))
 '(font-lock-constant-face ((t (:foreground "#64aa0f"))))
 '(font-lock-number-face ((t (:foreground "#cfbcba"))))
 '(font-lock-builtin-face ((t (:foreground "#ff7a7f"))))
 '(font-lock-function-name-face ((t (:foreground "#3dbbb0"))))
 '(font-lock-function-call-face ((t (:foreground "#82a0af"))))
 '(font-lock-string-face ((t (:foreground "#f06a3f"))))
 '(font-lock-variable-name-face ((t (:foreground "#6fafff"))))
 '(font-lock-variable-use-face ((t (:foreground "#82a0af"))))
 '(font-lock-property-name-face ((t (:foreground "#6fafff"))))
 '(font-lock-property-use-face ((t (:foreground "#6fafff"))))
 '(font-lock-operator-face ((t (:foreground "#cfbcba"))))
 '(font-lock-bracket-face ((t (:foreground "#cfbcba"))))
 '(font-lock-delimiter-face ((t (:foreground "#cfbcba"))))
 '(font-lock-warning-face ((t (:foreground "#f06a3f"))))
 '(region ((t (:background "#3f1324" :extend t))))
 '(line-number ((t (:foreground "#887c8a")))))

(provide 'rainforest-night-theme)
;;; rainforest-night-theme.el ends here
