//
//  PreviewStoryCell.swift
//  YoutubeVideoPlayer
//
//  Created by Osaretin Uyigue on 9/8/22.
//

import UIKit
class PreviewStoryCell: UICollectionViewCell {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Properties
    static let cellReuseIdentifier = String(describing: PreviewStoryCell.self)
    var story: UserStory! {
        didSet {
            titleLabel.text = story.username
            profileImageView.image = UIImage(named: story.profileImageUrl)
            thumbnailImageView.image = UIImage(named: story.profileImageUrl)
        }
    }
    
    fileprivate let thumbnailImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.image = UIImage(named: "image9")
        imageview.clipsToBounds = true
        imageview.layer.cornerRadius = 8
        return imageview
    }()
    
    let profileImageViewDimen: CGFloat = 50
    let whiteRingViewDimen: CGFloat = 45

    fileprivate lazy var profileImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.image = UIImage(named: "image3")
        imageview.clipsToBounds = true
        imageview.layer.borderWidth = 2.5
        imageview.layer.borderColor = UIColor.red.cgColor
        imageview.layer.cornerRadius = profileImageViewDimen / 2
        return imageview
    }()
    
    
    fileprivate lazy var whiteRingView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 2.5
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = whiteRingViewDimen / 2
        return view
    }()
    
    
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "21 Studios"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13.5)
        label.textAlignment = .center
        return label
    }()
    
    
    
    
    
    
    
    //MARK: - Handlers
    
    fileprivate func setUpViews() {
        backgroundColor = APP_BACKGROUND_COLOR
        addSubview(thumbnailImageView)
        addSubview(profileImageView)
        profileImageView.addSubview(whiteRingView)
        addSubview(titleLabel)
        
        thumbnailImageView.fillSuperview(padding: .init(top: 0, left: 0, bottom: 25, right: 0))
        
        profileImageView.anchor(top: nil, leading: nil, bottom: thumbnailImageView.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 10, right: 0), size: .init(width: profileImageViewDimen, height: profileImageViewDimen))
        profileImageView.centerXInSuperview()
        
        whiteRingView.centerInSuperview(size: .init(width: whiteRingViewDimen, height: whiteRingViewDimen))
        
        
        titleLabel.anchor(top: thumbnailImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 5, left: 0, bottom: 5, right: 0))
        
    }
    
    
    
    
    
}

struct UserStory: Decodable {
    
    let username: String
    let profileImageUrl: String
    
    
}
