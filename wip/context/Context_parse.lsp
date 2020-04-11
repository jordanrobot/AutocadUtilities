;#######################
;###   Get Project   ###
;#######################

;TODO: get project data from folder structure

;parse through and look for he project directory format "\\##### - *\\"

  ;search the whole string?  or chop off each section at a \\ and examine that section?
    ; how to set the full path from this? ==> append the split sections to from left to right until you find a matching pattern?, then stop looking?

(defun GetProject (item / output name lst i q x item)
  
  (setq lst (str->lst item "\\")
        i (length lst)
        q nil)

  (foreach x lst
    (setq i (- i 1))
    (if (wcmatch x "##### *")
      (progn
        (setq name x)
        (if i (setq q i))
      )
    )
  )

  (if q
    (progn
      (setq lst (reverse lst))
      (repeat q (setq lst (cdr lst)))
      (setq lst (reverse lst))
      ;(princ lst)
      (setq output (list (car (str->lst name " - ")) (nth 1 (str->lst name " - ")) (strcat (lst->str lst "\\") "\\")))
    )
  )

(if output output)
)

(defun GetTask ( item / output name lst i q x item)
  (setq lst (str->lst item "\\"))
  (foreach x lst
    (if (wcmatch x "### *")
        (setq output (list (car (str->lst x "-")) (nth 1 (str->lst x " - ")) (strcat x "\\")))
    )
  )
(if output output)

)



;(setq currentProject (GetProject (getvar 'dwgprefix)))
;(setq currentTask (GetTask (getvar 'dwgprefix))



;(match_path "##### *")


;TODO: get task data from folder structure
;(setq currentTask '("Task Name"  "Task Number" "345 - Big Top\\"))



;#############################
;###   Scan for RAW Data   ###
;#############################

;Raw file list from scan:


(setq fileListRaw 0)

(defun ScanFiles (/)
  (if (= fileListRaw (getallfiles (vl-string-right-trim "\\" (caddr CurrentProject)) "*"))
      nil
      (setq fileListRaw (getallfiles (vl-string-right-trim "\\" (caddr CurrentProject)) "*"))
  )
)


;(defun RemoveByWilcard (inputList wildcards)
;
;e.g.
;(RemoveByWildcard fileListRaw "*Issued Documents*,*Transmitted Documents*,*Machine Shop Documents*")




;(defun SplitList (inputList destinationList wildcards option [split/copy]))
;
;e.g.
;(SplitList fileListRaw fileListIssued "*Issued Documents*" 'split')
;(SplitList fileListRaw fileListDWGS "*MODL*,*AUXL*,*SKTH*,*FABA*,*FABB*,*FABC*" 'split)
;(SplitList fileListRaw fileListBOMS "*BOMS*" 'split)
;(SplitList fileListRaw fileListCNC "*MJET*,*MDXF*,*MROT*" 'split)

;(defun )
;
;
;


;Sorted file list from scan:
;(setq fileList ( ("MODL" (file1) (file2)) ("AUXL" (file3) (file4))... ))


;Archived file list from scan:
;(setq cx:fileListArchive ( (file1) (file2) (file3) (file4)... )


;Folder list from directory scan:
;(setq cx:fileListDirs ((dir1) (dir2) (dir3) (dir4)... ))

;(defun DirectoryScan(/)
;
; )





