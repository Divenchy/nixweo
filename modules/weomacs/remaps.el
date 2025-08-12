;; Set leader
(define-prefix-command 'leader)
(global-set-key (kbd "C-<return>") 'leader)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-quit)
(global-set-key (kbd "<escape>") 'minibuffer-keyboard-quit)

