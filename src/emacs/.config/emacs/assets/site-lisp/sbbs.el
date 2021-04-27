;;; sbbs.el --- SchemeBBS client -*- lexical-binding: t -*-


;; Downloaded from: https://fossil.textboard.org/sbbs
;; Modifications by: Maciej Barć
;; License: as original, CC0 1.0 Universal


;; Version: 0.1.0
;; Keywords: comm
;; Package-Requires: ((Emacs "24.4"))
;; Homepage: https://fossil.textboard.org/sbbs/home

;; This file is NOT part of Emacs.

;; This file is in the public domain, to the extent possible under law,
;; published under the CC0 1.0 Universal license.

;; For a full copy of the CC0 license see
;; https://creativecommons.org/publicdomain/zero/1.0/legalcode



;;; Commentary:

;; sbbs is a SchemeBBS (https://textboard.org) client in Emacs.
;; Start browsing a board by invoking M-x `sbbs'.



;;; Code:

(require 'button)
(require 'hl-line)
(require 'rx)
(require 'tabulated-list)
(require 'url)


;; CUSTOMIZABLE DATA

(defgroup sbbs nil
  "SchemeBBS client."
  :group 'applications
  :prefix "sbbs-")

(defcustom sbbs-boards
  '(("textboard.org" ("mona" "prog" "sol") t)
    ("bbs.jp.net" ("mona" "prog" "sol") t))
  "List of SchemeBBS sites and boards."
  :type '(repeat (list (string :tag "Board Domain")
                       (repeat (string :tag "Board Name"))
                       (boolean :tag "Use TLS?"))))

(defcustom sbbs-default-board nil
  "Jump to first link after narrowing posts."
  :type '(choice (const :tag "None" nil)
                 (cons (string :tag "Board Domain")
                       (string :tag "Board Name"))))

(defcustom sbbs-jump-to-link t
  "Jump to first link after narrowing posts."
  :type 'boolean)

(defcustom sbbs-recenter-to-top t
  "Move point to top of frame when moving through posts."
  :type 'boolean)

(defcustom sbbs-open-at-last-post t
  "Jump to last post in a thread when opening a thread."
  :type 'boolean)

(defface sbbs--spoiler-face
  '((((background light)) :background "black" :foreground "black")
    (((background dark)) :background "white" :foreground "white"))
  "Face for spoiler text in threads.")

(defface sbbs--uncover-spoiler-face
  '((((background light)) :background "black" :foreground "white")
    (((background dark)) :background "white" :foreground "black"))
  "Face for spoiler text in threads.")

(defface sbbs--code-face
  '((((background light)) :background "gray89" :extend t)
    (((background dark)) :background "gray11" :extend t))
  "Face for code blocks in threads.")

(defface sbbs--variable-pitch
  (if (and (window-system) (x-list-fonts "Mona-"))
      '((nil :font "Mona"
             :inherit variable-pitch))
    '((nil :inherit variable-pitch)))
  "Face for code blocks in threads.")

(defface sbbs--post-header-face
  '((nil :extend t
         :inherit highlight))
  "Face for post headers in the thread view.")


;; VARIABLES

(defvar-local sbbs--board nil
  "Buffer local reference to current board.

See `sbbs-make-board'.")

(defvar-local sbbs--thread-id nil
  "Buffer local reference to current thread id.

Used in thread and reply buffers.")

(defvar-local sbbs--limit-stack nil
  "Stack of last limit specs.")

(defvar-local sbbs--last-spoiler nil
  "Point of last spoiler visited.")


;; BOARD OBJECT AND FUNCTIONS

(defun sbbs-make-board (domain name &optional tls)
  "Create board object, using DOMAIN, NAME and TLS flag."
  (vector domain name tls))

(defsubst sbbs--board-domain (board)
  "Get domain part of a BOARD object."
  (aref board 0))

(defsubst sbbs--board-name (board)
  "Get board name part of a BOARD object."
  (aref board 1))

(defsubst sbbs--board-protocol (board)
  "Determine protocol to be used for BOARD object."
  (if (aref board 2) "https" "http"))

(defun sbbs--board-url (&optional path api-p board)
  "Generate URL for BOARD to access PATH.

If API-P is non-nil, prefix path with \"sexp\"."
  (let ((board (or board sbbs--board)))
    (format "%s://%s/%s%s/%s"
            (sbbs--board-protocol board)
            (sbbs--board-domain board)
            (if api-p "sexp/" "")
            (sbbs--board-name board)
            (or path ""))))

(defun sbbs--list-boards ()
  (let (boards)
    (dolist (ent sbbs-boards)
      (dolist (board (cadr ent))
        (push (sbbs-make-board (car ent) board (caddr ent))
              boards)))
    boards))

(defun sbbs-read-board ()
  "Read in a board using `completing-read'.

The list will be generated using `sbbs-boards', and the result
will be a board object generated with `sbbs-make-board'."
  (let (boards def)
    (dolist (b (sbbs--list-boards))
      (when (and sbbs-default-board
                 (string= (sbbs--board-domain b)
                          (car sbbs-default-board))
                 (string= (sbbs--board-name b)
                          (cdr sbbs-default-board)))
        (setq def b))
      (push (cons (format "%s/%s/"
                          (sbbs--board-domain b)
                          (sbbs--board-name b))
                  b)
            boards))
    (let ((choice (completing-read
                   (if def
                       (format "Board (default %s/%s): "
                               (sbbs--board-domain def)
                               (sbbs--board-name def))
                     "Board: ")
                   boards nil t "/" nil def)))
      (if (stringp choice)
          (cdr (assoc choice boards))
        choice))))


;; UTILITY FUNCTIONS

(defun sbbs--reload-thread (&optional _ignore-auto _noconfirm)
  "Function to reload an opened thread."
  (when sbbs--thread-id (sbbs-view-open sbbs--thread-id)))

(defun sbbs--reload-board ()
  "Function to regenerate thread index.

Called by `tabulated-list-mode' hooks."
  (when sbbs--board (sbbs-browse sbbs--board t)))

(defun sbbs--parse-number-range (desc limit)
  "Generate list of numbers, as specified by DESC.

To avoid memory overflows, limit number of entries to LIMIT."
  (save-match-data
    (apply #'nconc
           (mapcar
            (lambda (range)
              (cond
               ((string-match "\\`\\([[:digit:]]+\\)-\\([[:digit:]]+\\)\\'" range)
                (number-sequence (string-to-number (match-string 1 range))
                                 (min limit (string-to-number (match-string 2 range)))))
               ((string-match "\\`\\([[:digit:]]+\\)\\'" range)
                (list (string-to-number (match-string 1 range))))
               (t (error "Invalid range"))))
            (split-string desc ",")))))

