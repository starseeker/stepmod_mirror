; Author: Craig Lanning <CLanning@users.sf.net&gt;
; Modified by: Tom Hendrix, thomas.e.hendrix@boeing.com
;; Keywords: languages, step, iso

;; Code:
;;(provide 'express)

;;(require 'compile)
;;(require 'font-lock)

;; select Express-Mode for *.exp files

;;TEH notes: 
;;    Not tested with XEmacs.
;;    Tail remarks dont work if they contain a single quote.
;;    There is a lot of cruft that either Craig or I added 
;;        while figuring out how major modes work.
;;end TEH notes.
 
;;;###autoload
(pushnew '("\\.exp\\'" . express-mode) auto-mode-alist
	 :test (lambda (x y) (equal (car x) (car y))))

(defconst express-mode-version "Express-Mode 0.1"
  "Version of `express.el'.")

(defgroup express nil
  "Major mode for editing Express schemata in Emacs"
  :group 'languages)

(defvar express-mode-abbrev-table nil
  "Abbrev table for Express mode.")
(define-abbrev-table 'express-mode-abbrev-table '())

(defvar express-mode-syntax-table nil
  "Syntax table for Express mode.")
;; comment out 'if' on next line to force execution during bytc-compile. 
(if  
   (not express-mode-syntax-table)
    (let ((i 0))
      (setq express-mode-syntax-table (make-syntax-table))
      (while (< i ?0)
	(modify-syntax-entry i "_   " express-mode-syntax-table)
	(incf i))
      (while (< i (1+ ?9))
	(modify-syntax-entry i "w   " express-mode-syntax-table)
	(setq i (1+ i)))
      (while (< i ?A)
	(modify-syntax-entry i "_   " express-mode-syntax-table)
	(incf i))
      (while (< i (1+ ?Z))
	(modify-syntax-entry i "w   " express-mode-syntax-table)
	(setq i (1+ i)))
      (while (< i ?a)
	(modify-syntax-entry i "_   " express-mode-syntax-table)
	(incf i))
      (while (< i (1+ ?z))
	(modify-syntax-entry i "w   " express-mode-syntax-table)
	(setq i (1+ i)))
      (while (< i 128)
	(modify-syntax-entry i "_   " express-mode-syntax-table)
	(incf i))

      ;; add (modify-syntax-entry ...) forms
      (modify-syntax-entry ?\   "    " express-mode-syntax-table)
      (modify-syntax-entry ?\t  "    " express-mode-syntax-table)
      (modify-syntax-entry ?\f  "    " express-mode-syntax-table)
;      (modify-syntax-entry ?\n  ">   " express-mode-syntax-table)
      (modify-syntax-entry ?\^m ">   " express-mode-syntax-table)
      (modify-syntax-entry ?\[  "(]  " express-mode-syntax-table)
      (modify-syntax-entry ?\]  ")[  " express-mode-syntax-table)
      (modify-syntax-entry ?\(  "()1 " express-mode-syntax-table)  
      (modify-syntax-entry ?\)  ")(4 " express-mode-syntax-table)
      (modify-syntax-entry ?\*  ". 23" express-mode-syntax-table)

      ;; if this is uncommented then XEmacs dies during syntactic
      ;; fontification of large EXPRESS files
      ;; teh - changes not tested with XEmacs.
;      (modify-syntax-entry ?-  ". 56"  express-mode-syntax-table)
      (modify-syntax-entry ?-  ".   "  express-mode-syntax-table)
;      (modify-syntax-entry ?\n "> b"  express-mode-syntax-table)
      (modify-syntax-entry ?\' "\"   " express-mode-syntax-table)
      (modify-syntax-entry ?_  "_   "  express-mode-syntax-table)
;; teh add _ to the word characters - seems to work.
      (modify-syntax-entry ?\_  "w   "  express-mode-syntax-table)
      (modify-syntax-entry ?>  ".   "  express-mode-syntax-table)
      (modify-syntax-entry ?<  ".   "  express-mode-syntax-table)
      (modify-syntax-entry ?:  ".   "  express-mode-syntax-table)
      (modify-syntax-entry ?\; ".   "  express-mode-syntax-table)
      (modify-syntax-entry ?\\ ".   "  express-mode-syntax-table)
      (modify-syntax-entry ?\/ ".   "  express-mode-syntax-table)
      (modify-syntax-entry ?+  ".   "  express-mode-syntax-table)
      (modify-syntax-entry ?\. ".   "  express-mode-syntax-table)
      )
;; comment out next close paren  to force execution 
;; during byte-compile, for debugging  
)



;;; Menus stuff
;;(defvar express-mode-popup-menu nil)
;;(defvar express-mode-popup-menu-1
;;	(purecopy '("Express"
;;		    ["Insert ENTITY"    express-insert-entity    nil]
;;		    ["Insert FUNCTION"  express-insert-function  nil]
;;		    ["Insert PROCEDURE" express-insert-procedure nil]
;;		    ["Insert RULE"      express-insert-rule      nil]
;;		    ["Insert SCHEMA"    express-insert-schema    nil]
;;		    ["Insert TYPE"      express-insert-type      nil]
;;		    "---"
;;		    ["Upcase Keywords in Buffer" express-upcase-buffer-keywords nil]
;;		    ["Upcase Keywords in Region" express-upcase-region-keywords nil] ;;(region-exists-p)]
;;		    "---"
;;		    ["Comment Out Region" express-comment-region nil] ;;(region-exists-p)]
;;		    "---"
;;		    ["Indent Buffer" express-indent-buffer nil]
;;		    ["Indent Region" express-indent-region nil] ;;(region-exists-p)]
;;		    )))

;(defun express-mode-variables (express-syntax)
;  (cond (express-syntax
;	 (set-syntax-table express-mode-syntax-table)))
;  (setq local-abbrev-table express-mode-abbrev-table)
;  ;; not sure what else to put here
;  )


;; not used..
(defvar express-keywords
  '("ABSTRACT" "AGGREGATE" "ALIAS" "ARRAY" "AS" "BAG" 
	"BASED_ON" 
	"BEGIN" "BINARY" "BOOLEAN"
    "BY" "CASE" "CONSTANT" "CONTEXT" "DERIVE" "ELSE" "END" "END_ALIAS" "END_CASE"
    "END_CONSTANT" "END_CONTEXT" "END_ENTITY" "END_FUNCTION" 
	"END_SUBTYPE_CONSTRAINT" 
	"END_IF" "END_LOCAL"
    "END_MODEL" "END_PROCEDURE" "END_REPEAT" "END_RULE" "END_SCHEMA" "END_TYPE"
    "ENTITY" "ENUMERATION" "ESCAPE"  "EXTENSIBLE"
    "FIXED" "FOR" "FROM" "FUNCTION" "GENERIC" 
	"GENERIC_ENTITY"  
	"IF"
    "INSERT" "INTEGER" "INVERSE" "LIST" "LOCAL" "LOGICAL" "MODEL" "NUMBER" "OF"
    "ONEOF" "OPTIONAL" "OTHERWISE" "PROCEDURE" "QUERY" "REAL" "REFERENCE" "REMOVE" 
	"RENAMED"
    "REPEAT" "RETURN" "RULE" "SCHEMA" "SELECT" "SET" "SKIP" "STRING" "SUBTYPE" 
	"SUBTYPE_CONSTRAINT" "TOTAL_OVER"
    "SUPERTYPE" "THEN" "TO" "TYPE" "UNIQUE" "UNTIL" "USE" "VAR" "WHERE" "WHILE" 
	"WITH"))

