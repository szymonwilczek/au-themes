;;; rainforest.el --- Accessible rainy forest themes for Emacs -*- lexical-binding: t -*-

;; Author: Szymon Wilczek <swilczek.lx@gmail.com>
;; Version: 0.1.0
;; Package-Requires: ((emacs "28.1") (ef-themes "1.0.0"))
;; Keywords: faces, themes, accessibility

;;; Commentary:
;; Ergonomic themes tailored for extreme eye strain (APCA / WCAG 3).
;; Features rainy forest palettes:
;; - rainforest-day: damp sage and conifer woods with low glare (APCA Lc >= 75)
;; - rainforest-night: dark humus and rain with zero photic irradiation (LCD/OLED calibrated)

;;; Code:

(require 'rainforest-day-theme)
(require 'rainforest-night-theme)

;;;###autoload
(defun rainforest-toggle ()
  "Przełącz między rainforest-day a rainforest-night."
  (interactive)
  (if (eq (car custom-enabled-themes) 'rainforest-day)
      (progn
        (disable-theme 'rainforest-day)
        (load-theme 'rainforest-night t)
        (message "Włączono rainforest-night"))
    (progn
      (disable-theme 'rainforest-night)
      (load-theme 'rainforest-day t)
      (message "Włączono rainforest-day"))))

;;;###autoload
(when (and (boundp 'custom-theme-load-path)
           load-file-name)
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

(provide 'rainforest)
;;; rainforest.el ends here
