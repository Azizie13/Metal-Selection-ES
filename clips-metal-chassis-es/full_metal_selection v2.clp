;================================================================
;Initiliaze value

(deffacts DEFAULT "The intial value"
    (interface-shown chassis-select)
)

;===================Chassis Selection=============================
; Rules for selecting which chassis to use
(defrule chassis-selection
    ?interface <- (interface-shown chassis-select)
=>
    (buffer "chassis_select")
    (retract ?interface)
)

(defrule chassis-selection-front
    (declare (salience 50))
    (chassis-type front)
=>
    (buffer "front_sol_select")
)

(defrule chassis-selection-rear
    (declare (salience 50))
    (chassis-type rear)
=>
    (buffer "rear_sol_select")
)
;==============================================================

;=========================Front Chassis========================
; Solutions for Front Chassis
(defrule front-sol-1
    (chassis-type front)
    (solution-type 1)
=>
    ; (printout t "Solution: 1" crlf)
    ; (printout t "Subframe is Complex Phase Steel." crlf)
    (assert (subframe-type complex-phased))

    ; (printout t "Lower Control Arm is Complex Phase Steel." crlf)
    (assert (lc_arm-type complex-phased))
)

(defrule front-sol-2
    (chassis-type front)
    (solution-type 2)
=>
    ;(printout t "Solution: 2" crlf)
    ;(printout t "Subframe is Fortiform Steel." crlf)
    (assert (subframe-type fortiform))

    ;(printout t "Lower Control Arm is Complex Phase Steel." crlf)
    (assert (lc_arm-type complex-phased))
)

(defrule front-sol-3
    (chassis-type front)
    (solution-type 3)
=>
    ; (printout t "Solution: 3" crlf)
    ; (printout t "Subframe is Complex Phase Steel." crlf)
    (assert (subframe-type complex-phased))

    ; (printout t "Lower Control Arm is Ductibor Steel." crlf)
    (assert (lc_arm-type ductibor))
)

(defrule front-sol-4
    (chassis-type front)
    (solution-type 4)
=>
    ; (printout t "Solution: 4" crlf)
    ; (printout t "Subframe is Fortiform Steel." crlf)
    (assert (subframe-type fortiform))

    ; (printout t "Lower Control Arm is Usibor Steel." crlf)
    (assert (lc_arm-type usibor))
)
;===============================================================

;=========================Rear Chassis========================

(defrule rear-sol-1
    (chassis-type rear)
    (solution-type 1)
=>
    ; (printout t "Solution: 1" crlf)
    ; (printout t "Rear Cradle is Twist Beam." crlf)
    (assert (rear-cradle-steel 22MnB5))
    (assert (trailing-arm-steel None))

    ; (printout t "Rear Chassis has no Trailing Arm." crlf)
)

(defrule rear-sol-2
    (chassis-type rear)
    (solution-type 2)
=>
    ; (printout t "Solution: 2" crlf)
    ; (printout t "Rear Cradle is Complex Phase Steel." crlf)
    (assert (rearcradle-type complex-phased))

    ; (printout t "Trailing Arms is HSLA steel." crlf)
    (assert (trailingarm-type hsla))
)

(defrule rear-sol-3
    (chassis-type rear)
    (solution-type 3)
=>
    ; (printout t "Solution: 3" crlf)
    ; (printout t "Rear Cradle is Fortiform." crlf)
    (assert (rearcradle-type fortiform))

    ; (printout t "Lower Control Arm is Ductibor Steel." crlf)
    (assert (trailingarm-type hsla))
)

;===============================================================

;==========Steel Grade (Subframe Complex Phased Steel)==========
; Rules related to determining subframe steel grade, specifically Complex Phased Steel
; Subframe Part

(defrule sub-comp-values
    (chassis-type front)
    (subframe-type complex-phased)

=>
    (buffer "steel_val_select?subframe?tensile")
    (assert (choose subframe))
)

(defrule lc_arm-comp-values
    ?choose <- (choose lc_arm)
    (chassis-type front)
    (lc_arm-type complex-phased)

=>
    (buffer "steel_val_select?lc_arm?tensile")
)

