(defun c:na ( / l1 n temp )
  ;; As-Built Tools
  ;; Alan J. Thompson, 05.02.11
  ;; Modified by Lee Mac 25.05.11
  ;; modified by Matthew D. Jordan


  (setq l1
   '(
      ("Navigator" 1)
      ("" 1)
      ("Drawing Root"      0 (startapp "explorer.exe" (getvar "dwgprefix")))
      ("3D Blocks"      0 (startapp "explorer.exe" "K:\\!Engineering Admin\\CAD\\3D Block Library"))
      ("2D Blocks"      0 (startapp "explorer.exe" "K:\\!Engineering Admin\\CAD\\2D Block Library"))
      ("Hardware \(Fasteners\)"      0 (startapp "explorer.exe" "K:\\!Engineering Admin\\CAD\\3D Block Library\\Hardware \(Fasteners\)")
      )
      

      ("" 1)
      ("2014" 0 (startapp "explorer.exe" "K:\\!Projects\\2014"))
      ("2015" 0 (startapp "explorer.exe" "K:\\!Projects\\2015"))
      ("2016" 0 (startapp "explorer.exe" "K:\\!Projects\\2016"))
      ("" 1)
      ("Standard Parts" 0 (startapp "explorer.exe" "K:\\!Engineering Admin\\! Standard Parts"))
      ("Analysis" 0 (startapp "explorer.exe" "K:\\!Engineering Admin\\Analysis Library"))
      ("Operations" 0 (startapp "explorer.exe" "K:\\!Engineering Admin\\Operations"))
      ("Inventory List" 0 (startapp "explorer.exe" "K:\\!Engineering Admin\\Operations\\Inventory List\\PRG - TD&E Inventory List.xlsm"))
      ;("" 0 (startapp "explorer.exe" ""))
      ;("" 0 (startapp "explorer.exe" ""))
      ;("" 0 (startapp "explorer.exe" ""))
      ;("" 0 (startapp "explorer.exe" ""))
      ;("" 0 (startapp "explorer.exe" ""))
      ("" 1)
      ("Old Projects" 0 (startapp "explorer.exe" "C:\\Users\\mjordan\\STNY\\Jordan Projects\\! Old Projects"))
      ("Jordan (Server)" 0 (startapp "explorer.exe" "K:\\!Engineering Admin\\! Working Folders !\\Jordan"))
      ("LISP" 0 (startapp "explorer.exe" "X:\\acad\\LISP"))
    )
  )

  (if (setq n (dos_popupmenu (mapcar 'car l1) (mapcar 'cadr l1)))
    (eval
      (caddr (nth (1- n) (vl-remove-if-not '(lambda ( x ) (zerop (cadr x))) l1)))
    )
  )
  (princ)
)


;(dos_readdelimitedfile "X:\\acad\\LISP\\navigator\\custom.txt" "," T)