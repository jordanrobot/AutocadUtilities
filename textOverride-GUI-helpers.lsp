;####################################
;###   TextOverride GUI Helpers   ###
;####################################
;
;version 2.8.4
;
;by Matthew D. Jordan
;
;A set of helper functions that make avaiable TextOverride's
;shortcut set directly from a GUI.



(defun c:to_typical (/)
	(setq eset (ssget '((0 . "DIMENSION"))))
	(while (eq eset nil)
				 (prompt "  Nothing Selected!")
				 (setq eset (ssget '((0 . "DIMENSION")))))

	(to:text_override_function "<> TYP" eset)
)

(defun c:to_oncenter (/)
	(setq eset (ssget '((0 . "DIMENSION"))))
	(while (eq eset nil)
				 (prompt "  Nothing Selected!")
				 (setq eset (ssget '((0 . "DIMENSION")))))

	(to:text_override_function "<> OC" eset)
)

(defun c:to_oncentertypical (/)
	(setq eset (ssget '((0 . "DIMENSION"))))
	(while (eq eset nil)
				 (prompt "  Nothing Selected!")
				 (setq eset (ssget '((0 . "DIMENSION")))))

	(to:text_override_function "<> OC TYP" eset)
)

(defun c:to_centertocentertypical (/)
	(setq eset (ssget '((0 . "DIMENSION"))))
	(while (eq eset nil)
				 (prompt "  Nothing Selected!")
				 (setq eset (ssget '((0 . "DIMENSION")))))

	(to:text_override_function "<> CTC" eset)
)

(defun c:to_centerttocenterypical (/)
	(setq eset (ssget '((0 . "DIMENSION"))))
	(while (eq eset nil)
				 (prompt "  Nothing Selected!")
				 (setq eset (ssget '((0 . "DIMENSION")))))

	(to:text_override_function "<> CTC TYP" eset)
)

(defun c:to_skin (/)
	(setq eset (ssget '((0 . "DIMENSION"))))
	(while (eq eset nil)
				 (prompt "  Nothing Selected!")
				 (setq eset (ssget '((0 . "DIMENSION")))))

	(to:text_override_function "<> SKIN" eset)
)

(defun c:to_gap (/)
	(setq eset (ssget '((0 . "DIMENSION"))))
	(while (eq eset nil)
				 (prompt "  Nothing Selected!")
				 (setq eset (ssget '((0 . "DIMENSION")))))

	(to:text_override_function "<> GAP" eset)
)

(defun c:to_gaptypical (/)
	(setq eset (ssget '((0 . "DIMENSION"))))
	(while (eq eset nil)
				 (prompt "  Nothing Selected!")
				 (setq eset (ssget '((0 . "DIMENSION")))))

	(to:text_override_function "<> GAP TYP" eset)
)


(defun c:to_parenth (/)
	(setq eset (ssget '((0 . "DIMENSION"))))
	(while (eq eset nil)
				 (prompt "  Nothing Selected!")
				 (setq eset (ssget '((0 . "DIMENSION")))))

	(to:text_override_function "(<>)" eset)
)

(defun c:to_reset (/)

	(setq eset (ssget '((0 . "DIMENSION"))))
	(while (eq eset nil)
				 (prompt "  Nothing Selected!")
				 (setq eset (ssget '((0 . "DIMENSION")))))

	(to:text_override_function "" eset)
)


(defun c:to_ream (/)

	(setq eset (ssget '((0 . "DIMENSION"))))
	(while (eq eset nil)
				 (prompt "  Nothing Selected!")
				 (setq eset (ssget '((0 . "DIMENSION")))))

	(to:text_override_function "REAM <>" eset)
)