(defrule sub-comp-grade1
    ?choose <- (choose subframe)
    (chassis-type front)
    (subframe-type complex-phased)
    (subframe-tensile-strength ?val)
    (test (>= ?val 600))
    (test (<= ?val 700))
=>
    (assert (subframe-steel CR360Y590T-CP))
    ; (printout t "Subframe Steel Grade is CR360Y590T-CP" crlf)
    (retract ?choose)
    (assert (choose lc_arm))
)

(defrule sub-comp-grade2
    ?choose <- (choose subframe)
    (chassis-type front)
    (subframe-type complex-phased)
    (subframe-tensile-strength ?val)
    (test (>= ?val 780))
    (test (<= ?val 920))
=>
    (assert (subframe-steel CR570Y780T-CP))
    ; (printout t "Subframe Steel Grade is CR570Y780T-CP" crlf)
    (retract ?choose)
    (assert (choose lc_arm))
)

(defrule sub-comp-grade3
    ?choose <- (choose subframe)
    (chassis-type front)
    (subframe-type complex-phased)
    (subframe-tensile-strength ?val)
    (test (>= ?val 980))
    (test (<= ?val 1140))
=>
    (assert (subframe-steel CR780Y980T-CP))
    ; (printout t "Subframe Steel Grade is CR780Y980T-CP" crlf)
    (retract ?choose)
    (assert (choose lc_arm))
)

(defrule sub-comp-err
    (declare (salience -100))
    (choose subframe)
    (chassis-type front)
    (subframe-type complex-phased)
    ?wrong_val <- (subframe-tensile-strength ?val)
=>
    (buffer "steel_val_select?subframe?tensile")
    (message "Unable to find steel grade that falls within that range. Please try another value.")
    (retract ?wrong_val)
)

;===============================================================

;==========Steel Grade (Subframe Fortiform Steel)==========
; Rules related to determining subframe steel grade, specifically Complex Phased Steel
; Subframe Part

(defrule sub-fort-values
    (chassis-type front)
    (subframe-type fortiform)

=>
    (buffer "steel_val_select?subframe?tensile")
)

(defrule sub-fort-values2
    (declare (salience 10))
    (chassis-type front)
    (subframe-type fortiform)
    (subframe-tensile-strength ?val)
=>
    (buffer "steel_val_select?subframe?yield")
    (assert (choose subframe))
)

(defrule sub-fort-err
    (declare (salience -100))
    (choose subframe)
    (chassis-type front)
    (subframe-type fortiform)
    ?wrong_val <- (subframe-tensile-strength ?val)
    ?wrong_val2 <- (subframe-yield-stress ?val2)
=>
    (message "Unable to find steel grade that falls within that range. Please restart the program.")
    (retract ?wrong_val)
    (retract ?wrong_val2)
    (buffer "exit")  
)


(defrule sub-fort-grade1
    ?choose <- (choose subframe)
    (chassis-type front)
    (subframe-type fortiform)
    (subframe-tensile-strength ?val)
    (test (>= ?val 980))
    (test (<= ?val 1130))
    (subframe-yield-stress ?val2)
    (test (>= ?val2 700))
    (test (<= ?val2 820))
=>
    (assert (subframe-steel Fortiform980))
    ; (printout t "Subframe Steel Grade is Fortiorm 980" crlf)
    (retract ?choose)
    (assert (choose lc_arm))
)

(defrule sub-fort-grade2
    ?choose <- (choose subframe)
    (chassis-type front)
    (subframe-type fortiform)
    (subframe-tensile-strength ?val)
    (test (>= ?val 1050))
    (test (<= ?val 1180))
    (subframe-yield-stress ?val2)
    (test (>= ?val2 700))
    (test (<= ?val2 820))
=>
    (assert (subframe-steel Fortiform 050))
    ; (printout t "Subframe Steel Grade is Fortiorm 1050" crlf)
    (retract ?choose)
    (assert (choose lc_arm))
)

(defrule sub-fort-grade3
    ?choose <- (choose subframe)
    (chassis-type front)
    (subframe-type fortiform)
    (subframe-tensile-strength ?val)
    (test (>= ?val 1180))
    (test (<= ?val 1330))
    (subframe-yield-stress ?val2)
    (test (>= ?val2 850))
    (test (<= ?val2 1060))
=>
    (assert (subframe-steel Fortiform1180))
    ; (printout t "Subframe Steel Grade is Fortiorm 1180" crlf)
    (retract ?choose)
    (assert (choose lc_arm))
)

