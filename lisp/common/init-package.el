;;; init-package.el --- initialize the plugins

;;; Commentary:
;; (c) Cabins Kong, 2022-

;;; Code:
(setq use-package-always-ensure t
use-package-always-defer t
use-package-enable-imenu-support t
use-package-expand-minimally t)

;; Settings for company, auto-complete only for coding.
(use-package company
  :hook ((prog-mode . company-mode)
         (inferior-emacs-lisp-mode . company-mode))
  :config (setq company-minimum-prefix-length 1
                company-show-quick-access nil))

;; crux, a collection of many useful extensions/commands
;; without key-binding you can use
;; C-a for its original definition
;; M-m to the indentation of current line
;; C-M-<ARROW> for duplicate lines
;; crux commands? Pls use M-x.
(use-package crux)

;; Settings for exec-path-from-shell
;; fix the PATH environment variable issue
;;(use-package exec-path-from-shell
;;  :defer nil
;;  :when (or (memq window-system '(mac ns x))
;;            (unless (memq system-type '(windows-nt dos))
;;              (daemonp)))
;;  :init (exec-path-from-shell-initialize))

;; format all, formatter for almost languages
;; great for programmers
;;(use-package format-al
;;  :hook (prog-mode . format-all-ensure-formatter)
;;  :bind ("C-c f" . #'format-all-buffer))

;; gnu-elpa-keyring-update
(use-package gnu-elpa-keyring-update)

;; iedit - edit same text in one buffer or region
(use-package iedit)

;; avy easy jump
(use-package avy)

(use-package ivy)

(use-package counsel)

(use-package swiper)

(use-package imenu-list)

;; info-colors, make the info manual as colorful
(use-package info-colors
  :hook (Info-selection . info-colors-fontify-node))

;; move-dup, move/copy line or region
(use-package move-dup
  :hook (after-init . global-move-dup-mode))

;; org-superstar
;; make the org mode more beautiful with optimized leading chars
(use-package org-superstar
  :hook (org-mode . org-superstar-mode)
  :config (setq org-superstar-prettify-item-bullets nil))

;; popwin
(use-package popwin
  :hook (after-init . popwin-mode))

;; Settings for which-key - suggest next key
(use-package which-key
  :hook (after-init . which-key-mode))

;; ctrlf, good isearch alternative
(use-package ctrlf
  :hook (after-init . ctrlf-mode))

;; hungry delete, delete many spaces as one
(use-package hungry-delete
  :diminish
  :hook (after-init . global-hungry-delete-mode))

;; move-text, move line or region with M-<up>/<down>
(use-package move-text
  :hook (after-init . move-text-default-bindings))

;; Settings for projectile (use builtin project in Emacs 28)
;; (use-package projectile
;;  :diminish " Proj."
;;  :init (add-hook 'after-init-hook 'projectile-mode)
;;  :config (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
;;  )
(use-package projectile
  :ensure t
  :bind (("C-c p" . projectile-command-map))
  :config
  (setq projectile-mode-line "Projectile")
  (setq projectile-track-known-projects-automatically nil))

(use-package counsel-projectile
  :ensure t
  :after (projectile)
  :init (counsel-projectile-mode))

;; Show the delimiters as rainbow color
(use-package rainbow-delimiters
  :init (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))
(use-package highlight-parentheses
  :init (add-hook 'prog-mode-hook 'highlight-parentheses-mode))


;; Settings for yasnippet
(use-package yasnippet
  :hook (prog-mode . yas-minor-mode))
(use-package yasnippet-snippets)

(use-package buffer-move
  :ensure t
  :bind
  ("<C-S-up>" . buf-move-up)
  ("<C-S-down>" . buf-move-down)
  ("<C-S-left>" . buf-move-left)
  ("<C-S-right>" . buf-move-right))

(use-package cal-china-x)

(use-package ace-window)

(use-package multiple-cursors)

;;(use-package ggtags)

(provide 'init-package)

;; Local Variables:
;; byte-compile-warnings: (not free-vars unresolved)
;; End:
;;; init-package.el ends here
