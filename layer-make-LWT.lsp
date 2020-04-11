;###############################
;###   Layer Populate Tool   ###
;###############################
;version 2.0

; Matthew D. Jordan - Summer 2010
;
; Creates predefined layers - appends the layer names to a show label provided at run

; Command:
;		LWT

;Color Values
;============
; Red = 0
; Yellow = 1
; Green = 3
; Cyan = 4
; Blue = 5
; Magenta = 6
; White = 7
; Grey = 8
; Light Grey = = 9
; Orange = 40

;Lineweight Values
;=================
;ByLwDefault = -3
;ByBlock = -2
;ByLayer = -1
;Other Values are : 0, 5, 9, 13, 15, 18, 20, 25, 30, 35, 40, 50, 53, 60, 70, 80, 90, 100, 106, 120, 140, 158, 200, 211.


(defun c:LWT ( / layer_list tmp show_label theLayers i acadDocument LayerTable)

	(setvar "cmdecho" 0)
	(setq show_label (getstring CR "Please enter the Show Label:"))


;		 (name) (color #) (ON/OFF) (linetype) (Plot/noPlot) (lineweight)
	(setq layer_list '(
		((" - Masking - Soft")("5")("ON")("continuous")("Plot")("25"))
		((" - Masking - Hard")("5")("ON")("continuous")("Plot")("25"))
		((" - Masking - Layout")("3")	("ON")("continuous")("Plot")("9"))
		((" - GP Notes")("3")	("ON")("continuous")("Plot")("25"))
		((" - Rigging")("244")("ON")("continuous")("Plot")("20"))
		((" - Rigging - Layout")("3")("ON")("continuous")("Plot")("9"))
		((" - Load-in - Layout")("3")("ON")("continuous")("Plot")("9"))
		((" - Deck - Platforms")("40")("ON")("continuous")("Plot")("20"))
		((" - Deck - Platforms - Layout")("3")("ON")("continuous")("Plot")("9"))
		((" - Deck - Platforms - Outline")("106")("ON")("continuous")("Plot")("20"))
		((" - _Temp Layout")("200")("ON")("continuous")("Plot")("20"))
		)
	) ;setq


(vl-load-com)
(setq activeDocument (vla-get-activedocument (vlax-get-acad-object))) 
(setq LayerTable (vla-get-layers activeDocument))

	(foreach tmp layer_list

		(setq i (vla-add LayerTable (strcat show_label (car (car tmp)))))

		(vla-put-color i (car (nth 1 tmp)))

		(if (eq "ON" (car (nth 2 tmp)))
			(vla-put-layeron i :vlax-true)
			(vla-put-layeron i :vlax-false)
		)

		(vla-put-linetype i (car (nth 3 tmp)))

		(if (eq "Plot" (car (nth 4 tmp)))
			(vla-put-plottable i :vlax-true)
			(vla-put-plottable i :vlax-false)
		)

		(vla-put-LineWeight i (car (nth 5 tmp)))

	)
	(setvar "cmdecho" 0)
	(princ)
)