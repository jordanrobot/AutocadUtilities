;#####################
;###   Main Form   ###
;#####################


(defun c:Context_formMain_buttonNew_OnClicked (/)
	(setq flagSave 0)
  (dcl_Form_Show Context_formSave)
)

(defun c:Context_formMain_buttonProperties_OnClicked (/)
	(AddProps)
)

(defun c:Context_formMain_buttonSaveAs_OnClicked (/)
	(setq flagSave 1)

  (dcl_Form_Show Context_formSave)
 )

(defun c:Context_formMain_butonExplorer_OnClicked (/)
	(Explore (strcat (caddr currentProject)	(caddr currentTask)))
)

(defun c:Context_formMain_buttonRefresh_OnClicked (/)
	(Startup)
)



(defun c:Context_formMain_OnInitialize (/)

	(Startup)
)




;############################
;###   Right Click Item   ###
;############################

;(defun c:Context_formMain_gridCurrent_OnMouseUp (Button Flags X Y /)
;  (if (= 2 button)
;  	(dcl_Form_Show Context_ActionForm X Y)
;  )
;)

;##########################
;###   On File Change   ###
;##########################

(defun c:Context_formMain_OnDocActivated (/)

	(Startup)

)




;###################
;###   Options   ###
;###################

(defun c:Context_formMain_buttonOptions_OnClicked (/)
	(dcl_Form_Show Context_formOptions)
)


;esc key
(defun c:Context_formOptions_OnCancel (/)
	(dcl_Form_Close Context_formOptions)
)

;enter key
(defun c:Context_formOptions_OnOK (/)
	(dcl_Form_Close Context_formOptions)
)


;#################################
;###   Browse Project Button   ###
;#################################

(defun c:Context_formMain_buttonBrowseProject_OnClicked ( / temp)
	(SetBrowseInfo)
	(UpdateBrowseInfo)
)


;##############################
;###   Browse Task Button   ###
;##############################

(defun c:Context_formMain_buttonBrowseTask_OnClicked ( / temp)
	(SetBrowseInfo)
	(UpdateBrowseInfo)
)


;########################
;###   Grid Buttons   ###
;########################


(defun c:Context_formMain_buttonDWG_OnClicked (/)
	(ButtonToggle 1)
)

(defun c:Context_formMain_buttonCNCShop_OnClicked (/)
	(ButtonToggle 2)
)

(defun c:Context_formMain_buttonBOM_OnClicked (/)
	(ButtonToggle 3)
)

(defun c:Context_formMain_buttonParts_OnClicked (/)
	(ButtonToggle 4)
)

(defun c:Context_formMain_buttonAnalysis_OnClicked (/)
	(ButtonToggle 5)
)

(defun c:Context_formMain_buttonTheatre_OnClicked (/)
	(ButtonToggle 6)
)
True

(defun ButtonToggle (val / )

	(dcl_Control_SetEnabled Context_formMain_buttonDWG 		"True")
	(dcl_Control_SetEnabled Context_formMain_buttonCNCShop 	"True")
	(dcl_Control_SetEnabled Context_formMain_buttonBOM 		"True")
	(dcl_Control_SetEnabled Context_formMain_buttonParts 	"True")
	(dcl_Control_SetEnabled Context_formMain_buttonAnalysis "True")
	(dcl_Control_SetEnabled Context_formMain_buttonTheatre 	"True")

	(cond
		((= val 1) (dcl_Control_SetEnabled Context_formMain_buttonDWG 		"False"))
		((= val 2) (dcl_Control_SetEnabled Context_formMain_buttonCNCShop 	"False"))
		((= val 3) (dcl_Control_SetEnabled Context_formMain_buttonBOM 		"False"))
		((= val 4) (dcl_Control_SetEnabled Context_formMain_buttonParts 	"False"))
		((= val 5) (dcl_Control_SetEnabled Context_formMain_buttonAnalysis 	"False"))
		((= val 6) (dcl_Control_SetEnabled Context_formMain_buttonTheatre 	"False")))
)




;#########################
;###   Form Save/New   ###
;#########################

(defun c:Context_formSave_OnInitialize (/)

	(if (= flagSave 1)
		(progn
			(dcl_Control_SetEnabled Context_formSave_buttonCreate "False")
			(dcl_Control_SetEnabled Context_formSave_buttonSave "True")
		)
		(progn
			(dcl_Control_SetEnabled Context_formSave_buttonCreate "True")
			(dcl_Control_SetEnabled Context_formSave_buttonSave "False")
		)
	)
)	


(defun c:Context_formSave_buttonCreate_OnClicked (/)
  (dcl_Form_Close Context_formSave 0)
)

(defun c:Context_formSave_buttonSave_OnClicked (/)
  (dcl_Form_Close Context_formSave 0)
)

(defun c:Context_formSave_buttonCancel_OnClicked (/)
  (dcl_Form_Close Context_formSave 0)
)

(defun c:Context_formSave_buttonProjectOpen_OnClicked (/)
	(DirectoryDialog "Select Project Directory..." "\\" 1)
)

(defun c:Context_formSave_buttonTaskOpen_OnClicked (/)
	(DirectoryDialog "Select Project Directory..." "\\" 1)
)
