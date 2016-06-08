;;templates ********************

(deftemplate person "info about person"
	(slot name)
)

(deftemplate personality "Dimention of judgement - personality aspect"
	(slot trustworthyness)
	(slot neuroticism)
	(slot conscientiousness)
	(slot extrovertedness)
	(slot agreeableness)
	(slot coachability)
)

(deftemplate behaviorism "Dimention of judgement - behavior aspect"
	(slot trustworthyness)
	(slot neuroticism)
	(slot conscientiousness)
	(slot extrovertedness)
	(slot agreeableness)
	(slot coachability)
)

(deftemplate question "application might ask these question"
    (slot text)  ;; question text   
    (slot ident) ;; name of the question
)

(deftemplate answer
    (slot ident)
    (slot text)
)

;;facts ********************

(deffacts personality-question
	(question
		(ident trustworthyness)
		(text "On a scale of 0~5 how do you rate your trustworthyness (0-5)?")
	)
	(question
		(ident neuroticism)
		(text "On a scale of 0~5 how do you rate your newuroticism (0-5)?")
	)
	(question
		(ident conscientiousness)
		(text "On a scale of 0~5 how do you rate your neuroticism (0-5)?")
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
	(ask trustworthyness)
	(ask neuroticism)
	(ask conscientiousness)
	(ask extrovertedness)
	(ask agreeableness)
	(ask coachability)
)

;;rules ********************

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

(defrule good
	(answer (ident trustworthyness) (text ?trust))
	(answer (ident neuroticism) (text ?neuro))
	(answer (ident conscientiousness) (text ?consc))
	(answer (ident extrovertedness) (text ?extr))
	(answer (ident agreeableness) (text ?agre))
	(answer (ident coachability) (text ?coac))
	
	(test (>= (+ ?trust ?neuro ?consc ?extr ?agre ?coac)) 25) ;;if sum >= 25
	=>
	(assert (good))
	(printout t "good candidate" crlf)
)

(defrule poor
	(answer (ident trustworthyness) (text ?trust))
	(answer (ident neuroticism) (text ?neuro))
	(answer (ident conscientiousness) (text ?consc))
	(answer (ident extrovertedness) (text ?extr))
	(answer (ident agreeableness) (text ?agre))
	(answer (ident coachability) (text ?coac))
	
	(test (< (+ ?trust ?neuro ?consc ?extr ?agre ?coac)) 25) ;;if sum >= 25
	=>
	(assert (poor))
	(printout t "poor candidate" crlf)
)

;;asking rule
(defrule supply-answers
	(answer (ident ?id))
	(not (answer (ident ?id)))
	(not (ask ?id))
	=>
	(assert (ask ?id))
)

;;functions

(deffunction ask-user (?question)
	"Ask a question and return the answer"
	(bind ?answer "")
	(printout t ?question " ")
	(bind ?answer (read))
	(return ?answer)
)

;;ask by id
(defrule ask-question-by-id
	"ask user by id"
	(question (ident ?id) (text ?text))
	(not (answer (ident ?id))
	?ask <- (ask ?id)
	=>
	(retract ?ask)
	(bind ?answer (ask-user ?text))
	(assert (answer (ident ?id) (text ?answer)))
)
