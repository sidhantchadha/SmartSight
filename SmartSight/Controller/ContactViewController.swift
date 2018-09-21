//
//  ContactViewController.swift
//  SmartSight
//
//  Created by Sidhant Chadha on 8/30/18.
//  Copyright © 2018 AMoDynamics, Inc. All rights reserved.
//

import UIKit
import ChameleonFramework
import MessageUI

class ContactViewController: UIViewController, MFMailComposeViewControllerDelegate {
   
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var messageField: UITextField!

    @IBAction func dismissKeyboard(_ sender: Any) {
        self.resignFirstResponder()
    }
    
    
    @IBAction func sendButton(_ sender: UIButton) {
        let toRecipients = ["sidhantchadha@live.com"]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setToRecipients(toRecipients)
        mc.setSubject(nameField.text!)
        mc.setMessageBody("Name: \(nameField.text!) \n\nEmail: \(emailField.text!) \n\nMessage: \(messageField.text!)", isHTML: false)
        self.present(mc, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(gradientStyle: UIGradientStyle.topToBottom, withFrame: view.frame, andColors:[FlatGrayDark(), FlatWhite()])

    }
    
 
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
        case .cancelled :
            print("Cancelled")
        case .failed:
            print("Failed")
        case .saved:
            print("Saved")
        case .sent:
            print("Sent")
        }
        self.dismiss(animated: true, completion: nil)
    
    }


}
