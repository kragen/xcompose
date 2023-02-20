;;; xcompose.el --- major mode for editing .XCompose files
;; Copyright (C) 2019 Mark Shoulson

;; Author: Mark Shoulson
;; Maintainer: Mark Shoulson
;; URL:

;; This file is NOT part of GNU Emacs

;; Permission is hereby granted, free of charge, to any person
;; obtaining a copy of this software and associated documentation
;; files (the "Software"), to deal in the Software without
;; restriction, including without limitation the rights to use, copy,
;; modify, merge, publish, distribute, sublicense, and/or sell copies
;; of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:

;; The above copyright notice and this permission notice shall be
;; included in all copies or substantial portions of the Software.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;; NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
;; BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
;; ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
;; CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.

;;; Commentary:

;; This file provides the major mode xcompose-mode, for use in editing
;; .XCompose files, which are used in X-windows systems to define the
;; behavior certain sequential keystroke combinations, usually involving
;; the "Multi-Key".  It was also built with an eye towards use with "base"
;; files, which are slightly simplified compose files I use for
;; convenience.

;; Mainly fontifying; eventually should do better formatting, finding the
;; right tab stops etc.

;;; Code:

(defface xcompose-angle-face
  ;; Black seems to stand out best, what can I say?
  '((t (:inherit bold)))
  "Face for the angle brackets (<>) around key-names."
  :group 'xcompose-mode)

(defface xcompose-keys-face
  '((t (:inherit font-lock-constant-face)))
  "Face for the key names."
  :group 'xcompose-mode)

(defface xcompose-string-face
  ;; I feel like these should really stand out, not just plain-jane
  ;; font-lock-string-face.  Even to the point of increasing the size and
  ;; drawing boxes.
  '((t (:inherit font-lock-string-face
                 :height 1.2
                 :box "black")))
  "Face for the quoted strings containing the character(s) to be produced."
  :group 'xcompose-mode)

(defface xcompose-quotemark-face
  '((t (:inherit font-lock-string-face
                 :foreground "dark orchid")))
  "Face for quote-marks around character strings."
  :group 'xcompose-mode)

