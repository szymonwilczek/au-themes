;;; test-determinism-1to1.el --- 1:1 Keyface determinism and pairwise perceptual distance -*- lexical-binding: t -*-

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
;; Evaluate 1:1 keyface uniqueness and pairwise CIEDE2000 separation (min 10.0).
;; Colour separation is measured with CIEDE2000, not with Emacs' `color-distance',
;; which is an unpublished sRGB heuristic that is not perceptually uniform:
;; the same numeric gate of 8000 corresponded to dE00 between 9.7 and 19.7
;; depending on the hue pair.
;;
;; Ref:
;; CIE 142:2001 / ISO-CIE 11664-6:2014 (CIEDE2000).

;;; Code:

(require 'test-palette-extractor)

(defun test-determinism-1to1-run ()
  "Evaluate 1:1 keyface uniqueness and pairwise CIEDE2000 separation (min 10.0)"
  (let* ((theme (or rf-active-theme 'au-whispergrove-night))
         (pal (au-extract-active-palette theme))
         (passes 0)
         (fails 0)
         (tokens-to-check '(:preprocessor :keyword :type :constant :number
                                          :builtin :fnname :fnname-call :string :property
                                          :operator :bracket :delimiter :err :fg-dim :fg-main))
         (critical-pairs
          '(("define vs keyword"               :preprocessor :keyword)
            ("define vs constant"              :preprocessor :constant)
            ("keyword vs constant"             :keyword      :constant)
            ("keyword vs type"                 :keyword      :type)
            ("define vs type"                  :preprocessor :type)
            ("constant vs number"              :constant     :number)
            ("constant vs string"              :constant     :string)
            ("number vs string"                :number       :string)
            ("keyword vs builtin"              :keyword      :builtin)
            ("builtin vs fnname"               :builtin      :fnname)
            ("fnname vs fnname-call"           :fnname       :fnname-call)
            ("fnname vs type"                  :fnname       :type)
            ("fnname-call vs type"             :fnname-call  :type)
            ("property vs base text"           :property     :fg-main)
            ("define vs property"              :preprocessor :property)
            ("constant vs property"            :constant     :property)
            ("fnname-call vs property"         :fnname-call  :property)
            ("number vs base text"             :number       :fg-main)
            ("keyword vs base text"            :keyword      :fg-main)
            ("define vs base text"             :preprocessor :fg-main)
            ("type vs base text"               :type         :fg-main)
            ("constant vs base text"           :constant     :fg-main)
            ("builtin vs base text"            :builtin      :fg-main)
            ("fnname-call vs base text"        :fnname-call  :fg-main)
            ("string vs base text"             :string       :fg-main)
            ("err (!) vs base text"            :err          :fg-main)
            ("bracket vs base text"            :bracket      :fg-main)
            ("comments (needles) vs base text" :fg-dim       :fg-main)
            ("define vs string"                :preprocessor :string)
            ("define vs number"                :preprocessor :number)
            ("define vs builtin"               :preprocessor :builtin)
            ("builtin vs constant"             :builtin      :constant)
            ("keyword vs string"               :keyword      :string)
            ("type vs string"                  :type         :string)
            ("property vs string"              :property     :string)
            ("property vs type"                :property     :type)
            ("property vs keyword"             :property     :keyword)
            ("property vs fnname"              :property     :fnname)
            ("fnname-call vs builtin"          :fnname-call  :builtin)
            ("number vs type"                  :number       :type)
            ("number vs keyword"               :number       :keyword)
            ("number vs property"              :number       :property)
            ("fnname vs constant"              :fnname       :constant)
            ("fnname vs string"                :fnname       :string)
            ("define vs fnname"                :preprocessor :fnname)
            ("define vs fnname-call"           :preprocessor :fnname-call))))

    (princ (format "\n.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.\n"))
    (princ (format "| 1:1 Keyface Determinism & Pairwise CIEDE2000 Suite (min. dE00 10.0)\n"))
    (princ (format "| Theme: %s\n" theme))
    (princ (format "'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'\n"))

    (princ "\nKeyface Color Uniqueness (No shared hex across keyfaces):\n")
    (let ((seen (make-hash-table :test 'equal))
          (collisions nil))
      (dolist (key tokens-to-check)
        (let* ((hex (plist-get pal key))
               (prior (gethash hex seen)))
          (if (and prior (not (and (memq key '(:bracket :delimiter))
                                   (memq prior '(:bracket :delimiter)))))
              (push (cons key prior) collisions)
            (puthash hex key seen))))
      (if collisions
          (progn
            (princ (format "[FAIL]  Color collision detected: %S\n" collisions))
            (setq fails (1+ fails)))
        (princ "[PASS]  100% Deterministic: Each syntax role has a unique dedicated color.\n")
        (setq passes (1+ passes))))

    (princ (format "-------------------------------------------------------------------------------------------\n"))
    (princ "\nPairwise Separation Check (CIEDE2000 dE00 >= 10.0):\n")
    (princ (format "+--------------------------------------+-------------+-------------+-----------+----------+\n"))
    (princ (format "| %-31s      |   %-10s|   %-10s|  %-6s   |  %-6s  |\n"
                   "Role Comparison" "Color 1" "Color 2" " dE00" "Status"))
    (princ (format "+--------------------------------------+-------------+-------------+-----------+----------+\n"))
    (dolist (pair critical-pairs)
      (let* ((name (nth 0 pair))
             (k1   (nth 1 pair))
             (k2   (nth 2 pair))
             (min-dist (or (nth 3 pair) 10.0))
             (h1   (plist-get pal k1))
             (h2   (plist-get pal k2))
             (dist (rf-delta-e-2000 h1 h2))
             (ok   (>= dist min-dist)))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "| %-31s      |   %-10s|   %-10s|%8.2f   |   %s   |\n"
                       name h1 h2 dist
                       (if ok "PASS" (format "FAIL (<%.1f)" min-dist))))))
    (princ (format "+--------------------------------------+-------------+-------------+-----------+----------+\n"))


    (princ "\nCategorical Role Disparity Check (Daylight Hue Delta-h >= 40deg or Night Delta-L >= 0.08):\n")


    (princ (format "+--------------------------------------+--------+----------+-----------+---------+--------+\n"))
    (princ (format "| %-36s | %-7s | %-7s | %-9s | %-7s | %-7s|\n"
                   "Role Comparison" "Color 1" "Color 2" " Delta-h" "Delta-L" "Status"))
    (princ (format "+--------------------------------------+---------+---------+-----------+---------+--------+\n"))
    (let* ((polarity (rf-theme-polarity theme))
           (hue-pairs '(("struct (keyword) vs int (type)"         :keyword      :type        40.0)
                        ("struct (keyword) vs sizeof (builtin)"   :keyword      :builtin     40.0)
                        ("int (type) vs sizeof (builtin)"         :type         :builtin     15.0)
                        ("struct (keyword) vs constant"           :keyword      :constant    40.0)
                        ("struct (keyword) vs bpf_ (call)"        :keyword      :fnname-call 40.0)
                        ("constant vs bpf_ (call)"                :constant     :fnname-call 40.0)
                        ("preprocessor vs property"               :preprocessor :property    40.0)
                        ("constant vs property"                   :constant     :property    25.0)
                        ("bpf_ (call) vs property"                :fnname-call  :property    40.0)
                        ("bpf_ (call) vs base text"               :fnname-call  :fg-main     40.0)
                        ("preprocessor vs base text"              :preprocessor :fg-main     40.0)
                        ("0 (number) vs \"string\""               :number       :string      20.0)
                        ("preprocessor vs string"                 :preprocessor :string      25.0)
                        ("preprocessor vs constant"               :preprocessor :constant    40.0)
                        ("preprocessor vs builtin"                :preprocessor :builtin     40.0)
                        ("bpf_ (call) vs int (type)"              :fnname-call  :type        40.0)
                        ("property vs struct (keyword)"           :property     :keyword     40.0)
                        ("builtin vs constant"                    :builtin      :constant    25.0))))
      (dolist (hp hue-pairs)
        (let* ((name (nth 0 hp))
               (k1 (nth 1 hp))
               (k2 (nth 2 hp))
               (min-dh (nth 3 hp))
               (h1 (plist-get pal k1))
               (h2 (plist-get pal k2))
               (okl1 (rf-hex-to-oklch h1))
               (okl2 (rf-hex-to-oklch h2))
               (l1 (nth 0 okl1))
               (l2 (nth 0 okl2))
               (dl (abs (- l1 l2)))
               (hue1 (nth 2 okl1))
               (hue2 (nth 2 okl2))
               (raw-dh (abs (- hue1 hue2)))
               (dh (min raw-dh (- 360.0 raw-dh)))
               (ok (or (>= dh min-dh) (>= dl 0.08))))
          (if ok
              (setq passes (1+ passes))
            (setq fails (1+ fails)))
          (princ (format "| %-36s | %-7s | %-7s | %5.1fdeg  |  %5.3f  |  %s  |\n"
                         name h1 h2 dh dl
                         (if ok "PASS" "FAIL"))))))
    (princ (format "+--------------------------------------+---------+---------+-----------+---------+--------+\n"))


    (princ (format "\n===========================================================================================\n"))
    (princ (format "Determinism and Distance Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (let ((env (getenv "RF_TEST_THEMES")))
    (when (and env (not (string-empty-p env)))
      (setq rf-active-theme (intern (car (split-string env "[, ]+" t))))))
  (unless (test-determinism-1to1-run)
    (kill-emacs 1)))

(provide 'test-determinism-1to1)
;;; test-determinism-1to1.el ends here
