
;;***************templates of question and answer**************
(deftemplate question "application might ask these question"
    (slot text)  ;; question text   
    (slot ident) ;; name of the question
)

(deftemplate answer
    (slot ident)
    (slot text)
)

(deftemplate idealEmployee
	(slot trust)
	(slot neuro)
	(slot consci)
	(slot extro)
	(slot agree)
	(slot coach)
)

;;********* Arash Facts ***************
;;question to test technology dimenstion of the candidate
(deffacts technocalquestion
	(question
		(ident resumecontent)
		(text "On a scale of 0~5 how do you rate the candidate's resume (0-5)?")
	)
	(question
		(ident workingvisa)
		(text "Enter 0 or 1 if the candidate need working VISA (0 means no, 1 means yes):")
	)
	(question
		(ident schoolrating)
		(text "On a scale of 0~5 how do you rate the candidate's school rating (0-5)?")
	)
	(question
		(ident relatedworkexperience)
		(text "On a scale of 0~7 how do you rate the candidate's related work experience, 
note that any score greater and equal to 5 means the candidate has plenty of related work experiences (0-7)?")
	)
	(question
		(ident compensation)
		(text "Enter 0 or 1 if the candidate accept the compensation range you offer (0 means no, 1 means yes):")
	)
	(question
		(ident codingconvention)
		(text "On a scale of 0~5 how do you rate the candidate's coding convention (0-5)?")
	)
	(question
		(ident codingtalent)
		(text "On a scale of -5~5 how do you rate  the candidate has less, equal or greater coding talent than Arush? ")
	)
	(question
		(ident previouscompanyrating)
		(text "On a scale of 0~5 how do you rate the candidate's previous company rating (0-5)?")
	)
	(question
		(ident codingsolution)
		(text "On a scale of 0~7 how do you rate the candidate's coding solution, 
note that any score equal to 5 means the candidate has creative coding solution (0-7)?")
	)
	(question
		(ident explanation)
		(text "On a scale of 0~5 how do you rate the candidate's explanation for the coding solution (0-5)?")
	)
		(question
		(ident compensation)
		(text "Enter 0 or 1 if the candidate accept the compensation range you offer (0 means no, 1 means yes):")
	)
			(question
		(ident resumerequirement)
		(text "Enter 0 or 1 if the candidate's resume meet the requirement (0 means no, 1 means yes):")
	)
		(question
		(ident jobexperience)
		(text "Enter 0 or 1 if the candidate has job experience (0 means no, 1 means yes):")
	)
		(question
		(ident questionsquality)
		(text "On a scale of 0~5 how do you rate the candidate's questions (0-5)?")
	)
	(CTOask questionsquality)
	(CTOask compensation)
	(CTOask codingtalent)
	(CTOask explanation)
	(CTOask codingsolution)
	(CTOask codingconvention)
	(CTOask relatedworkexperience)
	(CTOask previouscompanyrating)
	(CTOask schoolrating)
	(CTOask resumecontent)
	(CTOask workingvisa)
	(CTOask jobexperience)
	(CTOask resumerequirement)
)




;;********* Arash Rules *****************
;;elimination heuristic - meeting job requiremented resume
(defrule disqualifiedDueTounqualifiedResume
	(answer (ident resumerequirement) (text ?resurq))
	(test (< ?resurq 1))
	=>
	(assert (disqualified))
	(printout t "Candidate disqualified because of unqualified resume" crlf)
	(halt)
)
;;elimination heuristic - Would not hire foreigner
(defrule disqualifiedDueToWorkingvisa
	(answer (ident workingvisa) (text ?wkv))
	(test (> ?wkv 0))
	=>
	(assert (disqualified))
	(printout t "Candidate disqualified because of working VISA is needed" crlf)
	(halt)
)
;;elimination heuristic - stay on budget
(defrule disqualifiedDueToOverBudget
	(answer (ident compensation) (text ?cps))
	(test (< ?cps 1))
	=>
	(assert (disqualified))
	(printout t "Candidate disqualified because of asking more then you would like to pay" crlf)
	(halt)
)
;;elimination heuristic - Coding Performance
(defrule disqualifiedDueTocodingPerformance
	(answer (ident codingsolution) (text ?coso))
	(answer (ident explanation) (text ?expl))
	(test (< (* ?coso ?expl) 7))
	=>
	(assert (disqualified))
	(printout t "Candidate disqualified because of poor coding performance" crlf)
	(halt)
)
;;elimination heuristic - Know the work
(defrule disqualifiedDueToJobExperience
	(answer (ident jobexperience) (text ?jexp))
	(test (< ?jexp 1))
	=>
	(assert (disqualified))
	(printout t "Candidate disqualified because of no job experience" crlf)
	(halt)
)
;;If the candidate has plenty of related work experiences
(defrule exceptionalDueToRelatedWorkExperiences 
	(answer (ident relatedworkexperience) (text ?rwke))
	(test (>= ?rwke 5))
	=>
	(assert (exceptional))
	(printout t "exceptional candidate due to having plenty of related working experiences" crlf)
)
;;If the candidate has creative coding solutioin
(defrule exceptionalDueToCreativeCoding
	(answer (ident codingsolution) (text ?coso))
	(test (>= ?coso 5))
	=>
	(assert (exceptional))
	(printout t "exceptional candidate due to creative coding skill" crlf)
)
;;to be a good candidate >=56 (80%) score
(defrule goodByCTO
	(answer (ident resumecontent) (text ?resu))
	(answer (ident schoolrating) (text ?scho))
	(answer (ident relatedworkexperience) (text ?rwke))
	(answer (ident codingconvention) (text ?cdct))
	(answer (ident previouscompanyrating) (text ?pcr))
	(answer (ident codingsolution) (text ?coso))
	(answer (ident explanation) (text ?expl))
	(answer (ident codingtalent) (text ?codtl))
	(answer (ident questionsquality) (text ?quequa))
	(test (>= (+ (* ?coso ?expl) (* ?pcr ?rwke) ?resu ?scho ?cdct ?codtl ?quequa) 56)) ;;if sum >= 56
	=>
	(assert (goodByCTO))
	(assert (canAskCEO))
	(printout t "This interviewee is a potential candidate, moving on to the next interview with the CEO!!" crlf)
)
;;any score <56 (80%) is considered as poor candidate
(defrule poorByCTO
	(answer (ident resumecontent) (text ?resu))
	(answer (ident schoolrating) (text ?scho))
	(answer (ident relatedworkexperience) (text ?rwke))
	(answer (ident codingconvention) (text ?cdct))
	(answer (ident previouscompanyrating) (text ?pcr))
	(answer (ident codingsolution) (text ?coso))
	(answer (ident explanation) (text ?expl))
	(answer (ident codingtalent) (text ?codtl))
	(answer (ident questionsquality) (text ?quequa))
	(test (< (+ (* ?coso ?expl) (* ?pcr ?rwke) ?resu ?scho ?cdct ?codtl ?quequa) 56)) ;;if sum < 56
	=>
	(assert (disqualified))	
	(printout t "The CTO disqualified the candidate in round 1" crlf)
	(halt)
)



;;************Armir facts*************
;;question to test personality dimenstion of the candidate
(deffacts personality-question
	(question
		(ident trustworthyness)
		(text "On a scale of 0~5 how do you rate your trustworthyness (0-5)?")
	)
	(question
		(ident neuroticism)
		(text "On a scale of 0~5 how do you rate your neuroticism (0-5)?")
	)
	(question
		(ident conscientiousness)
		(text "On a scale of 0~5 how do you rate your conscientiousness (0-5)?")
	)
	(question
		(ident extrovertedness)
		(text "On a scale of 0~5 how do you rate your extrovertedness (0-5)?")
	)
	(question
		(ident agreeableness)
		(text "On a scale of 0~5 how do you rate your agreeableness (0-5)?")
	)
	(question
		(ident coachability)
		(text "On a scale of 0~5 how do you rate your coachability (0-5)?")
	)
	(CEOask trustworthyness)
	(CEOask neuroticism)
	(CEOask conscientiousness)
	(CEOask extrovertedness)
	(CEOask agreeableness)
	(CEOask coachability)
)

;;***********Armir rules ********************
;;elimination heuristic - trusworthyness is a must
(defrule disqualified
	(answer (ident trustworthyness) (text ?trust))
	
	(test (< ?trust 4))
	=>
	(assert (disqualified))
	(printout t "candidate disqualified because of low trusworthyness" crlf)
	(halt)
)
;;all traits full marks - is an exceptional candidate
(defrule exceptional
	(answer (ident trustworthyness) (text 5))
	(answer (ident neuroticism) (text 5))
	(answer (ident conscientiousness) (text 5))
	(answer (ident extrovertedness) (text 5))
	(answer (ident agreeableness) (text 5))
	(answer (ident coachability) (text 5))
	=>
	(assert (exceptional))
	(printout t "exceptional candidate" crlf)
)
;;to be a good candidate >=25 score
(defrule goodByCEO
	(answer (ident trustworthyness) (text ?trust))
	(answer (ident neuroticism) (text ?neuro))
	(answer (ident conscientiousness) (text ?consc))
	(answer (ident extrovertedness) (text ?extr))
	(answer (ident agreeableness) (text ?agre))
	(answer (ident coachability) (text ?coac))
	(idealEmployee (trust ?t) (neuro ?n) (consci ?cs) (extro ?e) (agree ?a) (coach ?c))
	(test (>= (+ (* ?t ?trust) (* ?n ?neuro) (* ?cs ?consc) (* ?e ?extr) (* ?a ?agre) (* ?c ?coac)) 25)) ;;if sum >= 25
	=>
	(assert (goodByCEO))
	(printout t "good candidate" crlf)
)
;;any score <25 is considered as poor candidate
(defrule poorByCEO
	(answer (ident trustworthyness) (text ?trust))
	(answer (ident neuroticism) (text ?neuro))
	(answer (ident conscientiousness) (text ?consc))
	(answer (ident extrovertedness) (text ?extr))
	(answer (ident agreeableness) (text ?agre))
	(answer (ident coachability) (text ?coac))
	(idealEmployee (trust ?t) (neuro ?n) (consci ?cs) (extro ?e) (agree ?a) (coach ?c))
	(test (< (+ (* ?t ?trust) (* ?n ?neuro) (* ?cs ?consc) (* ?e ?extr) (* ?a ?agre) (* ?c ?coac)) 25)) ;;if sum < 25
	=>
	(assert (poorByCEO))
	(printout t "poor candidate" crlf)
)

;;************Function for CEO and CTO questions *********
;;functions called from ask-question-by-id
(deffunction ask-user (?question)
	"Ask a question and return the answer"
	(bind ?answer "")
	(printout t ?question " ")
	(bind ?answer (read))
	(return ?answer)
)

;;************* Rules for CEO questions ****************
;;rule to get the answer if not given put a rule so it prompts later
(defrule supply-answers
	(answer (ident ?id))
	(not (answer (ident ?id)))
	(not (CEOask ?id))
	=>
	(assert (CEOask ?id))
)

;;rule what question to ask and what question not-to as it's answered already
(defrule ask-question-by-idCEO
	"ask user by id"
	(question (ident ?id) (text ?text))
	(not (answer (ident ?id)))
	?CEOask <- (CEOask ?id)
	(canAskCEO)
	=>
	(retract ?CEOask)
	(bind ?ans (ask-user ?text))
	(assert (answer (ident ?id) (text ?ans)))
)



;;**************Rules for CTO questions ****************

(defrule supply-answersCTO
	(answer (ident ?id))
	(not (answer (ident ?id)))
	(not (CTOask ?id))
	=>
	(assert (CTOask ?id))
)
;;rule what question to ask and what question not-to as it's answered already
(defrule ask-question-by-idCTO
	"ask user by id"
	(question (ident ?id) (text ?text))
	(not (answer (ident ?id)))
	?CTOask <- (CTOask ?id)
	=>
	(retract ?CTOask)
	(bind ?ans (ask-user ?text))
	(assert (answer (ident ?id) (text ?ans)))
)
