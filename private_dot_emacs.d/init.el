;; -*- lexical-binding: t;  -*-

(eval-and-compile
  (customize-set-variable
   'package-archives '(("org" . "https://orgmode.org/elpa/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("gnu" . "https://elpa.gnu.org/packages/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    ;; (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    (leaf blackout :ensure t)

    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init)))
;; </leaf-install-code>

;; write config below here

(leaf leaf
  :config
  (leaf leaf-convert :ensure t)
  (leaf leaf-tree
    :ensure t
    :custom ((imenu-list-size . 30)
	     (imenu-list-position . 'left))))

(leaf cus-start
  :custom '((electric-pair-mode . t)
	    (global-display-line-numbers-mode . t)
	    (tool-bar-mode . nil)
	    (cursor-type . 'bar)
	    (truncate-lines . nil)
	    (org-startup-truncated . nil)
	    (make-backup-files . nil)
	    (auto-save-default . nil)
	    (auto-save-file-prefix . nil)
	    (create-lockfiles . nil)))

(set-face-font 'default "Monaspace Argon-14")

(leaf which-key
  :ensure t
  :config (which-key-mode 1))

(leaf moody
  :ensure t
  :config
  (moody-replace-mode-line-front-space)
  (moody-replace-mode-line-buffer-identification)
  (moody-replace-vc-mode))

(leaf catppuccin-theme
  :ensure t
  :config (load-theme 'catppuccin :no-confirm))

(leaf org
  :ensure t
  :bind (("C-c l" . org-store-link)
	 ("C-c a" . org-agenda)
	 ("C-c c" . org-capture))
  :custom '((org-default-notes-file . "~/org/notes.org")
	    (org-agenda-files . '("~/org/"))))

(leaf ox-latex
  :after org
  :require t
  :config
  (add-to-list 'org-latex-classes
	       '("jlreq"
		 "\\documentclass[a4j,12pt]{jlreq}"
		 ("\\section{%s}" . "\\section*{%s}")
		 ("\\subsection{%s}" . "\\subsection*{%s}")
		 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
		 ("\\paragraph{%s}" . "\\paragraph*{%s}")
		 ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))

(leaf vertico
  :ensure t
  :custom '((vertico-count . 15))
  :config (vertico-mode))

(leaf consult
  :ensure t
  :bind (("M-s l" . consult-line)))

(leaf orderless
  :ensure t
  :custom '((completion-styles . '(orderless basic))))

(leaf ddskk
  :ensure t
  :bind (("C-x C-j" . skk-mode)
	 ("C-x j"   . skk-mode)))

(leaf neotree
  :ensure t
  :bind (("<f8>" . neotree-toggle)))

(provide 'init)

