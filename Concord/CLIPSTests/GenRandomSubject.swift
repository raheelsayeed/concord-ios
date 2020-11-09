//
//  GenRandomSubject.swift
//  Concord
//
//  Created by Alex Leighton on 11/9/20.
//  Copyright © 2020 Medical Gear. All rights reserved.
//

import Foundation

public class RandomCLIPSSubject: CLIPSSubject{
    override init(ID: String?, LDL: Float?, age: Int?, diabetesMellitus: Bool?, bloodGlucose: Float?) {
        //LDL
        let LDLLow: Float = 30.0
        let LDLHigh: Float = 300.0
        //age
        let ageLow: Int = 1
        let ageHigh: Int = 120
        
        //Random vals
        let r_LDL = Float.random(in: LDLLow..<LDLHigh)
        let r_age = Int.random(in: ageLow...ageHigh)
        let r_diabetes = Bool.random()
        let r_ID = ID //doesn't matter
        //Blood glucose doesn't matter
        
        
        super.init(ID: r_ID, LDL: r_LDL, age: r_age, diabetesMellitus: r_diabetes, bloodGlucose: bloodGlucose)
    }
}
