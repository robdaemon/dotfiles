(add-to-list 'load-path "~/.emacs.d/local")

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

(use-package company
  :ensure t
  :config
  (global-company-mode)
  (add-to-list 'company-backends 'company-flow))

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package flycheck-clojure
  :ensure t
  :defer t
  :commands (flycheck-clojure-setup)               ;; autoload
  :config
  (eval-after-load 'flycheck
    '(setq flycheck-display-errors-function #'flycheck-pos-tip-error-messages))
  (add-hook 'after-init-hook #'global-flycheck-mode))

(use-package flycheck-pos-tip
  :ensure t
  :after flycheck)

(use-package cider
  :ensure t
  :defer t
  :config
  (add-hook 'clojure-mode-hook #'cider-mode)
  (flycheck-clojure-setup))

(use-package flycheck-flow
  :ensure t
  :config
  (flycheck-add-mode 'javascript-flow 'flow-minor-mode))

(use-package clj-refactor
  :ensure t
  :config
  (add-hook 'clojure-mode-hook #'clj-refactor-mode))

(use-package cljr-ivy
  :ensure t
  :bind (("C-c C-r" . cljr-ivy)))

;; (use-package js2-mode
;;   :ensure t
;;   :config
;;   (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
;;   (add-to-list 'auto-mode-alist '("\\.jsx?\\'" . js2-jsx-mode))
;;   (add-to-list 'interpreter-mode-alist '("node" . js2-jsx-mode)))

(use-package rjsx-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.js\\'" . rjsx-mode))
  )

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

;; always use auto-fill-mode when in text mode
;;   (stops emacs from line wrapping in makefiles !)
(add-hook 'text-mode-hook
	  '(lambda () (auto-fill-mode 1)))

;; auto load definitions

(defun prepend-to-auto-mode-alist (pair)
  "Add PAIR onto start of auto-mode-alist"
  (setq auto-mode-alist (cons pair auto-mode-alist)))

(prepend-to-auto-mode-alist ' ("\\.mod$" . gm2-mode))
(prepend-to-auto-mode-alist ' ("\\.def$" . gm2-mode))

(autoload 'gm2-mode "gm2-mode" "GNU Modula-2 mode")

(prepend-to-auto-mode-alist '("\\.v$" . verilog-mode))
(prepend-to-auto-mode-alist '("\\.sv$" . verilog-mode))
(autoload 'verilog-mode "verilog-mode" "Verilog Mode")

(prepend-to-auto-mode-alist '("\\.m3$" . modula-3-mode))
(prepend-to-auto-mode-alist '("\\.i3$" . modula-3-mode))
(require 'modula3)

(require 'gas-mode)
(add-to-list 'auto-mode-alist '("\\.S\\'" . gas-mode))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(custom-safe-themes
   (quote
    ("06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" default)))
 '(flycheck-javascript-flow-args nil)
 '(global-display-line-numbers-mode t)
 '(inhibit-startup-screen t)
 '(js-jsx-syntax t)
 '(package-selected-packages
   (quote
    (color-theme-sanityinc-tomorrow clj-refactor flycheck-clojure flycheck company cider clojure-mode projectile ivy use-package)))
 '(prettier-enabled-parsers
   (quote
    (babel-flow css json html scss toml typescript xml yaml)))
 '(prettier-infer-parser-flag t)
 '(safe-local-variable-values
   (quote
    ((js2-mode-show-strict-warnings)
     (js2-mode-show-parse-errors)
     (cljr-favor-prefix-notation . t)
     (eval progn
	   (put
	    (quote defendpoint)
	    (quote clojure-doc-string-elt)
	    3)
	   (put
	    (quote defendpoint-async)
	    (quote clojure-doc-string-elt)
	    3)
	   (put
	    (quote api/defendpoint)
	    (quote clojure-doc-string-elt)
	    3)
	   (put
	    (quote api/defendpoint-async)
	    (quote clojure-doc-string-elt)
	    3)
	   (put
	    (quote defsetting)
	    (quote clojure-doc-string-elt)
	    2)
	   (put
	    (quote setting/defsetting)
	    (quote clojure-doc-string-elt)
	    2)
	   (put
	    (quote s/defn)
	    (quote clojure-doc-string-elt)
	    2)
	   (put
	    (quote p\.types/defprotocol+)
	    (quote clojure-doc-string-elt)
	    2)
	   (define-clojure-indent
	     (let-404 1)
	     (match 1)
	     (merge-with 1)
	     (p\.types/defprotocol+
	      (quote
	       (1
		(:defn))))
	     (p\.types/def-abstract-type
	      (quote
	       (1
		(:defn))))
	     (p\.types/deftype+
	      (quote
	       (2 nil nil
		  (:defn))))
	     (p/def-map-type
	      (quote
	       (2 nil nil
		  (:defn))))
	     (p\.types/defrecord+
	      (quote
	       (2 nil nil
		  (:defn)))))))))
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
