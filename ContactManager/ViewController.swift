//
//  ViewController.swift
//  ContactManager
//
//  Created by adel on 21/11/2017.
//  Copyright © 2017 Adel Ramadan. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
//View elements:
    //Left side elements
    @IBOutlet var addContactButton: NSButton?
    @IBOutlet var contactsTable: NSTableView?
    @IBOutlet var removeButton: NSButton?
    //Right side elements
    @IBOutlet var contacViewName: NSTextField!
    @IBOutlet var contacViewLastname: NSTextField!
    @IBOutlet var contacViewPhone: NSTextField!
    @IBOutlet var contacViewEmail: NSTextField!
    @IBOutlet var contacViewNotes: NSTextField!
    @IBOutlet var contacViewTags: NSTextField!
//Help variables
    let sortings = ["name-sort", "lastname-sort", "phone-sort", "email-sort"]
    var lastSort:String = ""
    var contactBook = ContactBook()
    var lastRowSelected: Int = -1
    var updatedTags = [String]()
    
    //This function start when the view is loaded: it's a kind of main()
    override func viewDidLoad() {
        super.viewDidLoad()
        //Load contacts
        contactBook.loadCB()
        //And set table data source
        contactsTable?.delegate = self
        contactsTable?.dataSource = self
    }
    
    // Prepare for segue and set parameter to pass: this function manage parameter passed between views
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
            next.contactIndex = (contactsTable?.selectedRow)
            if next.contactToDelete.helperIndex == nil{
               next.contactToDelete.helperIndex = (contactsTable?.selectedRow)
            }else{
                next.contactToDelete = contactBook.contactsToShow()[lastRowSelected]
            }
        }
    }
    
    //This function is the filter to shown datas, it's an action and it's linked to the search bar
    //And it's triggered after a little time after typed something
    @IBAction func filterContent(sender: NSSearchField){
        contactBook.filter = sender.stringValue.lowercased() as String
        contactsTable?.reloadData()
    }
    
    //This function manage the right view: it's triggered when a row is clicked: the contact information are shown.
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
        //If it's clicked -1 row and a valid colum, click it's in the headbar, then sort!
        if sender.clickedRow == -1 && sender.clickedColumn != -1{
            sortList(by: sortings[(contactsTable?.clickedColumn)!])
            removeButton?.isEnabled = false
        }
        
    }
    //This function is triggered when a field on the right is edited: update the linked contact
    @IBAction func updateContact(sender: AnyObject){
        if lastRowSelected != -1{
            contactBook.contacts[lastRowSelected].name = contacViewName.stringValue
            contactBook.contacts[lastRowSelected].lastName = contacViewLastname.stringValue
            contactBook.contacts[lastRowSelected].email = contacViewEmail.stringValue
            contactBook.contacts[lastRowSelected].phone = contacViewPhone.stringValue
            contactBook.contacts[lastRowSelected].notes = contacViewNotes.stringValue
            //save and reload table view
            contactBook.saveCB()
            contactsTable?.reloadData()
        }
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
    
    //Require a sort for the objects in table
    private func sortList(by: String){
        var sorter = by
        print(sorter)
        if sorter == lastSort{
            sorter = sorter + "-reverse"
            lastSort = ""
        }else{
            lastSort = sorter
        }
        contactBook.sortCB(by: sorter)
        contactsTable?.reloadData()
    }
}

//______________________________________________________
//As datasource of the table view, need to implement the method that manage the behavior of this.

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
        
        //Select the contact to show
        let item = contactBook.contactsToShow()[row]
        //Up by column read interested fiel
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

        //Instanciate cell
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView
        cell?.textField?.stringValue = text
        
        return cell
    }
    
}
