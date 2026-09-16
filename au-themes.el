;;; au-themes.el --- Sensory-safe themes for autism and neurodivergence -*- lexical-binding: t -*-

;; Copyright (C) 2026  Szymon Wilczek

;; Author: Szymon Wilczek <swilczek.lx@gmail.com>
;; URL: https://github.com/szymonwilczek/au-themes
;; Version: 0.1.0
;; Package-Requires: ((emacs "28.1") (ef-themes "2.0.0") (modus-themes "5.2.0"))
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
;; Each theme in this collection is subjected to automated diagnostic gates:
;;
;; - APCA (Advanced Perceptual Contrast Algorithm) and ISO-compliant contrast tuning
;; - Parvocellular vs Magnocellular (M/P) visual pathway balancing
;; - Tonic accommodation lock
;; - Bouma window visual crowding suppression
;; - Isoluminance jitter elimination across adjacent syntax tokens
;; - Zero color collisions with strict 1:1 semantic syntax determinism
;; - Reduced blue light and macular hazard mitigation

;;; Code:

(require 'cl-lib)
(require 'subr-x)

(defgroup au-themes ()
  "Sensory-safe, scientifically gated themes for autism and neurodivergence."
  :group 'faces
  :prefix "au-themes-")

(defvar au-themes--dir
  (file-name-directory
   (or (macroexp-file-name)
       load-file-name
       (buffer-file-name)
       (when-let* ((lib (locate-library "au-themes"))) lib)
       default-directory))
  "Directory where `au-themes' library resides.")

(when (and (boundp 'custom-theme-load-path)
           au-themes--dir)
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (expand-file-name au-themes--dir))))

(defun au-themes--get-theme-dirs ()
  "Return list of directory paths where au-themes may reside."
  (let ((dirs nil))
    (when (and au-themes--dir (file-directory-p au-themes--dir))
      (push (file-name-as-directory (expand-file-name au-themes--dir)) dirs))
    (dolist (d custom-theme-load-path)
      (when (and (stringp d) (file-directory-p d))
        (push (file-name-as-directory (expand-file-name d)) dirs)))
    (dolist (p load-path)
      (when (and (stringp p)
                 (file-directory-p p)
                 (directory-files p nil "\\`au-[-a-z0-9]+-theme\\.el\\'"))
        (push (file-name-as-directory (expand-file-name p)) dirs)))
    (delete-dups (nreverse dirs))))

(defun au-themes--discover-themes ()
  "Dynamically discover all available au-themes across load paths.
Finds all theme files matching `au-*-theme.el'"
  (let ((themes nil))
    (dolist (dir (au-themes--get-theme-dirs))
      (when (file-directory-p dir)
        (dolist (file (directory-files dir nil "\\`au-[-a-z0-9]+-theme\\.el\\'"))
          (when (string-match "\\`\\(au-[-a-z0-9]+\\)-theme\\.el\\'" file)
            (let ((theme-sym (intern (match-string 1 file))))
              (push theme-sym themes))))))
    (sort (delete-dups themes)
          (lambda (a b) (string< (symbol-name a) (symbol-name b))))))

