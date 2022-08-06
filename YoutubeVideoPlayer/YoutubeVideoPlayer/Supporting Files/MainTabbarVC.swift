//
//  MainTabbarVC.swift
//  YoutubeVideoPlayer
//
//  Created by Osaretin Uyigue on 7/27/22.
//

import UIKit
class MainTabbarVC: UITabBarController {
    
    
    //MARK: - View's LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpGestureRecognizers()

    }
    
    //MARK: - Properties
    enum VideoPlayerMode: Int {
        case expanded, minimized
    }
    
    
    fileprivate var videoPlayerMode: VideoPlayerMode = .expanded
    
    
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
        view.backgroundColor = APP_BACKGROUND_COLOR
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    fileprivate var videoPlayerViewHeightAnchor = NSLayoutConstraint()
    fileprivate var videoPlayerViewWidthAnchor = NSLayoutConstraint()
    fileprivate let videoPlayerMaxHeight: CGFloat = UIScreen.main.bounds.width * 9 / 16 //16 x 9 is the aspect ration of most of youtube's HD videos

    
    fileprivate let videoPlayerView: VideoPlayerView = {
        let view = VideoPlayerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    fileprivate let miniPlayerControlView: MiniPlayerControlView = {
        let view = MiniPlayerControlView()
        return view
    }()
    
    
    //MARK: - Methods
    fileprivate func setUpViews() {
        let homeVC = HomeVC()
        homeVC.delegate = self
        
        lazy var homeNavController = handleCreateTab(with: homeVC, title: "Home", selectedImage: HOME_SELECTED_IMAGE, image: HOME_UNSELECTED_IMAGE)

        viewControllers = [homeNavController, shortsController, createController, subsController, libraryController]
    
        setUpPlayerViews()
    }
    
    
    
    fileprivate func setUpPlayerViews() {

        // videoPlayerContainerView
        view.addSubview(videoPlayerContainerView)
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
    
}


final class LightContentNavController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
}


//MARK: - HomeVCDelegate
extension MainTabbarVC: HomeVCDelegate {
    
    func handleOpenVideoPlayer(for homeFeedData: HomeFeedDataModel) {
        // data binding
        miniPlayerControlView.configure(with: homeFeedData)
        let imageName = homeFeedData.videoThumbnailImageUrl
        videoPlayerView.configure(with: UIImage(named: imageName))
        expandVideoPlayer()
    }
    
}




//MARK: - VideoPlayer Actions
extension MainTabbarVC {
    
    
    @objc fileprivate func expandVideoPlayer() {
        videoPlayerContainerViewTopAnchor.constant = 0
        videoPlayerViewHeightAnchor.constant = videoPlayerMaxHeight
        maximizeVideoPlayerViewWidth()
//        isStatusBarHidden = true
        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn) {[weak view] in
            view?.layoutIfNeeded()
            print("expandVideoPlayer")
        }
    }
    
    
    fileprivate func minimizeVideoPlayer() {
        videoPlayerContainerViewTopAnchor.constant = collapsedModePadding
        videoPlayerViewHeightAnchor.constant = MINI_PLAYER_HEIGHT
        minimizeVideoPlayerViewWidth()
//        isStatusBarHidden = false
        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.7, options: .curveEaseIn) {[weak view] in
            view?.layoutIfNeeded()
        }
    }
    
    
    fileprivate func minimizeVideoPlayerViewWidth() {
        // animates video player width into collapsed mode
        
        miniPlayerControlView.isHidden(false)

        if videoPlayerViewWidthAnchor.constant == videoPlayerMaxWidth {
            
            
            videoPlayerViewWidthAnchor.constant = MINI_PLAYER_WIDTH
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseIn) {[ weak view] in
                
                view?.layoutIfNeeded()
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
                print("maximizeVideoPlayerViewWidth")
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
//        isStatusBarHidden = false
        //minimizes video player as user drags down and makes sure it never gets smaller than minVideoPlayerHeight
        let heightLimit: CGFloat = 120
        if videoPlayerViewHeightAnchor.constant > heightLimit {
            videoPlayerViewHeightAnchor.constant -= 2
        }
    }
    
    
    
   
    
    @objc fileprivate func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
            
        case .changed:
            
            let yTranslation = gesture.translation(in: view).y
            dragVideoPlayerContainerView(to: yTranslation)
            
            // animates videoPlayerView Dimensions based on gesture directions
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



#if canImport(SwiftUI) && DEBUG
import SwiftUI

let deviceNames: [String] = [
    "iPhone 11 Pro Max"
]

@available(iOS 13.0, *)
struct ViewController_Preview: PreviewProvider {
    static var previews: some View {
        ForEach(deviceNames, id: \.self) { deviceName in
            UIViewControllerPreview {
                MainTabbarVC()
            }.previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
                .ignoresSafeArea()
        }
    }
}
#endif
