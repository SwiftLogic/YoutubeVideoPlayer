//
//  NotificationVC.swift
//  YoutubeVideoPlayer
//
//  Created by Osaretin Uyigue on 9/21/22.
//

import UIKit
class NotificationsVC: UIViewController {
    
    //MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpNavBar()
        setUpDummyData()
    }
    
    
    //MARK: - Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    
    fileprivate var notificationsData = [UserNotifications]()
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = APP_BACKGROUND_COLOR
        return tableView
    }()
    
    
    
    
    
    //MARK: - Handlers
    fileprivate func setUpViews() {
        view.backgroundColor = APP_BACKGROUND_COLOR
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.register(NotificationsCell.self, forCellReuseIdentifier: NotificationsCell.identifier)
        tableView.separatorStyle = .none
        
    }
    
    
    fileprivate func setUpNavBar() {
        let broadcastitem = UIBarButtonItem(image: BROADCAST_IMAGE, style: .done, target: self, action: nil)
        let searchcastitem = UIBarButtonItem(image: SEARCH_IMAGE, style: .done, target: self, action: nil)
        let optionsItem = UIBarButtonItem(image: BIGGER_VERTICAL_ELLIPSIS_IMAGE, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [optionsItem, searchcastitem, broadcastitem]
    }
    
    
    
    
    //MARK: - Dummy Data
    fileprivate func setUpDummyData() {
        let notif1 = UserNotifications(profileImageUrl: "hodge_twins_profile_picc", thumbnailImageUrl: "hodgtwins_sandwich", username: "Hodge Twins", message: "uploaded: Eating Burger King's New Crispy Chicken Sandwich", date: "3 months ago")
        
        let notif2 = UserNotifications(profileImageUrl: "hsw", thumbnailImageUrl: "what_a_beautifulname", username: "Hillsong worship", message: "responded to your comment: Thank you!", date: "1 months ago")

        
        let notif3 = UserNotifications(profileImageUrl: "image10", thumbnailImageUrl: "pinchtozoomvideo", username: "SamiSays11", message: "uploaded: How to Build a Pinch to Zoom Feature Using SwiftUI", date: "10 minutes ago")
        
        let notif4 = UserNotifications(profileImageUrl: "sean_allen", thumbnailImageUrl: "swiftUI_basics", username: "Sean Allen", message: "uploaded: Learn the Basics of SwiftUI", date: "1 year ago")

        
        let notif5 = UserNotifications(profileImageUrl: "sean_allen", thumbnailImageUrl: "swiftUI_basics", username: "Sean Allen", message: "responded to your comment: Good feedback is always apprecaited my friend. we are all just trying to be better devs :), thats the goal isnt it? so yea always happy to get constructive criticism. Good criticism is paramount to growth", date: "7 months ago")

        
        let notif6 = UserNotifications(profileImageUrl: "kavasoft", thumbnailImageUrl: "tabbarvideothumbnail", username: "KavaSoft", message: "uploaded: Building a Custom Tabbar in SwiftUI 3.0", date: "3 months ago")


        
        let notif7 = UserNotifications(profileImageUrl: "image10", thumbnailImageUrl: "image13", username: "SamiSays11", message: "uploaded: Vacay time with the wife!!", date: "1 second ago")
        
        let notif8 = UserNotifications(profileImageUrl: "nat_geo", thumbnailImageUrl: "nat_geo", username: "National Geo", message: "uploaded: Lions in Safaris", date: "40 second ago")

        
        let notifications = [notif1, notif2, notif3, notif4, notif5, notif6, notif7, notif8].shuffled()
        
        notificationsData = notifications + notifications + notifications
        

    }
}


//MARK: - TableView Delegates & DataSource
extension NotificationsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationsCell.identifier, for: indexPath) as! NotificationsCell
        cell.backgroundColor = APP_BACKGROUND_COLOR
        cell.usernotification = notificationsData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationsData.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
        
    }
    
   
    
}





