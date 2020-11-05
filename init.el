;; .emacs.d/init.el

;; ===================================
;; MELPA Package Support
;; ===================================
;; Enables basic packaging support
(require 'package)
(package-initialize)
;; Adds the Melpa archive to the list of available repositories
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

;; ensure use-package is installed if not present
(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))

(use-package spacemacs-common
  :ensure spacemacs-theme
  :config (load-theme 'spacemacs-dark t))

(use-package ace-window
  :ensure t
  :bind (("M-p" . ace-window)))

(use-package markdown-mode
  :ensure t)

;; ===================================
;; Python IDE setup
;; ===================================
(use-package elpy
  :ensure t
  :config
  (elpy-enable))

(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode))

(use-package py-autopep8
  :ensure t
  :config
  (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save))


;; ===================================
;; LaTeX
;; ===================================
(use-package auctex
  :defer t
  :ensure t
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq TeX-PDF-mode t))

;; ===================================
;; Basic Customization
;; ===================================
(setq inhibit-startup-message t)    ;; Hide the startup message
(global-linum-mode t)               ;; Enable line numbers globally
(delete-selection-mode 1)           ;; Typing/yanking will replace highlited text
(global-auto-revert-mode t)         ;; Refresh buffer whenever file changed (for git checkout)
;; Elpy customisatino
;; Enhance elpy-goto-definition to run rgrep if failed
(defun goto-def-or-rgrep ()
  "Go to definition of thing at point or do an rgrep in project if that fails"
  (interactive)
  (condition-case nil (elpy-goto-definition)
    (error (elpy-rgrep-symbol (thing-at-point 'symbol)))))
(define-key elpy-mode-map (kbd "M-.") 'goto-def-or-rgrep)



;; User-defined init.el ends here

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default)))
 '(package-selected-packages (quote (elpy eply use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

