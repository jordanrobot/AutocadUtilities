;#####################
;###   Tolerance   ###
;#####################

; version 1.0

(or debug? (defun debug?( Value /)(or (not *debug*)(prompt Value))))
(setq debug T)


;###   Dialogue Initialization   ###

(defun c:Tolerance_main_OnInitialize (/)

(debug? "initialization\n")
	;get any saved tolerance values
	(if tol:tboxUpper 
		(dcl_Control_SetText tboxUpper (rtos tol:tboxUpper))
		(progn
			(dcl_Control_SetText tboxUpper "0")
			(setq tol:tboxUpper 0.0)
		)
	)

	(if tol:tboxLower 
		(dcl_Control_SetText tboxLower (rtos tol:tboxLower))
		(progn
			(dcl_Control_SetText tboxLower "0")
			(setq tol:tboxLower 0.0)
		)
	)

	(if tol:optionType 
		(dcl_Control_SetText optionType tol:optionType)
		(progn
			(dcl_OptionList_SetCurSel Tolerance_main_optionType 0)
			(setq tol:optionType 0)
		)
	)

	(tol:optionToggles tol:optionType)


  ;	ignore previously selected dimensions (unless they are single dimensions? or matching tolerance dimensions?) before the dialogue loads?

  ; are dimensions selected?
  ;		no	-	set checkbox to "none"
  ;				set dimension box to "dimension"
  ;				set tolerance blocks blank
  ;		yes	-	how many???
  ;
  ;				one		 -	are limits applied?
  ;
  ;							yes	-	set type checkbox to the corresponding type
  ;									set the dimension block to match dimension
  ;									set tolerance blocks to the current tolerances
  ;							no	-	set the type checkbox to "none"
  ;									set dimension box to "dimension"
  ;									set tolerance blocks blank
  ;
  ;				multiple -	do they have limits applied?
  ;							no	-	set the type checkbox to "none"
  ;									set dimension box to "dimension"
  ;									set tolerance blocks blank
  ;							
  ;							yes -	are they the same type?
  ;								yes -	set the type checkbox to the corresponding type
  ;								no	-	set the type checkbox to "none"
  ;										set dimension box to "dimension"
  ;										set tolerance blocks blank
  ;

)


;###   Button Actions   ###
;##########################

(defun c:Tolerance_main_buttonLoad_OnClicked (/ tmp)

	(debug? "\n Loading dimension...")

	(setq tmp (tol:get_tolerance (car (entsel))))

	(dcl_Control_SetText tboxDim (cadddr tmp))
	(dcl_OptionList_SetCurSel Tolerance_main_optionType (car tmp))
	(dcl_Control_SetText tboxUpper (cadr tmp))
	(dcl_Control_SetText tboxLower (caddr tmp))

	(tol:optionToggles (car tmp))

  	(princ)
)

(defun c:Tolerance_main_buttonApply_OnClicked (/ eset total i)
	(setq	tol:optionType (tol:getOptionType)
			tol:tboxUpper (atof (dcl_Control_GetText tboxUpper))
			tol:tboxLower (atof (dcl_Control_GetText tboxLower)))

	(cond 

		((= tol:optionType 0) 
			(debug? "\n Applying... option 0 found...")
			(setq eset (ssget))
			(setq i 0)
			(repeat (sslength eset)
				(tol:set_tolerance (ssname eset i) (list tol:optionType tol:tboxLower tol:tboxUpper))
				;(debug? (princ (list tol:optionType tol:tboxLower tol:tboxUpper)))
				(setq i (+ 1 i))
			)
		)

		((= 1 1) 
			(debug? "\n Applying... option 1,2,3,4 found...")
			(setq eset (ssget))
			(setq i 0)
			(repeat (sslength eset)
				(tol:set_tolerance (ssname eset i) (list tol:optionType tol:tboxLower tol:tboxUpper))
;				(debug? (prompt (rtos tol:optionType)))
;				(debug? (prompt (rtos tol:tboxLower)))
;				(debug? (prompt (rtos tol:tboxUpper)))
				(setq i (+ 1 i))
			)
		)
	)
	(princ)
)

(defun c:Tolerance_main_buttonCancel_OnClicked (/)
  (dcl_Form_Close Tolerance_main 0)
  (princ)
)


;###   Text & Option Changes   ###

(defun c:Tolerance_main_optionType_OnSelChanged (i val /)
	(setq tol:optionType tol:getOptionType)
	(tol:optionToggles i)
)

(defun c:tboxUpper_OnEditChanged (NewValue /)
	(setq tol:tboxUpper (atof NewValue))
)

(defun c:tboxLower_OnEditChanged (NewValue /)
	(setq tol:tboxLower (atof NewValue))
)



;###   Support Functions   ###
;#############################

;(tol:get_tolerance (car (entsel)))
(defun tol:get_tolerance (ent / vla-ent)
	;accepts an entity parameter
	;returns (type, upper, lower)

	(setq vla-ent (vlax-ename->vla-object ent))
	(list 	(vla-get-ToleranceDisplay vla-ent)
			(rtos (vla-get-ToleranceLowerLimit vla-ent))
			(rtos (vla-get-ToleranceUpperLimit vla-ent))
			(rtos (vla-get-Measurement vla-ent))
	)
)


;(tol:set_tolerance (car (entsel)) '(1 0.04 0.08))
(defun tol:set_tolerance (ent lst / vla-ent)
	;accepts an entity parameter
	;accepts a list of new tolerances (type, upper, lower)

	(setq vla-ent (vlax-ename->vla-object ent))
	(vla-put-ToleranceDisplay vla-ent (car lst))
	(vla-put-ToleranceLowerLimit vla-ent (cadr lst))
	(vla-put-ToleranceUpperLimit vla-ent (caddr lst))
)

(defun tol:optionToggles (i / )
	(cond 
		((= i 0)
			(debug? "\n Option Change: found as 0")
			(dcl_Control_SetEnabled tboxUpper F)
			(dcl_Control_SetEnabled tboxLower F)
		)

		((= 1 1)
			(debug? "\n Option Change: found as 1, 2, 3, or 4")
			(dcl_Control_SetEnabled tboxUpper T)
			(dcl_Control_SetEnabled tboxLower T)
		)
	)
)

(defun tol:getOptionType ( / tmp)

(setq tmp (dcl_OptionList_GetCurSel Tolerance_main_optionType))
	(cond 
		((= tmp 0) 0)
		((= tmp 1) 2)
		((= tmp 2) 3)
		((= tmp 3) 4)
	)
)

;######################################
;###   Tolerance Wrapper Function   ###
;######################################
(tap:debug? "\n Tolerance Wrapper Function")

(defun c:tolerance_editor ( / *error*)

	(defun *error* (msg)
;		(setvar "cmdecho" 1)
		(prompt msg)
		(princ))

	(dcl_Project_Load "Tolerance" T)
	(dcl_project_import project nil nil)

;	(if (not (vl-registry-read tap:masterKey "taps"))
;		(tap:registry 'reset)
;	)

	(dcl_Form_Show Tolerance_main)

	(princ)
)