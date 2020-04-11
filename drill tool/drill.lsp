;#################
;###   Drill   ###
;#################
(setq drill:version "0.01")
;
;
; Matthew D. Jordan - (c) 2012
; 
; Create a drilled feature with the greatest of ease!
;
;	Command: DRILL
;


;####################
;###   Registry   ###
;####################

(defun drill:registry ( value / flag )

	(cond 
		;masterkey does not exist...
		((not drill:masterKey)
			(setq drill:masterKey "HKEY_CURRENT_USER\\Software\\MDJ\\Drill")
			(setq flag 1))
	
		;old version, so update the registry values
		((not (= drill:version (vl-registry-read drill:masterKey "Version")))
			(prompt "\nNew version detected, initializing registry values....\n")
			(vl-registry-delete drill:masterKey)
			(setq flag 1))
		
		;delete registry
		((= value 'delete)
			(vl-registry-delete drill:masterKey))

		;reset registry
		((= value 'reset)
			(setq flag 1))
	)

	;create the registry values
	(if (= flag 1)
		(progn
			(vl-registry-write drill:masterKey)
			(if (not (vl-registry-read drill:masterKey "x_position"))		(vl-registry-write drill:masterKey "x_position" "100"))
			(if (not (vl-registry-read drill:masterKey "y_position"))		(vl-registry-write drill:masterKey "y_position" "100"))
			(if (not (vl-registry-read drill:masterKey "width"))			(vl-registry-write drill:masterKey "width" "256"))
			(if (not (vl-registry-read drill:masterKey "height"))			(vl-registry-write drill:masterKey "height" "416"))
			(if (not (vl-registry-read drill:masterKey "bit_type"))	(vl-registry-write drill:masterKey "bit_type" "Fractional"))
			(if (not (vl-registry-read drill:masterKey "current_bit"))	(vl-registry-write drill:masterKey "current_bit" "3/8-16"))
			(if (not (vl-registry-read drill:masterKey "hole"))			(vl-registry-write drill:masterKey "hole" "on"))
			(if (not (vl-registry-read drill:masterKey "hole_layer"))		(vl-registry-write drill:masterKey "hole_layer" "Current"))
			(if (not (vl-registry-read drill:masterKey "auto_insert"))	(vl-registry-write drill:masterKey "auto_insert" "T"))
			(if (not (vl-registry-read drill:masterKey "debug"))			(vl-registry-write drill:masterKey "debug" "F"))
	
			(vl-registry-write drill:masterKey "Version" drill:version)
		)
	)
)

(drill:registry 0)

(if (vl-registry-read drill:masterKey "debug")
		(if (= (vl-registry-read drill:masterKey "debug") "T")
			(setq drill:debug T)))

(defun drill:debug?( Value /)
	(if (= drill:debug T)
		(prompt Value)
	)
)

;(setq drill:debug T)

;#######################
;###   Create Data   ###
;#######################
(drill:debug? "\n Initialize Data")


(setq drill:bit_type_list '("Fractional" "Decimal" "Numbered" "Lettered"))

;Form -> Pitch -> (NAME Tap_Diam Nominal_Diam)

(setq drill:Fractional '(
		("#1 - 64"		0.0595	0.073	)
		("#2 - 56"		0.07	0.086	)
		("#3 - 48"		0.0785	0.099	)
		("#4 - 40"		0.089	0.112	)
		("#5 - 40"		0.1015	0.125	)
		("#6 - 32"		0.1065	0.138	)
		("#8 - 32"		0.136	0.164	)
		("#10 - 24"		0.1495	0.19	)
		("#12 - 24"		0.177	0.216	)
		("1/4 - 20"		0.201	0.25	)
		("5/16 - 18"	0.257	0.3125	)
		("3/8 - 16"		0.3125	0.375	)
		("7/16 - 14"	0.368	0.4375	)
		("1/2 - 13"		0.4219	0.5		)
		("9/16 - 12"	0.4844	0.5625	)
		("5/8 - 11"		0.5312	0.625	)
		("3/4 - 10"		0.6562	0.75	)
		("13/16 - 10"	0.7187	0.8125	)
		("7/8 - 9"		0.7656	0.875	)
		("15/16 - 9"	0.8281	0.9375	)
		("1 - 8"		0.875	1.0		)
		("1 1/16 - 8"	0.9375	1.0625	)
		("1 1/16 - 16"	1.0000	1.0625	)
		("1 1/8 - 7"	0.9844	1.125	)
		("1 1/8 - 8"	1.0000	1.125	)
		("1 1/4 - 7"	1.1094	1.25	)
		("1 1/4 - 8"	1.125	1.25	)
		("1 3/8 - 6"	1.2187	1.375	)
		("1 1/2 - 6"	1.3437	1.5		)
		("1 3/4 - 5"	1.5625	1.75	)
		("2 - 4.5"		1.7812	2.0		)
))

(setq drill:Decimal '(
		("1 x 0.25" 	0.0295276 	0.0393701	)
		("1.1 x 0.25" 	0.0334646 	0.0433071	)
		("1.2 x 0.25" 	0.0374016 	0.0472441	)
		("1.4 x 0.3" 	0.0433071 	0.0551181	)
		("1.6 x 0.35" 	0.0492126 	0.0629921	)
		("1.8 x 0.35" 	0.0570866 	0.0708661	)
		("2 x 0.4" 		0.0629921 	0.0787402	) 
		("2.2 x 0.45" 	0.0688976 	0.0866142	)
		("2.5 x 0.45" 	0.0807087 	0.0984252	)
		("3 x 0.5" 		0.0984252 	0.11811		)
		("3.5 x 0.6" 	0.114173 	0.137795	)
		("4 x 0.7" 		0.129921 	0.15748		) 
		("4.5 x 0.75" 	0.147638 	0.177165	)
		("5 x 0.8" 		0.165354 	0.19685		)
		("6 x 1" 		0.19685 	0.23622		)
		("7 x 1" 		0.23622 	0.275591	)
		("8 x 1.25" 	0.265748 	0.314961	)
		("9 x 1.25" 	0.305118 	0.354331	)
		("10 x 1.5" 	0.334646 	0.393701	)
		("11 x 1.5" 	0.374016 	0.433071	) 
		("12 x 1.75" 	0.403543 	0.472441	)
		("14 x 2" 		0.472441 	0.551181	)
		("16 x 2" 		0.551181 	0.629921	)
		("18 x 2.5" 	0.610236 	0.708661	)
		("20 x 2.5" 	0.688976 	0.787402	) 
		("22 x 2.5" 	0.767717 	0.866142	)
		("24 x 3" 		0.826772 	0.944882	)
		("27 x 3" 		0.944882 	1.06299		)
		("30 x 3.5" 	1.04331 	1.1811		)
		("33 x 3.5" 	1.16142 	1.29921		)
		("36 x 4" 		1.25984 	1.41732		)
		("39 x 4" 		1.37795 	1.53543		)
		("42 x 4.5" 	1.47638 	1.65354		) 
		("45 x 4.5" 	1.63386 	1.77165		)
		("48 x 5" 		1.69291 	1.88976		)
		("52 x 5" 		1.85039 	2.04724		) 
		("56 x 5.5" 	1.98819 	2.20472		)
		("60 x 5.5" 	2.14567 	2.3622		)
		("64 x 6" 		2.28346 	2.51969		)
		("68 x 6" 		2.44094 	2.67717		)
))

(setq drill:Numbered '(
	("Standard"
		("3/8 - 12"		0.3		0.375 		)
		("7/16 - 12"	0.3625	0.4375		)
		("1/2 - 10"		0.410	0.5			)
		("5/8 - 8"		0.5125	0.625		)
		("3/4 - 6"		0.6 	0.75 		)
		("7/8 - 6"		0.725 	0.875		)
		("1 - 5"		0.820 	1.0 		)
		("1 1/8 - 5"	0.945 	1.125 		)
		("1 1/4 - 5"	1.070 	1.25 		)
		("1 1/2 - 4"	1.275 	1.5 		)
))

(setq drill:Lettered '(
		("1/16 - 27"	0.242	0.3125	)
		("1/8 - 27" 	0.332	0.405	)	
		("1/4 - 18"		0.438	0.540	)
		("3/8 - 18"		0.562	0.675	)
		("1/2 - 18"		0.703	0.840	)
		("3/4 - 14"		0.906	1.050	)
		("1.0 -11.5"	1.141	1.315	)
		("1.25 - 11.5"	1.484	1.660	)
		("1.5 - 11.5"	1.719	1.900	)
		("2.0 - 11.5"	2.188	2.375	)
		("2.5 - 8"		2.609	2.875	)
		("3.0 - 8"		3.234	3.5		)
		("4.0 - 8"		4.25	4.5		)
))

