//
//  LoginViewController.swift
//  WePlan
//
//  Created by Kan Chen on 4/3/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var pwdText: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    var displayed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.text = ""
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        displayed = true
        if PFUser.currentUser() != nil {
            usernameText.text = PFUser.currentUser().username
//            println(PFUser.currentUser().username)
//            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarEntry") as TabBarViewController
//            performSegueWithIdentifier(Login.LoginSegueId, sender: self)
//            self.presentViewController(vc, animated: false, completion: { () -> Void in
//                
//            })
            
        }
    }

    override func viewWillDisappear(animated: Bool) {
        displayed = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func clickSignin(sender: AnyObject) {
        let username = usernameText.text
        let pwd = pwdText.text
        if !validEmail(username) {
            errorLabel.text = Login.notifyEmailInvalid
            return
        }
        if !validPassword(pwd) {
            errorLabel.text = Login.notifyPasswordInvalid
            return
        }
        
        PFUser.logInWithUsernameInBackground(username, password: pwd) { (user: PFUser!, error: NSError!) -> Void in
            if user != nil {
                if self.displayed {
                    self.performSegueWithIdentifier(Login.LoginSegueId, sender: self)
                }
            }else {
                let errorString = error.userInfo!["error"] as String
                self.errorLabel.text = errorString
            }
        }
//        ParseAction.signIn(email, password: pwd) { (result) -> Void in
//            if result == "success" {
//                 self.performSegueWithIdentifier(Login.LoginSegueId, sender: self)
//            }
//        }
        
        
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
