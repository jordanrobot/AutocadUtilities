(or debug? (defun debug?( Value /)(or (not debug)(prompt Value))))
;(or debug? (defun debug?( Value /)(if (= debug T)(prompt Value)))!!!)
;(setq *debug* T)
;# setvar cmdecho shortcut
(or echo (defun echo( temp / )(or old_cmdecho (setq old_cmdecho (getvar "cmdecho")))(setvar "cmdecho" temp)))
;# set undo shortcut
(or undo (defun undo( temp / )(command "undo" temp)))
;# radians to decimals
(or rtd (defun rtd (a) (/ (* a 180.0 ) pi))) 
;# decimals to radians
(or dtr (defun dtr (a) (* pi (/ a 180.0))))


;#################
;###   Twist   ###
;#################
;v. 2.2

;Command : TWISTUCS
;  shortcut for dview twist (with added functionality)
;
;  Enter the twist angle explicitly or
;		Align: set twist angle by picking two points (Point 1 will become 0,0 and Point 2 becomes the positive x-axis vector)
; 		Relative: set twist angle relative to current twist angle (e.g. twist an additional 3 degrees, etc.)
; *NEW* Previous: set the twist angle to the previous twist.
;
;	After twisting the view, the list will prompt (yes/no) to Realign the UCS.

(debug? "\nTwist loading...")


(defun c:twistUCS( / answer lock_flag *doc* *vport* *vpmode* *error* islocked? lock? twist_model)

	(vl-load-com)
	(debug? "\nTwistUCS command initialized...")
	(echo 0)(undo "begin")

	(defun *error* (#Message)
    	(and #Message
    	     (not (wcmatch (strcase #Message) "*BREAK*,*CANCEL*,*QUIT*"))
    	     (princ (strcat "\nError: " #Message))
    	)
    	(echo 1)(undo 'end)
  	) ;defun


	;Unlock a viewport if needed
	(defun islocked?( / )
		(vl-load-com)
		(debug? "\nChecking if viewports are unlocked...")
		(or *doc* (setq *doc* (vla-get-ActiveDocument (vlax-get-acad-object))))
		(or *vport* (setq *vport* (vla-get-ActivePViewport *doc*)))
		(or *vpmode* (setq *vpmode* (vla-get-DisplayLocked *vport*)))

		(if (equal :vlax-true *vpmode*)
			(progn
				(debug? "\nUnlocking a locked viewport...")
				(vla-put-DisplayLocked *vport* :vlax-false)
				(setq lock_flag T)
			)
		)
	)

	;Lock a viewport if it was unlocked
	(defun lock?( / )
		(if (= lock_flag T)
			(progn
				(debug? "\nLock a previously locked viewport...")
				(vla-put-DisplayLocked *vport* :vlax-true)
				(setq lock_flag nil)
			)
		)
	)

	;Twisting action here!
	(defun twist_model(/)
		(debug? "\nFunction: twist_model...")

		(initget 128 "Align Relative Previous eXit")
		(setq answer (getint "\nSpecify angle or [Align/Relative/Previous/eXit] <Align>: "))

		(cond 
			((or (= answer "Align") (= answer nil))
				(setq answer (- (getvar "ViewTwist") (getangle "\nPick first point:"))))
	
			((= answer "Relative")
				(initget 128)
				(setq answer (+ (getvar "ViewTwist") (getangle "\nSpecify angle relative to current view: "))))

			((or (= answer "Previous") (= answer ""))
				(if tw:previous_twist (setq answer tw:previous_twist) (setq answer 0)))

			((= answer "eXit")
				(setq answer nil))

			((numberp answer) (setq answer (dtr answer)))
		) ;cond

	(if answer 
		(progn
			(setq tw:previous_twist (getvar "viewtwist"))	
			(command "dview" "" "twist" (rtd answer) "" )
			(initget "Yes No")
			(if (/= (getkword "\nRealign UCS?: [Yes/No] <Yes>:") "No" )
					(vl-cmdf "ucs" "v"))
		)
	)
		(undo "end")(echo old_cmdecho)
	) ;defun twist_model

	;Main switching logic
	(cond 
		;in paperspace - no viewport active
		((and (= (getvar "tilemode") 0) (= (getvar "cvport") 1))
			(prompt "\nYou cannot twist paperspace, please activate a viewport.")
		)

		;in paperspace - viewport active
		((and (= (getvar "tilemode") 0) (= (getvar "cvport") 2))
			(islocked?)
			(twist_model)
			(lock?)
		)

		;in modelspace
		((= (getvar "tilemode") 1)
			(twist_model)
		)
	)
	(princ)
)
