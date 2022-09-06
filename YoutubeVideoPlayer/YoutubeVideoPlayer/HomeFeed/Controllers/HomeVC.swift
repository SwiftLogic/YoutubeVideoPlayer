//
//  ViewController.swift
//  YoutubeVideoPlayer
//
//  Created by Osaretin Uyigue on 7/27/22.
//

import UIKit
import Combine
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
        fetchVideos()
    }
    
    
    //MARK: - Properties
    fileprivate var anyCancellable: AnyCancellable?

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
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        get {
            return .slide
        }
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



//MARK: -  API Call
extension HomeVC {
    
    fileprivate func fetchVideos() {
        anyCancellable = NetworkingService.fetchVideos()
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished promise")
                    
                case .failure(let error):
                    print("error fetching promise: \(error)")
                    
                }
            } receiveValue: { [weak self]data in
                self?.parseVideos(from: data)
                print("promise videosdata: \(data)")
            }
    }
    
    
    fileprivate func parseVideos(from data: Data) {
        let decoder = JSONDecoder()
        do {
            let videoList = try decoder.decode([HomeFeedDataModel].self, from: data)
            print("firstVideoChannelName: ", videoList.first?.channel.channelName ?? "")
            print("videosCount: ", videoList.count)
        } catch let decoderError {
            print("failed to decode videoList Data: ", decoderError)
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
        let homeFeedData = posts[indexPath.item]
        delegate?.handleOpenVideoPlayer(for: homeFeedData)
    }
    
}

//MARK: - StatusBarHiddenDelegate
extension HomeVC: StatusBarHiddenDelegate {
    func handleUpdate(isStatusBarHidden: Bool) {
        self.isStatusBarHidden = isStatusBarHidden
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
