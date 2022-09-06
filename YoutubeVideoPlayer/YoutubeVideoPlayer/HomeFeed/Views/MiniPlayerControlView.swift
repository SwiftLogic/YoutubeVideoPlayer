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
        setUpGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Properties
    weak var delegate: MiniPlayerControlViewDelegate?
    
    fileprivate let videoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Charles Oliveira goes off on Khabib & Ali Abdelaziz for talking too much"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12.5)
        return label
    }()
    
    
    fileprivate let channelNameLabel: UILabel = {
        let label = UILabel()
        label.text = "TwinMuscle"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    fileprivate lazy var pausePlayButton = createButton(with: "play.fill", targetSelector: #selector(didTapPausePlayButton))

    fileprivate lazy var cancelButton = createButton(with: "xmark", targetSelector: #selector(didTapCancelButton), imageScale: .large)
 
    var isPlaying: Bool = false
    
    //MARK: - Methods
    fileprivate func setUpViews() {
        backgroundColor = APP_BACKGROUND_COLOR.withAlphaComponent(0.9)

        addSubview(videoTitleLabel)
        addSubview(channelNameLabel)
        addSubview(pausePlayButton)
        addSubview(cancelButton)
        
        videoTitleLabel.constrainToTop(paddingTop: 10)
        videoTitleLabel.constrainToLeft(paddingLeft: 8)
        videoTitleLabel.trailingAnchor.constraint(equalTo: pausePlayButton.leadingAnchor, constant: 0).isActive = true
        channelNameLabel.leadingAnchor.constraint(equalTo: videoTitleLabel.leadingAnchor).isActive = true
        channelNameLabel.trailingAnchor.constraint(equalTo: videoTitleLabel.trailingAnchor).isActive = true
        channelNameLabel.topAnchor.constraint(equalTo: videoTitleLabel.bottomAnchor, constant: 8).isActive = true


        
        pausePlayButton.centerYInSuperview()
//        pausePlayButton.leadingAnchor.constraint(equalTo: videoTitleLabel.trailingAnchor, constant: 0).isActive = true
        pausePlayButton.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: 0).isActive = true
        pausePlayButton.constrainHeight(constant: MINI_PLAYER_HEIGHT)
        pausePlayButton.constrainWidth(constant: 50)
        
        
        cancelButton.centerYInSuperview()
        cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        cancelButton.constrainHeight(constant: MINI_PLAYER_HEIGHT)
        cancelButton.constrainWidth(constant: 50)
//
//        cancelButton.backgroundColor = .red
//        pausePlayButton.backgroundColor = .yellow
        
    }
    
    
    fileprivate func setUpGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapExpandVideoPlayer))
        addGestureRecognizer(tapGesture)
    }
    
    
    fileprivate func createButton(with imageName: String, targetSelector: Selector, imageScale: UIImage.SymbolScale = .medium) -> UIButton {
        let button = UIButton(type: .system)
        let image = createSFImage(imageName: imageName, imageScale: imageScale)
        button.tintColor = .white
        button.setImage(image, for: .normal)
        button.addTarget(self, action: targetSelector, for: .primaryActionTriggered)
        return button
    }
    
    
    func updatePlayButton(with imageName: String, isPlaying: Bool) {
        let image = createSFImage(imageName: imageName)
        pausePlayButton.setImage(image, for: .normal)
        self.isPlaying = isPlaying
    }
    
    
    func isHidden( _ hide: Bool) {
        alpha = hide ? 0 : 1
    }
    
    
    fileprivate func createSFImage(imageName: String, imageScale: UIImage.SymbolScale = .medium) -> UIImage {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .thin, scale: imageScale)
        let image = UIImage(systemName: imageName, withConfiguration:
                                config)?.withRenderingMode(.alwaysTemplate)
        
        return image ?? UIImage()
    }
    
    //MARK: - Data Binding
    func configure(with data: Video) {
        videoTitleLabel.text = data.videoTitle
        channelNameLabel.text = data.channel.channelName
    }
    
    
    //MARK: - Actions
    @objc fileprivate func didTapCancelButton() {
        delegate?.handleDismissVideoPlayer()
    }
    
    
    
    @objc fileprivate func didTapExpandVideoPlayer() {
        delegate?.handleExpandVideoPlayer()
    }
    
    
    @objc fileprivate func didTapPausePlayButton() {
        delegate?.handleChangePlayStatus(play: isPlaying)
    }
}
