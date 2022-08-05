//
//  ViewController.swift
//  YoutubeVideoPlayer
//
//  Created by Osaretin Uyigue on 7/27/22.
//

import UIKit

class HomeVC: UICollectionViewController {
    
    //MARK: - Init
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - View's LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = APP_BACKGROUND_COLOR
        handleSetUpNavBar()
        setUpCollectionView()
        setUpViews()
    }
    
    
    //MARK: - Properties
    
    
    
    var isStatusBarHidden: Bool = false {
        didSet {
            if oldValue != self.isStatusBarHidden {
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }

    override var prefersStatusBarHidden: Bool {
        return self.isStatusBarHidden
    }

    
    
    fileprivate let animationDuration: CGFloat = 0.4
    fileprivate var posts : [HomeFeedDataModel] = []
    
    
    
    fileprivate var playerViewTopAnchor = NSLayoutConstraint()
    fileprivate var videoPlayerViewHeightAnchor = NSLayoutConstraint()
    fileprivate var videoPlayerViewWidthAnchor = NSLayoutConstraint()

    
    fileprivate let videoPlayerMaxHeight: CGFloat = UIScreen.main.bounds.width * 9 / 16 //16 x 9 is the aspect ration of most of youtube's HD videos
    
    fileprivate let videoPlayerMaxWidth: CGFloat = UIScreen.main.bounds.width
    
    fileprivate let collapsedModePadding = UIScreen.main.bounds.height - 120 // 120 is miniplayer height + tabbar height

    fileprivate let playerContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = APP_BACKGROUND_COLOR
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    fileprivate let videoPlayerView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
//        view.backgroundColor = APP_BACKGROUND_COLOR.withAlphaComponent(0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    fileprivate let miniPlayerControlView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        return view
    }()
    
    
    //MARK: - Methods
    fileprivate func setUpCollectionView() {
        collectionView.register(HomeFeedCell.self, forCellWithReuseIdentifier: HomeFeedCell.cellReuseIdentifier)
        collectionView.register(ShortsContainerViewCell.self, forCellWithReuseIdentifier: ShortsContainerViewCell.cellReuseIdentifier)
        collectionView.backgroundColor = APP_BACKGROUND_COLOR
        collectionView.contentInset = .init(top: 8, left: 0, bottom: 0, right: 0)
        posts = HomeFeedDataModel.getMockData()
    }

    
    fileprivate func setUpViews() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {return}

        // playerContainerView
        window.addSubview(playerContainerView)
        playerViewTopAnchor = playerContainerView.topAnchor.constraint(equalTo: window.topAnchor, constant: view.frame.height)
        playerViewTopAnchor.isActive = true
        
        playerContainerView.anchor(top: nil, leading: window.leadingAnchor, bottom: nil, trailing: window.trailingAnchor, size: .init(width: 0, height: view.frame.height))
        
        // videoPlayerView
        playerContainerView.addSubview(videoPlayerView)
        videoPlayerView.anchor(top: playerContainerView.topAnchor, leading: playerContainerView.leadingAnchor, bottom: nil, trailing: nil)
        
        videoPlayerViewHeightAnchor = videoPlayerView.heightAnchor.constraint(equalToConstant: videoPlayerMaxHeight)
        videoPlayerViewHeightAnchor.isActive = true
        
        videoPlayerViewWidthAnchor = videoPlayerView.widthAnchor.constraint(equalToConstant: videoPlayerMaxWidth)
        
        videoPlayerViewWidthAnchor.isActive = true
        
        
        playerContainerView.addSubview(miniPlayerControlView)
        miniPlayerControlView.anchor(top: videoPlayerView.topAnchor, leading: videoPlayerView.trailingAnchor, bottom: videoPlayerView.bottomAnchor, trailing: playerContainerView.trailingAnchor)
        
        setUpGestureRecognizers()
        
    }
    
    
    fileprivate func setUpGestureRecognizers() {
        let swipeGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        playerContainerView.addGestureRecognizer(swipeGestureRecognizer)
    }
    

    
}




