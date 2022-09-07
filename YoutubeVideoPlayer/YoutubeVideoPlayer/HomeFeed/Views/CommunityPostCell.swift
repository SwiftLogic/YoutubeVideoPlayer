//
//  CommunityPostCell.swift
//  YoutubeVideoPlayer
//
//  Created by Osaretin Uyigue on 9/7/22.
//

import UIKit
class CommunityPostCell: UICollectionViewCell {
    
    //MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        backgroundColor = APP_BACKGROUND_COLOR
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties
    static let cellReuseIdentifier = String(describing: CommunityPostCell.self)

    fileprivate let thumbnailImageView: CacheableImageView = {
        let imageView = CacheableImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    fileprivate let channelImageViewDimen: CGFloat = 35
    fileprivate lazy var profileImageView: CacheableImageView = {
        let imageView = CacheableImageView()
        imageView.backgroundColor = APP_BACKGROUND_COLOR
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = channelImageViewDimen / 2
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    
    fileprivate let videoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Our New Rifles & Eating Popeye's New Chicken Sandwich"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    fileprivate let channelNameLabel: UILabel = {
        let label = UILabel()
        label.text = "ESPN FC."
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    fileprivate let creationDateLabel: UILabel = {
        let label = UILabel()
        label.text = "1 hour ago"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    
    fileprivate let captionLabel: UILabel = {
        let label = UILabel()
        label.text = "Dominant Real Madrid String 33 Passes to Produce Hazard's Goal vs. Celtic | CBS Sports Golazo"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    
    
    fileprivate let optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(VERTICAL_ELLIPSIS_IMAGE, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    
    fileprivate let likeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = createSfImage(with: "hand.thumbsup", pointSize: 15).withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.setTitle("  2.8K", for: .normal)
        button.tintColor = .white
        return button
    }()
    
    
    fileprivate let dislikeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = createSfImage(with: "hand.thumbsdown", pointSize: 15).withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate let commentButton: UIButton = {
        let button = UIButton(type: .system)
        let image = createSfImage(with: "text.bubble", pointSize: 15).withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.setTitle("  112", for: .normal)
        button.tintColor = .white
        return button
    }()
    
    
    // profile image view, timelabel, captionlabel, postimageview, likes button, likes countlabel, dislike btn, commentbutton and commentcount
    
    
    //MARK: - Methods
    fileprivate func setUpViews() {
        addSubview(profileImageView)
        addSubview(channelNameLabel)
        addSubview(creationDateLabel)
        addSubview(optionsButton)
        addSubview(captionLabel)
        addSubview(thumbnailImageView)
        addSubview(likeButton)
        addSubview(dislikeButton)
        addSubview(commentButton)
        
        profileImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10, left: 12, bottom: 0, right: 0), size: .init(width: channelImageViewDimen, height: channelImageViewDimen))
        
        
        channelNameLabel.anchor(top: profileImageView.topAnchor, leading: profileImageView.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 5, bottom: 0, right: 0))
        
        creationDateLabel.anchor(top: nil, leading: channelNameLabel.leadingAnchor, bottom: profileImageView.bottomAnchor, trailing: nil)
        
        
        optionsButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        optionsButton.constrainToRight(paddingRight: 0)
        optionsButton.constrainWidth(constant: 20)
        
        
        captionLabel.anchor(top: profileImageView.bottomAnchor, leading: profileImageView.leadingAnchor, bottom: nil, trailing: optionsButton.leadingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0))
        
        thumbnailImageView.anchor(top: captionLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 5, left: 0, bottom: 0, right: 0))
        
        likeButton.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 10).isActive = true 
        likeButton.constrainToLeft(paddingLeft: 8)
        
        
        dislikeButton.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 10).isActive = true
        dislikeButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 12).isActive = true
        
        commentButton.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 10).isActive = true
        commentButton.constrainToRight(paddingRight: -8)
        
        
        thumbnailImageView.setPlaceHolderImage()
        profileImageView.setPlaceHolderImage()
        
        
        
    }
    
    
}


#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct SimpleView_Preview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let button = CommunityPostCell()
            return button
        }.previewLayout(.sizeThatFits)
            .padding(0)
    }
}
#endif

