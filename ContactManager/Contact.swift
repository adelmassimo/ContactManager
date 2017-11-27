//
//  Contact.swift
//  ContactManager
//
//  Created by adel on 21/11/2017.
//  Copyright © 2017 Adel Ramadan. All rights reserved.
//
/* improved data persistance by following this guidelines:
developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/PersistData.html
 */
import Foundation
import os.log

class Contact: NSObject, NSCoding {

    
    var name: String!
    var lastName: String!
    var phone: String!
    var email: String!
    var notes: String!
    //the use of this index shortly is for remove and re-insert contacts in the same place, non depending by filtering
    var helperIndex: Int? = nil
    var tags = [String]()

    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("contacts")
    
    override init() {
        name = "Andrew"
        lastName = "Bagdanov"
        phone = "666"
        email = "andrew.bagdanov@unifi.it"
        notes = ""
    }
    init(name: String, lastname: String, phone: String, email: String, notes: String, tags: [String]){
        self.name = name
        self.lastName = lastname
        self.phone = phone
        self.email = email
        self.notes = notes
        self.tags = tags
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(notes, forKey: "notes")
        aCoder.encode(tags, forKey: "tags")
        print(tags)
    }
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: "name") as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cast.
        let phone = aDecoder.decodeObject(forKey: "phone") as? String
        let email = aDecoder.decodeObject(forKey: "email") as? String
        let notes = aDecoder.decodeObject(forKey: "notes") as? String
        let lastName = aDecoder.decodeObject(forKey: "lastName") as? String
        let tags = aDecoder.decodeObject(forKey: "tags") as? [String]
        // Must call designated initializer.
        self.init(name: name, lastname: lastName!, phone: phone!, email: email!, notes: notes!, tags: tags!)
        
    }
    
    
}
