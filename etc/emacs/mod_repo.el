;;; $Id: mod_repo.el,v 1.14 2003/04/23 14:59:32 robbod Exp $
;;;  Author:  Rob Bodington, Eurostep Limited
;;;  Purpose: A set of facilities for editing the stepmod files
;;;           Set the global variable modrep-home


(defcustom modrep-home 
  *stepmod_home* 
  "Base directory set in users .emacs"
  :type 'sexp)

;; example users .emacs

;; (setq *stepmod_home* 
;;      "e:/rbn/projects/nist_module_repo/stepmod/")
;; ......

;; (setq load-path (append (list nil (concat *stepmod_home* "etc/emacs") ) load-path))

;; (setq *user* "Tom Hendrix" )
;; (setq *prefix* "TEH-" )
;; (setq *schema* "plcs-core" )
;; (setq *org* "Boeing" )
;; (setq *notice*  "Developed by Eurostep and supplied to NIST under contract.")

;; (load "mod_repo")

;; end example users .emacs 

(defcustom modrep-issue-schema 
  *schema*
  "Schema entered into comment"
  :type 'sexp)

(defcustom modrep-issue-prefix 
  *prefix*
  "Comment prefix"
  :type 'sexp)

(defcustom modrep-user 
  *user*
  "MODREP user with whom comment is associated"
  :type 'sexp)

(defcustom modrep-org 
  *org*
  "My organization"
  :type 'sexp)

(defcustom modrep-owner-notice
  *notice*
  "My organizations copyright notice"
  :type 'sexp)

(defvar month-alist
  '(
    ("Jan" "01") ("January" "01")
    ("Feb" "02") ("February" "02")
    ("Mar" "03") ("March" "03")
    ("Apr" "04") ("April" "04")
    ("May" "05")
    ("Jun" "06") ("June" "06")
    ("Jul" "07") ("July" "07")
    ("Aug" "08") ("August" "08")
    ("Sep" "09") ("Sept" "09") ("September" "09")
    ("Oct" "10") ("October" "10")
    ("Nov" "11") ("November" "11")
    ("Dec" "11") ("December" "12")
    )
  "List of months")

(defun modrep-date()
  (let* ((month
	  (assoc (substring (current-time-string) 4 7)
		      month-alist)))
    (setq month (cadr month))
    (format "%s-%s-%s"
	    (substring (current-time-string) 22 24)
	    month
	    (substring (current-time-string) 8 10)
	     " ")
    )
  )

(defun modrep-issue-id ()
  ""
  (interactive)
  (save-excursion    
    (let ((id (format "id=\"%s" modrep-issue-prefix ))
	  (no-comments 0)
	  cnt pos beg)
      (setq pos (point))
      (goto-char 1)
      (while (search-forward id nil t)
	(setq beg (point))
	(search-forward "\"" nil t)
	(setq cnt (string-to-number (buffer-substring beg (point))))
	(setq no-comments (max cnt no-comments))
	)
      (goto-char pos)
      (format "%s" (+ 1 no-comments))
      )
    )
)

(defun modrep-issue-ref()
  (format "%s%s"
	  modrep-issue-prefix
	  (modrep-issue-id)
	  )
  )



(defun modrep-module-name ()
  (interactive)
  (let ((bdir (file-name-directory (buffer-file-name)))
	)
    ;; remove the last /
    (file-name-nondirectory (substring bdir 0 (- (length bdir) 1)))
    )
)


;;; Insert WG Number and header into arm.exp and mim.exp files
;;; It will also remove any comments etc prior to the fisrt schema declaration.
(defun modrep-insert-wgn (type)
  (let ((f (file-name-nondirectory buffer-file-truename))
	(module (file-name-nondirectory 
		 (directory-file-name (file-name-directory buffer-file-truename))))
	(wgn "XXXX")
	(partno "ZZZZ")
	armmim
	pos beg end 
	)
    (cond ((equalp f "arm.exp")
	   (setq armmim "ARM"))
	  (t (setq armmim "MIM")))
	       
    (goto-char (point-min))
    (setq beg (point))
    (search-forward "SCHEMA")
    (search-backward "SCHEMA")
    (setq end (point))
    (delete-region beg end)

    (insert "(*\n")
    (insert "  $Id: ")
    (insert "$\n")
    (insert "  ISO/TC184/SC4 WG12N")
    (insert wgn)
    (insert (format " - ISO/%s - 10303-%s " type partno))
    (setq pos (point))
    (setq beg pos)
    (insert module)
    (setq end (point))
    (capitalize-region pos (+ 1 pos))
    
    (goto-char beg)
    (replace-string "_" " " nil beg end)
    (goto-char end)

    (insert " - EXPRESS ")
    (insert armmim)
    (insert "\n*)\n\n")
    )  
)

(defun modrep-insert-wgn-cd ()
  (interactive)
  (modrep-insert-wgn "CD-TS")
  )

(defun modrep-insert-wgn-ts ()
  (interactive)
  (modrep-insert-wgn "CD TS")
  )


;;; Insert a Module Repository issue
(defun modrep-insert-issue (type)  
  (let (pos module beg end
	    (bdir (file-name-directory (buffer-file-name)))
	    )
    ;; remove the last /
    (setq bdir
	  (file-name-directory (substring bdir 0 (- (length bdir) 1))))
    (setq module (file-name-nondirectory (substring bdir 0 (- (length bdir) 1))))
    (goto-char (point-max))
    (search-backward "</issues>")
    (insert "\n")
    (beginning-of-line)
    (insert "<!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->\n")
    (insert "<issue\n")
    (insert "   id=\"")
    (insert (modrep-issue-ref))
    (insert "\"\n")

    (insert "   type=\"")
    (insert (format "%s" type))
    (insert "\"\n")

    (insert "   linkend=\"")
    (cond ((or (equalp type "arm")
	       (equalp type "mim"))
	   (setq beg (point))
	   (insert (format "%s_%s" module type))
	   (capitalize-region beg (+ 1 beg))
	   )
	  ((equalp type "mapping_table")
	   (insert "ae entity=")
	   )
	  )
    (insert "\"\n")
    (insert "   status=\"open\"\n")
    (insert "   category=\"editorial\"\n")
    (insert "   by=\"")
    (insert modrep-user)
    (insert "\"\n")
    (insert "   date=\"")
    (insert (modrep-date))
    (insert "\"\n")
    (insert "   seds=\"no\">\n")

    ;(insert "   category=\"editorial general model implementation\">\n")
    (insert "<description>\n")
    (setq pos (point))
    (insert "\n")
    (insert "</description>\n")
    (insert "</issue>\n\n")
    (goto-char pos)
    )
  )


(defun modrep-issue-close ()
  "Close a modrep issue comment"
  (interactive)
  (let (pos)
    (search-forward "</issue>")
    (search-backward "status=\"open\"")
    (forward-char 8)
    (delete-char 4)
    (insert "closed")
    )
  )
    


(defun modrep-issue-comment ()
  "Insert a modrep issue comment"
  (interactive)
  (let (pos)
    (search-forward "</issue>")
    (search-backward "</issue>")
    (insert "\n")
    (beginning-of-line)
    (insert "<comment\n")
    (insert "   by=\"")
    (insert modrep-user)
    (insert "\"\n")
    (insert "   date=\"")
    (insert (modrep-date))
    (insert "\">\n")
    (insert "<description>\n")
    (setq pos (point))
    (insert "\n")
    (insert "</description>\n")
    (insert "</comment>\n")
    (goto-char pos)
    )
  )

(defun modrep-issue-close-and-comment ()
  "Close and comment on modrep issue comment"
  (modrep-issue-close)
  (modrep-issue-comment)
)



(defun modrep-insert-file-header-details ()
  "Insert XSL File header"
  (interactive)
  (insert "<!--\n")
  (insert "$Id: mod_repo.el,v 1.14 2003/04/23 14:59:32 robbod Exp $\n")
  (insert "  Author:  ") (insert modrep-user) (insert ", ") (insert modrep-org)
  (insert "\n")
  (insert "  Owner:   ") (insert modrep-owner-notice) (insert "\n")
  (insert "  Purpose:\n")
  (insert "     \n")
  (insert "-->\n")
)

(defun modrep-insert-file-header-xml ()
  "Insert XML File header"
  (interactive)
  (goto-char (point-min))	     
  (insert "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n")
  (modrep-insert-file-header-details)
)

(defun modrep-insert-file-header-xsl ()
  "Insert XSL File header"
  (interactive)
  (goto-char (point-min))	     
  (insert "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n")
  (modrep-insert-file-header-details)
  (insert "<xsl:stylesheet xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\"\n")
  (insert"                version=\"1.0\">\n\n")
  (insert "  <xsl:output method=\"html\"/>\n\n")
  (insert "  <xsl:template match=\"/\">\n")
  (insert "  </xsl:template>\n\n")
  (insert "</xsl:stylesheet>\n")
)

(defun modrep-insert-issue-lvars ()
  "Insert local emacs variables for issues"
  (interactive)
  (goto-char (point-max))	     
  (insert "\n<!--\n")
  (insert "Ignore - Used for Emacs\n")
  (insert ";;; Local Variables: ***\n")
  (insert ";;; modrep-issue-schema:\"modrep_core\" ***\n")
  (insert ";;; modrep-issue-prefix:\"RBN-\" ***\n")
  (insert ";;; modrep-user:\"Rob Bodington\" ***\n")
  (insert ";;; End: ***\n")
  (insert "-->\n")
)


(defun modrep-insert-example ()
  "Insert HTML for example"
  (interactive)
  (let (m)
     (insert "<h4>Example</h4>\n")
     (insert "An example is:\n")
     (insert "  <p/>\n")
     (insert "  <table border=\"1\" width=\"500\" \n")
     (insert "    cellspacing=\"0\" cellpadding=\"3\" bgcolor=\"#FFFFCC\">\n")
     (insert "    <tr>\n")
     (insert "      <td width=\"100%\" bordercolor=\"#808080\" valign=\"top\" align=\"left\">\n")
     (insert "      <pre>\n      ")
     (setq m (point))
     (insert "\n")
     (insert "      </pre>\n")
     (insert "      </td>\n")
     (insert "    </tr>\n")
     (insert "  </table>\n")
     (insert "  <p>\n")
     (goto-char m)
    )
)


(defun modrep-insert-uof ()
  "Insert a Module UoF"
  (interactive)
  (search-backward "<module")
  (unless (search-forward "</uof>" nil t)
    (search-forward "<arm>"))
  (insert "\n   <uof name=\"\">\n")
  (insert "     <description>\n")
  (insert "     </description>\n")
  (insert "     <uof.ae entity=\"\"/>\n")
  (insert "   </uof>")
  )

(defun modrep-insert-uoflink ()
  "Insert a Module UoF"
  (interactive)
  (goto-line 1)
  (search-forward "</module")
  (search-backward "</arm")
  (search-backward "<express-g>" nil t)
  (beginning-of-line)
  (insert "   <uoflink module=\"\"\n") 
  (insert "     uof=\"\"/>\n")
  )


(defun modrep-insert-express_ref ()
  "Insert a express_ref"
  (interactive)
  (let ((beg (point))
	(end nil)
	(txt ""))
    (when mark-active
      (setq beg (min (point) (mark)))
      (setq end (max (point) (mark)))
      (setq txt (buffer-substring (point) (mark)))
      (delete-region beg end)
      )
    (goto-char beg)
    (insert "\n<express_ref linkend=\"")
    (insert txt)
    (insert "\"/>\n")
    )
  )


(defun modrep-insert-module_ref ()
  "Insert a module_ref"
  (interactive)
  (let ((beg (point))
	(end nil)
	(txt ""))
    (when mark-active
      (setq beg (min (point) (mark)))
      (setq end (max (point) (mark)))
      (setq txt (buffer-substring (point) (mark)))
      (delete-region beg end)
      )
    (goto-char beg)
    (insert "\n<module_ref linkend=\"xxx:introduction")
    (insert txt)
    (insert "\">\n")
    (insert txt)
    (insert "\n</module_ref>\n")
    )
  )

;;; Insert the describe.selects into external description files
(defun modrep-insert-describe-selects ()
  (goto-line 1)
  (search-forward "rcs.revision")
  (search-forward ">")
  (backward-char)
  (insert "\n  describe.selects=\"YES\"\n")
  )

;;; Insert the describe.selects into external description files
(defun modrep-insert-development-folder ()
  (goto-line 1)
  (search-forward "rcs.revision")
  (search-forward ">")
  (backward-char)
  (insert "\n  development.folder=\"dvlp\"\n")
  )

;;; Insert the external description link into arm.xml files
(defun modrep-insert-ext-arm-description-file ()
  (interactive)
  (modrep-insert-ext-description-file "arm_descriptions.xml")
  )

;;; Insert the external description link into mim.xml files
(defun modrep-insert-ext-mim-description-file ()
  (interactive)
  (modrep-insert-ext-description-file "mim_descriptions.xml")
  )

(defun modrep-insert-ext-description-file (file)
  (goto-line 1)
  (search-forward "rcs.revision")
  (search-forward ">")
  (backward-char)
  (insert "\n  description.file=\"")
  (insert (format "%s" file))
  (insert "\"\n")
  )



(defun modrep-insert-tag (tag)
  "Insert an XML tag"
  (interactive)
  (let ((pos (point))
	(mmark (mark t))
	)
    (when mark-active
	(copy-region-as-kill (mark) pos)
	(exchange-point-and-mark))
    (insert (format "<%s>" tag))
    (when mark-active
	(exchange-point-and-mark)
	)
    (setq pos (point))
    (insert (format "</%s>" tag))
    (if (not mark-active)
	(goto-char pos))
    )
  )

(defun modrep-update-imgfile-content ()
  "Add the module and title attribute to imgfile.content"
  (interactive)
  (let ((f (file-name-nondirectory buffer-file-truename))
	(module (file-name-nondirectory 
	      (directory-file-name  (file-name-directory buffer-file-truename))))
	title
	diag_no start end entity_diag)

    (goto-char (point-min))
    (search-forward "<imgfile.content")
    (setq start (search-backward "<"))
    (setq end (search-forward ">"))
    (delete-region start end)

    (insert "<imgfile.content\n")
    (insert "     module=\"")(insert module)(insert "\"\n")
    (insert "     file=\"")(insert f)(insert "\">\n")
    )
  )

;; teh add
(defun modrep-insert-mim()
 (interactive)
 (insert "../activity_method/sys/5_mim.xml#mim_express")

)

(defun modrep-insert-iso()
 (interactive)
 (insert "ISO 10303-")

)
;; end teh add


(easy-menu-define
 modrep-menu-symbol global-map "modrep"
 '("STEPmod"
   ("Issues"
     ["insert abbreviations issue" (modrep-insert-issue "abbreviations") t] 
     ["insert arm issue" (modrep-insert-issue "arm") t] 
     ["insert arm_lf issue" (modrep-insert-issue "arm_lf") t]
     ["insert armexpg issue" (modrep-insert-issue "armexpg") t] 
     ["insert armexpg_lf issue" (modrep-insert-issue "armexpg_lf ") t]
     ["insert bibliography issue" (modrep-insert-issue "bibliography") t]
     ["insert contacts issue" (modrep-insert-issue "contacts") t] 
     ["insert definition issue" (modrep-insert-issue "definition") t] 
     ["insert general issue" (modrep-insert-issue "general") t] 
     ["insert inscope issue" (modrep-insert-issue "inscope") t] 
     ["insert keywords issue" (modrep-insert-issue "keywords") t] 
     ["insert mapping_table  issue" (modrep-insert-issue "mapping_table") t]
     ["insert mim issue" (modrep-insert-issue "mim") t]  
     ["insert mim_lf issue" (modrep-insert-issue "mim_lf") t]
     ["insert mimexpg issue" (modrep-insert-issue "mimexpg") t] 
     ["insert mimexpg_lf issue" (modrep-insert-issue "mimexpg") t]
     ["insert normrefs issue" (modrep-insert-issue "normrefs") t] 
     ["insert outscope issue" (modrep-insert-issue "outscope") t]
     ["insert purpose issue" (modrep-insert-issue "purpose") t] 
     ["insert usage_guide issue" (modrep-insert-issue "usage_guide ") t]


;     ["Open issues/issue1.xml" 
;      (find-file (concat modrep-home "../issues/issue1.xml")) t]

     ["Insert <comment> issue" (modrep-issue-comment) t]
     ["Close issue" (modrep-issue-close) t]
     ["Close and <comment> issue" (modrep-issue-close-and-comment) t]
     )
   ["Insert development folder" 
    (modrep-insert-development-folder) t]
  ["Insert ARM description file" 
   (modrep-insert-ext-arm-description-file) t]
  ["Insert MIM description file" 
   (modrep-insert-ext-mim-description-file) t]

  ["Insert Enable Select boiler plates text" 
   (modrep-insert-describe-selects) t]

  ["Insert EXPRESS-G module/file attributes" 
   (modrep-update-imgfile-content) t]

  ["Insert CD TS WGN header into arm.exp or mim.exp file" 
   (modrep-insert-wgn-cd) t]

  ["Insert TS WGN header into arm.exp or mim.exp file" 
   (modrep-insert-wgn-ts) t]

  ["Insert <b>" 
   (modrep-insert-tag "b") t]
  ["Insert <i>" 
   (modrep-insert-tag "i") t]
  ["Insert <p>" 
   (modrep-insert-tag "p") t]
  ["Insert <li>" 
   (modrep-insert-tag "li") t]


  ["Insert UOF" 
   (modrep-insert-uof) t]

  ["Insert UOF link" 
   (modrep-insert-uoflink) t]
  ["Insert example HTML" 
   (modrep-insert-example) t]
  ["Insert <express_ref/>" 
   (modrep-insert-express_ref) t]
  ["Insert <module_ref>" 
   (modrep-insert-module_ref) t]
;; teh add
  ["Insert ISO 10303-" 
   (modrep-insert-iso) t]

  ["Insert href to mim listing" 
   (modrep-insert-mim) t]
;; end teh add

  ["Dired stepmod/xsl" 
    (find-file (concat modrep-home "/xsl/")) t]
  ["Dired stepmod/data/modules" 
    (find-file (concat modrep-home "/data/modules/")) t]
   ["Edit mod_repo.el" 
    (find-file (concat modrep-home "/etc/emacs/mod_repo.el")) t]
   ["Insert description LVars " (modrep-insert-issue-lvars) t]
   ["Insert XSL file header" (modrep-insert-file-header-xsl) t]
   ["Insert XML file header" (modrep-insert-file-header-xml) t]
   )
 )