(vl-load-com)
(or *doc* (setq *doc* (vla-get-ActiveDocument (vlax-get-acad-object))))
(or *mspace* (setq *mspace* (vla-get-ModelSpace *doc*)))
(or *layers* (setq *layers* (vla-get-Layers *doc*)))
(or *layouts* (setq *layouts* (vla-get-Layouts *doc*)))
(command "opendcl")



;###################################
;###   Set Switching Variables   ###
;###################################
(drill:debug? "\n Set Switching Variables")

(defun drill:Set_Bit(/)
	(setq drill:current_bit (vl-registry-read drill:masterKey "current_bit"))
)

(defun drill:Set_Bit_List (/)
	(dcl_ListBox_Clear Tap_Main_listTaps)
	;create list of taps from variables
	(dcl_ListBox_AddList Tap_Main_listTaps
		(mapcar '(lambda (x) (nth 0 x))
			(cdr (assoc drill:thread_pitch (eval drill:bit_type)))
		)
	)
)

(defun drill:Set_Thread_Pitch (/)
	(dcl_ComboBox_Clear tap_Main_comboPitch)

	(dcl_ComboBox_AddList tap_Main_comboPitch
		(mapcar '(lambda (x) (nth 0 x))
			(eval drill:bit_type)
		))

	(if (= -1 (dcl_ComboBox_SelectString tap_Main_comboPitch drill:thread_pitch))
		(dcl_ComboBox_SelectString tap_Main_comboPitch 
			(nth 0 	(mapcar '(lambda (x) (nth 0 x))(eval drill:bit_type)))
		)
	)

	(setq drill:thread_pitch (dcl_ComboBox_GetLBText tap_Main_comboPitch (dcl_ComboBox_GetCurSel tap_Main_comboPitch)))

	(drill:Set_Tap_List)
)



;###############################
;###   Main Dialogue: Init   ###
;###############################
(drill:debug? "\n Main Dialogue: Init")

;###   Main: Initialize   ###
(defun c:Tap_Main_OnInitialize (/ d r d1 r1 layer_list)
	
	;### Set the Tap Hole and Hidden Hole Visability Toggles
	(if (equal (vl-registry-read drill:masterKey "hole") "on") (dcl_Control_SetProperty Tap_Main_toggleTapHoles "Value" 1) (dcl_Control_SetProperty Tap_Main_toggleTapHoles "Value" 0))
	(if (equal (vl-registry-read drill:masterKey "hidden") "on") (dcl_Control_SetProperty Tap_Main_toggleHiddenHoles "Value" 1) (dcl_Control_SetProperty Tap_Main_toggleHiddenHoles "Value" 0))

	;### Thread Forms and Pitch Drop Downs
	;populate and select current thread form
	(dcl_ComboBox_Clear tap_Main_comboForm)
	(dcl_ComboBox_AddList tap_Main_comboForm drill:bit_type_list)
	(dcl_ComboBox_SelectString tap_Main_comboForm (vl-registry-read drill:masterKey "bit_type"))

	;### Set variables used in tap creation
	(setq drill:bit_type (read (strcat "drill:" (vl-registry-read drill:masterKey "bit_type"))))
	(setq drill:thread_pitch (vl-registry-read drill:masterKey "thread_pitch"))

	(drill:Set_Thread_Pitch)
	(drill:Set_Tap_List)

	;### Tap Layer Combo Box
	(setq layer_list (while (setq d (tblnext "layer" (null d))) (setq r (cons (cdr (assoc 2 d)) r))))
	(dcl_ComboBox_Clear Tap_Main_comboTapLayer)
	(dcl_ComboBox_AddList Tap_Main_comboTapLayer (cons "Current" (vl-sort layer_list '<)))
	(dcl_ComboBox_SelectString Tap_Main_comboTapLayer (if (tblsearch "layer" (vl-registry-read drill:masterKey "hole_layer"))
		(vl-registry-read drill:masterKey "hole_layer")
		"Current"))


	;###Hidden Layer Combo Box
	(dcl_ComboBox_Clear Tap_Main_comboHiddenLayer)
	(dcl_ComboBox_AddList Tap_Main_comboHiddenLayer (cons "Current" (vl-sort layer_list '<)))
	(dcl_ComboBox_SelectString Tap_Main_comboHiddenLayer (if (tblsearch "layer" (vl-registry-read drill:masterKey "hidden_layer"))
		(vl-registry-read drill:masterKey "hidden_layer")
		"Current"
		))

	;### select existing tap size
	(if drill:current_bit_index (dcl_ListBox_SetCurSel Tap_Main_listTaps drill:current_bit_index))
)



;#################################
;###   Main: Exit Conditions   ###
;#################################
(drill:debug? "\n Main Dialogue: Exit Conditions")

;###   Main: Close   ###
(defun c:Tap_Main_OnClose (UpperLeftX UpperLeftY /)
	(vl-registry-write drill:masterKey "x_position" UpperLeftX)
	(vl-registry-write drill:masterKey "y_position" UpperLeftY)
)


;###   Main: No Doc State Behavior   ###
(defun c:Tap_Main_OnEnteringNoDocState (/)
;	(drill:get_window_dims)
;	(dcl_ListBox_Clear Tap_Main_listTaps)
	(dcl_Form_Close Tap_Main 1)
)


;###   Main: Switching Docment Behavior   ###
(defun c:Tap_Main_OnDocActivated (/)
	(drill:get_window_dims)
	(dcl_Form_Close Tap_Main 2)
)


;###   Main: Save window dimemsions   ###
(defun drill:get_window_dims(/)
	(vl-registry-write drill:masterKey "x_position" (- (nth 0 (dcl_Control_GetPos Tap_Main)) 25))
	(vl-registry-write drill:masterKey "y_position" (- (nth 1 (dcl_Control_GetPos Tap_Main)) 12))
	(vl-registry-write drill:masterKey "width" (nth 2 (dcl_Control_GetPos Tap_Main)))
	(vl-registry-write drill:masterKey "height" (nth 3 (dcl_Control_GetPos Tap_Main)))
)




;###   Thread Form   ###
;#######################
(drill:debug? "\n Main Dialogue: Change Thread Form & Pitch")

(defun c:tap_Main_comboForm_OnSelChanged (ItemIndexOrCount Value /)
	(vl-registry-write drill:masterKey "bit_type" Value)
	(setq drill:bit_type (read (strcat "drill:" Value)))
	(drill:Set_Thread_Pitch)
)


(defun c:tap_Main_comboPitch_OnSelChanged (ItemIndexOrCount Value /)
	(vl-registry-write drill:masterKey "thread_pitch" Value)
	(setq drill:thread_pitch (vl-registry-read drill:masterKey "thread_pitch"))
	(drill:Set_Tap_List)
)



;###   Button Actions   ###
;##########################
(drill:debug? "\n Main Dialogue: Button Actions")

;###   Select New Tap Size   ###
(defun c:Tap_Main_listTaps_OnSelChanged (i val /)

	(setq drill:current_bit_index i)
	(vl-registry-write drill:masterKey "current_bit" val)
	(drill:set_tap)
	(if (= (vl-registry-read drill:masterKey "auto_insert") "T") (drill:circle_create))
cen )

;###   Insert Button   ###
(defun c:Tap_Main_buttonInsert_OnClicked (/)
	(drill:circle_create)
)

;###   Close Button Clicked   ###
(defun c:Tap_Main_buttonClose_OnClicked (/)
	(drill:get_window_dims)
	(dcl_Form_Close Tap_Main 2)
)

;###   About Button Clicked   ###
(defun c:tap_Main_buttonAbout_OnClicked (/)
	(dcl_Form_Show Tap_About)
)



;###   Show/Hide Options   ###
;#############################
(drill:debug? "\n Main Dialogue: Show/Hide Options")

;###   Tap Holes ###
(defun c:Tap_Main_toggleTapHoles_OnClicked (Value /)
	(cond
		((= Value 0) (vl-registry-write drill:masterKey "hole" "off"))
		((= Value 1) (vl-registry-write drill:masterKey "hole" "on"))
	)
)


;###   Hidden Holes ###
(defun c:Tap_Main_toggleHiddenHoles_OnClicked (Value /)
	(cond
		((= Value 0) (vl-registry-write drill:masterKey "hidden" "off"))
		((= Value 1) (vl-registry-write drill:masterKey "hidden" "on"))
	)
)



;###   Layer Options   ###
;#########################
(drill:debug? "\n Main Dialogue: Layer Options")

;###   Change Tap Hole Layer   ###
(defun c:Tap_Main_comboTapLayer_OnSelChanged (ItemIndexOrCount Value /)
	(vl-registry-write drill:masterKey "hole_layer" Value)
)

;###   Change Hidden Hole Layer   ###
(defun c:Tap_Main_comboHiddenLayer_OnSelChanged (ItemIndexOrCount Value /)
 	(vl-registry-write drill:masterKey "hidden_layer" Value)
)



;#############################
;###   Settings Dialogue   ###
;#############################
(drill:debug? "\n Settings Dialogue: Init")

(defun c:tap_About_OnInitialize (/)

	(dcl_Control_SetCaption versionLabel (strcat "Ver: " drill:version))

	(if (vl-registry-read drill:masterKey "current_bit")
		(dcl_Control_SetEnabled tap_About_buttonClearRegistry T)
		(dcl_Control_SetEnabled tap_About_buttonClearRegistry F)
	)

	(cond
		((= (vl-registry-read drill:masterKey "auto_insert") "T")
			(dcl_Control_SetProperty Tap_About_insertToggle "Value" 1))
		((= (vl-registry-read drill:masterKey "auto_insert") "F")
			(dcl_Control_SetProperty Tap_About_insertToggle "Value" 0))
	)

	(cond
		((= (vl-registry-read drill:masterKey "debug") "T")
			(dcl_Control_SetProperty Tap_About_debugToggle "Value" 1))
		((= (vl-registry-read drill:masterKey "debug") "F")
			(dcl_Control_SetProperty Tap_About_debugToggle "Value" 0))
	)

)



;#############################
;###   Settings: Buttons   ###
;#############################
(drill:debug? "\n Settings Dialogue: Button Actions")

(defun c:tap_About_buttonClearRegistry_OnClicked (/)
	(drill:registry 'delete)
	(dcl_Control_SetEnabled tap_About_buttonClearRegistry F)
	(dcl_Form_Close Tap_Main 2)
	(dcl_Form_Close Tap_About 2)
)

(defun c:tap_About_buttonResetRegistry_OnClicked (/)
	(drill:registry 'reset)
	(dcl_Control_SetEnabled tap_About_buttonClearRegistry T)
	(dcl_Form_Close Tap_Main 2)
	(dcl_Form_Close Tap_About 2)
)

(defun c:tap_About_buttonClose_OnClicked (/)
	(dcl_Form_Close Tap_About 2)
)


;#############################
;###   Settings: Toggles   ###
;#############################
(drill:debug? "\n Settings Dialogue: Toggles")

(defun c:tap_About_insertToggle_OnClicked (Value /)
 	(cond
		((= Value 0) (vl-registry-write drill:masterKey "auto_insert" "F"))
		((= Value 1) (vl-registry-write drill:masterKey "auto_insert" "T"))
	)
)

(defun c:tap_About_debugToggle_OnClicked (Value /)
 	(cond
		((= Value 0) (setq drill:debug nil)(vl-registry-write drill:masterKey "debug" "F"))
		((= Value 1) (setq drill:debug T)(vl-registry-write drill:masterKey "debug" "T"))
	)
)




;###########################
;###   Object Creation   ###
;###########################
(drill:debug? "\n Object Creation")

;### Create the Tap Circles ###
(defun drill:circle_create ( / *error* circle1 circle2 tmp)

	(defun *error* (msg)
		(prompt msg)
		(setvar "cmdecho" 1)
		(princ))

	(setvar "cmdecho" 0)

	(if (= (vl-registry-read drill:masterKey "hole") "on")
		(progn
			(setq tmp (dcl_ComboBox_GetLBText Tap_Main_comboTapLayer (dcl_ComboBox_GetCurSel Tap_Main_comboTapLayer)))
			(setq circle1 (list
				'(0 . "CIRCLE") 
				(if (= (strcase tmp T) "current")(cons 8 (getvar "clayer"))(cons 8 tmp))
				'(10 . (0 0 0))
				(cons 40 (/ (nth 1 (assoc drill:current_bit (cdr (assoc drill:thread_pitch (eval drill:bit_type))))) 2))
				)
			)
		)
	)
	(if drill:debug (progn (prompt "\n Tap Circle DXF Code:    ") (princ circle1)))

	(if (= (vl-registry-read drill:masterKey "hidden") "on")
		(progn
			(setq tmp (dcl_ComboBox_GetLBText Tap_Main_comboHiddenLayer (dcl_ComboBox_GetCurSel Tap_Main_comboHiddenLayer)))
			(setq circle2 (list
				'(0 . "CIRCLE") 
				(if (= (strcase tmp T) "current")(cons 8 (getvar "clayer"))(cons 8 tmp))
				'(10 . (0 0 0))
				(cons 40 (/ (nth 2 (assoc drill:current_bit (cdr (assoc drill:thread_pitch (eval drill:bit_type))))) 2))
				)
			)
		)
	)

	(if drill:debug (progn (prompt "\n Hidden Circle DXF Code: " )(princ circle2)))

	(if (or circle1 circle2)
		(progn
			(entmake '((0 . "BLOCK")
				(100 . "AcDbEntity")
				(67 . 0)
				(8 . "0")
				(100 . "AcDbBlockReference")
				(2 . "TempTapBlock")
				(10 0 0 0)
				(70 . 0)
				)
			)
			(if circle2 (entmake circle2))
			(if (and circle1 (/= (cdr (assoc 40 circle1)) 0)) (entmake circle1))

			(entmake
				'((0 . "ENDBLK")
				(100 . "AcDbBlockEnd")
				(8 . "0")
				)
			)
		
		(dcl_Control_SetKeepFocus Tap_Main F)
		(command "-insert" "TempTapBlock" pause "" "" "")
		(command "explode" (entlast))
 		)
	)

	(setvar "cmdecho" 1)
)



;################################
;###   Tap Wrapper Function   ###
;################################
(drill:debug? "\n Tap Wrapper Function")

(defun c:tap ( / *error*)

	(defun *error* (msg)
		(setvar "cmdecho" 1)
		(prompt msg)
		(princ))

	(dcl_Project_Load "Drill" T)
;	(dcl_project_import project nil nil)

	(if (not (vl-registry-read drill:masterKey "hole"))
		(drill:registry 'reset)
	)

	(dcl_Form_Show Drill_Main)

	(princ)
)

(prompt "\nTap Creator loaded... type \"TAP\" to run.")