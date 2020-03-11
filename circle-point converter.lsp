
;# Insert a point at each selected circle's centerpoint,
;# add options to select all circles in drawing, all circles on layer, all circles on screen, selected circles
;# add delete circle option or make default

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



; TODO: create a function to convert points to circles to points
; Select the following:
;	All points
;	points on screen?
;	points on layer?
;	selected points
; Specify size of created circles (Diameter/Radius)

