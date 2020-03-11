;########################################
;###   Transparent unit conversions   ###
;###   v 2.2            July 2012     ###
;########################################
;
;
; transparently convert units during commands
;
;	command: 'mm
;				run while in another command to return the inch equivalent of the entered mm distance
;	command: 'ii
;				run while in another command to return the mm equivalent of the entered inch distance
;	command: 'ft
;				run while in another command to return the mm equivalent of the entered foot distance



(vl-load-com)

(defun c:mm_to_inches(/ tmp activedoc olderror myerror *lunits)
	(setq activedoc (vla-get-ActiveDocument (vlax-get-acad-object)))

	(defun myerror (msg)
		(setvar 'lunits *lunits)
		(setq *error* olderror)
	)

	(setq olderror *error*)
	(setq *error* myerror)
	(setq *lunits (getvar 'lunits))				;;save current units
	(setvar 'lunits 2)							;;decimal units

	(setq tmp (/ (getreal "---> Enter millimeters: ") 25.4))
	
	(setvar 'lunits *lunits)
	(setq *error* olderror)
	(vla-SendCommand activedoc tmp)
	(vla-SendCommand activedoc "\n")
	(princ)
)

(defun c:inches_to_mm(/ tmp activedoc olderror myerror *lunits)
	(setq activedoc (vla-get-ActiveDocument (vlax-get-acad-object)))

	(defun myerror (msg)
		(setvar 'lunits *lunits)
		(setq *error* olderror)
	)

	(setq olderror *error*)
	(setq *error* myerror)
	(setq *lunits (getvar 'lunits))				;;save current units
	(setvar 'lunits 2)							;;decimal units
	
	(setq tmp (* (getreal "---> Enter inches: ") 25.4))
	
	(setvar 'lunits *lunits)
	(setq *error* olderror)
	(vla-SendCommand activedoc tmp)
	(vla-SendCommand activedoc "\n")
	(princ)
)
