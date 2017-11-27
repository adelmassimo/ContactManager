//
//  ViewController.swift
//  ContactManager
//
//  Created by adel on 21/11/2017.
//  Copyright © 2017 Adel Ramadan. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet var addContactButton: NSButton?
    @IBOutlet var contactsTable: NSTableView?
    @IBOutlet var searchField: NSSearchField?
    @IBOutlet var removeButton: NSButton?
    
    @IBOutlet var contacViewName: NSTextField!
    @IBOutlet var contacViewLastname: NSTextField!
    @IBOutlet var contacViewPhone: NSTextField!
    @IBOutlet var contacViewEmail: NSTextField!
    @IBOutlet var contacViewNotes: NSTextField!
    @IBOutlet var contacViewTags: NSTextField!
    
    let sortings = ["name-sort", "lastname-sort", "phone-sort", "email-sort"]
    var lastSort:String = ""
    var contactBook = ContactBook()
    var lastRowSelected: Int = -1
    var updatedTags = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        contactBook.loadCB()
        contactsTable?.delegate = self
        contactsTable?.dataSource = self
//        let adel = Contact(name: "Adel", lastname: "Ramadan", phone: "3272911709", email: "adel.massimo.ramadan@gmial.com", notes: "lorem ipsus est dolore dolorem dio moi aoisnao oin  ad a as as asiniansc", tags: ["A"])
//        contactBook.add(contact: adel)
//        contactBook.saveCB()
        //contactsTable?.reloadData()
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    // Prepare for segue and set parameter to pass
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if(segue.identifier!.rawValue == "addContactSegue"){
            let next = segue.destinationController as! AddContactViewController
            next.contactBook = contactBook
            next.backView = self
        }
        if(segue.identifier!.rawValue == "removeContactSegue"){
            let next = segue.destinationController as! RemoveViewController
            next.contactBook = contactBook
            next.backView = self
            next.contactToDelete = contactBook.contactsToShow()[lastRowSelected]
            if next.contactToDelete.helperIndex == nil{
               next.contactToDelete.helperIndex = (contactsTable?.selectedRow)
            }
        }
    }
    
    //apply filter to shown datas
    @IBAction func filterContent(sender: AnyObject){
        print(searchField!.stringValue.lowercased() as String)
        contactBook.filter = searchField!.stringValue.lowercased() as String
        contactsTable?.reloadData()
    }
    
    //Enable or disable remove, edit and tags buttons
    @IBAction func zoomContact(sender: NSTableView){
        lastRowSelected = sender.selectedRow
        if lastRowSelected != -1{
            removeButton?.isEnabled = true
            contacViewName.stringValue = contactBook.contactsToShow()[lastRowSelected].name
            contacViewLastname.stringValue = contactBook.contactsToShow()[lastRowSelected].lastName
            contacViewEmail.stringValue = contactBook.contactsToShow()[lastRowSelected].email
            contacViewPhone.stringValue = contactBook.contactsToShow()[lastRowSelected].phone
            contacViewNotes.stringValue = contactBook.contactsToShow()[lastRowSelected].notes
            contacViewTags.stringValue = contactBook.contactsToShow()[lastRowSelected].tags.description
        }
        if sender.clickedRow == -1 && sender.clickedColumn != -1{
            sortList(by: sortings[(contactsTable?.clickedColumn)!])
            removeButton?.isEnabled = false
        }
        
    }
    @IBAction func updateContact(sender: AnyObject){
        if lastRowSelected != -1{
            contactBook.contacts[lastRowSelected].name = contacViewName.stringValue
            contactBook.contacts[lastRowSelected].lastName = contacViewLastname.stringValue
            contactBook.contacts[lastRowSelected].email = contacViewEmail.stringValue
            contactBook.contacts[lastRowSelected].phone = contacViewPhone.stringValue
            contactBook.contacts[lastRowSelected].notes = contacViewNotes.stringValue
            
            contactsTable?.reloadData()
        }
    }
//    @IBAction func updateContactTags(sender: NSButton){
//        let tag = sender.identifier?._rawValue as! String
//        if sender.state.rawValue == 1{
//            updatedTags.append(tag)
//        }else{
//            updatedTags.remove(at: updatedTags.index(of: tag)!)
//        }
//        contactBook.contacts[lastRowSelected].tags = updatedTags
//        contactBook.saveCB()
//    }
//
    //Require a sort for the objects in table
    func sortList(by: String){
        var sorter = by
        print(sorter)
        if sorter == lastSort{
            sorter = sorter + "-reverse"
            lastSort = ""
        }else{
            lastSort = sorter
        }
        contactBook.sortByName(by: sorter)
        contactsTable?.reloadData()
    }
    
    //toggle Tags in the filter
    @IBAction func toggleTags(sender: NSButton){
        let tag = sender.identifier?._rawValue as! String
        if sender.state.rawValue == 1{
            contactBook.tagsToFilter.append(tag)
        }else{
            contactBook.tagsToFilter.remove(at: contactBook.tagsToFilter.index(of: tag)!)
        }
        contactsTable?.reloadData()
    }
        
}

//______________________________________________________
extension ViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return contactBook.contactsToShow().count
    }
    
}
extension ViewController: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let nameCell = "nameCell"
        static let lastNameCell = "lastNameCell"
        static let phoneCell = "phoneCell"
        static let emailCell = "emailCell"
        static let tagCell = "tagCell"
    }
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var text: String = ""
        var cellIdentifier: String = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        
        // 1
//        if contactBook.contacts.count < row {
//            return nil
//        }
        let item = contactBook.contactsToShow()[row]
        // 2
        switch (tableColumn?.identifier)!.rawValue {
        case CellIdentifiers.nameCell:
            text = item.name
            cellIdentifier = CellIdentifiers.nameCell
        case CellIdentifiers.lastNameCell:
            text = item.lastName
            cellIdentifier = CellIdentifiers.lastNameCell
        case CellIdentifiers.phoneCell:
            text = item.phone
            cellIdentifier = CellIdentifiers.phoneCell
        case CellIdentifiers.emailCell:
            text = item.email
            cellIdentifier = CellIdentifiers.emailCell
        case CellIdentifiers.tagCell:
            text = "item.tag!"
            cellIdentifier = CellIdentifiers.tagCell
        default:
            print("switch must be exaustif")
        }

        
        // 3
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView
        cell?.textField?.stringValue = text
        
        return cell
    }
    
}
