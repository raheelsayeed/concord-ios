//
//  ParseReports.swift
//  Concord
//
//  Created by Alex Leighton on 11/6/20.
//  Copyright © 2020 Medical Gear. All rights reserved.
//

import Foundation
import SMART
import ResearchKit
import SMARTMarkers



func getHighestObservation(records: Optional<Array<Report>>, obsCode: String)-> Float? {
    //returns maximun float value in records matching specified fhir observation code
    var r_val: Float? = nil
    records?.forEach{
        //Double check string codes here - make sure to catch
        if $0.rp_resourceType == "Observation" && $0.rp_code?.code?.string == obsCode{
            // If observation code matches update reading
            let obs: Float? = ($0.rp_observation as NSString?)?.floatValue
            if r_val == nil {r_val = obs}
            else if obs == nil {}
            else {r_val = max(r_val!, obs!)}
            }}; return r_val
}

func checkDiabetesMellitus(records: Optional<Array<Report>>) -> Bool {
    // Returns true if patient has diabetes
    var r_val = false
    records?.forEach{
        //Code might not be accurate so check substring
        if $0.rp_resourceType == "Condition" && ($0.rp_code?.code?.string == "4307007" || (($0.rp_title?.lowercased().contains("diabetes")) != nil)){
            r_val = true
        }}; return r_val
}

func checkHighCholesterol(records: Optional<Array<Report>>, threshold: Float = 190.0)-> Bool {
    //Returns true if LDL levels above threshold
    var r_val: Bool = false
    let highestCholesterolObservation = getHighestObservation(records: records, obsCode: "2089-1")
    if highestCholesterolObservation ?? 130.0 >= threshold {
        r_val = true
    }; return r_val
}

func checkHighGlucoseLevels(records: Optional<Array<Report>>, threshold: Float = 120.0)-> Bool {
    //Returns true if Glucose levels above threshold
    var r_val: Bool = false
    let highestGlucoseObservation = getHighestObservation(records: records, obsCode: "2339-0")
    if highestGlucoseObservation ?? 100.0 >= threshold {
        r_val = true
    }; return r_val
}


func checkPerscribedStatin(records: Optional<Array<Report>>) -> Bool{
    //TODO is "lipid lowering drug" code really ok substitute for statins
    var r_val: Bool = false
    records?.forEach{
        //Code might not be accurate so check substring
        if $0.rp_resourceType == "MedicationRequest" && ($0.rp_code?.code?.string == "57952007"){
            r_val = true}
        }
    return r_val
    
}



