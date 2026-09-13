;;; au-themes.el --- Sensory-safe themes for autism and neurodivergence -*- lexical-binding: t -*-

;; Copyright (C) 2026  Szymon Wilczek

;; Author: Szymon Wilczek <swilczek.lx@gmail.com>
;; URL: https://github.com/szymonwilczek/au-themes
;; Version: 0.1.0
;; Package-Requires: ((emacs "28.1") (ef-themes "1.0.0"))
;; Keywords: faces, themes, accessibility, autism, neurodivergence

;; This file is not part of GNU Emacs.

;; This file is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this file.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; au-themes (named after Au - the chemical symbol for Gold, representing
;; autism pride and acceptance) is a collection of sensory-safe,
;; psycho-optically calibrated Emacs themes designed specifically for autistic
;; individuals and neurodivergent sensory profiles.
;;
;; Autistic visual perception frequently involves hyper-reactivity to visual stimuli,
;; including photophobia, pattern glare, foveal visual crowding, and rapid visual fatigue.
;; Each theme in this collection is subjected to automated diagnostic gate:
;;
;; - APCA (Advanced Perceptual Contrast Algorithm) and ISO-compliant contrast tuning
;; - Parvocellular vs Magnocellular (M/P) visual pathway balancing
;; - Tonic accommodation lock
;; - Bouma window visual crowding suppression
;; - Isoluminance jitter elimination across adjacent syntax tokens
;; - Zero color collisions with strict 1:1 semantic syntax determinism
;; - Reduced blue light and macular hazard mitigation

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
  "List of themes included in the au-themes collection."
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
