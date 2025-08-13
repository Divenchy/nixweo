;; Emacs options
(load-file "~/.emacs.d/basic_settings.el")

;; Emacs remaps
(load-file "~/.emacs.d/remaps.el")

;; Eshell setup
(load-file "~/.emacs.d/eshell.el")

;; QoL + UI
(load-file "~/.emacs.d/qol.el")
(load-file "~/.emacs.d/workflows.el")

;; Custom funcs
(load-file "~/.emacs.d/weofuncs.el")

;; Theming
(load-file "~/.emacs.d/themes.el")

(defun weo/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
	   (format "%.2f seconds"
		   (float-time
		    (time-subtract after-init-time before-init-time)))
	   gcs-done))
(add-hook 'emacs-startup-hook #'weo/display-startup-time)
