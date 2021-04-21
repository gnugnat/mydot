;;; neko-mode.el --- Major mode for editing Neko source code files


;; This file is part of mydot.

;; mydot is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, version 3.

;; mydot is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with mydot.  If not, see <https://www.gnu.org/licenses/>.

;; Copyright (c) 2020-2021, Maciej Barć <xgqt@riseup.net>
;; Licensed under the GNU GPL v3 License



;;; Commentary:


;; Initially based on haxe-mode by Jens Peter Secher:
;; https://github.com/emacsorphanage/haxe-mode



;;; Code:

(require 'cc-bytecomp)
(require 'cc-fonts)
(require 'cc-langs)
(require 'cc-mode)
(require 'compile)
(require 'prog-mode)

;; The language constants are needed when compiling.
(eval-when-compile
  (let
      (
       (load-path
        (if (and (boundp 'byte-compile-dest-file)
                 (stringp byte-compile-dest-file))
            (cons (file-name-directory byte-compile-dest-file) load-path)
          load-path)
        )
       )
    (load "cc-mode" nil t)
    (load "cc-fonts" nil t)
    (load "cc-langs" nil t)
    (load "cc-bytecomp" nil t)
    (load "prog-mode" nil t)
    )
  )

(eval-and-compile
  ;; Tell the language constant system about Neko and base it on Java.
  (c-add-language 'neko-mode 'c-mode)
  )

;;; Lexer-level syntax (identifiers, tokens etc).

;; No other operators in identifiers.
(c-lang-defconst c-after-id-concat-ops
  neko nil
  )

;; Conditional compilation prefix.
(c-lang-defconst c-opt-cpp-prefix
  neko "\\s *#"
  )

;; No strings in conditional compilation.
(c-lang-defconst c-cpp-message-directives
  neko nil
  )

;; No file name in angle brackets or quotes in conditional compilation.
(c-lang-defconst c-cpp-include-directives
  neko nil
  )

;; No macro definition in conditional compilation.
(c-lang-defconst c-opt-cpp-macro-define
  neko nil
  )

;; Conditional compilation directives followed by expressions.
(c-lang-defconst c-cpp-expr-directives
  neko '("if" "else")
  )

;; No functions in conditional compilation.
(c-lang-defconst c-cpp-expr-functions
  neko nil
  )

;; Neko operators.
(c-lang-defconst c-operators
  neko `(
         ;; Preprocessor.
         (prefix "#")
         ;; Standard operators.
         ,@(c-lang-const c-identifier-ops)
         ;; Generics.
         (postfix-if-paren "<" ">")
         ;; Postfix.
         (left-assoc "." "->")
         (postfix "++" "--" "[" "]" "(" ")")
         ;; Unary.
         (prefix "++" "--" "+" "-" "!" "~" "new")
         ;; Multiplicative.
         (left-assoc "*" "/" "%")
         ;; Additive.
         (left-assoc "+" "-")
         ;; Shift.
         (left-assoc "<<" ">>" ">>>")
         ;; Relational.
         (left-assoc "<" ">" "<=" ">=")
         ;; Iteration.
         (left-assoc "...")
         ;; Equality.
         (left-assoc "==" "!=" "===" "!==")
         ;; Bitwise and.
         (left-assoc "&")
         ;; Bitwise exclusive or.
         (left-assoc "^")
         ;; Bitwise or.
         (left-assoc "|")
         ;; Logical and.
         (left-assoc "&&")
         ;; Logical or.
         (left-assoc "||")
         ;; Assignment.
         (right-assoc ,@(c-lang-const c-assignment-operators))
         ;; Exception.
         (prefix "throw")
         ;; Sequence.
         (left-assoc ",")
         )
  )

;; No overloading.
(c-lang-defconst c-overloadable-operators
  neko nil
  )
(c-lang-defconst c-opt-op-identitier-prefix
  neko nil
  )


;;; Keywords.

;; I will treat types uniformly below since they all start with capital
;; letters.
(c-lang-defconst c-primitive-type-kwds
  neko nil
  )

;; TODO: check double occurrence of enum.
;; Type-introduction is straight forward in Neko.
(c-lang-defconst c-class-decl-kwds
  neko '( "class" "interface" "enum" "typedef" "abstract" )
  )

;; Recognises enum constants.
;; TODO: find a way to also recognise parameterised constants.
(c-lang-defconst c-brace-list-decl-kwds
  neko '( "enum" )
  )

;; Keywords introducing declarations where the identifier follows directly
;; after the keyword, without any type.
(c-lang-defconst c-typeless-decl-kwds
  neko (append '( "function" "var" )
               (c-lang-const c-class-decl-kwds)
               (c-lang-const c-brace-list-decl-kwds)
               )
  )

;; Definition modifiers.
(c-lang-defconst c-modifier-kwds
  neko '( "private" "public" "static" "override" "inline")
  )
(c-lang-defconst c-other-decl-kwds
  neko nil
  )

;; Namespaces.
(c-lang-defconst c-ref-list-kwds
  neko '( "import" "package" "using")
  )

;; Statement keywords followed directly by a substatement.
(c-lang-defconst c-block-stmt-1-kwds
  neko '( "do" "else" "try" )
  )

;; Statement keywords followed by a paren sexp and then by a substatement.
(c-lang-defconst c-block-stmt-2-kwds
  neko '( "for" "if" "switch" "while" "catch" )
  )

;; Statement keywords followed by an expression or nothing.
(c-lang-defconst c-simple-stmt-kwds
  neko '( "break" "continue" "return" "default" "new" )
  )

;; No ';' inside 'for'.
(c-lang-defconst c-paren-stmt-kwds
  neko nil
  )

;; Keywords for constants.
(c-lang-defconst c-constant-kwds
  neko '( "false" "true" "null" )
  )

;; Keywords for expressions.
(c-lang-defconst c-primary-expr-kwds
  neko '( "this" "super" )
  )

(c-lang-defconst c-decl-hangon-kwds
  neko '( "in" )
  )

;; No other labels.
(c-lang-defconst c-before-label-kwds
  neko nil
  )

;; No classes inside expressions.
(c-lang-defconst c-inexpr-class-kwds
  neko nil
  )

;; No brace lists inside expressions.
(c-lang-defconst c-inexpr-brace-list-kwds
  neko nil
  )

;; All identifiers starting with a capital letter are types.
(c-lang-defconst c-cpp-matchers
  neko (append
        (c-lang-const c-cpp-matchers c)
        '(("\\<\\([A-Z][A-Za-z0-9_]*\\)\\>" 1 font-lock-type-face))
        )
  )

;; Generic types.
(c-lang-defconst c-recognize-<>-arglists
  neko t
  )

;; Fontification degrees.
(defconst neko-font-lock-keywords-1 (c-lang-const c-matchers-1 neko)
  "Minimal highlighting for neko mode.")
(defconst neko-font-lock-keywords-2 (c-lang-const c-matchers-2 neko)
  "Fast normal highlighting for neko mode.")
(defconst neko-font-lock-keywords-3 (c-lang-const c-matchers-3 neko)
  "Accurate normal highlighting for neko mode.")
(defvar neko-font-lock-keywords neko-font-lock-keywords-3
  "Default expressions to highlight in neko mode.")

(defvar neko-mode-syntax-table nil
  "Syntax table used in Neko mode buffers.")
(or neko-mode-syntax-table
    (setq neko-mode-syntax-table
          (funcall (c-lang-const c-make-mode-syntax-table neko))
          )
    )

(defvar neko-mode-abbrev-table nil
  "Abbreviation table used in neko mode buffers.")
(c-define-abbrev-table
 'neko-mode-abbrev-table
 ;; Keywords that, if they occur first on a line, might alter the
 ;; syntactic context, and which therefore should trigger
 ;; reindentation when they are completed.
 '(
   ("else" "else" c-electric-continued-statement 0)
   ("while" "while" c-electric-continued-statement 0)
   ("catch" "catch" c-electric-continued-statement 0)
   )
 )

(defvar neko-mode-map ()
  "Keymap used in neko mode buffers.")
(if neko-mode-map
    nil
  (setq neko-mode-map (c-make-inherited-keymap))
  )

(add-to-list 'auto-mode-alist '("\\.neko\\'" . neko-mode))

;; Tell compilation-mode how to parse error messages.  You need to set
;; compilation-error-screen-columns to nil to get the right
;; interpretation of tabs.
(add-to-list 'compilation-error-regexp-alist
             '("^\\([^: ]+\\):\\([0-9]+\\): characters \\([0-9]+\\)-[0-9]+ : "
               1 2 3)
             )

(defcustom neko-mode-hook nil
  "*Hook called by `neko-mode'."
  :type 'hook
  :group 'c
  )

(defun neko-mode ()
  "Major mode for editing Neko source code files."
  (interactive)
  (kill-all-local-variables)
  (c-initialize-cc-mode t)
  (set-syntax-table neko-mode-syntax-table)
  (setq
   major-mode 'neko-mode
   mode-name "Neko"
   local-abbrev-table neko-mode-abbrev-table
   abbrev-mode t
   )
  (use-local-map neko-mode-map)
  ;; `c-init-language-vars' is a macro that is expanded at compile
  ;; time to a large `setq' with all the language variables and their
  ;; customized values for our language.
  (c-init-language-vars neko-mode)
  ;; `c-common-init' initializes most of the components of a CC Mode
  ;; buffer, including setup of the mode menu, font-lock, etc.
  ;; There's also a lower level routine `c-basic-common-init' that
  ;; only makes the necessary initialization to get the syntactic
  ;; analysis and similar things working.
  (c-common-init 'neko-mode)
  (run-hooks 'c-mode-common-hook 'neko-mode-hook)
  (c-update-modeline)
  )


(provide 'neko-mode)



;;; neko-mode.el ends here
