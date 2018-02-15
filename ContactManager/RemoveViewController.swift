//
//  removeViewController.swift
//  ContactManager
//
//  Created by adel on 22/11/2017.
//  Copyright © 2017 Adel Ramadan. All rights reserved.
//

import Cocoa

class RemoveViewController: NSViewController {

    @IBOutlet var removeButton:NSButton?
    @IBOutlet var undoButton:NSButton?
    @IBOutlet var labelName: NSTextField?
    @IBOutlet var labelPhone: NSTextField?
    @IBOutlet var labelEmail: NSTextField?
    @IBOutlet var labelNotes: NSTextField?
    @IBOutlet var tagsLabel: NSTextField!
    var backView: ViewController!
    var contactBook = ContactBook()
    var contactToDelete = Contact()
    var contactIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        contactToDelete = contactBook.contacts[contactIndex!]
        labelName?.stringValue = contactToDelete.name + " " + contactToDelete.lastName
        labelPhone?.stringValue = contactToDelete.phone
        labelEmail?.stringValue = contactToDelete.email
        labelNotes?.stringValue = contactToDelete.notes
        tagsLabel?.stringValue = contactToDelete.tags.description
    }
    override func viewWillAppear(){
        //Set focus on the remove button
        self.view.window?.makeFirstResponder(removeButton)
    }
    @IBAction func removeContact(sender: NSButton) {
        contactBook.contacts.remove(at: contactIndex!)
        contactBook.saveCB()
        backView.contactsTable?.reloadData()
        backView.lastRowSelected = -1
        removeButton?.isEnabled = false
        undoButton?.isHidden = false
        
        backView.contacViewTags.stringValue = ""
        backView.contacViewName.stringValue = ""
        backView.contacViewLastname.stringValue = ""
        backView.contacViewEmail.stringValue = ""
        backView.contacViewPhone.stringValue = ""
        backView.contacViewNotes.stringValue = ""
    }
    @IBAction func undoRemoveContact(sender: NSButton) {
        contactBook.contacts.insert(contactToDelete, at: contactIndex!)
        contactBook.saveCB()
        backView.contactsTable?.reloadData()
        removeButton?.isEnabled = false
        undoButton?.isEnabled = false
    }
}