;; Yes, kind of a lot of faces and a lot of fine-tuning of the line's
;; appearance.  Maybe a bit too much.
(defface xcompose-num-face
  '((t (:inherit font-lock-preprocessor-face :weight bold)))
  "Face for the hex numbers identifying the code-point."
  :group 'xcompose-mode)

(defface xcompose-U-face
  '((t (:inherit font-lock-preprocessor-face)))
  "Face for the U before the hex numbers."
  :group 'xcompose-mode)

(defface xcompose-colon-face
  '((t (:inherit bold)))
  "Face for the \":\" separating the keystrokes from the character string."
  :group 'xcompose-mode)

;; There are LOTS of comments (commented-out lines) in some of these files;
;; I'd like them to fade into the background a bit, and I use a white
;; background.
(defface xcompose-comment-face
  `((t (:inherit font-lock-comment-face
                 :foreground "light coral")))
  "Face for comments in xcompose files."
  :group 'xcompose-mode)

(defvar xcompose-mode-syntax-table
  (let ((st (make-syntax-table text-mode-syntax-table)))
    (modify-syntax-entry ?< "(>  " st)
    (modify-syntax-entry ?> ")<  " st)
    (modify-syntax-entry ?# "<   " st)
    (modify-syntax-entry ?_ "_   " st)
    (modify-syntax-entry ?\n ">   " st)
    (modify-syntax-entry ?{ "|   " st)
    (modify-syntax-entry ?} "|   " st)
    st)
  "Syntax table for xcompose-mode")

(defvar xcompose-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c u") 'xcompose-fill-in-char-string)
    (define-key map (kbd "C-c C-u") 'xcompose-fill-in-char-code)
    ;; (define-key map (kbd "C-c C-i") 'xcompose-insert-char-name)
    (define-key map (kbd "C-c ;") 'xcompose-insert-char-name)
    map)
  "Keymap for xcompose-mode")

(defvar xcompose-font-lock-keywords
  '(
    ("[<>]" . 'xcompose-angle-face)
    ("<\\([a-zA-Z0-9_]*\\)>" . (1 'xcompose-keys-face))
    ;; ("\"[^\"]*\"" . 'xcompose-string-face)
    ("\"\\([^\"]*\\)\"" . (1 'xcompose-string-face))
    ("\"" . 'xcompose-quotemark-face)
    ("\\(U\\)\\([0-9A-Fa-f]*\\)" .
     ((1 'xcompose-U-face) (2 'xcompose-num-face)))
    (":" . 'xcompose-colon-face)
    ;; I want to be able to open my "base" files too, and automatically
    ;; de-emphasize (comment-out) things that won't be expanded (because of
    ;; too long a string.)
    ("^.*{[^}]\\{8,\\}}.*$" 0 'xcompose-comment-face prepend)
    )
  "Keywords for xcompose-mode")

(defvar xcompose-key-re "<[a-zA-Z0-9_]+"
  "Regexp matching the beginning of a keystroke.")

;; I wonder if this will be useful or really annoying.
(define-abbrev-table 'xcompose-mode-abbrev-table
  '(("<Mu" "<Multi_key" nil :system t)
	("<mu" "<Multi_key" nil :system t)
    ("<ap" "<apostrophe" nil :system t)
    ("<am" "<ampersand" nil :system t)
    ("<asciic" "<asciicircum" nil :system t)
    ("<ci" "<asciicircum" nil :system t)
    ("<asciit" "<asciitilde" nil :system t)
    ("<ti" "<asciitilde" nil :system t)
    ("<ast" "<asterisk" nil :system t)
    ("<bac" "<backslash" nil :system t)
    ("<BS" "<BackSpace" nil :system t)
    ("<bar" "<bar" nil :system t)      ; ?
    ("<bracel" "<braceleft" nil :system t)
    ("<bracer" "<braceright" nil :system t)
    ("<bracketl" "<bracketleft" nil :system t)
    ("<bracketr" "<bracketright" nil :system t)
    ("<bcl" "<braceleft" nil :system t)
    ("<bcr" "<braceright" nil :system t)
    ("<bkl" "<bracketleft" nil :system t)
    ("<bkr" "<bracketright" nil :system t)
    ("<col" "<colon" nil :system t)
    ("<com" "<comma" nil :system t)
    ("<do" "<dollar" nil :system t)
    ("<gra" "<grave" nil :system t)
    ("<gre" "<greater" nil :system t)
    ("<le" "<less" nil :system t)
    ("<mi" "<minus" nil :system t)
    ("<nu" "<numbersign" nil :system t)
    ("<parenl" "<parenleft" nil :system t)
    ("<parenr" "<parenright" nil :system t)
    ("<pl" "<parenleft" nil :system t)
    ("<pr" "<parenright" nil :system t)
    ("<perc" "<percent" nil :system t)
    ("<peri" "<period" nil :system t)
    ("<pl" "<plus" nil :system t)
    ("<quo" "<quotedbl" nil :system t)
    ("<se" "<semicolon" nil :system t)
    ("<sp" "<space" nil :system t)
    ("<ex" "<exclam" nil :system t)
    ("<que" "<question" nil :system t)
    ("<un" "<underscore" nil :system t))
  "Abbrev table"
  :regexp "\\(<[a-zA-Z0-9_]+\\)"
  :case-fixed t)

;; See https://emacs.stackexchange.com/questions/51216/how-to-expand-abbrevs-without-hitting-another-extra-key
(defun xcompose-expand-abbrev ()
  "Run `expand-abbrev' when text before point matches `xcompose-key-re'"
  (when (looking-back xcompose-key-re (line-beginning-position))
    (expand-abbrev)))

;; Not really all that useful, since I can fill in the comment automatically
(defun xcompose-capitalize-comment nil
  "Set any trailing comment on the current line to all-caps."
  (interactive)
  (save-excursion
    (let* ((eol (progn (end-of-line) (point)))
           (bol (progn (beginning-of-line) (point))))
      (if (search-forward comment-start eol t)
          (upcase-region (point) eol)))))

(defun xcompose-find-quoted-char (&optional pos)
  "Find the character in quotes in the current line (or that given by pos)."
  (save-excursion
    (let* ((pos (or pos (point)))
           (chr nil)
           (eol (progn (end-of-line) (point)))
           (bol (progn (beginning-of-line) (point))))
      (if (search-forward ":" eol t)
          (progn
            (if (search-forward "\"" eol t)
                (setq chr (char-after)))))
      chr)))

;; If you can type the char but don't know its code (using C-x 8 RET is
;; great for this, if you know the character name)
(defun xcompose-fill-in-char-code (&optional pos)
  "Look up character in string on line given and fill in the UXXXX code at point."
  (interactive)
  (let* ((pos (or pos (point)))
         (chr (xcompose-find-quoted-char pos)))
    (goto-char pos)
    (insert (format "U%.04X" chr))))

;; Conversely, if you know the character code but for some reason can't
;; type it (C-x 8 RET not working for you?) you can do it the other way.
(defun xcompose-fill-in-char-string (&optional pos)
  "Look up character given by UXXXX code on line given and insert into string before it, separated by a space."
  ;; Probably needs some reformatting afterwards
  (interactive)
  (let* ((pos (or pos (point)))
         (eol (progn (end-of-line) (point)))
         (bol (progn (beginning-of-line) (point))))
    ;; search not necessarily as precise
    (if (search-forward-regexp "\\<U\\([[:xdigit:]]+\\)" eol)
        (let* ((hex (match-string 1))
               (num (string-to-number hex 16))
               (str (char-to-string num)))
          (goto-char (match-beginning 0))
          (insert (format "\"%s\" " str))))))

(defun xcompose-insert-char-name nil
  "Find the (first) quoted character on the line, and insert its name as
a comment at the end of the line."
  (interactive)
  (let* ((pos (point))
         (chr (xcompose-find-quoted-char pos)))
    (goto-char pos)
    (move-to-column (max (+ 4 (current-column)) comment-column) t)
    (insert (format "# %s" (get-char-code-property chr 'name)))))

(define-derived-mode xcompose-mode fundamental-mode "XCompose"
  "Major mode for .XCompose files
\\{xcompose-mode-map}"
  (font-lock-add-keywords nil xcompose-font-lock-keywords)
  ;; (setq-local comment-start "\\s-#")
  (setq-local comment-end "\n")
  (setq-local comment-continue " *")
  (setq-local comment-start-skip "/[*/]+[ \t]*")
  (setq-local comment-end-skip "[ \t]*\\(?:\n\\|\\*+/\\)")
  (setq-local font-lock-comment-face 'xcompose-comment-face)
  (add-hook 'post-self-insert-hook #'xcompose-expand-abbrev nil t)
  (auto-fill-mode 0)
  )
