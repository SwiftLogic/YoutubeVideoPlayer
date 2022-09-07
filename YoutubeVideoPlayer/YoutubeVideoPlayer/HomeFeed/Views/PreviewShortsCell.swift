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
    }
    
    
    
    
    //MARK: - Properties
    static let cellReuseIdentifier = String(describing: PreviewShortsCell.self)

    fileprivate let thumbnailImageView: CacheableImageView = {
        let imageView = CacheableImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.75
        return imageView
    }()
    
    
    fileprivate let videoTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    fileprivate let viewsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        return label
    }()
    
    
    
    //MARK: - Methods
    fileprivate func setUpViews() {
        
        clipsToBounds = true
        layer.cornerRadius = 3
        
        addSubview(thumbnailImageView)
        thumbnailImageView.fillSuperview()
        
        insertSubview(viewsLabel, aboveSubview: thumbnailImageView)
        insertSubview(videoTitleLabel, aboveSubview: thumbnailImageView)

      
        viewsLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 10, bottom: 10, right: 0))
        
        videoTitleLabel.anchor(top: nil, leading: viewsLabel.leadingAnchor, bottom: viewsLabel.topAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 5, right: 5))
        
    }
    
    

    func bind(short: YoutubeShort) {
        thumbnailImageView.getImage(for: short.imageUrl)
        videoTitleLabel.text = short.title
        viewsLabel.text = short.views
    }
    
    
    //MARK: - Overriden
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.setPlaceHolderImage()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
