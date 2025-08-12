(defun load-theme-doom-henna ()
  "Load the doom-henna theme."
  (interactive)
  (load-theme 'doom-henna t))

(defun load-theme-doom-flatwhite ()
  "Load the doom-flatwhite theme."
  (interactive)
  (load-theme 'doom-flatwhite t))

(defun load-theme-doom-snazzy ()
  "Load the doom-snazzy theme."
  (interactive)
  (load-theme 'doom-snazzy t))

(defun load-theme-doom-Iosvkem ()
  "Load the doom-Iosvkem theme."
  (interactive)
  (load-theme 'doom-Iosvkem t))

(load-theme 'doom-Iosvkem t) ;; Default theme
(define-prefix-command 'theme-prefix)
(global-set-key (kbd "C-c t") 'theme-prefix)
(global-set-key (kbd "C-x t") #'counsel-load-theme)
(define-key theme-prefix (kbd "h") #'load-theme-doom-henna)
(define-key theme-prefix (kbd "f") #'load-theme-doom-flatwhite)
(define-key theme-prefix (kbd "s") #'load-theme-doom-snazzy)
