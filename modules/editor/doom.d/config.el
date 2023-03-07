;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Fira Code" :size 24 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "Fira Code" :size 20))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-dracula)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :custom
  ;; (+lsp-company-backends '(company-tabnine :separate company-capf company-yasnippet)) ;; to enable Tab-nine autocomplete
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package direnv
 :config
 (direnv-mode))

(use-package lsp-mode
  :after (lsp direnv)
  :commands (lsp lsp-deferred)
  :config
  (lsp-enable-which-key-integration t)
  )

(after! lsp-mode
    (setq lsp-enable-symbol-highlighting nil)                   ;; 1
    (setq lsp-ui-doc-enable nil)                                ;; 2
    (setq lsp-ui-doc-show-with-cursor nil)
    (setq lsp-ui-doc-show-with-mouse nil)
    (setq lsp-lens-enable nil)                                  ;; 3
    (setq lsp-headerline-breadcrumb-segments
          '(path-up-to-project file symbols))
    (setq lsp-headerline-breadcrumb-enable nil)                 ;; 4
    (setq lsp-ui-sideline-enable t)                             ;; 5
    (setq lsp-ui-sideline-show-code-actions t)
    (setq lsp-ui-sideline-enable t)                             ;; 6
    (setq lsp-ui-sideline-show-hover t)
    (setq lsp-modeline-code-actions-enable t)                   ;; 7

    (setq lsp-diagnostics-provider :auto)                       ;; 8
    (setq lsp-ui-sideline-enable t)                             ;; 9
    (setq lsp-eldoc-enable-hover t)                             ;; 10
    (setq lsp-modeline-diagnostics-enable t)                    ;; 11

    (setq lsp-signature-auto-activate t)                        ;; 12
    (setq lsp-signature-render-documentation nil)               ;; 13

    (setq lsp-completion-provider :capf)                        ;; 14
    (setq lsp-completion-show-detail t)                         ;; 15
    (setq lsp-completion-show-kind t)                           ;; 16
  )

(use-package lsp-ui
  :after lsp
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom)
  )

(use-package lsp-treemacs
  :after lsp)

(setq lsp-clients-clangd-args '("--header-insertion=never"))

(use-package lsp-pyright
  :after lsp
  :ensure t
  :init
  (setq lsp-pyright-multi-root nil)
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp))))  ; or lsp-deferred

(use-package pyvenv
  :config
  (pyvenv-mode 1))

(setq projectile-project-search-path '("~/Projects"))
