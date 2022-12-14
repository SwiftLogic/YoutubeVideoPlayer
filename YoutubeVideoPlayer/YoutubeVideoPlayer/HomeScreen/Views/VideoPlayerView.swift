//
//  VideoPlayerView.swift
//  YoutubeVideoPlayer
//
//  Created by Osaretin Uyigue on 8/6/22.
//

import UIKit
import AVFoundation
import MaterialComponents.MaterialActivityIndicator
class VideoPlayerView: UIView {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        cleanUpPlayerForReuse()
    }
    
    //MARK: - Properties
    weak var delegate: VideoPlayerViewDelegate?
    fileprivate var timeObserverToken: Any?
    var videoPlayerMode: VideoPlayerMode = .expanded
//    {
//        didSet {
//            //MARK: - Potential solution to issue #1
//            playerLayer?.frame = frame
//
//        }
//    }
    fileprivate var isScrubAble = false
    
    
    fileprivate(set) lazy var thumbnailImageView: CacheableImageView = {
        let view = CacheableImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    fileprivate var player: AVPlayer?
    fileprivate var playerLayer: AVPlayerLayer?
    
    
    fileprivate lazy var playbackSlider: CustomSlider = {
        let slider = CustomSlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = UIColor(white: 0.5, alpha: 0.5)
        slider.thumbTintColor = .red
//        slider.setThumbImage( UIImage().withRenderingMode(.alwaysTemplate), for: .normal)
        slider.setThumbImage(#imageLiteral(resourceName: "thumb").withRenderingMode(.alwaysOriginal), for: .normal)
        slider.setThumbImage(#imageLiteral(resourceName: "thumb").withRenderingMode(.alwaysOriginal), for: .highlighted)
        slider.addTarget(self, action: #selector(handleSliderDragged), for: .valueChanged)
        return slider
    }()
    
    
  
    
    // pause play btn
    fileprivate lazy var pausePlayButton = createButton(with: "pause.fill", imageSize: 30, targetSelector: #selector(didTapPausePlayButton))
    
    // [prev] button
    fileprivate lazy var skipBackwardButton = createButton(with: "gobackward.5", targetSelector: #selector(didTapSkipBackwardsButton))

    
    // skip btn
    fileprivate lazy var skipForwardButton = createButton(with: "goforward.5", targetSelector: #selector(didTapSkipForwardsButton))

    
    // time label
    fileprivate let elapsedTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.alpha = 0
        return label
    }()
    
    // close player btn
    fileprivate lazy var minimizeVideoPlayerBtn = createButton(with: "chevron.down", backgroundColor: .clear, targetSelector: #selector(didTapMinimizePlayerButton))
    
    
    // full screen mode btn
    fileprivate lazy var fullScreenModeBtn = createButton(with: "arrow.up.left.and.arrow.down.right", imageSize: 15, backgroundColor: .clear, targetSelector: #selector(didTapFullScreenModeButton))

    
    fileprivate(set) lazy var activityIndicator = MDCActivityIndicator()

    
    //MARK: - Methods
    fileprivate func setUpViews() {
        addSubview(thumbnailImageView)
        addSubview(playbackSlider)
        addSubview(elapsedTimeLabel)
        thumbnailImageView.fillSuperview()
        
        let playbackSliderHeight: CGFloat = 10
        playbackSlider.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: -3, right: 0),  size: .init(width: 0, height: playbackSliderHeight))
        elapsedTimeLabel.constrainToLeft(paddingLeft: 15)
        elapsedTimeLabel.constrainToBottom(paddingBottom: -15)
        setUpPlayBackControls()
        
        activityIndicator.sizeToFit()
        insertSubview(activityIndicator, belowSubview: pausePlayButton)
        activityIndicator.centerInSuperview()
    }
    
    
    fileprivate func setUpPlayBackControls() {
        addSubview(pausePlayButton)
        addSubview(skipBackwardButton)
        addSubview(skipForwardButton)
        addSubview(minimizeVideoPlayerBtn)
        addSubview(fullScreenModeBtn)
        
        let pausePlayButtonDimen: CGFloat = 60
        let itemSpacing: CGFloat = 35
        pausePlayButton.layer.cornerRadius = pausePlayButtonDimen / 2
        pausePlayButton.centerInSuperview(size: .init(width: pausePlayButtonDimen, height: pausePlayButtonDimen))
        
        
        let skipButtonsDimen: CGFloat = 45

        skipBackwardButton.centerYInSuperview()
        skipBackwardButton.trailingAnchor.constraint(equalTo: pausePlayButton.leadingAnchor, constant: -itemSpacing).isActive = true 
        skipBackwardButton.constrainHeight(constant: skipButtonsDimen)
        skipBackwardButton.constrainWidth(constant: skipButtonsDimen)
        skipBackwardButton.layer.cornerRadius = skipButtonsDimen / 2
        
        skipForwardButton.centerYInSuperview()
        skipForwardButton.leadingAnchor.constraint(equalTo: pausePlayButton.trailingAnchor, constant: itemSpacing).isActive = true
        skipForwardButton.constrainHeight(constant: skipButtonsDimen)
        skipForwardButton.constrainWidth(constant: skipButtonsDimen)
        skipForwardButton.layer.cornerRadius = skipButtonsDimen / 2
        
        
        minimizeVideoPlayerBtn.constrainToLeft(paddingLeft: 0)
        minimizeVideoPlayerBtn.constrainToTop(paddingTop: 0)
        minimizeVideoPlayerBtn.constrainHeight(constant: skipButtonsDimen)
        minimizeVideoPlayerBtn.constrainWidth(constant: skipButtonsDimen)

        fullScreenModeBtn.constrainToRight(paddingRight: -15)
        fullScreenModeBtn.centerYAnchor.constraint(equalTo: elapsedTimeLabel.centerYAnchor).isActive = true
    }
    
    
    fileprivate func setUpTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureAction))
        thumbnailImageView.isUserInteractionEnabled = true
        thumbnailImageView.addGestureRecognizer(tapGesture)
    }
    
    
    
    fileprivate func prepareViewForReuse() {
        let imageName = "pause.fill"
        let image = createSfImage(with: imageName)
        pausePlayButton.setImage(image, for: .normal)
        elapsedTimeLabel.text = ""
        activityIndicator.stopAnimating()
//        playbackSlider.setThumbImage( UIImage().withRenderingMode(.alwaysTemplate), for: .normal)

        [pausePlayButton, skipBackwardButton, skipForwardButton, elapsedTimeLabel, fullScreenModeBtn, minimizeVideoPlayerBtn].forEach { view in
            view.alpha = 0
        }
    }
    
    
    fileprivate func createButton(with systemName: String,
                                  imageSize: CGFloat = 20,
                                  backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.3), targetSelector: Selector) -> UIButton {
        
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: imageSize, weight: .regular, scale: .medium)
        let image = UIImage(systemName: systemName, withConfiguration:
                                config)?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.backgroundColor = backgroundColor
        button.alpha = 0
        button.addTarget(self, action: targetSelector, for: .primaryActionTriggered)
        return button
    }
    
    
    
    func initializePlayer(for url: URL) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.setUpPlayer(with: url)
        }
    }
    
    
    func isHidden(_ hide: Bool) {
        [pausePlayButton, skipBackwardButton, skipForwardButton, elapsedTimeLabel, fullScreenModeBtn, minimizeVideoPlayerBtn, playbackSlider].forEach { view in
            
            view.isHidden = hide
            
        }
    }
    
    
}





