;;; rainforest-night-theme.el --- Deep rainy forest shelter theme -*- lexical-binding:t -*-

(require 'ef-themes)

(defconst rainforest-night-palette-partial
  '(;; Płótno: głęboka noc w borze iglastym (neutralny, organiczny mrok, zero zafarbu)
    (cursor "#4e92a8")        ; KURSOR: Lśniąca, chłodna kropla deszczu (APCA LCD: 37.72)
    (bg-main "#090a09")       ; Neutralna, ciemna próchnica boru (R=9, G=10, B=9 - czysta noc bez zielonkawego zafarbu)
    (bg-dim "#0e0f0e")        ; Nasiąknięty pień świerku
    (bg-alt "#131413")        ; Głęboki cień pod gałęziami
    (fg-main "#96a098")       ; Zgaszony kwarc mineralny (APCA LCD: 47.80, C*=5.9 - eliminuje mikrofluktuacje mięśnia rzęskowego i pulsowanie oka)
    ;; Komentarze: ciemne igliwie w ściółce (leży cicho pod kodem, czysta kursywa)
    (fg-dim "#445448")        ; APCA LCD: 13.28
    ;; Argumenty i identyfikatory: wilgotny piaskowiec leśny
    (fg-alt "#708078")        ; APCA LCD: 31.53, C*=7.9, Δ do tekstu bazowego = 10 352 (>= 8000)

    (bg-active "#1a1b1a")
    (bg-inactive "#0c0d0c")
    (border "#151615")

    ;; Składnia: ciemne, nasycone barwy przesiąknięte deszczem (fizyka Lekner & Dorf 1988, C* <= 38, Thibos ΔD <= 0.25 D, Δ >= 8000)
    (red "#944e48")           ; Alerty / błędy: wilgotny owoc cisa w ulewie (C*=33.2, LCD=20.47)
    (red-warmer "#9e5650")
    (red-cooler "#8a4642")
    (red-faint "#743c38")

    (green "#588046")         ; TYPY: Głęboki, nasiąknięty mech borowy (C*=37.2, LCD=28.58, Δ do cyan = 9022)
    (green-warmer "#648c50")
    (green-cooler "#52783e")
    (green-faint "#446434")

    (yellow "#946498")        ; STRINGS: Dojrzała leśna borówka w deszczu (C*=35.1, LCD=28.23, Δ do magenta = 8811)
    (yellow-warmer "#9e6ca2")
    (yellow-cooler "#8a5c8e")
    (yellow-faint "#764e7a")

    (blue "#28769e")          ; FUNKCJE i WYWOŁANIA (is_write_open_flags, bpf_...): Chłodna górska woda potoku w ulewie (C*=29.9, LCD=25.90, ZERO pomarańczu!)
    (blue-warmer "#2e80a8")
    (blue-cooler "#226c92")
    (blue-faint "#1e5c7e")

    (magenta "#72586a")       ; SYMBOLE, STAŁE i BUILTIN (__always_inline, :slant, '...): Nasiąknięty cedr / ciemny wrzos w mroku (C*=15.3, LCD=19.22)
    (magenta-warmer "#7c6074")
    (magenta-cooler "#685060")
    (magenta-faint "#564450")

    (cyan "#248466")          ; SŁOWA KLUCZOWE (static, defun, defconst): Ciemny szmaragd igliwia w ulewie (C*=36.0, LCD=28.66, zero morskiego cyjanu)
    (cyan-warmer "#2c8e70")
    (cyan-cooler "#207c60")
    (cyan-faint "#1a6850")

    ;; Diffy i panele
    (bg-added "#0c1e10")
    (bg-added-faint "#08140b")
    (bg-added-refine "#102816")
    (fg-added "#54a85c")

    (bg-changed "#1c1808")
    (bg-changed-faint "#121005")
    (bg-changed-refine "#26200a")
    (fg-changed "#b09832")

    (bg-removed "#220c0a")
    (bg-removed-faint "#140807")
    (bg-removed-refine "#2c100e")
    (fg-removed "#b84c44")

    (bg-mode-line-active "#121412")
    (fg-mode-line-active "#9aa69c")
    (bg-completion "#101210")
    (bg-popup "#0e100e")
    (bg-hover "#141814")
    (bg-hover-secondary "#1c161a")
    (bg-hl-line "#0d0f0d")
    (bg-paren-match "#101c12")
    (bg-err "#200a08")
    (bg-warning "#1a1004")
    (bg-info "#08160c")
    (bg-region "#141c14")))

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

    ;; Determinizm 1:1 w sercu boru (spokojna hierarchia bez pstrokacizny)
    (builtin magenta)         ; Builtin (__always_inline, :foreground, :slant): mokry cedr
    (comment fg-dim)          ; Komentarze: ciemne igliwie w ściółce (leży cicho pod kodem)
    (constant magenta)        ; Symbole i stałe ('...): mokry cedr
    (fnname blue)             ; Definicje funkcji: chłodna woda górskiego potoku
    (fnname-call blue)        ; Wywołania funkcji (bpf_...): chłodna woda górskiego potoku (ZERO pomarańczu!)
    (keyword cyan)            ; Słowa kluczowe (static, defun, defconst): szmaragd igliwia w ulewie
    (preprocessor cyan-faint)
    (docstring fg-dim)
    (string yellow)           ; Literały tekstowe: dojrzała leśna borówka w deszczu
    (type green)              ; Typy (int, size_t): wilgotny mech borowy
    (variable fg-main)        ; Zmienne bazowe: chłodny kwarc mineralny
    (variable-use fg-main)    ; Użycia zmiennych: chłodny kwarc mineralny
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
 "Deszczowe schronienie w borze nocą (APCA Lc / WCAG 3, optyka astygmatyzmu, szmaragd igliwia, kwarc i borówka)."
 'dark
 'rainforest-night-palette
 nil
 nil)

;; Dyskretne dopasowanie twarzy: brak pstrokatego kolorowania każdego znaku,
;; wywołania funkcji jako chłodna woda leśna, komentarze jako ciche igliwie:
(custom-theme-set-faces
 'rainforest-night
 '(font-lock-comment-face ((t (:foreground "#445448" :slant italic))))
 '(font-lock-comment-delimiter-face ((t (:foreground "#445448" :slant italic))))
 '(font-lock-doc-face ((t (:foreground "#445448" :slant italic))))
 '(font-lock-function-call-face ((t (:foreground "#28769e")))))

(provide 'rainforest-night-theme)
;;; rainforest-night-theme.el ends here
