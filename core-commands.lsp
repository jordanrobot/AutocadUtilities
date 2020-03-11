(or debug? (defun debug?( Value /)(or (not *debug*)(prompt Value))))
;(setq *debug* T)


;#####################################
;###   Matt J's AutoCad Utilites   ###
;###   v 1.131          May 2016   ###
;#####################################

(debug? "\nUtilities.lsp Loading...")



;#############################
;###   SelectionSet Tool   ###
;#############################
(debug? "\n  Selection Set Tool... ")

(defun c:s1( / ) (setq s1 (ssget)))
(defun c:s2( / ) (setq s2 (ssget)))
(defun c:s3( / ) (setq s3 (ssget)))
(defun c:s4( / ) (setq s4 (ssget)))


;###################
;###   Scripts   ###
;###################

;       ###   Drawing   ###
;==================================
(debug? "\n  Drawing... ")

;#Delayed Copy
(defun c:cc`( / eset basept tmp point-list)
	(setq eset (ssget))
	(setq basept (getpoint "Select Basepoint...:"))

	(setvar "blipmode" 1)
	(setq point-list (list'("")))
	;select copy-to points
	(initget 128)
	(while (/= (setq tmp (getpoint "copy to...:")) nil)
	(setq point-list (append point-list (list tmp))))

	(setq point-list (reverse point-list))
	(foreach tmp point-list (command "copy" eset "" basept tmp ""))
	(setvar "blipmode" 0)
	(command "regen")
	(princ))


;#Delayed Move
(defun c:mm`( / eset basept pt)
	(setq eset (ssget))
	(setq basept (getpoint))

	;select move-to points
	(setq pt (getpoint "move to...:"))

	(command "move" eset "" basept pt)
	(princ))

;#Move to preassigned point
(defun c:mpp( / eset basept pt)

	(setq pt (getpoint "move to...:"))

	(while 1
	(setq eset (ssget))
	(setq basept (getpoint))
	(command "move" eset "" basept pt))

	(princ))

;# Concentric Rings (Circles)
(defun c:cr( / pt1 *error* )
	(echo 1)
	(defun *error* (msg) (echo old_cmdecho))
	
	(setq pt1 (getpoint "Select Centerpoint:"))
	(while (eq 1 1)
		(command "circle" pt1 (while (> (getvar "cmdactive") 0) (command pause))))
	(echo old_cmdecho)
	(princ))

;# Seperate Solids
(defun c:sep( / )
  (echo 0)
  (command "solidedit" "b" "p" pause "" "")
  (echo 1)
  (princ))

;# Copy Face! Copy Face!  I'm gunna get him hot.  Show him what I got.  Copy Face!  Copy Face!  oh... oh oh........ oooooo...  owwwww.... <\walken> 
(defun c:cf( / )
	(command "solidedit" "f" "c" pause pause pause pause (command)(command))
  (princ))


;# X-Line - Constrained
(defun c:xc ( / *error* temp i )
	(defun *error* (msg) (princ))

	(setq i 0)
	(while (= i 0)
		(command "xline" "h" (while (> (getvar "cmdactive") 0) (command pause)))
		(if (eq temp (setq temp (entlast)))(exit))
		(command "xline" "v" (while (> (getvar "cmdactive") 0) (command pause)))
		(if (eq temp (setq temp (entlast)))(exit)))
	(princ))

;# X-Line - Angled
(defun c:xa ( / )
		(command "xline" "a" (while (> (getvar "cmdactive") 0) (command pause)))
	(princ))

;# X-Line - Offset
(defun c:xo ( / )
		(command "xline" "o" (while (> (getvar "cmdactive") 0) (command pause)))
	(princ))

