(defconst rsense-mode-version "0.0.1"
  "The version of `rsense-mode'.")

(defvar rsense-executable
  (executable-find "rsense"))

(defvar rsense-client-executable
  (executable-find "_rsense_commandline.rb"))

(defvar rsense-start-command
  (concat rsense-executable " start --path " cwd))

(defvar current-position
  (format "%s:%s" (line-number-at-pos) (current-column)))

(defvar autocomplete-command
  (concat rsense-client-executable
          " --project="  default-directory
          " --filepath=" buffer-file-name
          " --text=" (buffer-string)
          " --location=" current-position))

(defun start-rsense ()
  (call-process-shell-command rsense-start-command))

;; This doesn't actually autocomplete yet...
;; It just invokes the command line client.
(defun rsense-complete
  (shell-command autocomplete-command))

;; Can't get the keymap quite right :( Don't want to replace all tabs...
;; just when the cursor is on non-whitespace...
(define-minor-mode rsense-mode
  "RSense sees all."
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "TAB") 'rsense-complete)
            map))

(provide 'rsense-mode)
