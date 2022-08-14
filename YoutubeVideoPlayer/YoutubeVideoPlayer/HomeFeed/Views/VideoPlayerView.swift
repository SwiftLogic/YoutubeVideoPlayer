//
//  VideoPlayerView.swift
//  YoutubeVideoPlayer
//
//  Created by Osaretin Uyigue on 8/6/22.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Properties
    fileprivate var videoURL: String? {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.setUpPlayer()
            }
        }
    }
    
    
    
    
    fileprivate let thumbnailImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
   fileprivate var player: AVPlayer = {
        let player = AVPlayer()
        return player
    }()
    
    
    fileprivate var playerLayer: AVPlayerLayer = {
        let playerLayer = AVPlayerLayer()
        return playerLayer
    }()
    
    
    
    fileprivate lazy var videoSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = UIColor(white: 0.5, alpha: 0.5)
        slider.thumbTintColor = .red
        slider.setThumbImage( UIImage().withRenderingMode(.alwaysTemplate), for: .normal)
        //        slider.setThumbImage(#imageLiteral(resourceName: "thumb").withRenderingMode(.alwaysOriginal), for: .normal)
        //        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        return slider
    }()

    
    
    //MARK: - Methods
    fileprivate func setUpViews() {
        addSubview(thumbnailImageView)
        addSubview(videoSlider)
        thumbnailImageView.fillSuperview()
        videoSlider.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: -1.5, bottom: 0, right: -1.5),  size: .init(width: 0, height: 2))
        
    }
    
    
    
    func configure(with image: UIImage?) {
        thumbnailImageView.image = image
        videoURL = "https://player.vimeo.com/progressive_redirect/playback/694704491/rendition/360p?loc=external&oauth2_token_id=1027659655&signature=6f4425e6cbc3e6c9dfe7a01f60ab993bcf297393152794a8aa9f409173b78244"
        
//        "https://player.vimeo.com/external/487508532.sd.mp4?s=dfb8c469317bd740e8beec7b0b0db0675cef880e&profile_id=164"
    }
    
    
    
    fileprivate func setUpPlayer() {
        guard let videoUrlUnwrapped = videoURL else {return}
        guard let url = URL(string: videoUrlUnwrapped) else {return}
        let player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.player = player
        self.playerLayer = playerLayer
        thumbnailImageView.layer.addSublayer(playerLayer)
        self.player.play()
        
        
//
//        //track player progress
        let interval = CMTime(seconds: 0.01,
                                  preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        self.player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { [weak self] (progressTime) in
            let seconds = CMTimeGetSeconds(progressTime)

            //lets move slider thumb
            if let duration = self?.player.currentItem?.duration {
                let durationSeconds = CMTimeGetSeconds(duration)

                self?.videoSlider.value = Float(seconds / durationSeconds)
            }
        })
        
        //alerts that video completed playing
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidPlayToEndTime(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }
    
    
    
    @objc fileprivate func playerDidPlayToEndTime(notification: Notification) {
        player.seek(to: CMTime.zero)
        player.play()
    }
    
}


import UIKit
import AVFoundation

open class VideoView: UIView {

    public enum Repeat {
        case once
        case loop
    }

    override open class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    private var playerLayer: AVPlayerLayer {
        return self.layer as! AVPlayerLayer
    }

    public var player: AVPlayer? {
        get {
            self.playerLayer.player
        }
        set {
            self.playerLayer.player = newValue
        }
    }


    open override var contentMode: UIView.ContentMode {
        didSet {
            switch self.contentMode {
            case .scaleAspectFit:
                self.playerLayer.videoGravity = .resizeAspect
            case .scaleAspectFill:
                self.playerLayer.videoGravity = .resizeAspectFill
            default:
                self.playerLayer.videoGravity = .resize
            }
        }
    }

    public var `repeat`: Repeat = .once

    public var url: URL? {
        didSet {
            guard let url = self.url else {
                self.teardown()
                return
            }
            self.setup(url: url)
        }
    }

    @available(*, unavailable)
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.initialize()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.initialize()
    }

    public init() {
        super.init(frame: .zero)

        self.translatesAutoresizingMaskIntoConstraints = false

        self.initialize()
    }

    open func initialize() {

    }

    deinit {
        self.teardown()
    }


    private func setup(url: URL) {

        self.player = AVPlayer(playerItem: AVPlayerItem(url: url))

        self.player?.currentItem?.addObserver(self,
                                              forKeyPath: "status",
                                              options: [.old, .new],
                                              context: nil)

        self.player?.addObserver(self, forKeyPath: "rate", options: [.old, .new], context: nil)


        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.itemDidPlayToEndTime(_:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: self.player?.currentItem)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.itemFailedToPlayToEndTime(_:)),
                                               name: .AVPlayerItemFailedToPlayToEndTime,
                                               object: self.player?.currentItem)
    }

    private func teardown() {
        self.player?.pause()

        self.player?.currentItem?.removeObserver(self, forKeyPath: "status")

        self.player?.removeObserver(self, forKeyPath: "rate")

        NotificationCenter.default.removeObserver(self,
                                                  name: .AVPlayerItemDidPlayToEndTime,
                                                  object: self.player?.currentItem)

        NotificationCenter.default.removeObserver(self,
                                                  name: .AVPlayerItemFailedToPlayToEndTime,
                                                  object: self.player?.currentItem)

        self.player = nil
    }



    @objc func itemDidPlayToEndTime(_ notification: NSNotification) {
        guard self.repeat == .loop else {
            return
        }
        self.player?.seek(to: .zero)
        self.player?.play()
    }

    @objc func itemFailedToPlayToEndTime(_ notification: NSNotification) {
        self.teardown()
    }


    open override func observeValue(forKeyPath keyPath: String?,
                                          of object: Any?,
                                          change: [NSKeyValueChangeKey : Any]?,
                                          context: UnsafeMutableRawPointer?) {
        if keyPath == "status", let status = self.player?.currentItem?.status, status == .failed {
            self.teardown()
        }

        if
            keyPath == "rate",
            let player = self.player,
            player.rate == 0,
            let item = player.currentItem,
            !item.isPlaybackBufferEmpty,
            CMTimeGetSeconds(item.duration) != CMTimeGetSeconds(player.currentTime())
        {
            self.player?.play()
        }
    }
}
