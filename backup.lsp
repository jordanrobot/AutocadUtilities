;##################
;###   Backup   ###
;##################
;version: 1.0
;
;	Matthew D. Jordan - August 2010
;
; Handles automatic daily backups (e.g. "/dwgprefix/backups/file - 2010.08.28.dwg").
; This must be manually enabled in each file you want to back up. After that though,
; the backup status for that file remains persistent - even across different computers.
; Note that backups will only occur while this lisp is loaded.
;
; Command: Backup
;        1. Toggle backup on & off (for current file)
;        2. Edit backup directory location
;        3. Show backup directory in explorer

(vl-load-com)

(setq default-backup-value "OldVersions")

(defun backup?()
  (if	(vl-catch-all-error-p (vl-catch-all-apply 'vla-GetCustomByKey 
        (list (vla-get-SummaryInfo (vla-get-ActiveDocument (vlax-get-acad-object)))
              "Backup" 
              'backup-value)))
      (progn (zerop 1)(setq backup-value nil))
      (zerop 0)))


(defun backup-reaction ( reactor params / )
  (if (backup?) (backup-engine)))


(if (null backup-Reactor)
  (setq backup-Reactor (vlr-editor-reactor nil '((:vlr-saveComplete . backup-reaction)))))

(if (backup?)
    (prompt "\nBackups are enabled in this file.\n"))


(defun backup-engine ( / date dwg-full backup-directory new-file )
	(setq
      date (rtos (getvar "CDATE") 2 0)
      date (strcat (substr date 1 4) "." (substr date 5 2) "." (substr date 7 2)))

  (setq dwg-full (strcat (getvar "dwgprefix") (getvar "dwgname"))
        backup-directory (strcat (getvar "dwgprefix") backup-value "\\")
        new-file (strcat backup-directory (vl-filename-base dwg-full) " - " date ".dwg"))

  (if (not (vl-file-directory-p backup-directory))
           (vl-mkdir backup-directory))

  (if	(= (vl-file-copy dwg-full new-file) nil)
      (progn
        (vl-file-delete new-file)
        (vl-file-copy dwg-full new-file)
        (prompt ": Backup saved."))
      (prompt ": Backup saved."))

  (princ))


(defun c:backup( / tmp *error* )
  (defun *error* (msg)
    (if (and msg (/= msg "") (not (wcmatch (strcase msg) "*QUIT*,*CANCEL*")))
        (princ (strcat "\nError: " msg))))

  (setq tmp (vla-get-SummaryInfo (vla-get-ActiveDocument (vlax-get-acad-object))))

  (initget "Yes Edit Show eXit")
  (or (if (backup?)
          (setq answer (getkword "\nBackup is ON... turn it OFF? [Yes/Edit/Show/eXit]<Yes>: "))
          (setq answer (getkword "\nBackup is OFF... turn it ON? [Yes/Edit/eXit]<Yes>: ")))
      (setq answer "Yes"))

  (cond	
    ((= answer "Yes")
      (if (backup?)
        (vl-catch-all-apply 'vla-removecustombykey (list tmp "Backup"))
        (vla-addcustominfo tmp "Backup" default-backup-value)))

    ((= answer "Edit")
      (if (backup?)
        (prompt (strcat "Current sub-directory: " backup-value "\n")))

      (setq backup-value (getstring "New sub-directory <Default>: "))
      (cond
        ((= backup-value "")
          (setq backup-value default-backup-value)
          (prompt backup-value))
        ((= x (strcase backup-value T)) (princ)))

      (vl-catch-all-apply 'vla-removecustombykey (list tmp "Backup"))
      (vl-catch-all-apply 'vla-addcustominfo (list tmp "Backup" backup-value)))

    ((and (= answer "Show") (backup?))
      (startapp "explorer.exe" (strcat (getvar "dwgprefix") backup-value "\\")))

    ((and (= answer "Show") (not (backup?))))

    ((= answer "eXit")))

  (princ)) ;defun