;; Set leader
(define-prefix-command 'leader)
(global-set-key (kbd "M-;") 'leader)

(define-key leader (kbd "h") #'hs-minor-mode)

;; Avy ;;
(global-set-key (kbd "C-,") 'avy-goto-char)
(global-set-key (kbd "M-,") 'avy-goto-char-2)
(global-set-key (kbd "M-g l") 'avy-goto-line)
(global-set-key (kbd "C-.") 'avy-goto-word-1)

;; Getting harpoony ;;
(dotimes (i 9)
  (let ((n (number-to-string (1+ i))))
    ;; C-c h 1 .. C-c h 9 to *set* bookmark
    (global-set-key
     (kbd (concat "C-c h " n))
     `(lambda () (interactive)
        (bookmark-set (concat "slot-" ,n))))

    ;; C-c j 1 .. C-c j 9 to *jump* to bookmark
    (global-set-key
     (kbd (concat "C-c j " n))
     `(lambda () (interactive)
        (bookmark-jump (concat "slot-" ,n))))))

;; Install package
(global-set-key (kbd "C-x p") 'package-install)

;; Editing Remaps ;;

;; Open a new line and places cursor on it, without breatking the current line
(global-set-key (kbd "M-<return>") (lambda ()
				(interactive)
				(move-end-of-line 1)
				(newline-and-indent)))
(global-set-key (kbd "C-<return>")
  (lambda ()
    (interactive)
    ;; Insert a newline *above* the current line
    (beginning-of-line)
    (open-line 1)              ;; open a line above
    (indent-according-to-mode)
    (forward-line 0)))         ;; move point to the newly created line


;; Zap up to char quickly
(defun vg-quick-zap-up-to-char (prefix char)
  "Zap up to CHAR. With negative PREFIX, zap backward."
  (interactive "P\nc")
  (let ((count (cond
                ((null prefix) 1)
                ((integerp prefix) prefix)
                (t (prefix-numeric-value prefix)))))
    (zap-up-to-char count char)))

(defun vg-quick-zap-up-to-char-backward (char)
  "Zap backward up to CHAR (like Vim's dT')."
  (interactive "cZap backward up to char: ")
  (zap-up-to-char -1 char))

(global-set-key (kbd "C-d") #'vg-quick-zap-up-to-char)
(global-set-key (kbd "C-D") #'vg-quick-zap-up-to-char-backward)

(global-set-key (kbd "C-k") 'kill-whole-line)

;; Replicate change inside word motion
(defun weo/change-inner-word ()
  "Delete the word at point, like Vim ciw."
  (interactive)
  (let ((bounds (bounds-of-thing-at-point 'word)))
    (when bounds
      (delete-region (car bounds) (cdr bounds)))))

(global-set-key (kbd "M-c") #'weo/change-inner-word)

(defun weo/change-up-to-char (char)
  "Delete up to CHAR (excluding it) like Vim ci<char>."
  (interactive "cChange up to char: ")
  (let ((end (save-excursion
               (search-forward (char-to-string char) nil nil 1))))
    (when end
      (delete-region (point) (1- end))))
  (call-interactively 'self-insert-command))

(global-set-key (kbd "M-C") #'weo/change-up-to-char)

;; Marking (Selections) ;;
(global-set-key (kbd "C-SPC")
  (lambda ()
    (interactive)
    (set-mark (point))
    (deactivate-mark)))

(define-prefix-command 'mark-prefix)
(global-set-key (kbd "M-m") 'mark-prefix)
(define-key mark-prefix (kbd "m") 'set-mark-command)
(define-key mark-prefix (kbd "r") 'rectangle-mark-mode)
(define-key mark-prefix (kbd "p") 'mark-paragraph)
(define-key mark-prefix (kbd "w") 'mark-word)
(define-key mark-prefix (kbd "s") 'mark-sexp)
(define-key mark-prefix (kbd "d") 'mark-defun)
(define-key mark-prefix (kbd "u") 'pop-global-mark)
(define-key mark-prefix (kbd "b") 'mark-whole-buffer)
(define-key mark-prefix (kbd "P") 'mark-page)

(global-set-key (kbd "M-W") 'kill-region) ;; W for withdraw
(global-set-key (kbd "M-w") 'kill-ring-save)

;; Go to first char in line
(global-set-key (kbd "M-i") 'beginning-of-line-text)
;; yank line
(defun weo/yank-line ()
  "Copy the current line to the kill ring."
  (interactive)
  (let ((beg (line-beginning-position))
        (end (line-end-position)))
    (kill-ring-save beg end)
    (message "Line copied")))
(global-set-key (kbd "M-y") #'weo/yank-line)

;; Standardize C-y
(defun weo/yank-replace-region ()
  "Replace active region with yanked content."
  (interactive)
  (when (use-region-p)
    (delete-region (region-beginning) (region-end)))
  (yank))

(global-set-key (kbd "C-y") #'weo/yank-replace-region)

;; File/Buffer
(define-prefix-command 'file-prefix)
(global-set-key (kbd "C-c f") 'file-prefix)
(define-prefix-command 'buffer-prefix)
(global-set-key (kbd "C-c b") 'buffer-prefix)

(define-key file-prefix (kbd "s") #'save-buffer)
(define-key file-prefix (kbd "f") #'find-file)
(define-key buffer-prefix (kbd "b") #'switch-to-buffer)
(define-key buffer-prefix (kbd "e") #'eval-buffer)
(define-key buffer-prefix (kbd "k") #'kill-buffer)
(define-key buffer-prefix (kbd "K")
  (lambda (&rest _args)
    (interactive)
    (kill-this-buffer)))


(global-set-key (kbd "C-`") #'mode-line-other-buffer)
(global-set-key (kbd "<f11>") #'toggle-frame-fullscreen)

;; Replace a character under point
(defun weo/replace-char (char)
  "Replace character under point with CHAR (like Vim's `r`)."
  (interactive "cReplace with: ")
  (delete-char 1)
  (insert char)
  (backward-char 1))  ;; stay on replaced char, like Vim
(global-set-key (kbd "C-r") #'weo/replace-char)

;; Windows/Frames
(define-prefix-command 'window-prefix)
(global-set-key (kbd "C-w") 'window-prefix)

(defun my-next-window-in-frame ()
  "Switch to the next window in the currently selected frame."
  (interactive)
  (select-window (next-window (selected-window) nil (selected-frame))))

(defun my-prev-window-in-frame ()
  "Switch to the previous window in the currently selected frame."
  (interactive)
  (select-window (previous-window (selected-window) nil (selected-frame) )))

(defun my-delete-window ()
  "Delete the current window, interactive (repeatable)."
  (interactive)
  (delete-window))

(define-key window-prefix (kbd "v") #'split-window-vertically)
(define-key window-prefix (kbd "h") #'split-window-horizontally)
(define-key window-prefix (kbd "w") #'my-delete-window)
(define-key window-prefix (kbd "o") #'delete-other-windows)
(define-key window-prefix (kbd "n") #'my-next-window-in-frame)
(define-key window-prefix (kbd "p") #'my-prev-window-in-frame)

;; Windows/Frames Repeatability
(defvar window-repeat-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "n") #'my-next-window-in-frame)
    (define-key map (kbd "p") #'my-prev-window-in-frame)
    (define-key map (kbd "v") #'split-window-vertically)
    (define-key map (kbd "h") #'split-window-horizontally)
    (define-key map (kbd "w") #'my-delete-window)
    map))

;; window-repeat-map
(put 'my-next-window-in-frame 'repeat-map 'window-repeat-map)
(put 'my-prev-window-in-frame 'repeat-map 'window-repeat-map)
(put 'split-window-vertically 'repeat-map 'window-repeat-map)
(put 'split-window-horizontally 'repeat-map 'window-repeat-map)
(put 'my-delete-window 'repeat-map 'window-repeat-map)
(put 'my-delete-window 'repeat-map 'window-repeat-map)

;; Easy window productivity
(defun my-find-file-other-window ()
  "Open a file in the other window."
  (interactive)
  (let ((file (read-file-name "File: ")))
    (find-file-other-window file)))

(define-key file-prefix (kbd "F") #'my-find-file-other-window)
(define-prefix-command 'quit-prefix)
(defun my-switch-window ()
  "Move point to the next window in the current frame."
  (interactive)
  (other-window 1))

(global-set-key (kbd "M-o") #'my-switch-window)



(global-set-key (kbd "C-q") 'quit-prefix)
;; Quitting emacs
(defun weo/force-quit ()
  "Quit Emacs immediately without saving."
  (interactive)
  (kill-emacs))


;; soft restart
(defun weo/reload-init ()
  "Reload the Emacs init file."
  (interactive)
  (load-file (expand-file-name "~/.emacs.d/init.el")))


(define-key quit-prefix (kbd "Q") #'weo/force-quit)
(define-key quit-prefix (kbd "r") #'weo/reload-init)
(define-key quit-prefix (kbd "q") #'save-buffers-kill-emacs)
(define-key quit-prefix (kbd "R") #'restart-emacs)
