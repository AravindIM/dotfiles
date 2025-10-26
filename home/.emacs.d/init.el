;; AIM's Emacs Config

;; Start the server
;;(server-start)

;; Variables
(setq warning-minimum-level :emergency)

;; Shell Mode Exit Hook
(defun set-no-process-query-on-exit ()
  (let ((proc (get-buffer-process (current-buffer))))
    (when (processp proc)
      (set-process-query-on-exit-flag proc nil))))

(add-hook 'shell-mode-hook 'set-no-process-query-on-exit)


;; Simple toggles
(setq inhibit-startup-message t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(menu-bar-mode -1)
(setq visible-bell t)
(column-number-mode)
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode t)


(dolist (mode '(org-mode-hook
		term-mode-hook
		vterm-mode-hook
		shell-mode-hook
		treemacs-mode-hook
		eshell-mode-hook))
	      (add-hook mode (lambda () (display-line-numbers-mode 0))))


;; Fonts
(set-face-attribute 'default nil :font "FiraCode Nerd Font 12")

(set-face-attribute 'variable-pitch nil :font "FiraCode Nerd Font 12")


;; Quit prompts with ESC key
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "C-x <escape>") 'keyboard-escape-quit)
(global-set-key (kbd "C-c <escape>") 'keyboard-escape-quit)


;; Package Manager
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)


;; Packages

;; No littering package
(setq user-emacs-directory "~/.cache/emacs")

(use-package no-littering)

(setq auto-save-file-name-transforms
      `((".*", (no-littering-expand-var-file-name "auto-save/") t)))


;; Evil package
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))


;; Evil Collection package
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))


;; General package
(use-package general
  :after evil
  :config
  (general-create-definer emacs/leader-key-def
		  :keymaps '(normal insert visual emacs)
		  :prefix "SPC"
		  :global-prefix "C-SPC")
  (emacs/leader-key-def
   "ff" 'find-file
   "." 'find-file
   "fs" 'save-buffer
   "fe" 'dired
   "p" '(:keymap projectile-command-map :package projectile)
   "bb" 'switch-to-buffer
   "bk" 'kill-current-buffer))

;; Rainbow Delimiters package
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))


;; Term package
(use-package term
  :commands term
  :config
  (setq explicit-shell-file-name "bash")
  :init
  (add-hook 'term-mode-hook 'set-no-process-query-on-exit))


;; Vterm package
(use-package vterm
  :commands vterm
  :config
  (setq vterm-max-scrollback 10000)
  :init
  (add-hook 'vterm-mode-hook 'set-no-process-query-on-exit))


;; Doom Themes package
(use-package doom-themes
  :init (load-theme 'doom-monokai-pro t))


;; All the icons package
(use-package all-the-icons
  :ensure t)


;; Doom Modeline package
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom
  (setq doom-modeline-height 15)
  (setq doom-modeline-icon t)
  (setq doom-modeline-major-mode-icon t)
  (setq doom-modeline-buffer-file-name-style 'truncate-except-project))


;; Which key package
(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 1))


;; Vertico package
(use-package vertico
  :init
  (vertico-mode))


;; Savehist package for Vertico
(use-package savehist
  :init
  (savehist-mode))


;; Vertico configs
(use-package emacs
  :init
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
		  (replace-regexp-in-string
		   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
		   crm-seperator)
		  car (args))
	  (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  (setq minibuffer-prompt-properties
	'(read-only t cursor-intangible t face minibuffer-prompt))

  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  (setq enable-recursive-minibuffers t))


;; Orderless package for Vertico
(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
	completion-category-defaults nil
	completion-category-overrides '((file (styles partial-completion)))))


;; Marginalia package for Vertico
(use-package marginalia
  :bind (("M-A" . marginalia-cycle)
	 :map minibuffer-local-map
	 ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))


;; Vertico completion configs
(setq completion-styles '(substring orderless basic))


;; Helpful Package
(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :bind
  ([remap describe-function] . helpful-callable)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-key] . helpful-key))


;; Dirvish package

(use-package dirvish
  :init
  (dirvish-override-dired-mode)
  :config
  ;; (dirvish-peek-mode) ; Preview files in minibuffer
  ;; (dirvish-side-follow-mode) ; similar to `treemacs-follow-mode'
  (setq dirvish-mode-line-format
        '(:left (sort symlink) :right (omit yank index)))
  (setq dirvish-attributes
        '(all-the-icons file-time file-size collapse subtree-state vc-state git-msg))
  (setq delete-by-moving-to-trash t)
  (setq dired-listing-switches
        "-l --almost-all --human-readable --group-directories-first --no-group"))

;; LSP package

(defun emacs/lsp-moden-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook
  (lsp-mode . emacs/lsp-mode-setup)
  (lsp-mode . lsp-enable-which-key-integration)
  (prog-mode . lsp)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (lsp-enable-which-key-integration t))


(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))


;; DAP Package
(use-package dap-mode
  :commands dap-debug
  :config
  (require 'dap-node)
  (dap-node-setup))


;; Web mode package
(use-package web-mode
  :ensure t)

;; Mustache mode package
(use-package mustache-mode
  :ensure t)

;; CSS package
(use-package css-mode
  :init
  (setq css-indent-offset 2))

;; Smart parens package
(use-package smartparens
  :init (add-hook 'css-mode-hook 'smartparens-mode))


;; Javascript mode package
(use-package js2-mode
  :ensure t
  :init
  (setq js-indent-level 2)
  (setq-default js2-indent-level 2
		js2-basic-offset 2
		js2-auto-indent-p t
		js2-cleanup-whitespace t
		js2-enter-indents-newline t
		js2-enter-on-enter-key t
		js2-global-externs (list "window" "module" "require" "buster" "sinon" "assert" "refute" "setTimeout" "clearTimeout" "setInterval"  "clearInterval" "location" "__dirname" "console" "JSON" "jQuery" "$"))
  (add-hook 'js2-mode-hook
	    (lambda ()
	      (push '("function" . ?f) prettify-symbols-alist)))
  (add-hook 'js2-mode-hook
	    (lambda () (flycheck-select-checker "javascript-eslint")))
  (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode)))


;; Javascript Refactor package
(use-package js2-refactor
  :ensure t
  :init (add-hook 'js2-mode-hook 'js2-refactor-mode)
  :config (js2r-add-keybindings-with-prefix "C-c C-r"))

;; Javascript X Reference package
(use-package xref-js2
  :ensure t)

;; Rjsx mode package
(use-package rjsx-mode)

;; Docker mode package
(use-package dockerfile-mode)

(use-package yaml-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
  (add-hook 'yaml-mode-hook
      (lambda ()
        (define-key yaml-mode-map "\C-m" 'newline-and-indent))))

;; Java mode package
;; (use-package lsp-java)

;; Flutter Support
(use-package lsp-dart
  :custom
  (lsp-dart-sdk-dir "~/.local/share/flutter/")
  (lsp-dart-flutter-sdk-dir "~/.local/share/flutter/"))

(use-package dart-mode
  :hook (dart-mode . flutter-test-mode))

(use-package flutter
  :after dart-mode
  :bind (:map dart-mode-map
              ("C-M-x" . #'flutter-run-or-hot-reload))
  :custom
  (flutter-sdk-path "~/.local/share/flutter/"))

;; Company mode package
(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind
  (:map company-active-map
	      ("<tab>" . company-complete-selection))
  (:map lsp-mode-map
	("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))


;; Projectile package
(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/Projects")
    (setq projectile-project-search-path '("~/Projects")))
  (setq projectile-switch-project-action #'projectile-dired))


;; Magit
(use-package magit
  :commands magit-status
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; Git gutter
(use-package git-gutter
  :init
  (global-git-gutter-mode t))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("5f128efd37c6a87cd4ad8e8b7f2afaba425425524a68133ac0efd87291d05874" "00cec71d41047ebabeb310a325c365d5bc4b7fab0a681a2a108d32fb161b4006" "be84a2e5c70f991051d4aaf0f049fa11c172e5d784727e0b525565bb1533ec78" "56044c5a9cc45b6ec45c0eb28df100d3f0a576f18eef33ff8ff5d32bac2d9700" "443e2c3c4dd44510f0ea8247b438e834188dc1c6fb80785d83ad3628eadf9294" "f5f80dd6588e59cfc3ce2f11568ff8296717a938edd448a947f9823a4e282b66" "e4a702e262c3e3501dfe25091621fe12cd63c7845221687e36a79e17cf3a67e0" "88f7ee5594021c60a4a6a1c275614103de8c1435d6d08cc58882f920e0cec65e" "aec7b55f2a13307a55517fdf08438863d694550565dee23181d2ebd973ebd6b8" default))
 '(package-selected-packages
   '(git-gutter dirvish lsp-dart magit projectile company-box company yaml-mode dockerfile-mode rjsx-mode xref-js2 js2-refactor js2-mode smartparens mustache-mode web-mode dap-mode lsp-ui lsp-mode helpful marginalia orderless vertico which-key doom-modeline all-the-icons doom-themes vterm rainbow-delimiters general evil-collection evil no-littering)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
