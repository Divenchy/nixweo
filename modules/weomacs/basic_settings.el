;; UI and STUFFZ ;;

(setq inhibit-startup-message t) ;; Disable landing page

(doom-modeline-mode 1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10) ;; Give breathing room
(menu-bar-mode -1)
(repeat-mode 1)
(setq bookmark-save-flag 1)
(setq default-directory (concat (getenv "HOME") "/"))

;; Fonts
(set-face-attribute 'default nil :font "Iosevka NF" :height 180)
(set-frame-font "Iosevka NF 18" nil t)

;; Eshell Path
(setq eshell-directory-name (expand-file-name "~/.emacs.d/eshell/"))
(setq eshell-default-directory (expand-file-name "~/"))

;; UI and STUFFZ END ;;


;; Editing ;;
(setq-default truncate-lines t) ;; Word-wrap
(column-number-mode)
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode t)
;; Disable rel nums lines for select modes
(dolist (mode '(org-mode-hook
		term-mode-hook
		shell-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))
(setq visible-bell t)

;; Editing END ;;

