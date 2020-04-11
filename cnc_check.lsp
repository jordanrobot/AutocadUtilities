;#####################
;###   CNC Check   ###
;#####################
;
;	version 0.6.4
;	Matthew D. Jordan	2012

;	This routine goes through an autocad file and finds
;	illegal geometry, elevations, etc. in preperation
;	for cnc programming.  It checks:
;   * are all objects on z = 0?  If no, highlight "invalid" objects
;   * are there any 3D objects? - if yes, highlight "invalid" objects
;   * explode all geometric objects(not annotations & dimensions)
;   * change dimensions and text to .stny text layer
;   * highlight invalid objects
;	* Purge "..cnc - invalid..." layer names when not needed
;	* Check for duplicate names in cnc tag block
;



;# set debug function
(or debug? (defun debug?( Value /)(or(= *debug* nil)(prompt Value))))
;(setq *debug* T)
;# setvar cmdecho shortcut
(or echo (defun echo( temp / )(or old_cmdecho (setq old_cmdecho (getvar "cmdecho")))(setvar "cmdecho" temp)))
;# set undo shortcut
(or undo (defun undo( temp / )(vl-cmdf "undo" temp)))

;#########################
;###   Main Start...   ###
;#########################

(defun c:cnc_check ( / cnc:annotative-p cnc:zero_match *error* cnc:invalid_flag cnc:invalid_object eset delete_layer cnc:z_flag cnc:dupe_flag tmp_text)

	(echo 0)
	(undo "begin")

	;###   Error Handling   ###
	(defun *error* (msg)
		(princ "An error occured, CNC_CHECK has terminated.")
		(princ msg)
		(command)
		(echo old_cmdecho)
		(undo "end")
	)


	;###   Create Light Layer   ###
	(if (not (tblsearch "LAYER" "..02 - Light"))
		(entmake '(( 0 . "LAYER")(100 . "AcDbSymbolTableRecord")(100 . "AcDbLayerTableRecord")(70 . 0)(2 . "..02 - Light")(62 . 142)(6 . "Continuous")(370 . 9)))
	) ;if



;##############################
;###   Internal Functions   ###
;##############################

	;###   Delete Layers   ###
	(defun delete_layer (layer / )
		(debug? "Function: delete_layer...\n")
		(if (and (tblsearch "LAYER" layer) (not (ssget "_X" (list (cons 8 layer)))))
			(vla-delete (vlax-ename->vla-object (tblobjname "layer" layer)))
		)
	)


	;###   Invalid Objects   ###
	(defun cnc:invalid_object ( eset / )
		(debug? "\nFunction: cnc:invalid_object...")
		;move invalid objects in eset to ".cnc - invalid" layer - create layer if needed

		(if (not (tblsearch "LAYER" ".error - invalid object")) 
			(entmake '(( 0 . "LAYER")(100 . "AcDbSymbolTableRecord")(100 . "AcDbLayerTableRecord")(70 . 0)(2 . ".error - invalid object")(62 . 2)(6 . "Continuous")))
		) ;if

		(vl-cmdf "chprop" eset "" "_la" ".error - invalid object" "")
	) ;defun


	;###   Invalid Elevation   ###
	(defun cnc:invalid_elevation ( eset / )
		(debug? "\nFunction: cnc:invalid_elevation...")
		;move invalid objects in eset to ".cnc - invalid" layer - create layer if needed

		(if (not (tblsearch "LAYER" ".error - invalid elevation")) 
			(entmake '(( 0 . "LAYER")(100 . "AcDbSymbolTableRecord")(100 . "AcDbLayerTableRecord")(70 . 0)(2 . ".error - invalid elevation")(62 . 40)(6 . "Continuous")))
		) ;if

		(vl-cmdf "chprop" eset "" "_la" ".error - invalid elevation" "")
	) ;defun


	;###   Duplicate Names   ###
	(defun cnc:duplicate_names ( lst / )
		(debug? "\nFunction: cnc:duplicate_names...")
		;move duplicate names in list to ".cnc - duplicate name" layer - create layer if needed

		(setq cnc:dupe_flag T)
		(if (not (tblsearch "LAYER" ".error - duplicate name")) 
			(entmake '(( 0 . "LAYER")(100 . "AcDbSymbolTableRecord")(100 . "AcDbLayerTableRecord")(70 . 0)(2 . ".error - duplicate name")(62 . 4)(6 . "Continuous")))
		) ;if

			(foreach x lst (vl-cmdf "chprop" (car (cdr x)) "" "_la" ".error - duplicate name" ""))
	) ;defun


	;###   Match to Zero w/ fuzz   ###
	(defun cnc:zero_match (input / ) 
		(eq (atof (rtos input 2 6)) 0)
	)


	;###   Examine and Fix Z Elevation    ###
	; sets all entities to 0.0 on the z axis
	(defun cnc:fixz ( eset / Zflag ed cur_ent total i curtype as1 as2 ptx1 ptx2 pty1 pty2 ptz1 ptz2 oldpt newpt )

		(debug? "\nFunction: cnc:fixZ - inspect Z elevation of all elements...")
		(setq i 0)
		(repeat (sslength eset)

			(setq cur_ent (ssname eset i))
			(setq ed (entget cur_ent))
			(setq curtype (cdr (assoc '0 ed)))

			(cond

				((eq curtype "LINE")

					(if (not (and (cnc:zero_match (cadddr (assoc '10 ed))) (cnc:zero_match (cadddr (assoc '11 ed)))))
						(setq Zflag 1)
					)
				)

				((or (eq curtype "ARC") (eq curtype "CIRCLE") (eq curtype "ELLIPSE"))
					(if (not (and (cnc:zero_match (cadddr (assoc '10 ed)))
									(cnc:zero_match (cadr (assoc '210 ed)))
									(cnc:zero_match (caddr (assoc '210 ed)))
									(equal (abs (cadddr (assoc '210 ed))) 1 0.0000001)
							)) ;not
						(setq Zflag 1)
					)
				)

				((or (eq curtype "MTEXT") (eq curtype "TEXT") (eq curtype "MULTILEADER")(eq curtype "LEADER"))
					(if (not (cnc:zero_match (cadddr (assoc '10 ed))))
						(progn
							(setq as1 (assoc '10 ed))
							(setq ptx1 (cadr as1))
							(setq pty1 (caddr as1))
							(setq ptz1 (cadddr as1))
							(setq oldpt (list '10 ptx1 pty1 ptz1))
							(setq newpt (list '10 ptx1 pty1 '0.0))
							(setq ed (subst newpt oldpt ed))
							(entmod ed)
						)
					)
				)

				((eq curtype "DIMENSION")
					(if (not (and (cnc:zero_match (cadddr (assoc '13 ed))) (cnc:zero_match (cadddr (assoc '14 ed)))))
						(progn
							(setq as1 (assoc '13 ed))
							(setq as2 (assoc '14 ed))
							(setq ptx1 (cadr as1))
							(setq ptx2 (cadr as2))
							(setq pty1 (caddr as1))
							(setq pty2 (caddr as2))
							(setq ptz1 (cadddr as1))
							(setq ptz2 (cadddr as2))
							(setq oldpt (list '13 ptx1 pty1 ptz1))
							(setq newpt (list '13 ptx1 pty1 '0.0))
							(setq ed (subst newpt oldpt ed))
							(entmod ed)
							(setq oldpt (list '14 ptx2 pty2 ptz2))
							(setq newpt (list '14 ptx2 pty2 '0.0))
							(setq ed (subst newpt oldpt ed))
							(entmod ed)
						)
					)
				)


				((= curtype "LEADER")
					(if (not (or (equal (cadddr (assoc '13 ed)) 0 fuzz) (equal (cadddr (assoc '14 ed)) 0 fuzz)))
						(progn
							(setq as1 (assoc '10 ed))
							(setq ptx1 (cadr as1))
							(setq pty1 (caddr as1))
							(setq ptz1 (cadddr as1))
							(setq oldpt (list '10 ptx1 pty1 ptz1))
							(setq newpt (list '10 ptx1 pty1 '0.0))
							(setq ed (subst newpt oldpt ed))
							(entmod ed)
						)
					)
				)
			) ;cond

			(if (eq Zflag 1)
				(progn
					(setq cnc:z_flag T)
					(cnc:invalid_elevation cur_ent)))
	
			(setq Zflag 0)
	
			(setq i (1+ i))
		) ; while
	) ; defun cnc:fixz


	; ###   Check if provided object is Annotative = "YES"   ###
	
	(defun cnc:annotative-p ( ename / check )
		(and (setq check (cdr (assoc 360 (entget ename))))
	       (setq check (dictsearch check "AcDbContextDataManager"))
	       (setq check (dictsearch (cdr (assoc -1 check)) "AcDb_AnnotationScales"))
	       (assoc 350 check)
	 	)
	)


	; ###   Select all blocks with name: "CNC-PART"   ###

	(defun cnc:block-unique-dection (/ eset ent1 i ename values )
		(debug? "\ncnc:duplicate name detection...")
		(if (setq eset (ssget "_X" '((0 . "Insert")(2 . "CNC-PART"))))
			(progn
				(setq total (sslength eset))
				(setq i 0)
		
				(repeat (sslength eset)				;propagate list of Part names to Value variable
					(setq ent1 (ssname eset i))		;block entity name
					(setq ename (ssname eset i))
		
					(setq ename (entnext ename))
					(setq elist (entget ename))   				;the entity list
					(while (and (= (cdr (assoc 0 elist)) "ATTRIB")
								(= (cdr (assoc 2 elist)) "PART"))	;save attributes to a list
						(setq values (cons (list (cdr (assoc 1 elist)) ent1) values))
		;				(princ (list (cdr (assoc 1 elist)) ent1))
						(setq ename (entnext ename))         	;move onto the next attribute
						(setq elist (entget ename))
					)
		
					(setq i (+ i 1))
				)
		
		
					(setq dupes (vl-remove-if-not
				    	(function
				    	    (lambda ( x / tempList )
				    	        (or
				    	            (and
				    	                (setq tempList (assoc (car x) values))
				    	                (not (equal tempList x))
				    	            )
				    	            (assoc (car x) (cdr (member x values)))
				    	        )
				    	    )
				    	)
				    	values
					)) ;setq dupes

				(if dupes (cnc:duplicate_names dupes))
			) ;progn
		) ;if
	) ;defun


	;#############################
	;###   Imperative Calls    ###
	;#############################

	;###   explode planes and surfaces   ###
	(debug? "\nInitialize planes and surfaces detection & explosion...")
	(if (setq eset (ssget "_X" '((0 . "PLANESURFACE,SURFACE"))))
		(progn
			(debug? (strcat (itoa (sslength eset)) " items found."))
			(vl-cmdf "explode" eset "")
		)
	)

	;###   explode regions and polylines   ###
	(debug? "\nInitialize regions and polylines detection & explosion...")
	(if (setq eset (ssget "_X" '((0 . "REGION,MLINE"))))
		(progn
			(debug? (strcat (itoa (sslength eset)) " items found."))
			(vl-cmdf "explode" eset "")
		)
	)

	;###   Find invalid objects - move to the approprate layer   ###
	(debug? "\nFind invalid objects...")
	(if (setq eset (ssget "_X" '((0 . "3DFACE,3DSOLID,ATTRIB,HATCH,HELIX,ELLIPSE,IMAGE,LIGHT,OLEFRAME,OLE2FRAME,POINT,RAY,SECTION,SECTIONOBJECT,SOLID,SPLINE,SUN,SURFACE,UNDERLAY,WIPEOUT,XLINE,SURFACE,MLINE,REGION,NURBSURFACE"))))
		(progn
			(debug? (strcat (itoa (sslength eset)) " items found."))
			(setq cnc:invalid_flag T)
			(cnc:invalid_object eset)
		)
	)

	;###   Check Z=0   ###
	(debug? "\nInitialize Z-check...")
	(if (setq eset (ssget "_X")) (cnc:fixz eset))


	;###   Annotative Property Changer   ###
	(debug? "\nInitialize Annotative Property Changer...")
	(if (setq eset (ssget "_X" '((0 . "dimension,text,mtext,MULTILEADER"))))
		(progn
			(setq i 0)
			(repeat (sslength eset)
				(if	(cnc:annotative-p (ssname eset i)) (command "_chprop" (ssname eset i) "" "A" "No" ""))
				(setq i (+ i 1))
			) ;repeat
		) ;progn
	) ;if
	

	;###   Unique Name Detector Run   ###
	(debug? "\nInitialize unique name detection...")
	(cnc:block-unique-dection)


	;###   Layer Cleanup   ###
	(debug? "\nInitialize unused layer cleanup...\n")
	(delete_layer ".error - invalid object")
	(delete_layer ".error - invalid elevation")
	(delete_layer ".error - duplicate name")


	;###   Notify User of Script Status   ###
	(debug? "\nNotify user of script status...")
	(if (or cnc:z_flag cnc:invalid_flag cnc:dupe_flag)
		(progn
			(alert "There were errors found...")
			(vl-cmdf "laywalk")
		)
		(alert "CNC file prep check completed without any errors.")
	)

	(undo "end")
	(echo old_cmdecho)
) ; defun