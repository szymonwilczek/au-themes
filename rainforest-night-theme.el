;;; rainforest-night-theme.el --- Deep rainy forest shelter theme -*- lexical-binding:t -*-

(require 'ef-themes)

(defconst rainforest-night-palette-partial
  '(;; Płótno: dno boru z cokołem luminancji (pedestal L*=7.0 zapobiegający rozszerzaniu źrenicy i aberracji r^4)
    (cursor "#58b0c8")        ; KURSOR: Lśniąca kropla deszczu w świetle księżyca (APCA LCD: 49.32)
    (bg-main "#141615")       ; PODŁOŻE BORU: Organiczna ziemia z cokołem luminancji (L*=7.0, redukcja rozproszenia straylight)
    (bg-dim "#1a1d1b")        ; Nasiąknięty pień świerku
    (bg-alt "#202422")        ; Głęboki cień pod gałęziami
    (fg-main "#a2aca4")       ; KWARC MINERALNY: Zrównoważony tekst bazowy (APCA LCD: 54.64, C*=5.8 - bez pulsowania rzęskowego)
    (fg-dim "#566a5c")        ; ŚCIÓŁKA IGLASTA: Komentarze w czystej kursywie (APCA LCD: 22.86, czytelna i dyskretna)
    (fg-alt "#609886")        ; WILGOTNY PIASKOWIEC: Pola struktur i parametry (APCA LCD: 41.5, Δ do tekstu = 14 875)

    (bg-active "#222824")
    (bg-inactive "#161917")
    (border "#1c201e")

    ;; PALETA DETERMINIZMU 1:1 (Lekner & Dorf 1988 C* <= 38.0, Thibos ΔD <= 0.25 D, Δ >= 8000)
    (red "#a05450")           ; OWOC CISA: Błędy, alerty, negacja ! (C*=35.1, LCD=24.83)
    (red-warmer "#aa5a54")
    (red-cooler "#964e4a")
    (red-faint "#607266")     ; GAŁĄZKA MODRZEWIA: Nawiasy ( ) [ ] { } (LCD Lc = 24.4)

    (green "#64925a")         ; WARSTWA 3 (MECH BOROWY / TYPY: int, size_t, struct Type): (C*=36.7, LCD=37.41)
    (green-warmer "#6e9c62")
    (green-cooler "#5a8850")
    (green-faint "#527848")

    (yellow "#ba726c")        ; WARSTWA 5 (BORÓWKA LEŚNA / STRINGS: "napisy"): (C*=31.7, LCD=35.37)
    (yellow-warmer "#aa8a4c") ; ŻYWICA BURSZTYNOWA / LICZBY (0, 24, 32 w buf[0] itp.): (C*=37.7, LCD=41.21)
    (yellow-cooler "#a46a84")
    (yellow-faint "#8e586e")

    (blue "#267a9e")          ; WARSTWA 4A (POTOK GÓRSKI / DEFINICJE FUNKCJI: is_write_open_flags): (C*=30.3, LCD=30.90)
    (blue-warmer "#54aaca")   ; WARSTWA 4B (KROPLA MŻAWKI / WYWOŁANIA FUNKCJI: bpf_...): (C*=29.7, LCD=45.60)
    (blue-cooler "#6c8074")   ; CIEMNY ŁUPEK / OPERATORY: +, -, *, >>, & (C*=10.7, LCD=32.30)
    (blue-faint "#206886")

    (magenta "#946ca2")       ; WARSTWA 2B (FIOLET WRZOSOWY / STAŁE I MAKRA: LOTA_PCR_COUNT, NULL): (C*=34.6, LCD=31.97)
    (magenta-warmer "#9e74ac")
    (magenta-cooler "#967464") ; WARSTWA 2A (KORA SOSNY I CEDR / BUILTIN: __always_inline, :keywords): (C*=17.8, LCD=32.31)
    (magenta-faint "#76584c")

    (cyan "#288e72")          ; SŁOWA KLUCZOWE JĘZYKA (struct, while, static, return): Szmaragd igliwia (C*=36.4, LCD=33.73)
    (cyan-warmer "#4eb294")   ; PREPROCESOR (#define, #include): Wierzchołek świerku (C*=37.2, LCD=50.30)
    (cyan-cooler "#208468")
    (cyan-faint "#627268")    ; SUBTELNE IGLIWIE / DELIMITERY: przecinki, średniki

    ;; Diffy i panele
    (bg-added "#102616")
    (bg-added-faint "#0a1a0f")
    (bg-added-refine "#16341e")
    (fg-added "#58b260")

    (bg-changed "#24200a")
    (bg-changed-faint "#181406")
    (bg-changed-refine "#302a0e")
    (fg-changed "#bca436")

    (bg-removed "#28100e")
    (bg-removed-faint "#1a0a09")
    (bg-removed-refine "#361412")
    (fg-removed "#c0524a")

    (bg-mode-line-active "#181c1a")
    (fg-mode-line-active "#a6b4a8")
    (bg-completion "#161a18")
    (bg-popup "#141816")
    (bg-hover "#1c221e")
    (bg-hover-secondary "#241c22")
    (bg-hl-line "#161a17")
    (bg-paren-match "#18281e")
    (bg-err "#26100e")
    (bg-warning "#201606")
    (bg-info "#0c1e12")
    (bg-region "#1a261c")))

(defconst rainforest-night-palette-mappings-partial
  '(;; Statusy
    (err red)
    (warning yellow-warmer)
    (info green)

    (fg-link blue-warmer)
    (fg-link-visited magenta)
    (name blue)
    (keybind red-warmer)
    (identifier fg-alt)
    (fg-prompt blue)

    ;; DETERMINIZM 1:1 DLA KAŻDEGO KEYFACE (ŻADEN KOLOR SIĘ NIE POWTARZA):
    (preprocessor cyan-warmer)   ; #4eb294 - Preprocesor (#define, #include)
    (keyword cyan)               ; #288e72 - Słowa kluczowe (struct, while, static, return)
    (type green)                 ; #64925a - Typy danych (int, size_t, struct Type)
    (constant magenta)           ; #946ca2 - Stałe i enumy (LOTA_PCR_COUNT, NULL, enum)
    (number yellow-warmer)       ; #aa8a4c - Liczby (0, 24, 32 w buf[0] itp.)
    (builtin magenta-cooler)     ; #967464 - Builtin i atrybuty (__always_inline, :keywords)
    (fnname blue)                ; #267a9e - Definicje funkcji (is_write_open_flags)
    (fnname-call blue-warmer)    ; #54aaca - Wywołania funkcji (bpf_map_lookup_elem)
    (string yellow)              ; #ba726c - Literały tekstowe ("strings")
    (property fg-alt)            ; #609886 - Pola struktur (->tgid, .field)
    (variable fg-main)           ; #a2aca4 - Zmienne i argumenty
    (variable-use fg-main)       ; #a2aca4 - Użycia zmiennych
    (operator blue-cooler)       ; #6c8074 - Operatory (+, -, *, >>, &)
    (bracket red-faint)          ; #607266 - Nawiasy (( ) [ ] { })
    (delimiter cyan-faint)       ; #627268 - Separatory (, ;)
    (comment fg-dim)             ; #566a5c - Ściółka iglasta (komentarze)
    (docstring fg-dim)           ; #566a5c - Ściółka iglasta (dokumentacja)
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
 "Deszczowe schronienie w borze nocą (APCA Lc / WCAG 3, determinizm 1:1, cokół luminancji przeciw aberracji oka)."
 'dark
 'rainforest-night-palette
 nil
 nil)

;; Dyskretne, deterministyczne dopasowanie twarzy i wsparcie LSP / Eglot:
(custom-theme-set-faces
 'rainforest-night
 '(font-lock-comment-face ((t (:foreground "#566a5c" :slant italic))))
 '(font-lock-comment-delimiter-face ((t (:foreground "#566a5c" :slant italic))))
 '(font-lock-doc-face ((t (:foreground "#566a5c" :slant italic))))
 '(font-lock-preprocessor-face ((t (:foreground "#4eb294"))))
 '(font-lock-keyword-face ((t (:foreground "#288e72"))))
 '(font-lock-type-face ((t (:foreground "#64925a"))))
 '(font-lock-constant-face ((t (:foreground "#946ca2"))))
 '(font-lock-number-face ((t (:foreground "#aa8a4c"))))
 '(font-lock-builtin-face ((t (:foreground "#967464"))))
 '(font-lock-function-name-face ((t (:foreground "#267a9e"))))
 '(font-lock-function-call-face ((t (:foreground "#54aaca"))))
 '(font-lock-string-face ((t (:foreground "#ba726c"))))
 '(font-lock-property-name-face ((t (:foreground "#609886"))))
 '(font-lock-property-use-face ((t (:foreground "#609886"))))
 '(font-lock-operator-face ((t (:foreground "#6c8074"))))
 '(font-lock-bracket-face ((t (:foreground "#607266"))))
 '(font-lock-delimiter-face ((t (:foreground "#627268"))))
 ;; LSP / Eglot semantic tokens (makra w wyrażeniach jak LOTA_PCR_COUNT jako stała fiolet wrzosowy):
 '(eglot-semantic-macro ((t (:foreground "#946ca2"))))
 '(eglot-semantic-property ((t (:foreground "#609886")))))

(provide 'rainforest-night-theme)
;;; rainforest-night-theme.el ends here