//MARK: - Video Player Setup & TearDown
extension VideoPlayerView {
    
    fileprivate func setUpPlayer(with url: URL) {
        cleanUpPlayerForReuse()
        let player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.player = player
        self.playerLayer = playerLayer
        thumbnailImageView.layer.addSublayer(playerLayer)
        self.player?.play()
        delegate?.videoPlayStatusChanged(isPlaying: true)
        setUpPeriodicTimeObserver()
        activityIndicator.stopAnimating()
        
        player.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        //alerts that video completed playing
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidPlayToEndTime(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }
    
    
    private func setUpPeriodicTimeObserver() {
        let interval = CMTime(seconds: 0.001,
                              preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        timeObserverToken = self.player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { [weak self] (elapsedTime) in
            
            self?.updateVideoPlayerState(with: elapsedTime)
            
        })
        
    }
    
    
    private  func updateVideoPlayerState(with elapsedTime: CMTime) {
        let seconds = CMTimeGetSeconds(elapsedTime)
        //lets move slider thumb
        guard let duration = player?.currentItem?.duration else {return}
        let durationSeconds = CMTimeGetSeconds(duration)
        let progress = Float(seconds / durationSeconds)
        playbackSlider.value = progress
        delegate?.handleUpdateSlideBar(with: progress)
        
        // Updating Elapsed Time
        let totalDurationInSeconds = CMTimeGetSeconds(duration)
        
        let secondsString = String(format: "%02d", Int(seconds .truncatingRemainder(dividingBy: 60)))
        
        let minutesString = String(format: "%02d", Int(seconds) / 60)
        
        let currentTime = "\(minutesString):\(secondsString)"
        
        guard totalDurationInSeconds.isFinite else {return}
        
        let videoLength = String(format: "%02d:%02d",Int((totalDurationInSeconds / 60)),Int(totalDurationInSeconds) % 60)
        
        elapsedTimeLabel.text = currentTime + " / " + videoLength
    }
    

    
    @objc fileprivate func playerDidPlayToEndTime(notification: Notification) {
        player?.seek(to: CMTime.zero)
        player?.play()
    }
    
    
    func cleanUpPlayerForReuse() {
       prepareViewForReuse()
       NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
            player?.replaceCurrentItem(with: nil)
            player = nil
            playerLayer = nil
            playbackSlider.value = 0
            isScrubAble = false
        }
    }
    
    
    
