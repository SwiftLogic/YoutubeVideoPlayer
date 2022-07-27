//
//  PreviewShortsCell.swift
//  YoutubeVideoPlayer
//
//  Created by Osaretin Uyigue on 7/27/22.
//

import UIKit
class PreviewShortsCell: UICollectionViewCell {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        clipsToBounds = true
        layer.cornerRadius = 3
    }
    
    
    
    
    //MARK: - Properties
    static let cellReuseIdentifier = String(describing: PreviewShortsCell.self)

    var imageName: String! {
        didSet {
            thumbnailImageView.image = UIImage(named: imageName)
        }
    }
    
    
    fileprivate let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.75
        return imageView
    }()
    
    
    
    fileprivate let videoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Our New Rifles & Eating Popeye's New Chicken Sandwich"
        label.textColor = .white
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)

        return label
    }()
    
    fileprivate let viewsLabel: UILabel = {
        let label = UILabel()
        label.text = "931K views"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        return label
    }()
    
    
    
    //MARK: - Handlers
    
    fileprivate func setUpViews() {
        addSubview(thumbnailImageView)
        thumbnailImageView.fillSuperview()
        
        insertSubview(viewsLabel, aboveSubview: thumbnailImageView)
        insertSubview(videoTitleLabel, aboveSubview: thumbnailImageView)

      
        viewsLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 10, bottom: 10, right: 0))
        
        videoTitleLabel.anchor(top: nil, leading: viewsLabel.leadingAnchor, bottom: viewsLabel.topAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 5, right: 5))

        
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
