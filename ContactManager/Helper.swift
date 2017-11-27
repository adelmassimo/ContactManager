//
//  Helper.swift
//  ContactManager
//
//  Created by adel on 24/11/2017.
//  Copyright © 2017 Adel Ramadan. All rights reserved.
//

import Cocoa

class Helper: NSObject {
    
    static func existsIntersection(ArrayOne: [String], ArrayTwo: [String]) -> Bool {
        for animal in ArrayOne {
            if ArrayTwo.contains(animal) {
                return true
            }
        }
        return false
    }

}
