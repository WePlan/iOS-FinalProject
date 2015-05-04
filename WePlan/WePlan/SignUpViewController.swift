//
//  SignUpViewController.swift
//  WePlan
//
//  Created by Kan Chen on 4/6/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {

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
    
    // MARK: - TextFiled
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        pulldownView()
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.nicknameTextField{
            self.emailTextField.becomeFirstResponder()
        }
        else if textField == self.emailTextField{
            self.usernameTextField.becomeFirstResponder()
        }
        else if textField == self.usernameTextField{
            self.passwordTextField.becomeFirstResponder()
        }
        else if textField == self.passwordTextField{
            self.passwordRepeatTextField.becomeFirstResponder()
        }
        else{
            pulldownView()
            view.endEditing(true)
            create()
            return true
        }
        return false
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == self.passwordRepeatTextField || textField == self.passwordTextField {
            let frame = self.view.frame
            if frame.origin == CGPoint(x: 0, y: 0) {
//                println( "0,0")
                UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    let size = self.view.frame.size
                    self.view.frame = CGRectMake(0, -100, size.width, size.height)
                    self.view.layoutIfNeeded()
                    }, completion: { (finished:Bool) -> Void in
                        //
                })
            }
        }
        return true
    }
    
    func pulldownView() {
        if self.view.frame.origin == CGPoint(x: 0 , y: -100) {
            let size = self.view.frame.size
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.view.frame = CGRectMake(0, 0, size.width, size.height)
                self.view.layoutIfNeeded()
                }) { (finished:Bool) -> Void in
                    //
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.nicknameTextField.delegate=self
        self.emailTextField.delegate=self
        self.usernameTextField.delegate=self
        self.passwordTextField.delegate=self
        self.passwordRepeatTextField.delegate=self
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
        view.endEditing(true)
        pulldownView()
        create()
        
    }
    
    func create() {
        let email = emailTextField.text
        let username = usernameTextField.text
        let password = passwordTextField.text
        let passwordRepeat = passwordRepeatTextField.text
        let nickname = nicknameTextField.text
        if count(nickname) < 3 {
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
        
        user.signUpInBackgroundWithBlock { (succeeded: Bool, error: NSError?) -> Void in
            if error == nil{
                if self.displayed {
                    let pfobject = PFObject(className:"User_Group")
                    assert(user.objectId != nil, "id is nil")
                    pfobject["uid"] = user.objectId
                    pfobject["groupIds"] = []
                    pfobject.saveInBackground()
                    self.performSegueWithIdentifier(Constants.segueToTabbar, sender: self)
                }
           
            }else {
                let errorString = error!.userInfo!["error"] as! String
                self.errorLabel.text = errorString
            }
        }
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
