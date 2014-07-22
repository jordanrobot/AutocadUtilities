;######################
;###   Create Tap   ###
;######################
(setq tap:version "0.97")
;
;
; Matthew D. Jordan - (c) 2012
; 
; Create a tap feature with the greatest of ease!
;
;	Command: TAP
;


;####################
;###   Registry   ###
;####################

(defun tap:registry ( value / flag )

	(cond 
		;masterkey does not exist...
		((not tap:masterKey)
			(setq tap:masterKey "HKEY_CURRENT_USER\\Software\\MDJ\\Tap")
			(setq flag 1))
	
		;old version, so update the registry values
		((not (= tap:version (vl-registry-read tap:masterKey "Version")))
			(prompt "\nNew version detected, initializing registry values....\n")
			(vl-registry-delete tap:masterKey)
			(setq flag 1))
		
		;delete registry
		((= value 'delete)
			(vl-registry-delete tap:masterKey))

		;reset registry
		((= value 'reset)
			(setq flag 1))
	)

	;create the registry values
	(if (= flag 1)
		(progn
			(vl-registry-write tap:masterKey)
			(if (not (vl-registry-read tap:masterKey "x_position"))		(vl-registry-write tap:masterKey "x_position" "100"))
			(if (not (vl-registry-read tap:masterKey "y_position"))		(vl-registry-write tap:masterKey "y_position" "100"))
			(if (not (vl-registry-read tap:masterKey "width"))			(vl-registry-write tap:masterKey "width" "256"))
			(if (not (vl-registry-read tap:masterKey "height"))			(vl-registry-write tap:masterKey "height" "416"))
			(if (not (vl-registry-read tap:masterKey "thread_form"))	(vl-registry-write tap:masterKey "thread_form" "US-Unified"))
			(if (not (vl-registry-read tap:masterKey "current_tap"))	(vl-registry-write tap:masterKey "current_tap" "3/8-16"))
			(if (not (vl-registry-read tap:masterKey "thread_pitch"))	(vl-registry-write tap:masterKey "thread_pitch" "Coarse"))
			(if (not (vl-registry-read tap:masterKey "hidden"))			(vl-registry-write tap:masterKey "hidden" "on"))
			(if (not (vl-registry-read tap:masterKey "hidden_layer"))	(vl-registry-write tap:masterKey "hidden_layer" "Current"))
			(if (not (vl-registry-read tap:masterKey "taps"))			(vl-registry-write tap:masterKey "taps" "on"))
			(if (not (vl-registry-read tap:masterKey "taps_layer"))		(vl-registry-write tap:masterKey "taps_layer" "Current"))
			(if (not (vl-registry-read tap:masterKey "auto_insert"))	(vl-registry-write tap:masterKey "auto_insert" "T"))
			(if (not (vl-registry-read tap:masterKey "debug"))			(vl-registry-write tap:masterKey "debug" "F"))
	
			(vl-registry-write tap:masterKey "Version" tap:version)
		)
	)
)

(tap:registry 0)

(if (vl-registry-read tap:masterKey "debug")
		(if (= (vl-registry-read tap:masterKey "debug") "T")
			(setq tap:debug T)))

(defun tap:debug?( Value /)
	(if (= tap:debug T)
		(prompt Value)
	)
)

;(setq tap:debug T)

;#######################
;###   Create Data   ###
;#######################
(tap:debug? "\n Initialize Data")


(setq tap:thread_form_list '("US-Unified" "ISO-Metric" "NPT" "ACME"))

;Form -> Pitch -> (NAME Tap_Diam Nominal_Diam)

(setq tap:US-Unified '(
	("Coarse"
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
	)
	("Fine"
		("#0 - 72"		0.0465	0.06		)
		("#0 - 80"		0.0469	0.06		)
		("#1 - 72"		0.0595	0.073		)
		("#2 - 64"		0.07	0.086		)
		("#3 - 56"		0.082	0.099		)
		("#4 - 48"		0.0935	0.112		)
		("#5 - 44"		0.104	0.125		)
		("#6 - 40"		0.113	0.138		)
		("#8-36"		0.136	0.164		)
		("#10 - 32"		0.159	0.19		)
		("12 - 28"		0.182	0.216		)
		("1/4 - 28"		0.213	0.25		)
		("5/16 - 24"	0.272	0.3125		)
		("3/8 - 24"		0.332	0.375		)
		("7/16 - 20"	0.3906	0.4375		)
		("1/2 - 20"		0.4531	0.5			)
		("9/16 - 18"	0.5156	0.5625		)
		("5/8 - 18"		0.5781	0.625		)
		("3/4 - 16"		0.6875	0.75		)
		("7/8 - 14"		0.8125	0.875		)
		("1 - 12"		0.9219	1.0			)
		("1 1/8 - 12"	1.0469	1.125		)
		("1 1/4 - 12"	1.1719	1.25		)
		("1 3/8 - 12"	1.2969	1.375		)
		("1 1/2 - 12"	1.4219	1.5			)
	)
	("Extra Fine"
		("#12 - 32"		0.18	0.216		)
		("1/4 - 32"		0.2187	0.25		)
		("5/16 - 32"	0.2812	0.3125		)
		("3/8 - 32"		0.348	0.375		)
		("7/16 - 28"	0.404	0.4375		)
		("1/2 - 28"		0.4687	0.5			)
		("9/16 - 24"	0.5156	0.5625		)
		("5/8 - 24"		0.5781	0.625		)
		("11/16 - 24"	0.6406	0.6875		)
		("3/4 - 20"		0.7031	0.75		)
		("13/16 - 20"	0.7656	0.8125		)
		("7/8 - 20"		0.8281	0.875		)
		("15/16 - 20"	0.875	0.9375		)
		("1 - 20"		0.9531	1.0			)
		("1 1/16 - 18"	1.0000	1.0625		)
		("1 1/8 - 18"	1.0625	1.125		)
		("1 3/16 - 18"	1.1406	1.1875		)
		("1 1/4 - 18"	1.1875	1.25		)
		("1 5/16 - 18"	1.25	1.3125		)
		("1 3/8 - 18"	1.3125	1.375		)
		("1 7/16 - 18"	1.375	1.4375		)
		("1 1/2 - 18"	1.4375	1.5			)
		("1 9/16 - 18"	1.5		1.5625		)
		("1 5/8 - 18"	1.5625	1.625		)
		("1 11/16 - 18"	1.625	1.6875		)
	)
	("Special"
		("#10 - 28"		0.152	0.19		)
		("#10 - 36"		0.159	0.19		)
		("#10 - 40"		0.161	0.19		)
		("#10 - 48"		0.166	0.19		)
		("#10 - 56"		0.1695	0.19		)
		("#12 - 36"		0.189	0.216		)
		("#12 - 40"		0.191	0.216		)
		("#12 - 48"		0.196	0.216		)
		("#12 - 56"		0.196	0.216		)
		("1/4 - 24"		0.209	0.25		)
		("1/4 - 27"		0.213	0.25		)
		("1/4 - 36"		0.221	0.25		)
		("1/4 - 40"		0.228	0.25		)
		("1/4 - 48"		0.228	0.25		)
		("1/4 - 56"		0.234	0.25		)
		("5/16 - 27"	0.277	0.3125		)
		("5/16 - 36"	0.2812	0.3125		)
		("5/16 - 40"	0.29	0.3125		)
		("5/16-48"		0.29	0.3125		)
		("3/8 - 18"		0.316	0.375		)
		("3/8 - 27"		0.339	0.375		)
		("3/8 - 36"		0.348	0.375		)
		("3/8 - 40"		0.348	0.375		)
		("0.390 - 27"	0.348	0.39		)
		("7/16 - 18"	0.386	0.4375		)
		("7/16 - 24"	0.397	0.4375		)
		("7/16 - 27"	0.404	0.4375		)
		("1/2 - 12"		0.4219	0.5			)
		("1/2 - 14"		0.4219	0.5			)
		("1/2 - 18"		0.4375	0.5			)
		("1/2 - 24"		0.4531	0.5			)
		("1/2 - 27"		0.4687	0.5			)
		("9/16 - 14"	0.4844	0.5625		)
		("9/16 - 27"	0.5312	0.5625		)
		("5/8 - 14"		0.5469	0.625		)
		("5/8 - 27"		0.5937	0.625		)
		("3/4 - 14"		0.6719	0.75		)
		("3/4 - 18"		0.6875	0.75		)
		("3/4 - 24"		0.7031	0.75		)
		("7/8 - 10"		0.7812	0.875		)
		("7/8 - 18"		0.8281	0.875		)
		("7/8 - 24"		0.8281	0.875		)
		("7/8 - 27"		0.8437	0.875		)
		("1 - 10"		0.9062	1.0			)
		("1 - 14"		0.9375	1.0			)
		("1 - 18"		0.9375	1.0			)
		("1 - 24"		0.9531	1.0			)
		("1 - 27"		0.9687	1.0			)
		("1 1/8 - 10"	1.0312	1.125		)
		("1 1/8 - 14"	1.0469	1.125		)
		("1 1/8 - 24"	1.0781	1.125		)
		("1 1/4 - 10"	1.1562	1.25		)
		("1 1/4 - 14"	1.1719	1.25		)
		("1 1/4 - 24"	1.2031	1.25		)
		("1 3/8 - 10"	1.2812	1.375		)
		("1 3/8 - 14"	1.2969	1.375		)
		("1 3/8 - 24"	1.3281	1.375		)
		("1 1/2 - 10"	1.4062	1.5			)
		("1 1/2 - 14"	1.4219	1.5			)
		("1 1/2 - 24"	1.4531	1.5			)
		("1 5/8 - 10"	1.5312	1.625		)
		("1 5/8 - 14"	1.5469	1.625		)
		("1 5/8 - 24"	1.5781	1.625		)
		("1 3/4 - 10"	1.6562	1.75		)
		("1 3/4 - 14"	1.6719	1.75		)
		("1 3/4 - 18"	1.6875	1.75		)
		("1 7/8 - 10"	1.7812	1.875		)
		("1 7/8 - 14"	1.8125	1.875		)
		("1 7/8 - 18"	1.8125	1.875		)
		("2 - 10"		1.9062	2.0			)
		("2 - 14"		1.9375	2.0			)
		("2 - 18"		1.9375	2.0			)
	)
	("32UN"
		("#6 - 32"		0.1065	0.138		)
		("#8 - 32"		0.136	0.164		)
		("#10 - 32"		0.159	0.19		)
		("#12 - 32"		0.18	0.216		)
		("1/4 - 32"		0.2187	0.25		)
		("5/16 - 32"	0.2812	0.3125		)
		("3/8 - 32"		0.348	0.375		)
		("7/16 - 32"	0.404	0.4375		)
		("1/2 - 32"		0.4687	0.5			)
		("9/16 - 32"	0.5312	0.5625		)
		("5/8 - 32"		0.5937	0.625		)
		("11/16 - 32"	0.6562	0.6875		)
		("3/4 - 32"		0.7187	0.75		)
		("13/16 - 32"	0.7812	0.8125		)
		("7/8 - 32"		0.8437	0.875		)
		("15/16 - 32"	0.9062	0.9375		)
		("1 - 32"		0.9687	1.0			)
	)
	("28UN"
		("#10 - 28"		0.152	0.19		)
		("12 - 28"		0.182	0.216		)
		("1/4 - 28"		0.213	0.25		)
		("5/16 - 28"	0.277	0.3125		)
		("3/8 - 28"		0.339	0.375		)
		("7/16 - 28"	0.404	0.4375		)
		("1/2 - 28"		0.4687	0.5			)
		("9/16 - 28"	0.5312	0.5625		)
		("5/8 - 28"		0.5937	0.625		)
		("11/16 - 28"	0.6562	0.6875		)
		("3/4 - 28"		0.7187	0.75		)
		("13/16 - 28"	0.7812	0.8125		)
		("7/8 - 28"		0.8437	0.875		)
		("15/16 - 28"	0.9062	0.9375		)
		("1 - 28"		0.9687	1.0			)
		("1 1/16 - 28"	1.0312	1.0625		)
		("1 1/8 - 28"	1.0938	1.125		)
		("1 3/16 - 28"	1.1562	1.1875		)
		("1 1/4 - 28"	1.2187	1.25		)
		("1 5/16 - 28"	1.2812	1.3125		)
		("1 3/8 - 28"	1.3438	1.375		)
		("1 7/16 - 28"	1.4062	1.4375		)
		("1 1/2 - 28"	1.4531	1.5			)
	)
	("20UN"
		("5/16 - 20"	0.2656	0.3125		)
		("3/8 - 20"		0.3281	0.375		)
		("7/16 - 20"	0.3906	0.4375		)
		("1/2 - 20"		0.4531	0.5			)
		("9/16 - 20"	0.5156	0.5625		)
		("5/8 - 20"		0.5781	0.625		)
		("11/16 - 20"	0.6406	0.6875		)
		("3/4 - 20"		0.7031	0.75		)
		("13/16 - 20"	0.7656	0.8125		)
		("7/8 - 20"		0.8281	0.875		)
		("15/16 - 20"	0.875	0.9375		)
		("1 - 20"		0.9531	1.0			)
		("1 1/16 - 20"	1.0156	1.0625		)
		("1 1/8 - 20"	1.0781	1.125		)
		("1 3/16 - 20"	1.1406	1.1875		)
		("1 1/4 - 20"	1.25	1.25		)
		("1 5/16 - 20"	1.2656	1.3125		)
		("1 3/8 - 20"	1.3281	1.375		)
		("1 7/16 - 20"	1.3906	1.4375		)
		("1 1/2 - 20"	1.4531	1.5			)
		("1 9/16 - 20"	1.5156	1.5625		)
		("1 5/8 - 20"	1.5781	1.625		)
		("1 11/16 - 20"	1.6406	1.6875		)
		("1 3/4 - 20"	1.7031	1.75		)
		("1 13/16 - 20"	1.75	1.8125		)
		("1 7/8 - 20"	1.8125	1.875		)
		("1 15/16 - 20"	1.9062	1.9375		)
		("2 - 20"		1.9375	2.0			)
	)

	("16UN"
		("3/8 - 16"		0.3125	0.375		)
		("7/16 - 16"	0.377	0.4375		)
		("1/2 - 16"		0.4375	0.5			)
		("9/16 - 16"	0.5		0.5625		)
		("5/8 - 16"		0.5625	0.625		)
		("11/16 - 16"	0.625	0.6875		)
		("3/4 - 16"		0.6875	0.75		)
		("13/16 - 16"	0.75	0.8125		)
		("7/8 - 16"		0.8125	0.875		)
		("15/16 - 16"	0.875	0.9375		)
		("1 - 16"		0.9375	1.0			)
		("1 1/16 - 16"	1.0000	1.0625		)
		("1 1/8 - 16"	1.0625	1.125		)
		("1 3/16 - 16"	1.125	1.1875		)
		("1 1/4 - 16"	1.1875	1.25		)
		("1 5/16 - 16"	1.25	1.3125		)
		("1 3/8 - 16"	1.3125	1.375		)
		("1 7/16 - 16"	1.375	1.4375		)
		("1 1/2 - 16"	1.4375	1.5			)
		("1 9/16 - 16"	1.5		1.5625		)
		("1 5/8 - 16"	1.5625	1.625		)
		("1 11/16 - 16"	1.625	1.6875		)
		("1 3/4 - 16"	1.6875	1.75		)
		("1 13/16 - 16"	1.75	1.8125		)
		("1 7/8 - 16"	1.8125	1.875		)
		("1 15/16 - 16"	1.875	1.9375		)
		("2 - 16"		1.9375	2.0			)
	)
	("12UN"
		("1/2 - 12"		0.4219	0.5			)
		("9/16 - 12"	0.4844	0.5625		)
		("5/8 - 12"		0.5469	0.625		)
		("11/16 - 12"	0.6093	0.6875		)
		("3/4 - 12"		0.6719	0.75		)
		("13/16 - 12"	0.7344	0.8125		)
		("7/8 - 12"		0.7969	0.875		)
		("15/16 - 12"	0.8594	0.9375		)
		("1 - 12"		0.9219	1.0			)
		("1 1/16 - 12"	0.9844	1.0625		)
		("1 1/8 - 12"	1.0469	1.125		)
		("1 3/16 - 12"	1.1094	1.1875		)
		("1 1/4 - 12"	1.1719	1.25		)
		("1 5/16 - 12"	1.2344	1.3125		)
		("1 3/8 - 12"	1.2969	1.375		)
		("1 7/16 - 12"	1.3594	1.4375		)
		("1 1/2 - 12"	1.4219	1.5			)
		("1 9/16 - 12"	1.4844	1.5625		)
		("1 5/8 - 12"	1.5469	1.625		)
		("1 11/16 - 12"	1.6094	1.6875		)
		("1 3/4 - 12"	1.6719	1.75		)
		("1 13/16 - 12"	1.7344	1.8125		)
		("1 7/8 - 12"	1.7812	1.875		)
		("1 15/16 - 12"	1.8438	1.9375		)
		("2 - 12"		1.9062	2.0			)
	)

	("8UN"
		("1 - 8"		0.875	1.0			)
		("1 1/16 - 8"	0.9375	1.0625		)
		("1 1/8 - 8"	1.0		1.125		)
		("1 3/16 - 8"	1.0625	1.1875		)
		("1 1/4 - 8"	1.125	1.25		)
		("1 5/16 - 8"	1.1875	1.3125		)
		("1 3/8 - 8"	1.25	1.375		)
		("1 7/16 - 8"	1.3125	1.4375		)
		("1 1/2 - 8"	1.375	1.5			)
		("1 9/16 - 8"	1.4375	1.5625		)
		("1 5/8 - 8"	1.5		1.625		)
		("1 11/16 - 8"	1.5625	1.6875		)
		("1 3/4 - 8"	1.625	1.75		)
		("1 13/16 - 8"	1.6875	1.8125		)
		("1 7/8 - 8"	1.75	1.875		)
		("1 15/16 - 8"	1.8125	1.9375		)
		("2 - 8"		1.875	2.0			)
	)
	("6UN"
		("1 3/8 - 6"	1.2187	1.375		)
		("1 7/16 - 6"	1.2656	1.4375		)
		("1 9/16 - 6"	1.3906	1.5			)
		("1 5/8 - 6"	1.4531	1.625		)
		("1 11/16 - 6"	1.5156	1.6875		)
		("1 3/4 - 6"	1.5781	1.75		)
		("1 13/16 - 6"	1.6406	1.8125		)
		("1 7/8 - 6"	1.7031	1.875		)
		("1 15/16 - 6"	1.7812	1.9375		)
		("2 - 6"		1.8438	2.0			)		
	)

))

(setq tap:ISO-Metric '(
	("Coarse"
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
	)
	("Fine"
		("1 x 0.2"		0.0314961 	0.0393701	)
		("1.1 x 0.2"	0.0354331 	0.0433071	)
		("1.2 x 0.2"	0.0393701 	0.0472441	)
		("1.4 x 0.2"	0.0472441 	0.0551181	)
		("1.6 x 0.2" 	0.0551181 	0.0629921	)
		("1.8 x 0.2" 	0.0629921 	0.0708661	)
		("2 x 0.25" 	0.0688976 	0.0787402	) 
		("2.2 x 0.25" 	0.0767717 	0.0866142	)
		("2.5 x 0.35" 	0.0846457 	0.0984252	)
		("3 x 0.35" 	0.104331 	0.11811		)
		("3.5 x 0.35" 	0.124016 	0.137795	)
		("4 x 0.5" 		0.129921 	0.15748		) 
		("4.5 x 0.5" 	0.15748 	0.177165	)
		("5 x 0.5" 		0.177165	0.19685		)
		("5.5 x 0.5" 	0.19685 	0.216535	)
		("6 x 0.75" 	0.19685 	0.23622		)
		("7 x 0.75" 	0.246063 	0.275591	)
		("8 x 1" 		0.275591 	0.314961	)
		("9 x 0.75" 	0.324803 	0.354331	)
		("10 x 1.25" 	0.344488 	0.393701	) 
		("10 x 1" 		0.354331 	0.393701	)
		("10 x 0.75" 	0.364173 	0.393701	)
		("11 x 1" 		0.393701 	0.433071	)
		("11 x 0.75" 	0.403543 	0.433071	)
		("12 x 1.5" 	0.413386 	0.472441	) 
		("12 x 1.25" 	0.423228 	0.472441	)
		("12 x 1" 		0.433071 	0.472441	)
		("14 x 1.5" 	0.492126 	0.551181	)
		("14 x 1.25" 	0.501969 	0.551181	)
		("14 x 1" 		0.511811 	0.551181	)
		("15 x 1.5" 	0.531496 	0.590551	)
		("15 x 1" 		0.551181 	0.590551	)
		("16 x 1.5" 	0.570866 	0.629921	) 
		("16 x 1" 		0.590551 	0.629921	)
		("17 x 1.5" 	0.610236 	0.669291	)
		("17 x 1" 		0.629921 	0.669291	)
		("18 x 2" 		0.629921 	0.708661	)
		("18 x 1.5" 	0.649606 	0.708661	)
		("18 x 1" 		0.669291 	0.708661	)
		("20 x 2" 		0.708661 	0.787402	)
		("20 x 1.5" 	0.728346 	0.787402	) 
		("20 x 1" 		0.748031 	0.787402	)
		("22 x 2" 		0.787402 	0.866142	)
		("22 x 1.5" 	0.807087 	0.866142	)
		("22 x 1" 		0.826772 	0.866142	)
		("24 x 2" 		0.866142 	0.944882	)
		("24 x 1.5" 	0.885827 	0.944882	)
		("24 x 1" 		0.905512 	0.944882	)
		("25 x 2" 		0.905512 	0.984252	) 
		("25 x 1.5" 	0.925197 	0.984252	)
		("27 x 2" 		0.984252 	1.06299		)
		("27 x 1.5" 	1.00394 	1.06299		)
		("27 x 1" 		1.02362 	1.06299		)
		("28 x 2" 		1.02362 	1.10236		)
		("28 x 1.5" 	1.04331 	1.10236		)
		("28 x 1" 		1.06299 	1.10236		)
		("30 x 3" 		1.06299 	1.1811		)
		("30 x 2" 		1.10236 	1.1811		)
		("30 x 1.5" 	1.12205 	1.1811		)
		("30 x 1" 		1.14173 	1.1811		)
		("32 x 2" 		1.1811 		1.25984		)
		("32 x 1.5"		1.20079 	1.25984		)
		("33 x 3.5" 	1.16142 	1.29921		)
		("33 x 3" 		1.1811 		1.29921		)
		("33 x 2" 		1.22047 	1.29921		)
		("33 x 1.5" 	1.24016 	1.29921		) 
		("35 x 1.5" 	1.3189 		1.37795		)
		("36 x 3" 		1.29921 	1.41732		)
		("36 x 2" 		1.33858 	1.41732		) 
		("36 x 1.5" 	1.35827 	1.41732		)
		("39 x 3" 		1.41732 	1.53543		)
		("39 x 2" 		1.45669 	1.53543		) 
		("39 x 1.5" 	1.47638 	1.53543		)
		("40 x 3" 		1.45669 	1.5748		)
		("40 x 2" 		1.49606 	1.5748		) 
		("40 x 1.5" 	1.51575 	1.5748		)
		("42 x 4" 		1.49606 	1.65354		)
		("42 x 3" 		1.53543 	1.65354		) 
		("42 x 2" 		1.5748 		1.65354		)
		("42 x 1.5" 	1.59449 	1.65354		)
		("45 x 4" 		1.61417 	1.77165		) 
		("45 x 3" 		1.65354 	1.77165		)
		("45 x 2" 		1.69291 	1.77165		)
		("45 x 1.5" 	1.7126 		1.77165		) 
		("48 x 4" 		1.73228 	1.88976		)
		("48 x 3" 		1.77165 	1.88976		)
		("48 x 2" 		1.81102 	1.88976		) 
		("48 x 1.5" 	1.83071 	1.88976		)
		("50 x 3" 		1.85039 	1.9685		)
		("50 x 2" 		1.88976 	1.9685		) 
		("50 x 1.5" 	1.90945 	1.9685		)
	)
))

(setq tap:ACME '(
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
	)
	("all"
		("3/16 -20"		0		0.1875		)
		("1/4 - 20"		0		0.25		)
		("1/4 - 16"		0		0.25		)
		("3/8 - 20"		0		0.375 		)
		("3/8 - 16"		0		0.375 		)
		("3/8 - 12"		0.3		0.375 		)
		("3/8 - 10"		0		0.375 		)
		("3/8 - 8"		0		0.375 		)
		("7/16 - 12"	0.3625	0.4375		)
		("1/2 - 10"		0.410	0.5			)
		("1/2 - 8"		0		0.5			)
		("5/8 - 10"		0		0.625		)
		("5/8 - 8"		0.5125	0.625		)
		("5/8 - 7"		0		0.625		)
		("3/4 - 16"		0	 	0.75 		)
		("3/4 - 10"		0	 	0.75 		)
		("3/4 - 8"		0	 	0.75 		)
		("3/4 - 7"		0	 	0.75 		)
		("3/4 - 6"		0.6 	0.75 		)
		("3/4 - 5"		0	 	0.75 		)
		("7/8 - 6"		0.725 	0.875		)
		("7/8 - 5"		0	 	0.875		)
		("1 - 10"		0	 	1.0 		)
		("1 - 8"		0	 	1.0 		)
		("1 - 7"		0	 	1.0 		)
		("1 - 6"		0	 	1.0 		)
		("1 - 5"		0.820 	1.0 		)
		("1 - 4"		0	 	1.0 		)
		("1 1/8 - 5"	0.945 	1.125 		)
		("1 1/4 - 16"	0	 	1.25 		)
		("1 1/4 - 5"	1.070 	1.25 		)
		("1 1/4 - 4"	0	 	1.25 		)
		("1 3/8 - 4"	0	 	1.375 		)
		("1 1/2 - 10"	0	 	1.5 		)
		("1 1/2 - 5"	0	 	1.5 		)
		("1 1/2 - 4"	1.275 	1.5 		)
		("1 1/2 - 2.66"	0	 	1.5 		)
		("1 3/4 - 4"	0	 	1.75 		)
		("1 3/4 - 3"	0	 	1.75 		)
		("2 - 4"		0 		2.0 		)
		("2 - 3"		0 		2.0 		)
		("2 1/4 - 4"	0	 	2.25 		)
		("2 1/2 - 4"	0	 	2.5 		)
		("2 1/2 - 3"	0	 	2.5 		)
		("2 1/2 - 2"	0	 	2.5 		)
		("3 - 4"		0 		3.0 		)
		("3 - 3"		0 		3.0 		)
		("3 - 2"		0 		3.0 		)
	)
))