;===============================================================

;==========Steel Grade (Lower Control Arm Complex Phased Steel)==========
; Rules related to determining subframe steel grade, specifically Complex Phased Steel
; Lower Control Arm Part

(defrule lc_arm-comp-grade1
    ?choose <- (choose lc_arm)
    (chassis-type front)
    (lc_arm-type complex-phased)
    (lc_arm-tensile-strength ?val)
    (test (>= ?val 680))
    (test (<= ?val 700))
=>
    (assert (lc_arm-steel CR360Y590T-CP))
    (retract ?choose)
    ; (printout t "Lower Control Arm Grade is CR360Y590T-CP" crlf)
)

(defrule lc_arm-comp-grade2
    ?choose <- (choose lc_arm)
    (chassis-type front)
    (lc_arm-type complex-phased)
    (lc_arm-tensile-strength ?val)
    (test (>= ?val 780))
    (test (<= ?val 920))
=>
    (assert (lc_arm-steel CR570Y780T-CP))
    (retract ?choose)
    ; (printout t "Lower Control Arm Grade is CR570Y780T-CP" crlf)
)

(defrule lc_arm-comp-grade3
    ?choose <- (choose lc_arm)
    (chassis-type front)
    (lc_arm-type complex-phased)
    (lc_arm-tensile-strength ?val)
    (test (>= ?val 980))
    (test (<= ?val 1140))
=>
    (assert (lc_arm-steel CR780Y980T-CP))
    (retract ?choose)
    ; (printout t "Lower Control Arm Grade is CR780Y980T-CP" crlf)
)

(defrule lc_arm-comp-err
    (declare (salience -100))
    (choose lc_arm)
    (chassis-type front)
    (lc_arm-type complex-phased)
    ?wrong_val <- (lc_arm-tensile-strength ?val)
=>
    (buffer "steel_val_select?lc_arm?tensile") ; <================ Mesti ikut format mcm ni
    (message "Unable to find steel grade that falls within that range. Please try another value.")
    (retract ?wrong_val)
)

;===============================================================

;==========Steel Grade (Lower Control Arm Ductibor)==========

(defrule lc_arm-duct-values
    (choose lc_arm)
    (chassis-type front)
    (lc_arm-type ductibor)

=>
    (buffer "steel_val_select?lc_arm?tensile-min-duct")
)

(defrule lc_arm-duct-grade1
    ?choose <- (choose lc_arm)
    (chassis-type front)
    (lc_arm-type ductibor)
    (lc_arm-tensile-strength-min 450)
=>
    (assert (lc_arm-steel Ductibor450))
    ; (printout t "Lower Control Arm Grade is Ductibor 450" crlf)
    (retract ?choose)
)

(defrule lc_arm-duct-grade2
    ?choose <- (choose lc_arm)
    (chassis-type front)
    (lc_arm-type ductibor)
    (lc_arm-tensile-strength-min 550)
=>
    (assert (lc_arm-steel Ductibor550))
    ; (printout t "Lower Control Arm Grade is Ductibor 550" crlf)
    (retract ?choose)
)

(defrule lc_arm-duct-grade3
    ?choose <- (choose lc_arm)
    (chassis-type front)
    (lc_arm-type ductibor)
    (lc_arm-tensile-strength-min 1100)
=>
    (assert (lc_arm-steel Ductibor1000))
    ; (printout t "Lower Control Arm Grade is Ductibor 1000" crlf)
    (retract ?choose)
)
;===============================================================

;==========Steel Grade (Lower Control Arm Ubisor)==========
(defrule sub-usib-values
    (choose lc_arm)
    (chassis-type front)
    (lc_arm-type usibor)

=>
    (buffer "steel_val_select?lc_arm?tensile-min-usib")
)


(defrule lc_arm-usib-grade1
    ?choose <- (choose lc_arm)
    (chassis-type front)
    (lc_arm-type usibor)
    (lc_arm-tensile-strength-min 1400)
=>
    (assert (lc_arm-steel Usibor1500))
    ; (printout t "Lower Control Arm Grade is Usibor 1500" crlf)
    (retract ?choose)
)