(defun sbbs--read-jump-to (nr)
  "Set point to first character of post with number NR."
  (let ((up (point-min)) (down (point-max)) current)
    (while (progn
             (goto-char (+ up (/ (- down up) 2)))
             (setq current (get-text-property (point) 'sbbs-thread-nr))
             (/= nr current))
      (cond ((< nr current) (setq down (point)))
            ((> nr current) (setq up (point))))))
  (unless (and (eq 'highlight (get-text-property (point) 'face))
               (looking-at-p "\\`#[[:digit:]]+"))
    ;; in case we are on the first character of a post, we shouldn't
    ;; jump back, since that would mean setting to point to NR-1.
    (sbbs-read-previous 1)))


;; UI GENERATOR

(defconst sbbs--link-regexp
  (rx-to-string
   `(: bos
       (or (: "/" (group-n 2 (+ alnum))
              "/" (group-n 3 (+ digit))
              "/" (group-n 4 (: (+ digit) (? "-" (+ digit)))
                           (* "," (+ digit) (? "-" (+ digit)))))
           (: "http" (? "s") "://"
              (group-n 1 (or ,@(mapcar #'sbbs--board-domain
                                       (sbbs--list-boards))))
              "/" (group-n 2 (+ alnum))
              "/" (group-n 3 (+ digit))
              (? (or (: "/" (group-n 4 (: (+ digit) (? "-" (+ digit)))
                                     (* "," (+ digit) (? "-" (+ digit)))))
                     (: "#t" (backref 3)
                        "p" (group-n 4 (+ digit)))))))
       eos))
  "Regular expression to destruct internal links.")

(defun sbbs--limit-to-range (spec &optional no-push-p)
  "Hide all posts in the current thread, that aren't in SPEC.

Unless NO-PUSH-P is non-nil, SPEC will be pushed onto
`sbbs--limit-stack', as to be popped off again by
`sbbs-show-pop'."
  (let ((inhibit-read-only t))
    (remove-list-of-text-properties
     (point-min) (point-max) '(invisible intangible))
    (when spec
      (unless no-push-p
        (push (cons (point) spec) sbbs--limit-stack))
      (save-excursion
        (let ((last (point-max)))
          (goto-char last)
          (while (not (bobp))
            (sbbs-read-previous 1)
            (unless (memq (get-text-property (point) 'sbbs-thread-nr)
                          spec)
              (add-text-properties
               (point) last '(invisible t intangible t)))
            (setq last (point)))))
      (goto-char (point-min))
      (when spec
        (sbbs--read-jump-to (apply #'min spec)))
      (let ((point (point)))
        (when sbbs-jump-to-link
          (forward-button 1)
          (when (invisible-p (point))
            (goto-char point)))))))

(defun sbbs--insert-link (text link)
  "Insert link to LINK as TEXT into buffer.

If LINK is a (board, thread or site) local link, modify opening
behavior accordingly."
  (save-match-data
    (let ((match (string-match sbbs--link-regexp link))
          range id other)
      (when match
        (when (match-string 4 link)
          (setq range (sbbs--parse-number-range (match-string 4 link) 300)))
        (setq id (string-to-number (match-string 3 link)))
        (setq other (sbbs-make-board
                     (match-string 1 link)
                     (match-string 2 link)
                     (string-match-p "\\`https://" link))))
      (let* ((board sbbs--board)
             (domain (sbbs--board-domain board))
             (name (sbbs--board-name board))
             (func (lambda (&optional _)
                     (cond ((not match) (browse-url link))
                           ;; other supported board
                           ((or (and (sbbs--board-domain other)
                                     (not (string= (sbbs--board-domain other)
                                                   domain)))
                                (not (string= name (sbbs--board-name other))))
                            (let ((sbbs--board other))
                              (sbbs-view-open id range)))
                           ;; other thread
                           ((/= id sbbs--thread-id)
                            (let ((sbbs--board board))
                              (sbbs-view-open id range)))
                           ;; this thread
                           (range (sbbs--limit-to-range range))))))
        (insert-button (propertize text  'face 'sbbs--variable-pitch)
                       'action func 'sbbs-ref range)))))

