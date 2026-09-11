;;; rainforest-night-theme.el --- Deep rainy forest shelter theme -*- lexical-binding:t -*-

(require 'ef-themes)

(defconst rainforest-night-palette-partial
  '(;; Płótno: głęboka noc w borze iglastym (neutralny, organiczny mrok z nutą zieleni, zero morskiego cyjanu)
    (cursor "#4e92a8")        ; KURSOR: Lśniąca, chłodna kropla deszczu (APCA Lc ≈ 38)
    (bg-main "#0b0e0a")       ; Ciemna, bezpieczna próchnica boru pod osłoną nocy (R=11, G=14, B=10 - neutralna czerń z liściastą zielenią)
    (bg-dim "#101410")        ; Nasiąknięty pień świerku
    (bg-alt "#151a14")        ; Głęboki cień pod gałęziami
    (fg-main "#a6b6b0")       ; Chłodny kwarc mineralny (APCA LCD: 58.95, OLED: 58.04, C*=6.8 - idealna definicja dla astygmatyzmu)
    ;; Komentarze: ciemne igliwie w ściółce (leży cicho pod kodem)
    (fg-dim "#4f6154")        ; APCA Lc ≈ 18
    ;; Argumenty i identyfikatory (txt, bg): wilgotny piaskowiec
    (fg-alt "#849a90")        ; APCA LCD: 43.37, C*=10.2, Δ do tekstu bazowego = 8 664

    (bg-active "#1c241b")
    (bg-inactive "#0e120d")
    (border "#182017")

    ;; Składnia: głębokie, soczyste barwy przesiąknięte deszczem (C* <= 38, Thibos ΔD <= 0.25 D, Δ >= 8000)
    (red "#a85a52")           ; Alerty: wilgotny owoc cisa w deszczu (C*=36.3, LCD=26.32)
    (red-warmer "#b46058")
    (red-cooler "#9e544e")
    (red-faint "#844844")

    (green "#64965e")         ; TYPY: Soczysty mech borowy (C*=37.3, LCD=37.93)
    (green-warmer "#6e9e66")
    (green-cooler "#5c8e58")
    (green-faint "#4c7648")

    (yellow "#a47ca6")        ; STRINGS: Leśna borówka / wilgotny wrzos w mroku (C*=28.2, LCD=37.57)
    (yellow-warmer "#ba8428") ; Alerty ostrzeżeń (warning): bursztyn ostrzegawczy
    (yellow-cooler "#9c749e")
    (yellow-faint "#7e5e80")

    (blue "#469ec4")          ; FUNKCJE: Kropla deszczu / woda potoku w ulewie (C*=31.0, LCD=43.30)
    (blue-warmer "#4ea6cc")
    (blue-cooler "#749a94")   ; DWUKROPKI i BUILTIN (:foreground, __always_inline): Mokry łupek leśny (C*=14.4, LCD=42.17)
    (blue-faint "#3c7694")

    (magenta "#ba825a")       ; SYMBOLE '... : Mokry cedr / kora sosny w deszczu (C*=34.6, LCD=40.15)
    (magenta-warmer "#c48a62")
    (magenta-cooler "#b07a54")
    (magenta-faint "#8e6446")

    (cyan "#3aa084")          ; SŁOWA KLUCZOWE (static, defun, defconst): Szmaragd nefrytu / pędy sosny (C*=36.8, LCD=40.98)
    (cyan-warmer "#42aa8e")
    (cyan-cooler "#34987c")
    (cyan-faint "#2c6e5a")

    ;; Diffy i panele
    (bg-added "#0d2012")
    (bg-added-faint "#09160d")
    (bg-added-refine "#122c19")
    (fg-added "#60ba68")

    (bg-changed "#201a08")
    (bg-changed-faint "#141005")
    (bg-changed-refine "#2a240a")
    (fg-changed "#bfa438")

    (bg-removed "#240c0b")
    (bg-removed-faint "#160807")
    (bg-removed-refine "#30100f")
    (fg-removed "#c4544c")

    (bg-mode-line-active "#141812")
    (fg-mode-line-active "#b4c2ab")
    (bg-completion "#121611")
    (bg-popup "#10140f")
    (bg-hover "#161e14")
    (bg-hover-secondary "#20181c")
    (bg-hl-line "#0f130d")
    (bg-paren-match "#122014")
    (bg-err "#220c0a")
    (bg-warning "#1c1204")
    (bg-info "#0a180e")
    (bg-region "#162016")))

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
    (builtin blue-cooler)     ; DWUKROPKI i BUILTIN (:foreground, __always_inline): mokry łupek leśny
    (comment fg-dim)          ; Komentarze: ciemne igliwie w ściółce
    (constant magenta)        ; SYMBOLE ('costam): Mokry cedr / kora sosny
    (fnname blue)             ; Definicje funkcji: kropla deszczu / woda potoku
    (fnname-call blue)        ; Wywołania funkcji: kropla deszczu / woda potoku
    (keyword cyan)            ; Słowa kluczowe (static, defun, defconst): szmaragd nefrytu / pędy
    (preprocessor cyan-faint)
    (docstring fg-dim)
    (string yellow)           ; Literały tekstowe: leśna borówka / wilgotny wrzos
    (type green)              ; Typy: soczysty mech borowy
    (variable fg-main)        ; Zmienne bazowe: chłodny kwarc mineralny
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
