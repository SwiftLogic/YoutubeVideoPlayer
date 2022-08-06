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
        setUpPlayerViews()
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

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate let animationDuration: CGFloat = 0.4
    fileprivate var posts : [HomeFeedDataModel] = []
    
    
    
    fileprivate let videoPlayerMaxWidth: CGFloat = UIScreen.main.bounds.width
    
    fileprivate let collapsedModePadding = UIScreen.main.bounds.height - 120 // 120 is miniplayer height + tabbar height

    
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
    fileprivate func setUpCollectionView() {
        collectionView.register(HomeFeedCell.self, forCellWithReuseIdentifier: HomeFeedCell.cellReuseIdentifier)
        collectionView.register(ShortsContainerViewCell.self, forCellWithReuseIdentifier: ShortsContainerViewCell.cellReuseIdentifier)
        collectionView.backgroundColor = APP_BACKGROUND_COLOR
        collectionView.contentInset = .init(top: 8, left: 0, bottom: 0, right: 0)
        posts = HomeFeedDataModel.getMockData()
    }

    
    fileprivate func setUpPlayerViews() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {return}

        // videoPlayerContainerView
        window.addSubview(videoPlayerContainerView)
        videoPlayerContainerViewTopAnchor = videoPlayerContainerView.topAnchor.constraint(equalTo: window.topAnchor, constant: view.frame.height)
        videoPlayerContainerViewTopAnchor.isActive = true
        
        videoPlayerContainerView.anchor(top: nil, leading: window.leadingAnchor, bottom: nil, trailing: window.trailingAnchor, size: .init(width: 0, height: view.frame.height))
        
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
        
        setUpGestureRecognizers()
        
    }
    
    
    fileprivate func setUpGestureRecognizers() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        videoPlayerContainerView.addGestureRecognizer(panGestureRecognizer)
    }
    

    
}




//MARK: - Actions
extension HomeVC {
    
    
    fileprivate func minimizeVideoPlayerViewWidth() {
        // animates video player width into collapsed mode
        
        miniPlayerControlView.isHidden(false)

        if videoPlayerViewWidthAnchor.constant == videoPlayerMaxWidth {
            
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {return}
            
            videoPlayerViewWidthAnchor.constant = MINI_PLAYER_WIDTH
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseIn) {[ weak window] in
                
                window?.layoutIfNeeded()
            }
            
        }
    }
    
    
    fileprivate func maximizeVideoPlayerViewWidth() {
        isStatusBarHidden = true
        miniPlayerControlView.isHidden(true)

        // animate video player width back to expanded mode
        if videoPlayerViewWidthAnchor.constant < videoPlayerMaxWidth {
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {return}
            
            videoPlayerViewWidthAnchor.constant = videoPlayerMaxWidth
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn) {[ weak window] in

                window?.layoutIfNeeded()
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
         
            onGestureCompletion(gesture: gesture)
        default:
            break
        }
        
    }
    
    
    // Set's videoPlayerView back to open or collapsed position
    fileprivate func onGestureCompletion(gesture: UIPanGestureRecognizer) {
        
        let yTranslation: CGFloat = gesture.direction(in: view) == .down ? collapsedModePadding : 0
        
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {return}

        videoPlayerContainerViewTopAnchor.constant = yTranslation
        
        // 0 = expanded mode
        // collapsedModePadding mode
        if yTranslation == 0 {
            //expand
            videoPlayerViewHeightAnchor.constant = videoPlayerMaxHeight
        } else {
            //collapse
            videoPlayerViewHeightAnchor.constant = MINI_PLAYER_HEIGHT
            minimizeVideoPlayerViewWidth()
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

        videoPlayerContainerViewTopAnchor.constant = 0
        videoPlayerViewHeightAnchor.constant = videoPlayerMaxHeight

        // data binding
        let homeFeedData = posts[indexPath.item]
        miniPlayerControlView.configure(with: homeFeedData)
        let imageName = posts[indexPath.item].videoThumbnailImageUrl
        videoPlayerView.configure(with: UIImage(named: imageName))
        
        
        maximizeVideoPlayerViewWidth()

        
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