(defun sbbs--insert-sxml-par (sxml)
  "Insert paragraph contents SXML at point."
  (dolist (it sxml)
    (cond ((stringp it)
           (insert (propertize it 'face 'sbbs--variable-pitch)))
          ((eq (car it) 'br)
           (newline))
          ((eq (car it) 'b)
           (insert (propertize (cadr it) 'face '(bold sbbs--variable-pitch))))
          ((eq (car it) 'i)
           (insert (propertize (cadr it) 'face '(italic sbbs--variable-pitch))))
          ((eq (car it) 'code)
           (insert (propertize (cadr it) 'face 'fixed-pitch)))
          ((eq (car it) 'del)
           (insert (propertize (cadr it) 'face 'sbbs--spoiler-face)))
          ((eq (car it) 'a)
           (let* ((text (caddr it))
                  (link (plist-get (cadadr it) 'href)))
             (sbbs--insert-link text link)))
          (t (insert (prin1-to-string it)))))
  (insert ?\n))

(defun sbbs--insert-sxml (sxml)
  "Insert top level SXML into buffer at point."
  (dolist (par sxml)
    (cond ((eq (car par) 'p)
           (sbbs--insert-sxml-par (cdr par)))
          ((eq (car par) 'blockquote)
           (let ((start (point))
                 (comment-start "> "))
             (sbbs--insert-sxml-par (cdadr par))
             (comment-region start (point))
             (add-face-text-property start (point)
                                     'font-lock-comment-face)))
          ((eq (car par) 'pre)
           (let ((start (point)))
             (insert (propertize (cadadr par)
                                 'face 'fixed-pitch))
             (newline)
             (add-face-text-property start (point) 'sbbs--code-face)))
          (t (error "Unknown top-level element")))
    (insert ?\n)))

(defun sbbs--thread-insert-post (post)
  "Prepare and Insert header and contents of POST at point."
  (let ((start (point)))
    (insert (format "#%d\t%s" (car post)
                    (cdr (assq 'date (cdr post)))))
    (when (cdr (assq 'vip (cdr post)))
      (insert " (VIP)"))
    (newline 2)
    (add-text-properties start (1- (point)) '(face sbbs--post-header-face))
    (set-text-properties (1- (point)) (point) nil)
    (sbbs--insert-sxml (cdr (assq 'content (cdr post))))
    (add-text-properties start (point) (list 'sbbs-thread-nr (car post)))))

(defun sbbs--uncover-spoiler ()
  "Show spoiler."
  (cond ((eq (get-text-property (point) 'face) 'sbbs--spoiler-face)
         (let* ((start (previous-property-change (1+ (point))))
                (end (next-property-change (point)))
                (o (make-overlay start end (current-buffer) t t)))
           (overlay-put o 'face 'sbbs--uncover-spoiler-face)
           (overlay-put o 'sbbs-uncover-p t))
         (setq sbbs--last-spoiler (point)))
        (sbbs--last-spoiler
         (dolist (o (overlays-at sbbs--last-spoiler))
           (when (overlay-get o 'sbbs-uncover-p)
             (delete-overlay o)))
         (setq sbbs--last-spoiler nil))))


;; URL.EL CALLBACKS

(defun sbbs--fix-encoding ()
  "Convert the raw response after point to utf-8."
  (save-excursion
    ;; see http://textboard.org/prog/39/263
    (set-buffer-multibyte nil)
    (while (search-forward-regexp
            ;; rx generates a multibyte string, that confuses
            ;; search-forward-regexp, therefore the regexp literal
            ;; here
            "[\x80-\xff]\\(\\(?:\\\\[0-7]\\{3\\}\\)+\\)"
            nil t)
      (let (new)
        (goto-char (match-beginning 1))
        (while (< (point) (match-end 1))
          (push (string-to-number (buffer-substring
                                   (+ (point) 1)
                                   (+ (point) 4))
                                  8)
                new)
          (forward-char 4))
        (replace-match (apply #'string (nreverse new))
                       nil t nil 1))))
  (set-buffer-multibyte t)
  (decode-coding-region (point) (point-max)
                        'utf-8))

(defun sbbs--board-loader (status buf)
  "Callback function for `url-retrieve' when loading board.

Load results into buffer BUF. STATUS is used to check for
errors."
  (when (buffer-live-p buf)
    (when (plist-get status :error)
      (error "Error while loading: %s"
             (cdr (plist-get status :error))))
    (forward-paragraph)
    (sbbs--fix-encoding)
    (let ((list (read (current-buffer))))
      (kill-buffer)
      (with-current-buffer buf
        (let (ent)
          (dolist (thread list)
            (push (list (car thread)
                        (vector (substring (cdr (assq 'date (cdr thread)))
                                           0 16)
                                (number-to-string
                                 (cdr (assq 'messages (cdr thread))))
                                (propertize
                                 (cdr (assq 'headline (cdr thread)))
                                 'face 'sbbs--variable-pitch)))
                  ent))
          (setq-local tabulated-list-entries ent)
          (tabulated-list-print t t)
          (hl-line-highlight))))))

(defun sbbs--thread-loader (status id buf range)
  "Callback function for `url-retrieve' when loading thread.

The attribute ID determines what thread from board BOARD to
load. STATUS is used to check for errors."
  (when (buffer-live-p buf)
    (when (plist-get status :error)
      (error "Error while loading: %s"
             (cdr (plist-get status :error))))
    (prog-mode)
    (forward-paragraph)
    (sbbs--fix-encoding)
    (save-excursion
      (save-match-data
        (while (search-forward "#f" nil t)
          (unless (cadddr (syntax-ppss))
            (replace-match "nil")))))
    (save-excursion
      (save-match-data
        (while (search-forward "#f" nil t)
          (unless (cadddr (syntax-ppss))
            (replace-match "t")))))
    (let ((thread (read (current-buffer))))
      (kill-buffer)
      (with-current-buffer buf
        (let ((buffer-read-only nil))
          (erase-buffer)
          (setq header-line-format
                (format "Thread %d: %s" id
                        (cdr (assq 'headline thread))))
          (dolist (post (cadr (assq 'posts thread)))
            (sbbs--thread-insert-post post))
          (delete-blank-lines)
          (when range
            (sbbs--limit-to-range range))
          (if sbbs-open-at-last-post
              (sbbs-goto-end)
            (goto-char (point-min))))))))


;; INTERACTIVE FUNCTIONS

(defun sbbs-show-all ()
  "Show all hidden posts."
  (interactive)
  (sbbs-show-pop -1))

(defun sbbs-show-pop (&optional n)
  "Show all hidden posts.

A prefix argument N, repeats this N times. If negative or zero,
pop all the way up."
  (interactive "P")
  (let ((n (or n 1)))
    (unless sbbs--limit-stack
      (message "Nothing left to pop"))
    (dotimes (_ (if (> n 0) n (length sbbs--limit-stack)))
      (let ((point (car (pop sbbs--limit-stack))))
        (sbbs--limit-to-range (cdar sbbs--limit-stack) t)
        (when point (goto-char point))))))

(defun sbbs-show-replies ()
  "Show all posts responding to post at point."
  (interactive)
  (let ((nr (get-text-property (point) 'sbbs-thread-nr))
        (point (point)) overlay range)
    (while (setq overlay (next-button point))
      (when (memq nr (overlay-get overlay 'sbbs-ref))
        (push (get-text-property (overlay-start overlay)
                                 'sbbs-thread-nr)
              range))
      (setq point (overlay-end overlay)))
    (if range
        (sbbs--limit-to-range range)
      (message "No posts referencing %d" nr))))

(defun sbbs-view-open (id &optional range)
  "Open thread ID in new buffer."
  (interactive (list (tabulated-list-get-id)))
  (let ((url (sbbs--board-url (format "/%d" id) t))
        (headline (or (and (not (tabulated-list-get-entry))
                           header-line-format)
                      (substring-no-properties
                       (aref (tabulated-list-get-entry) 2))))
        (board sbbs--board)
        (buf (get-buffer-create
              (format "*reading /%s/%d*"
                      (sbbs--board-name sbbs--board)
                      id))))
    (with-current-buffer buf
      (sbbs-read-mode)
      (when headline
        (setq header-line-format (format "Thread %d: %s" id headline)))
      (setq sbbs--board board
            sbbs--thread-id id))
    (url-retrieve url #'sbbs--thread-loader (list id buf range))
    (switch-to-buffer buf)))

(defun sbbs-view-compose ()
  "Create buffer to start a new thread."
  (interactive)
  (let ((board sbbs--board))
    (with-current-buffer (generate-new-buffer "*new thread*")
      (sbbs-compose-mode)
      (setq sbbs--board board)
      (switch-to-buffer (current-buffer)))))

(defun sbbs-read-reply (arg)
  "Create buffer to start a reply in current thread.

With \\[universal-argument] interactivly, or a non-nil ARG, add a
reply reference to thread at point."
  (interactive "P")
  (let ((id sbbs--thread-id)
        (nr (get-text-property (point) 'sbbs-thread-nr))
        (board sbbs--board))
    (with-current-buffer (generate-new-buffer "*new response*")
      (sbbs-compose-mode)
      (when (and arg (= (car arg) 4))
        (insert (format ">>%d" nr))
        (newline))
      (setq header-line-format (format "Responding to Thread %d" id)
            sbbs--thread-id id
            sbbs--board board)
      (switch-to-buffer (current-buffer)))))

(defun sbbs-compose-format (style)
  "Insert string STYLE around region or point."
  (save-excursion
    (if (region-active-p)
        (let ((beg (region-beginning))
              (end (region-end)))
          (goto-char end)
          (insert style)
          (goto-char beg)
          (insert style))
      (insert style style)))
  (when (< (point) (mark))
    (forward-char (length style))))

(defun sbbs-compose-format-code ()
  "Insert code syntax markers."
  (interactive)
  (sbbs-compose-format "```\n"))

(defun sbbs-compose-format-bold ()
  "Insert bold syntax markers."
  (interactive)
  (sbbs-compose-format "**"))

(defun sbbs-compose-format-italic ()
  "Insert italic syntax markers."
  (interactive)
  (sbbs-compose-format "__"))

(defun sbbs-compose-format-verbatim ()
  "Insert verbatim syntax markers."
  (interactive)
  (sbbs-compose-format "=="))

(defun sbbs-compose-format-spoiler ()
  "Insert spoiler syntax markers."
  (interactive)
  (sbbs-compose-format "~~"))

(defun sbbs-compose-unformat ()
  (interactive)
  (when (search-backward-regexp "\\(\\*\\*\\|==\\|__\\|~~\\)" nil t)
    (looking-at (concat "\\(" (regexp-quote (match-string 1)) "\\).*?"
                        "\\(" (regexp-quote (match-string 1)) "\\)"))
    (replace-match "" nil nil nil 2)
    (replace-match "" nil nil nil 1)))

(defun sbbs-compose-create ()
  "Upload response or thread to board."
  (interactive)
  (let ((board sbbs--board)
        (url-request-method "POST")
        (url-request-extra-headers
         '(("Content-Type" . "application/x-www-form-urlencoded")))
        (url-request-data
         (url-build-query-string
          `((epistula ,(buffer-string))
            (ornamentum "") (name "") (message "")
            (frontpage ,(if sbbs--thread-id "true" "false"))
            . ,(and (not sbbs--thread-id)
                    `((titulus ,(read-string "Headline: ")))))))
        (url (if sbbs--thread-id
                 (sbbs--board-url (format "%d/post" sbbs--thread-id))
               (sbbs--board-url "/post"))))
    (url-retrieve url (lambda (status buf)
                        (if (plist-get status :error)
                            (message "Error while submitting: %s"
                                     (cdr (plist-get status :error)))
                          (kill-buffer buf)
                          (let ((sbbs--board board))
                            (sbbs--reload-thread))))
                  (list (current-buffer)))))

(defun sbbs-read-next (arg)
  "Move point ARG posts forward."
  (interactive "p")
  (dotimes (_ arg)
    (end-of-line)
    (catch 'found
      (while (search-forward-regexp "^#" nil t)
        (when (and (eq 'sbbs--post-header-face (get-text-property (point) 'face))
                   (not (get-text-property (point) 'invisible)))
          (throw 'found t)))))
  (beginning-of-line)
  (when sbbs-recenter-to-top
    (set-window-start (selected-window) (point))))

(defun sbbs-read-previous (arg)
  "Move point ARG posts backwards."
  (interactive "p")
  (dotimes (_ arg)
    (catch 'found
      (while (search-backward-regexp "^#" nil t)
        (when (and (eq 'sbbs--post-header-face (get-text-property (point) 'face))
                   (not (get-text-property (point) 'invisible)))
          (throw 'found t)))))
  (beginning-of-line)
  (when sbbs-recenter-to-top
    (set-window-start (selected-window) (point))))

(defun sbbs-goto-end ()
  "Jump to last message in the curren thread."
  (interactive)
  (goto-char (point-max))
  (let ((sbbs-recenter-to-top nil))
    (sbbs-read-previous 1)))

;;;###autoload
(defun sbbs-browse (board reload)
  "Open thread overview for BOARD (if not RELOAD)."
  (interactive (list (sbbs-read-board) nil))
  (let* ((name (format "*browsing /%s/*" (sbbs--board-name board)))
         (url (sbbs--board-url "list" t board)))
    (if (and (get-buffer name) (not reload))
        (progn (switch-to-buffer name)
               (sbbs--reload-board))
      (with-current-buffer (get-buffer-create name)
        (sbbs-view-mode)
        (setq sbbs--board board)
        (url-retrieve url #'sbbs--board-loader
                      (list (current-buffer)))
        (switch-to-buffer (current-buffer))))))

;;;###autoload
(defalias 'sbbs #'sbbs-browse)


;; MAJOR MODES

(defvar sbbs-view-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "RET") #'sbbs-view-open)
    (define-key map (kbd "c") #'sbbs-view-compose)
    map))

(define-derived-mode sbbs-view-mode tabulated-list-mode "SchemeBBS Browse"
  "Major mode for browsing a SchemeBBS board."
  (buffer-disable-undo)

  (setq tabulated-list-format [("Date" 16 t)
                               ("#" 3 t :right-align t)
                               ("Headline" 0 nil)]
        tabulated-list-sort-key '("Date" . t))
  (add-hook 'tabulated-list-revert-hook
            #'sbbs--reload-board nil t)
  (tabulated-list-init-header)

  (hl-line-mode t))

(defvar sbbs-read-mode-map
  (let ((map (make-sparse-keymap)))
    (suppress-keymap map)
    (define-key map (kbd "<tab>") #'forward-button)
    (define-key map (kbd "TAB") #'forward-button)
    (define-key map (kbd "<backtab>") #'backward-button)
    (define-key map (kbd "r") #'sbbs-read-reply)
    (define-key map (kbd "n") #'sbbs-read-next)
    (define-key map (kbd "p") #'sbbs-read-previous)
    (define-key map (kbd "a") #'sbbs-show-pop)
    (define-key map (kbd "u") #'sbbs-show-pop)
    (define-key map (kbd "l") #'sbbs-show-pop)
    (define-key map (kbd "A") #'sbbs-show-all)
    (define-key map (kbd "f") #'sbbs-show-replies)
    (define-key map (kbd "e") #'sbbs-goto-end)
    (define-key map (kbd ">") #'sbbs-goto-end)
    map))

(define-derived-mode sbbs-read-mode special-mode "SchemeBBS Read"
  "Major mode for reading a thread."
  (buffer-disable-undo)
  (visual-line-mode t)
  (setq-local revert-buffer-function #'sbbs--reload-thread)
  (add-hook 'post-command-hook #'sbbs--uncover-spoiler
            nil t))

(defvar sbbs-compose-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c C-f C-b") #'sbbs-compose-format-bold)
    (define-key map (kbd "C-c C-f C-i") #'sbbs-compose-format-italic)
    (define-key map (kbd "C-c C-f C-v") #'sbbs-compose-format-verbatim)
    (define-key map (kbd "C-c C-f C-s") #'sbbs-compose-format-spoiler)
    (define-key map (kbd "C-c C-f C-c") #'sbbs-compose-format-code)
    (define-key map (kbd "C-c C-f C-d") #'sbbs-compose-unformat)
    (define-key map (kbd "C-c C-c") #'sbbs-compose-create)
    map))

(defvar sbbs--font-lock
  ;; stolen/based on from http://textboard.org/prog/81/5
  '(;; code
    ("^```\\(.*\n\\)*?```\n?" . 'sbbs--code-face)
    ;; bold
    ("\\*\\*[^ ].*?\\*\\*" . 'bold)
    ;; italic
    ("__[^ ].*?__" . 'italic)
    ;; monospaced
    ("==[^ ].*?==" . 'shadow)
    ;; spoiler
    ("~~[^ ].*?~~" . 'sbbs--spoiler-face)
    ;; references
    (">>\\([[:digit:]]+\\(?:-[[:digit:]]+\\)?\\(?:,[[:digit:]]+\\(?:-[[:digit:]]+\\)?\\)*\\)"
     . 'link)
    ;; quotes
    ("^>.*" . font-lock-comment-face))
  "Highlighting for SchemeBBS posts")

(define-derived-mode sbbs-compose-mode text-mode "SchemeBBS Compose"
  "Major mode for composing replies and starting new threads."
  (setq-local comment-start ">")
  (setq-local comment-start-skip "^>")
  (setq-local font-lock-defaults '(sbbs--font-lock))
  (setq-local font-lock-multiline t)
  (setq-local fill-column most-positive-fixnum)
  (message "Press C-c C-c to send"))

(provide 'sbbs)



;;; sbbs.el ends here