(defcustom au-themes-collection nil
  "List of themes included in the `au-themes' collection.
When nil (the default), themes are dynamically discovered from
`custom-theme-load-path' and library directories."
  :type '(choice (const :tag "Dynamic autodiscovery" nil)
                 (repeat :tag "Explicit theme list" symbol))
  :group 'au-themes)

(defun au-themes--hex-to-rgb (hex)
  "Convert HEX string #rrggbb to list of normalized (R G B) [0.0..1.0]."
  (let ((h (string-remove-prefix "#" hex)))
    (list (/ (string-to-number (substring h 0 2) 16) 255.0)
          (/ (string-to-number (substring h 2 4) 16) 255.0)
          (/ (string-to-number (substring h 4 6) 16) 255.0))))

(defun au-themes--srgb-to-linear (c)
  "Convert sRGB channel C [0.0..1.0] to linear light."
  (if (<= c 0.04045)
      (/ c 12.92)
    (expt (/ (+ c 0.055) 1.055) 2.4)))

(defun au-themes--luminance-y (hex)
  "Compute relative biophysical luminance Y [0.0..1.0] from HEX color code."
  (let* ((rgb (au-themes--hex-to-rgb hex))
         (lr (au-themes--srgb-to-linear (nth 0 rgb)))
         (lg (au-themes--srgb-to-linear (nth 1 rgb)))
         (lb (au-themes--srgb-to-linear (nth 2 rgb))))
    (+ (* 0.2126729 lr) (* 0.7151522 lg) (* 0.0721750 lb))))

(defun au-themes--theme-palette (theme)
  "Extract palette alist for THEME, requiring theme library if needed."
  (let* ((pal-sym (intern (format "%s-palette-partial" theme)))
         (file-sym (intern (format "%s-theme" theme))))
    (unless (boundp pal-sym)
      (require file-sym nil t))
    (when (boundp pal-sym)
      (symbol-value pal-sym))))

(defun au-themes--theme-polarity (theme)
  "Determine whether THEME is `light' or `dark' via biophysical luminance.
Calculates luminance Y of `bg-main' and caches the polarity on the theme
symbol property `au-themes-polarity'.
Threshold: Y >= 0.25 is light, Y < 0.25 is dark."
  (or (get theme 'au-themes-polarity)
      (let* ((palette (au-themes--theme-palette theme))
             (bg-main (cadr (assq 'bg-main palette))))
        (when bg-main
          (let* ((y (au-themes--luminance-y bg-main))
                 (polarity (if (>= y 0.25) 'light 'dark)))
            (put theme 'au-themes-polarity polarity)
            (put theme 'au-themes-luminance-y y)
            polarity)))))

(defun au-themes-get-themes (&optional polarity)
  "Return list of discovered au-themes, optionally filtered by POLARITY.
POLARITY should be `light' or `dark'."
  (let ((all (or au-themes-collection (au-themes--discover-themes))))
    (if polarity
        (cl-remove-if-not (lambda (th) (eq (au-themes--theme-polarity th) polarity)) all)
      all)))

(defcustom au-themes-post-load-hook nil
  "Hook run after an au-theme is loaded and enabled."
  :type 'hook
  :group 'au-themes)

(defcustom au-themes-toggle-themes '(au-aurum-day au-aurum-night)
  "Default pair of themes to toggle between when no history exists."
  :type '(list symbol symbol)
  :group 'au-themes)

(defvar au-themes--last-light-theme nil
  "Last enabled light theme in au-themes.")

(defvar au-themes--last-dark-theme nil
  "Last enabled dark theme in au-themes.")

(defvar au-themes--select-history nil
  "Minibuffer history for `au-themes' selectors.")

(defun au-themes-get-current-theme ()
  "Return currently enabled theme that belongs to `au-themes', if any."
  (seq-find (lambda (theme) (memq theme (au-themes-get-themes)))
            custom-enabled-themes))

(defun au-themes--apply-theme (theme)
  "Switch to THEME by disabling other themes and loading THEME."
  (unless (eq theme (car custom-enabled-themes))
    (dolist (enabled custom-enabled-themes)
      (disable-theme enabled))
    (when theme
      (load-theme theme t))))

(defun au-themes-load-theme (theme)
  "Disable current themes and enable au-theme THEME."
  (unless (memq theme (au-themes-get-themes))
    (user-error "`%s' is not a recognized au-theme" theme))
  (au-themes--apply-theme theme)
  (let ((polarity (au-themes--theme-polarity theme)))
    (if (eq polarity 'light)
        (setq au-themes--last-light-theme theme)
      (setq au-themes--last-dark-theme theme)))
  (run-hooks 'au-themes-post-load-hook)
  (message "Loaded theme: `%s' [%s]"
           theme (upcase (symbol-name (or (au-themes--theme-polarity theme) 'unknown)))))

;;;###autoload
(defun au-themes-toggle ()
  "Toggle between a light and a dark theme from `au-themes'.
Alternates between the last selected light and dark themes, defaulting
to `au-themes-toggle-themes'."
  (interactive)
  (let* ((current (au-themes-get-current-theme))
         (curr-polarity (and current (au-themes--theme-polarity current)))
         (target (cond
                  ((eq curr-polarity 'light)
                   (or au-themes--last-dark-theme
                       (cadr au-themes-toggle-themes)
                       (car (au-themes-get-themes 'dark))))
                  ((eq curr-polarity 'dark)
                   (or au-themes--last-light-theme
                       (car au-themes-toggle-themes)
                       (car (au-themes-get-themes 'light))))
                  (t
                   (or (car au-themes-toggle-themes)
                       (car (au-themes-get-themes 'dark)))))))
    (if target
        (au-themes-load-theme target)
      (user-error "No valid au-theme available to toggle"))))

;;;###autoload
(defalias 'au-toggle #'au-themes-toggle)

(defvar au-themes--picker-initial-theme nil
  "Theme that was active when the picker was initiated.")

(defun au-themes--group-themes (cand transform)
  "Group CAND for minibuffer completion into Light and Dark.
If TRANSFORM is non-nil, return CAND unchanged."
  (if transform
      cand
    (let ((symbol (intern-soft cand)))
      (if (eq (au-themes--theme-polarity symbol) 'light)
          "Light themes"
        "Dark themes"))))

(defun au-themes--annotate-theme (cand)
  "Annotate CAND with its polarity, relative luminance Y, and active status."
  (let* ((symbol (intern-soft cand))
         (pol (au-themes--theme-polarity symbol))
         (y (get symbol 'au-themes-luminance-y))
         (active (and au-themes--picker-initial-theme
                      (eq symbol au-themes--picker-initial-theme))))
    (concat
     (if (and pol y)
         (format "  [%s, Y=%.2f]" (upcase (symbol-name pol)) y)
       (if pol
           (format "  [%s]" (upcase (symbol-name pol)))
         ""))
     (if active " (active)" ""))))

(defun au-themes--display-sort (candidates)
  "Preserve stable candidate order for minibuffer completion."
  candidates)

(defun au-themes--completion-table (themes)
  "Return completion table with rich metadata for THEMES."
  (lambda (string pred action)
    (if (eq action 'metadata)
        '(metadata
          (category . theme)
          (group-function . au-themes--group-themes)
          (annotation-function . au-themes--annotate-theme)
          (display-sort-function . au-themes--display-sort))
      (complete-with-action action (mapcar #'symbol-name themes) string pred))))

(defun au-themes--prompt-with-preview (themes prompt)
  "Prompt user to select a theme from THEMES with live buffer preview.
Restores previous theme if aborted."
  (let* ((saved-theme (au-themes-get-current-theme))
         (au-themes--picker-initial-theme saved-theme)
         (default-theme (or saved-theme (car themes)))
         (cand-names (mapcar #'symbol-name themes)))
    (if (fboundp 'consult--read)
        ;; Consult
        (let ((selected
               (consult--read
                cand-names
                :prompt prompt
                :require-match t
                :category 'theme
                :history 'au-themes--select-history
                :group #'au-themes--group-themes
                :annotate #'au-themes--annotate-theme
                :sort nil
                :default (and default-theme (symbol-name default-theme))
                :lookup (lambda (sel &rest _)
                          (and sel (intern-soft sel)))
                :state (lambda (action cand)
                         (pcase action
                           ('preview
                            (when cand
                              (let ((th (if (symbolp cand) cand (intern-soft cand))))
                                (when (memq th themes)
                                  (au-themes--apply-theme th)))))
                           ('return
                            (let ((final-th (or (and cand (if (symbolp cand) cand (intern-soft cand)))
                                                saved-theme)))
                              (when final-th
                                (au-themes--apply-theme final-th)))))))))
          (or selected saved-theme))
      ;; completing-read
      (let ((completed nil)
            (preview-cand nil))
        (unwind-protect
            (minibuffer-with-setup-hook
                (lambda ()
                  (add-hook
                   'post-command-hook
                   (lambda ()
                     (when-let* ((cand-str (or (and (bound-and-true-p vertico-mode)
                                                    (fboundp 'vertico--candidate)
                                                    (vertico--candidate))
                                               (minibuffer-contents)))
                                 (cand-sym (intern-soft cand-str)))
                       (when (and (memq cand-sym themes)
                                  (not (eq cand-sym preview-cand)))
                         (setq preview-cand cand-sym)
                         (au-themes--apply-theme cand-sym))))
                   nil t))
              (let* ((choice (completing-read
                              (format "%s (default %s): " prompt default-theme)
                              (au-themes--completion-table themes)
                              nil t nil
                              'au-themes--select-history
                              (symbol-name default-theme)))
                     (chosen-sym (intern-soft choice)))
                (setq completed t)
                (or chosen-sym saved-theme)))
          ;; Aborted -> restore original theme
          (unless completed
            (when saved-theme
              (au-themes--apply-theme saved-theme))))))))

;;;###autoload
(defun au-themes-select (&optional theme)
  "Select and enable a theme from `au-themes' collection with live preview.
Themes are grouped into Light and Dark categories.
With optional THEME symbol, load it directly without prompting."
  (interactive)
  (let* ((themes (au-themes-get-themes))
         (chosen (or theme
                     (au-themes--prompt-with-preview themes "Select au-theme: "))))
    (when chosen
      (au-themes-load-theme chosen))))

;;;###autoload
(defun au-themes-select-light (&optional theme)
  "Select and enable a light theme from `au-themes' collection with live preview.
With optional THEME symbol, load it directly without prompting."
  (interactive)
  (let* ((themes (au-themes-get-themes 'light))
         (chosen (or theme
                     (au-themes--prompt-with-preview themes "Select light au-theme: "))))
    (when chosen
      (au-themes-load-theme chosen))))

;;;###autoload
(defun au-themes-select-dark (&optional theme)
  "Select and enable a dark theme from `au-themes' collection with live preview.
With optional THEME symbol, load it directly without prompting."
  (interactive)
  (let* ((themes (au-themes-get-themes 'dark))
         (chosen (or theme
                     (au-themes--prompt-with-preview themes "Select dark au-theme: "))))
    (when chosen
      (au-themes-load-theme chosen))))

;;;###autoload
(defalias 'au-select #'au-themes-select)

;;;###autoload
(defalias 'au-select-light #'au-themes-select-light)

;;;###autoload
(defalias 'au-select-dark #'au-themes-select-dark)

(provide 'au-themes)
;;; au-themes.el ends here
