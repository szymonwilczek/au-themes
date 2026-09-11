;;; rainforest-night-theme.el --- Deep rainy forest shelter theme -*- lexical-binding:t -*-

(require 'ef-themes)

(defconst rainforest-night-palette-partial
  '(;; Płótno: głęboka noc w borze iglastym (organiczny mrok, zero morskiej szarości)
    (cursor "#4e92a8")        ; KURSOR: Lśniąca, chłodna kropla deszczu (APCA Lc ≈ 45-47)
    (bg-main "#0d110f")       ; Ciemna, bezpieczna próchnica boru pod osłoną nocy
    (bg-dim "#131815")        ; Nasiąknięty pień świerku
    (bg-alt "#19201c")        ; Głęboki cień pod gałęziami
    (fg-main "#a6b6b0")       ; Chłodny kwarc mineralny (APCA LCD: 58.81, OLED: 57.87, C*=6.8 - idealna definicja dla astygmatyzmu)
    ;; Komentarze: ciemne igliwie w ściółce (leży cicho pod kodem)
    (fg-dim "#4f6154")        ; APCA Lc ≈ 18
    ;; Argumenty i identyfikatory (txt, bg): wilgotny piaskowiec
    (fg-alt "#889e94")        ; APCA LCD: 45.27, C*=10.1, Δ do tekstu bazowego = 6 575

    (bg-active "#202a24")
    (bg-inactive "#111513")
    (border "#1c2520")

    ;; Składnia: głębokie, soczyste barwy przesiąknięte deszczem (C* <= 38, Thibos ΔD <= 0.25 D)
    (red "#9e524a")           ; Alerty: wilgotny owoc cisa w deszczu
    (red-warmer "#ab5a50")
    (red-cooler "#964e4e")
    (red-faint "#7c4642")

    (green "#608e58")         ; TYPY: Soczysty, mokry mech leśny (C*=35.9, LCD=34.33)
    (green-warmer "#6c9860")
    (green-cooler "#548a56")
    (green-faint "#4c744c")

    (yellow "#a27ca2")        ; STRINGS: Leśna borówka w deszczu / wilgotny wrzos (C*=25.9, LCD=36.99)
    (yellow-warmer "#ba8428") ; Alerty ostrzeżeń (warning): bursztyn ostrzegawczy
    (yellow-cooler "#94769c")
    (yellow-faint "#7c5c7c")

    (blue "#3886a4")          ; FUNKCJE: Górska woda / czysty potok w deszczu (C*=27.1, LCD=31.96)
    (blue-warmer "#3c8ca8")
    (blue-cooler "#2e7470")   ; DWUKROPKI (:foreground itp.): Tafla kałuży w cieniu drzew
    (blue-faint "#32687c")

    (magenta "#8e6c7e")       ; SYMBOLE '... : Mokry cedr / wilgotny wrzos w mroku (C*=17.2, LCD=28.30)
    (magenta-warmer "#987484")
    (magenta-cooler "#846678")
    (magenta-faint "#6c5664")

    (cyan "#3c9676")          ; SŁOWA KLUCZOWE (defun, defconst): Szmaragd igliwia w deszczu / mokry nefryt (C*=35.9, LCD=36.43)
    (cyan-warmer "#449e7e")
    (cyan-cooler "#368e74")
    (cyan-faint "#327460")

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
 "Deszczowe schronienie w borze nocą (APCA Lc / WCAG 3, optyka astygmatyzmu, nefryt, kwarc i leśny bursztyn)."
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
