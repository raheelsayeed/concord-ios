//
//  Condition+Report.swift
//  SMARTMarkers
//
//  Created by Alex Leighton on 11/6/20.
//  Copyright © 2020 Boston Children's Hospital. All rights reserved.
//

import SMARTMarkers
import Foundation
import SMART

extension Condition : Report {
    
    public var rp_code: Coding? {
        return code?.coding?.first
    }
    
    public var rp_resourceType: String {
        return "Condition"
    }
    
    public var rp_identifier: String? {
        return id?.string
    }
    
    public var rp_title: String? {
        
        if let code = code {
            return code.text?.string ?? rp_code!.display?.string ?? "Code: \(rp_code!.code!.string)"
        }
        
        return "Condition: #\(self.id?.string ?? "-")"
    }
    
    public var rp_description: String? {
        
        let meta = category?.first?.coding?.first?.display ?? category?.first?.coding?.first?.code ?? ""
        return "Condition [\(meta)]"
    }
    
    public var rp_date: Date {
        return onsetDateTime?.nsDate ?? Date()
    }
    
    public var rp_observation: String? {
        return nil
    }
}
