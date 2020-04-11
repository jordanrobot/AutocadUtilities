(defun acons (x y a) (cons (cons x y) a))

;; REGEXP.LSP 
;; Copyright (c) 2004, Tony Tanzillo ;; 
;; Sample showing how to use RegExp from Visual LISP 


(defun RegExpTest ( / RegExp cnt match result i) 
	(setq RegExp (vlax-create-object "VBScript.RegExp"))
	(vlax-put-property RegExp 'Pattern "is.")
	(vlax-put-property RegExp 'Global :vlax-true)
	(vlax-put-property RegExp 'IgnoreCase :vlax-true)
	(setq result (vlax-invoke-method RegExp 'Execute "IS1 is2 IS3 is4") )

	(princ (strcat "\nMatches found: " (itoa (setq cnt (vlax-get-property Result 'Count))) ) )
	(setq i 0)
	(repeat cnt 
		(setq match (vlax-get-property Result 'Item i))
		(princ (strcat "\nMatch[" (itoa i) "]: " (vlax-get-property Match 'Value)))
		(setq i (1+ i)) 
	)
	(vlax-release-object result) (vlax-release-object RegExp) ) ;;;;;;;;;;; REGEXP.LSP ;;;;;;;;;;;;;; -- 

