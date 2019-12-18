;; Blah blah add headers here.
;; Playing with the notion of a major mode for .XCompose files.
;; Maybe eventually smart enough to keep columns lined up.
;; For now, settling for pretty colors.

(defface xcompose-angle-face
  '((t (:inherit font-lock-keyword-face)))
  "Face for the <>s"
  :group 'xcompose-mode)

(defface xcompose-keys-face
  '((t (:inherit font-lock-constant-face)))
  "Face for the key names"
  :group 'xcompose-mode)

(defface xcompose-string-face
  '((t (:inherit font-lock-string-face
                 :height 1.2
                 :box "black")))
  "Face for the strings.  Not straight font-lock-string-face in case I want
to make it big or something."
  :group 'xcompose-mode)
(defface xcompose-quotemark-face
  '((t (:inherit font-lock-string-face
                 :foreground "dark orchid")))
  "Face for quotes around strings"
  :group 'xcompose-mode)

(defface xcompose-num-face
  '((t (:inherit font-lock-preprocessor-face :weight bold)))
  "Face for the hex numbers"
  :group 'xcompose-mode)

(defface xcompose-U-face
  '((t (:inherit font-lock-preprocessor-face)))
  "Face for the U before the hex numbers"
  :group 'xcompose-mode)

(defface xcompose-colon-face
  '((t (:inherit bold)))
  "Face for the \":\"."
  :group 'xcompose-mode)


(defvar xcompose-mode-syntax-table
  (let ((st (make-syntax-table text-mode-syntax-table)))
    (modify-syntax-entry ?< "(>  " st)
    (modify-syntax-entry ?> ")<  " st)
    (modify-syntax-entry ?# "<   " st)
    (modify-syntax-entry ?_ "_   " st)
    (modify-syntax-entry ?\n ">   " st)
    st)
  "Syntax table for xcompose-mode")

(defvar xcompose-mode-map
  (let ((map (make-sparse-keymap)))
    ;; ADD BINDINGS
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
    (" #.*" . 'glyphless-char)
    ))

(define-derived-mode xcompose-mode text-mode "XCompose"
  "Major mode for .XCompose files"
  (font-lock-add-keywords nil xcompose-font-lock-keywords)
  (setq-local comment-start "#")
  (setq-local comment-end "\n")
  (setq-local comment-continue " *")
  (setq-local comment-start-skip "/[*/]+[ \t]*")
  (setq-local comment-end-skip "[ \t]*\\(?:\n\\|\\*+/\\)")
  ;; Bizarrely enough, this actually works.
  ;; But I think I might not want to use it.
  ;; (setq-local font-lock-comment-face
  ;;             '(:height 0.95 :inherit font-lock-comment-face))
  ;; But lighten the color a little, since there's so much comment text...
  (setq-local font-lock-comment-face
              '(:inherit font-lock-comment-face :foreground "light coral"))
  )