;# Insert a point at each selected circle's centerpoint
(defun c:cpo ( / eset i pt1 pt2 pt3 )
	(setq eset (ssget '((0 . "CIRCLE"))))
	(setq i 0)
	(repeat (sslength eset)
		(setq pt1 (nth 1 (assoc 10 (entget (ssname eset i)))))
		(setq pt2 (nth 2 (assoc 10 (entget (ssname eset i)))))
		(setq pt3 (nth 3 (assoc 10 (entget (ssname eset i)))))	
		(command "point" (strcat (rtos pt1) "," (rtos pt2) "," (rtos pt3)))
		(setq i (+ i 1)))
	(princ))


;       ###   Layers   ###
;==================================
(debug? "\n  Layers... ")

;# original layer off
(defun c:lo`()
  (command "layoff"  (while (> (getvar "cmdactive") 0) (command pause))))

;# Layerstate Switcher
(defun c:lss( / *error* answer)

	;in case of chemical attack...
	(defun *error* (msg)
		(or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
      	(princ (strcat "\n** Error: " msg " **")))
		(princ))
	
	;is this the first time using this utility?  If so, save a new layerstate...
	(if (not (layerstate-has "layerstate_switcher_temp_1"))
			(progn
				(layerstate-save "layerstate_switcher_temp_1" 255 nil)
				(prompt "\nLayerstate switcher initialized...")
				(princ)
				(quit)))

	;purge extra layerstates
	(if (layerstate-has "layerstate_switcher_temp_2")
			(layerstate-delete "layerstate_switcher_temp_2"))

	(initget "Previous Update Clear eXit")
		(or	(setq answer (getkword "\nEnter an Layerstate Switch option [Previous/Update/Clear all/eXit] <Previous> : "))
			(setq answer "Previous"))
		(cond
			((= answer "Previous")
				(progn 
					(layerstate-save   "layerstate_switcher_temp_2" 255 nil)
					(layerstate-restore "layerstate_switcher_temp_1" nil)
					(layerstate-delete "layerstate_switcher_temp_1")
					(layerstate-rename "layerstate_switcher_temp_2" "layerstate_switcher_temp_1")
					(prompt "\nLayerstate restored...")))

			((= answer "Update")
				(progn
					(layerstate-delete "layerstate_switcher_temp_1")
					(layerstate-save   "layerstate_switcher_temp_1" 255 nil)
					(prompt "\nLayerstate updated...")))
		
			((= answer "Clear")
				(progn
					(layerstate-delete "layerstate_switcher_temp_1")
					(prompt "\nTemporary layerstates cleared...")))
		
			((= answer "eXit")))
		(princ))

;### layer isolate toggle ###
(defun lay_isolate_toggle( temp1 temp2 / *error* eset )
  (echo 0)(undo "begin")
	
	(defun *error* (msg)
		(command "layuniso")
		(setq mdj:lay_isolate_holder 0)
		(prompt "There has been an error in the isolate layer toggle."))

	(if
    (= mdj:lay_isolate_holder 1)
    (progn
      (setq mdj:lay_isolate_holder 0)
      (command "layuniso"))
    (progn
      (setq eset (ssget))
      (command "layiso" "s" temp1 temp2 eset "")
      (setq mdj:lay_isolate_holder 1)))

	(undo "end")(echo 1)
  (princ))

;### Smart Layer Isolate Shortcut
(defun c:li()
  (lay_isolate_toggle "l" "60")
  (princ))

;### Smart Layer Unisolate Shortcut
(defun c:li`()
  (lay_isolate_toggle "o" "o")
  (princ))


;   ###   Annotation Tools   ###
;==================================
(debug? "\n  Annotation... ")

(defun c:l1() (setvar "cmleaderstyle" "prg 01 - Standard"))
(defun c:l2() (setvar "cmleaderstyle" "prg 02 - Bubble"))
(defun c:l3() (setvar "cmleaderstyle" "prg 03 - Circle Ref"))
(defun c:l4() (setvar "cmleaderstyle" "prg 04 - Slot"))
(defun c:l5() (setvar "cmleaderstyle" "prg 05 - Slot Ref"))

(defun c:t1() (setvar "textstyle" "prg 01 - Text"))
(defun c:t2() (setvar "textstyle" "prg 02 - Labels"))
(defun c:t3() (setvar "textstyle" "prg 03 - Standard"))


(defun c:d1() (command "-dimstyle" "Restore" "prg - inch - 0"))
(defun c:d2() (command "-dimstyle" "Restore" "prg - inch - 00"))
(defun c:d3() (command "-dimstyle" "Restore" "prg - inch - 000"))
(defun c:d4() (command "-dimstyle" "Restore" "prg - inch - 0000"))
(defun c:d5() (command "-dimstyle" "Restore" "prg - inch - 08"))
(defun c:d6() (command "-dimstyle" "Restore" "prg - inch - 16"))
(defun c:d7() (command "-dimstyle" "Restore" "prg - inch - 32"))
(defun c:d8() (command "-dimstyle" "Restore" "prg - mm - 0"))
(defun c:d9() (command "-dimstyle" "Restore" "prg - mm - 00"))



;       ###   Editing   ###
;==================================
(debug? "\n  Editing... ")

;offset
(defun c:o (/)
	(command "offset" "erase" "n" (while (> (getvar "cmdactive") 0) (command pause)))
	)

;;offset Delete
(defun c:od (/)
	(command "offset" "erase" "y" (while (> (getvar "cmdactive") 0) (command pause)))
	)

;# Makes normal viewport on the ..08 - Viewports layer in paperspace
;# opens the view dialogue in modelspace
(defun C:v ( / )
	(cond 
		;in paperspace
		((= (getvar "tilemode") 0)
			(command "mview" (while (> (getvar "cmdactive") 0) (command pause)))
			(command ".chprop" "_l" "" "_la" "..08 - Viewports" "")
		)

		;in modelspace
		((= (getvar "tilemode") 1) 
		(command "view")
		)
	)
	(princ)
)


;# makes a polygon viewport on the ..08 - Viewports layer
(defun C:vv ( / )
	(command "mview" "P" (while (> (getvar "cmdactive") 0) (command pause)))
	(command ".chprop" "l" "" "_layer" "..08 - Viewports")
	(princ))

;# Converts an object intoa  viewport, sets sets the layer to ..08 - Viewports
(defun C:vvv (/ convert_to_viewport)
	(setq Convert_to_Viewport (ssget))
	(command "mview" "O" Convert_to_Viewport)
	(command ".chprop" "l" "" "_layer" "..08 - Viewports" "")
	(princ)
)


;# Mirror selected objects on the XY plane
(defun c:xy( / eset )
	(setq eset (ssget))
	(command "mirror3d" eset "" "_non" '(0 0 0) "_non" '(10 5 0) "_non" '(5 10 0))
	(princ))

;# Mirror selected objects on the ZY plane
(defun c:zy( / eset )
	(setq eset (ssget))
	(command "mirror3d" eset "" "_non" '(0 0 0) "_non" '(0 10 5) "_non" '(0 5 10))
	(princ))

;# Mirror selected objects on the XZ plane
(defun c:xz( / eset )
	(setq eset (ssget))
	(command "mirror3d" eset "" "_non" '(0 0 0) "_non" '(10 0 5) "_non" '(5 0 10))
	(princ))


;# Slice selected objects on the XY plane thru point
(defun c:xy`( / eset )
	(setq eset (ssget))
	(command "slice" eset "" "xy" pause )
	(princ))

;# Slice selected objects on the ZY plane
(defun c:zy`( / eset )
	(setq eset (ssget))
	(command "slice" eset "" "zy" pause )
	(princ))

;# Slice selected objects on the XZ plane
(defun c:xz`( / eset )
	(setq eset (ssget))
	(command "slice" eset "" "zx" pause )
	(princ))


;# NAVCube Popup v1.0 - mdj 2010
(defun c:cu()
	(if (or (= 10 oldnavcubedisp) (= nil oldnavcubedisp))
		(progn
			(setq cu:oldnavcubedisp (getvar "navvcubedisplay"))
			(setq cu:oldnavcubesize (getvar "navvcubesize"))
			(setvar "navvcubedisplay" 3)
			(setvar "navvcubesize" 4))
		(progn
			(setvar "navvcubedisplay" cu:oldnavcubedisp)
			(setvar "navvcubesize" cu:oldnavcubesize)
			(setq cu:oldnavcubedisp 10))))

;# Edgemode Toggle v0.1 - mdj 2009
(if (= edgemode_toggle nil)
	(defun edgemode_toggle()
		(if	(= (getvar "edgemode") 0)
				(setvar "edgemode" 1)
				(setvar "edgemode" 0))))

;# Trim command with edgemode toggle
(defun c:tr`()
	(edgemode_toggle)
	(command "trim" (while (> (getvar "cmdactive") 0) (command pause)))
	(edgemode_toggle)
	(princ))

;# Extend command with edgemode toggle
(defun c:ex`()
	(edgemode_toggle)
	(command "extend" (while (> (getvar "cmdactive") 0) (command pause)))
	(edgemode_toggle)
	(princ))

;# Edgemode toggle command
(defun C:em()
	(edgemode_toggle)
	(princ))

;# ViewUpdateAuto Toggle v0.1 - mdj 2015
(defun C:va()
		(if	(= (getvar "viewupdateauto") 0)
				(setvar "viewupdateauto" 1)
				(setvar "viewupdateauto" 0)))

;# allow divide the use of noun/verb selection
(defun c:di( / eset )
	(setq eset (ssget))
	(command "divide" eset pause )
	(princ))

;# send to back
(defun c:ba ()
	(command "DRAWORDER" "B")
	(princ))

;# send to front
(defun c:fw ()
	(command "DRAWORDER" "F")
	(princ))

;# ADD object to Refedit
(defun c:rea ()
	(command "refset" "a")
	(princ))

;# REMOVE object to Refedit
(defun c:rer ()
	(command "refset" "r")
	(princ))


;       ###   View   ###
;==================================
(debug? "\n  View... ")

(defun c:vc ()
	(command "VSCURRENT" "c")
	(princ))

(defun c:v2 ()
	(command "VSCURRENT" "2")
	(princ))

(defun c:vg ()
	(command "VSCURRENT" "g")
	(princ))

(defun c:v3 ()
	(command "VSCURRENT" "3")
	(princ))

(defun c:vr ()
	(command "VSCURRENT" "r")
	(princ))
	
(defun c:vh ()
	(command "VSCURRENT" "h")
	(princ))
	
(defun c:vx ()
	(command "VSCURRENT" "x")
	(princ))
	
	
(defun c:`t ()
	(command "-View" "orthographic" "top")
	(princ))

(defun c:`f ()
	(command "-View" "orthographic" "front")
	(princ))
	
(defun c:`r ()
	(command "-View" "orthographic" "right")
	(princ))

(defun c:`l ()
	(command "-View" "orthographic" "left")
	(princ))

(defun c:`b ()
	(command "-View" "orthographic" "back")
	(princ))

(defun c:`bb ()
	(command "-View" "orthographic" "bottom")
	(princ))

(defun c:`p ()
	(command "plan" "")
	(princ))
	
;# redefine origin without changing ucs orientation
(defun c:or ()
	(command "ucs" "o" pause)
	(princ))

;# UCS Object
(defun c:uob ()
	(command "ucs" "ob" pause)
	(princ))

;# UCS world
(defun c:uw ()
	(command "ucs" "w")
	(princ))

;# UCS View
(defun c:uv()
	(command "ucs" "v")
	(princ))

;# UCS Face
(defun c:uf()
	(command "ucs" "f" (while (> (getvar "cmdactive") 0) (command pause)))
	(princ))

;# UCS 3 Points
(defun c:u3()
	(command "ucs" "3p" (while (> (getvar "cmdactive") 0) (command pause)))
	(princ))

;# UCS 2 Points
(defun c:u2()
	(command "ucs" "3p" (while (> (getvar "cmdactive") 0) (command pause)))
	(princ))

;# UCS previous
(defun c:u` ()
	(command "ucs" "p")
	(princ))

;# Previous Zoom
(defun c:z` ()
  (command "zoom" "p"))

;# zoom to 95% of screen
;from some autocad book - thanks dude, I use this all of the time
(defun c:zx ()
	(command "Zoom" "e" "zoom" "s" "0.95x")
	(princ))

;# Tilemode switcher
(defun c:tt ()
	(if (= 0 (getvar "tilemode"))
		(setvar "tilemode" 1)
		(setvar "tilemode" 0))
	(princ))

;# OsnapZ switcher
(defun c:sz ( / *error*)
	(defun *error* (msg)
		(setvar "osnapz" 0)
		(setvar "pickbox" sz:old_pickbox)
		(princ))

	(if (= 0 (getvar "osnapz"))
		(progn
			(setq sz:old_pickbox (getvar "pickbox"))
			(setvar "osnapz" 1)
			(prompt "\nOsnap-Z: ACTIVE")
			(setvar "pickbox" 15))
		(progn
			(setvar "osnapz" 0)
			(prompt "\nOsnap-Z: OFF")
			(setvar "pickbox" sz:old_pickbox)))
	(princ)
	)

;# Annotation Monitor switcher
(defun c:am ( / *error*)
	(defun *error* (msg)
		(setvar "ANNOMONITOR" 2)
		(princ)
		)

	(if (or (= 0 (getvar "ANNOMONITOR")) (> 0 (getvar "ANNOMONITOR")))
		(progn 
			(setvar "ANNOMONITOR" 2)
			(prompt "\nAnnotation Monitor: ACTIVE")
			)

		(progn
			(setvar "ANNOMONITOR" 0)
			(prompt "\nAnnotation Monitor: DISABLED")		
			)
		)
	
	(princ)
	)


;        ###   Misc   ###
;==================================
(debug? "\n  Misc... ")

;Super-purge AUTO
(defun c:purge-and-close ()
	(command "vs" "2")
	(command "-View" "orthographic" "top")
	(command "Zoom" "e" "zoom" "s" "0.95x")
	(command "-purge" "a" "" "no")
	(command "qsave")
	(command "close" "y")
	)

;#flatshot shortcut
(defun c:ff ()
	(command "ucs" "w")
	(command "ucs" "o" pause)
	(command "flatshot" "0,0,0" "" "" "")
	(princ))

;#Magic Divide - divide between two mouse clicks without creating temporary lines.
(defun c:di`( / eset tmp)	
	(command "line" pause pause "")
	(setq eset (entlast))
	(command "divide" eset pause)
	(command "erase" eset "")	
	)

(setq text_editor "C:/Users/mjordan/bin/scite/SciTE.exe")
(defun c:pgp()	(startapp text_editor (findfile "acad.pgp")))
(defun c:util()	(startapp text_editor (findfile "utilities.lsp")))

;#open explorer at LISP Directory
(defun c:lisp ()
	(startapp "explorer.exe" "X:\\acad\\LISP"))

	
;# Set PSLTSCALE to 1 in each layout
(defun c:pls( / lay )
  (foreach lay
    (layoutlist)
    (command "_LAYOUT" "_Set" lay "PSLTSCALE" 1)))

(defun c:pw()
	(command "plinewid"))

;# set default OSnaps
(defun c:oss ()
	(setvar "osmode" 191)
	(princ))


(debug? "\n  Arc Tools")
;#####################
;###   Arc Tools   ###
;#####################

;###   Dimension Temporary Arc   ###

(defun c:darr ( / arc )
(command "arc" (while (> (getvar "cmdactive") 0) (command pause)))
	(setq arc (entlast))
	(command "dimarc" (while (> (getvar "cmdactive") 0) (command pause)))
	(entdel arc)
)

;###   Rectify Arcs to x-axis   ###
;version 0.5
;Matthew D. Jordan 2010

;Measures selected arc lengths and maps them along a specified path with points
;
;ADD: UCS stuff all in code
;ADD: error handline for picking not arcs
;ADD: ability to pick only a section of an arc polyline
;ADD: ability to pick straight lines as well???

(defun c:rarc ( / *error* *model* acMS pt1 ang x y z e msg )
	(defun *error* (msg)
		(command "ucs" "named" "restore" "temporary")
		(command "ucs" "named" "delete" "temporary")
		(princ msg))

	(command "ucs" "named" "save" "temporary" "")
	(command "ucs" "w")
	(vl-load-com)

	(setq *model* (vla-get-modelspace 
	            (vla-get-ActiveDocument
							  (vlax-get-acad-object))))

	(setq pt1 (getpoint "Specify start point of line: "))
				
	(vlax-invoke *model* 'AddPoint pt1)
	(setq ang (getangle pt1 "Specify direction: "))

	
	(while t
		(print "make point") 
		(setq e nil)

		(while (not e)
				(setq e (car (entsel))))
		
;			(setq e (vlax-get-property (vlax-ename->vla-object e) 'Length)
;					pt1 (polar pt1 ang e ))
			(setq e (vlax-get-property (vlax-ename->vla-object e) 'ArcLength)
					pt1 (polar pt1 ang e ))

	 	(vlax-invoke *model* 'AddPoint pt1)))



;###############################
;###   Sweep along Profile   ###
;###############################
; version 0.01
; Matthew D. Jordan
; 

(defun c:sa()

	(command "sweep" pause "b" pause pause "")
	(princ)
)



;########################################
;###   (Coordinates) XY Multileader   ###
;########################################
(debug? "\n  CXY ML")
(defun C:cxy ( / pt1 pt2 tmp )
  (setvar "cmdecho" 0)

  (while (not pt1) (setq pt1 (getpoint "\nSpecify point to dimension: ")))
  (while (not pt2) (setq pt2 (getpoint pt1 "\nSpecify start point of text: ")))
  (setq tmp (strcat "PL=" (rtos (abs (cadr pt1)) 4 4) "\n" "CL=" (rtos (abs (car pt1)) 4 4) "\n"))
	(initcommandversion)
	(command "mleader" pt1 pt2 tmp)

  (setvar "cmdecho" 1)
  (princ))


;##############################
;###   Dupe(licate Layer)   ###
;##############################
; version 1.102
; Matthew D. Jordan
; 
; Duplicate a selected layer while specifying a new layer name.  It will keep
; making new duplicate layers until a blank line is returned.
(debug? "\n  Duplicate Layers...")

(defun c:dupe ( / *error* eset orig_name table_list new_name new_lay )

	(defun *error* (msg)
	    (princ))

	(setq eset (car (entsel "Select object on layer or <current> : ")))

	(if eset
			(setq orig_name (cdr (assoc 8 (entget eset))))	
			(setq orig_name (getvar "clayer")))

	;pull layer's information
	(setq table_list (entget (tblobjname "LAYER" orig_name)))  (prompt orig_name)

	(while (= 0 0)
		(setq new_name (getstring T "\nEnter name of new layer or <exit> : "))
 		(if (= new_name "")(quit))

		(setq new_lay (list
			'( 0 . "LAYER")		
			'(100 . "AcDbSymbolTableRecord")
			'(100 . "AcDbLayerTableRecord")
			(cons 2 new_name)
			(assoc 62 table_list)
			(assoc 6  table_list)
			(assoc 70 table_list)
			(assoc 5  table_list)))

		;test to see if new layer already exists!
		(if (tblsearch "LAYER" new_name)
				(progn
					(setq new_name nil)
					(prompt " -- This layer already exists.  Try again cheesedog.\n"))
				(entmake new_lay)))

	(princ))
	

;#################
;###   Nudge   ###
;#################
; version 1.02
; by Matthew D. Jordan

; Nudge selected objects via a seletced base point, rounded to the nearest measurement increment.
(debug? "\n  Nudge")
(defun c:ng ( / *error* pt1 pt2 eset done i temp)

	(defun *error* (msg)
		(echo old_cmdecho))

	(while (not eset)(setq eset (ssget)))
	(echo 0)

	(if (not nudge:increment) (setq nudge:increment 0.125))

	(while (/= done 1)
		(initget 129 "Increment Origin ? eXit")
		(prompt (strcat "Rounding increment: " (rtos nudge:increment 5 5)))
		(setq pt1 (getpoint "\nSelect base point or [Increment/Origin/?/eXit]<Increment> : "))

		(cond
			((listp pt1)
				(foreach i (reverse pt1)
					(cond 
						((zerop i)(setq temp i)) ;case 1 - prevent those wiley div by zeros!
						((= 1 1)
							;(prompt "\n == Rounding == \n")
							(setq temp (/ i nudge:increment))
							(setq temp (* nudge:increment (fix (+ temp (* (/ temp (abs temp)) 0.5)))))))

				(if (not pt2) (setq pt2 (cons temp nil)) (setq pt2 (cons temp pt2))))

				(command "move" eset "" pt1 pt2)
				(setq done 1))

			((= pt1 "Increment")
				(initget 7)
				(setq nudge:increment (getreal "Enter new rounding increment: ")))

			((= pt1 "Origin") (command "ucs" "3" pause "" "")) ;case 3

			((= pt1 "?")
				(prompt "\nShowing the origin point. Return to <exit> : ")
				(command "circle" "0,0,0" pause)
				(entdel (entlast)))

			((= pt1 "eXit") (setq done 1))))

	(echo old_cmdecho)
	(princ))


;#######################
;###   Third Party   ###
;#######################
(debug? "\n  3rd Party...")


(debug? "\n    Breakpoint...")
;# breaks selected object at the point you pick
; via someone else, don't know who.
(defun c:bb (/ object breakpoint)
	(setq object (entsel))
	(setq breakpoint (getpoint "pick  breakpoint "))
 	(command "break" object "f" breakpoint "@")
	(princ))

;# Delete ALL entities on specified layer
;  Bob Zelna
(debug? "\n    Wipe Layer...")
(defun c:wipe()
	(command ".ERASE" (ssget "X" (list (cons 8 (cdr (assoc 8 (entget (car (entsel)))))))) "")
	(princ))