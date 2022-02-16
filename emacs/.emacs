;;; Mirror Source
(setq package-archives
      '(("gnu" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
        ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
        ))
;;; Init Packages
(package-initialize)
(setq package-check-signature nil)

(require 'package)
(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(use-package rime
  :ensure t
  :custom
  (default-input-method "rime"))

(use-package dracula-theme
  :init (load-theme 'dracula t)
  ;; Dracula-theme
  ;; Jazz-theme
  ;; Ample-theme
  ;; Junio
  :ensure t)

;; The following lines are always needed. Choose your own keys.
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(add-hook 'org-mode-hook 'turn-on-font-lock) ; not needed when global-font-lock-mode is on


;; The following lines are automated added by use-package.
