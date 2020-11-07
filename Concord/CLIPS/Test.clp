;  File.clp
;  Concord
;
;  Created by Alex Leighton on 11/7/20.
;  Copyright © 2020 Medical Gear. All rights reserved.
;  Copied from http://clipsrules.sourceforge.net/documentation/v630/ug.pdf

(defrule ideal-duck-bachelor
     (bill big ?name)
     (feet wide ?name)
    =>
     (printout t "The ideal duck is "
     ?name crlf)
     (assert (move-to-front ?name)))


(defrule move-to-front
    ?move-to-front <- (move-to-front ?who)
    ?old-list <- (list $?front ?who $?rear)
    =>
    (retract ?move-to-front ?old-list)
    (assert (list ?who ?front ?rear))
    (assert (change-list yes)))
(defrule print-list
    ?change-list <- (change-list yes)
    (list $?list)
    =>
    (retract ?change-list)
    (printout t "List is : " ?list crlf))
(deffacts duck-bachelor-list
    (list Dorky Dinky Dicky))

(deffacts duck-assets
    (bill big Dicky)
    (bill big Dorky)
    (bill little Dinky)
    (feet wide Dicky)
    (feet narrow Dorky)
    (feet narrow Dinky))
