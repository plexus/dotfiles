;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (package-initialize)

(setq plexus/emacs-profiles
      '(("plexus"                       . ((user-emacs-directory . "~/emacs-profiles/plexus")))
        ("lambdaisland"                 . ((user-emacs-directory . "~/emacs-profiles/spacemacs-master")
                                           (env . (("SPACEMACSDIR" . "~/emacs-profiles/lambdaisland")))))
        ("spacemacs"                    . ((user-emacs-directory . "~/emacs-profiles/spacemacs-master")
                                           (env . (("SPACEMACSDIR" . "~/emacs-profiles/spacemacs-dir")))))
        ("spacemacs-develop"            . ((user-emacs-directory . "~/emacs-profiles/spacemacs-develop")
                                           (env . (("SPACEMACSDIR" . "~/emacs-profiles/spacemacs-dir")))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun plexus/get-emacs-profile (profile)
  (alist-get profile plexus/emacs-profiles nil nil #'equal))

(defun plexus/emacs-profile-key (key &optional default)
  (alist-get key (plexus/get-emacs-profile plexus/current-emacs-profile)
             default))

(defun plexus/load-profile (profile)
  (setq plexus/current-emacs-profile profile)
  (let* ((emacs-directory (file-name-as-directory
                           (plexus/emacs-profile-key 'user-emacs-directory)))
         (init-file       (expand-file-name "init.el" emacs-directory))
         (custom-file-    (plexus/emacs-profile-key 'custom-file init-file)))
    (setq user-emacs-directory emacs-directory)

    ;; Allow multiple profiles to each run their server
    (setq server-name profile)


    ;; Set environment variables, these are visible to init-file with getenv
    (mapcar (lambda (env)
              (setenv (car env) (cdr env)))
            (plexus/emacs-profile-key 'env))

    ;; Start the actual initialization
    (load init-file)

    ;; Prevent customize from changing ~/.emacs (this file)
    (when (not custom-file)
      (setq custom-file custom-file-)
      (load custom-file))))

(defun plexus/check-command-line-args (args)
  (when args
    (if (equal (car args) "--load-profile")
        (plexus/load-profile (cadr args))
      (plexus/check-command-line-args (cdr args)))))

;; Check for a --load-profile flag and honor it
(plexus/check-command-line-args command-line-args)

;; TODO a sensible fallback?

;; If we wait for command-switch-alist then after-init-hook has already run,
;; this is just a no-op so Emacs knows --load-profile is a valid option
(add-to-list 'command-switch-alist '("--load-profile" .
                                     (lambda (_) (pop command-line-args-left))))

(provide '.emacs)
