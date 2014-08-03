;; borrowed from web
(defun rsense-http/parse-headers (data)
  "Parse an HTTP response header.

Each header line is stored in the hash with a symbol form of the
header name.

The status line is expected to be the first line of the data.
The status is stored in the header as well with the following
keys:

  status-version
  status-code
  status-string

which are stored as symbols the same as the normal header keys."
  (let* ((header-hash (make-hash-table :test 'equal))
         (header-lines (split-string data "\r\n"))
         (status-line (car header-lines)))
    (when (string-match
           "HTTP/\\([0-9.]+\\) \\([0-9]\\{3\\}\\)\\( \\(.*\\)\\)*"
           status-line)
      (puthash 'status-version (match-string 1 status-line) header-hash)
      (puthash 'status-code (match-string 2 status-line) header-hash)
      (puthash 'status-string
               (or (match-string 4 status-line) "")
               header-hash))
    (loop for line in (cdr header-lines)
       if (string-match
           "^\\([A-Za-z0-9.-]+\\):[ ]*\\(.*\\)"
           line)
       do
         (let ((name (intern (downcase (match-string 1 line))))
               (value (match-string 2 line)))
           (puthash name value header-hash)))
    header-hash))

(defun rsense-http/parse-response ()
  "Parse a complete HTTP response, status code, headers, body.
Expects the current buffer to contain the response."
  (goto-char (point-min))
  (or (re-search-forward "\r\n\r\n" nil t)
      (re-search-forward "\n\n" nil t))
  (let ((hdr (rsense-http/parse-headers (buffer-substring (point-min) (point-max))))
        (part-data (if (> (point-max) (point))
                       (buffer-substring (point) (point-max))
                     nil)))
    `(,hdr ,part-data)))

(defun rsense-http/post (body)
  (let ((url-request-method        "POST")
        (url-request-extra-headers `(("Content-Type" . "application/json")))
        (url-request-data          body))
	  (with-current-buffer (url-retrieve-synchronously rsense-endpoint-uri)
      (rsense-http/parse-response))))

(provide 'rsense-http)
