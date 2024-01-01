;; configuration --- Summary
;;; Commentary:
;;; Code:
(put 'narrow-to-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)

; list the repositories containing them
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))

; activate all the packages (in particular autoloads)
(package-initialize)

; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))

;; bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

(use-package better-defaults
  :ensure t)
(use-package f
  :ensure t)
(use-package evil
  :ensure t
  :config
  (mapc
   (lambda (mode-hook)
     (add-hook mode-hook 'turn-on-evil-mode)
     (evil-esc-mode 1))
   '(text-mode-hook
     prog-mode-hook
     comint-mode-hook
     css-mode-hook
     conf-mode-hook))
  (mapc
   (lambda (mode-hook)
     (add-hook mode-hook 'turn-off-evil-mode))
   '(Info-mode-hook))
  (evil-mode 1))
(use-package evil-exchange
  :ensure t
  :config
  (evil-exchange-install))
(use-package ido-completing-read+
  :ensure t
  :config
  (ido-ubiquitous-mode 1))
(use-package ido-vertical-mode
  :ensure t
  :config
  (ido-vertical-mode 1))
(use-package smex
  :ensure t
  :config
  (smex-initialize)
  :bind (("M-x" . smex)
         ("C-c C-m" . smex)
         ("M-X" . smex-major-mode-commands)
         ("C-c C-c M-x" . execute-extended-command)))
(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))
(use-package ace-window
  :ensure t
  :bind (("C-x o" . ace-window)))
(use-package smart-mode-line
  :ensure t
  :config
  (sml/setup))
(use-package elpy
  :ensure t
  :init
  (elpy-enable))

; additional libraries
(use-package dired
  :config
  (add-hook 'dired-load-hook
            (function (lambda () (load "dired-x")))))
(use-package python
  :ensure t)
(use-package ansi-color
  :ensure t)

(use-package shell
  :ensure t
  :config
  (add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
  ; show ansi-colors by default
  (add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
  ; properly parse zsh extended history
  (add-hook 'shell-mode-hook '(lambda () (
      setq comint-input-ring-separator "\n: [0-9]*:[0-9]*;")))
  (add-hook 'shell-mode-hook '(lambda () (
      setq comint-input-ring-file-name "~/.histfile")))
  (add-hook 'shell-mode-hook '(lambda () (
      setq  comint-process-echoes t)))
  (add-hook 'shell-mode-hook
          '(lambda ()
              (add-hook 'comint-output-filter-functions
                      'comint-strip-ctrl-m
                      'python-pdbtrack-comint-output-filter-function t))))

(use-package org
  :ensure t
  :config
  (setq org-todo-keywords
      '((sequence "TODO" "STARTED" "|" "DONE" "DELEGATED")))
  (setq org-directory "~/agenda")
  (setq org-default-notes-file (concat org-directory "/todo.org"))
  (setq org-capture-templates
      '(("t" "Todo" entry (file+headline (concat org-directory "/todo.org")
                                          "Tasks")
          "* TODO %?\n SCHEDULED: %t")
          ("j" "Journal" entry (file+datetree
                              (concat org-directory "/journal.org"))
          "* %?\n %t")))
  (setq org-archive-location "~/agenda/journal.org::datetree/")
  (setq org-log-done 'time)
  :bind (("C-c c" . org-capture)
         ("C-c a" . org-agenda)))

; show ansi color in buffer when needed
(defun display-ansi-colors ()
  (interactive)
  (ansi-color-apply-on-region (point-min) (point-max)))

; customization
(setq term-prompt-regexp "^[^%]* % *")
(setq enable-recursive-minibuffers t)
; performance
(setq gc-cons-threshold 50000000)

(global-set-key (kbd "<f5>") 'redraw-display)
(global-set-key (kbd "C-x k") 'kill-this-buffer)
;;; Unbind 'C-x f'
(global-unset-key "\C-xf")
;;; Bind recompile
(global-set-key "\C-cr" 'recompile)

;; Have a nice display console
(set-display-table-slot standard-display-table 'vertical-border
                        (make-glyph-code ?│))
;; Reverse colors for the border to have nicer line
(set-face-inverse-video-p 'vertical-border nil)
(set-face-background 'vertical-border (face-background 'default))
