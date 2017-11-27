//
//  AddContactViewController.swift
//  ContactManager
//
//  Created by adel on 21/11/2017.
//  Copyright © 2017 Adel Ramadan. All rights reserved.
//

import Cocoa

class AddContactViewController: NSViewController {
    
    @IBOutlet var nameLabel:NSTextField?
    @IBOutlet var lastNameLabel:NSTextField?
    @IBOutlet var phoneLabel:NSTextField?
    @IBOutlet var emailLabel:NSTextField?
    @IBOutlet var notesLabel:NSTextField?
    
    var backView: ViewController!
    var contactBook = ContactBook()
    @IBOutlet var tag1: NSButton!
    @IBOutlet var tag2: NSButton!
    var tags = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
//        contactBook.contacts.append( Contact() )
//        ContactBook.saveContactBook(contactBook: contactBook)
//        backView.contactsTable?.reloadData()
    }
    
    @IBAction func myfunc(sender: AnyObject) {
        let newContact = Contact(
            name: (nameLabel?.stringValue)!,
            lastname: (lastNameLabel?.stringValue)!,
            phone: (phoneLabel?.stringValue)!,
            email: (emailLabel?.stringValue)!,
            notes: (notesLabel?.stringValue)!,
            tags: tags)
        contactBook.add(contact: newContact )
        contactBook.sortByName(by: backView.lastSort)
        contactBook.saveCB()
        backView.contactsTable?.reloadData()
        self.dismissViewController(self)
    }
    @IBAction func toggleTags(sender: NSButton){
        let tag = sender.identifier?._rawValue as! String
        if sender.state.rawValue == 1{
            tags.append(tag)
        }else{
            tags.remove(at: tags.index(of: tag)!)
        }
        
        
    }
}