(setq tap:NPT '(
	("all"
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
)

(vl-load-com)
(or *doc* (setq *doc* (vla-get-ActiveDocument (vlax-get-acad-object))))
(or *mspace* (setq *mspace* (vla-get-ModelSpace *doc*)))
(or *layers* (setq *layers* (vla-get-Layers *doc*)))
(or *layouts* (setq *layouts* (vla-get-Layouts *doc*)))
(command "opendcl")



;###################################
;###   Set Switching Variables   ###
;###################################
(tap:debug? "\n Set Switching Variables")

(defun tap:Set_Tap(/)
	(setq tap:current_tap (vl-registry-read tap:masterKey "current_tap"))
)

(defun tap:Set_Tap_List (/)
	(dcl_ListBox_Clear Tap_Main_listTaps)
	;create list of taps from variables
	(dcl_ListBox_AddList Tap_Main_listTaps
		(mapcar '(lambda (x) (nth 0 x))
			(cdr (assoc tap:thread_pitch (eval tap:thread_form)))
		)
	)
)

(defun tap:Set_Thread_Pitch (/)
	(dcl_ComboBox_Clear tap_Main_comboPitch)

	(dcl_ComboBox_AddList tap_Main_comboPitch
		(mapcar '(lambda (x) (nth 0 x))
			(eval tap:thread_form)
		))

	(if (= -1 (dcl_ComboBox_SelectString tap_Main_comboPitch tap:thread_pitch))
		(dcl_ComboBox_SelectString tap_Main_comboPitch 
			(nth 0 	(mapcar '(lambda (x) (nth 0 x))(eval tap:thread_form)))
		)
	)

	(setq tap:thread_pitch (dcl_ComboBox_GetLBText tap_Main_comboPitch (dcl_ComboBox_GetCurSel tap_Main_comboPitch)))

	(tap:Set_Tap_List)
)



;###############################
;###   Main Dialogue: Init   ###
;###############################
(tap:debug? "\n Main Dialogue: Init")

;###   Main: Initialize   ###
(defun c:Tap_Main_OnInitialize (/ d r d1 r1 layer_list)
	
	;### Set the Tap Hole and Hidden Hole Visability Toggles
	(if (equal (vl-registry-read tap:masterKey "taps") "on") (dcl_Control_SetProperty Tap_Main_toggleTapHoles "Value" 1) (dcl_Control_SetProperty Tap_Main_toggleTapHoles "Value" 0))
	(if (equal (vl-registry-read tap:masterKey "hidden") "on") (dcl_Control_SetProperty Tap_Main_toggleHiddenHoles "Value" 1) (dcl_Control_SetProperty Tap_Main_toggleHiddenHoles "Value" 0))

	;### Thread Forms and Pitch Drop Downs
	;populate and select current thread form
	(dcl_ComboBox_Clear tap_Main_comboForm)
	(dcl_ComboBox_AddList tap_Main_comboForm tap:thread_form_list)
	(dcl_ComboBox_SelectString tap_Main_comboForm (vl-registry-read tap:masterKey "thread_form"))

	;### Set variables used in tap creation
	(setq tap:thread_form (read (strcat "tap:" (vl-registry-read tap:masterKey "thread_form"))))
	(setq tap:thread_pitch (vl-registry-read tap:masterKey "thread_pitch"))

	(tap:Set_Thread_Pitch)
	(tap:Set_Tap_List)

	;### Tap Layer Combo Box
	(setq layer_list (while (setq d (tblnext "layer" (null d))) (setq r (cons (cdr (assoc 2 d)) r))))
	(dcl_ComboBox_Clear Tap_Main_comboTapLayer)
	(dcl_ComboBox_AddList Tap_Main_comboTapLayer (cons "Current" (vl-sort layer_list '<)))
	(dcl_ComboBox_SelectString Tap_Main_comboTapLayer (if (tblsearch "layer" (vl-registry-read tap:masterKey "taps_layer"))
		(vl-registry-read tap:masterKey "taps_layer")
		"Current"))


	;###Hidden Layer Combo Box
	(dcl_ComboBox_Clear Tap_Main_comboHiddenLayer)
	(dcl_ComboBox_AddList Tap_Main_comboHiddenLayer (cons "Current" (vl-sort layer_list '<)))
	(dcl_ComboBox_SelectString Tap_Main_comboHiddenLayer (if (tblsearch "layer" (vl-registry-read tap:masterKey "hidden_layer"))
		(vl-registry-read tap:masterKey "hidden_layer")
		"Current"
		))

	;### select existing tap size
	(if tap:current_tap_index (dcl_ListBox_SetCurSel Tap_Main_listTaps tap:current_tap_index))
)



;#################################
;###   Main: Exit Conditions   ###
;#################################
(tap:debug? "\n Main Dialogue: Exit Conditions")

;###   Main: Close   ###
(defun c:Tap_Main_OnClose (UpperLeftX UpperLeftY /)
	(vl-registry-write tap:masterKey "x_position" UpperLeftX)
	(vl-registry-write tap:masterKey "y_position" UpperLeftY)
)


;###   Main: No Doc State Behavior   ###
(defun c:Tap_Main_OnEnteringNoDocState (/)
;	(tap:get_window_dims)
;	(dcl_ListBox_Clear Tap_Main_listTaps)
	(dcl_Form_Close Tap_Main 1)
)


;###   Main: Switching Docment Behavior   ###
(defun c:Tap_Main_OnDocActivated (/)
	(tap:get_window_dims)
	(dcl_Form_Close Tap_Main 2)
)


;###   Main: Save window dimemsions   ###
(defun tap:get_window_dims(/)
	(vl-registry-write tap:masterKey "x_position" (- (nth 0 (dcl_Control_GetPos Tap_Main)) 25))
	(vl-registry-write tap:masterKey "y_position" (- (nth 1 (dcl_Control_GetPos Tap_Main)) 12))
	(vl-registry-write tap:masterKey "width" (nth 2 (dcl_Control_GetPos Tap_Main)))
	(vl-registry-write tap:masterKey "height" (nth 3 (dcl_Control_GetPos Tap_Main)))
)




;###   Thread Form   ###
;#######################
(tap:debug? "\n Main Dialogue: Change Thread Form & Pitch")

(defun c:tap_Main_comboForm_OnSelChanged (ItemIndexOrCount Value /)
	(vl-registry-write tap:masterKey "thread_form" Value)
	(setq tap:thread_form (read (strcat "tap:" Value)))
	(tap:Set_Thread_Pitch)
)


(defun c:tap_Main_comboPitch_OnSelChanged (ItemIndexOrCount Value /)
	(vl-registry-write tap:masterKey "thread_pitch" Value)
	(setq tap:thread_pitch (vl-registry-read tap:masterKey "thread_pitch"))
	(tap:Set_Tap_List)
)



;###   Button Actions   ###
;##########################
(tap:debug? "\n Main Dialogue: Button Actions")

;###   Select New Tap Size   ###
(defun c:Tap_Main_listTaps_OnSelChanged (i val /)

	(setq tap:current_tap_index i)
	(vl-registry-write tap:masterKey "current_tap" val)
	(tap:set_tap)
	(if (= (vl-registry-read tap:masterKey "auto_insert") "T") (tap:circle_create))
cen )

;###   Insert Button   ###
(defun c:Tap_Main_buttonInsert_OnClicked (/)
	(tap:circle_create)
)

;###   Close Button Clicked   ###
(defun c:Tap_Main_buttonClose_OnClicked (/)
	(tap:get_window_dims)
	(dcl_Form_Close Tap_Main 2)
)

;###   About Button Clicked   ###
(defun c:tap_Main_buttonAbout_OnClicked (/)
	(dcl_Form_Show Tap_About)
)



;###   Show/Hide Options   ###
;#############################
(tap:debug? "\n Main Dialogue: Show/Hide Options")

;###   Tap Holes ###
(defun c:Tap_Main_toggleTapHoles_OnClicked (Value /)
	(cond
		((= Value 0) (vl-registry-write tap:masterKey "taps" "off"))
		((= Value 1) (vl-registry-write tap:masterKey "taps" "on"))
	)
)


;###   Hidden Holes ###
(defun c:Tap_Main_toggleHiddenHoles_OnClicked (Value /)
	(cond
		((= Value 0) (vl-registry-write tap:masterKey "hidden" "off"))
		((= Value 1) (vl-registry-write tap:masterKey "hidden" "on"))
	)
)



;###   Layer Options   ###
;#########################
(tap:debug? "\n Main Dialogue: Layer Options")

;###   Change Tap Hole Layer   ###
(defun c:Tap_Main_comboTapLayer_OnSelChanged (ItemIndexOrCount Value /)
	(vl-registry-write tap:masterKey "taps_layer" Value)
)

;###   Change Hidden Hole Layer   ###
(defun c:Tap_Main_comboHiddenLayer_OnSelChanged (ItemIndexOrCount Value /)
 	(vl-registry-write tap:masterKey "hidden_layer" Value)
)



;#############################
;###   Settings Dialogue   ###
;#############################
(tap:debug? "\n Settings Dialogue: Init")

(defun c:tap_About_OnInitialize (/)

	(dcl_Control_SetCaption versionLabel (strcat "Ver: " tap:version))

	(if (vl-registry-read tap:masterKey "current_tap")
		(dcl_Control_SetEnabled tap_About_buttonClearRegistry T)
		(dcl_Control_SetEnabled tap_About_buttonClearRegistry F)
	)

	(cond
		((= (vl-registry-read tap:masterKey "auto_insert") "T")
			(dcl_Control_SetProperty Tap_About_insertToggle "Value" 1))
		((= (vl-registry-read tap:masterKey "auto_insert") "F")
			(dcl_Control_SetProperty Tap_About_insertToggle "Value" 0))
	)

	(cond
		((= (vl-registry-read tap:masterKey "debug") "T")
			(dcl_Control_SetProperty Tap_About_debugToggle "Value" 1))
		((= (vl-registry-read tap:masterKey "debug") "F")
			(dcl_Control_SetProperty Tap_About_debugToggle "Value" 0))
	)

)



;#############################
;###   Settings: Buttons   ###
;#############################
(tap:debug? "\n Settings Dialogue: Button Actions")

(defun c:tap_About_buttonClearRegistry_OnClicked (/)
	(tap:registry 'delete)
	(dcl_Control_SetEnabled tap_About_buttonClearRegistry F)
	(dcl_Form_Close Tap_Main 2)
	(dcl_Form_Close Tap_About 2)
)

(defun c:tap_About_buttonResetRegistry_OnClicked (/)
	(tap:registry 'reset)
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
(tap:debug? "\n Settings Dialogue: Toggles")

(defun c:tap_About_insertToggle_OnClicked (Value /)
 	(cond
		((= Value 0) (vl-registry-write tap:masterKey "auto_insert" "F"))
		((= Value 1) (vl-registry-write tap:masterKey "auto_insert" "T"))
	)
)

(defun c:tap_About_debugToggle_OnClicked (Value /)
 	(cond
		((= Value 0) (setq tap:debug nil)(vl-registry-write tap:masterKey "debug" "F"))
		((= Value 1) (setq tap:debug T)(vl-registry-write tap:masterKey "debug" "T"))
	)
)




;###########################
;###   Object Creation   ###
;###########################
(tap:debug? "\n Object Creation")

;### Create the Tap Circles ###
(defun tap:circle_create ( / *error* circle1 circle2 tmp)

	(defun *error* (msg)
		(prompt msg)
		(setvar "cmdecho" 1)
		(princ))

	(setvar "cmdecho" 0)

	(if (= (vl-registry-read tap:masterKey "taps") "on")
		(progn
			(setq tmp (dcl_ComboBox_GetLBText Tap_Main_comboTapLayer (dcl_ComboBox_GetCurSel Tap_Main_comboTapLayer)))
			(setq circle1 (list
				'(0 . "CIRCLE") 
				(if (= (strcase tmp T) "current")(cons 8 (getvar "clayer"))(cons 8 tmp))
				'(10 . (0 0 0))
				(cons 40 (/ (nth 1 (assoc tap:current_tap (cdr (assoc tap:thread_pitch (eval tap:thread_form))))) 2))
				)
			)
		)
	)
	(if tap:debug (progn (prompt "\n Tap Circle DXF Code:    ") (princ circle1)))

	(if (= (vl-registry-read tap:masterKey "hidden") "on")
		(progn
			(setq tmp (dcl_ComboBox_GetLBText Tap_Main_comboHiddenLayer (dcl_ComboBox_GetCurSel Tap_Main_comboHiddenLayer)))
			(setq circle2 (list
				'(0 . "CIRCLE") 
				(if (= (strcase tmp T) "current")(cons 8 (getvar "clayer"))(cons 8 tmp))
				'(10 . (0 0 0))
				(cons 40 (/ (nth 2 (assoc tap:current_tap (cdr (assoc tap:thread_pitch (eval tap:thread_form))))) 2))
				)
			)
		)
	)

	(if tap:debug (progn (prompt "\n Hidden Circle DXF Code: " )(princ circle2)))

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
(tap:debug? "\n Tap Wrapper Function")

(defun c:tap ( / *error*)

	(defun *error* (msg)
		(setvar "cmdecho" 1)
		(prompt msg)
		(princ))

	(dcl_Project_Load "Tap" T)
;	(dcl_project_import project nil nil)

	(if (not (vl-registry-read tap:masterKey "taps"))
		(tap:registry 'reset)
	)

	(dcl_Form_Show Tap_Main)

	(princ)
)

(prompt "\nTap Creator loaded... type \"TAP\" to run.")