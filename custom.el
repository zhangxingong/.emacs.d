(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(current-language-environment "UTF-8")
 '(display-time-mode t)
 '(global-display-line-numbers-mode t)
 '(menu-bar-mode nil)
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(tooltip-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Fira Code Retina" :foundry "outline" :slant normal :weight normal :height 120 :width normal)))))
;; Enable with t if you prefer
(defconst *spell-check-support-enabled* nil)
;;(setq confirm-kill-emacs #'yes-or-no-p)      ; 在关闭 Emacs 前询问是否确认关闭，防止误触
(add-hook 'prog-mode-hook #'show-paren-mode) ; 编程模式下，光标在括号上时高亮另一个括号
(global-auto-revert-mode t)                  ; 当另一程序修改了文件时，让 Emacs 及时刷新 Buffer
(when (display-graphic-p) (toggle-scroll-bar -1)) ; 图形界面时关闭滚动条
;;(setq garbage-collection-messages t)
;;(add-hook 'calendar-load-hook
;;              (lambda ()
;;                (calendar-set-date-style 'european)))
;;(set-default 'truncate-lines t)
;;(setq debug-on-error t)
(add-hook 'diary-list-entries-hook 'diary-include-other-diary-files)
(add-hook 'diary-mark-entries-hook 'diary-mark-included-diary-files)
(setq package-archives '(("gnu"   . "http://1.15.88.122/gnu/")
                         ("org" . "http://1.15.88.122/org/")
                         ("nongnu" . "http://1.15.88.122/nongnu/")
                         ("melpa" . "http://1.15.88.122/melpa/")))
;;; calendar
(require 'calendar)
(setq mark-diary-entries-in-calendar t)
(delete-selection-mode 1)
;;(desktop-save-mode 1)
(setq diary-entry-marker "D")

(add-hook 'today-visible-calendar-hook 'calendar-mark-today)
(setq calendar-today-marker "T")
(defvar k-gc-timer
  (run-with-idle-timer 15 t
                       'garbage-collect))
(defmacro k-time (&rest body)
  "Measure and return the time it takes evaluating BODY."
  `(let ((time (current-time)))
     ,@body
     (float-time (time-since time))))

(defvar k-gc-timer
  (run-with-idle-timer 15 t
                       (lambda ()
                         (message "Garbage Collector has run for %.06fsec"
                                  (k-time (garbage-collect))))))
(global-set-key (kbd "C-c C-j") 'goto-line)
(global-set-key (kbd "M-/") 'set-mark-command)
(global-set-key (kbd "M-;") 'avy-goto-char)
(global-set-key (kbd "M-L") 'avy-goto-line)
(global-set-key (kbd "M-W") 'avy-goto-word-0)
(global-set-key (kbd "C-S-K") 'kill-whole-line)
(global-set-key (kbd "C-c o") 'ace-window)
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
(global-set-key (kbd "C-c z") 'mc/edit-lines)
(global-set-key (kbd "C-c >") 'mc/mark-next-like-this)
(global-set-key (kbd "C-c <") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c M-z") 'mc/mark-all-like-this)

;;(imenu-list-minor-mode)
(global-set-key (kbd "C-'") #'imenu-list-minor-mode)
(setq imenu-list-focus-after-activation t)
(setq imenu-list-auto-resize t)
(setq ring-bell-function 'ignore)
(setq-local imenux-create-index-function #'ggtags-build-imenu-index)
;; (add-hook 'c-mode-common-hook
;;           (lambda ()
;;             (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
;;               (ggtags-mode 1))))
;(setq imenu-list-after-jump-hook nil)
;(add-hook 'imenu-list-after-jump-hook #'recenter-top-bottom)
;;(global-set-key (kbd "<ESC> <ESC>") 'keyboard-escape-quit)
;;(global-set-key "\C-c\C-d" "\C-a\C- \C-n\M-w\C-y")
;; vi-like line insertion
(global-set-key (kbd"C-M-o") (lambda () (interactive)(beginning-of-line)(open-line 1)))
(global-set-key (kbd"M-o") (lambda () (interactive)(end-of-line)(newline)))
;;switch buffer
(global-set-key (kbd "M-<left>") 'previous-buffer)
(global-set-key (kbd "M-<right>") 'next-buffer)
(server-start)

;;; record two different file's last change. cycle them
(defvar feng-last-change-pos1 nil)
(defvar feng-last-change-pos2 nil)

(defun feng-swap-last-changes ()
  (when feng-last-change-pos2
    (let ((tmp feng-last-change-pos2))
      (setf feng-last-change-pos2 feng-last-change-pos1
            feng-last-change-pos1 tmp))))

(defun feng-goto-last-change ()
  (interactive)
  (when feng-last-change-pos1
    (let* ((buffer (find-file-noselect (car feng-last-change-pos1)))
           (win (get-buffer-window buffer)))
      (if win
          (select-window win)
        (switch-to-buffer-other-window buffer))
      (goto-char (cdr feng-last-change-pos1))
      (feng-swap-last-changes))))

(defun feng-buffer-change-hook (beg end len)
  (let ((bfn (buffer-file-name))
        (file (car feng-last-change-pos1)))
    (when bfn
      (if (or (not file) (equal bfn file)) ;; change the same file
          (setq feng-last-change-pos1 (cons bfn end))
        (progn (setq feng-last-change-pos2 (cons bfn send))
               (feng-swap-last-changes))))))

(add-hook 'after-change-functions 'feng-buffer-change-hook)
;;; just quick to reach
(global-set-key (kbd "M-`") 'feng-goto-last-change)

;; delete space or word
(defun kill-whitespace-or-word ()
  (interactive)
  (if (looking-at "[ \t\n]")
      (let ((p (point)))
        (re-search-forward "[^ \t\n]" nil :no-error)
        (backward-char)
        (kill-region p (point)))
    (kill-word 1)))
;;(global-set-key (kbd "M-d") 'kill-whitespace-word)

;;add the % jump function in vim
;;ref: http://docs.huihoo.com/homepage/shredderyin/emacs_elisp.html
;;ref: emacs FAQ info doc "Matching parentheses"
(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))
(global-set-key "%" 'match-paren)

(add-to-list 'default-frame-alist '(fullscreen . maximized))
(setq default-major-modve 'text-mode)
(add-to-list 'auto-mode-alist '("\\.java\\'" . java-mode))
(add-to-list 'auto-mode-alist '("\\.jsp\\'" . java-mode))
(add-to-list 'auto-mode-alist '("\\.html\\'" . html-mode))
(add-to-list 'auto-mode-alist '("\\.css\\'" . css-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . js-mode))
(add-to-list 'auto-mode-alist '("\\.xml\\'" . xml-mode))
(add-to-list 'auto-mode-alist '("\\.txt\\'" . org-mode))
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
;;(require 'iedit)
;;; 关于没有选中区域,则默认为选中整行的advice
;;;;默认情况下M-w复制一个区域，但是如果没有区域被选中，则复制当前行
(defadvice kill-ring-save (before slickcopy activate compile)
  "When called interactively with no active region, copy a single line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (message "已选中当前行!")
     (list (line-beginning-position)
           (line-beginning-position 2)))))
;;auto saveback
(setq
 backup-by-copying t    ;自动备份
 delete-old-versions t ; 自动删除旧的s备份文件
 kept-new-versions 10   ; 保留最近的10个备份文件
 kept-old-versions 2   ; 保留最早的2个备份文件
 version-control t    ; 多次备份s
 ;; 把生成的备份文件放到统一的一个目录,而不在在文件当前目录生成好多 ~ #的文件
 ;; 如果你编辑某个文件时 后悔了想恢复成以前的一个版本 你可以到这个目录下
 ;; 找到备份的版本
 backup-directory-alist `((".*" . "~/.emacs.d/cache/backup_files/"))
 auto-save-file-name-transforms `((".*" "~/.emacs.d/cache/backup_files/" t))
 auto-save-list-file-prefix   "~/.emacs.d/cache/backup_files/saves-")

;;basic config
(prefer-coding-system 'utf-8)
(setq-default  use-dialog-box nil)
(setq  initial-scratch-message nil)
(setq visible-bell t)
(setq  ring-bell-function 'ignore)
(electric-pair-mode t)
(setq mouse-yank-at-point t)
(setq kill-ring-max 200)
(setq kill-whole-line t);在行首 C-k 时，同时删除末尾换行符
(setq kill-do-not-save-duplicates t);不向kill-ring中加入重复内容
(setq-default
 enable-recursive-minibuffers t        ;在minibuffer 中也可以再次使用minibuffer
 history-delete-duplicates t          ;minibuffer 删除重复历史
 minibuffer-prompt-properties (quote (read-only t point-entered minibuffer-avoid-prompt face minibuffer-prompt)) ;;;;minibuffer prompt 只读，且不允许光标进入其中
 resize-mini-windows t ;; 当minibuffer 内容一行显示不下来时 允许调整minibuffer大小
 read-buffer-completion-ignore-case t ;;补全buffer名时忽略大小写
 read-file-name-completion-ignore-case t;;补全文件名时忽略大小写
 completion-cycle-threshold 8)
(setq  large-file-warning-threshold nil)
(setq recentf-max-saved-items 500)

;;plugin setting
;;(projectile-mode)
;; Recommended keymap prefix on Windows/Linux
;;(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

(ivy-mode)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
;; enable this if you want `swiper' to use it
;; (setq search-default-mode #'char-fold-to-regexp)
(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "<f6>") 'ivy-resume)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> o") 'counsel-describe-symbol)
(global-set-key (kbd "<f1> l") 'counsel-find-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)
(setq ivy-use-selectable-prompt t)

;;(defun reload-custom-config()
;;  (interactive)
;;  (load-file "~/.emacs.d/init.el"))

;; TODO mode
(setq todo-file-do "~/.emacs.d/todo-do")
(setq todo-file-done "~/.emacs.d/todo-done")
(setq todo-file-top "~/.emacs.d/todo-top")


;;org directory
(setq org-agenda-files '("~/.emacs.d/OrgMode/ORG/"
))

(setq org-agenda-include-diary t)
(setq org-agenda-diary-file "~/.emacs.d/OrgMode/ORG/src/standard-diary") ;;2020-03-02 10:47:06
(setq diary-file "~/.emacs.d/OrgMode/ORG/src/standard-diary")

;; location
(setq calendar-longitude 121.57)
(setq calendar-latitude 31.16)

(advice-add 'org-agenda :after
            (lambda (_)
              (when (equal (buffer-name)
                           "*Org Agenda*")
                (calendar)
                (other-window 1))))

(advice-add 'org-agenda-quit :before
            (lambda ()
              (let ((window (get-buffer-window calendar-buffer)))
                (when (and window (not (one-window-p window)))
                  (delete-window window)))))

(require 'cal-china-x)
(setq mark-holidays-in-calendar t)
(setq calendar-mark-holidays-flag t)
(setq cal-china-x-important-holidays cal-china-x-chinese-holidays)
;;(setq cal-china-x-general-holidays '((holiday-lunar 1 15 "元宵节")))
(setq calendar-holidays
      (append cal-china-x-important-holidays
              cal-china-x-general-holidays
              holiday-general-holidays
              holiday-christian-holidays))




;; display Chinese date
(setq org-agenda-format-date 'zeroemacs/org-agenda-format-date-aligned)

(defun zeroemacs/org-agenda-format-date-aligned (date)
  "Format a DATE string for display in the daily/weekly agenda, or timeline.
      This function makes sure that dates are aligned for easy reading."
  (require 'cal-iso)
  (let* ((dayname (aref cal-china-x-days
                        (calendar-day-of-week date)))
         (day (cadr date))
         (month (car date))
         (year (nth 2 date))
         (cn-date (calendar-chinese-from-absolute (calendar-absolute-from-gregorian date)))
         (cn-month (cl-caddr cn-date))
         (cn-day (cl-cadddr cn-date))
         (cn-month-string (concat (aref cal-china-x-month-name
                                        (1- (floor cn-month)))
                                  (if (integerp cn-month)
                                      ""
                                    "(闰月)")))
         (cn-day-string (aref cal-china-x-day-name
                              (1- cn-day))))
    (format "%04d-%02d-%02d 周%s %s%s" year month
            day dayname cn-month-string cn-day-string)))

;;(setq org-agenda-format-date 'org-agenda-format-date-aligned)

;;(defun org-agenda-format-date-aligned (date)
;;  "Format a DATE string for display in the daily/weekly agenda, or timeline.
;;      This function makes sure that dates are aligned for easy reading."
;;  (require 'cal-iso)
;;  (let* ((dayname (aref cal-china-x-days
;;                        (calendar-day-of-week date)))
;;         (day (cadr date))
;;         (month (car date))
;;         (year (nth 2 date))
;;         (cn-date (calendar-chinese-from-absolute (calendar-absolute-from-gregorian date)))
;;         (cn-month (cl-caddr cn-date))
;;         (cn-day (cl-cadddr cn-date))
;;         (cn-month-string (concat (aref cal-china-x-month-name
;;                                        (1- (floor cn-month)))
;;                                  (if (integerp cn-month)
;;                                      ""
;;                                    "(闰月)")))
;;         (cn-day-string (aref cal-china-x-day-name
;;                              (1- cn-day))))
;;    (format "%04d-%02d-%02d 周%s %s%s" year month
;;            day dayname cn-month-string cn-day-string)))
;;
(setq org-agenda-start-day "+0d")
(setq org-agenda-span 1)
(setq org-agenda-start-on-weekday 1)

;;设置一周从周一开始.
(setq calendar-week-start-day 1)

;; Insert timestamp
(defun insert-current-date ()
  "Insert the current date"
  (interactive "*")
  (insert (format-time-string "%Y-%m-%d %A" (current-time)))
  )

;;Sunrise and Sunset
;;日出而作, 日落而息
;;(add-to-path 'load-path "~/.emacs.d/chinese-calendar.el")

;;---------------------------------------------
;;org-agenda-time-grid
;;--------------------------------------------
(setq org-agenda-time-grid (quote ((daily today require-timed)
                                   (300
                                    600
                                    900
                                    1200
                                    1500
                                    1800
                                    2100
                                    2400)
                                   "......"
                                   "-----------------------------------------------------"
                                   )))

(defun my:org-agenda-time-grid-spacing ()
  "Set different line spacing w.r.t. time duration."
  (save-excursion
    (let* ((background (alist-get 'background-mode (frame-parameters)))
           (background-dark-p (string= background "dark"))
           (colors (if background-dark-p
                       (list "#aa557f" "DarkGreen" "DarkSlateGray" "DarkSlateBlue")
                     (list "#F6B1C3" "#FFFF9D" "#BEEB9F" "#ADD5F7")))
           pos
           duration)
      (nconc colors colors)
      (goto-char (point-min))
      (while (setq pos (next-single-property-change (point) 'duration))
        (goto-char pos)
        (when (and (not (equal pos (point-at-eol)))
                   (setq duration (org-get-at-bol 'duration)))
          (let ((line-height (if (< duration 30) 1.0 (+ 0.5 (/ duration 60))))
                (ov (make-overlay (point-at-bol) (1+ (point-at-eol)))))
            (overlay-put ov 'face `(:background ,(car colors)
                                                :foreground
                                                ,(if background-dark-p "black" "white")))
            (setq colors (cdr colors))
            (overlay-put ov 'line-height line-height)
            (overlay-put ov 'line-spacing (1- line-height))))))))

(add-hook 'org-agenda-finalize-hook #'my:org-agenda-time-grid-spacing)

(setq-default system-time-locale "C")

;;;projectile find file
(projectile-global-mode)
(setq projectile-enable-caching t)
;; Recommended keymap prefix on Windows/Linux
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(setq projectile-completion-system 'ivy)

(add-hook 'org-mode-hook (lambda () (setq truncate-lines nil)))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

(setq org-default-notes-file (concat "~/.emacs.d" "/OrgMode/ORG/todo_today.org"))
(setq org-src-fontify-natively t)
(setq org-enforce-todo-dependencies t)
(setq org-todo-keywords '((sequence "TODO(t)" "DOING(i@)" "|" "DONE(d/!)" "ABORT(a/!)")))
(setq org-todo-keyword-faces '(("TODO" . "pink")
                               ("DOING" . "cyan")
                               ("DONE" . "green")
                               ("ABORT" . "white")))
;;Sunrise and Sunset
;;日出而作, 日落而息
(defun diary-sunrise ()
  (let ((dss (diary-sunrise-sunset)))
    (with-temp-buffer
      (insert dss)
      (goto-char (point-min))
      (while (re-search-forward " ([^)]*)" nil t)
        (replace-match "" nil nil))
      (goto-char (point-min))
      (search-forward ",")
      (buffer-substring (point-min) (match-beginning 0)))))

(defun diary-sunset ()
  (let ((dss (diary-sunrise-sunset))
        start end)
    (with-temp-buffer
      (insert dss)
      (goto-char (point-min))
      (while (re-search-forward " ([^)]*)" nil t)
        (replace-match "" nil nil))
      (goto-char (point-min))
      (search-forward ", ")
      (setq start (match-end 0))
      (search-forward " at")
      (setq end (match-beginning 0))
      (goto-char start)
      (capitalize-word 1)
      (buffer-substring start end))))

(defun diary-workon ()
     (with-temp-buffer
       (insert "上班 08:30am")
       ;;(message (buffer-string))
       (buffer-string)))

(defun diary-workoff ()
  (with-temp-buffer
    (insert "下班 05:30pm")
    (buffer-string)))

(setq calendar-chinese-celestial-stem ["甲" "乙" "丙" "丁" "戊" "己" "庚" "辛" "壬" "癸"])
(setq calendar-chinese-terrestrial-branch ["子" "丑" "寅" "卯" "辰" "巳" "午" "未" "申" "酉" "戌" "亥"])

;;最后只保留Note和Plan两部分。
(defun my-org-goto-last-headline (heading)
  (end-of-buffer)
  (re-search-backward heading)
  (end-of-line))


(defun generate-file-path ()
  "按照日期生成一个空的capture模板"
  (let((my-file-name (concat "~/.emacs.d/OrgMode/ORG/todo_" (format-time-string "%y%m%d") ".org")))
    ;;(message my-file-name)
    (if(equal (file-exists-p my-file-name) nil)
        (progn
          (copy-file "~/.emacs.d/OrgMode/ORG/todo_template.org"  my-file-name)
          (find-file my-file-name)
          (goto-char (point-min))
          (goto-line 5)
          (end-of-line)(newline)
          (insert "*" ?\s (format-time-string "%Y-%m-%d %A") ?\n)
          )
    )
    my-file-name
  )
)


(setq org-capture-templates
      '(("n" "Note" entry
         (file+function generate-file-path
                        (lambda () (my-org-goto-last-headline "\\* Note" )))
         "* %i%?\nEntered on %U\n-天气: %^{天气}\n-场地:%^{场所}\n-心情:%^{心情} \n %a")
        ("p" "Plan" entry
         (file+function generate-file-path
                        (lambda () (my-org-goto-last-headline "\\* Plan")))
         "* TODO %i%?\n%a")
        ("e" "Event" entry
         (file+function generate-file-path
                        (lambda () (my-org-goto-last-headline "\\* Event")))
               "* %?\n%U\n%a" :clock-in t :clock-resume t)
        ("t" "Task" entry
         (file+function generate-file-path
                        (lambda () (my-org-goto-last-headline "\\* Task")))
         "* TODO %?\n%U\n%a" :clock-in t :clock-resume t)
        ("d" "Todo" entry (file+function generate-file-path
                                         (lambda () (my-org-goto-last-headline "\\* Plan")))
              "* TODO %?\n  %i\n  %a")
        ("j" "Journal" entry (file+function generate-file-path
                                            (lambda () (my-org-goto-last-headline  "\\* Event")))
              "* %?\nEntered on %U\n  %i\n  %a")
))


(transient-mark-mode 1)
