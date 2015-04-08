//
//  SignUpViewController.swift
//  WePlan
//
//  Created by Kan Chen on 4/6/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordRepeatTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var displayed:Bool = false
    private struct Constants {
        static let segueToTabbar = "signUpSucceeded"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        errorLabel.text = ""
        displayed = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        displayed = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func clickCreate(sender: AnyObject) {
        let email = emailTextField.text
        let username = usernameTextField.text
        let password = passwordTextField.text
        let passwordRepeat = passwordRepeatTextField.text
        let nickname = nicknameTextField.text
        if countElements(nickname) < 3 {
            errorLabel.text = "Nickname is too short."
            return
        }
        if password != passwordRepeat {
            errorLabel.text = "These passwords don't match! Please try again!"
            return
        }
        var user = PFUser()
        user.username = username
        user.email = email
        user.password = password
        
        user["nickname"] = nickname
//        println(self.view.window)
        
        user.signUpInBackgroundWithBlock { (succeeded: Bool!, error: NSError!) -> Void in
//            println(NSDate())
//            sleep(5)
//            println(NSDate())
            if error == nil{
                if self.displayed {
//                    println(self.displayed)
//                    println("Going to segue")
//                    println(self.view.window)
                    self.performSegueWithIdentifier(Constants.segueToTabbar, sender: self)
                }
//                if self.isViewLoaded() && self.view.window != nil {
//                    println(self.displayed)
//                    println("Going to segue")
//                    println(self.view.window)
//                    self.performSegueWithIdentifier(Constants.segueToTabbar, sender: self)
//                }
            }else {
                let errorString = error.userInfo!["error"] as String
                self.errorLabel.text = errorString
            }
        }
        
//        performSegueWithIdentifier("cancel", sender: self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
