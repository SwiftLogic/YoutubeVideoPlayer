//
//  MainTabbarVC.swift
//  YoutubeVideoPlayer
//
//  Created by Osaretin Uyigue on 7/27/22.
//

import UIKit
import Combine
enum VideoPlayerMode: Int {
    case expanded, minimized
}
class MainTabbarVC: UITabBarController {
    
    
    //MARK: - View's LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpGestureRecognizers()
        setUpTabBarAppearance()
        listenForExtractedURL()
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isTabBarHidden {
            let offset = tabBar.frame.height
            let tabBar = tabBar
            tabBar.frame = tabBar.frame.offsetBy(dx: 0, dy: offset)
        }
    }

    
    //MARK: - Properties
    weak var statusBarHiddenDelegate: StatusBarHiddenDelegate?
    fileprivate var isTabBarHidden = false {
        didSet {
            playbackSlider.isHidden = isTabBarHidden
        }
    }

    
    
    ///🐞 this breaks when we exit app to background mode, the animator stops responding to pan interaction
//   fileprivate lazy var propertyAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeIn) {[weak self] in
//       guard let self = self else {return}
//       self.detailsContainerView.alpha = 0.9
//       let offset = self.tabBar.frame.height
//       self.tabBar.frame = self.tabBar.frame.offsetBy(dx: 0, dy: -offset)
//    }
//
    
   fileprivate var isStatusBarHidden: Bool = false {
        didSet {
            if oldValue != self.isStatusBarHidden {
                statusBarHiddenDelegate?.handleUpdate(isStatusBarHidden: isStatusBarHidden)
            }
        }
    }

    
    fileprivate var videoPlayerMode: VideoPlayerMode = .expanded {
        didSet {
            videoPlayerView.videoPlayerMode = videoPlayerMode
        }
    }
    
    lazy var shortsController = handleCreateTab(with: UIViewController(), title: "Shorts", selectedImage: SHORTS_SELECTED_IMAGE, image: SHORTS_IMAGE)

    lazy var createController = handleCreateTab(with: UIViewController(), title: nil, selectedImage: CREATE_POST_IMAGE, image: CREATE_POST_IMAGE)
    
    lazy var subsController = handleCreateTab(with: UIViewController(), title: "Subscriptions", selectedImage: SUBSCRIPTION_SELECTED_IMAGE, image: SUBSCRIPTION_UNSELECTED_IMAGE)
    
    lazy var libraryController = handleCreateTab(with: UIViewController(), title: "Library", selectedImage: LIBRARY_SELECTED_IMAGE, image: LIBRARY_UNSELECTED_IMAGE)
    
    
    
    fileprivate let animationDuration: CGFloat = 0.4

    
    fileprivate let videoPlayerMaxWidth: CGFloat = UIScreen.main.bounds.width
    
    fileprivate lazy var playerSpacingAboveTabbar = tabBar.frame.height + MINI_PLAYER_HEIGHT
    fileprivate lazy var collapsedModePadding: CGFloat = UIScreen.main.bounds.height - playerSpacingAboveTabbar //+ MINI_PLAYER_HEIGHT // 120 is miniplayer height + tabbar height


    fileprivate var videoPlayerContainerViewTopAnchor = NSLayoutConstraint()
    fileprivate let videoPlayerContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    fileprivate var videoPlayerViewHeightAnchor = NSLayoutConstraint()
    fileprivate var videoPlayerViewWidthAnchor = NSLayoutConstraint()
    fileprivate let videoPlayerMaxHeight: CGFloat = UIScreen.main.bounds.width * 9 / 16 //16 x 9 is the aspect ration of most of youtube's HD videos

    
    fileprivate lazy var videoPlayerView: VideoPlayerView = {
        let view = VideoPlayerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    
    fileprivate lazy var miniPlayerControlView: MiniPlayerControlView = {
        let view = MiniPlayerControlView()
        view.delegate = self
        return view
    }()
    
    fileprivate var detailsContainerViewAlpha: CGFloat = 1.0
    fileprivate let detailsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = APP_BACKGROUND_COLOR
        return view
    }()
    
    
    fileprivate let playbackSlider: CustomSlider = {
        let slider = CustomSlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = UIColor(white: 0.5, alpha: 0.5)
        slider.thumbTintColor = .red
        slider.setThumbImage( UIImage().withRenderingMode(.alwaysTemplate), for: .normal)
        slider.setThumbImage( UIImage().withRenderingMode(.alwaysTemplate), for: .highlighted)
        slider.isHidden = true
        return slider
    }()
    
    
    fileprivate let urlExtractor: URLExtractor = {
        let linkExtractor  = URLExtractor()
        return linkExtractor
    }()
    
    //MARK: - Methods
    fileprivate func setUpTabBarAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        let tabBarItemAppearance = UITabBarItemAppearance()
        
        tabBarItemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        tabBarItemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        tabBarAppearance.configureWithDefaultBackground()
        tabBarAppearance.backgroundColor = APP_BACKGROUND_COLOR
        
        tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance
        tabBar.barTintColor = APP_BACKGROUND_COLOR
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
    }
    
    
    fileprivate func setUpViews() {
        
        let homeVC = HomeVC()
        homeVC.delegate = self
        statusBarHiddenDelegate = homeVC
        
        lazy var homeNavController = handleCreateTab(with: homeVC, title: "Home", selectedImage: HOME_SELECTED_IMAGE, image: HOME_UNSELECTED_IMAGE)

        viewControllers = [homeNavController, shortsController, createController, subsController, libraryController]
        
        configureTabImageInset()
        setUpPlayerViews()
        
    }
    
    
    
    fileprivate func configureTabImageInset() {
        guard let items = self.tabBar.items else {return}
        for (specificIndex, tabbarItem)  in items.enumerated() {
            if specificIndex == 2 {
                tabbarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            }
        }
    }
    
    
    fileprivate func setUpPlayerViews() {

        // videoPlayerContainerView
        view.insertSubview(videoPlayerContainerView, belowSubview: tabBar) // this is important because it allows us to be able to interact with the player in minimized mode
        videoPlayerContainerViewTopAnchor = videoPlayerContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        videoPlayerContainerViewTopAnchor.isActive = true
        
        videoPlayerContainerView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: view.frame.height))
        
        // videoPlayerView
        videoPlayerContainerView.addSubview(videoPlayerView)
        videoPlayerView.anchor(top: videoPlayerContainerView.topAnchor, leading: videoPlayerContainerView.leadingAnchor, bottom: nil, trailing: nil)
        
        videoPlayerViewHeightAnchor = videoPlayerView.heightAnchor.constraint(equalToConstant: videoPlayerMaxHeight)
        videoPlayerViewHeightAnchor.isActive = true
        
        videoPlayerViewWidthAnchor = videoPlayerView.widthAnchor.constraint(equalToConstant: videoPlayerMaxWidth)
        
        videoPlayerViewWidthAnchor.isActive = true
        
        // miniPlayerControlView
        videoPlayerContainerView.addSubview(miniPlayerControlView)
        miniPlayerControlView.anchor(top: videoPlayerView.topAnchor, leading: videoPlayerView.trailingAnchor, bottom: videoPlayerView.bottomAnchor, trailing: videoPlayerContainerView.trailingAnchor)
        
        // detailsContainerView
        videoPlayerContainerView.addSubview(detailsContainerView)
        detailsContainerView.anchor(top: videoPlayerView.bottomAnchor, leading: videoPlayerContainerView.leadingAnchor, bottom: videoPlayerContainerView.bottomAnchor, trailing: videoPlayerContainerView.trailingAnchor)
        
        // playbackSlider
        videoPlayerContainerView.addSubview(playbackSlider)

        let playbackSliderHeight: CGFloat = 10
        playbackSlider.anchor(top: nil, leading: tabBar.leadingAnchor, bottom: tabBar.topAnchor, trailing: tabBar.trailingAnchor, padding: .init(top: 0, left: 0, bottom: -5, right: 0),  size: .init(width: 0, height: playbackSliderHeight))

                
    }
    
    
    fileprivate func setUpGestureRecognizers() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        videoPlayerContainerView.addGestureRecognizer(panGestureRecognizer)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(expandVideoPlayer))
        videoPlayerView.addGestureRecognizer(tapGesture)
        
    }
    
    
    
    
    fileprivate func handleCreateTab(with controller: UIViewController, title: String?, selectedImage: UIImage?, image: UIImage?) -> UINavigationController {
        let navController = LightContentNavController(rootViewController: controller)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.tabBarItem.selectedImage = selectedImage
        tabBar.unselectedItemTintColor = UIColor.white
        tabBar.tintColor = .white
        return navController
        
    }
    
    
    
    fileprivate var extractedURL: URL?
    fileprivate var subscriptions = Set<AnyCancellable>()

    fileprivate func listenForExtractedURL() {
        urlExtractor.publishExtractedURL
            .receive(on: DispatchQueue.main)
            .sink { subscription in
                switch subscription {
                    
                case .finished:
                    ()
                }
            } receiveValue: {[weak self] url in
                self?.extractedURL = url
            }.store(in: &subscriptions)
    }
    
}