(defvar express-operators
  '("AND" "ANDOR" "DIV" "IN" "LIKE" "MOD" "NOT" "OR" "XOR"))

(defvar express-constants
  '("?" "CONST_E" "FALSE" "PI" "SELF" "TRUE" "UNKNOWN"))

(defvar express-functions
  '("ABS" "ACOS" "ASIN" "ATAN" "BLENGTH" "COS" "EXISTS" "EXP" "FORMAT"
    "HIBOUND" "HIINDEX" "LENGTH" "LOBOUND" "LOG" "LOG2" "LOG10" "LOINDEX"
    "NVL" "ODD" "ROLESOF" "SIN" "SIZEOF" "SQRT" "TAN" "TYPEOF" "USEDIN" "VALUE"))

(defvar express-procedures
  '("INSERT" "REMOVE"))

;; end not used.

(defvar express-mode-map nil
  "Keymap for Express mode.")

(if express-mode-map ()
    (setq express-mode-map (make-sparse-keymap))
;;    (set-keymap-name express-mode-map 'express-mode-map)
    ;; define Express specific key bindings
;;    (define-key express-mode-map "\M-;" 'express-indent-for-comment)
;;    (define-key express-mode-map "\e\C-q" 'express-indent-definition)
    )

;;;###autoload

;;;
;;; Font-Lock/Colorizing stuff
;;;

;;; fontified by syntax:
;; font-lock-comment-face		(* ... *)
;; font-lock-string-face		'string'

;;; fontified by regexp:
;; font-lock-comment-face		-- ...
;; font-lock-doc-string-face
;; font-lock-keyword-face		various EXPRESS words
;; font-lock-function-name-face		[a-z][a-z0-9_]*
;; font-lock-variable-name-face		SELF
;; font-lock-type-face			ARRAY BAG SET LIST STRING NUMBER INTEGER REAL <etc>
;; font-lock-reference-face
;; font-lock-preprocessor-face
;; font-lock-warning-face

(defvar express-flkw-1 nil)
(defvar express-mode-font-lock-keywords-1 nil
  "Minimum highlighting for EXPRESS mode.")

(setq express-flkw-1
      (purecopy
       (list
	'("--.*[\n\r]" . font-lock-comment-face)
	'("\\<\\(ENTITY\\|TYPE\\)\\>[ \t]+\\([a-zA-Z][a-z0-9A-Z_]*\\)"
	  (1 font-lock-keyword-face)
	  (2 font-lock-type-face))
	'("\\<\\(FUNCTION\\|PROCEDURE\\|RULE\\)\\>[ \t]+\\([a-zA-Z][a-z0-9A-Z_]*\\)"
	  (1 font-lock-keyword-face)
	  (2 font-lock-function-name-face))
	'("\\<\\(SCHEMA\\)\\>[ \t]+\\([a-zA-Z][a-z0-9A-Z_]*\\)"
	  (1 font-lock-keyword-face)
	  (2 font-lock-variable-name-face))
	'("\\<\\(CONSTANT\\|END_TYPE\\(SCHEMA\\|CONSTANT\\)\\)\\>"
	  . font-lock-keyword-face)
	)
       ))

(setq express-mode-font-lock-keywords-1 express-flkw-1)


(defvar express-flkw-2 nil)
(defvar express-mode-font-lock-keywords-2 nil
  "Medium highlighting for EXPRESS mode.")

(setq express-flkw-2
      (list
       '("\\<\\(DERIVE\\|INVERSE\\|UNIQUE\\|WHERE\\)\\>"
	 . font-lock-keyword-face)
       '("\\<\\(ABSTRACT\\|SUPERTYPE\\|SUBTYPE\\|FOR\\|OF\\|ONEOF\\|OPTIONAL\\)\\>"
	 1 font-lock-keyword-face)
       '("\\<\\(SELECT\\|ENUMERATION\\)\\>" . font-lock-keyword-face)
       (cons (concat "\\<\\(NUMBER\\|REAL\\|INTEGER\\|STRING\\|BOOLEAN\\|LOGICAL\\|"
		     "GENERIC\\|LIST\\|SET\\|BAG\\|ARRAY\\|AGGREGATE\\)\\>")
	     'font-lock-type-face)
       ))

