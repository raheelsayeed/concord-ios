;  ACC_AHA_Simplified.clp
;  Concord
;
;  Created by Alex Leighton on 11/7/20.
;  Copyright © 2020 Medical Gear. All rights reserved.


(defmodule MAIN (export ?ALL))

(deftemplate subject
    (slot ID
        (type STRING)
        (default "patient 1")
    )
    (slot LDL
        (type FLOAT)
        (default 120.0)
    )
    (slot diabetes-mellitus
        (default no)
    )
    (slot BMI
        (type FLOAT)
        (default 22.0)
    )
    (slot age
        (type INTEGER)
        (default 45)
    )
    (slot on-statin
        (default no)
    )
    (slot family-history::hypercholesterolemia
        (default no)
    )
    (slot family-history::premature-ASCVD
        (default no)
    )
    (slot family-history::LDL-over-160
        (default no)
    )
)

(defrule recomend-high-intensity-statin
    (subject (LDL ?LDL))
    (test(> ?LDL 190.0))
    =>
    (printout t "Recomend high-intenstiy Statin" crlf))

(defrule recomend-moderate-intensity-statin
    (subject
        (age ?age)
        (diabetes-mellitus ?diabetes-mellitus)
        (family-history::hypercholesterolemia ?family-history::hypercholesterolemia)
    )
    (test(or
        (and (>= ?age 40)(<= ?age 75)(eq diabetes-mellitus yes))
        (and (?age <= 19)(eq ?family-history::hypercholesterolemia yes))
    ))
    =>
    (printout t "Recomend moderate-intenstiy Statin" crlf))

(defrule consider-high-intensity-statin
    (subject
        (age ?age)
        (diabetes-mellitus yes)
        (on-statin yes)
    )
    (test(or
        (and (>= ?age 40) (<= ?age 75))
    ))
    =>
    (printout t "Risk assesment to consider high-intenstiy Statin" crlf))
(defrule risk-discussion
    (subject
        (age ?age)
        (LDL ?LDL)
        (on-statin no)
        (diabetes-mellitus no)
    )
    (test
        (or (> ?age 75)
        (and (<= ?age 75) (> ?age 40) (>= ?LDL 70.0) (< ?LDL 190.0)))
    )
    =>
    (printout t "Discuss risks" crlf))
(defrule consider-moderate-intensity-statin
    (subject
        (age ?age)
        (LDL ?LDL)
        (family-history::premature-ASCVD ?family-history::premature-ASCVD)
    )
    (test
        (and (>= ?age 20) (<= ?age 39) (eq ?family-history::premature-ASCVD yes) (>= ?LDL 160))
    )
    =>
    (printout t "Consider moderate intensity statin" crlf))



