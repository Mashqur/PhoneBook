//
//  AlertMessageGenerator.swift
//  PhoneBook
//
//  Created by Mashqur Habib on 10/23/17.
//  Copyright © 2017 Himel's App. All rights reserved.
//

import Foundation
import UIKit
class AlertMessageGenerator {
    class func alertMessage(title: String, message: String, controller: UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    
    }
}
