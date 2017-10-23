//
//  ViewController.swift
//  PhoneBook
//
//  Created by Mashqur Habib on 10/18/17.
//  Copyright © 2017 Himel's App. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var number: UITextField!
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveCredentials(_ sender: UIButton) {
        
        if(name.text != "" && number.text != ""){
            let newContact = NSEntityDescription.insertNewObject(forEntityName: "Family", into: context)
            newContact.setValue(name.text, forKey: "name")
            newContact.setValue(number.text, forKey: "phoneNumber")
            name.text = ""
            number.text = ""
            name.resignFirstResponder()
            number.resignFirstResponder()
            do{
                try context.save()
            }
            catch{
                print(error)
            }
            
        }else{
            let nameAlert = UIAlertController(title: "No name or number", message: "Please fill name or number", preferredStyle: UIAlertControllerStyle.alert)
            nameAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            //self.present(nameAlert, animated: true, completion: nil)
            present(nameAlert, animated: true, completion: nil)
        }
    }

}

