//
//  RecentlyViewedVideoCell.swift
//  YoutubeVideoPlayer
//
//  Created by Osaretin Uyigue on 9/21/22.
//

import UIKit
class RecentlyViewedVideoCell: UICollectionViewCell {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    
    
    
    //MARK: - Properties
    static let cellReuseIdentifier = String(describing: RecentlyViewedVideoCell.self)
    fileprivate let thumbnailImageView: CacheableImageView = {
        let imageView = CacheableImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.blue.withAlphaComponent(0.4)
        imageView.contentMode = .scaleAspectFill
        imageView.setPlaceHolderImage()
        return imageView
    }()
    
    
    fileprivate let videoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Top 5 Fastest 100m athletes who have been banned"
        label.numberOfLines = 2
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    
    fileprivate let channelNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sprint Kings"
        label.numberOfLines = 1
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    fileprivate let optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(VERTICAL_ELLIPSIS_IMAGE, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    
    
    fileprivate let videoDurationLabel: PaddedlUILabel = {
        let label = PaddedlUILabel()
        label.textInsets = .init(top: 2, left: 5, bottom: 2, right: 5)
        label.backgroundColor = .black.withAlphaComponent(0.65)
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.layer.cornerRadius = 3.5
        return label
    }()
    
    
    
    //MARK: - Handlers
    
    fileprivate func setUpViews() {
        addSubview(thumbnailImageView)
        addSubview(videoTitleLabel)
        addSubview(channelNameLabel)
        addSubview(optionsButton)
        thumbnailImageView.addSubview(videoDurationLabel)

        let height_forImageView = frame.width / 2
        thumbnailImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, size: .init(width: 0, height: height_forImageView + 20))
        
        videoTitleLabel.anchor(top: thumbnailImageView.bottomAnchor, leading: thumbnailImageView.leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 5, left: 0, bottom: 0, right: 10))
        
        channelNameLabel.anchor(top: videoTitleLabel.bottomAnchor, leading: videoTitleLabel.leadingAnchor, bottom: nil, trailing: videoTitleLabel.trailingAnchor)
        
        optionsButton.anchor(top: videoTitleLabel.topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor)
        
        videoDurationLabel.bottomAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: -8).isActive = true
        videoDurationLabel.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: -8).isActive = true
        
        
    }
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
