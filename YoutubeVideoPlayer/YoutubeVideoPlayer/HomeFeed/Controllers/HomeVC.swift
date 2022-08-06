//
//  ViewController.swift
//  YoutubeVideoPlayer
//
//  Created by Osaretin Uyigue on 7/27/22.
//

import UIKit
protocol HomeVCDelegate: AnyObject {
    func handleOpenVideoPlayer(for homeFeedData: HomeFeedDataModel)
}
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
//        setUpPlayerViews()
//        setUpGestureRecognizers()

    }
    
    
    //MARK: - Properties
    enum VideoPlayerMode: Int {
        case expanded, minimized
    }
    
    weak var delegate: HomeVCDelegate?
    
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
    fileprivate var posts : [HomeFeedDataModel] = []
    
    
    
    //MARK: - Methods
    fileprivate func setUpCollectionView() {
        collectionView.register(HomeFeedCell.self, forCellWithReuseIdentifier: HomeFeedCell.cellReuseIdentifier)
        collectionView.register(ShortsContainerViewCell.self, forCellWithReuseIdentifier: ShortsContainerViewCell.cellReuseIdentifier)
        collectionView.backgroundColor = APP_BACKGROUND_COLOR
        collectionView.contentInset = .init(top: 8, left: 0, bottom: 0, right: 0)
        posts = HomeFeedDataModel.getMockData()
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
        let homeFeedData = posts[indexPath.item]
        delegate?.handleOpenVideoPlayer(for: homeFeedData)
    }
    
}


//
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
//




