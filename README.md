# The functions or modules that need to be implemented or updated：

## Group Module:

### UI Part :

1. CreateGroupView. Including (All the contents should be implemented in a single view.): 
  - Image of the Group. (By uploading.)
  - Input the basic information of the group. (Such as : title, description, etc.)
  - Add members for this group. (sub-Tableview)
2. Cell of group need to be updated. (New style, arrangement, etc. Needs to be redesigned.)
3. GroupDetailView. Including :
  - Showing detailed information of the group. (Data has already been fetched from the database.)
  - "Quit/Dismiss" button needs to be implemented. (Group owner or Group member.)
  - Assign task for this group. (New View, which can be named as AssignGroupTaskView.)
4. Remove "Slide to delete" function for Group Module.
5. Remove "Touch-shown list" function for Group Module.

### Backend Part:

1. func QuitGroup (PFUser.currentUser().objectId)
2. func DeleteGroup (groupId)
3. func GetGroupUserList ([memberId])
4. func AssignGroupTask() with tsort = 3, towner = groupId, uid = each member's objectId of the groupId.

## Friend Module:

### UI Part :

1. "Add" friend button bug needs to be fixed. (Turn into grey (enable = false))
2. FriendDetailView. Including :
  - Showing detailed information of the selected friend. (Data has already been fetched from the database.)
  - "Delete" the friendship button. (Function has already been implemented.)
  - Assign task for this friend. (New View, which can be named as AssignFriendTaskView.)
3. Remove "Touch-shown list" function for Friend Module.
4. Remove "Slide to delete" function for Friend Module.
5. Search Bar for my friend list.

### Backend Part :

1. AssignFriendTask() with tsort = 2, towner = sender's objectId, uid = receiver's objectId.

2. Send Email invitation to new user. Use Parse notification.

## Task Module :

### UI Part :

1. Remove "Slide to delete" function for Task Module.
2. Hide the touch-shown list when the user touches some blank place or other items of the menu.
3. Expand the cell of the Task to support more information and buttons.
4. "Colored Label", which is used for showing different types of the task. (Self task or Group task or Friend assigned task)

### Backend Part :

1. "Slide right to check the task" function needs to be implemented. (Pending.)

## Setting Module : (TBA)

###April 27th, 2015, By Mark

# iOS-FinalProject
Group for iOS final

Project: WePlan

Teammates:

Kan Chen (kc2386@nyu.edu)

Xi Su (suxi.suzie@gmail.com)

Zhaonan Zhang (zz724@nyu.edu)

Huibo Li (hl1487@nyu.edu)

Prototype link:
http://invis.io/3Q2E2L95X

Project Progress:

1. Model 里是一些用来接数据的对象或者结构， 可以根据需求改变

2. 每个storyboard 只负责自己的部分

3. ParseAction.swift: 和parse相关的方法, 详细要求见文件内注释

4. Friend 和 group 的tableviewcell 可以设计dynamic prototype 在storyboard里直接设计就可以了

Settings 的 table view 用静态的 设计就可以了

5.  在每个storyboard里加入相关的viewcontroller： 比如好友的详细界面  添加界面等， 也可以写相关的功能方法

6. 现在需要的图片: appicon , Tabbar icon 优先级比较高， 其他的可以先不考虑， 用涂鸦占位， 做好storyboard先

7. Tableview的相关质料：

基础入门指南: https://developer.apple.com/library/ios/referencelibrary/GettingStarted/RoadMapiOS/index.html#//apple_ref/doc/uid/TP40011343

stanford itunesU: swift lesson 10: Tableview
