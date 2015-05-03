//
//  LoginViewController.swift
//  WePlan
//
//  Created by Kan Chen on 4/3/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var pwdText: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    var displayed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.text = ""
        
        // Do any additional setup after loading the view.
        self.usernameText.delegate=self
        self.pwdText.delegate=self
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        pulldownView()
        view.endEditing(true)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        let frame = self.view.frame
        if frame.origin == CGPoint(x: 0, y: 0) {
//            println( "0,0")
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                let size = self.view.frame.size
                self.view.frame = CGRectMake(0, -100, size.width, size.height)
                }, completion: { (finished:Bool) -> Void in
                //
            })
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.usernameText{
            self.pwdText.becomeFirstResponder()
        }
        else{
            view.endEditing(true)
            pulldownView()
            signIn()
            return true
        }
        return false
    }
    
    func pulldownView() {
        if self.view.frame.origin == CGPoint(x: 0 , y: -100) {
            let size = self.view.frame.size
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.view.frame = CGRectMake(0, 0, size.width, size.height)
                }) { (finished:Bool) -> Void in
                    //
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        displayed = true
//        if PFUser.currentUser() != nil {
//            usernameText.text = PFUser.currentUser().username
//            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarEntry") as TabBarViewController
//            println(vc)
//            vc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
//            
//            self.presentViewController(vc, animated: true, completion: nil)
        
//        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
//        if PFUser.currentUser() != nil {
//            usernameText.text = PFUser.currentUser().username
//            performSegueWithIdentifier(Login.LoginSegueId, sender: self)
//        }
    }

    override func viewWillDisappear(animated: Bool) {
        displayed = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func clickSignin(sender: AnyObject) {
        view.endEditing(true)
        pulldownView()
        signIn()
    }
    
    private func signIn() {
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
        
        
        PFUser.logInWithUsernameInBackground(username, password: pwd) { (user: PFUser?, error: NSError?) -> Void in
        if user != nil {
        if self.displayed {
        self.performSegueWithIdentifier(Login.LoginSegueId, sender: self)
        }
        }else {
        let errorString = error!.userInfo!["error"] as! String
        self.errorLabel.text = errorString
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
