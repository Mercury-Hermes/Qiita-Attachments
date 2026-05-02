;;; tamago-tsunagi workaround, experimental
;;
;;  adapt tamago-tsunagi to the latest emacs by mimicking obsolete functions
;;
(if (not (fboundp 'make-coding-system))
    (defun make-coding-system (coding-system type mnemonic doc-string
    					     &optional
					     flags
					     properties
					     eol-type)
      "Define a new coding system CODING-SYSTEM (symbol).
This function is provided for backward compatibility."
      (declare (obsolete define-coding-system "23.1"))
      ;; For compatibility with XEmacs, we check the type of TYPE.  If it
      ;; is a symbol, perhaps, this function is called with XEmacs-style
      ;; arguments.  Here, try to transform that kind of arguments to
      ;; Emacs style.
      (if (symbolp type)
       	  (let ((args (transform-make-coding-system-args coding-system type
	   						 mnemonic doc-string)))
	    (setq coding-system (car args)
		  type (nth 1 args)
		  mnemonic (nth 2 args)
		  doc-string (nth 3 args)
		  flags (nth 4 args)
		  properties (nth 5 args)
		  eol-type (nth 6 args))))

      (setq type
	    (cond ((eq type 0) 'emacs-mule)
		  ((eq type 1) 'shift-jis)
		  ((eq type 2) 'iso2022)
		  ((eq type 3) 'big5)
		  ((eq type 4) 'ccl)
		  ((eq type 5) 'raw-text)
		  (t
		   (error "Invalid coding system type: %s" type))))

      (setq properties
	    (let ((plist nil) key)
	      (dolist (elt properties)
		(setq key (car elt))
		(cond ((eq key 'post-read-conversion)
		       (setq key :post-read-conversion))
		      ((eq key 'pre-write-conversion)
		       (setq key :pre-write-conversion))
		      ((eq key 'translation-table-for-decode)
		       (setq key :decode-translation-table))
		      ((eq key 'translation-table-for-encode)
		       (setq key :encode-translation-table))
		      ((eq key 'safe-charsets)
		       (setq key :charset-list))
		      ((eq key 'mime-charset)
		       (setq key :mime-charset))
		      ((eq key 'valid-codes)
		       (setq key :valids)))
		(setq plist (plist-put plist key (cdr elt))))
	      plist))
      (setq properties (plist-put properties :mnemonic mnemonic))
      (plist-put properties :coding-type type)
      (cond ((eq eol-type 0) (setq eol-type 'unix))
	    ((eq eol-type 1) (setq eol-type 'dos))
	    ((eq eol-type 2) (setq eol-type 'mac))
	    ((vectorp eol-type) (setq eol-type nil)))
      (plist-put properties :eol-type eol-type)

      (cond
       ((eq type 'iso2022)
	(plist-put properties :flags
		   (list (and (or (consp (nth 0 flags))
				  (consp (nth 1 flags))
				  (consp (nth 2 flags))
				  (consp (nth 3 flags))) 'designation)
			 (or (nth 4 flags) 'long-form)
			 (and (nth 5 flags) 'ascii-at-eol)
			 (and (nth 6 flags) 'ascii-at-cntl)
			 (and (nth 7 flags) '7-bit)
			 (and (nth 8 flags) 'locking-shift)
			 (and (nth 9 flags) 'single-shift)
			 (and (nth 10 flags) 'use-roman)
			 (and (nth 11 flags) 'use-oldjis)
			 (or (nth 12 flags) 'direction)
			 (and (nth 13 flags) 'init-at-bol)
			 (and (nth 14 flags) 'designate-at-bol)
			 (and (nth 15 flags) 'safe)
			 (and (nth 16 flags) 'latin-extra)))
	(plist-put properties :designation
		   (let ((vec (make-vector 4 nil)))
		     (dotimes (i 4)
		       (let ((spec (nth i flags)))
			 (if (eq spec t)
			     (aset vec i '(94 96))
			   (if (consp spec)
			       (progn
				 (if (memq t spec)
				     (setq spec (append (delq t spec) '(94 96))))
				 (aset vec i spec))))))
		     vec)))

       ((eq type 'ccl)
	(plist-put properties :ccl-decoder (car flags))
	(plist-put properties :ccl-encoder (cdr flags))))

      (apply 'define-coding-system coding-system doc-string properties)))
;;
;; https://www.mail-archive.com/users-jp@freebsd.org/msg00229.html
(define-obsolete-variable-alias
  'inactivate-current-input-method-function
  'deactivate-current-input-method-function
  "24.3")
(define-obsolete-function-alias
  'inactivate-input-method
  'deactivate-input-method
  "24.3")
;;
;;  https://osdn.net/projects/tamago-tsunagi/ticket/48966
(if (not (fboundp 'buffer-has-markers-at))
	 (defun buffer-has-markers-at (position)
	   "Return t if there are markers pointing at POSITION in the current buffer.
The original function was obsolute since 24.3."
	   (let ((tmp-ring mark-ring))
	     (while (and tmp-ring
			 (not (= position (marker-position (car tmp-ring)))))
	       (pop tmp-ring)
	       )
	     tmp-ring)))
