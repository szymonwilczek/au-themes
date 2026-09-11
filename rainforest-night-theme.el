;;; rainforest-night-theme.el --- Deep rainy forest shelter theme -*- lexical-binding:t -*-

(require 'ef-themes)

(defconst rainforest-night-palette-partial
  '(;; Płótno: dno boru pod osłoną nocnego deszczu (neutralny, organiczny mrok)
    (cursor "#54a2b8")        ; KURSOR: Lśniąca kropla deszczu (APCA LCD: 44.98)
    (bg-main "#090a09")       ; DNO LASU: Ciemna próchnica boru (R=9, G=10, B=9 - neutralna czerń bez zafarbu)
    (bg-dim "#0e0f0e")        ; Nasiąknięty pień świerku
    (bg-alt "#131413")        ; Głęboki cień pod gałęziami
    (fg-main "#a0aaa2")       ; KWARC MINERALNY: Wyrazisty, zrównoważony tekst (APCA LCD: 53.09, C*=5.8 - bez oślepiania i bez mikrofluktuacji akomodacyjnych)
    ;; Warstwa ściółki: ciemne igliwie pod drzewami (leży cicho pod kodem, czysta kursywa)
    (fg-dim "#506456")        ; ŚCIÓŁKA IGLASTA: APCA LCD: 19.04, czytelna i dyskretna
    ;; Warstwa piaskowca: argumenty i parametry kodu
    (fg-alt "#788a80")        ; WILGOTNY PIASKOWIEC: APCA LCD: 35.98, C*=9.1, Δ do tekstu = 11 093 (>= 8000)

    (bg-active "#1c1e1c")
    (bg-inactive "#0c0d0c")
    (border "#161816")

    ;; WARSTWY LASU OD GÓRY DO DOŁU (Fizyka Lekner & Dorf 1988, C* <= 38, Thibos ΔD <= 0.25 D, Δ >= 8000)
    (red "#9e5650")           ; OWOC CISA / ALERTY: Dojrzały owoc cisa w deszczu (C*=33.5, LCD=23.90)
    (red-warmer "#a85c54")
    (red-cooler "#94504a")
    (red-faint "#804440")

    (green "#629056")         ; WARSTWA 3 (MECH NADRZEWNY / TYPY: int, size_t, struct): Wilgotny mech borowy na pniu (C*=37.7, LCD=35.44)
    (green-warmer "#6c9a60")
    (green-cooler "#58864c")
    (green-faint "#4a723e")

    (yellow "#a676aa")        ; WARSTWA 5 (RUNO LEŚNE / BORÓWKA / STRINGS): Dojrzała borówka czarna w runie (C*=34.4, LCD=36.38)
    (yellow-warmer "#b07eb4")
    (yellow-cooler "#9c6ea0")
    (yellow-faint "#865e8a")

    (blue "#328ab0")          ; WARSTWA 4 (POTOK GÓRSKI / FUNKCJE I WYWOŁANIA: is_write_open_flags, bpf_...): Chłodna woda potoku w ulewie (C*=30.6, LCD=34.11)
    (blue-warmer "#3894ba")
    (blue-cooler "#2a7ea4")
    (blue-faint "#226c8e")

    (magenta "#886a78")       ; WARSTWA 2 (KORA SOSNOWA / CEDR / BUILTIN: __always_inline, :slant, :foreground): Mokry pień sosny i cedru (C*=14.7, LCD=27.05)
    (magenta-warmer "#927282")
    (magenta-cooler "#7e626e")
    (magenta-faint "#6c5460")

    (cyan "#34967a")          ; WARSTWA 1 (KORONA DRZEW / PREPROCESOR I SŁOWA KLUCZOWE: #define, #include, static, defun): Szmaragd igliwia w koronie (C*=36.0, LCD=36.56)
    (cyan-warmer "#3ca084")
    (cyan-cooler "#2c8c70")
    (cyan-faint "#24765e")

    ;; Diffy i panele
    (bg-added "#0e2212")
    (bg-added-faint "#09180c")
    (bg-added-refine "#14301a")
    (fg-added "#58b260")

    (bg-changed "#201c08")
    (bg-changed-faint "#141205")
    (bg-changed-refine "#2c240a")
    (fg-changed "#bca436")

    (bg-removed "#240e0c")
    (bg-removed-faint "#160807")
    (bg-removed-refine "#321210")
    (fg-removed "#c0524a")

    (bg-mode-line-active "#141814")
    (fg-mode-line-active "#a6b4a8")
    (bg-completion "#121412")
    (bg-popup "#101210")
    (bg-hover "#161c16")
    (bg-hover-secondary "#20181e")
    (bg-hl-line "#0f120f")
    (bg-paren-match "#122216")
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

    ;; Koncepcja warstw lasu od góry do dołu:
    (preprocessor cyan-warmer) ; Wierzchołek: szmaragd igliwia w koronie drzew (#define, #include)
    (keyword cyan)            ; Korona drzew: słowa kluczowe (static, defun, defconst)
    (builtin magenta)         ; Warstwa 2: kora sosnowa / cedr (__always_inline, :foreground, :slant)
    (constant magenta)        ; Warstwa 2: stałe i symbole ('...)
    (type green)              ; Warstwa 3: mech borowy na pniach (int, size_t, struct)
    (fnname blue)             ; Warstwa 4: potok górski w ulewie (definicje funkcji)
    (fnname-call blue)        ; Warstwa 4: potok górski w ulewie (wywołania funkcji: bpf_...)
    (string yellow)           ; Warstwa 5: runo leśne i borówka ("literały tekstowe")
    (variable fg-main)        ; Warstwa 6: kwarc mineralny (zmienne bazowe)
    (variable-use fg-main)    ; Warstwa 6: kwarc mineralny (użycia zmiennych)
    (comment fg-dim)          ; Warstwa 7: ściółka iglasta na samym dnie (komentarze)
    (docstring fg-dim)        ; Warstwa 7: ściółka iglasta (dokumentacja)
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
 "Deszczowe schronienie w borze nocą (APCA Lc / WCAG 3, warstwy lasu od korony po runo i ściółkę)."
 'dark
 'rainforest-night-palette
 nil
 nil)

;; Dyskretne dopasowanie twarzy:
(custom-theme-set-faces
 'rainforest-night
 '(font-lock-comment-face ((t (:foreground "#506456" :slant italic))))
 '(font-lock-comment-delimiter-face ((t (:foreground "#506456" :slant italic))))
 '(font-lock-doc-face ((t (:foreground "#506456" :slant italic))))
 '(font-lock-function-call-face ((t (:foreground "#328ab0")))))

(provide 'rainforest-night-theme)
;;; rainforest-night-theme.el ends here
