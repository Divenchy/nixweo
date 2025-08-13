(use-package dogears
  :init (dogears-mode)
  :bind (("M-g d" . dogears-go)
         ("M-g M-b" . dogears-back)
         ("M-g M-f" . dogears-forward)))

;; Treemacs
(use-package treemacs)
(define-key leader (kbd "e") #'treemacs)

;; MAGIT ;;
(use-package magit
  :commands (magit-status magit-get-current-branch)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)) ;; Makes Magit appear in the same window instead of a new window

;; Projectile ;;

;; revert-buffer or eval dir var for projectile run cmd
;; this is set using dir file (C-c p E)
(use-package projectile
  :diminish projectile-mode
  :config
  (projectile-mode)
  (setq projectile-auto-discover t)
  (projectile-discover-projects-in-search-path)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/Projects/")
    (setq projectile-project-search-path '("~/Projects/")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))
