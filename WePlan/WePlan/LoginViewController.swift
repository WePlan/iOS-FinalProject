//
//  LoginViewController.swift
//  WePlan
//
//  Created by Kan Chen on 4/3/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var pwdText: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.text = ""
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func clickSignin(sender: AnyObject) {
        let email = emailText.text
        let pwd = pwdText.text
        if !validEmail(email) {
            errorLabel.text = Login.notifyEmailInvalid
            return
        }
        if !validPassword(pwd) {
            errorLabel.text = Login.notifyPasswordInvalid
            return
        }
        
        ParseAction.signIn(email, password: pwd) { (result) -> Void in
            if result == "success" {
                 self.performSegueWithIdentifier(Login.LoginSegueId, sender: self)
            }
        }
        
       
        
    }
    
    private func validEmail(String) -> Bool {
        //TODO: test email
        return true
    }
    
    private func validPassword(String) -> Bool {
        //TODO: test password
        return true
    }
    
    // MARK: - Navigation
    private struct Login {
        static let LoginSegueId = "Login"
        static let notifyEmailInvalid = "invalid E-mail"
        static let notifyPasswordInvalid = "invalid Password"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
