//
//  SettingsTableVC.swift
//  WePlan
//
//  Created by Kan Chen on 3/30/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class SettingsTableVC: UITableViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var uidLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
    
    private struct Constants {
        static let imageDefault = "defaultUserImage"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.photoImage.image = UIImage(named: Constants.imageDefault)
    }
    
    func setUserLabels () {
        usernameLabel.text = PFUser.currentUser()!.username!
        uidLabel.text = PFUser.currentUser()!.objectId!
        emailLabel.text = PFUser.currentUser()!.email!
    }
    
    @IBAction func clickLogout(sender: AnyObject) {
        var sb = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        var vc = sb.instantiateViewControllerWithIdentifier("LoginView") as! LoginViewController
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    // MARK: - ImagePickerController and delegate
    
    @IBAction func clickChangeImage(sender: AnyObject) {
        prepareImagePicker()
    
    }
    
    func prepareImagePicker() {
        var pickerController = UIImagePickerController()
        let sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        pickerController.sourceType = sourceType
        if let availableSource = UIImagePickerController.availableMediaTypesForSourceType(sourceType) {
            NSLog("source is available")
            pickerController.mediaTypes = availableSource
        }
        pickerController.allowsEditing = true
        pickerController.delegate = self
        
        self.presentViewController(pickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        println("image picked!")
        let newSize = CGSizeMake(180, 180)
        var newImage = resizeImage(image, size: newSize)
        
        photoImage.image = newImage
        
        ParseImageAction.uploadImage(newImage)
                
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func resizeImage(image: UIImage , size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        var newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    // MARK: - LifeCycle
    
    override func viewWillAppear(animated: Bool) {
        DefaultSetting.setNavigationBar(self.navigationController!)
        
        setUserLabels()
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
