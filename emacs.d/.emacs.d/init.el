;; Package manager
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
 )

(package-initialize)

(setq load-path (cons "~/.emacs.d/vendor" load-path))

;; Disable graphical dialogs
(defadvice yes-or-no-p (around prevent-dialog activate)
  "Prevent yes-or-no-p from activating a dialog"
  (let ((use-dialog-box nil))
    ad-do-it)
)
(defadvice y-or-n-p (around prevent-dialog-yorn activate)
  "Prevent y-or-n-p from activating a dialog"
  (let ((use-dialog-box nil))
    ad-do-it))

;; powerline 
(add-to-list 'load-path "~/.emacs.d/vendor/emacs-powerline")
(require 'cl)
(require 'powerline)
(setq powerline-arrow-shape 'half)

;; Fixing auto-save
(setq auto-save-file-name-transforms '((".*"
           "/tmp/emacs-autosave/_" t)))
(setq auto-save-list-file-prefix "/tmp/emacs-autosave/.saves-")

(setq backup-directory-alist
        `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
        `((".*" ,temporary-file-directory t)))

;; Set font
;; (when (eq system-type 'darwin)
;;       (set-face-attribute 'default nil :family "Inconsolata")
;;       (set-face-attribute 'default nil :height 125)
;; )

(when (eq system-type 'darwin)
      (set-face-attribute 'default nil :family "Inconsolata")
      (set-face-attribute 'default nil :height 140)
)

;; General scripts
(add-to-list 'load-path' "~/.emacs.d/vendor")
(global-set-key (kbd "<f5>") #'redraw-display)

;; ace-jump-mode
(require 'ace-jump-mode)
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

;; Automatically hide compilation buffers
(require 'aj-compilation)

;; NVM
(require 'nvm)

;; Hide menu bar
(menu-bar-mode -1)
(toggle-scroll-bar -1) 
(tool-bar-mode -1)

;; IDO mode
(require 'ido)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)
(setq ido-use-filename-at-point 'guess)

;; top
(require 'top-mode)

;; aliases
(defalias 'ff 'find-file)
(defalias 'ffow 'find-file-other-window)

;; fiplr
(require 'fiplr)
(setq fiplr-ignored-globs '((directories (".git" ".svn" "node_modules" "dist"))
                            (files ("*.jpg" "*.png" "*.zip" "*~"))))
(global-set-key (kbd "C-x f") 'fiplr-find-file)
;; Flycheck
;(require 'flycheck)
;;(add-hook 'js-mode-hook
;;          (lambda () (flycheck-mode t)))
;(setq flycheck-check-syntax-automatically '(mode-enabled save))

;; Tab size
;;(setq tab-width 2) ; or any other preferred value
;;(defvaralias 'c-basic-offset 'tab-width)
;;(defvaralias 'cperl-indent-level 'tab-width)
(setq-default indent-tabs-mode nil)

;; auto complete
(require 'auto-complete)
(global-auto-complete-mode t)

;;(setq multi-term-program "ESHELL")

;; Eshell
(defun shortened-path (path max-len)
  "Return a modified version of `path', replacing some components
  with single characters starting from the left to try and get
  the path down to `max-len'"
  (let* ((components (split-string (abbreviate-file-name path) "/"))
         (len (+ (1- (length components))
                 (reduce '+ components :key 'length)))
         (str ""))
    (while (and (> len max-len)
                (cdr components))
      (setq str (concat str (if (= 0 (length (car components)))
                                "/"
                              (string (elt (car components) 0) ?/)))
            len (- len (1- (length (car components))))
            components (cdr components)))
    (concat str (reduce (lambda (a b) (concat a "/" b)) components))))

;; The function to set to prompt
(defun rjs-eshell-prompt-function ()
  (concat (shortened-path (eshell/pwd) 20)
          (if (= (user-uid) 0) " # " " $ ")))

(defun eshell/clear ()
  "To clear the eshell buffer."
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)))

(setq eshell-prompt-function (lambda nil
    (concat
;;     (propertize (eshell/pwd) 'face `(:foreground "#cc99cc"))
     (propertize (rjs-eshell-prompt-function) 'face `(:foreground "#cc99cc"))
     (propertize " " 'face `(:foreground "white")))))
  (setq eshell-highlight-prompt nil)

;; Enable mouse support
(unless window-system
  (require 'mouse)
  (xterm-mouse-mode t)
  (global-set-key [mouse-4] '(lambda ()
                              (interactive)
                              (scroll-down 1)))
  (global-set-key [mouse-5] '(lambda ()
                              (interactive)
                              (scroll-up 1)))
  (defun track-mouse (e))
  (setq mouse-sel-mode t)
)

;; Refresh all buffers on disk change
(global-auto-revert-mode t)

;; column marker
(require 'column-marker)
(add-hook 'js2-mode-hook (lambda () (interactive) (column-marker-1 80)))
(add-hook 'web-mode-hook (lambda () (interactive) (column-marker-1 80)))
;; Exec from path
(require 'exec-path-from-shell)
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; Dockerfile mode
(add-to-list 'load-path "~/.emacs.d/vendor/dockerfile-mode")
(require 'dockerfile-mode)
(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))

;; magit
(require 'magit)
(global-set-key (kbd "C-x g") 'magit-status)

;; linum+
(add-to-list 'load-path' "~/.emacs.d/linum+")
(require 'linum+)

;; Org mode
(add-to-list 'load-path' "~/.emacs.d/org/lisp")
(add-to-list 'load-path' "~/.emacs.d/org/contrib/lisp")

;; smartparens
;;(require 'smartparens-config)
;;(smartparens-global-mode t)


;; Python -- elpy
(require 'package)
(add-to-list 'package-archives
             '("elpy" . "http://jorgenschaefer.github.io/packages/"))
(package-initialize)
(elpy-enable)
(elpy-use-ipython)

;; Groovy mode
(require 'groovy-mode)

;; Sass mode
(require 'sass-mode)
(setq sass-indent-level 2)
(setq scss-compile-at-save nil)


;; Rainbow mode
(require 'rainbow-mode)

;; Javascript
(require 'js2-mode)
;; (require 'js2-refactor)

(add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))

;; Web mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[gj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.twig\\'" . web-mode))
;;(add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))
(setq web-indent-level 2)

;; Stack overflow
(add-to-list 'load-path' "~/.emacs.d/vendor/sos")
(require 'sos)

;; iedit
(require 'iedit)


(defun iedit-dwim (arg)
  "Starts iedit but uses \\[narrow-to-defun] to limit its scope."
  (interactive "P")
  (if arg
      (iedit-mode)
    (save-excursion
      (save-restriction
        (widen)
        ;; this function determines the scope of `iedit-start'.
        (if iedit-mode
            (iedit-done)
          ;; `current-word' can of course be replaced by other
          ;; functions.
          (narrow-to-defun)
          (iedit-start (current-word) (point-min) (point-max)))))))



(global-set-key (kbd "C-;") 'iedit-dwim)

;; jsx
(add-to-list 'auto-mode-alist '("\\.jsx$" . web-mode))
(defadvice web-mode-highlight-part (around tweak-jsx activate)
  (if (equal web-mode-content-type "jsx")
      (let ((web-mode-enable-part-face nil))
        ad-do-it)
    ad-do-it))

(require 'jsx-mode)
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . jsx-mode))

(add-hook 'jsx-mode-hook
          (lambda () (auto-complete-mode 1)))
(setq jsx-indent-level 2)

;; Jsx flycheck
(require 'flycheck)
(flycheck-define-checker jsxhint-checker
  "A JSX syntax and style checker based on JSXHint."

  :command ("jsxhint" source)
  :error-patterns
  ((error line-start (1+ nonl) ": line " line ", col " column ", " (message) line-end))
  :modes (jsx-mode))
(add-hook 'jsx-mode-hook (lambda ()
                          (flycheck-select-checker 'jsxhint-checker)
                          (flycheck-mode)))


 
;; Markdown mode
(add-to-list 'load-path' "~/.emacs.d/markdown-mode")
(require 'markdown-mode)
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; Add themes
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

(add-to-list 'load-path "~/.emacs.d/themes/")
(load-theme 'base16-eighties t)
;;(load-theme 'tomorrow-night-eighties t)

;; Disable bold fonts
(set-face-bold-p 'bold nil)


;; Buffer move
(require 'buffer-move)
(global-set-key (kbd "<C-S-up>")     'buf-move-up)
(global-set-key (kbd "<C-S-down>")   'buf-move-down)
(global-set-key (kbd "<C-S-left>")   'buf-move-left)
(global-set-key (kbd "<C-S-right>")  'buf-move-right)

;; Apps
;; Hacker news
(require 'hackernews)

;; Twitter
(require 'twittering-mode)
(setq twittering-use-master-password t)

;; Elfeed feeds
(setq elfeed-feeds
      '("http://feeds.feedburner.com/2ality"))
 ;;       ""))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("d1f2da6cd8f215e7110e478e6b9fedeffcf2eb8bfaa2dec0a444782a32a969d3" "3a727bdc09a7a141e58925258b6e873c65ccf393b2240c51553098ca93957723" "b21bf64c01dc3a34bc56fff9310d2382aa47ba6bc3e0f4a7f5af857cd03a7ef7" "6a37be365d1d95fad2f4d185e51928c789ef7a4ccf17e7ca13ad63a8bf5b922f" "756597b162f1be60a12dbd52bab71d40d6a2845a3e3c2584c6573ee9c332a66e" "7bde52fdac7ac54d00f3d4c559f2f7aa899311655e7eb20ec5491f3b5c533fe8" "1e194b1010c026b1401146e24a85e4b7c545276845fc38b8c4b371c8338172ad" "943bff6eada8e1796f8192a7124c1129d6ff9fbd1a0aed7b57ad2bf14201fdd4" default)))
 '(elfeed-feeds (quote ("http://feeds.feedburner.com/theendeavour")) t)
 '(sml/mode-width
   (if
       (eq powerline-default-separator
	   (quote arrow))
       (quote right)
     (quote full)))
 '(sml/pos-id-separator
   (quote
    (""
     (:propertize " " face powerline-active1)
     (:eval
      (propertize " "
		  (quote display)
		  (funcall
		   (intern
		    (format "powerline-%s-%s" powerline-default-separator
			    (car powerline-default-separator-dir)))
		   (quote powerline-active1)
		   (quote powerline-active2))))
     (:propertize " " face powerline-active2))))
 '(sml/pos-minor-modes-separator
   (quote
    (""
     (:propertize " " face powerline-active1)
     (:eval
      (propertize " "
		  (quote display)
		  (funcall
		   (intern
		    (format "powerline-%s-%s" powerline-default-separator
			    (cdr powerline-default-separator-dir)))
		   (quote powerline-active1)
		   nil)))
     (:propertize " " face sml/global))))
 '(sml/pre-id-separator
   (quote
    (""
     (:propertize " " face sml/global)
     (:eval
      (propertize " "
		  (quote display)
		  (funcall
		   (intern
		    (format "powerline-%s-%s" powerline-default-separator
			    (car powerline-default-separator-dir)))
		   nil
		   (quote powerline-active1))))
     (:propertize " " face powerline-active1))))
 '(sml/pre-minor-modes-separator
   (quote
    (""
     (:propertize " " face powerline-active2)
     (:eval
      (propertize " "
		  (quote display)
		  (funcall
		   (intern
		    (format "powerline-%s-%s" powerline-default-separator
			    (cdr powerline-default-separator-dir)))
		   (quote powerline-active2)
		   (quote powerline-active1))))
     (:propertize " " face powerline-active1))))
 '(sml/pre-modes-separator (propertize " " (quote face) (quote sml/modes))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background nil)))))


;; Transparency
;;(set-frame-parameter (selected-frame) 'alpha '(<active> [<inactive>]))
 (set-frame-parameter (selected-frame) 'alpha '(95 95))
 (add-to-list 'default-frame-alist '(alpha 95 95))

;; Hex colors
(defun xah-syntax-color-hex ()
"Syntax color hex color spec such as 「#ff1100」 in current buffer."
  (interactive)
  (font-lock-add-keywords
   nil
   '(("#[abcdefABCDEF[:digit:]]\\{6\\}"
      (0 (put-text-property
          (match-beginning 0)
          (match-end 0)
          'face (list :background (match-string-no-properties 0)))))))
  (font-lock-fontify-buffer)
  )

(add-hook 'css-mode-hook 'xah-syntax-color-hex)
(add-hook 'sass-mode-hook 'xah-syntax-color-hex)
(add-hook 'scss-mode-hook 'xah-syntax-color-hex)
(add-hook 'php-mode-hook 'xah-syntax-color-hex)
(add-hook 'html-mode-hook 'xah-syntax-color-hex)
(add-hook 'js-mode-hook 'xah-syntax-color-hex)
(add-hook 'js2-mode-hook 'xah-syntax-color-hex)


;; power line
(set-face-attribute 'mode-line nil
                    :foreground "Black"
                    :background "#99cc99"
                    :box nil)

(setq powerline-color1 "grey10")
(setq powerline-color2 "grey22")


;; Indentation from
;; http://blog.binchen.org/posts/easy-indentation-setup-in-emacs-for-web-development.html
(defun my-setup-indent (n)
  ;; web development
  (setq coffee-tab-width n) ; coffeescript
  (setq javascript-indent-level n) ; javascript-mode
  (setq js-indent-level n) ; js-mode
  (setq js2-basic-offset n) ; js2-mode
  (setq web-mode-markup-indent-offset n) ; web-mode, html tag in html file
  (setq web-mode-css-indent-offset n) ; web-mode, css in html file
  (setq web-mode-code-indent-offset n) ; web-mode, js code in html file
  (setq css-indent-offset n) ; css-mode
  )

(defun my-office-code-style ()
  (interactive)
  (message "Office code style!")
  (setq indent-tabs-mode t) ; use tab instead of space
  (my-setup-indent 4) ; indent 4 spaces width
  )

(defun my-personal-code-style ()
  (interactive)
  (message "Indentation set to two")
  (setq indent-tabs-mode nil) ; use space instead of tab
  (my-setup-indent 2) ; indent 2 spaces width
  )

;; call indentation
(my-personal-code-style)

;; Start emacs
(server-start)

;; Turn off bell
(setq ring-bell-function 'ignore)


;; Require EVIL
(add-to-list 'load-path' "~/.emacs.d/evil")
(require 'evil)
(evil-mode 1)
(evil-set-initial-state 'eshell 'insert)

(setq initial-buffer-choice "~/todo.org") 
(add-to-list 'default-frame-alist '(font .  "ProggyCleanTT-12" ))

(set-face-bold-p 'bold nil)

(set-frame-parameter (selected-frame) 'alpha '(90 75))
(add-to-list 'default-frame-alist '(alpha 90 75))
