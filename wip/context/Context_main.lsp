;###########################
;###   Project Context   ###
;###########################
(setq $context_version "0.02")

;Matthew D. Jordan - 2012


;###########################
;###   Prelim Settings   ###
;###########################


(command "opendcl")
(vl-load-com)
(load "Context_UI.lsp")
(load "Context_props.lsp")
(load "Context_parse.lsp")

;################################
;###   Main Command Wrapper   ###
;################################

(defun C:context( / *error* )
	(defun *error* (msg)
		(princ msg)
		(princ))

	(dcl_Project_Load "Context" T)
	(dcl_project_import project nil nil)

	(dcl_Form_Show Context_formMain)

)



;###################
;###   Startup   ###
;###################

(defun Startup(/) 

  (ButtonToggle 1)

  (setq currentProject (GetProject (getvar 'dwgprefix)))
  (setq currentTask (GetTask (getvar 'dwgprefix)))
  
  (ScanFiles)
  
  (dcl_Control_SetText Context_formMain_textCurrentProject  (strcat (car currentProject) " - " (cadr currentProject)))
  (dcl_Control_SetText Context_formMain_textVersionsProject   (strcat (car currentProject) " - " (cadr currentProject)))
  (dcl_Control_SetText Context_formMain_textIssuedProject   (strcat (car currentProject) " - " (cadr currentProject)))
  
  (dcl_Control_SetText Context_formMain_textCurrentTask     (strcat (car currentTask) " - " (cadr currentTask)))
  (dcl_Control_SetText Context_formMain_textVersionsTask    (strcat (car currentTask) " - " (cadr currentTask)))
  (dcl_Control_SetText Context_formMain_textIssuedTask    (strcat (car currentTask) " - " (cadr currentTask)))
    
  (dcl_Control_SetText Context_formMain_textCurrentPath     (strcat (caddr currentProject)  (caddr currentTask)))
  (dcl_Control_SetText Context_formMain_textVersionsPath    (strcat (caddr currentProject)  (caddr currentTask)))
  (dcl_Control_SetText Context_formMain_textIssuedPath    (strcat (caddr currentProject)  (caddr currentTask)))

  (UpdateBrowseInfo)
)






;##################
;###   Browse   ###
;##################

(defun BrowseProject? (case1 case2 / )
  (if browseProject
    case1
    case2
    )
  )

(defun BrowseTask? (case1 case2 / )
  (if browseTask
    case1
    case2
    )
  )

(defun BrowsePath? (case1 case2 / )
  (if browsePath
    case1
    case2
    )
  )

(defun CurrentProject? (case1 case2 / )
  (if currentProject
    case1
    case2
    )
  )

(defun CurrentTask? (case1 case2 / )
  (if currentTask
    case1
    case2
    )
  )


(defun SetBrowseInfo (/)

  (setq temp (DirectoryDialog "Select Task Folder:" "\\" 0))

  ;(if (not 
    (setq browseProject (GetProject temp));)
   ; (setq browseProject nil))

;  (if (not 
  (setq browseTask (GetTask temp));)
;    (setq browseTask nil))

  (setq browsePath (strcat 
    (if browseProject (caddr browseProject)) (if browseTask (caddr browseTask))))

)



(defun UpdateBrowseInfo (/)

  (BrowseProject?
    (dcl_Control_SetText Context_formMain_comboBrowseProject  (strcat (car browseProject) " - " (cadr cbrowseProject)))
    (dcl_Control_SetText Context_formMain_comboBrowseProject "Valid Project not found")
  )

  (BrowseTask?
    (dcl_Control_SetText Context_formMain_comboBrowseTask     (strcat (car browseTask) " - " (cadr browseTask)))
    (dcl_Control_SetText Context_formMain_comboBrowseTask "Valid Task not found")
    )

  (BrowsePath? 
    (dcl_Control_SetText Context_formMain_textBrowsePath    (browsePath))
    (dcl_Control_SetText Context_formMain_textBrowsePath "Valid Path not found")
  )
)


;#####################
;###   Functions   ###
;#####################

;###   Directory Dialogue   ###
(defun DirectoryDialog ( msg dir flag / Shell Fold Self Path )
  (vl-catch-all-apply
    (function
      (lambda ( / ac HWND )
        (if
          (setq Shell (vla-getInterfaceObject (setq ac (vlax-get-acad-object)) "Shell.Application")
                HWND  (vl-catch-all-apply 'vla-get-HWND (list ac))
                Fold  (vlax-invoke-method Shell 'BrowseForFolder (if (vl-catch-all-error-p HWND) 0 HWND) msg flag dir)
          )
          (setq Self (vlax-get-property Fold 'Self)
                Path (vlax-get-property Self 'Path)
                Path (vl-string-right-trim "\\" (vl-string-translate "/" "\\" Path))
          )
        )
      )
    )
  )
  (if Self  (vlax-release-object  Self))
  (if Fold  (vlax-release-object  Fold))
  (if Shell (vlax-release-object Shell))
  Path
)

;###   Explorer   ###
(defun Explore ( target / Shell result )

  (setq Shell  (vla-getInterfaceObject (vlax-get-acad-object) "Shell.Application"))

  (setq result
    (and (or (eq 'INT (type target)) (vl-file-directory-p target))
      (not
        (vl-catch-all-error-p
          (vl-catch-all-apply 'vlax-invoke (list Shell 'Explore target))
        )
      )
    )
  )
  (vlax-release-object Shell)
  result
)



;###   Get all files   ###
(defun GetAllFiles ( dir typ )
  (vl-remove-if '(lambda ( x ) (wcmatch x "`.,`.`.,*`.bak,*`.dwl,*`.dwl2,acad`.plot,acad`.err")) 
    (append (mapcar '(lambda ( x ) (strcat dir "\\" x)) (vl-directory-files dir typ 1))
      (apply 'append
        (mapcar '(lambda ( x ) (GetAllFiles (strcat dir "\\" x) typ))
          (vl-remove-if '(lambda ( x ) (wcmatch x "`.,`.`.")) (vl-directory-files dir "*" -1))
        )
      )
    )
  )
)


(defun getDirectories ( / dir)
  (setq dir (vl-string-right-trim "\\" (getvar 'dwgprefix)))
  (append (mapcar '(lambda (x) (strcat dir "\\" x)) (vl-directory-files dir "*" -1) ))

  )

(defun lst->str ( lst del / str )
    (setq str  (car lst))
    (foreach x (cdr lst) (setq str (strcat str del x)))
    str
)


(defun str->lst ( str del / pos )
    (if (setq pos (vl-string-search del str))
        (cons (substr str 1 pos) (str->lst (substr str (+ pos 1 (strlen del))) del))
        (list str)
    )
)