//MARK: - Actions
extension HomeVC {
    
    
    fileprivate func collapseVideoPlayerView() {
        // animate video player width in to collapsed mode
        if videoPlayerViewWidthAnchor.constant == videoPlayerMaxWidth {
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {return}
            
            videoPlayerViewWidthAnchor.constant = MINI_PLAYER_WIDTH
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn) {[ weak window] in
                
                window?.layoutIfNeeded()
            }
            
        }
    }
    
    
    fileprivate func expandVideoPlayer() {
        isStatusBarHidden = true
        // animate video player width back to expanded mode
        if videoPlayerViewWidthAnchor.constant < videoPlayerMaxWidth {
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {return}
            
            videoPlayerViewWidthAnchor.constant = videoPlayerMaxWidth
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn) {[ weak window] in

                window?.layoutIfNeeded()
            }
            
            
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn) {[weak window] in
//                window?.layoutIfNeeded()
//
//            } completion: {[weak self] onComplete in
//                self?.isStatusBarHidden = true
//
//            }

            
        }
    }
    
    @objc fileprivate func panGestureRecognizerAction(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .changed:
            
            let translatedYPoint = translation.y
            
            // moves the containerview
            if playerViewTopAnchor.constant < 0 {
                playerViewTopAnchor.constant = 0 // Prevents user from dragging mediaPickerView past 0
            } else {
                playerViewTopAnchor.constant += translatedYPoint // Allows user to drag
            }
            
            
            
            
            
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {return}

            switch gesture.direction(in: window) {
                
            case .Up:
                
                //maximize video player as user drags up and makes sure it never gets bigger than maxVideoPlayerHeight
                if videoPlayerViewHeightAnchor.constant < videoPlayerMaxHeight {
                    videoPlayerViewHeightAnchor.constant += 2
                }
                
                
                expandVideoPlayer()
                
                
                
                
            case .Down:
                isStatusBarHidden = false

                //minimizes video player as user drags down and makes sure it never gets smaller than minVideoPlayerHeight
                if videoPlayerViewHeightAnchor.constant > MINI_PLAYER_HEIGHT {
                    videoPlayerViewHeightAnchor.constant -= 2
                }
                
                
                
            default:
                break
            }
            
            
            gesture.setTranslation(.zero, in: view)
            
        case .failed, .cancelled, .ended:
         
            onGestureCompletion(gesture: gesture)
        default:
            break
        }
        
    }
    
    
    // Set mediaPickerView back to open or collapsed position
    fileprivate func onGestureCompletion(gesture: UIPanGestureRecognizer) {
        
        let yTranslation: CGFloat = gesture.direction(in: view) == .Down ? collapsedModePadding : 0
        
        
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {return}

        playerViewTopAnchor.constant = yTranslation
        if yTranslation == 0 {
            //expand
            videoPlayerViewHeightAnchor.constant = videoPlayerMaxHeight
        } else {
            //collapse
            videoPlayerViewHeightAnchor.constant = MINI_PLAYER_HEIGHT
            collapseVideoPlayerView()


        }
        
        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.7, options: .curveEaseIn) {[weak window] in
            window?.layoutIfNeeded()
        }
    }
        
    
    
}


//MARK: - CollectionView Delegate & DataSource
extension HomeVC: UICollectionViewDelegateFlowLayout {

    
    fileprivate func setUpCells(with post: HomeFeedDataModel, indexPath: IndexPath) -> UICollectionViewCell {
        
        switch post.type {
        
        case .normalYoutubeVideos:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeFeedCell.cellReuseIdentifier, for: indexPath) as! HomeFeedCell
            let post = posts[indexPath.item]
            cell.configure(with: post)
            let newHeight = computeImageViewHeight(withImage: posts[indexPath.item].videoThumbnailImageUrl)
            cell.thumbnailHeightConstraint.constant = newHeight
            cell.layoutIfNeeded()
            return cell
            
        case .shortsYoutubeVideos:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShortsContainerViewCell.cellReuseIdentifier, for: indexPath) as! ShortsContainerViewCell
            return cell
            
        }
        
    }
    
    
  
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return setUpCells(with: posts[indexPath.item], indexPath: indexPath)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let dataType = posts[indexPath.item].type
        let imageName = posts[indexPath.item].videoThumbnailImageUrl
        
        switch dataType {
        
        case .normalYoutubeVideos:
                   
            var newHeight = computeImageViewHeight(withImage: imageName)
            newHeight += 35 + 8
            newHeight += 30
            return .init(width: view.frame.width, height: newHeight)
            
        case .shortsYoutubeVideos:
            return .init(width: view.frame.width, height: 320)
        }
        
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {return}

        playerViewTopAnchor.constant = 0
        videoPlayerViewHeightAnchor.constant = videoPlayerMaxHeight

        let imageName = posts[indexPath.item].videoThumbnailImageUrl
        videoPlayerView.image = UIImage(named: imageName)
        expandVideoPlayer()

        
        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn) {[weak window] in
            window?.layoutIfNeeded()
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



