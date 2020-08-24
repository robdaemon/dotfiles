(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile (require 'use-package))

(use-package use-package
  :config
  (setq use-package-always-ensure t))

(use-package ivy
  :ensure t
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t))

(use-package swiper
  :ensure t)

(use-package counsel
  :ensure t
  :config
  (setq search-default-mode #'char-fold-to-regexp)
  (global-set-key "\C-s" 'swiper)
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  (global-set-key (kbd "<f1> f") 'counsel-describe-function)
  (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
  (global-set-key (kbd "<f1> o") 'counsel-describe-symbol)
  (global-set-key (kbd "<f1> l") 'counsel-find-library)
  (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
  (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
  (global-set-key (kbd "C-c g") 'counsel-git)
  (global-set-key (kbd "C-c j") 'counsel-git-grep)
  (global-set-key (kbd "C-c k") 'counsel-ag)
  (global-set-key (kbd "C-x l") 'counsel-locate)
  (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
  (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history))

(use-package projectile
  :config
  (projectile-global-mode t)
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (setq projectile-completion-system 'ivy))

(use-package clojure-mode
  :ensure t)

(use-package cider
  :ensure t
  :config
  (add-hook 'clojure-mode-hook #'cider-mode))

(use-package company
  :ensure t
  :config
  (global-company-mode))

(use-package flycheck
  :ensure t)

(use-package flycheck-clojure
  :ensure t
  :config
  (flycheck-clojure-setup))

(use-package clj-refactor
  :ensure t
  :config
  (add-hook 'clojure-mode-hook #'clj-refactor-mode))

(use-package cljr-ivy
  :ensure t
  :bind (("C-c C-r" . cljr-ivy)))

(use-package js2-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
  (add-to-list 'auto-mode-alist '("\\.jsx?\\'" . js2-jsx-mode))
  (add-to-list 'interpreter-mode-alist '("node" . js2-jsx-mode)))

(use-package prettier
  :ensure t
  :config
  (add-hook 'js2-mode-hook #'prettier-mode))

(use-package flow-js2-mode
  :ensure t
  :config
  (add-hook 'js2-mode-hook #'flow-js2-mode))

(use-package rainbow-delimiters
  :ensure t
  :config
  (defvar on-mode-hooks
  '(emacs-lisp-mode-hook python-mode-hook js2-mode-hook shell-mode-hook shell-script-mode-hook sh-mode cider-repl-mode-hook))
  (defun enable-rainbow-delimiters (mode-hook)
    "Enable rainbow delimiters in MODE-HOOK."
    (add-hook mode-hook #'rainbow-delimiters-mode))
  (mapc 'enable-rainbow-delimiters on-mode-hooks))

(use-package smartparens
  :ensure t
  :init
  (require 'smartparens-config)
  (show-smartparens-global-mode t)
  (smartparens-global-mode t)
  (smartparens-global-strict-mode t)
  (sp-use-smartparens-bindings)
  (sp-with-modes '(minibuffer-inactive-mode cider-repl-mode clojure-mode emacs-lisp-mode)
    (sp-local-pair "'" nil :actions nil))
  :config
  :delight smartparens-mode
  :bind (("M-(" . sp-wrap-round)
	 ("M-[" . sp-wrap-square)
	 ("M-{" . sp-wrap-curly)))

(use-package yasnippet
  :ensure t
  :config
  (add-hook 'clojure-mode-hook #'yas-minor-mode))

(use-package clojure-snippets
  :ensure t)

(use-package yaml-mode
  :ensure t
  :config
  (add-hook 'yaml-mode-hook
	    (lambda ()
	      (define-key yaml-mode-map "\C-m" 'newline-and-indent))))

(use-package indent-tools
  :ensure t
  :config
  (global-set-key (kbd "C-c >") 'indent-tools-hydra/body))

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(custom-safe-themes
   '("06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" default))
 '(global-display-line-numbers-mode t)
 '(inhibit-startup-screen t)
 '(package-selected-packages
   '(color-theme-sanityinc-tomorrow clj-refactor flycheck-clojure flycheck company cider clojure-mode projectile ivy use-package))
 '(safe-local-variable-values
   '((js2-mode-show-strict-warnings)
     (js2-mode-show-parse-errors)
     (eval add-to-list
	   (make-local-variable 'clojure-align-cond-forms)
	   "are+")
     (cljr-favor-prefix-notation . t)
     (eval progn
	   (put 'defendpoint 'clojure-doc-string-elt 3)
	   (put 'defendpoint-async 'clojure-doc-string-elt 3)
	   (put 'api/defendpoint 'clojure-doc-string-elt 3)
	   (put 'api/defendpoint-async 'clojure-doc-string-elt 3)
	   (put 'defsetting 'clojure-doc-string-elt 2)
	   (put 'setting/defsetting 'clojure-doc-string-elt 2)
	   (put 's/defn 'clojure-doc-string-elt 2)
	   (put 'p\.types/defprotocol+ 'clojure-doc-string-elt 2)
	   (define-clojure-indent
	     (let-404 1)
	     (match 1)
	     (merge-with 1)
	     (p\.types/defprotocol+
	      '(1
		(:defn)))
	     (p\.types/def-abstract-type
	      '(1
		(:defn)))
	     (p\.types/deftype+
	      '(2 nil nil
		  (:defn)))
	     (p/def-map-type
	      '(2 nil nil
		  (:defn)))
	     (p\.types/defrecord+
	      '(2 nil nil
		  (:defn)))))))
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Noto Mono" :foundry "GOOG" :slant normal :weight normal :height 120 :width normal)))))

(use-package color-theme-sanityinc-tomorrow
  :ensure t
  :config
  (load-theme 'sanityinc-tomorrow-night))
(put 'upcase-region 'disabled nil)
