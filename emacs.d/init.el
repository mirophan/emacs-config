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

(use-package modus-themes
  :ensure t ;; Ensure the package is installed
  :init
  ;; Optional: Customize theme settings before loading
  (setq modus-themes-bold-constructs t
        modus-themes-italic-constructs nil
        modus-themes-region '(bg-only))
  :config
  ;; Load the modus-vivendi theme
  (load-theme 'modus-vivendi-tinted t))

(use-package ace-window
  :ensure t
  :bind (("M-o" . ace-window)))

(use-package markdown-mode
  :ensure t)

(use-package sql
  :ensure t
  :hook (sql-mode . my-sql-mode-setup) ; Add setup function to sql-mode
  :config
  (defun my-sql-mode-setup ()
    "Set up custom configurations for sql-mode."
    ;; Keybinding for running SQLFluff
    (local-set-key (kbd "C-c C-l") 'run-sqlfluff-fix-on-buffer)))


;; make sure to also run sudo apt install xclip
(use-package xclip
  :ensure t
  :init
  (xclip-mode))

(use-package clipetty
  :ensure t
  :hook
  (after-init . global-clipetty-mode))

(use-package csv-mode
  :ensure t
  :config
  (add-hook 'csv-mode-hook 'csv-align-mode))

;; ===================================
;; Python IDE setup
;; ===================================
(use-package elpy
  :ensure t
  :init
  (elpy-enable)
  :config
  (setq python-shell-completion-native-enable nil))

(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode))

(use-package blacken
  :ensure t
  :hook (python-mode . blacken-mode)
  :custom
  (blacken-line-length 79))  ;; Adjust line length as needed

;; Enable Mamba support
(use-package conda
  :ensure t
  :config
  (conda-env-initialize-interactive-shells)
  :custom
  (conda-anaconda-home "~/miniforge3")
  (conda-env-home-directory "~/miniforge3"))


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
(setq dired-dwim-target t) ;; dired move / copy files to other split by default (total cmdr style)
(setq dired-listing-switches "-alFh")
(setq initial-scratch-message nil) ;; scratch buffer will start with no text

;; ===================================
;; Shortcuts
;; ===================================
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-c r") 'query-replace)


;; ===================================
;; Backup configuration
;; ===================================
(setq version-control t     ;; Use version numbers for backups.
      kept-new-versions 10  ;; Number of newest versions to keep.
      kept-old-versions 2   ;; Number of oldest versions to keep.
      delete-old-versions t ;; Don't ask to delete excess backup versions.
      backup-by-copying t   ;; Copy all files, don't rename them.
      version-control t     ;; version numbers for backup files
      vc-make-backup-files t) ;; backup versioned files

;; Default and per-save backups go here:
(setq backup-directory-alist '(("" . "~/.emacs.d/backup/per-save")))

(defun force-backup-of-buffer ()
  ;; Make a special "per session" backup at the first save of each
  ;; emacs session.
  (when (not buffer-backed-up)
    ;; Override the default parameters for per-session backups.
    (let ((backup-directory-alist '(("" . "~/.emacs.d/backup/per-session")))
          (kept-new-versions 3))
      (backup-buffer)))
  ;; Make a "per save" backup on each save.  The first save results in
  ;; both a per-session and a per-save backup, to keep the numbering
  ;; of per-save backups consistent.
  (let ((buffer-backed-up nil))
    (backup-buffer)))

(add-hook 'before-save-hook  'force-backup-of-buffer)


(defun run-sqlfluff-fix-on-buffer ()
  "Run SQLFluff fix on the current buffer."
  (interactive)
  (let ((output-buffer (get-buffer-create "*SQLFluff Output*")))
    ;; Clear the output buffer
    (with-current-buffer output-buffer
      (erase-buffer))
    ;; Run SQLFluff fix
    (let ((exit-code (call-process-region (point-min) (point-max)
                                          "sqlfluff" nil output-buffer nil
                                          "fix" "--dialect" "snowflake" "-")))
      (if (zerop exit-code)
          (message "SQLFluff: Fix applied successfully!")
        (message "SQLFluff: Issues fixed partially or failed, check *SQLFluff Output* buffer."))
      ;; Display the output buffer
      (display-buffer output-buffer))))



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
 '(package-selected-packages '(eply use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

