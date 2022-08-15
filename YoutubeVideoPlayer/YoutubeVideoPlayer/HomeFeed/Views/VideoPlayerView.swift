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
    
    
    deinit {
        tearDownVideoPlayer()
    }
    
    //MARK: - Properties
    fileprivate var timeObserverToken: Any?
    
    fileprivate var videoURL: String? {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
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
    
    
    fileprivate var player: AVPlayer?
    fileprivate var playerLayer: AVPlayerLayer?
    
    
    
    fileprivate lazy var playbackSlider: CustomSlider = {
        let slider = CustomSlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = UIColor(white: 0.5, alpha: 0.8)
        slider.thumbTintColor = .red
        slider.setThumbImage( UIImage().withRenderingMode(.alwaysTemplate), for: .normal)
        slider.setThumbImage(#imageLiteral(resourceName: "thumb").withRenderingMode(.alwaysOriginal), for: .highlighted)
        slider.addTarget(self, action: #selector(handleSliderDragged), for: .valueChanged)
        return slider
    }()

    
    
    //MARK: - Methods
    fileprivate func setUpViews() {
        addSubview(thumbnailImageView)
        addSubview(playbackSlider)
        thumbnailImageView.fillSuperview()
        let playbackSliderHeight: CGFloat = 10
        playbackSlider.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0),  size: .init(width: 0, height: playbackSliderHeight))
    }
    
    
    
    func configure(with image: UIImage?) {
        thumbnailImageView.image = image
        videoURL =  "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
        
        
//        "https://player.vimeo.com/external/587646755.hd.mp4?s=c6f18daeca03bfd4f07ee7ffd702dfd88254a6ff&profile_id=174"
        
//        "https://player.vimeo.com/progressive_redirect/playback/694704491/rendition/360p?loc=external&oauth2_token_id=1027659655&signature=6f4425e6cbc3e6c9dfe7a01f60ab993bcf297393152794a8aa9f409173b78244"
        
//        "https://player.vimeo.com/external/487508532.sd.mp4?s=dfb8c469317bd740e8beec7b0b0db0675cef880e&profile_id=164"
    }
    
    
    
    fileprivate func setUpPlayer() {
        tearDownVideoPlayer()
        
        guard let videoUrlUnwrapped = videoURL,
              let url = URL(string: videoUrlUnwrapped) else {return}
        
        let player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.player = player
        self.playerLayer = playerLayer
        thumbnailImageView.layer.addSublayer(playerLayer)
        self.player?.play()
        
        setUpPeriodicTimeObserver()
       
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
        playbackSlider.value = Float(seconds / durationSeconds)
    }
    
    
    @objc fileprivate func playerDidPlayToEndTime(notification: Notification) {
        player?.seek(to: CMTime.zero)
        player?.play()
    }
    
    
    func tearDownVideoPlayer() {
       NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
            player?.replaceCurrentItem(with: nil)
            player = nil
            playerLayer = nil
            playbackSlider.value = 0
        }
    }
    
    
   
}



//MARK: - Actions
extension VideoPlayerView {
    
    @objc fileprivate func handleSliderDragged( sender: UISlider) {
        guard let duration = player?.currentItem?.duration else { return }
        let value = Float64(playbackSlider.value) * CMTimeGetSeconds(duration)
        let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
        player?.seek(to: seekTime)
    }
   
}





// removes the corner radius that comes with default uislider class
class CustomSlider: UISlider {
   
   
   @IBInspectable var trackHeight: CGFloat = 5

   override func trackRect(forBounds bounds: CGRect) -> CGRect {
       return CGRect(origin: CGPoint(x: bounds.origin.x, y: bounds.origin.y + trackHeight), size: CGSize(width: bounds.width, height: trackHeight))
   }

   private var thumbFrame: CGRect {
       return thumbRect(forBounds: bounds, trackRect: trackRect(forBounds: bounds), value: value)
   }

   

}

