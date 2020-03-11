(or debug? (defun debug?( Value /)(or (not *debug*)(prompt Value))))
;(setq *debug* T)
(debug? "\nLayer-Off w/ Undo loading...")

;setvar cmdecho shortcut
(or echo (defun echo( temp / )(if (not old_cmdecho) (setq old_cmdecho (getvar "cmdecho")))(setvar "cmdecho" temp)))
;set undo shortcut
(or undo (defun undo( temp / )(command "undo" temp)))


;#########################
;###   Layer Control   ###
;#########################
;version 3.2.4

;This lisp is an improved layer on-off, freeze-thaw, lock-unlock tool.
;Each type (on-off, freeze-thaw, & lock-unlock) keeps an undo history of the layers it has affected. When you enter the complimentary command for each type, it will undo the changes you made in reverse order.
;
;E.g. Suppose I issue a layer-off for layers 1-6, and then again for layers 7-9.  When I invoke the layer-on command, layers 7-9 will turn on.  When I invoke it again, layers 1-6 will turn on. 
;
;command: LO - layer off
;command: OL - layer on
;command: LL - layer lock
;command: LU - layer unlock
;command: LF - layer freeze
;command: FL - layer thaw
;

;### this part not for casual users. ###
;About the Layer Diddling function:
; This silly command provides:
; 1. The ablility to edit properties of multiple layers at once.
; 2. A specific undo that undos in groups, back into the past! 

;function syntax
;(layer_diddle 'layer_temp_sets dxf_code_to_edit dxf_edit_operation weeding_citeria)

; layer table DXF codes:
; 70 . [] standard flags -- lock, frozen, xref
; 62 . [] color #, negative for off

(vl-load-com)
(defun layer_diddle_do ( layer_temp_sets dxf_code dxf_edit_operation weeding / *error* i eset layName splat table_list layer_temp_list msg)

	(while (not eset)(setq eset (ssget)))
	(echo 1)(undo "begin")
	(defun *error* (msg)
    (undo "end")(echo old_cmdecho)
    (princ)
	)

	;	get selected entity layer names
	(setq i 0)
	(repeat (sslength eset)
		;get layer names
	  (setq layName(cdr(assoc 8 (entget (ssname eset i)))))
	
		;build list of layers to operate on - get rid of duplicate layer names & weed out other criteria
		(if (and (not (member layName layer_temp_list)) (eval weeding))
					(setq layer_temp_list (cons layName layer_temp_list))
		)
		(setq i(+ i 1))
	) ;repeat

	;turn off layers in list
	(foreach i layer_temp_list
		(setq table_list (entget (tblobjname "layer" i)))
		;dxf_editing_operation from function input variable, variable splat will be inserted into the layer table.
		(setq splat (eval dxf_edit_operation))
		(setq table_list (subst (cons dxf_code splat) (assoc dxf_code table_list) table_list))
		(entmod table_list)
	) ;foreach

	;append this list of layers (this 'set') to a list of sets
	(if (= (eval layer_temp_sets) nil)
		(set layer_temp_sets (cons layer_temp_list nil))
		(set layer_temp_sets (cons layer_temp_list (eval layer_temp_sets)))
	) ;if

	(undo "end")(echo old_cmdecho)
	(princ)
) ;defun


;This function will perform an operation on the previous layer list & remove that list from the set
(defun layer_diddle_undo ( layer_temp_sets dxf_code dxf_edit_operation / i splat table_list)
	(echo 0)(undo "begin")

	(foreach i (car (eval layer_temp_sets))
		(setq table_list (entget(tblobjname "layer" i)))
		;dxf_editing_operation from function input variable, variable splat will be inserted into the layer table.
		(setq splat (eval dxf_edit_operation))
		(setq table_list (subst (cons dxf_code splat) (assoc dxf_code table_list) table_list))
		(entmod table_list)
	);foreach

	(set layer_temp_sets (cdr (eval layer_temp_sets)))

	(undo "end")(echo old_cmdecho)
	(princ)
)


;       The Actual Commands
;===================================

;#layer-off
;(function, set_name, dxf-code, dxf-operation, 1) [that one is a placeholder for the weeding variable]
(defun c:lo ()
	(layer_diddle_do 'layer_off_sets 62 '(- (cdr(assoc 62 table_list))) 1)
)

;#layer-on
;(function, set_name, dxf-code, dxf-operation)
(defun c:ol ()
	(layer_diddle_undo 'layer_off_sets 62 '(abs (cdr (assoc 62 table_list))))
)

;#layer-lock
;(function, set_name, dxf-code, dxf-operation, test_to_weed_out_already_locked_layer)
(defun c:ll ()
	(layer_diddle_do 'layer_lock_sets 70 '(boole 6 4 (cdr(assoc 70 table_list)))
		'(/= 4 (boole 1 4 (cdr (assoc 70 (entget (tblobjname "layer" layName))))))
	)
	
	(vla-regen (vla-get-activedocument (vlax-get-acad-object)) acActiveViewport)
)

;#layer-unlock
;(function, set_name, dxf-code, dxf-operation)
(defun c:lu ( / eset )
	(if (eq nil layer_lock_sets)
		(command "layulk")
		(progn
			(layer_diddle_undo 'layer_lock_sets 70 '(boole 6 4 (cdr(assoc 70 table_list))))
			(vla-regen (vla-get-activedocument (vlax-get-acad-object)) acActiveViewport)
		)
	)
)
;#layer-freeze
;(function, set_name, dxf-code, dxf-operation, test_to_weed_out_already_frozen_layers)
(defun c:lf ()
	(layer_diddle_do 'layer_freeze_sets 70 '(boole 6 1 (cdr(assoc 70 table_list)))
		'(/= 1 (boole 1 1 (cdr (assoc 70 (entget (tblobjname "layer" layName))))))
	)
	
	(vla-regen (vla-get-activedocument (vlax-get-acad-object)) acActiveViewport)
)

;#layer-thaw - (function, set_name, dxf-code, dxf-operation)
(defun c:fl ()
	(layer_diddle_undo 'layer_freeze_sets 70 '(boole 6 1 (cdr(assoc 70 table_list))))
	
	(vla-regen (vla-get-activedocument (vlax-get-acad-object)) acActiveViewport)
)