(setq express-mode-font-lock-keywords-2
      (purecopy
       (append
	express-flkw-1
	express-flkw-2
	)))

(defvar express-flkw-3 nil)
(defvar express-mode-font-lock-keywords-3 nil
  "Maximum highlighting for EXPRESS mode.")

(setq express-flkw-3
      (list
       '("\\<END_\\(ENTITY\\|FUNCTION\\|PROCEDURE\\|RULE\\|TYPE\\|SCHEMA\\|CONSTANT\\)\\>"
	 . font-lock-keyword-face)
       '("\\<\\(IN\\|QUERY\\|SUBTYPE\\|OF\\|FROM\\|USE\\|REFERENCE\\)\\>"
	 . font-lock-keyword-face)
       ;; EXPRESS Operators
       '("\\<\\(AND\\|ANDOR\\|DIV\\|IN\\|LIKE\\|MOD\\|NOT\\|OR\\|XOR\\)\\>"
	 . font-lock-function-name-face)
       ;; EXPRESS Functions
       (cons (concat "\\<\\(ABS\\|ACOS\\|ASIN\\|ATAN\\|BLENGTH\\|COS\\|EXISTS\\|"
		     "EXP\\|FORMAT\\|HIBOUND\\|HIINDEX\\|LENGTH\\|"
		     "LO\\(BOUND\\|G\\|G2\\|G10\\|INDEX\\)\\|NVL\\|ODD\\|ROLESOF\\|"
		     "SIN\\|SIZEOF\\|SQRT\\|TAN\\|TYPEOF\\|USEDIN\\|VALUE\\)\\>")
	     'font-lock-function-name-face)
       ;; EXPRESS Constants
       '("\\<\\(\\?\\|CONST_E\\|FALSE\\|PI\\|SELF\\|TRUE\\|UNKNOWN\\)\\>"
	 . font-lock-variable-name-face)
       ;; EXPRESS Procedures
       '("\\<\\(insert\\|remove\\)\\>" . font-lock-function-name-face)
	 ))

