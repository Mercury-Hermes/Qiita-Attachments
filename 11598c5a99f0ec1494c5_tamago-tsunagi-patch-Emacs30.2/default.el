;;; default.el - loaded after ".emacs" on startup
;;;
;;; Setting `inhibit-default-init' non-nil in "~/.emacs"
;;; prevents loading of this file.  Also the "-q" option to emacs
;;; prevents both "~/.emacs" and this file from being loaded at startup.

;; default to better frame titles
(setq-default frame-title-format (concat "%b - " user-login-name "@" (system-name)))

;;;	languages input
;;
;;(load-file "/usr/share/emacs/30.2/lisp/leim/leim-list.el")
;;  or
(load-file (concat source-directory "lisp/leim/leim-list.el"))
;;  i.e. source-directory is defined in site-start.el
;;
;;  tamago-tsunagi
;;
(if t
    (progn
      (load-file "/usr/local/share/emacs/site-lisp/tamago-tsunagi/leim-list.el")
      (load-file "/usr/local/share/emacs/site-lisp/tamago-tsunagi/menudiag.el")
      (setq default-input-method "japanese-egg-wnn")
      ;;
      (custom-set-variables
       ;; custom-set-variables was added by Custom -- don't edit or cut/paste it!    
       ;; Your init file should contain only one such instance.                      
       '(wnn-auto-save-dictionaries 19)
       '(wnn-jserver '("localhost")))
      ;;
      (setq   toroku-region-yomigana  "")
      ))

;;
;;  alternately, use Anthy
;;
(if nil
    (progn
      (load-file "/usr/share/emacs/site-lisp/anthy-unicode/leim-list.el")
      (setq default-input-method "japanese-anthy-unicode")))
