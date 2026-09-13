;;; test-asd-semantic-entropy.el --- ASD Semantic Entropy and Sensory Chroma Dispersion -*- lexical-binding: t -*-

;; Copyright (C) 2026  Szymon Wilczek

;; Author: Szymon Wilczek <swilczek.lx@gmail.com>
;; URL: https://github.com/szymonwilczek/au-themes

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
;; Evaluate Shannon entropy H and Oklab chroma C* dispersion for ASD sensory
;; processing.
;; Autism spectrum processing exhibits detail-focused processing (weak central
;; coherence).
;; Excessive chroma variance ('code christmas tree') causes sensory noise
;; and cognitive overwhelm.
;;
;; Ref:
;; - Happé & Frith (2006) J. Autism Dev. Disord.
;; - Shannon (1948)
;; - Ottosson (2020)

;;; Code:

(require 'test-palette-extractor)

(defun test-asd-semantic-entropy-run ()
  "Evaluate Shannon entropy H and Oklab chroma C* dispersion for ASD sensory processing.
Autism spectrum processing exhibits detail-focused processing (weak central coherence).
Excessive chroma variance ('code christmas tree') causes sensory noise and cognitive overwhelm.
Ref: Happé & Frith (2006) J. Autism Dev. Disord.; Shannon (1948); Ottosson (2020)."
  (let* ((pal (au-extract-active-palette))
         (theme (plist-get pal :theme))
         (polarity (rf-theme-polarity theme))
         (bg (plist-get pal :bg-main))
         (passes 0)
         (fails 0)
         (tokens '(("Base text"                 :fg-main)
                   ("Comments"                  :fg-dim)
                   ("Keywords"                  :keyword)
                   ("Data types"                :type)
                   ("Constants"                 :constant)
                   ("Numbers"                   :number)
                   ("Builtins"                  :builtin)
                   ("Function definitions"      :fnname)
                   ("Function calls"            :fnname-call)
                   ("Strings"                   :string)
                   ("Struct fields"             :property)
                   ("Operators"                 :operator)
                   ("Brackets"                  :bracket)))
         (chromas (mapcar (lambda (item) (nth 1 (rf-hex-to-oklch (plist-get pal (cadr item))))) tokens))
         (n (length chromas))
         (mean-c (/ (apply #'+ chromas) (float n)))
         (var-c (/ (apply #'+ (mapcar (lambda (c) (expt (- c mean-c) 2)) chromas)) (float n)))
         (std-c (sqrt var-c))
         ;; Discretize chromas into 5 equal bins in range [0.0..0.20] for Shannon Entropy
         (num-bins 5)
         (bin-width 0.04)
         (bin-counts (make-vector num-bins 0)))

    (dolist (c chromas)
      (let ((idx (min (1- num-bins) (max 0 (floor (/ c bin-width))))))
        (aset bin-counts idx (1+ (aref bin-counts idx)))))

    (let ((shannon-h 0.0))
      (dotimes (i num-bins)
        (let ((count (aref bin-counts i)))
          (when (> count 0)
            (let ((p (/ (float count) n)))
              (setq shannon-h (- shannon-h (* p (log p 2))))))))

      (princ (format "\n======================================================================\n"))
      (princ (format " ASD Semantic Entropy & Sensory Chroma Dispersion Suite\n"))
      (princ (format " Ref: Happe & Frith (2006); Shannon (1948) Bell Syst. Tech. J.\n"))
      (princ (format " Theme: %s (%s) | Background: %s\n" theme polarity bg))
      (princ (format "======================================================================\n"))

      ;; Part 1: Oklab Chroma Vector per Role
      (princ "\nPart 1: Oklab Syntactic Chroma C* Vector Distribution:\n")
      (princ (format "%-28s | %-8s | %-8s | %-8s | %-8s\n"
                     "Syntax Role" "Hex" "Chroma C*" "Max C*" "Status"))
      (princ (format "-----------------------------+----------+----------+----------+----------\n"))
      (dolist (tok tokens)
        (let* ((label (car tok))
               (key   (cadr tok))
               (hex   (plist-get pal key))
               (c-val (nth 1 (rf-hex-to-oklch hex)))
               (max-c (if (eq polarity 'light) 0.130 0.145))
               (ok    (<= c-val max-c)))
          (if ok
              (setq passes (1+ passes))
            (setq fails (1+ fails)))
          (princ (format "%-28s | %-8s | %8.4f | <= %5.3f | %s\n"
                         label hex c-val max-c (if ok "PASS" "FAIL")))))
      (princ (format "-----------------------------+----------+----------+----------+----------\n"))

      ;; Part 2: Mean Chroma and Dispersion (Narrow Cohesive Envelope)
      (princ "\nPart 2: Mean Chroma and Standard Deviation Envelope:\n")
      (let* ((max-mean-c (if (eq polarity 'light) 0.100 0.115))
             (max-std-c  0.055)
             (mean-ok (<= mean-c max-mean-c))
             (std-ok  (<= std-c max-std-c)))
        (if mean-ok
            (progn
              (princ (format "   [PASS] Mean Chroma C* = %.4f <= %.3f: Muted, non-overstimulating palette.\n"
                             mean-c max-mean-c))
              (setq passes (1+ passes)))
          (princ (format "   [FAIL] Mean Chroma C* = %.4f > %.3f: Saturated sensory overload.\n"
                         mean-c max-mean-c))
          (setq fails (1+ fails)))

        (if std-ok
            (progn
              (princ (format "   [PASS] Chroma Std Dev sigma = %.4f <= %.3f: Cohesive, non-fragmented syntax.\n"
                             std-c max-std-c))
              (setq passes (1+ passes)))
          (princ (format "   [FAIL] Chroma Std Dev sigma = %.4f > %.3f: Disjointed chroma spikes.\n"
                         std-c max-std-c))
          (setq fails (1+ fails))))

      ;; Part 3: Shannon Information Entropy
      (princ "\nPart 3: Shannon Semantic Chrominance Entropy H:\n")
      (let* ((h-max (log num-bins 2))
             (max-entropy 2.10) ; structured clustering: avoids scattered uniform noise (H_max = 2.322 bits)
             (entropy-ok (<= shannon-h max-entropy)))
        (if entropy-ok
            (progn
              (princ (format "   [PASS] Shannon Entropy H = %.3f bits <= %.2f bits (H_max = %.3f, relative = %.1f%%): Structured chroma clustering.\n"
                             shannon-h max-entropy h-max (* 100.0 (/ shannon-h h-max))))
              (setq passes (1+ passes)))
          (princ (format "   [FAIL] Shannon Entropy H = %.3f bits > %.2f bits: Unstructured uniform chroma scatter.\n"
                         shannon-h max-entropy))
          (setq fails (1+ fails))))

      (princ (format "\n----------------------------------------------------------------------\n"))
      (princ (format "ASD Semantic Entropy Summary: %d Passed, %d Failed.\n\n" passes fails))
      (zerop fails))))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-asd-semantic-entropy-run)
    (kill-emacs 1)))

(provide 'test-asd-semantic-entropy)
;;; test-asd-semantic-entropy.el ends here
