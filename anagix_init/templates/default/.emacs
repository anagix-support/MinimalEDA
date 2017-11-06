(garbage-collect)
(global-set-key "\C-xI"  'insert-buffer)
(global-set-key "\C-xv"  'vm-visit-folder)
(global-set-key "\C-x4v"  'vm-visit-folder-other-window)
(global-set-key "\C-z" 'scroll-down)
(global-set-key "\C-x\C-z" 'suspend-emacs)

(put 'narrow-to-region 'disabled nil)
(unless (member "/usr/local/share/emacs/site-lisp" load-path)
  (setq load-path (cons "/usr/local/share/emacs/site-lisp" load-path)))
(setq frame-background-mode 'dark)  ; to change sphinx title background color
