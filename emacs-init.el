(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

(set-frame-font "JetBrains Mono 14" t)

(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

(require 'package)
(add-to-list 'package-archives '("gnu"   . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))


;; set environment vars
(defun prepend-directory-to-path (dir)
  "Prepend DIR to the PATH environment variable and Emacs exec-path."
  (setenv "PATH" (concat dir path-separator (getenv "PATH")))
  (add-to-list 'exec-path dir))

;; Example usage:
(prepend-directory-to-path "/home/suywh0/go/bin/")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("f253a920e076213277eb4cbbdf3ef2062e018016018a941df6931b995c6ff6f6" "ebdaa6f5ec2f4c5afb361d785d7c49374c4f0d0c0512132bc87f1372ffd9f506" "aec7b55f2a13307a55517fdf08438863d694550565dee23181d2ebd973ebd6b8" "e8ceeba381ba723b59a9abc4961f41583112fc7dc0e886d9fc36fa1dc37b4079" "93011fe35859772a6766df8a4be817add8bfe105246173206478a0706f88b33d" "9b9d7a851a8e26f294e778e02c8df25c8a3b15170e6f9fd6965ac5f2544ef2a9" "183bfd1efb07b9001c90e76f30241975ab067bc971d2567276cd1e6867ca58d3" default))
 '(package-selected-packages
   '(automoji emojify chemtable cherry-blossom-theme python-black python-mode evil hackernews magit go-mode company company-mode doom-themes darkokai-theme helm vterm-toggle org-superstar lsp-mode lsp-pyright ruff-format)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Keybinds
(bind-key (kbd"M-x") 'helm-M-x)
(bind-key (kbd "C-x C-b") 'helm-buffers-list)
(bind-key (kbd "C-c t") 'vterm-toggle)
(bind-key (kbd "C-c C-t") 'vterm)

(load-theme 'cherry-blossom)
;; extra packages
(use-package electric-pair-mode
  :hook prog-mode
  )

(use-package go-mode
  :ensure t
  :hook (go-mode-hook . go-mode))

(use-package python-mode
  :ensure t
  :hook (python-mode-hook . python-mode))

(use-package lsp-mode
  :ensure t
  :hook (
	 (go-mode-hook . lsp-deferred)
;;	 (python-mode-hook . lsp-deferred)
  ))


(use-package company
  :ensure t
  :hook (
	 (go-mode-hook . company-mode)
;;	 (python-mode-hook . company-mode)
	 ))

(use-package lsp-pyright
  :ensure t
  :custom (lsp-pyright-langserver-command "pyright") ;; or basedpyright
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp))))  ; or lsp-deferred


(use-package python-black
  :ensure t
  :hook (python-mode . python-black-on-save-mode))

(use-package emojify
  :ensure t
  :hook (after-init . global-emojify-mode))


(use-package automoji
  :ensure t
;;   :straight (:host github :repo "Dev380/automoji-el" :files ("*.el*" "generated.data"))
  :config
  (add-hook 'completion-at-point-functions #'automoji-capf))



(require 'lsp-mode)
(add-hook 'go-mode-hook #'lsp-deferred)

(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)



;; spacemacs dashboard config
(require 'dashboard)
(dashboard-setup-startup-hook)
;; custom function to get random banner gif on every run
(setq banner-files '("/home/suywh0/.emacs.d/banners/justaken.gif", "/home/suywh0/.emacs.d/banners/whocool.gif", "/home/suywh0/.emacs.d/banners/soph.gif", "/home/suywh0/.emacs.d/banners/doingood.gif"))

(defun get-random-banner()
  (seq-random-elt banner-files)
  )

;; Set the title
(setq dashboard-banner-logo-title "Welcome suywh0!")
;; Set the banner
;; (setq dashboard-startup-banner "/home/suywh0/.emacs.d/justaken.gif") ;; uncomment for adding a dashboard banner value
(setq dashboard-startup-banner (get-random-banner))
;; Value can be:
;;  - 'official which displays the official emacs logo.
;;  - 'logo which displays an alternative emacs logo.
;;  - an integer which displays one of the text banners
;;    (see dashboard-banners-directory files).
;;  - a string that specifies a path for a custom banner
;;    currently supported types are gif/image/text/xbm.
;;  - a cons of 2 strings which specifies the path of an image to use
;;    and other path of a text file to use if image isn't supported.
;;    (cons "path/to/image/file/image.png" "path/to/text/file/text.txt").
;;  - a list that can display an random banner,
;;    supported values are: string (filepath), 'official, 'logo and integers.

;; Content is not centered by default. To center, set
(setq dashboard-center-content t)
;; vertically center content
(setq dashboard-vertically-center-content t)

;; To disable shortcut "jump" indicators for each section, set
;; (setq dashboard-show-shortcuts nil)
;; (put 'downcase-region 'disabled nil)

;; (require 'evil)
;; (evil-mode 1)