//
//open class VideoView: UIView {
//
//    public enum Repeat {
//        case once
//        case loop
//    }
//
//    override open class var layerClass: AnyClass {
//        return AVPlayerLayer.self
//    }
//
//    private var playerLayer: AVPlayerLayer {
//        return self.layer as! AVPlayerLayer
//    }
//
//    public var player: AVPlayer? {
//        get {
//            self.playerLayer.player
//        }
//        set {
//            self.playerLayer.player = newValue
//        }
//    }
//
//
//    open override var contentMode: UIView.ContentMode {
//        didSet {
//            switch self.contentMode {
//            case .scaleAspectFit:
//                self.playerLayer.videoGravity = .resizeAspect
//            case .scaleAspectFill:
//                self.playerLayer.videoGravity = .resizeAspectFill
//            default:
//                self.playerLayer.videoGravity = .resize
//            }
//        }
//    }
//
//    public var `repeat`: Repeat = .once
//
//    public var url: URL? {
//        didSet {
//            guard let url = self.url else {
//                self.teardown()
//                return
//            }
//            self.setup(url: url)
//        }
//    }
//
//    @available(*, unavailable)
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        self.initialize()
//    }
//
//    @available(*, unavailable)
//    public required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//
//        self.initialize()
//    }
//
//    public init() {
//        super.init(frame: .zero)
//
//        self.translatesAutoresizingMaskIntoConstraints = false
//
//        self.initialize()
//    }
//
//    open func initialize() {
//
//    }
//
//    deinit {
//        self.teardown()
//    }
//
//
//    private func setup(url: URL) {
//
//        self.player = AVPlayer(playerItem: AVPlayerItem(url: url))
//
//        self.player?.currentItem?.addObserver(self,
//                                              forKeyPath: "status",
//                                              options: [.old, .new],
//                                              context: nil)
//
//        self.player?.addObserver(self, forKeyPath: "rate", options: [.old, .new], context: nil)
//
//
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(self.itemDidPlayToEndTime(_:)),
//                                               name: .AVPlayerItemDidPlayToEndTime,
//                                               object: self.player?.currentItem)
//
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(self.itemFailedToPlayToEndTime(_:)),
//                                               name: .AVPlayerItemFailedToPlayToEndTime,
//                                               object: self.player?.currentItem)
//    }
//
//    private func teardown() {
//        self.player?.pause()
//
//        self.player?.currentItem?.removeObserver(self, forKeyPath: "status")
//
//        self.player?.removeObserver(self, forKeyPath: "rate")
//
//        NotificationCenter.default.removeObserver(self,
//                                                  name: .AVPlayerItemDidPlayToEndTime,
//                                                  object: self.player?.currentItem)
//
//        NotificationCenter.default.removeObserver(self,
//                                                  name: .AVPlayerItemFailedToPlayToEndTime,
//                                                  object: self.player?.currentItem)
//
//        self.player = nil
//    }
//
//
//
//    @objc func itemDidPlayToEndTime(_ notification: NSNotification) {
//        guard self.repeat == .loop else {
//            return
//        }
//        self.player?.seek(to: .zero)
//        self.player?.play()
//    }
//
//    @objc func itemFailedToPlayToEndTime(_ notification: NSNotification) {
//        self.teardown()
//    }
//
//
//    open override func observeValue(forKeyPath keyPath: String?,
//                                          of object: Any?,
//                                          change: [NSKeyValueChangeKey : Any]?,
//                                          context: UnsafeMutableRawPointer?) {
//        if keyPath == "status", let status = self.player?.currentItem?.status, status == .failed {
//            self.teardown()
//        }
//
//        if
//            keyPath == "rate",
//            let player = self.player,
//            player.rate == 0,
//            let item = player.currentItem,
//            !item.isPlaybackBufferEmpty,
//            CMTimeGetSeconds(item.duration) != CMTimeGetSeconds(player.currentTime())
//        {
//            self.player?.play()
//        }
//    }
//}
//
//
//
