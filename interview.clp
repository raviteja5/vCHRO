
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

;;********* CTO Facts ***************
;;question to test technology dimenstion of the candidate
(deffacts technocalquestion
	(question
		(ident resumecontent);;scale the candidate's resume
		(text "On a scale of 0~5 how do you rate the candidate's resume content (0-5)?")
	)
	(question
		(ident workingvisa);;true or false question if the candidate need the working VISA
		(text "Enter 0 or 1 if the candidate need working VISA (0 means no, 1 means yes):")
	)
	(question
		(ident schoolrating);;scale the candidate's resume
		(text "On a scale of 0~5 how do you rate the candidate's school rating (0-5)?")
	)
	(question
		(ident relatedworkexperience);;scale the candidate's experience (this score will be used to multiply with the score from candidate's previous company rating)
		(text "On a scale of 0~7 how do you rate the candidate's related work experience, 
note that any score greater and equal to 5 means the candidate has plenty of related work experiences (0-7)?")
	)
	(question
		(ident compensation);;true or false question if the candidate satisfy the salary
		(text "Enter 0 or 1 if the candidate accept the compensation range you offer (0 means no, 1 means yes):")
	)
	(question
		(ident codingconvention);;scale the candidate's coding assessment
		(text "On a scale of 0~5 how do you rate the candidate's coding convention (0-5)?")
	)
	(question
		(ident codingtalent);;compare the candidate's coding with Arash's 
		(text "On a scale of -5 to 5 how do you rate  the candidate has less, equal or greater coding talent than Arash (-5 to +5)?")
	)
	(question
		(ident previouscompanyrating);;scale the candidate's previous company's rating (this score will be used to multiply with the score from related working experience)
		(text "On a scale of 0~5 how do you rate the candidate's previous company (0-5)?")
	)
	(question
		(ident codingsolution);;scale the candidate's coding solution (this score will be used to multiply with the score from the coding explanation)
		(text "On a scale of 0~7 how do you rate the candidate's coding solution, 
note that any score equal to 5 means the candidate has creative coding solution (0-7)?")
	)
	(question
		(ident explanation);;scale the candidate's explanation for the coding (this score will be used to multiply with the score from the coding solution)
		(text "On a scale of 0~5 how do you rate the candidate's explanation for the coding solution (0-5)?")
	)
	(question
		(ident resumerequirement);;true or false question if the candidate's resume match the required skill set
		(text "Enter 0 or 1 if the candidate's resume meet the requirement (0 means no, 1 means yes):")
	)
	(question
		(ident jobexperience);;true or false question if the candidate has any job experience
		(text "Enter 0 or 1 if the candidate has job experience (0 means no, 1 means yes):")
	)
		(question
		(ident questionsquality);;scale the candidate's question at the end of the interview
		(text "On a scale of 0~5 how do you rate the candidate's questions (0-5)?")
	)
	;;question id (question order is from the bottom to the top)
	;(CTOask questionsquality)
	;(CTOask compensation)
	;(CTOask codingtalent)
	;(CTOask explanation)
	;(CTOask codingsolution)
	;(CTOask codingconvention)
	;(CTOask relatedworkexperience)
	;(CTOask previouscompanyrating)
	;(CTOask schoolrating)
	;(CTOask resumecontent)
	;(CTOask workingvisa)
	;(CTOask jobexperience)
	;(CTOask resumerequirement)
)


;;********* CTO Rules *****************
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
;;elimination heuristic - coding performance
(defrule disqualifiedDueTocodingPerformance
	(answer (ident codingsolution) (text ?coso))
	(answer (ident explanation) (text ?expl))
	(test (< (* ?coso ?expl) 12));;the multiplication of codingsolution and explanation should be greater and equal to 12
	=>
	(assert (disqualified))
	(printout t "Candidate disqualified because of poor coding performance" crlf)
	(halt)
)
;;elimination heuristic - must know how to work
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
;;to be a good candidate >=63 (90%) score (the full point is 70 and there are another 25 extra points)
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
	(test (>= (+ (* ?coso ?expl) (* ?pcr ?rwke) ?resu ?scho ?cdct ?codtl ?quequa) 63)) ;;if sum >= 63
	=>
	(assert (goodByCTO))
	(assert (canAskCEO))
	(printout t "This interviewee is a potential candidate, moving on to the next interview with the CEO!!" crlf)
)
;;any score <63 (90%) is considered as poor candidate
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
	(test (< (+ (* ?coso ?expl) (* ?pcr ?rwke) ?resu ?scho ?cdct ?codtl ?quequa) 63)) ;;if sum < 63
	=>
	(assert (disqualified))	
	(printout t "The CTO disqualified the candidate in round 1 due to the low score" crlf)
	(halt)
)

