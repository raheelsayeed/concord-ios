//
//  Medication+Report.swift
//  SMARTMarkers
//
//  Created by Alex Leighton on 11/5/20.
//  Copyright © 2020 Boston Children's Hospital. All rights reserved.
//

import Foundation
import SMART

extension MedicationRequest : Report {
    
    public var rp_code: Coding? {
        return medicationCodeableConcept?.coding?.first
    }
    
    public var rp_resourceType: String {
        return "MedicationRequest"
    }
    
    public var rp_identifier: String? {
        return id?.string
    }
    
    public var rp_title: String? {
        
        if let medicationCodeableConcept = medicationCodeableConcept {
            return medicationCodeableConcept.text?.string ?? rp_code!.display?.string ?? "Code: \(rp_code!.code!.string)"
        }
        
        return "Observation: #\(self.id?.string ?? "-")"
    }
    
    public var rp_description: String? {
        
        let meta = category?.first?.coding?.first?.display ?? category?.first?.coding?.first?.code ?? ""
        return "Observation [\(meta)]"
    }
    
    public var rp_date: Date {
        return authoredOn?.nsDate ?? Date()
    }
    
    public var rp_observation: String? {
        return dosageInstruction?[0].maxDosePerAdministration?.unit?.string
    }
}
