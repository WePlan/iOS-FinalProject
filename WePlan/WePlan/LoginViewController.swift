//
//  LoginViewController.swift
//  WePlan
//
//  Created by Kan Chen on 4/3/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit


class LoginViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate{

    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var pwdText: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    @IBOutlet weak var BackgroundImage: UIImageView!
    
    var displayed: Bool = false
    enum UIBlurEffectStyle : Int {
        case ExtraLight
        case Light
        case Dark
    }
    
    func setTextFieldStyle(stringText:String,textField:UITextField){
        var placeHolder=NSAttributedString(string: stringText, attributes:[NSForegroundColorAttributeName: UIColor(white: 1, alpha: 0.5)])
        textField.attributedPlaceholder = placeHolder
    }
  
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.text = ""
        
        // Do any additional setup after loading the view.
        self.usernameText.delegate=self
        self.pwdText.delegate=self
        setTextFieldStyle("Username", textField: usernameText)
        setTextFieldStyle("Password", textField: pwdText)
        //Add Background BlurEffect
        let blurEffect = UIBlurEffect(style: .Dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        view.addSubview(blurView)
        
        loginButton.readPermissions = ["public_profile","email"]
        loginButton.delegate = self
        if FBSDKAccessToken.currentAccessToken() != nil {
            println("Already loggined in with facebook!")
            println(self.returnUserData())
        }
        
        
       // insertBlurView(BackgroundImage, style: UIBlurEffectStyle.Light)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        pulldownView()
        view.endEditing(true)
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        println("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
            println("Error : \(error)")
        }
        else if result.isCancelled {
            // Handle cancellations
            println("User cancelled logging process.")
        }
        else {
            if result.grantedPermissions.contains("email") {
                returnUserData()
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User Logged Out")
    }
    
    func returnUserData(){
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                println("Error: \(error)")
            }
            else
            {
                //println("fetched user: \(result)")
                let userName : String = result.valueForKey("name") as! String
                //println("User Name is: \(userName)")
                let userEmail : String = result.valueForKey("email") as! String
                //println("User Email is: \(userEmail)")
                self.signInWithThirdPartyAccount(userName, email: userEmail, complete: { (result : String) -> Void in
                    println(result)
                })
            }
        })
    }
    
    func signIn (email : String){
        PFUser.logInWithUsernameInBackground(email, password: email) { (object : PFUser?, error : NSError?) -> Void in
            if object != nil {
                if self.displayed {
                    self.performSegueWithIdentifier(Login.LoginSegueId, sender: self)
                }
            }
            else{
                println(error?.userInfo)
            }
        }
    }
    
    func signInWithThirdPartyAccount (nickname : String, email : String, complete : (String) -> Void) {
        var query = PFQuery(className: "_User")
        query.whereKey("email", equalTo: email)
        query.getFirstObjectInBackgroundWithBlock { (object : PFObject?, error : NSError?) -> Void in
            if error == nil {
                self.signIn(email)
                complete("Account existed! Directly login in!")
            }
            else{
                var user = PFUser()
                user.email = email
                user.username = email
                user.password = email
                user["nickname"] = nickname
                user.signUpInBackgroundWithBlock({ (success : Bool, error : NSError?) -> Void in
                    if success {
                        let object = PFObject(className: "User_Group")
                        object["uid"] = user.objectId
                        object["groupIds"] = []
                        object.saveInBackground()
                        self.signIn(email)
                        complete("New user created! For third party account.")
                    }
                    else{
                        let ee = error!.userInfo!["error"] as? String
                        complete(ee!)
                    }
                })
            }
        }
    }

    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        let frame = self.view.frame
        if frame.origin == CGPoint(x: 0, y: 0) {
//            println( "0,0")
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                let size = self.view.frame.size
                self.view.frame = CGRectMake(0, -100, size.width, size.height)
                self.view.layoutIfNeeded()
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
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.view.frame = CGRectMake(0, 0, size.width, size.height)
                self.view.layoutIfNeeded()
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
    
    
    //MARK: - Background Image Processing
    
//    
//    func insertBlurView (view: UIView,  style: UIBlurEffectStyle) {
//        view.backgroundColor = UIColor.clearColor()
//        
//        var blurEffect = UIBlurEffect(style: style)
//        var blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = view.bounds
//        view.insertSubview(blurEffectView, atIndex: 0)
//    }
//
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return UIStatusBarStyle.LightContent
//    }


}
