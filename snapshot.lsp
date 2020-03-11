(or debug? (defun debug?( Value /)(or(= *debug* nil)(prompt Value))))
;(setq *debug* T)
(debug? "Snapshot loading...")

;####################
;###   Snapshot   ###
;####################
;version: 1.3
;
;	Matthew D. Jordan - May 2012
;
; Handles drawing snapshots (e.g. "/dwgprefix/OldVersions/file.v1 - suffix.dwg").
;
; Command: Snapshot
;		1. Location - 	edit the snapshot directory location
;		2. Show 	-	show the snapshot directory in explorer
;		3. Version - 	edit the document revision number 

(vl-load-com)

(setq doc (vla-get-summaryinfo (vla-get-activedocument (vlax-get-acad-object)))
	  snapshot-value-default "OldVersions")


(defun snapshot-engine ( / revision-value dwg-full snapshot-directory new-file tmp tmp_rev)

	(if (and (>= (atoi (vla-get-revisionnumber doc)) 0) (>= 9 (atoi (vla-get-revisionnumber doc))))
		(setq revision-value (strcat "0" (vla-get-revisionnumber doc)))
		(setq revision-value (vla-get-revisionnumber doc))
		)
	
	(setq 	dwg-full (strcat (getvar "dwgprefix") (getvar "dwgname"))
			tmp (getstring "\nSpecify a suffix: " T)
			snapshot-directory (strcat (getvar "dwgprefix") snapshot-value "\\")
			new-file (strcat snapshot-directory (vl-filename-base dwg-full) ".r" revision-value))

	(if (not (= tmp ""))
		(setq tmp (strcat " - " tmp)))
	
	(if (not (vl-file-directory-p snapshot-directory))
	    	 (vl-mkdir snapshot-directory))
	
	(while (= (vl-file-copy dwg-full (strcat new-file tmp ".dwg")) nil)
        (if (setq tmp (getstring "\nThis file already exists, specify a different suffix: "))
			(setq tmp (strcat " - " tmp))))

	(prompt ": Snapshot saved.")

	;;	increment-revision number
	(vla-put-revisionnumber doc (itoa (1+ (atoi (vla-get-revisionnumber doc)))))
		
  (princ))


(defun c:snapshot( / *error* revision-value finished snapshot-value)
	(defun *error* (msg)
		(if (and msg (/= msg "") (not (wcmatch (strcase msg) "*QUIT*,*CANCEL*")))
		(princ (strcat "\nError: " msg))))

	(defun snapshot?()
	(if	(vl-catch-all-error-p (vl-catch-all-apply 'vla-GetCustomByKey (list doc "Snapshot" 'snapshot-value)))
	      (progn (zerop 1)(setq snapshot-value nil))
	      (zerop 0)))
	
	
	(defun revision?()
		(if (= (vla-get-revisionnumber doc) "")
			(progn (zerop 1)(setq revision-value nil))
			(zerop 0)))


	(if (not (snapshot?))
		(progn
			(vla-addcustominfo doc "Snapshot" snapshot-value-default)
			(snapshot?)
		))

	(if (not (revision?))
		(vla-put-revisionnumber doc "0"))


	(while (= finished nil)
	(prompt (strcat "Current Version: " (vla-get-revisionnumber doc) "     Location: " snapshot-value))
	(initget "Yes Location Revision Show eXit")
		(setq answer (getkword "\nTake Snapshot? [Yes/Location/Revision/Show/eXit]<Yes>: "))


	(cond	
		((or (= answer "Yes") (= answer nil))
			(if (snapshot?)
				(snapshot-engine)
				(prompt "\nNo snapshot directory specified... Please set a snapshot directory: "))
				(setq finished 1))

		((or (= answer "Location") (and (= answer "Show") (not (snapshot?))))
			(setq snapshot-value (getstring  (strcat "Specify snapshot sub-directory [Default/eXit] <" snapshot-value-default ">: ")))
			(cond
				((or (= snapshot-value "") (= "d" (strcase snapshot-value T)) (= "default" (strcase snapshot-value T)))
					(vl-catch-all-apply 'vla-removecustombykey (list doc "Snapshot"))
					(vl-catch-all-apply 'vla-addcustominfo (list doc "Snapshot" snapshot-value-default))
					(prompt snapshot-value))

;				((or (= "c" (strcase snapshot-value T)) (= "choose" (strcase snapshot-value T)))
;					(setq  snapshot-value (acet-ui-pickdir))
;					(vl-catch-all-apply 'vla-removecustombykey (list doc "Snapshot"))
;					(vl-catch-all-apply 'vla-addcustominfo (list doc "Snapshot" snapshot-value)))
				
				((or (= "x" (strcase snapshot-value T)) (= "exit" (strcase snapshot-value T)))
					(princ))
				
				((/= snapshot-value)
					(vl-catch-all-apply 'vla-removecustombykey (list doc "Snapshot"))
					(vl-catch-all-apply 'vla-addcustominfo (list doc "Snapshot" snapshot-value))))
					
			(snapshot?)
			(prompt "\n --- \n"))

		((and (= answer "Show") (snapshot?))
			(startapp "explorer.exe" (strcat (getvar "dwgprefix") snapshot-value "\\"))
			(setq finished 1))

		((and (= answer "Revision"))
			(setq revision-value (getint (strcat "Change Revision No. <" (vla-get-revisionnumber doc) "> : ")))
			(cond
				((= revision-value nil))

				((numberp revision-value)
					(vla-put-revisionnumber doc revision-value)))
			(prompt "\n ---- \n"))


		((= answer "eXit") (setq finished 1))))

	(princ)
) ;defun