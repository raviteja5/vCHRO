;;***************templates of question and answer**************
(deftemplate question "application might ask these question"
    (slot text)  ;; question text   
    (slot ident) ;; name of the question
)

(deftemplate answer
    (slot ident)
    (slot text)
)
;;************Arash Facts*************
;;question to test technology dimenstion of the candidate
(deffacts technocal-question
	(question
		(ident resumecontent)
		(text "On a scale of 0~5 how do you rate the candidate's resume (0-5)?")
	)
	(question
		(ident workingvisa)
		(text "Enter 0 or 1 if the candidate has working VISA (0 means no, 1 means yes).")
	)
	(question
		(ident schoolrating)
		(text "On a scale of 0~5 how do you rate the candidate's school rating (0-5)?")
	)
	(question
		(ident relatedworkexperience)
		(text "On a scale of 0~10 how do you rate the candidate's related work experience (0-10), note that any score greater and equal to 8 means the candidate has plenty of related work experiences")
	)
	(question
		(ident compensation)
		(text "Enter 0 or 1 if the candidate accept the compensation range you offer (0 means no, 1 means yes).")
	)
	(question
		(ident codingconvention)
		(text "On a scale of 0~5 how do you rate the candidate's coding convention (0-5)?")
	)
	(question
		(ident codingtalent)
		(text "Enter 0 or 1 if the candidate has equal or greater coding talent than Arush (0 means no, 1 means yes).")
	)
	(question
		(ident previouscompanyrating)
		(text "On a scale of 0~5 how do you rate the candidate's previous company rating (0-5)?")
	)
	(question
		(ident codingsolution)
		(text "On a scale of 0~10 how do you rate the candidate's coding solution (0-10), note that any score greater and equal to 8 means the candidate has creative coding solution")
	)
	(question
		(ident explanation)
		(text "On a scale of 0~5 how do you rate the candidate's explanation for the coding solution (0-5)?")
	)
	(ask resumecontent)
	(ask workingvisa)
	(ask schoolrating)
	(ask relatedworkexperience)
	(ask compensation)
	(ask codingconvention)
	(ask codingtalent)
	(ask previouscompanyrating)
	(ask codingsolution)
	(ask explanation)
)

;;Armir rules ********************
;;elimination heuristic - Would not hire foreigner
(defrule disqualifiedDueToWorkingvisa
	(answer (ident workingvisa) (text ?wkv))
	(test (< ?wkv 1))
	=>
	;(ap = 0)
	(assert (disqualified))
	(printout t "Candidate disqualified because of working VISA is needed" crlf)
)
;;elimination heuristic - stay on budget
(defrule disqualifiedDueToOverBudget
	(answer (ident compensation) (text ?cps))
	(test (< ?cps 1))
	=>
	(assert (disqualified))
	(printout t "Candidate disqualified because of asking more then you would like to pay" crlf)
)
;;If the candidate has plenty of related work experiences
(defrule exceptionalDueToRelatedWorkExperiences 
	(answer (ident relatedworkexperience) (text ?rwke))
	(test (>= ?rwke 8))
	=>
	(assert (exceptional))
	(printout t "exceptional candidate due to having plenty of related working experiences" crlf)
)
;;If the candidate has creative coding solutioin
(defrule exceptionalDueToCreativeCoding
	(answer (ident codingsolution) (text ?coso))
	(test (>= ?coso 8))
	=>
	(assert (exceptional))
	(printout t "exceptional candidate due to creative coding skill" crlf)
)
;;to be a good candidate >=37.5 (83.33%) score
(defrule good
	(answer (ident resumecontent) (text ?resu))
	(answer (ident schoolrating) (text ?scho))
	(answer (ident relatedworkexperience) (text ?rwke))
	(answer (ident codingconvention) (text ?cdct))
	(answer (ident previouscompanyrating) (text ?pcr))
	(answer (ident codingsolution) (text ?coso))
	(answer (ident explanation) (text ?expl))
	(test (>= (+ ?resu ?scho ?rwke ?cdct ?pcr ?coso ?expl) 37.5)) ;;if sum >= 37.5
	=>
	(assert (good))
	(printout t "potential candidate" crlf)
)
;;any score <37.5 (83.33%) is considered as poor candidate
(defrule poor
	(answer (ident resumecontent) (text ?resu))
	(answer (ident schoolrating) (text ?scho))
	(answer (ident relatedworkexperience) (text ?rwke))
	(answer (ident codingconvention) (text ?cdct))
	(answer (ident previouscompanyrating) (text ?pcr))
	(answer (ident codingsolution) (text ?coso))
	(answer (ident explanation) (text ?expl))
	(test (< (+ ?resu ?scho ?rwke ?cdct ?pcr ?coso ?expl) 37.5)) ;;if sum < 37.5
	=>
	(assert (poor))
	(printout t "unqualified candidate" crlf)
)

;;rule to get the answer if not given put a rule so it prompts later
(defrule supply-answers
	(answer (ident ?id))
	(not (answer (ident ?id)))
	(not (ask ?id))
	=>
	(assert (ask ?id))
)

;;functions called from ask-question-by-id
(deffunction ask-user (?question)
	"Ask a question and return the answer"
	(bind ?answer "")
	(printout t ?question " ")
	(bind ?answer (read))
	(return ?answer)
)

;;rule what question to ask and what question not-to as it's answered already
(defrule ask-question-by-id
	"ask user by id"
	(question (ident ?id) (text ?text))
	(not (answer (ident ?id)))
	?ask <- (ask ?id)
	=>
	(retract ?ask)
	(bind ?ans (ask-user ?text))
	(assert (answer (ident ?id) (text ?ans)))
)
