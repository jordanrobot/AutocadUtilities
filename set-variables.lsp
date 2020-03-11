;(or debug? (defun debug?( Value /)(or (not *debug*)(prompt Value))))
;(setq *debug* T)
;(debug? "\nSet Variables loading...")

;#########################
;###   Set Variables   ###
;#########################
;;
;Variable Reference
;http://www.hyperpics.com/system_variables/
;
;TODO:
;	Add a section for (if autocad version = target ver.) for the variables that are removed and flub up later versions.
;


(defun set_vars_to_defaults (/ version base_vars more_vars)

  (setq version (substr (getvar 'acadver) 1 4))

	;### 2000 & previous
  (setq	base_vars
	 (list
	   (list 'peditaccept 1)
	   (list "msltscale" 1)
	   (list "psltscale" 1)
	   (list "celtscale" 1)
	   (list "osmode" 191)
	   (list "mirrtext" 0)
	   (list "pickfirst" 1)
	   (list "menubar" 1)
	   (list "attdia" 1)
	   (list "3ddwfprec" 4)		;Controls the precision of 3D DWF or 3D DWFx publishing. 
	   (list "angbase" 0)		;
	   (list "angdir" 0)		; CCW
	   (list "apbox" 1)		; Aperture box off 0
	   (list "aperture" 7)		; zone of detection
	   (list "aunits" 0)		; 0 = degrees 4 = survey
	   (list "auprec" 2)		; no  od decimal places
	   (list "autosnap" 21)		; 
	   (list "blipmode" 0)		; 0 = blips off
	   (list "chammode" 0)		; require 2 distances
	   (list "cmddia" 1)
	   (list "cmdecho" 1)
	   (list "coords" 0)
	   (list "cursorsize" 15)	; size of cross
	   (list "dimfrac" 2)		; fraction stacking in dims
	   (list "dimassoc" 2)		;
	   (list "dragmode" 2)		; display outline
	   (list "dragp1" 10)
	   (list "dragp2" 25)
	   (list "edgemode" 0)		; trim to extension
	   (list "expert" 4)
	   (list "facetres" 4)
	   (list "filedia" 1)
	   (list "filletrad" 0)
	;  (list "fillmode"    1 )  ; 
	   (list "gridmode" 0)		; grid off
	   (list "grips" 2)		;
	   (list "gripsize" 5)		; grip box size
	   (list "highlight" 1)
	   (list "insbase" (list 0 0 0))
	   (list "isolines" 4)
	   (list "limcheck" 0)		; 0= allow create obj outside limites
	;(list "lunits"      4 )  ; 4=Arch  2=decimal	3=engineering
	   (list "luprec" 5)		; decimal places displayed for linear
	   (list "maxactvp" 64)		; max viewport to be regenerated
	   (list "maxsort" 500)		; max num of layers to sort in layer manager
	   (list "mbuttonpan" 1)	; middle button pan (0 = action in cui)
	   (list "measurement" 0)	; Imperial (1 = metric)
	   (list "measureinit" 0)	; Imperial (1 = metric)
	   (list "mirrtext" 0)		; 1=mirror text 0=text always aligned in reading direction
	   (list "offsetgaptype" 0)	;
	   (list "osmode" 191)
	   (list "pickadd" 1)
	   (list "pickauto" 1)
	   (list "pickbox" 5)		;the pick box size
	   (list "pickdrag" 0)		;Controls the method of drawing a selection window. 
	   (list "pickfirst" 1)		;Controls whether you select objects before (noun-verb selection) or after you issue a command. 
	   (list "pickstyle" 0)		;Controls the use of group selection and associative hatch selection. 
	   (list "plinegen" 0)		;Sets how linetype patterns generate around the vertices of a 2D polyline. 
	   (list "plinetype" 2)		;Specifies whether optimized 2D polylines are used. 
	   (list "plinewid" 0)		; pline width
	   (list "plotrotmode" 2)	; align lower left plot area with LL of paper
	   (list "polarang" 0.785398)		;Sets the polar angle increment. Values are 90, 45, 30, 22.5, 18, 15,10, and 5. 
	   (list "polarmode" 2)		;
	   (list "projmode" 1)		;Sets the current Projection mode for trimming or extending.
	   (list "proxygraphics" 1)	;
	   (list "proxynotice" 0)	;
	   (list "proxyshow" 1)		;
		;(list "qtextmode"   0 )  ; 1=display box ILO text
		;(list "regenmode"   1 )
	   (list "savetime" 0)		; minutes between auto save 0=no auto save
	   (list "sdi" 0)
	   (list "snapang" 0)
	   (list "snapbase" (list 0 0))	; hatch base point
	   (list "snapisopair" 1)
	   (list "snapmode" 0)
	   (list "snapstyl" 0)
	   (list "snaptype" 0)
	   (list "snapunit" (list 1 1))
	   (list "sortents" 127)
	   (list "splframe" 0)
	   (list "textfill" 1)		; plot with text filled
	   (list "textqlty" 50)		; text resolution of TT font while plotting
	   (list "textsize" 0.125)	; default text size
	   (list "tooltips" 1)
	   (list "trimmode" 1)
	   (list "tstackalign" 1)
	   (list "tstacksize" 70)
	   (list "unitmode" 0)
	   (list "ucsdetect" 1)
	   (list "ucsfollow" 0)
	   (list "ucsicon" 1)		; 0=no display 2=display icon at origin
	   (list "worldview" 1)
	   (list "visretain" 1)		; retain layer state
	   (list "xloadctl" 1)		; load xrefs
	   (list "zoomfactor" 60)
	   (list "zoomwheel" 0)		;zoom wheel direction
	 )
  )


					;### 2000i
  (if (>= version "15.05")
    (progn
      (setq more_vars (list (list 'rememberfolders 1)))
      (setq base_vars (append base_vars more_vars))
    )

    (princ "\n   <<Ignored AutoCAD 2000i Variable List>>")
  )

					;### 2002
  (if (>= version "15.06")
    (progn
      (setq more_vars
	     (list
	       (list 'dimassoc 2)
	       (list 'whipthread 3)
	     )
      )
      (setq base_vars (append base_vars more_vars))
    )

    (princ "\n   <<Ignored AutoCAD 2002 Variable List>>")
  )

					;### 2004
  (if (>= version "16.0")
    (progn
      (setq more_vars
	     (list
	       (list 'hpassoc 1)
	       (list 'peditaccept 1)
	       (list 'reporterror 1)
	       (list 'startup 0)
	       (list 'gripobjlimit 100)
	       (list 'mtextfixed 2)
	       (list 'olequality 1)
	     )
      )
      (setq base_vars (append base_vars more_vars))
    )

    (princ "\n   <<Ignored AutoCAD 2004 Variable List>>")
  )

					;### 2005
  (if (>= version "16.1")
    (progn
      (setq more_vars
	     (list
	       (list 'backgroundplot 0)
	       (list 'draworderctl 3)
	       (list 'fieldeval 31)
	       (list 'hpgaptol 1)
	       (list 'osnaphatch 0)	; deprecated?
	       (list 'xreftype 0)
	     )
      )
      (setq base_vars (append base_vars more_vars))
    )

    (princ "\n   <<Ignored AutoCAD 2005 Variable List>>")
  )

					;###2006
  (if (>= version "16.2")
    (progn
      (setq more_vars
	     (list
	       (list 'BDEPENDENCYHIGHLIGHT 1)
	       (list 'BLOCKEDITLOCK 0)
	       (list 'BTMARKDISPLAY 1)
	       (list 'CALCINPUT 1)
	       (list 'CENTERMT 1)
	       (list 'CMDINPUTHISTORYMAX 30)
	       (list 'CROSSINGAREACOLOR 4)
	       (list 'DTEXTED 2)
	       (list 'DYNDIGRIP 31)
	       (list 'DYNDIVIS 1)
	       (list 'DYNMODE -3)
	       (list 'DYNPICOORDS 0)
	       (list 'DYNPIFORMAT 1)
	       (list 'DYNPIVIS 1)
	       (list 'DYNPROMPT 1)
	       (list 'DYNTOOLTIPS 1)
	       (list 'FULLPLOTPATH 1)
	       (list 'GRIPDYNCOLOR 140)
	       (list 'HPINHERIT 0)
	       (list 'HPORIGINMODE 0)
	       (list 'HPSEPARATE 1)
	       (list 'INPUTHISTORYMODE 15)
	       (list 'LAYERFILTERALERT 2)
	       (list 'OSNAPOVERRIDE 0)
	       ;(list 'PREVIEWEFFECT 2)
	       (list 'PREVIEWFILTER 7)
	       (list 'RECOVERYMODE 2)
	       (list 'SELECTIONAREA 1)
	       (list 'SELECTIONAREAOPACITY 10)
	       (list 'SELECTIONPREVIEW 0)
	       (list 'SHOWLAYERUSAGE 0)
	       (list 'SSMPOLLTIME 600)
	       (list 'SSMSHEETSTATUS 2)
	       (list 'TABLEINDICATOR 1)
	       (list 'TEMPOVERRIDES 1)
	       (list 'TOOLTIPMERGE 0)
	       (list 'VTDURATION 500)
	       (list 'VTENABLE 3)
	       (list 'VTFPS 15)
	       (list 'WINDOWAREACOLOR 6)
	     )
      )
      (setq base_vars (append base_vars more_vars))
    )

    (princ "\n   <<Ignored AutoCAD 2006 Variable List>>")
  )

					;(list 'BACTIONCOLOR 7)
					;(list 'BGRIPOBJCOLOR 141)
					;(list 'BGRIPOBJSIZE 8)
					;(list 'BPARAMETERCOLOR 7)
					;(list 'BPARAMETERFONT
					;(list 'BPARAMETERSIZE				
					;(list 'BVMODE
					;(list 'HPOBJWARNING 10000)
					;(list 'HPORIGIN '0",0")
					;(list 'INTELLIGENTUPDATE
					;(list 'OSNAPZ 1)


					;###2007
  (if (>= version "17.0")
    (progn
      (setq more_vars
	     (list
	       (list 'AUTOSNAP 21)
	       (list 'DBLCLKEDIT 1)
	       (list 'DISPSILH 1)
	       (list 'DELOBJ 3)
	       (list 'PICKADD 2)
	       (list 'SOLIDHIST 0)
	     )
      )
      (setq base_vars (append base_vars more_vars))
    )

    (princ "\n   <<Ignored AutoCAD 2007 Variable List>>")
  )

					;POLARMODE
					;PROJECTNAME
					;SURFU
					;SURFV
					;TRACKPATH
					;(list BACKZ ; Deprecated?)
					;
					;(list 'FRONTZ ; Deprecated?


					;###2009
  (if (>= version "17.2")
    (progn
      (setq more_vars
	     (list
					;(list 'navvcubedisplay 3 )
	       (list 'navvcubelocation 1)
	       (list 'navvcubeopacity 10)
	       (list 'navvcubeorient 1)
	       (list 'navvcubesize 0)
	       (list 'LAYERDLGMODE 1)
	     )
      )
      (setq base_vars (append base_vars more_vars))
    )
    (princ "\n   <<Ignored AutoCAD 2009 Variable List>>")
  )
					;  ACTPATH
					;  ACTRECORDERSTATE
					;  ACTRECPATH
					;  ACTUI
					;  CAPTURETHUMBNAILS
					;  DGNIMPORTMAX
					;  DGNMAPPINGPATH
					;  LAYEREVALCTL
					;  MENUBAR
					;  MLEADERSCALE
					;  MTEXTTOOLBAR
					;  NAVSWHEELMODE
					;  NAVSWHEELOPACITYBIG
					;  NAVSWHEELOPACITYMINI
					;  NAVSWHEELSIZEBIG
					;  NAVSWHEELSIZEMINI
					;  PREVIEWTYPE
					;  PUBLISHHATCH
					;  QPLOCATION
					;  QPMODE
					;  QVDRAWINGPIN
					;  QVLAYOUTPIN
					;  ROLLOVERTIPS
					;  SHOWMOTIONPIN
					;  STATUSBAR
					;Undocumented
					;
					;CBARDISPLAYMODE
					;CDYNDISPLAYMODE
					;CNAMEFORMAT
					;CONSTRAINTRELAX
					;CONSTRAINTSOLVEMODE
					;RENDERQUALITY
					;SKYSTATUS

					;HIDEXREFSCALES
					;Hides xref scales in the annotation, plot and viewport scale list.
					;0 xref scales are not hidden
					;1 xref scales are hidden

					;(command  "navbar" "off")

					;###2010
  (if (>= version "18.0")
    (progn
      (setq more_vars
	     (list
	       (list 'BACTIONBARMODE 1)
	       (list 'DEFAULTGIZMO 0)
	       (list 'DIMTXTDIRECTION 0)
	       (list 'FRAME 2)
	       (list 'GRIPSUBOBJMODE 1)
	       (list 'MESHTYPE 1)
	       (list 'PDFOSNAP 1)
	       (list 'SUBOBJSELECTIONMODE 0)
	       (list 'PUBLISHALLSHEETS 0)
	       (list 'XREFNOTIFY 1)
	       (list 'LARGEOBJECTSUPPORT 0)
	       (list 'VSSILHEDGES 0 )
	       (list 'XDWGFADECTL 20)
	     )
      )
      (setq base_vars (append base_vars more_vars))
    )

    (princ "\n   <<Ignored AutoCAD 2010 Variable List>>")
  )

					;###2011
  (if (>= version "18.1")
    (progn
      (setq more_vars
	     (list
	       (list 'hpquickpreview 0)
	       (list 'selectioncycling 1)
	       (list 'navbardisplay 0)
	     )
      )

      (setq base_vars (append base_vars more_vars))
    )

    (princ "\n   <<Ignored AutoCAD 2011 Variable List>>")
  )

  (mapcar '(lambda (x) (setvar (car x) (cadr x))) base_vars)
  (princ)
)

(setvar "FILETABPREVIEW" 0)

(set_vars_to_defaults)