//
//  NameListViewController.swift
//  PhoneBook
//
//  Created by Mashqur Habib on 10/18/17.
//  Copyright © 2017 Himel's App. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class NameListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var nameNumberTable: UITableView!

    var contact:[Family] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        nameNumberTable.delegate = self
        nameNumberTable.dataSource = self
        fetchContact()
        nameNumberTable.reloadData()

        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contact.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = nameNumberTable.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        cell.name?.text = contact[indexPath.row].name
        cell.number?.text = contact[indexPath.row].phoneNumber
        return cell
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult) {
        self.nameNumberTable.reloadData()
        controller.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete" , handler: { action, index in
            self.messageAlert(tableRow: self.contact[indexPath.row])
        })
        delete.backgroundColor = UIColor.lightGray
        
        let call = UITableViewRowAction(style: .normal, title: "Call", handler: { action, index in
            let call = self.contact[indexPath.row].phoneNumber
            UIApplication.shared.open(NSURL(string: "tel://\(String(describing: call!))")! as URL, options: [:], completionHandler: nil)
        })
        call.backgroundColor = UIColor.orange
        
        let message = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Message", handler: {action, index in
            print("clicked")
            if (!MFMessageComposeViewController.canSendText()) {
                AlertMessageGenerator.alertMessage(title: "Message", message: "Message is not available", controller: self)
            }else{
                let messageVC = MFMessageComposeViewController()
                messageVC.messageComposeDelegate = self
                messageVC.recipients = [self.contact[indexPath.row].phoneNumber!]
                self.present(messageVC, animated: true, completion: nil)
            }
        })
        message.backgroundColor = UIColor.gray
        return [delete, call, message]
    }
    
    func fetchContact(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            contact = try context.fetch(Family.fetchRequest())
        }
        catch{
            print(error)
        }
    }
    
    func performDelete(tableRow: Any){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let user = tableRow
        context.delete(user as! NSManagedObject)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        do{
            self.contact = try  context.fetch(Family.fetchRequest())
        }
        catch{
            print(error)
        }
        self.nameNumberTable.reloadData()
    }
    
    func messageAlert(tableRow: Any){
        let nameAlert = UIAlertController(title: "Delete Contact", message: "Do you want to delete?", preferredStyle: UIAlertControllerStyle.alert)
        nameAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {ACTION in self.performDelete(tableRow: tableRow)}))
        nameAlert.addAction(UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.cancel, handler: {ACTION in self.nameNumberTable.reloadData()}))
        self.present(nameAlert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
