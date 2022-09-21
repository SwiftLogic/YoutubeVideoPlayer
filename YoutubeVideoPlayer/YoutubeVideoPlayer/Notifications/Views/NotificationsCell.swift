//
//  NotificationsCell.swift
//  YoutubeVideoPlayer
//
//  Created by Osaretin Uyigue on 9/21/22.
//

import UIKit
class NotificationsCell: UITableViewCell {
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
        selectionStyle = .none

    }
    
    
    
    //MARK: - Properties
    
    static let identifier = String(describing: NotificationsCell.self)
    
    var usernotification: UserNotifications! {
        didSet {
            profileImageView.image = UIImage(named: usernotification.profileImageUrl)
            thumbnailImageView.image = UIImage(named: usernotification.thumbnailImageUrl)
            let title = usernotification.username + " " + usernotification.message
            setUpAttributedString(title: title, dateText: usernotification.date)

        }
    }
    
    fileprivate let profileImageViewDimen: CGFloat = 35
    fileprivate lazy var profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = profileImageViewDimen / 2
        profileImageView.contentMode = .scaleAspectFill
        return profileImageView
    }()
    
    
    fileprivate let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    
    fileprivate let notificationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12.5)
        return label
    }()
    
    
    
    fileprivate let optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(VERTICAL_ELLIPSIS_IMAGE, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    
    //MARK: - Handlers
    
    fileprivate func setUpViews() {
        addSubview(profileImageView)
        addSubview(thumbnailImageView)
        addSubview(notificationLabel)
        addSubview(optionsButton)
        
        profileImageView.constrainToTop(paddingTop: 12)
        profileImageView.constrainToLeft(paddingLeft: HORIZONTAL_PADDING)
        profileImageView.constrainWidth(constant: profileImageViewDimen)
        profileImageView.constrainHeight(constant: profileImageViewDimen)
        
        
        thumbnailImageView.constrainToTop(paddingTop: 12)
        let thumbnailImageViewPadding: CGFloat = 30
        thumbnailImageView.constrainToRight(paddingRight: -thumbnailImageViewPadding)
        thumbnailImageView.constrainWidth(constant: 80)
        thumbnailImageView.constrainHeight(constant: 45)
        
        
        notificationLabel.anchor(top: profileImageView.topAnchor, leading: profileImageView.trailingAnchor, bottom: bottomAnchor, trailing: thumbnailImageView.leadingAnchor, padding: .init(top: 0, left: HORIZONTAL_PADDING, bottom: HORIZONTAL_PADDING, right: HORIZONTAL_PADDING))
        
        
        optionsButton.centerYAnchor.constraint(equalTo: thumbnailImageView.centerYAnchor).isActive = true
        optionsButton.constrainToRight(paddingRight: -12)
        
        
    }
    
    
    
    fileprivate func setUpAttributedString(title: String, dateText: String) {
        let attributedString = handleSetUpAttributedText(titleString: title, subString: " \(dateText)", mainColor: .white, mainfont: UIFont.systemFont(ofSize: 12.5), secondColor: .lightGray, subFont: UIFont.systemFont(ofSize: 12.5))
        notificationLabel.attributedText = attributedString
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
