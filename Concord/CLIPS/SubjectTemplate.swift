//
//  SubjectTemplate.swift
//  Concord
//
//  Created by Alex Leighton on 11/8/20.
//  Copyright © 2020 Medical Gear. All rights reserved.
//

import Foundation


public class CLIPSSubject {
    // Add relavent info here
    var ID: String?
    var LDL: Float?
    var age: Int?
    var diabetesMellitus: Bool?
    var bloodGlucose: Float?
    
    init(ID: String?, LDL: Float?, age: Int?, diabetesMellitus: Bool?, bloodGlucose: Float?) {
        self.ID = ID
        self.LDL = LDL
        self.age = age
        self.diabetesMellitus = diabetesMellitus
        self.bloodGlucose = bloodGlucose
    }
    
    
    public func toCLIPSSubjectDefinition() -> String{
        //Parse patient to CLIPS subject template
        //Add future params
        var r_string: String = "(subject"
        if self.ID != nil {r_string += " (ID " + self.ID! + " ) "}
        if self.LDL != nil {r_string += " (LDL " + self.LDL!.description + " ) "}
        if self.age != nil {r_string += " (age " + self.age!.description + " ) "}
        if self.diabetesMellitus != nil {if self.diabetesMellitus!{ r_string += " ( diabetes-mellitus yes ) "}} // default value is no
        
        r_string += ")"
        return r_string
    }
}
