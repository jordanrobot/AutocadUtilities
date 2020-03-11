;(debug? "\n  Quick Copy & Rotate...")
;#############################
;###   Quick Copy/Rotate   ###
;#############################
; version 2.1
; Matthew D. Jordan 2010, 2012

; Changelog 2.1
; Added the "Move" option.

(defun c:quick_copy_rotate( / eset pt1 pt0 flag )

	(if (not eset)
		(setq eset (ssget)))
		
	(setq pt0 (list 0 0 0))
	(setq	pt1 nil)
	
	(initget 129 "Move Center eXit")
	(while (not flag)
	(setq pt1 (getpoint "\nSelect reference point or [Center/Move/eXit]<Center> : "))
			(cond
			((= pt1 "Center") (setq pt0 (getpoint "\nSelect new Centerpoint: ")))
			((= pt1 "eXit") (exit))
			((= pt1 "Move") (command "rotate" eset "" pt0 "reference" pt0 pause) (exit))
			((listp pt1) (setq flag T))
		)
	)
	
	(command "rotate" eset "" pt0 "copy" "reference" pt0 pt1 (while (> (getvar "cmdactive") 0) (command pause)))
	(while (or (/= flag "eXit"))
		(command "rotate" eset "" pt0 "copy" "reference" pt0 pt1 (while (> (getvar "cmdactive") 0) (command pause))))
)