//MARK: - HomeVCDelegate
extension MainTabbarVC: HomeVCDelegate {
    
    func handleOpenVideoPlayer(for content: FeedContent) {
        
        miniPlayerControlView.configure(with: content)
        
        // setup video thumbnail
        let imageUrl = content.thumbnailImageUrlUnwrapped
        videoPlayerView.cleanUpPlayerForReuse()
        videoPlayerView.thumbnailImageView.getImage(for: imageUrl)

        // load url extractor
        guard let url = URL(string: content.videoUrl ?? "") else {return}
        urlExtractor.load(youtubeVideoLink: url)
        
        // wait for extractor to extract streammable url and pass it to video player
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            guard let videoURL = self.extractedURL else {return}
            self.videoPlayerView.initializePlayer(for: videoURL)
        }
        
        
        expandVideoPlayer()
    }
    
}




//MARK: - VideoPlayer Actions
extension MainTabbarVC {
    
    @objc fileprivate func expandVideoPlayer() {
        videoPlayerView.isHidden(false)
        isTabBarHidden = true
//        propertyAnimator.fractionComplete = 0.0
        videoPlayerContainerViewTopAnchor.constant = 0
        videoPlayerViewHeightAnchor.constant = videoPlayerMaxHeight
        maximizeVideoPlayerViewWidth()
        isStatusBarHidden = true
        videoPlayerMode = .expanded
        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn) {[weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    
    fileprivate func minimizeVideoPlayer() {
        videoPlayerView.isHidden(true)
        isTabBarHidden = false
//        propertyAnimator.fractionComplete = 1.0
        videoPlayerContainerViewTopAnchor.constant = collapsedModePadding
        videoPlayerViewHeightAnchor.constant = MINI_PLAYER_HEIGHT
        minimizeVideoPlayerViewWidth()
        isStatusBarHidden = false
        videoPlayerMode = .minimized
        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.7, options: .curveEaseIn) {[weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    
    fileprivate func minimizeVideoPlayerViewWidth() {
        // animates video player width into collapsed mode
        
        miniPlayerControlView.isHidden(false)

        if videoPlayerViewWidthAnchor.constant == videoPlayerMaxWidth {
            
            videoPlayerViewWidthAnchor.constant = MINI_PLAYER_WIDTH
            
//            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseIn) {[ weak view] in
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut) { [weak self] in
                self?.view.layoutIfNeeded()
            }
            
        }
    }
    
    
    fileprivate func maximizeVideoPlayerViewWidth() {
        
        miniPlayerControlView.isHidden(true)

        // animate video player width back to expanded mode
        if videoPlayerViewWidthAnchor.constant < videoPlayerMaxWidth {
            
            
            videoPlayerViewWidthAnchor.constant = videoPlayerMaxWidth
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn) {[ weak view] in
                view?.layoutIfNeeded()
            }
            
        }
    }
    
    
    
    fileprivate func dragVideoPlayerContainerView(to yPoint: CGFloat) {
        // Prevents user from dragging videoPlayerContainerView past 0
        if videoPlayerContainerViewTopAnchor.constant < 0 {
            videoPlayerContainerViewTopAnchor.constant = 0
        } else {
            // Allows us to  drag the videoPlayerContainerView up & down
            videoPlayerContainerViewTopAnchor.constant += yPoint
        }
        
    }
    
    
    fileprivate func increaseVideoPlayerViewHeight() {
        //maximizes the video player as user drags up and makes sure it never gets bigger than maxVideoPlayerHeight
        if videoPlayerViewHeightAnchor.constant < videoPlayerMaxHeight {
            videoPlayerViewHeightAnchor.constant += 2
        }
    }
    
    
   fileprivate func decreaseVideoPlayerViewHeight() {
        isStatusBarHidden = false
        //minimizes video player as user drags down and makes sure it never gets smaller than minVideoPlayerHeight
        let heightLimit: CGFloat = 120
        if videoPlayerViewHeightAnchor.constant > heightLimit {
            videoPlayerViewHeightAnchor.constant -= 2
        }
    }
    
    
    
    @objc fileprivate func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            let translation = gesture.translation(in: view)
            dragVideoPlayerContainerView(to: translation.y)
            // animates videoPlayerView Dimensions based on gesture directions
            
//            let percent : CGFloat  = gesture.view!.frame.origin.y/view.frame.size.height
//            propertyAnimator.fractionComplete = percent
//            
            videoPlayerView.isHidden(true)
            playbackSlider.isHidden = true


            switch gesture.direction(in: view) {
            case .up:
                increaseVideoPlayerViewHeight()
                maximizeVideoPlayerViewWidth()
              
            case .down:
                decreaseVideoPlayerViewHeight()
            default:
                break
            }
            
            gesture.setTranslation(.zero, in: view)
            
        case .failed, .cancelled, .ended:
            videoPlayerMode = gesture.direction(in: view) == .down ? .minimized : .expanded
            onGestureCompletion(mode: videoPlayerMode)
            
        default:
            break
        }
    }
    
    
    fileprivate func onGestureCompletion(mode: VideoPlayerMode) {
        switch mode {
        case .expanded:
            expandVideoPlayer()
        case .minimized:
            minimizeVideoPlayer()
        }
    }
    
}



