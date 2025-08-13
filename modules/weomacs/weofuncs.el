(defun weo/run-python-current-file ()
  (interactive)
  (async-shell-command (concat "python " (shell-quote-argument buffer-file-name))))
