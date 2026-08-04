;;;;;;;; LSP & Langs ;;;;;;;;
;; M-x package-vc-install RET https://github.com/mattt-b/odin-mode RET
(use-package odin-mode
  :mode "\\.odin\\'")

(when (treesit-available-p)
  (add-to-list 'major-mode-remap-alist '(csharp-mode . csharp-ts-mode)))


;; In lsp.el or qol.el
(use-package glsl-mode
  :ensure t
  :mode ("\\.vert\\'" "\\.frag\\'" "\\.geom\\'" 
         "\\.comp\\'" "\\.glsl\\'"))


;;;;;;;; PowerShell ;;;;;;;;

(use-package powershell
  :ensure t
  :mode ("\\.ps1\\'" "\\.psm1\\'" "\\.psd1\\'")
  :hook (powershell-mode . lsp-deferred)
  :config
  (setq powershell-indent 4))

;;;;;;;; YAML (Azure DevOps, GitHub Actions, etc.) ;;;;;;;;

;; Tree-sitter version (Emacs 29+, recommended)
(when (treesit-available-p)
  (add-to-list 'major-mode-remap-alist '(yaml-mode . yaml-ts-mode)))

;; Fallback for non-treesitter
(use-package yaml-mode
  :ensure t
  :mode ("\\.yml\\'" "\\.yaml\\'"))

;; LSP for YAML with schema support
(with-eval-after-load 'lsp-mode
  ;; Register yaml-language-server
  (add-to-list 'lsp-language-id-configuration '(yaml-mode . "yaml"))
  (add-to-list 'lsp-language-id-configuration '(yaml-ts-mode . "yaml"))
  
  ;; Azure DevOps pipeline schema
  (setq lsp-yaml-schemas
        '((https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/main/service-schema.json 
           . ["azure-pipelines.yml"
              "azure-pipelines.yaml"
              "pipelines/*.yml"
              "pipelines/*.yaml"
              ".azure-pipelines/*.yml"
              ".azure-pipelines/*.yaml"])
          ;; GitHub Actions
          (https://json.schemastore.org/github-workflow.json 
           . [".github/workflows/*.yml"
              ".github/workflows/*.yaml"])
          ;; Docker Compose
          (https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json
           . ["docker-compose.yml"
              "docker-compose.yaml"
              "docker-compose.*.yml"
              "compose.yml"
              "compose.yaml"])
          ;; Kubernetes
          (kubernetes 
           . ["k8s/*.yml"
              "k8s/*.yaml"
              "kubernetes/*.yml"
              "kubernetes/*.yaml"])))
  
  ;; Enable schema validation
  (setq lsp-yaml-validate t)
  (setq lsp-yaml-format-enable t)
  (setq lsp-yaml-hover t)
  (setq lsp-yaml-completion t))

(use-package lsp-mode

  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook (
	 (glsl-mode . lsp-deferred)
	 (rust-mode . lsp-deferred)
	 (csharp-ts-mode . lsp-deferred)
	 (zig-ts-mode . lsp-deferred)
	 (lisp-mode . lsp-deferred)
	 (c-mode . lsp-deferred)
	 (js-mode . lsp-deferred)
	 (json-ts-mode . lsp-deferred)
	 (nix-ts-mode . lsp-deferred)
	 (typescript-mode . lsp-deferred)
	 (tsx-ts-mode . lsp-deferred)
	 (toml-ts-mode . lsp-deferred)
	 (yaml-mode . lsp-deferred)
	 (yaml-ts-mode . lsp-deferred)
	 (haskell-ts-mode . lsp-deferred)
	 (nim-mode . lsp-deferred)
	 (lsp-mode . lsp-enable-which-key-integration))
  :commands (lsp lsp-deferred))
(setq lsp-enable-snippet t)
(setq lsp-completion-provider :none)
(setq lsp-javascript-suggest-complete-function-calls t)
(setq lsp-typescript-suggest-complete-function-calls t)

(defun my/lsp-mode-setup-completion ()
  (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
	'(orderless)))
(add-hook 'lsp-completion-mode-hook #'my/lsp-mode-setup-completion)

;; Debugging ;;
(use-package dap-mode
  :ensure t
  :after lsp-mode
  :config
  (dap-auto-configure-mode 1)

  (require 'dap-netcore)

  (setq dap-netcore-debugger-path (executable-find "netcoredbg"))

  :hook
  ((csharp-mode . dap-mode)
   (csharp-mode . dap-ui-mode)))

(with-eval-after-load 'dap-netcore
  (dap-register-debug-template
   ".NET Core Launch"
   (list :type "coreclr"
	 :request "launch"
	 :name "NetCore Launch"
	 :program "${workspaceFolder}/bin/Debug/net10.0/${fileBasenameNoExtension}.dll"
	 :cwd "${workspaceFolder}")))

;;; Useful keybindings
(global-set-key (kbd "<f5>") 'dap-debug)
(global-set-key (kbd "<f9>") 'dap-breakpoint-toggle)
(global-set-key (kbd "<f10>") 'dap-next)
(global-set-key (kbd "<f11>") 'dap-step-in)
(global-set-key (kbd "S-<f11>") 'dap-step-out)

;;; Corfu - Completion UI
(use-package corfu
  :ensure t
  :custom
  (corfu-cycle t)                  ; Cycle through candidates
  (corfu-auto t)                   ; Enable auto completion
  (corfu-auto-delay 0.0)           ; Delay before popup
  (corfu-auto-prefix 1)            ; Min chars before popup
  (corfu-popupinfo-delay '(0.4 . 0.2))  ; Documentation popup
  (corfu-preview-current nil)      ; Don't preview current candidate
  (corfu-on-exact-match nil)       ; Don't auto-insert on exact match
  :bind (:map corfu-map
         ("M-n" . corfu-next)
         ("M-p" . corfu-previous)
         ("TAB" . corfu-insert)
	 ([tab] . corfu-insert)
	 ("RET" . nil)
         ("M-d" . corfu-popupinfo-toggle))
  
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode))  ; Show documentation popup

;;; Cape - Completion At Point Extensions
(use-package cape
  :ensure t
  :init
  ;; Add useful completion sources
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  
  :bind (("C-c a p" . completion-at-point)  ; capf
         ("C-c a d" . cape-dabbrev)         ; words in buffer
         ("C-c a f" . cape-file)            ; file path
         ("C-c a k" . cape-keyword)         ; programming keyword
         ("C-c a s" . cape-elisp-symbol)    ; elisp symbol
         ("C-c a h" . cape-history)))       ; history

;;; Kind-icon - Icons in completion (optional, nice to have)
(use-package kind-icon
  :ensure t
  :after corfu
  :custom
  (kind-icon-default-face 'corfu-default)
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))
