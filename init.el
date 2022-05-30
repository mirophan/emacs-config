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
  :bind (("M-o" . ace-window)))

(use-package markdown-mode
  :ensure t)

(use-package xclip
  :ensure t
  :init
  (xclip-mode))

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
;; (global-linum-mode t)               ;; Enable line numbers globally (pre emacs v26)
(when (version<= "26.0.50" emacs-version )
  (global-display-line-numbers-mode))
(setq select-enable-clipboard t)
(delete-selection-mode 1)           ;; Typing/yanking will replace highlited text
(global-auto-revert-mode t)         ;; Refresh buffer whenever file changed (for git checkout)
(add-hook 'dired-mode-hook 'auto-revert-mode) ;; Refresh dired buffer when file changed
(setq dired-recursive-deletes 'always) ;; Single prompt when deleting recirsively in Dired
(setq dired-recursive-copies 'always) ;;  Single prompt when copying recirsively in Dired

;; ===================================
;; Shortcuts
;; ===================================
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-c r") 'query-replace)

;; Elpy customisation
;; Enhance elpy-goto-definition to run rgrep if failed
(defun goto-def-or-rgrep ()
  "Go to definition of thing at point or do an rgrep in project if that fails"
  (interactive)
  (condition-case nil (elpy-goto-definition)
    (error (elpy-rgrep-symbol (thing-at-point 'symbol)))))
(define-key elpy-mode-map (kbd "M-.") 'goto-def-or-rgrep)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ediff                                                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'ediff)
;; don't start another frame
;; this is done by default in preluse
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
;; put windows side by side
(setq ediff-split-window-function (quote split-window-horizontally))
;;revert windows on exit - needs winner mode
(winner-mode)
(add-hook 'ediff-after-quit-hook-internal 'winner-undo)


;; User-defined init.el ends here

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default))
 '(package-selected-packages '(elpy eply use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

