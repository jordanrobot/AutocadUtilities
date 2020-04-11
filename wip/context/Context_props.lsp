;##############################
;###   Add DWG Properties   ###
;##############################
; version 1.6
; Matthew D. Jordan
; 
; Automates the task of adding to the custom dwg properties.
; A simpler version of propify(express tool) but propify is
; not working correctly at the moment and I don't want to spend
; the time troubleshooting the problem.

(vl-load-com)

(defun context:AddProps ( / doc db si properties i tmp )

	(setq doc (vla-get-ActiveDocument (vlax-get-Acad-Object)))
	(setq db  (vla-get-Database doc))
	(setq si  (vla-get-SummaryInfo db))
 
	(vla-put-author si (getvar "loginname"))
	
	; this is a list of the custom properties you are adding... (key/name . value)
	(setq properties  (list
		'("Status" . "")
		(cons "Project Name"  (CurentProject? (car currentProject) ""))
		(cons "Unit Name" (CurrentTask? (car currentTask) ""))
		'("Drafted By" . "")
		'("Project Manager" . "")
		(cons "Job Number" (CurentProject? (cadr currentProject) ""))
		'("Location Number" . "3120")
		(cons "Task Number" (CurrentTask? (cadr currentTask) ""))
		'("Total Drawings" . "")))
	
	;go through the above list and see if they already exist.
	(foreach i properties
		(if (vl-catch-all-error-p (vl-catch-all-apply 'vla-GetCustomByKey (list si (car i) 'tmp)))
			;key not found - create a brand new key!
			(progn 
				(vl-catch-all-apply 'vla-removecustombykey (list si (car i))) 
				(vla-addcustominfo si (car i) (cdr i)))))
	
	(princ)
	(command "dwgprops")
	)