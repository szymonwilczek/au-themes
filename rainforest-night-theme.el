;;; rainforest-night-theme.el --- Deep rainy forest shelter theme -*- lexical-binding:t -*-

(require 'ef-themes)

(defconst rainforest-night-palette-partial
  '(;; Płótno: głęboka noc w borze iglastym (organiczny mrok, zero morskiej szarości)
    (cursor "#4e92a8")        ; KURSOR: Lśniąca, chłodna kropla deszczu (APCA Lc ≈ 45-47)
    (bg-main "#0d110f")       ; Ciemna, bezpieczna próchnica boru pod osłoną nocy
    (bg-dim "#131815")        ; Nasiąknięty pień świerku
    (bg-alt "#19201c")        ; Głęboki cień pod gałęziami
    (fg-main "#abb6a2")       ; Mokry len (APCA LCD: 58.84, OLED: 57.90 - ostra definicja bez rozlewania)
    ;; Komentarze: ciemne igliwie w ściółce (leży cicho pod kodem)
    (fg-dim "#4f6154")        ; APCA Lc ≈ 23
    ;; Argumenty i identyfikatory (txt, bg): wilgotny piaskowiec
    (fg-alt "#8fa08b")        ; APCA Lc ≈ 51.8, Δ do komentarzy = 33 872

    (bg-active "#202a24")
    (bg-inactive "#111513")
    (border "#1c2520")

    ;; Składnia: głębokie, soczyste barwy przesiąknięte deszczem (brak wyblakłych pasteli)
    (red "#b54a3e")           ; Alerty: wilgotny owoc cisa
    (red-warmer "#c05432")
    (red-cooler "#aa4c50")
    (red-faint "#884e46")

    (green "#549842")         ; TYPY: Soczysty, mokry mech borowy (APCA Lc ≈ 44)
    (green-warmer "#62a038")
    (green-cooler "#489850")
    (green-faint "#4c7a3e")

    (yellow "#ba8428")        ; STRINGS: Mokra, złota żywica sosnowa (APCA Lc ≈ 47)
    (yellow-warmer "#c47c20")
    (yellow-cooler "#ab8432")
    (yellow-faint "#8a6e38")

    (blue "#388a66")          ; FUNKCJE: Głęboki świerk w deszczu (APCA Lc ≈ 38)
    (blue-warmer "#448f58")
    (blue-cooler "#3a8576")   ; DWUKROPKI (:foreground itp.): Wilgotna patyna skały
    (blue-faint "#3c6e5a")

    (magenta "#a65248")       ; SYMBOLE '... : Mokry owoc jarzębiny / kora dębu (APCA Lc ≈ 30)
    (magenta-warmer "#b0503c")
    (magenta-cooler "#9a5652")
    (magenta-faint "#7a4e48")

    (cyan "#b56834")          ; SŁOWA KLUCZOWE (defun, defconst): Mokra kora modrzewia (APCA Lc ≈ 38)
    (cyan-warmer "#bf6e2a")
    (cyan-cooler "#a8693c")
    (cyan-faint "#865836")

    ;; Diffy i panele
    (bg-added "#0e2414")
    (bg-added-faint "#08180d")
    (bg-added-refine "#14301a")
    (fg-added "#60ba68")

    (bg-changed "#221c08")
    (bg-changed-faint "#161205")
    (bg-changed-refine "#2e260c")
    (fg-changed "#bfa438")

    (bg-removed "#280e0c")
    (bg-removed-faint "#1a0807")
    (bg-removed-refine "#341210")
    (fg-removed "#c4544c")

    (bg-mode-line-active "#141c17")
    (fg-mode-line-active "#b4c2ab")
    (bg-completion "#111714")
    (bg-popup "#0f1411")
    (bg-hover "#16221a")
    (bg-hover-secondary "#20181d")
    (bg-hl-line "#111613")
    (bg-paren-match "#122419")
    (bg-err "#220c0a")
    (bg-warning "#1c1204")
    (bg-info "#081a0e")
    (bg-region "#162019")))

(defconst rainforest-night-palette-mappings-partial
  '(;; Statusy
    (err red-warmer)
    (warning yellow-warmer)
    (info green-cooler)

    (fg-link yellow-cooler)
    (fg-link-visited magenta-cooler)
    (name blue)
    (keybind red-warmer)
    (identifier fg-alt)
    (fg-prompt blue)

    ;; Determinizm 1:1 w sercu boru
    (builtin blue-cooler)     ; DWUKROPKI (:foreground)
    (comment fg-dim)          ; Komentarze: ściółka iglasta
    (constant magenta)        ; SYMBOLE ('costam): Jarzębina / dąb
    (fnname blue)             ; Definicje funkcji: świerk w deszczu
    (fnname-call blue)        ; Wywołania funkcji
    (keyword cyan)            ; Słowa kluczowe (defun, defconst): mokry modrzew
    (preprocessor cyan-faint)
    (docstring fg-dim)
    (string yellow)           ; Literały tekstowe: złota żywica
    (type green)              ; Typy: soczysty mech borowy
    (variable fg-main)        ; Zmienne bazowe: matowy len
    (variable-use fg-alt)     ; Użycia zmiennych i argumenty (txt, bg): wilgotny piaskowiec
    (rx-backslash yellow-cooler)
    (rx-construct red)

    (accent-0 blue)
    (accent-1 yellow)
    (accent-2 green)
    (accent-3 cyan)))

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
 "Deszczowe schronienie w borze nocą (APCA Lc / WCAG 3, kora, igliwie i żywica)."
 'dark
 'rainforest-night-palette
 nil
 nil)

;; Komentarze: czysta kursywa bez narzucania wagi czcionki
(custom-theme-set-faces
 'rainforest-night
 '(font-lock-comment-face ((t (:foreground "#4f6154" :slant italic))))
 '(font-lock-comment-delimiter-face ((t (:foreground "#4f6154" :slant italic))))
 '(font-lock-doc-face ((t (:foreground "#4f6154" :slant italic)))))

(provide 'rainforest-night-theme)
;;; rainforest-night-theme.el ends here
