(defconst rsense-mode-version "0.0.1"
  "The version of `rsense-mode'.")

(defvar rsense-executable
  (executable-find "rsense"))

(defvar cwd
  (file-name-directory (or load-file-name buffer-file-name)))

(defvar rsense-start-command
  (concat rsense-executable " start --path " cwd))

(defun start-rsense ()
  (shell-command rsense-start-command))