(defrule lc_arm-usib-grade2
    ?choose <- (choose lc_arm)
    (chassis-type front)
    (lc_arm-type usibor)
    (lc_arm-tensile-strength-min 1800)
=>
    (assert (lc_arm-steel Usibor2000))
    ; (printout t "Lower Control Arm Grade is Usibor2000" crlf)
    (retract ?choose)
)

;===============================================================

;==========Steel Grade (Rear Chassis)==========
; Rules related to determining rear chassis steel grade

(defrule rear-crad-comp-values
    (chassis-type rear)
    (rearcradle-type complex-phased)

=>
    (buffer "steel_val_select?rearcradle?tensile") ;
    (assert (choose rearcradle))
)

(defrule trail-arm-hsla-values
    ?choose <- (choose trail-arm)
    (chassis-type rear)
    (trailingarm-type hsla)

=>
    (buffer "steel_val_select?trail-arm?tensile") ; 
)

(defrule rear-crad-fort-values
    (chassis-type rear)
    (rearcradle-type fortiform)

=>
    (buffer "steel_val_select?rearcradle?tensile")
    
)

(defrule rear-crad-fort-values2
    (declare (salience 10))
    (chassis-type rear)
    (rearcradle-type fortiform)
    (rearcradle-tensile-strength ?val)

=>

    (buffer "steel_val_select?rearcradle?yield")
    (assert (choose rearcradle))
)

;==========Steel Grade (Rear Cradle Complex Phase)==========
; Rules related to determining rear cradle steel grade

(defrule rear-crad-comp-grade1
    ?choose <- (choose rearcradle)
    (chassis-type rear)
    (rearcradle-type complex-phased)
    (rearcradle-tensile-strength ?val)
    (test (>= ?val 600))
    (test (<= ?val 700))
=>
    (assert (rear-cradle-steel CR360Y590T-CP))
    ; (printout t "Rear Cradle Steel Grade is CR360Y590T-CP" crlf)
    (retract ?choose)
    (assert (choose trail-arm))
)

(defrule rear-crad-comp-grade2
    ?choose <- (choose rearcradle)
    (chassis-type rear)
    (rearcradle-type complex-phased)
    (rearcradle-tensile-strength ?val)
    (test (>= ?val 780))
    (test (<= ?val 920))
=>
    (assert (rear-cradle-steel CR570Y780T-CP))
    ; (printout t "Rear Cradle Steel Grade is CR570Y780T-CP" crlf)
    (retract ?choose)
    (assert (choose trail-arm))
)

(defrule rear-crad-comp-grade3
    ?choose <- (choose rearcradle)
    (chassis-type rear)
    (rearcradle-type complex-phased)
    (rearcradle-tensile-strength ?val)
    (test (>= ?val 980))
    (test (<= ?val 1140))
=>
    (assert (rear-cradle-steel CR780Y980T-CP))
    ; (printout t "Rear Cradle Steel Grade isCR780Y980T-CP" crlf)
    (retract ?choose)
    (assert (choose trail-arm))
)

(defrule rear-crad-comp-err
    (declare (salience -100))
    (choose rearcradle)
    (chassis-type rear)
    (rearcradle-type complex-phased)
    ?wrong_val <- (rearcradle-tensile-strength ?val)
=>
    (buffer "steel_val_select?rearcradle?tensile") ; <================ Mesti ikut format mcm ni
    (message "Unable to find steel grade that falls within that range. Please try another value.")
    (retract ?wrong_val)
)





;==========Steel Grade (Rear Cradle Fortiform)==========

(defrule rear-crad-fort-grade1
    ?choose <- (choose rearcradle)
    (chassis-type rear)
    (rearcradle-type fortiform)
    (rearcradle-tensile-strength ?val)
    (test (>= ?val 980))
    (test (<= ?val 1180))
    (rearcradle-yield-stress ?val2)
    (test (>= ?val2 600))
    (test (<= ?val2 750))
=>
    (assert (rear-cradle-steel Fortiform980))
    ; (printout t "Rear Cradle Steel Grade is Fortiform 980" crlf)
    (retract ?choose)
    (assert (choose trail-arm))
)