//MARK: - MiniPlayerControlViewDelegate
extension MainTabbarVC: MiniPlayerControlViewDelegate {
    
    func handleExpandVideoPlayer() {
        expandVideoPlayer()
    }
    
    
    func handleDismissVideoPlayer() {
        videoPlayerView.cleanUpPlayerForReuse()
        videoPlayerContainerViewTopAnchor.constant = view.frame.height
        playbackSlider.isHidden = true
        playbackSlider.value = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn) {[ weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    
    func handleChangePlayStatus(play: Bool) {
        videoPlayerView.didTapPausePlayButton()
    }
    
}


//MARK: - VideoPlayerViewDelegate
extension MainTabbarVC: VideoPlayerViewDelegate {
    func handleMinimizeVideoPlayer() {
        minimizeVideoPlayer()
    }
    
    
    func handleMaximizeVideoPlayer() {
        expandVideoPlayer()
    }
    
    func handleUpdateSlideBar(with progress: Float) {
        playbackSlider.value = progress
    }
    
    
    func videoPlayStatusChanged(isPlaying: Bool) {
        let imageName = isPlaying ? "pause.fill" : "play.fill"
        miniPlayerControlView.updatePlayButton(with: imageName, isPlaying: isPlaying)
    }
}


//
//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//let deviceNames: [String] = [
//    "iPhone 11 Pro Max"
//]
//
//@available(iOS 13.0, *)
//struct ViewController_Preview: PreviewProvider {
//    static var previews: some View {
//        ForEach(deviceNames, id: \.self) { deviceName in
//            UIViewControllerPreview {
//                MainTabbarVC()
//            }.previewDevice(PreviewDevice(rawValue: deviceName))
//                .previewDisplayName(deviceName)
//                .ignoresSafeArea()
//        }
//    }
//}
//#endif
