;;; init.el --- the entry of emacs config -*- lexical-binding: t -*-

;; Author: Cabins
;; Maintainer: Cabins
;; Github: https://github.com/cabins/emacs.d

;;; Commentary:
;; (c) Cabins Kong, 2022-

;;; Code:

;; set the startup default directory, not essential but recommended.
;;(setq default-directory "~/")

;; Adjust garbage collection thresholds during startup, and thereafter
(let ((init-gc-cons-threshold (* 128 1024 1024)))
  (setq gc-cons-threshold init-gc-cons-threshold)
  (add-hook 'emacs-startup-hook
                        (lambda () (setq gc-cons-threshold (* 20 1024 1024)))))

(defun package--save-selected-packages (&optional value)
  "Set and save `package-selected-packages' to VALUE."
  (when value
    (setq package-selected-packages value)))

;;(el-patch-defun package--save-selected-packages (&optional value)
;;  "Set and save `package-selected-packages' to VALUE."
;;  (when value
;;    (setq package-selected-packages value))
;;  (el-patch-remove
;;    (if after-init-time
;;        (let ((save-silently inhibit-message))
;;          (customize-save-variable 'package-selected-packages package-selected-packages))
;;      (add-hook 'after-init-hook #'package--save-selected-packages))))

;; update load-path to make customized lisp codes work
(dolist (folder (directory-files (concat user-emacs-directory "lisp") t directory-files-no-dot-files-regexp))
  (add-to-list 'load-path folder))

;; customized functions
(require 'init-fn)

;; change Emacs default settings here, variables only (NOT include built-in packages)
(require 'init-system)

;; settings for Melpa/Elpa/GNU repos for Emacs package manager
(require 'init-elpa)

;; change default Emacs settings with built-in packages
(require 'init-builtin)

;; all the third-part packages configed here
(require 'init-package)

;; different settings depends on os platform
(require 'init-platform)

;; settings for programming languages (include IDE/LSP feature)
;;(requir;; other features, such as UI/daemon etc.
(require 'init-feature)

;; coding
;;(require 'init-ide)
(require 'init-ui)
(require 'init-kbd)
;; DON'T forget to define and load custom file at last
(setq custom-file (locate-user-emacs-file "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

(provide 'init)

;;; init.el ends here
