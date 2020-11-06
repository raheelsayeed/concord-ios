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



func checkGlucoseLevels(records: Optional<Array<Report>>, threshold: Float = 120.0)-> Bool {
    //Returns true if Glucose levels above threshold
    var r_val: Bool = false
    records?.forEach{
        //Double check string codes here - make sure to catch
        if $0.rp_resourceType == "Observation" && $0.rp_code?.code?.string == "2339-0"{
            // If blood glucose greater than 130 -> DIABETES_MELLITUS= true
            if ($0.rp_observation as NSString?)?.floatValue ?? 100.0 >= threshold {
                r_val = true
            }}}; return r_val
}

func checkHighCholesterol(records: Optional<Array<Report>>, threshold: Float = 190.0)-> Bool {
    var r_val: Bool = false
    records?.forEach{
        //Check FHIR String code
        if $0.rp_resourceType == "Observation" && $0.rp_code?.code?.string == "2089-1" {
            // If LDL greater than 190 -> HIGH_COL = true
            if ($0.rp_observation as NSString?)?.floatValue ?? 130.0 >= 190.0 {
                r_val = true
            }}}; return r_val
}

func checkDiabetesMellitus(records: Optional<Array<Report>>) -> Bool {
    var r_val = false
    records?.forEach{
        //Code might not be accurate so check substring
        if $0.rp_resourceType == "Condition" && ($0.rp_code?.code?.string == "4307007" || (($0.rp_title?.lowercased().contains("diabetes")) != nil)){
            r_val = true
        }}; return r_val
}




