(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook (
	 (csharp-mode . lsp-deferred)
	 (js-json-mode . lsp-deferred)
	 (zig-mode . lsp-deferred)
	 (ada-mode . lsp-deferred)
	 (lisp-mode . lsp-deferred)
	 (c-mode . lsp-deferred)
	 (lsp-mode . lsp-enable-which-key-integration))
  :commands (lsp lsp-deferred))
(setq lsp-enable-snippet t)

(use-package company
  :after lsp-mode
  :hook
  (lsp-mode . company-mode)
  :bind
  (:map company-active-map
	("<tab>" . company-complete-selection)
	("<return>" . nil)
	("RET". nil)
	("C-m" . nil))
  (:map lsp-mode-map
	("<tab>" . company-indent-or-complete-common))
  :custom
  (setq company-backends '((company-files company-capf company-keywords)))
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

;; Debugging ;;
(use-package dap-mode
  :after lsp-mode
  :config
  (require 'dap-netcore)
  (setq dap-netcore-download-url "https://github.com/Samsung/netcoredbg/releases/download/3.1.2-1054/netcoredbg-linux-amd64.tar.gz")
  (setq dap-netcore-install-dir "~/dev_tools/debuggers/netcoredbg/")
  (setq dap-netcore--debugger-cmd "~/dev_tools/debuggers/netcoredbg/netcoredbg"))
