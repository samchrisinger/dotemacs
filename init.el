(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)

(menu-bar-mode -1)
(global-subword-mode 1)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq-default c-basic-offset 2)
(defalias 'yes-or-no-p 'y-or-n-p)
(global-set-key (kbd "C-x w") 'delete-trailing-whitespace)
(setq make-backup-files nil) ; stop creating backup~ files
(setq auto-save-default nil) ; stop creating #autosave# files

(use-package highlight-indentation
  :straight t
  :init (highlight-indentation-mode 1))

(add-to-list 'load-path "~/.emacs.d/plugins/")
(load "highlight-chars")
(add-hook 'font-lock-mode-hook 'hc-highlight-tabs)
(add-hook 'font-lock-mode-hook 'hc-highlight-trailing-whitespace)

(straight-use-package
 '(magit :type git :host github :repo "magit/magit"))

(setq package-selected-packages
   (quote
    (company-statistics xref-js2 company-tern company-ycmd json-mode flx-ido flx flymake-jslint web-beautify elpy geben-helm-projectile scad-mode flymake-phpcs yasnippet-snippets yasnippet solarized-theme simpleclip xclip phi-search git-gutter editorconfig flymake-jshint js2-mode web-mode flymake-php on-screen hl-anything helm eterm-256color highlight-indent-guides geben dash window-number browse-kill-ring multiple-cursors auto-complete term+ php-mode flycheck)))

(dolist (package package-selected-packages)
  (straight-use-package package))

(require 'company)
(setq company-dabbrev-downcase nil)
(setq company-tooltip-limit 20)                      ; bigger popup window
(setq company-tooltip-align-annotations 't)          ; align annotations to the right tooltip border
(setq company-idle-delay .3)                         ; decrease delay before autocompletion popup shows
(setq company-begin-commands '(self-insert-command)) ; start autocompletion only after typing
(add-to-list 'company-backends 'company-files)
(global-set-key (kbd "C-c /") 'company-files)
(global-company-mode)
(require 'ycmd)
(add-hook 'after-init-hook #'global-ycmd-mode)
(set-variable 'ycmd-server-command '("/usr/bin/ycmd"))
(require 'company-ycmd)
(company-ycmd-setup)

(require 'company-tern)
(add-to-list 'company-backends 'company-tern)
(add-hook 'js2-mode-hook (lambda ()
                           (tern-mode)
                           (company-mode)))

(require 'yasnippet)
(setq yas-snippet-dirs
      '("~/.emacs.d/snippets"                 ;; personal snippets
        ))
(require 'yasnippet-snippets)
(yas-global-mode 1)

;; Multiple cursors
(require 'multiple-cursors)
(global-set-key (kbd "C-c RET RET") 'mc/edit-beginnings-of-lines)

(global-set-key (kbd "C-c d") 'mc/mark-next-like-this)
(global-set-key (kbd "C-c e") 'mc/unmark-next-like-this)
(global-set-key (kbd "C-c a") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c q") 'mc/unmark-previous-like-this)
(global-set-key (kbd "C-c s") 'mc/mark-all-like-this)
(global-set-key (kbd "C-c f") 'mc/skip-to-next-like-this)

;; WINDOW RESIZING
(global-set-key (kbd "S-C-<right>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<left>") 'enlarge-window-horizontally)
(global-set-key (kbd "<M-down>") 'shrink-window)
(global-set-key (kbd "<M-up>") 'enlarge-window)

;; BROWSE KILL RING
(require 'browse-kill-ring)
(browse-kill-ring-default-keybindings)

;; WINDOW-NUMBER-MODE
(require 'window-number)
(window-number-mode)
(window-number-meta-mode)

;; MAGIT
(require 'magit)
(global-set-key (kbd "C-c g") 'magit-status)
(global-set-key (kbd "C-c b") 'magit-blame)

;; TERM
(require 'term+)
(global-set-key (kbd "C-c t") 'term)
(setq explicit-shell-file-name "/bin/bash")

(require 'php-mode)
(add-to-list 'auto-mode-alist '("\\.module\\'" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc\\'" . php-mode))

(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(setq js2-include-node-externs t)
(add-to-list 'auto-mode-alist '("\\.vue$" . web-mode))
;; use web-mode for .jsx files
(add-to-list 'auto-mode-alist '("\\.jsx$" . web-mode))
(define-key js2-mode-map (kbd "M-.") nil)
(add-hook 'js2-mode-hook (lambda ()
  (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)))

;; http://www.flycheck.org/manual/latest/index.html
(require 'flycheck)

;; use eslint with web-mode for jsx files
(flycheck-add-mode 'javascript-eslint 'web-mode)

;; disable jshint since we prefer eslint checking
(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
          '(javascript-jshint)))

;; disable json-jsonlist checking for json files
(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
    '(json-jsonlist)))

;; use eslint with web-mode for jsx files
(flycheck-add-mode 'javascript-eslint 'web-mode)

;; customize flycheck temp file prefix

(require 'editorconfig)
(editorconfig-mode 1)
(add-to-list 'editorconfig-indentation-alist
  '(js2-mode js-indent-level))

(require 'phi-search)
(global-set-key (kbd "C-s") 'phi-search)
(global-set-key (kbd "C-r") 'phi-search-backward)

(require 'simpleclip)
(simpleclip-mode 1)
(global-set-key (kbd "C-x c") 'simpleclip-copy)

(require 'web-mode)
(defun _web-mode-element-close()
  (interactive)
  (web-mode-element-close))
(define-key web-mode-map (kbd "C-c /") '_web-mode-element-close)

(add-to-list 'auto-mode-alist '("\\.tpl.php\\'" . php-mode))
(setq web-mode-auto-close-style 1)
(setq web-mode-tag-auto-close-style 1)

(defun nxml-where ()
  "Display the hierarchy of XML elements the point is on as a path."
  (interactive)
  (let ((path nil))
    (save-excursion
      (save-restriction
        (widen)
        (while (and (< (point-min) (point)) ;; Doesn't error if point is at beginning of buffer
                    (condition-case nil
                        (progn
                          (nxml-backward-up-element) ; always returns nil
                          t)
                      (error nil)))
          (setq path (cons (xmltok-start-tag-local-name) path)))
        (if (called-interactively-p t)
            (message "/%s" (mapconcat 'identity path "/"))
          (format "/%s" (mapconcat 'identity path "/")))))))

(defun xml-find-file-hook ()
  (when (derived-mode-p 'nxml-mode)
    (which-function-mode t)
    (setq which-func-mode t)
    (add-hook 'which-func-functions 'nxml-where t t)))

(add-hook 'find-file-hook 'xml-find-file-hook t)

(require 'hideshow)
(require 'sgml-mode)
(require 'nxml-mode)

(add-to-list 'hs-special-modes-alist
             '(nxml-mode
               "<!--\\|<[^/>]*[^/]>"
               "-->\\|</[^/>]*[^/]>"

               "<!--"
               sgml-skip-tag-forward
               nil))



(add-hook 'nxml-mode-hook 'hs-minor-mode)

;; optional key bindings, easier than hs defaults
(define-key nxml-mode-map (kbd "C-c h") 'hs-toggle-hiding)

(eval-after-load 'js2-mode
  '(define-key js2-mode-map (kbd "C-c |") 'web-beautify-js))

(eval-after-load 'js
  '(define-key js-mode-map (kbd "C-c |") 'web-beautify-js))

(eval-after-load 'json-mode
  '(define-key json-mode-map (kbd "C-c |") 'web-beautify-js))

(eval-after-load 'sgml-mode
  '(define-key html-mode-map (kbd "C-c |") 'web-beautify-html))

(eval-after-load 'web-mode
  '(define-key web-mode-map (kbd "C-c |") 'web-beautify-html))

(eval-after-load 'css-mode
  '(define-key css-mode-map (kbd "C-c |") 'web-beautify-css))
