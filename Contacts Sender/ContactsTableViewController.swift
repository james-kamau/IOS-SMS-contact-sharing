//
//  ContactsTableViewController.swift
//  Contacts Sender
//
//  Created by James Kamau on 27/06/2018.
//  Copyright © 2018 James Kamau. All rights reserved.
//

import UIKit
import ContactsUI
import MessageUI
import os

class ContactsTableViewController: UITableViewController, CNContactPickerDelegate, MFMessageComposeViewControllerDelegate {
    
    var contacts = [UserContact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        openContactsDialog(self)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contacts.count;
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIndetifier = "ContactTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIndetifier, for: indexPath) as? ContactTableViewCell else {
            fatalError("The dequeued cell is not an instance of ContactTableViewCell")
        }
        
        let contact = contacts[indexPath.row]
        
        cell.nameLabel.text = contact.name
        cell.contactLabel.text = contact.contact
        
        // Configure the cell...
        
        return cell
    }
    
    // MARK: Conact dialog actions
    
    @IBAction func openContactsDialog(_ sender: Any) {
        
        let picker = CNContactPickerViewController();
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let names = [contact.givenName, contact.middleName, contact.familyName]
        let userName = names.filter({ (name) -> Bool in
            return name.count > 0
        }).joined(separator: " ")
        
        for number in contact.phoneNumbers {
            let phoneNumber = number.value.stringValue
            let selected = UserContact(name: userName, contact: phoneNumber)
            self.contacts.append(selected)
            
            let indexPath = IndexPath(row: self.contacts.count - 1 , section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
            
            if contact.phoneNumbers.count == 1 {
                dismiss(animated: true) {
                    self.shareContact(contact: selected)
                }
            }
        }
    }
    
    // MARK: Contact Sharing
    
    func shareContact(contact: UserContact) {
        os_log("Share contact", log: OSLog.default, type: OSLogType.debug)
        let presenter  = MFMessageComposeViewController()
        presenter.body = "\(contact.name) \(contact.contact)"
        presenter.messageComposeDelegate = self
        present(presenter, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
       self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Tabel cell selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        os_log("Table cell celected ", log: OSLog.default, type: OSLogType.debug)
        let contact = contacts[indexPath.row]
        shareContact(contact: contact)
    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
