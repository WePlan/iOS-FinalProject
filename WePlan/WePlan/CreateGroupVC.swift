//
//  CreateGroupVC.swift
//  WePlan
//
//  Created by Kan Chen on 4/24/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class CreateGroupVC: UIViewController ,UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, FriendSelectTableDelegate{
    var localFriendsList = LocalFriendList.sharedInstance
    @IBOutlet weak var gruopNameTextField: UITextField!
    @IBOutlet weak var descTextField: UITextField!
    @IBOutlet weak var groupImageView: AsyncUIImageView!
    @IBOutlet weak var memberNumLabel: UILabel!
    
    @IBOutlet weak var friendsTableView: UITableView!
    var selectedFriends:[String] = [PFUser.currentUser()!.objectId!]
    var changeImageAlertController: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendsTableView.dataSource = self
        friendsTableView.delegate = self
        // Do any additional setup after loading the view.
        self.initialAlertController()
        self.initialPhotoView()
    }
    
    // MARK: - TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localFriendsList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("friendSelectedCell", forIndexPath: indexPath) as! FriendSelectTableViewCell
        cell.nameLabel.text = localFriendsList.friendList[indexPath.row].name
        cell.friendImageView.imageObjectId = localFriendsList.friendList[indexPath.row].imageId
        cell.uid = localFriendsList.friendList[indexPath.row].uid
        cell.delegate = self
        return cell
    }
    
    // MARK: deleget for Cell
    func selectFriend(uid: String) {
        selectedFriends.append(uid)
        memberNumLabel.text = "\(selectedFriends.count)"
    }
    func deselectFriend(uid: String) {
        var find = -1
        for index in 0..<selectedFriends.count {
            if selectedFriends[index] == uid {
                find = index
                break
            }
        }
        
        if find != -1{
            selectedFriends.removeAtIndex(find)
            memberNumLabel.text = "\(selectedFriends.count)"
        }
    }
    // MARK: - Misc.
    @IBAction func clickBack(sender: AnyObject) {
        performSegueWithIdentifier(SegueId.unwindTable, sender: self)
    }
    
    @IBAction func clickCreate(sender: AnyObject) {
        let groupName: String = self.gruopNameTextField.text
        let creatorId = PFUser.currentUser()!.objectId!
        let desc:String = self.descTextField.text
        let image = UIImage() // set it
        ParseGroupAction.createGroup(groupName, ownerId: creatorId, members: self.selectedFriends, desc: desc, groupImage: image) { () -> Void in
            self.performSegueWithIdentifier(SegueId.unwindTable, sender: self)
        }
        
    }
    
    // MARK: - Navigation
    private struct SegueId {
        static let unwindTable = "unwindGroupTable"
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    // MARK: - TapImage and Alert
    func initialPhotoView() {
        // add TapGesture
        self.groupImageView.userInteractionEnabled = true
        let singleTap = UITapGestureRecognizer(target: self, action: "tappedImage")
        self.groupImageView.addGestureRecognizer(singleTap)
        // Set default image and frame
        self.groupImageView.defaultImageName = ""
        ImageProcess.changeImageViewRounded(groupImageView)
        
        // TODO: image id is wrong
        if let imageId = PFUser.currentUser()!["imageId"] as? String {
            self.groupImageView.imageObjectId = imageId
        }else {
            println("Could not find imageId")
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

    
    // MARK: - ImagePickerController and delegate
    enum PhotoSource {
        case Library
        case Camera
    }
    
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
        println("image picked!")
        let newSize = CGSizeMake(180, 180)
        var newImage = ImageProcess.resizeImage(image, size: newSize)
        
        groupImageView.image = newImage
        
        ParseImageAction.uploadGroupImage(newImage, groupId: "")
        // TODO: use completion to track Image Id, set image id to group when create group
        // TODO: use created group id to track image such that there is no duplicate image for a group
        
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }


}
