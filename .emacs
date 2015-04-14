;; Commentary: Emacs 24 config file
;;; Inspired by http://www.aaronbedra.com/emacs.d/

;; ** user details **
(setq user-mail-address "alex@mypopescu.com")

;; ** environment **
(require 'server)
(unless (server-running-p)
  (server-start))

;; ** package management
(require 'cl)
(require 'package)
(package-initialize)
(add-to-list 'package-archives
	     '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/"))

(defvar my-packages '(ag
		      exec-path-from-shell
		      flycheck
                      flycheck-clojure
                      flycheck-pyflakes
                      flycheck-rust
                      sr-speedbar
                      projectile
                      projectile-speedbar
                      flx-ido
                      neotree
                      company
                      company-anaconda
                      company-go
                      company-inf-ruby
                      company-quickhelp
                      ;; modes
                      applescript-mode
                      clojure-mode
                      csharp-mode
                      erlang
                      go-mode
                      go-direx
                      json-mode
                      markdown-mode
                      php-mode
                      scala-mode
                      web-mode
                      yaml-mode
                      ;; themes
                      color-theme
                      ample-theme
                      color-theme-sanityinc-tomorrow
                      ir-black-theme
                      solarized-theme)
  "Packages that should be installed at launch")

(defun my-packages-installed-p ()
  (loop for p in my-packages
	when (not (package-installed-p p)) do (return nil)
	finally (return t)))

(unless (my-packages-installed-p)
  ;; check for new packages (package versions)
  (message "%s" "Refreshing package database...")
  (package-refresh-contents)
  (dolist (p my-packages)
    (when (not (package-installed-p p))
      (package-install p))))

;; *** start-up options ***
;;; Backups
;; uncomment next line for disabling backup files
;; (setq make-backup-files nil)
(setq backup-directory-alist `(("." . "~/tmp")))

;;; Splash screen
(setq inhibit-startup-message t
      initial-scratch-message nil
      ;;initial-major-mode 'org-mode)
      )
;;; Display
(setq default-frame-alist
      '(
        (width . 110)
        (height . 70)
	(cursor-color . "#ffd700")
	(font . "Input Mono:11")
        ))

;; (setq-default cursor-type 'bar)
(blink-cursor-mode 0)
(setq ring-bell-function 'ignore)


;;; Editing defaults
(prefer-coding-system 'utf-8)
(setq buffer-file-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;;; line numbers
(global-linum-mode t)
(setq column-number-mode t)
(show-paren-mode 1)
(setq show-paren-delay 0.2)

;;; indentation
(setq indent-tabs-mode nil)
(electric-indent-mode 1)
(add-hook 'yaml-mode-hook (lambda () (electric-indent-local-mode -1)))

;;; electric pairs
(electric-pair-mode 1)
;; configure electric pairs
;; (setq electric-pair-pairs '(
;; 			    (?\" . ?\")
;; 			    (?\{ . ?\})
;; 			    ))

;;; Key bindings
(global-set-key (kbd "C-x O") 'previous-multiframe-window)
;; (global-set-key (kbd "C-*")
;; 		(lambda ()
;; 		  (interactive)
;; 		  (re-search-forward (format "\\b%s\\b" (thing-at-point 'word)))))
(define-key isearch-mode-map (kbd "C-*")
  (lambda ()
	  "Reset current isearch to a word-mode search of the word under point"
	  (interactive)
	  (setq isearch-word t
	        isearch-string ""
	        isearch-message "")
	  (isearch-yank-string (word-at-point))))

;;; Themes
(if window-system
    (load-theme 'misterioso t)
  (load-theme 'wombat t))


;;; *** plugins ***
;; exec-path-from-shell
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; ido flx-ido
(setq ido-create-new-buffer 'always
      ido-enable-prefix nil
      ido-enable-flex-matching t
      ido-everywhere t
      ido-use-filename-at-point 'guess)
(ido-mode 1)

(require 'flx-ido)
(flx-ido-mode 1)

;; disable ido faces to see flx highlights
(setq ido-use-faces nil)
;; uncomment to disable flx highlights
;; (setq flx-ido-use-faces nil)


;; flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)
(with-eval-after-load 'flycheck
  (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))
  (setq flycheck-check-syntax-automatically '(save idle-change mode-enabled)
	flycheck-idle-change-delay 1.0))

;; org-mode
(setq org-directory "~/Dropbox/Dox/TaskPaper")
(setq org-default-notes-file (concat org-directory "/instant-notes.org"))
(setq org-log-done t
      org-todo-keywords '((sequence "TODO" "WIP" "|" "DONE" "CANCELED" "WAIT"))
      org-todo-keyword-faces '(("WIP" . (:foreground "#7c2acd" :weight bold))
			       ("CANCELED" . (:foreground "#ffd39b" :weight normal :strike-through t))
			       ("WAIT" . (:foreground "#ff7f00" :slant italic))))

(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(global-set-key "\C-cl" 'org-store-link)

(setq org-capture-templates
      '(("a" "Todo" entry (file+datetree org-default-notes-file)
	 "* TODO %?\n  %i" :empty-lines 1)
	("b" "Todo with ref" entry (file+datetree org-default-notes-file)
	 "* TODO %?\n  %a\n  %i" :empty-lines 1)
	("c" "Task" checkitem (file+datetree org-default-notes-file)
	 "- [ ] %?\n  %i\n  %T" :empty-lines 1)
	("d" "Task" checkitem (file+datetree org-default-notes-file)
	 "- [ ] %?\n  %a\n  %i\n  %T" :empty-lines 1)
	("e" "Note" item (file+datetree org-default-notes-file)
	 "+ %? (%T)")))


;; speedbar
(setq speedbar-show-unknown-files t)
(setq sr-speedbar-right-side nil)
;(setq speedbar-use-images nil) ; use text for buttons
;; (add-hook 'speedbar-mode-hook
;; 	  (lambda()
;; 	    (speedbar-add-supported-extension "\\.rb")
;; 	    (speedbar-add-supported-extension "\\.ru")
;; 	    (speedbar-add-supported-extension "\\.erb")
;; 	    (speedbar-add-supported-extension "\\.rjs")
;; 	    (speedbar-add-supported-extension "\\.rhtml")
;; 	    (speedbar-add-supported-extension "\\.rake")))
(global-set-key "\C-ct" 'sr-speedbar-toggle)


;; projectile
(projectile-global-mode)
;;(setq projectile-indexing-method 'native)
(setq projectile-use-native-indexing t)
(setq projectile-completion-system 'ido)
(setq projectile-globally-ignored-directories
    (append '(".git"
	      ".svn"
	      "build"
	      "target") projectile-globally-ignored-directories))

(setq projectile-globally-ignored-files
      (append '("*.pyc"
		"*.pyo"
		"*.class"
		"*.o") projectile-globally-ignored-files))


;; neotree
(global-set-key [f5] 'neotree-toggle)
(global-set-key "\C-cs" 'neotree-toggle)

;; company
(add-hook 'after-init-hook 'global-company-mode)
(global-set-key (kbd "M-RET") 'company-complete)
(global-set-key (kbd "s-/") 'company-complete)
(setq
 ;; never start auto-completion unless asked
 company-idle-delay 5
 ;; autocomplete right after .
 company-minimum-prefix-length 0
 ;; remove echo delay
 company-echo-delay 0
 ;; don't complete in certain modes
 company-global-modes '(not git-commit-mode org-mode))

(with-eval-after-load 'company
  (add-to-list 'company-backends 'company-anaconda)
  (add-to-list 'company-backends 'company-go))
(add-hook 'python-mode-hook 'anaconda-mode)

;; markdown-mode
(setq markdown-command "~/bin/emarkdown")
(setq auto-mode-alist
      (cons '("\\.\\(md\\|markdown\\)\\'" . markdown-mode) auto-mode-alist))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (sanityinc-tomorrow-eighties)))
 '(custom-safe-themes
   (quote
    ("9bc1eec9b485726318efd9341df6da8b53fa684931d33beba57ed7207f2090d6" "e80932ca56b0f109f8545576531d3fc79487ca35a9a9693b62bf30d6d08c9aaf" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "82d2cac368ccdec2fcc7573f24c3f79654b78bf133096f9b40c20d97ec1d8016" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "a041a61c0387c57bb65150f002862ebcfe41135a3e3425268de24200b82d6ec9" "5cd698ce53179b1e4eaa7917c992832a220600c973967904fea71e3980a46532" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "8d6fb24169d94df45422617a1dfabf15ca42a97d594d28b3584dc6db711e0e0b" "08efabe5a8f3827508634a3ceed33fa06b9daeef9c70a24218b70494acdf7855" "764e3a6472a3a4821d929cdbd786e759fab6ef6c2081884fca45f1e1e3077d1d" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; coding: utf-8