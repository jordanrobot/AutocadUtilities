;##############################
;###   Step Leg Estimator   ###
;##############################
;version 1.0
;
;	Matthew D. Jordan - October 2009
;
;	Estimate the materials needed to build x number of step legs.
;	measurement is to the top of the plywood (bottom of plat frame) in inches.

; Command:
;		legs

(defun c:legs ( / leg_count leg_length )
	(setq leg_count (GETREAL "how many legs?: \n"))
	(setq leg_length (GETREAL "What is the leg height? (in): "))
	(prompt "\n")
	(princ (/ leg_count (+ 0.0 (* 4 (fix (/ 96 (+ 0.125 leg_length)))))) )
	(prompt " sheets of plywood \n")
	(princ)
	(princ (/ leg_count (+ 0.0 (fix (/ 192 (+ leg_length 3.5))))))
	(prompt " sticks of 2x4x16' \n")
	(princ)
)