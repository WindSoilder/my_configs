;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)
;; load emacs 24's package system. Add MELPA repository.
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   ;'("melpa" . "http://stable.melpa.org/packages/") ; many packages won't show if using stable
   '("melpa" . "https://melpa.org/packages/")
   ;'("melpa" . "http://melpa.milkbox.net/packages/")
   t))

(setq make-backup-files nil)
 
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(lsp-mode htmlize))
 '(safe-local-variable-values '((eval when (fboundp 'rainbow-mode) (rainbow-mode 1)))))

(linum-mode t)
(column-number-mode t)

;; Configuration for org mode
(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cb" 'org-iswitchb)

(setq org-log-done t)
(global-visual-line-mode t)
;; (setq org-startup-truncated nil)
(setq org-html-validation-link nil)
(eval-after-load "org"
  '(require 'ox-md nil t))
(setq org-todo-keywords (list "TODO" "IN PROGRESS" "DONE"))


;; UTF-8 as default encoding
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(add-to-list 'load-path "~/.emacs.d/lisp")
(add-to-list 'load-path "~/.emacs.d/site-lisp")
(add-to-list 'load-path "~/.emacs.d/site-lisp/dash.el")
(load "gruvbox")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'gruvbox-dark-hard t)

;; scheme relative.
(autoload 'paredit-mode "paredit"
  "Minor mode for pseudo-structurally editing Lisp code."
  t)
(require 'cmuscheme)

;; bypass the interactive question and start the default interpreter
(defun scheme-proc ()
  "Return the current Scheme process, starting one if necessary."
  (unless (and scheme-buffer
               (get-buffer scheme-buffer)
               (comint-check-proc scheme-buffer))
    (save-window-excursion
      (run-scheme scheme-program-name)))
  (or (scheme-get-process)
      (error "No current process. See variable `scheme-buffer'")))

(defun scheme-split-window ()
  (cond
   ((= 1 (count-windows))
    (delete-other-windows)
    (split-window-vertically (floor (* 0.68 (window-height))))
    (other-window 1)
    (switch-to-buffer "*scheme*")
    (other-window 1))
   ((not (member "*scheme*"
               (mapcar (lambda (w) (buffer-name (window-buffer w)))
                       (window-list))))
    (other-window 1)
    (switch-to-buffer "*scheme*")
    (other-window -1))))

(defun scheme-send-last-sexp-split-window ()
  (interactive)
  (scheme-split-window)
  (scheme-send-last-sexp))

(defun scheme-send-definition-split-window ()
  (interactive)
  (scheme-split-window)
  (scheme-send-definition))

(add-hook 'scheme-mode-hook
  (lambda ()
    (paredit-mode 1)
    (define-key scheme-mode-map (kbd "<f5>") 'scheme-send-last-sexp-split-window)
    (define-key scheme-mode-map (kbd "<f6>") 'scheme-send-definition-split-window)))

(require 'parenface)
(set-face-foreground 'paren-face "DimGray")
(linum-mode t) 
;;; I prefer cmd key for meta
(setq mac-option-key-is-meta t
      mac-option-modifier 'meta)
