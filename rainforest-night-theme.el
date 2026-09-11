;;; rainforest-night-theme.el --- Deep rainy forest shelter theme -*- lexical-binding:t -*-

(require 'ef-themes)

(defconst rainforest-night-palette-partial
  '(;; Płótno: głęboka noc w borze iglastym (neutralny, organiczny mrok z nutą zieleni, zero morskiego cyjanu)
    (cursor "#4e92a8")        ; KURSOR: Lśniąca, chłodna kropla deszczu (APCA Lc ≈ 38)
    (bg-main "#0b0e0a")       ; Ciemna, bezpieczna próchnica boru pod osłoną nocy (R=11, G=14, B=10 - neutralna czerń z liściastą zielenią)
    (bg-dim "#101410")        ; Nasiąknięty pień świerku
    (bg-alt "#151a14")        ; Głęboki cień pod gałęziami
    (fg-main "#b0b4b2")       ; Chłodny kwarc mineralny (APCA LCD: 59.33, OLED: 58.41, C*=1.85 - neutralny kwarc bez zielonkawego zafarbu)
    ;; Komentarze: ciemne igliwie w ściółce (leży cicho pod kodem)
    (fg-dim "#4f6154")        ; APCA Lc ≈ 18
    ;; Argumenty i identyfikatory (txt, bg): wilgotny piaskowiec
    (fg-alt "#849a90")        ; APCA LCD: 43.37, C*=10.2, Δ do tekstu bazowego = 10 597

    (bg-active "#1c241b")
    (bg-inactive "#0e120d")
    (border "#182017")

    ;; Składnia: głębokie, soczyste barwy przesiąknięte deszczem (C* <= 38, Thibos ΔD <= 0.25 D, Δ >= 8000)
    (red "#9e524a")           ; Alerty: wilgotny owoc cisa w deszczu (C*=36.0, LCD=22.79)
    (red-warmer "#a85a52")
    (red-cooler "#964e4e")
    (red-faint "#7c4642")

    (green "#6a9054")         ; TYPY: Wilgotny mech borowy na kamieniu (C*=37.1, LCD=35.85, Δ do cyan = 8220)
    (green-warmer "#72985c")
    (green-cooler "#5e864c")
    (green-faint "#4c703c")

    (yellow "#b078ac")        ; STRINGS: Dojrzała leśna borówka w deszczu (C*=35.8, LCD=38.34, Δ do const = 8704)
    (yellow-warmer "#a48046") ; LICZBY i ŻYWICA (0, 32 itp.): Mokry bursztyn leśny / żywica (C*=37.1, LCD=36.02)
    (yellow-cooler "#a470a0")
    (yellow-faint "#7e567c")

    (blue "#3282a6")          ; FUNKCJE: Woda potoku w nocnej ulewie (C*=29.0, LCD=30.58, głęboki mokry błękit, Δ do text = 49540)
    (blue-warmer "#388cae")
    (blue-cooler "#a8664a")   ; DWUKROPKI i BUILTIN (:foreground, :slant, __always_inline): Mokra kora sosny / cedr (C*=35.9, LCD=29.10)
    (blue-faint "#2a6c8a")

    (magenta "#8e6c7e")       ; SYMBOLE '... : Mokry cedr / wilgotny wrzos w mroku (C*=17.2, LCD=28.44)
    (magenta-warmer "#987484")
    (magenta-cooler "#846678")
    (magenta-faint "#6c5664")

    (cyan "#3c9676")          ; SŁOWA KLUCZOWE (static, defun, defconst): Szmaragd igliwia w ulewie / mokry nefryt (C*=35.9, LCD=36.56)
    (cyan-warmer "#449e7e")
    (cyan-cooler "#368e74")
    (cyan-faint "#307660")

    (pine-shoot "#72a898")    ; POLA STRUKTUR (->tgid): Młody pęd sosny w ulewie (C*=21.5, LCD=47.72)

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
    (builtin blue-cooler)     ; DWUKROPKI i BUILTIN (:foreground, :slant, __always_inline): mokra kora sosny / cedr
    (comment fg-dim)          ; Komentarze: ciemne igliwie w ściółce
    (constant magenta)        ; SYMBOLE ('costam): Mokry cedr / wilgotny wrzos w mroku
    (fnname blue)             ; Definicje funkcji: woda potoku w nocnej ulewie
    (fnname-call blue)        ; Wywołania funkcji: woda potoku w nocnej ulewie
    (keyword cyan)            ; Słowa kluczowe (static, defun, defconst): szmaragd igliwia w ulewie
    (preprocessor cyan-faint)
    (docstring fg-dim)
    (string yellow)           ; Literały tekstowe: dojrzała leśna borówka w deszczu
    (number yellow-warmer)    ; Liczby (0, 32 itp.): złocista żywica świerkowa w mroku
    (property pine-shoot)     ; Pola struktur (->tgid): młody pęd sosny w ulewie
    (type green)              ; Typy (int, size_t): wilgotny mech borowy
    (variable fg-main)        ; Zmienne bazowe: chłodny kwarc mineralny
    (variable-use fg-main)    ; Użycia zmiennych: chłodny kwarc mineralny
    (operator fg-alt)         ; Operatory (->, =, &, >>): wilgotny piaskowiec
    (bracket fg-alt)          ; Nawiasy: wilgotny piaskowiec
    (delimiter fg-dim)        ; Ograniczniki (, ;): ciemne igliwie ściółki
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

;; Jawne definicje twarzy dla pełnego pokrycia składni w C, tree-sitterze i Elisp:
(custom-theme-set-faces
 'rainforest-night
 '(font-lock-comment-face ((t (:foreground "#4f6154" :slant italic))))
 '(font-lock-comment-delimiter-face ((t (:foreground "#4f6154" :slant italic))))
 '(font-lock-doc-face ((t (:foreground "#4f6154" :slant italic))))
 '(font-lock-number-face ((t (:foreground "#a48046"))))
 '(font-lock-property-name-face ((t (:foreground "#72a898"))))
 '(font-lock-property-use-face ((t (:foreground "#72a898"))))
 '(font-lock-builtin-face ((t (:foreground "#a8664a"))))
 '(font-lock-function-call-face ((t (:foreground "#3282a6"))))
 '(font-lock-operator-face ((t (:foreground "#849a90"))))
 '(font-lock-bracket-face ((t (:foreground "#849a90"))))
 '(font-lock-delimiter-face ((t (:foreground "#4f6154")))))

(provide 'rainforest-night-theme)
;;; rainforest-night-theme.el ends here
