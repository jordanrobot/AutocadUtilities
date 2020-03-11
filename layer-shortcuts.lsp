(or debug? (defun debug?( Value /)(or (not *debug*)(prompt Value))))
;(setq *debug* T)
(debug? "\nLayer Tools Loading...")

;####################################
;###   Standard Layer Shortcuts   ###
;####################################
;
;
;	2009-2012 - Matthew D. Jordan

(debug? "Standard Layer Tools... ")

;# set current layer to...
(defun c:0() (setvar "clayer" "0"))
(defun c:1() (setvar "clayer" "..01 - Medium"))
(defun c:2() (setvar "clayer" "..02 - Light"))
(defun c:3() (setvar "clayer" "..03 - Thick"))
(defun c:4() (setvar "clayer" "..04 - Hidden"))
(defun c:44()(setvar "clayer" "..04 - Hidden2"))
(defun c:5() (setvar "clayer" "..05 - Center"))
(defun c:6() (setvar "clayer" "..06 - Phantom"))
(defun c:7() (setvar "clayer" "..07 - Section Cut"))
(defun c:8() (setvar "clayer" "..08 - Viewports"))
(defun c:9() (setvar "clayer" "..09 - Hatch"))

;==================================

;# move selected objects to layer...
(defun c:m0 ( / eset) (setq eset (ssget)) (command ".chprop" "_p" "" "_la" "0" ""))
(defun c:m1 ( / eset) (setq eset (ssget)) (command ".chprop" "_p" "" "_la" "..01 - Medium" ""))
(defun c:m2 ( / eset) (setq eset (ssget)) (command ".chprop" "_p" "" "_la" "..02 - Light" ""))
(defun c:m3 ( / eset) (setq eset (ssget)) (command ".chprop" "_p" "" "_la" "..03 - Thick" ""))
(defun c:m4 ( / eset) (setq eset (ssget)) (command ".chprop" "_p" "" "_la" "..04 - Hidden" ""))
(defun c:m44( / eset) (setq eset (ssget)) (command ".chprop" "_p" "" "_la" "..04 - Hidden2" ""))
(defun c:m5 ( / eset) (setq eset (ssget)) (command ".chprop" "_p" "" "_la" "..05 - Center" ""))
(defun c:m6 ( / eset) (setq eset (ssget)) (command ".chprop" "_p" "" "_la" "..06 - Phantom" ""))
(defun c:m7 ( / eset) (setq eset (ssget)) (command ".chprop" "_p" "" "_la" "..07 - Section Cut" ""))
(defun c:m8 ( / eset) (setq eset (ssget)) (command ".chprop" "_p" "" "_la" "..08 - Viewports" ""))
(defun c:m9 ( / eset) (setq eset (ssget)) (command ".chprop" "_p" "" "_la" "..09 - Hatch" ""))
(defun c:mf ( / eset) (setq eset (ssget)) (command ".chprop" "_p" "" "_la" "..cnc - Fast" ""))
(defun c:mc ( / eset) (setq eset (ssget)) (command ".chprop" "_p" "" "_la" "..cnc - Caution" ""))
;==================================

;#	copy to ____ layer function
(defun copy_to( layer / eset )
	(while (not eset)(setq eset (ssget)))
	(echo 0)(undo "begin")
	(command "_copy" eset "" "d" "")
	(command ".chprop" eset "" "la" layer "")
	(command "draworder" "p" "" "F")
	(echo 1)(undo "end")
	;prompt for Displacement or Exit?
	(princ))

;# copy to current layer
(defun c:ctc() (copy_to (getvar "clayer"))(princ))

;# copy to ___ layer
(defun c:c`() (copy_to ".sketch") (princ))
(defun c:c0() (copy_to "0") (princ))
(defun c:c1() (copy_to "..01 - Medium") (princ))
(defun c:c2() (copy_to "..02 - Light") (princ))
(defun c:c3() (copy_to "..03 - Thick") (princ))
(defun c:c4() (copy_to "..04 - Hidden") (princ))
(defun c:c44()(copy_to "..04 - Hidden2") (princ))
(defun c:c5() (copy_to "..05 - Center") (princ))
(defun c:c6() (copy_to "..06 - Phantom") (princ))
(defun c:c7() (copy_to "..07 - Section Cut") (princ))
(defun c:c8() (copy_to "..08 - Viewports") (princ))
(defun c:c9() (copy_to "..09 - Hatch") (princ))


;==================================

;# make selected objects look like a ... object function
(defun look_like( color linetype lineweight / eset )
	(echo 0)
	(setq eset (ssget))
	(command ".chprop" "_p" "" "_c" color "lt" linetype "lw" lineweight "")
	(echo 1)
	(princ))

;# Look Like... shortcuts
(defun c:by() (look_like "bylayer" "bylayer" "bylayer") (princ))	;by layer
(defun c:i1() (look_like "0"   "continuous" "0.25") (princ))	;med
(defun c:i2() (look_like "142" "continuous" "0.1")  (princ))	;light
(defun c:i3() (look_like "230" "continuous" "0.4")  (princ))	;hidden
(defun c:i4() (look_like "44"  "hidden"     "0.1")  (princ))	;hidden2
(defun c:i44()(look_like "44"  "hidden2"    "0.1")  (princ))	;centerline
(defun c:i5() (look_like "84"  "center"     "0.01") (princ))	;phantom
(defun c:i6() (look_like "234" "phantom"    "0.1")  (princ))	;thick
(defun c:i7() (look_like "230" "phantom"    "0.4")  (princ))	;section line
(defun c:i8() (look_like "11"  "continuous" "0.0")  (princ))	;dashed
(defun c:i9() (look_like "8"   "continuous" "0.1")  (princ))	;dashed
