//
//  Allergies+Report.swift
//  Concord
//
//  Created by Alex Leighton on 11/10/20.
//  Copyright © 2020 Medical Gear. All rights reserved.
//

import SMARTMarkers
import Foundation
import SMART

extension AllergyIntolerance : Report {
    
    public var rp_code: Coding? {
        return code?.coding?.first
    }
    
    public var rp_resourceType: String {
        return "Allergy"
    }
    
    public var rp_identifier: String? {
        return id?.string
    }
    
    public var rp_title: String? {
        
        if let code = code {
            return code.text?.string ?? rp_code!.display?.string ?? "Code: \(rp_code!.code!.string)"
        }
        
        return "Allergy: #\(self.id?.string ?? "-")"
    }
    
    public var rp_description: String? {
        
        let meta = code?.coding?.first?.display ?? code?.coding?.first?.code ?? ""
        return "Allergy [\(meta)]"
    }
    
    public var rp_date: Date {
        return onsetDateTime?.nsDate ?? Date()
    }
    
    public var rp_observation: String? {
        return nil
    }
}