;;************CEO facts*************
;;question to test personality dimenstion of the candidate
(deffacts personality-question
	(question
		(ident trustworthyness)
		(text "On a scale of 0~5 how do you rate the candidate's trustworthyness (0-5)?")
	)
	(question
		(ident neuroticism)
		(text "On a scale of 0~5 how do you rate the candidate's neuroticism (0-5)?")
	)
	(question
		(ident conscientiousness)
		(text "On a scale of 0~5 how do you rate the candidate's conscientiousness (0-5)?")
	)
	(question
		(ident extrovertedness)
		(text "On a scale of 0~5 how do you rate the candidate's extrovertedness (0-5)?")
	)
	(question
		(ident agreeableness)
		(text "On a scale of 0~5 how do you rate the candidate's agreeableness (0-5)?")
	)
	(question
		(ident coachability)
		(text "On a scale of 0~5 how do you rate the candidate's coachability (0-5)?")
	)
	(question
		(ident emotion)
		(text "Which emotion is the strongest for the CEO during interview 0:Neutral 1:Anxiety 2:Joy 3:Midly Sad 4:Fear 5:Anger (0-5)?")
	)
    (question
		(ident emotionLevel)
		(text "What is the level of this emotion during the interview (0-5)?")
	)
    (question
		(ident polarized)
		(text "Is this emotion due to pre-existing mooods(0) or due to the candidate (1)?")
	)
    (question
		(ident candidateForSTG)
		(text "Might the candidate help in achieving short term goal(0-No 1-Yes)?")
	)
    (question
		(ident stereotype)
		(text "Is the candidate good or bad based on CEO's stereotype on the candidate (0=Best; 5=Worst)?")
	)
	(question
		(ident referenceDep)
		(text "Is the candidate better compare to the one just interviewed before (0-No 1-Yes)?")
	)
	(question
		(ident susceptibility)
		(text "Is the CEO a highly susceptible person (0-No 1-Yes)?")
	)
	;(CEOask emotion)
	;(CEOask emotionLevel)
	;(CEOask susceptibility)
	;(CEOask referenceDep)
	;(CEOask polarized)
	;(CEOask stereotype)	
	;(CEOask candidateForSTG)
	;(CEOask trustworthyness)
	;(CEOask neuroticism)
	;(CEOask conscientiousness)
	;(CEOask extrovertedness)
	;(CEOask agreeableness)
	;(CEOask coachability)
)

(defglobal ?*thres* = 75)
(defglobal ?*suscep* = 1)

;;***********CEO rules ********************
;;*******Pre-existing emotions Rules**
;;Susceptibility level of the CEO increases the strength of emotional effects on the hiring decision
(defrule susceptible
	(answer (ident susceptibility) (text ?susceptibility))
	(test (eq ?susceptibility 1))
	=>
	(bind ?*suscep* (* ?*suscep* 1.5))
	
)

;;Set pasing score to 75 for neutral or sad moods
(defrule neutralOrSad
	(answer (ident emotion) (text ?emotion))
	(answer (ident emotionLevel) (text ?emotionLevel))
	(test (>= ?emotionLevel 3))
	(test (or (eq ?emotion 0) (eq ?emotion 3)))
	=>
	(bind ?*thres* 75)
)

;;Set passing score to 40 for anxious CEO
(defrule anxious
	(answer (ident emotion) (text ?emotion))
	(answer (ident emotionLevel) (text ?emotionLevel))
	(test (>= ?emotionLevel 3))
	(test (eq ?emotion 1))
	=>
	(bind ?*thres* 40)
	(printout t "CEO is anxious." crlf)
)

;;Decrease passing score by 10 for joyful CEO
(defrule joyful
	(answer (ident emotion) (text ?emotion))
	(answer (ident emotionLevel) (text ?emotionLevel))
	(test (>= ?emotionLevel 3))
	(test (eq ?emotion 2))
	=>
	(bind ?*thres* (- ?*thres* (* 10 suscep)))
	(printout t "CEO is joyful." crlf)
)

;;Decrease passing score by 10 for fearful CEO, given that candidate might help in achieving Short term goal
(defrule fearful
	(answer (ident emotion) (text ?emotion))
	(answer (ident candidateForSTG) (text ?stg))
	(answer (ident emotionLevel) (text ?emotionLevel))
	(test (>= ?emotionLevel 3))
	(test (eq ?emotion 4))
	(test (>= ?stg 1))
	=>
	(bind ?*thres* (- ?*thres* (* 10 suscep)))
	(printout t "CEO is fearful, and the candidate might help in achieving Short Term Goal." crlf)
)

