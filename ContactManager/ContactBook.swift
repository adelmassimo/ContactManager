//
//  ContactBook.swift
//  ContactManager
//
//  Created by adel on 21/11/2017.
//  Copyright © 2017 Adel Ramadan. All rights reserved.
//
import os.log
import Foundation

class ContactBook: NSObject {
    var filter:String = ""
    var tagsToFilter = [String]()
    var contacts = [Contact]()
    
    override init() {}
    
    func add(contact: Contact){
        contacts.append(contact)
    }
    func saveCB(){
        saveContacts(contactBook: self)
    }
    func loadCB(){
        contacts = loadContacts()!
    }
    func sortCB(by: String){

        switch by {
        case "email-sort":
            contacts.sort { (contact1, contact2) -> Bool in
                return contact1.email.lowercased() < contact2.email.lowercased()
            }
        case "phone-sort":
            contacts.sort { (contact1, contact2) -> Bool in
                return contact1.phone.lowercased() < contact2.phone.lowercased()
            }
        case "lastname-sort":
            contacts.sort { (contact1, contact2) -> Bool in
                return contact1.lastName.lowercased() < contact2.lastName.lowercased()
            }
        case "email-sort-reverse":
            contacts.sort { (contact1, contact2) -> Bool in
                return contact1.email.lowercased() > contact2.email.lowercased()
            }
        case "phone-sort-reverse":
            contacts.sort { (contact1, contact2) -> Bool in
                return contact1.phone.lowercased() > contact2.phone.lowercased()
            }
        case "name-sort-reverse":
            contacts.sort { (contact1, contact2) -> Bool in
                return contact1.name.lowercased() > contact2.name.lowercased()
            }
        case "lastname-sort-reverse":
            contacts.sort { (contact1, contact2) -> Bool in
                return contact1.lastName.lowercased() > contact2.lastName.lowercased()
            }
        default:
            contacts.sort { (contact1, contact2) -> Bool in
                return contact1.name.lowercased() < contact2.name.lowercased()
            }
        }
        
    }
    private func contactsFiltered() -> [Contact] {
        var contactsShow = [Contact]()
        if filter == "" {
            return contacts
        }else{
            for i in 0..<contacts.count{
                if contacts[i].name.lowercased().range(of:filter) != nil ||
                    contacts[i].lastName.lowercased().range(of:filter) != nil ||
                    contacts[i].phone.lowercased().range(of:filter) != nil ||
                    contacts[i].email.lowercased().range(of:filter) != nil{
                    contactsShow.append(contacts[i])
                    contactsShow.last?.helperIndex = i
                }
            }
        }
        return contactsShow
    }

    func contactsToShow() -> [Contact] {
        let contactsFilteredBySearch = self.contactsFiltered()
        var contactsShowable = [Contact]()
        if tagsToFilter != [] {
            for i in 0..<contactsFilteredBySearch.count{
                if Helper.existsIntersection(ArrayOne: tagsToFilter, ArrayTwo: contactsFilteredBySearch[i].tags) {
                    contactsShowable.append(contactsFilteredBySearch[i])
                    contactsShowable.last?.helperIndex = contactsFilteredBySearch[i].helperIndex
                }
            }
            return contactsShowable
        }
        return contactsFilteredBySearch
    }
    
    //MARK: NSCoding
    private func saveContacts(contactBook: ContactBook) {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(contactBook.contacts, toFile: Contact.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Contacts successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save contacts...", log: OSLog.default, type: .error)
        }
    }
    private func loadContacts() -> [Contact]?  {
        guard let contacts = NSKeyedUnarchiver.unarchiveObject(withFile: Contact.ArchiveURL.path) as? [Contact] else{
            return [Contact]()
        }
        return contacts
    }
}