(defrule rear-crad-fort-grade2
    ?choose <- (choose rearcradle)
    (chassis-type rear)
    (rearcradle-type fortiform)
    (rearcradle-tensile-strength ?val)
    (test (>= ?val 1050))
    (test (<= ?val 1180))
    (rearcradle-yield-stress ?val2)
    (test (>= ?val2 700))
    (test (<= ?val2 820))
=>
    (assert (rear-cradle-steel Fortiform1050))
    ; (printout t "Rear Cradle Steel Grade is Fortiform 1050" crlf)
    (retract ?choose)
    (assert (choose trail-arm))
)

(defrule rear-crad-fort-grade3
    ?choose <- (choose rearcradle)
    (chassis-type rear)
    (rearcradle-type fortiform)
    (rearcradle-tensile-strength ?val)
    (test (>= ?val 1180))
    (test (<= ?val 1330))
    (rearcradle-yield-stress ?val2)
    (test (>= ?val2 850))
    (test (<= ?val2 1060))
=>
    (assert (rear-cradle-steel Fortiform1180))
    ; (printout t "Rear Cradle Steel Grade is Fortiform 1180" crlf)
    (retract ?choose)
    (assert (choose trail-arm))
)

(defrule rear-crad-fort-err
    (declare (salience -100))
    (choose rearcradle)
    (chassis-type rear)
    (rearcradle-type fortiform)
    ?wrong_val1 <- (rearcradle-tensile-strength ?val)
    ?wrong_val2 <- (rearcradle-yield-stress ?val2)
=>
    (message "Unable to find steel grade that falls within that range. Please restart the program.")
    (retract ?wrong_val1)
    (retract ?wrong_val2)
    (buffer "exit")
)

;==========Steel Grade (Trailing Arm)==========
; Rules related to determining Trailing arm steel grade

(defrule trail-arm-hsla-grade1
    ?choose <- (choose trail-arm)
    (chassis-type rear)
    (trailingarm-type hsla)
    (trailingarm-tensile-strength ?val)
    (test (>= ?val 310))
    (test (<= ?val 410))
=>
    (assert (trailing-arm-steel CR210LA))
    ; (printout t "Trailing Arm Steel is CR210LA" crlf)
    (retract ?choose)
)

(defrule trail-arm-hsla-grade2
    ?choose <- (choose trail-arm)
    (chassis-type rear)
    (trailingarm-type hsla)
    (trailingarm-tensile-strength ?val)
    (test (>= ?val 410))
    (test (<= ?val 530))
=>
    (assert (trailing-arm-steel CR340LA))
    ; (printout t "Trailing Arm Steel is CR340LA" crlf)
    (retract ?choose)
)

(defrule trail-arm-hsla-grade3
    ?choose <- (choose trail-arm)
    (chassis-type rear)
    (trailingarm-type hsla)
    (trailingarm-tensile-strength ?val)
    (test (>= ?val 530))
    (test (<= ?val 680))
=>
    (assert (trailing-arm-steel CR460LA))
    ; (printout t "Trailing Arm Steel is CR460LA" crlf)
    (retract ?choose)
)

(defrule trail-arm-hsla-err
    (declare (salience -100))
    (choose trail-arm)
    (chassis-type rear)
    (trailingarm-type hsla)
    ?wrong_val <- (trailingarm-tensile-strength ?val)
=>
    (buffer "steel_val_select?trail-arm?tensile")
    (message "Unable to find steel grade that falls within that range. Please try another value.")
    (retract ?wrong_val)
)

;==========Program Termination Rules==========
; This rule check if both parts steel grade has been determined
(defrule front-steel-complete
    (declare (salience 100))
    (subframe-steel ?subframe-steel-grade)
    (lc_arm-steel ?lc_arm-steel-grade)
=>
    (message (str-cat "Steel Grade Selected ----> " "Subframe: " ?subframe-steel-grade "   Lower Control Arm: " ?lc_arm-steel-grade))
    (buffer "exit")    
)

(defrule rear-steel-complete
    (declare (salience 100))
    (rear-cradle-steel ?rear-cradle-steel-grade)
    (trailing-arm-steel ?trailing-arm-steel-grade)
=>
    (message (str-cat "Steel Grade Selected ----> " "Rear Cradle: " ?rear-cradle-steel-grade "   Trailing Arm: " ?trailing-arm-steel-grade))
    (buffer "exit")    
)