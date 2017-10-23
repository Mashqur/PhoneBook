//
//  NameListViewController.swift
//  PhoneBook
//
//  Created by Mashqur Habib on 10/18/17.
//  Copyright © 2017 Himel's App. All rights reserved.
//

import UIKit
import CoreData

class NameListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
        let nameNumber = contact[indexPath.row]
        cell.name?.text = nameNumber.name
        cell.number?.text = nameNumber.phoneNumber
        return cell
    }
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        
//        if editingStyle == .delete{
//            let user = contact[indexPath.row]
//            context.delete(user)
//            (UIApplication.shared.delegate as! AppDelegate).saveContext()
//            do{
//              try  contact =  context.fetch(Family.fetchRequest())
//            }
//            catch{
//                print(error)
//            }
//        }
//        nameNumberTable.reloadData()
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("TAPPED")
//        let call = contact[indexPath.row].phoneNumber
//        print(call!)
//        UIApplication.shared.open(NSURL(string: "tel://\(String(describing: call!))")! as URL, options: [:], completionHandler: nil)
//    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            self.messageAlert(tableRow: self.contact[indexPath.row])
        }
        delete.backgroundColor = UIColor.lightGray
        
        let call = UITableViewRowAction(style: .normal, title: "Call") { action, index in
            let call = self.contact[indexPath.row].phoneNumber
            UIApplication.shared.open(NSURL(string: "tel://\(String(describing: call!))")! as URL, options: [:], completionHandler: nil)
        }
        call.backgroundColor = UIColor.orange
        return [delete, call]
    }
    
    func fetchContact(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            try contact = context.fetch(Family.fetchRequest())
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
            try  self.contact =  context.fetch(Family.fetchRequest())
        }
        catch{
            print(error)
        }
        self.nameNumberTable.reloadData()
    }
    
    func messageAlert(tableRow: Any){
        let nameAlert = UIAlertController(title: "Delete Contact", message: "Do you want to delete?", preferredStyle: UIAlertControllerStyle.alert)
        nameAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {ACTION in self.performDelete(tableRow: tableRow)}))
        nameAlert.addAction(UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(nameAlert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
