;debug switch like this ===> (debug? "Text to output.")
(or debug? (defun debug?( Value /)(or (not *debug*)(prompt Value))))
;(setq *debug* T) ;uncomment to turn on debugging

;################################
;###   Toggle Hidden States   ###
;################################
;
;v1.0
;Matthew D. Jordan

(vl-load-com)
(defun c:togglehidden ( / bob i mark )
	(setq 	bob (ssget "X")
			mark (ssadd)
			i 	0)

	;Mark is a selection set of visible objects
	;Bob is a selection set of all objects

	(repeat (sslength bob)
		(setq obj (vlax-ename->vla-object (ssname bob i)))
		(if (eq :vlax-true (vla-get-Visible obj))
			(setq mark (ssadd (ssname bob i) mark))
		)
		(setq i (1+ i))
	)

	(debug? (strcat "\nVisible Items: " (itoa (sslength mark)) "\n"))
	(debug? (strcat "Hidden Items: " (itoa (- (sslength bob) (sslength mark))) "\n"))


	(if (/= (sslength bob) (sslength mark))
		(progn
			(command "unisolateobjects")
			(command "hideobjects" mark "")
		)
	)

(princ)
)