;;Increase passing score by 10 for angry CEO, given that candidate has a bad impression based on CEO's stereotype
(defrule angry
	(answer (ident emotion) (text ?emotion))
	(answer (ident stereotype) (text ?stereotype))
	(answer (ident emotionLevel) (text ?emotionLevel))
	(test (>= ?emotionLevel 3))
	(test (eq ?emotion 5))
	(test (>= ?stereotype 3))
	=>
	(bind ?*thres* (+ ?*thres* (* 10 suscep)))
	(printout t "CEO is angry, and the candidate is not good based on his stereotype." crlf)
)

;;***** Emotions during interview - Rules ***********
;;Further decrease passing score by 5 if emotion is due to candidate (for joy and fear)
(defrule polarizedDecrease
	(answer (ident polarized) (text ?polarized))
	(answer (ident emotion) (text ?emotion))
	(test (or (eq ?emotion 2) (eq ?emotion 3)))
	(test (eq ?polarized 1))
	=>
	(bind ?*thres* (- ?*thres* (* 5 suscep)))
)

;;Further increase passing score by 5 if emotion is due to candidate (for anger)
(defrule polarizedIncrease
	(answer (ident polarized) (text ?polarized))
	(answer (ident emotion) (text ?emotion))
	(answer (ident stereotype) (text ?stereotype))
	(test (>= ?stereotype 3))
	(test (eq ?emotion 5))
	(test (eq ?polarized 1))
	=>
	(bind ?*thres* (+ ?*thres* (* 5 suscep)))
)

;;Decrease passing score by 5 if the CEO feels current candidate is better then the previous candidate(s)
(defrule referenceDependence
	(answer (ident referenceDep) (text ?referenceDep))
	(test (eq ?referenceDep 1))
	=>
	(bind ?*thres* (- ?*thres* (* 5 suscep)))
)



;;*****Disqualify/Exceptional Rules *************
;;elimination heuristic - trusworthyness is a must
(defrule disqualified
	(answer (ident trustworthyness) (text ?trust))
	(test (< ?trust 5))
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
	(printout t "exceptional candidate, HIRE HIM/HER!!" crlf)
)
;;************* CEO says Yes ***************
;;Rule for CEO to say Yes when he is not anxious
(defrule goodByCEONotAnxious
	(answer (ident trustworthyness) (text ?trust))
	(answer (ident neuroticism) (text ?neuro))
	(answer (ident conscientiousness) (text ?consc))
	(answer (ident extrovertedness) (text ?extr))
	(answer (ident agreeableness) (text ?agre))
	(answer (ident coachability) (text ?coac))
	(answer (ident emotion) (text ?emotion))
	(idealEmployee (trust ?t) (neuro ?n) (consci ?cs) (extro ?e) (agree ?a) (coach ?c))
	(test (>= (+ (* ?t ?trust) (* ?n ?neuro) (* ?cs ?consc) (* ?e ?extr) (* ?a ?agre) (* ?c ?coac)) ?*thres*)) 
	(test (not(eq ?emotion 1)))
	=>
	(assert (goodByCEO))
	(printout t "CEO is either emotionally neutral or midly sad." crlf)
	(printout t "Good candidate!" crlf)
)

;;Anxious CEO : Only 3 traits are considered for anxious CEO (Same as previous rule but he is anxious)
(defrule goodByCEOAnxious
	(answer (ident neuroticism) (text ?neuro))
	(answer (ident extrovertedness) (text ?extr))
	(answer (ident agreeableness) (text ?agre))
	(answer (ident emotion) (text ?emotion))
	(idealEmployee (trust ?t) (neuro ?n) (consci ?cs) (extro ?e) (agree ?a) (coach ?c))
	(test (>= (+ (* ?n ?neuro) (* ?e ?extr) (* ?a ?agre)) ?*thres*))
	(test (eq ?emotion 1))
	(computedThres)
	=>
	(assert (goodByCEO))
	(printout t "CEO is anxious." crlf)
	(printout t "Good candidate!" crlf)
)

;;***************** CEO Says No **************
(defrule badByCEORetract
	(goodByCEO)
	?b <- (badByCEO)
	=>
	(retract b)
)

(defrule badByCEOAdd
	(not(goodByCEO))
	=>
	(assert (badByCEO))
	(printout t "Do not hire candidate!" crlf)
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
Contact GitHub API Training Shop Blog About
© 2016 GitHub, Inc. Terms Privacy Security Status Help
