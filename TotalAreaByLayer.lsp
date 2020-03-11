;############################
;###   TotalAreaByLayer   ###
;############################
;;	2019 - jordanrobot
;;
;; basic area calculation routine was based on POLYAREA.LSP from Tee Square Graphics


(defun C:tabl ( / layerList i output)

	;Add your custom layer names here:
	(setq layerList   '("0"
  						"..02 - Light"
  						"third layer"
  						"fourth layer"
  					 	))

  	;Set the inital definition for the resultList, values will be added onto this list later
	(setq resultList '(" "))

	;go through each layer in the layerList and run the areaCalculator
	(foreach temp layerList 
		;If the current layer exists in the drawing, do the calc.  If not, skip that layer
  		(if (tblsearch "LAYER" temp) (areaCalculator temp)))


  	;Format the output list of areas into a single string, to feed into the alert
    (setq output (car resultList))
	;(print resultList)
    (foreach i (cdr resultList) (setq output (strcat output "\n\n" i)))

    ;Print final list of areas in a message box for the user
	(alert output)

)
 
 ;Function to calculate the =total area of the closed shapes on each layer
(defun areaCalculator (tempLayer / a ss n du) 

	(princ (strcat "running area calculator for " tempLayer))
	;set variables, the dimenstionunit, and set the selection set for the closed objects on the layer
	(setq a 0
		du (getvar "dimunit")
		ss (ssget "_x" (List (cons 0 "*POLYLINE,CIRCLE")(cons 8 tempLayer))))
	; If there are selected objects...
	(if ss
		;calculate the area
		(progn
			(setq n (1- (sslength ss)))
				(while (>= n 0)
					(command "_.area" "_o" (ssname ss n))
					(setq a (+ a (getvar "area")) n (1- n)))
				;append the area results to the resultList
				(setq resultList
					(cons  
						(strcat "Layer: " tempLayer "\nArea = "
							(if (or (= du 3)(= du 4)(= du 6))
								(strcat ;(rtos a 2 2) " sq. in | " ;uncomment to report in inches
									(rtos (/ a 144.0) 2 3) " sq. ft")

							(strcat (rtos a 2 3) " square units.")))
						resultList)))
		;No objects were found in the current layer, record an area of 0 to the resultList
		(setq resultList (cons (strcat "Layer: " tempLayer "\nArea = 0") resultList )))
	(princ)
)
(princ)