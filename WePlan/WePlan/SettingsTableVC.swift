//
//  SettingsTableVC.swift
//  WePlan
//
//  Created by Kan Chen on 3/30/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class SettingsTableVC: UITableViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var about: UILabel!
    @IBOutlet weak var uidLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var photoImageView: AsyncUIImageView!
    
    var changeImageAlertController: UIAlertController?
    
    private struct Constants {
        static let imageDefault = "defaultUserImage"
    }
    
    enum PhotoSource {
        case Library
        case Camera
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialAlertController()
        self.initialPhotoView()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let tap = UITapGestureRecognizer(target: self, action: "changeName")
        self.uidLabel.userInteractionEnabled = true
        uidLabel.addGestureRecognizer(tap)
        
    }
    func initialPhotoView() {
        // add TapGesture
        self.photoImageView.userInteractionEnabled = true
        let singleTap = UITapGestureRecognizer(target: self, action: "tappedImage")
        self.photoImageView.addGestureRecognizer(singleTap)
        // Set default image and frame
        self.photoImageView.defaultImageName = Constants.imageDefault
        ImageProcess.changeImageViewToCircle(photoImageView)
//        if let imageId = PFUser.currentUser()!["imageId"] as? String {
//            self.photoImageView.imageObjectId = imageId
//        }else {
//            println("Could not find imageId")
//        }
        if let imageFile = PFUser.currentUser()!["photo"] as? PFFile {
            self.photoImageView.imageFile = imageFile
        }else {
            print("Could not find imageId")
        }
    }
    
    func tappedImage() {
        presentViewController(changeImageAlertController!, animated: true, completion: nil)
    }
    
    
    
    func initialAlertController () {
        self.changeImageAlertController = UIAlertController(title: "Do you want to change your photo?", message: "", preferredStyle: .ActionSheet)
        
        self.changeImageAlertController?.addAction(UIAlertAction(title: "Choose From Library", style: .Default, handler: { (paramAction:UIAlertAction!) -> Void in
            self.prepareImagePicker(PhotoSource.Library)
        }))
        self.changeImageAlertController?.addAction(UIAlertAction(title: "Choose From Camera", style: .Default, handler: { (paramAction:UIAlertAction!) -> Void in
            self.prepareImagePicker(PhotoSource.Camera)
        }))
        self.changeImageAlertController?.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
    }
    
    // MARK: - ClickAction
    @IBAction func clickLogout(sender: AnyObject) {
        PFUser.logOut()
        if FBSDKAccessToken.currentAccessToken() != nil {
            var logout : FBSDKLoginManager = FBSDKLoginManager()
            logout.logOut()
        }
        var sb = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        var vc = sb.instantiateViewControllerWithIdentifier("LoginView") as! LoginViewController
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func clickAbout(sender: AnyObject) {
        let alert = UIAlertController(title: "About us", message: "Thanks for chosing WePlan \n Developer: \n Kan Chen\n Xi Su\nZhaonan Zhang\nHuibo Li\n@Copyright", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func changeName() {
        let alert = UIAlertController(title: "Change your nickname", message: "please enter your new name", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler { (text:UITextField!) -> Void in
            text.placeholder = "Enter your new name"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        alert.addAction(UIAlertAction(title: "Change", style: UIAlertActionStyle.Destructive, handler: { (action:UIAlertAction!) -> Void in
            if let textFileds = alert.textFields{
                let thetextFields = textFileds as! [UITextField]
                let newname = thetextFields[0].text
                print(newname)
                if newname?.characters.count > 0 {
                    ParseImageAction.changeNickname(newname!)
                    self.usernameLabel.text = newname
                }
            }
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    // MARK: - ImagePickerController and delegate
    
    func prepareImagePicker(source: PhotoSource) {
        var pickerController = UIImagePickerController()
        let sourceType: UIImagePickerControllerSourceType
        if source == .Library {
            sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }else{
            sourceType = UIImagePickerControllerSourceType.Camera
        }
        pickerController.sourceType = sourceType
        var availableSource = UIImagePickerController.availableMediaTypesForSourceType(sourceType)
        availableSource?.removeLast()
        pickerController.mediaTypes = availableSource!
        pickerController.allowsEditing = true
        pickerController.delegate = self
        
        self.presentViewController(pickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        print("image picked!")
        let newSize = CGSizeMake(180, 180)
        var newImage = ImageProcess.resizeImage(image, size: newSize)
        
        photoImageView.image = newImage
        
//        ParseImageAction.uploadImage(newImage)
        ParseImageAction.uploadImageToUser(newImage)
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    // MARK: - LifeCycle
    func setUserLabels () {
//        usernameLabel.text = PFUser.currentUser()!.username!
        usernameLabel.text = PFUser.currentUser()!["nickname"] as? String
//        uidLabel.text = PFUser.currentUser()!.objectId!
        emailLabel.text = PFUser.currentUser()!.email!
        uidLabel.textColor = WePlanColors.blueColor()
        about.textColor = WePlanColors.blueColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        DefaultSetting.setNavigationBar(self.navigationController!)
        initialUISettings()
        setUserLabels()
    }
    private func initialUISettings() {
        DefaultSetting.setNavigationBar(self.navigationController!)
//        self.tabBarItem = UITabBarItem.init(title: "as", image: UIImage.init(named: "TapBarTaskGrey"), selectedImage: UIImage.init(named: "TapBarTaskBlue"))
        //        self.tabBarItem = UITabBarItem.init(title: "as", image: UIImage.init(named: "TapBarFriendGrey"), selectedImage: UIImage.init(named: "TapBarFriendBlue"))
        //        self.tabBarItem = UITabBarItem.init(title: "as", image: UIImage.init(named: "TapBarGroupGrey"), selectedImage: UIImage.init(named: "TapBarGroupBlue"))
//                self.tabBarItem = UITabBarItem.init(title: nil, image: UIImage.init(named: "TapBarSettingGrey")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: UIImage.init(named: "TapBarSettingBlue")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal))
//        self.tabBarItem.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: -9, right: 0)
        self.view.backgroundColor = UIColor.whiteColor()
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 7
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
