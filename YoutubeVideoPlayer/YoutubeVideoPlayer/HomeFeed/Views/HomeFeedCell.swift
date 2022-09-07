//
//  HomeFeedCell.swift
//  YoutubeVideoPlayer
//
//  Created by Osaretin Uyigue on 7/27/22.
//


import UIKit
class HomeFeedCell: UICollectionViewCell {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        backgroundColor = APP_BACKGROUND_COLOR
    }
    
    
    
    
    //MARK: - Properties
    static let cellReuseIdentifier = String(describing: HomeFeedCell.self)

    var thumbnailHeightConstraint: NSLayoutConstraint = NSLayoutConstraint()
    fileprivate let thumbnailImageView: CacheableImageView = {
        let imageView = CacheableImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    fileprivate let channelImageViewDimen: CGFloat = 35
    fileprivate lazy var channelImageView: CacheableImageView = {
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
        label.text = "TwinMuscle • 931K views • 1 year ago"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
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
    
    
    fileprivate let optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(VERTICAL_ELLIPSIS_IMAGE, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    
    //MARK: - Methods
    fileprivate func setUpViews() {
        addSubview(thumbnailImageView)
        addSubview(channelImageView)
        addSubview(videoTitleLabel)
        addSubview(channelNameLabel)
        thumbnailImageView.addSubview(videoDurationLabel)
        
        
        thumbnailImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        thumbnailHeightConstraint = thumbnailImageView.heightAnchor.constraint(equalToConstant: 0)
        thumbnailHeightConstraint.isActive = true
        thumbnailImageView.constrainWidth(constant: frame.width)

        
        channelImageView.anchor(top: thumbnailImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 8, left: 8, bottom: 0, right: 0), size: .init(width: channelImageViewDimen, height: channelImageViewDimen))

        videoTitleLabel.anchor(top: channelImageView.topAnchor, leading: channelImageView.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 5, bottom: 0, right: 5))

        channelNameLabel.anchor(top: videoTitleLabel.bottomAnchor, leading: videoTitleLabel.leadingAnchor, bottom: nil, trailing: videoTitleLabel.trailingAnchor)


        videoDurationLabel.bottomAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: -8).isActive = true
        videoDurationLabel.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: -8).isActive = true
        
        
    }
    
    
    
    // data binding
    func configure(with video: Video) {
        thumbnailImageView.getImage(for: video.videoThumbnailImageUrl)
        channelImageView.getImage(for: video.channel.channelImageUrl)
        videoTitleLabel.text = video.videoTitle
        videoDurationLabel.text = video.videoDuration
        let creationDate = video.creationDate
        
        let channelNameLimit = 18
        let channelName = video.channel.channelName.count > channelNameLimit ? String(video.channel.channelName.prefix(channelNameLimit)) : video.channel.channelName
        
        let views = video.views
        channelNameLabel.text = "\(channelName) • \(views) • \(creationDate)"
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


