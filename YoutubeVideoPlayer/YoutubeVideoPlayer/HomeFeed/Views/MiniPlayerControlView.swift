//
//  MiniPlayerControlView.swift
//  YoutubeVideoPlayer
//
//  Created by Osaretin Uyigue on 8/6/22.
//

import UIKit
class MiniPlayerControlView: UIView {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        backgroundColor = APP_BACKGROUND_COLOR.withAlphaComponent(0.3)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Properties
    fileprivate let videoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Charles Oliveira goes off on Khabib & Ali Abdelaziz for talking too much"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    
    fileprivate let channelNameLabel: UILabel = {
        let label = UILabel()
        label.text = "TwinMuscle"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    fileprivate let pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .light, scale: .medium)
        let image = UIImage(systemName: "play.fill", withConfiguration:
                                config)?.withRenderingMode(.alwaysTemplate)
        button.tintColor = .white
        button.setImage(image, for: .normal)
        return button
    }()
    
    
    
    
    fileprivate let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .light, scale: .medium)
        let image = UIImage(systemName: "xmark", withConfiguration:
                                config)?.withRenderingMode(.alwaysTemplate)
        button.tintColor = .white
        button.setImage(image, for: .normal)
        return button
    }()
    
    
    //MARK: - Methods
    fileprivate func setUpViews() {
        addSubview(videoTitleLabel)
        addSubview(channelNameLabel)
        addSubview(pausePlayButton)
        addSubview(cancelButton)
        
        videoTitleLabel.constrainToTop(paddingTop: 10)

        videoTitleLabel.constrainToLeft(paddingLeft: 8)
        videoTitleLabel.constrainWidth(constant: MINI_PLAYER_WIDTH)
        channelNameLabel.leadingAnchor.constraint(equalTo: videoTitleLabel.leadingAnchor).isActive = true
        channelNameLabel.trailingAnchor.constraint(equalTo: videoTitleLabel.trailingAnchor).isActive = true
        channelNameLabel.topAnchor.constraint(equalTo: videoTitleLabel.bottomAnchor, constant: 8).isActive = true


        
        pausePlayButton.centerYInSuperview()
        pausePlayButton.leadingAnchor.constraint(equalTo: videoTitleLabel.trailingAnchor, constant: 0).isActive = true
        pausePlayButton.constrainHeight(constant: 40)
        pausePlayButton.constrainWidth(constant: 60)
        
        
        cancelButton.centerYInSuperview()
        cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        cancelButton.constrainHeight(constant: 40)
        cancelButton.constrainWidth(constant: 60)
        
    }
    
    
    
    func isHidden( _ hide: Bool) {
        alpha = hide ? 0 : 1
    }
    
    
    //MARK: - Data Binding
    func configure(with data: HomeFeedDataModel) {
        videoTitleLabel.text = data.videoTitle
        channelNameLabel.text = data.channel.channelName
    }
    
    
}
