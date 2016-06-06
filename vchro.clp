;;templates ********************

(deftemplate person "info about person"
	(slot name)
	(slot interview)
	(slot education)
	(slot big5)
)

;;facts ********************

(deffacts data
	(person 
		(name BobTheBuilder)
		(interview 9)
		(education 9)
		(big5 9))
	(person 		
		(name TheKindOne)
		(interview 3)
		(education 7)
		(big5 8))
)

;;rules ********************

(defrule ed
	(person 
		(name ?name)
		(interview ?int)
		(education ?ed)
		(big5 ?b5))
	(test(> ?int 5))
	(test(> ?ed 4))
	(test(> ?ed 3))
	=>
	(assert (hire ?name)))
	
(defrule printHires
	(hire ?name)
	=>
	(printout t "Hire " ?name crlf))
	
	 