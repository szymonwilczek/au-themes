;;; au-themes.el --- Sensory-safe, scientifically gated themes for autism and neurodivergence -*- lexical-binding: t -*-

;; Author: Szymon Wilczek <swilczek.lx@gmail.com>
;; Version: 0.2.0
;; Package-Requires: ((emacs "28.1") (ef-themes "1.0.0"))
;; Keywords: faces, themes, accessibility, autism, neurodivergence
;; URL: https://github.com/szymonwilczek/au-themes

;;; Commentary:
;;
;; Au-themes (named after Au — the chemical symbol for Gold, representing
;; autism pride and acceptance over the pathologizing blue puzzle piece) is a
;; collection of sensory-safe, psycho-optically calibrated Emacs themes
;; engineered specifically for autistic individuals and neurodivergent sensory profiles.
;;
;; Autistic visual perception frequently involves hyper-reactivity to visual stimuli,
;; including photophobia, pattern glare, foveal visual crowding, and rapid visual fatigue.
;; Each theme in this collection is subjected to a 34-module automated diagnostic gate:
;;
;; - APCA (Advanced Perceptual Contrast Algorithm) & ISO-compliant contrast tuning
;; - Parvocellular vs Magnocellular (M/P) visual pathway balancing
;; - Tonic accommodation lock (ciliary muscle dark focus anchoring at 50-60cm)
;; - Bouma window visual crowding suppression (delimiter/bracket hierarchy)
;; - Isoluminance jitter elimination across adjacent syntax tokens
;; - Zero color collisions with strict 1:1 semantic syntax determinism
;; - Reduced blue light and macular hazard mitigation
;;
;; Available themes in the Au collection:
;; - `au-whispergrove-night`: Deep nocturnal whisper grove sanctuary (LCD/OLED calibrated)
;; - `au-whispergrove-evening`: Soft twilight whisper grove evening (elevated dark)
;; - `au-whispergrove-morning`: Dewy dawn mist whisper grove canopy (subdued daylight)
;; - `au-whispergrove-day`: Misty temperate whisper grove daylight sanctuary
;; - `au-aurum-twilight`: Volcanic basalt, ancient gold, olivine, and amethyst sanctuary
;; - `au-aurum-night`: Volcanic basalt and ancient gold sanctuary (zero blue light, pure warm gold)
;; - `au-aurum-day`: Warm sandstone, ancient gold, and basalt daylight sanctuary (zero blue light)
;; - `au-parchment-night`: Antique leather binding and worn vellum nocturnal sanctuary (minimal chroma entropy)
;; - `au-parchment-day`: Authentic medieval manuscript and vellum daylight sanctuary (minimal chroma entropy)
;;
;; All themes in this suite use the `au-` prefix.

;;; Code:

(require 'au-whispergrove-day-theme)
(require 'au-whispergrove-morning-theme)
(require 'au-whispergrove-evening-theme)
(require 'au-whispergrove-night-theme)
(require 'au-aurum-twilight-theme)
(require 'au-aurum-night-theme)
(require 'au-aurum-day-theme)
(require 'au-parchment-night-theme)
(require 'au-parchment-day-theme)

(defgroup au-themes ()
  "Sensory-safe, scientifically gated themes for autism and neurodivergence."
  :group 'faces
  :prefix "au-themes-")

(defcustom au-themes-collection
  '(au-whispergrove-night
    au-whispergrove-evening
    au-whispergrove-morning
    au-whispergrove-day
    au-aurum-twilight
    au-aurum-night
    au-aurum-day
    au-parchment-night
    au-parchment-day)
  "List of themes included in the Au-themes collection."
  :type '(repeat symbol)
  :group 'au-themes)

;;;###autoload
(defun au-themes-toggle ()
  "Toggle between `au-whispergrove-day' and `au-whispergrove-night'."
  (interactive)
  (if (eq (car custom-enabled-themes) 'au-whispergrove-day)
      (progn
        (disable-theme 'au-whispergrove-day)
        (load-theme 'au-whispergrove-night t)
        (message "Włączono au-whispergrove-night"))
    (progn
      (disable-theme 'au-whispergrove-night)
      (load-theme 'au-whispergrove-day t)
      (message "Włączono au-whispergrove-day"))))

;;;###autoload
(defalias 'au-toggle #'au-themes-toggle)

;;;###autoload
(when (and (boundp 'custom-theme-load-path)
           load-file-name)
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

(provide 'au-themes)
;;; au-themes.el ends here