(setq express-mode-font-lock-keywords-3
      (purecopy
       (append
	express-flkw-1
	express-flkw-2
	express-flkw-3
	)))


;; teh added


(defvar express-flkw-4 nil)
(defvar express-mode-font-lock-keywords-4 nil
  "Express e2 highlighting for EXPRESS mode.")

(setq express-flkw-4
      (list
       '("\\<\\(generic_entity\\|based_on\\|with\\)\\>"
	 . font-lock-keyword-face)
	   ))


(setq express-mode-font-lock-keywords-4
      (purecopy
       (append
	express-flkw-1
	express-flkw-2
	express-flkw-3
	express-flkw-4
	)))


(defun express-mode ()
  "Major mode for editing Express schemata in Emacs.
 (add some details later)."
  (interactive)
  (kill-all-local-variables)
  (use-local-map express-mode-map)
  (setq major-mode 'express-mode)
  (setq mode-name  "Express")
  (setq local-abbrev-table express-mode-abbrev-table)
  (set-syntax-table express-mode-syntax-table)
  (setq case-fold-search t)
;  (unless express-mode-popup-menu
;    (easy-menu-define express-mode-popup-menu express-mode-map ""
;		      express-mode-popup-menu-1))
;  (easy-menu-add express-mode-popup-menu)
;  (express-mode-variables nil)
;  (font-lock-set-defaults nil)
  (run-hooks 'express-mode-hook)

(make-local-variable 'font-lock-keywords)
(setq font-lock-keywords  express-mode-font-lock-keywords-4)

(make-local-variable 'font-lock-defaults)
(setq font-lock-defaults '(font-lock-keywords t))
(setq font-lock-mark-block-function 'express-font-lock-mark-block-function)

)

(provide 'express)

;;; express.el ends here
