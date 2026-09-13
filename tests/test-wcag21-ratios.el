;;; test-wcag21-ratios.el --- WCAG 2.1 relative luminance and photophobia trade-off evaluation -*- lexical-binding: t -*-

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
;; Evaluate WCAG 2.1 relative luminance contrast ratios.
;;
;; Note:
;; Full ISO/IEC 40500 / WCAG 2.1 SC 1.4.3 requires >= 4.5:1 across all body
;; text.
;; In photophobic nocturnal themes, primary body text meets the 4.5:1 threshold,
;; while secondary syntactic roles (comments, delimiters, brackets)
;; are intentionally subordinated to 1.5:1 - 3.0:1 to reduce sensory overload
;; and cortical stress.

;;; Code:

(require 'test-palette-extractor)

(defun test-wcag21-ratios-run ()
  "Evaluate WCAG 2.1 relative luminance contrast ratios.
Note: Full ISO/IEC 40500 / WCAG 2.1 SC 1.4.3 requires >= 4.5:1 across all body text.
In photophobic nocturnal themes, primary body text meets the 4.5:1 threshold,
while secondary syntactic roles (comments, delimiters, brackets) are intentionally
subordinated to 1.5:1 - 3.0:1 to reduce sensory overload and cortical stress."
  (let* ((pal (au-extract-active-palette))
         (bg (plist-get pal :bg-main))
         (theme (plist-get pal :theme))
         (passes 0)
         (fails 0)
         (tokens '(("Base text (Mineral quartz)"       :fg-main      4.5)
                   ("Comments (Damp needles)"          :fg-dim       1.5)
                   ("Cursor (Raindrop glint)"          :cursor       3.0)
                   ("Preprocessor (#define)"           :preprocessor 3.0)
                   ("Keywords (struct, while)"         :keyword      2.0)
                   ("Data types (int, size_t)"         :type         3.0)
                   ("Constants (LOTA_PCR_COUNT)"       :constant     2.0)
                   ("Numbers (0, 24, 32)"              :number       3.0)
                   ("Builtins (__always_inline)"       :builtin      2.0)
                   ("Function definitions"             :fnname       2.0)
                   ("Function calls (bpf_...)"         :fnname-call  3.0)
                   ("Strings (\"string literals\")"    :string       2.5)
                   ("Struct fields (->tgid)"           :property     2.5)
                   ("Operators (+, -, *, >>)"          :operator     2.0)
                   ("Brackets (( ) [ ] { })"           :bracket      1.8)
                   ("Alerts / Errors (!)"              :err          2.0))))
    (princ (format "\n======================================================================\n"))
    (princ (format " WCAG 2.1 Contrast & Photophobia-Readability Trade-off Suite\n"))
    (princ (format " Theme: %s | Background: %s\n" theme bg))
    (princ (format " Note: Base text targets SC 1.4.3 (>= 4.5:1); syntax roles use intentional\n"))
    (princ (format "       photophobia subordination thresholds (1.5:1 - 3.0:1).\n"))
    (princ (format "======================================================================\n"))
    (princ (format "%-32s | %-8s | %-7s | %-12s | %-8s\n" "Token Role" "Hex" "Ratio" "Min Target" "Status"))
    (princ (format "---------------------------------+----------+---------+--------------+----------\n"))
    (dolist (tok tokens)
      (let* ((name (nth 0 tok))
             (key  (nth 1 tok))
             (min-ratio (nth 2 tok))
             (hex (plist-get pal key))
             (ratio (rf-wcag-contrast-ratio hex bg))
             (ok (>= ratio min-ratio)))
        (if ok
            (setq passes (1+ passes))
          (setq fails (1+ fails)))
        (princ (format "%-32s | %-8s | %6.2f:1 | >= %4.1f:1     | %s\n"
                       name hex ratio min-ratio
                       (if ok "PASS" "FAIL")))))
    (princ (format "---------------------------------+----------+---------+--------------+----------\n"))
    (princ (format "WCAG 2.1 Summary: %d Passed, %d Failed.\n\n" passes fails))
    (zerop fails)))

(when (and noninteractive (not (bound-and-true-p rf-running-all-tests)))
  (unless (test-wcag21-ratios-run)
    (kill-emacs 1)))

(provide 'test-wcag21-ratios)
;;; test-wcag21-ratios.el ends here
