(require 'find-file-in-project)
(require 'auto-complete)
(require 'json)

(defconst rsense-version "0.0.2"
  "The version of `rsense'.")

;; (defvar rsense-executable
;;   (executable-find "rsense"))

(defvar rsense-endpoint-uri
  "http://localhost:47367")

;;(setq rsense-endpoint-uri "http://localhost:47367")
;;(setq rsense-endpoint-uri "http://localhost:47368")
;;(setq rsense-endpoint-uri "http://localhost:4567")

;; (defun rsense-start-command ()
;;   (concat rsense-executable " start --path " default-directory))

;; (defun rsense-start ()
;;   (call-process-shell-command (rsense-start-command)))

(defun rsense/code-completion-request-body ()
  (json-encode `((command . code_completion)
                 (project . ,(ffip-project-root))
                 (file . ,buffer-file-name)
                 (code . ,(buffer-string))
                 ;;(code . "")
                 (location . ((row . ,(line-number-at-pos))
                              (column . ,(1+ (current-column))))))))

(defun rsense/completions ()
  (let* ((response (rsense-http/post (rsense/code-completion-request-body)))
         (status-hash (car response))
         (body (cadr response))
         (parsed (json-read-from-string body))
         (completions (cdr (assoc 'completions parsed))))
    ;;(prin1 completions)
    (mapcar (lambda (el) (cdr (assoc 'name el))) completions)))


(ac-define-source rsense
  '((candidates . rsense/completions)
    (prefix . "\\(?:\\.\\|::\\)\\(.*\\)")
    ;;(prefix . "\\.\\(.*\\)")
    (requires . 0)
    ;;(document . ac-rsense-documentation)
    (cache)))

(defun rsense/ac-complete ()
  (interactive)
  (setq ac-sources '(ac-source-rsense)))

(provide 'rsense)
