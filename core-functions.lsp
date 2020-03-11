(or debug? (defun debug?( Value /)(or (not *debug*)(prompt Value))))
;(setq *debug* T)

;##########################
;###   Core Functions   ###
;##########################
; v1.0

(vl-load-com)

(debug? "\nCore.lsp Loading...")

;# setvar cmdecho shortcut
(or echo (defun echo( temp / )(if (not old_cmdecho) (setq old_cmdecho (getvar "cmdecho")))(setvar "cmdecho" temp)))
;# set undo shortcut
(or undo (defun undo( temp / )(command "undo" temp)))
;# radians to decimals
(or rtd (defun rtd (a) (/ (* a 180.0 ) pi))) 
;# decimals to radians
(or dtr (defun dtr (a) (* pi (/ a 180.0))))



;######################################
;###   Set Support Path Functions   ###
;###   By Lee-Mac                   ###
;######################################

(defun LM:AddSupportPaths ( lst / PreferenceFiles SupportPaths )
  (setq PreferenceFiles (vla-get-files (vla-get-preferences (vlax-get-acad-object)))
        SupportPaths    (LM:str->lst (vla-get-SupportPath PreferenceFiles) ";"))
  (vla-put-SupportPath PreferenceFiles (LM:lst->str (append SupportPaths (setq lst (vl-remove-if '(lambda ( s ) (member s SupportPaths)) lst))) ";")) lst)

(defun LM:RemoveSupportPaths ( lst / PreferenceFiles SupportPaths )
  (setq PreferenceFiles (vla-get-files (vla-get-preferences (vlax-get-acad-object)))
        SupportPaths    (LM:str->lst (vla-get-SupportPath PreferenceFiles) ";"))
  (vla-put-SupportPath PreferenceFiles
    (LM:lst->str (setq lst (vl-remove-if '(lambda ( s ) (member s lst)) SupportPaths)) ";")) lst )


;##########################
;###   String to List   ###
;###   by Lee-Mac       ###
;##########################

; Separates a string using a given delimiter
; str - [str] String to process
; del - [str] Delimiter by which to separate the string
; Returns: [lst] List of strings
 
(defun LM:str->lst ( str del / len lst pos )
    (setq len (1+ (strlen del)))
    (while (setq pos (vl-string-search del str))
        (setq lst (cons (substr str 1 pos) lst)
              str (substr str (+ pos len))
        )
    )
    (reverse (cons str lst))
)

;##########################
;###   List to String   ###
;###   by Lee-Mac       ###
;##########################

; Concatenates each string in a supplied list, separated by a given delimiter
; lst - [lst] List of strings to concatenate
; del - [str] Delimiter string to separate each item

(defun LM:lst->str ( lst del / str )
    (setq str (car lst))
    (foreach itm (cdr lst) (setq str (strcat str del itm)))
    str
)

;###################
;###   Inspect   ###
;###################
; v 1.0   Matthew D. Jordan - 2012

(defun c:inspect (/)
  (initget "Acad Docs doC Vport dXf Object Symbols")
  (setq answer (GETKWORD "Enter type of inspection... [Acad/Docs/doC/Vport/dXf/Object/Symbols]<dXf>: "))
  (cond 
    ((= answer "Acad")    (vlax-dump-object (vlax-get-Acad-Object) T))
    ((= answer "Docs")    (vlax-dump-object (vla-get-documents (vlax-get-Acad-Object)) T))
    ((= answer "doC")     (vlax-dump-object (vla-item (vla-get-documents (vlax-get-Acad-Object)) 0) T)) 
    ((= answer "Vport")   (vla-get-ActivePViewport (vla-get-ActiveDocument (vlax-get-acad-object))))
    ((= answer "dXf")     (entget (car (entsel)))) 
    ((= answer "Object")  (vlax-dump-object(vlax-ename->vla-object(car(entsel))) T))
    ((= answer "Symbols") (vl-sort (ATOMS-FAMILY 1) '<))
  )
)


;######################################
;###   Get Autocad Release Number   ###
;######################################
; v 0.1   Matthew D. Jordan - 2012
;
;(acad-ver '< "2011")     ;;return T if version is less than 2011
;(acad-ver '>= "2011")     ;;return T if version is equal to or greater than 2011
;(acad-ver '> "2009")     ;;return T if version is greater than 2009

(defun acad-ver (operator version / version-list )
  (setq version-list '(
    ("R13" . 13.0)
    ("2000" . 14.0)
    ("2001i" . 15.05)
    ("2002" . 15.06)
    ("2004" . 16.0)
    ("2005" . 16.1)
    ("2006" . 16.2)
    ("2007" . 17.0)
    ("2008" . 17.1)
    ("2009" . 17.2)
    ("2010" . 18.0)
    ("2011" . 18.1)
    ("2012" . 18.2)
    ("2013" . 19.0)
  ))
  (if ((eval operator) (atof (getvar "ACADVER")) (cdr (assoc version version-list)))
    T
    nil
  )
) ;defun

;################
;###   Push   ###
;################
; by Kdub
; push first element into quoted list
;
; syntax -- list::push( item 'lst )

(defun list::push (item lst)
  (set lst (cons item (eval lst)))
)

;################
;###   Push   ###
;################
; by Kdub
;
; pop first element permenantly from quoted list and return this element's value
; example : (list::pop 'list)
 
(defun list::pop (lst / item)
  (setq item (eval lst))
  (set lst (cdr lst))
  (car item)
)

;#####################
;###   Rollright   ###
;#####################
; by Kdub
;
; Rolls a list right-wise
; rolls the last item in a list to the front
;   (list::rollup '(0 1 2 3)) => '(3 0 1 2)
(defun list::rollright (lst)
  (cons (last lst) (reverse (cdr (reverse lst))))
)

;####################
;###   Rollleft   ###
;####################
; by Kdub
;
; Rolls a list left-wise
; rolls the first item in a list to last
;   (list::rollup '(0 1 2 3)) => '(1 2 3 0)
(defun list::rollleft (lst)
  (append (cdr lst) (list (car lst)))
)