    //MARK: - Player Observer
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //This is when the player is ready and rendering frames
        if keyPath == "currentItem.loadedTimeRanges" {
            isScrubAble = true
        }
    }
    
}



//MARK: - Actions
extension VideoPlayerView {
    
    @objc fileprivate func handleSliderDragged( sender: UISlider) {
        guard let duration = player?.currentItem?.duration, isScrubAble else { return }
        let value = Float64(playbackSlider.value) * CMTimeGetSeconds(duration)
        let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
        player?.seek(to: seekTime)
    }
    
    
    
    @objc fileprivate func handleTapGestureAction() {
        switch videoPlayerMode {
        case .expanded:
            guard isScrubAble else {return}
            handleToggleControls()
        case .minimized:
            delegate?.handleMaximizeVideoPlayer()
        }
    }
    
    
    
    fileprivate func handleToggleControls() {
        [pausePlayButton, skipBackwardButton, skipForwardButton, elapsedTimeLabel, fullScreenModeBtn, minimizeVideoPlayerBtn].forEach { view in
            UIView.animate(withDuration: 0.4, delay: 0) {[weak view] in
                guard let view = view else {return}
                view.alpha = view.alpha == 0 ? 1 : 0
            }
        }
    }
    
    
    
    @objc  func didTapPausePlayButton() {
        guard let player = player else {return}
        if player.isPlaying {
            player.pause()
            delegate?.videoPlayStatusChanged(isPlaying: false)
        } else {
            player.play()
            delegate?.videoPlayStatusChanged(isPlaying: true)

        }
        pausePlayButton.setImage(player.icon, for: .normal)

    }
    
    
    @objc fileprivate func didTapSkipBackwardsButton() {
        guard let currentTime = player?.currentTime(), isScrubAble else { return }
        let currentTimeInSecondsMinus10 =  CMTimeGetSeconds(currentTime).advanced(by: -5)
        let seekTime = CMTime(value: CMTimeValue(currentTimeInSecondsMinus10), timescale: 1)
        player?.seek(to: seekTime)
    }
    
    
    @objc fileprivate func didTapSkipForwardsButton() {
        guard let currentTime = player?.currentTime(), isScrubAble else { return }
        let currentTimeInSecondsPlus10 =  CMTimeGetSeconds(currentTime).advanced(by: 5)
        let seekTime = CMTime(value: CMTimeValue(currentTimeInSecondsPlus10), timescale: 1)
        player?.seek(to: seekTime)
    }
    
    
    @objc fileprivate func didTapFullScreenModeButton() {
        print("didTapFullScreenModeButton")
    }
    
    
    @objc fileprivate func didTapMinimizePlayerButton() {
        delegate?.handleMinimizeVideoPlayer()
    }
   
}




// removes the corner radius that comes with default uislider class
class CustomSlider: UISlider {
   
   
   @IBInspectable var trackHeight: CGFloat = 3

   override func trackRect(forBounds bounds: CGRect) -> CGRect {
       return CGRect(origin: CGPoint(x: bounds.origin.x, y: bounds.origin.y + trackHeight), size: CGSize(width: bounds.width, height: trackHeight))
   }

   private var thumbFrame: CGRect {
       return thumbRect(forBounds: bounds, trackRect: trackRect(forBounds: bounds), value: value)
   }
}



extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
    
    var icon: UIImage {
        let imageName = isPlaying ? "pause.fill" : "play.fill"
        let image = createSfImage(with: imageName)
        return image
    }
}


func createSfImage(with systemName: String, pointSize: CGFloat = 30) -> UIImage {
    let config = UIImage.SymbolConfiguration(pointSize: pointSize, weight: .regular, scale: .medium)
    let image = UIImage(systemName: systemName, withConfiguration:
                            config)?.withRenderingMode(.alwaysTemplate)
    return image ?? UIImage()
}
