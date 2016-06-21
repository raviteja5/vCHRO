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
;;************facts*************
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
	(ask trustworthyness)
	(ask neuroticism)
	(ask conscientiousness)
	(ask extrovertedness)
	(ask agreeableness)
	(ask coachability)
)

;;rules ********************
;;elimination heuristic - trusworthyness is a must
(defrule disqualified
	(answer (ident trustworthyness) (text ?trust))
	
	(test (< ?trust 5))
	=>
	(assert (disqualified))
	(printout t "candidate disqualified" crlf)
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
(defrule good
	(answer (ident trustworthyness) (text ?trust))
	(answer (ident neuroticism) (text ?neuro))
	(answer (ident conscientiousness) (text ?consc))
	(answer (ident extrovertedness) (text ?extr))
	(answer (ident agreeableness) (text ?agre))
	(answer (ident coachability) (text ?coac))
	(idealEmployee (trust ?t) (neuro ?n) (consci ?c) (extro ?e) (agree ?a) (coach ?c))
	(test (>= (+ (* ?t ?trust) (* ?n ?neuro) (* ?c ?consc) (* ?e ?extr) (* ?a ?agre) (* ?c ?coac)) 25)) ;;if sum >= 25
	=>
	(assert (good))
	(printout t "good candidate" crlf)
)
;;any score <25 is considered as poor candidate
(defrule poor
	(answer (ident trustworthyness) (text ?trust))
	(answer (ident neuroticism) (text ?neuro))
	(answer (ident conscientiousness) (text ?consc))
	(answer (ident extrovertedness) (text ?extr))
	(answer (ident agreeableness) (text ?agre))
	(answer (ident coachability) (text ?coac))
	(idealEmployee (trust ?t) (neuro ?n) (consci ?c) (extro ?e) (agree ?a) (coach ?c))
	(test (< (+ (* ?t ?trust) (* ?n ?neuro) (* ?c ?consc) (* ?e ?extr) (* ?a ?agre) (* ?c ?coac)) 25)) ;;if sum < 25
	=>
	(assert (poor))
	(printout t "poor candidate" crlf)
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
