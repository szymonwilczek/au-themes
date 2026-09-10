;;; rainforest-day.el --- Rainy coniferous forest light theme -*- lexical-binding:t -*-

(require 'ef-themes)

(defconst rainforest-day-palette-partial
  '(;; Tła: zamglony, chłodniejszy deszczowy bór (ciemniejszy od Arcadii o ~10% luminancji)
    (cursor "#335544")
    (bg-main "#cbd5c5")       ; zamglony, chłodny bór iglasty
    (bg-dim "#c0ccbb")        ; mokra ziemia/kamień
    (bg-alt "#b5c2b0")
    (fg-main "#192d20")       ; wilgotny cień świerku (APCA Lc: 75.08 - ciągły tekst Lc >= 75)
    (fg-dim "#405b63")        ; stalowa mgła leśna (APCA Lc: 58.88)
    (fg-alt "#3d5446")

    (bg-active "#9fb09a")
    (bg-inactive "#b8c5b3")
    (border "#8a9c85")

    ;; Barwy semantyczne boru w deszczu
    (red "#852a1d")           ; wilgotna kora sosny (~6.5:1)
    (red-warmer "#912812")
    (red-cooler "#7d2c2e")
    (red-faint "#6e3f3a")

    (green "#1c5a2c")         ; mech leśny (akcent uspokajający jak w Arcadii, ~5.8:1)
    (green-warmer "#2e5f15")  ; młode igliwie
    (green-cooler "#115c48")  ; wilgotny świerk
    (green-faint "#2a5438")

    (yellow "#634710")        ; promień słońca przez mgłę (~6.0:1)
    (yellow-warmer "#703e05")
    (yellow-cooler "#604d2b")
    (yellow-faint "#594d33")

    (blue "#1e4678")          ; głęboka woda kałuży (~6.2:1)
    (blue-warmer "#2b428c")
    (blue-cooler "#104c7d")
    (blue-faint "#324968")

    (magenta "#6e3b68")       ; wrzosowisko (~5.5:1)
    (magenta-warmer "#7d3058")
    (magenta-cooler "#503e7a")
    (magenta-faint "#5c4359")

    (cyan "#10525e")          ; krople deszczu / mgła (~6.1:1)
    (cyan-warmer "#1c4e6e")
    (cyan-cooler "#0a5652")
    (cyan-faint "#2f4d54")

    ;; Stany i diffy (łagodne dla oka)
    (bg-added "#a8ccae")
    (bg-added-faint "#b8d9be")
    (bg-added-refine "#94bfa0")
    (fg-added "#12451d")

    (bg-changed "#d6cd96")
    (bg-changed-faint "#dfd7aa")
    (bg-changed-refine "#c7be7f")
    (fg-changed "#4a3c00")

    (bg-removed "#d8b2a8")
    (bg-removed-faint "#e2c4bc")
    (bg-removed-refine "#cb9e93")
    (fg-removed "#691b15")

    (bg-mode-line-active "#9ab89e")
    (fg-mode-line-active "#122b1a")
    (bg-completion "#adc2b0")
    (bg-popup "#c2cebe")
    (bg-hover "#a8c0ab")
    (bg-hover-secondary "#a0b8aa")
    (bg-hl-line "#c3cfbf")
    (bg-paren-match "#96b59d")
    (bg-err "#dab3aa")
    (bg-warning "#dad09f")
    (bg-info "#a2ccb0")
    (bg-region "#b0c4b2")))

(defconst rainforest-day-palette-mappings-partial
  '((err red-warmer)
    (warning yellow-warmer)
    (info green-cooler)

    (fg-link blue)
    (fg-link-visited magenta-cooler)
    (name green-cooler)
    (keybind cyan)
    (identifier fg-dim)
    (fg-prompt green-cooler)

    ;; Składnia: bór i zgaszone słońce
    (builtin green)
    (comment fg-dim)
    (constant cyan)
    (fnname green-warmer)
    (fnname-call green)
    (keyword cyan-cooler)
    (preprocessor blue-faint)
    (docstring cyan-faint)
    (string yellow)
    (type green-cooler)
    (variable fg-main)
    (variable-use fg-alt)
    (rx-backslash yellow-cooler)
    (rx-construct red-cooler)

    (accent-0 green)
    (accent-1 yellow)
    (accent-2 cyan)
    (accent-3 green-warmer)))

(defconst rainforest-day-palette
  (modus-themes-generate-palette
   rainforest-day-palette-partial
   nil
   nil
   (append rainforest-day-palette-mappings-partial ef-themes-palette-common)))

;;;###theme-autoload
(modus-themes-theme
 'rainforest-day
 'ef-themes
 "Ergonomiczny motyw dzienny boru w deszczu (APCA Lc >= 75 / WCAG 3)."
 'light
 'rainforest-day-palette
 nil
 nil)

;; Komentarze: czysta kursywa bez narzucania wagi czcionki
(custom-theme-set-faces
 'rainforest-day
 '(font-lock-comment-face ((t (:foreground "#405b63" :slant italic))))
 '(font-lock-comment-delimiter-face ((t (:foreground "#405b63" :slant italic))))
 '(font-lock-doc-face ((t (:foreground "#405b63" :slant italic)))))

(provide 'rainforest-day-theme)
;;; rainforest-day-theme.el ends here
