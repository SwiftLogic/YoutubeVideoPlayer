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
    
    
    fileprivate var feedContentList : [FeedContent] = []
    
    
    
    //MARK: - Methods
    fileprivate func setUpCollectionView() {
        collectionView.register(HomeFeedCell.self, forCellWithReuseIdentifier: HomeFeedCell.cellReuseIdentifier)
        collectionView.register(ShortsContainerViewCell.self, forCellWithReuseIdentifier: ShortsContainerViewCell.cellReuseIdentifier)
        collectionView.register(CommunityPostCell.self, forCellWithReuseIdentifier: CommunityPostCell.cellReuseIdentifier)
        collectionView.register(StoriesCollectionCell.self, forCellWithReuseIdentifier: StoriesCollectionCell.cellReuseIdentifier)
        collectionView.backgroundColor = UIColor.rgb(red: 55, green: 55, blue: 55)
//        collectionView.contentInset = .init(top: 8, left: 0, bottom: 0, right: 0)
    }


}



//MARK: -  API Call
extension HomeVC {
    
    fileprivate func fetchVideos() {
        anyCancellable = NetworkingService.fetchVideos()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:()
                case .failure(let error):
                    print("error fetching promise: \(error)")
                }
            } receiveValue: { [weak self]data in
                self?.parseVideos(from: data)
            }
    }
    
    
    fileprivate func parseVideos(from data: Data) {
        let decoder = JSONDecoder()
        do {
            let videos = try decoder.decode([FeedContent].self, from: data)
            self.feedContentList = videos
            self.collectionView.reloadData()
        } catch let decoderError {
            print("failed to decode videoList Data: ", decoderError)
        }
    }
    
}


//MARK: - CollectionView Delegate & DataSource
extension HomeVC: UICollectionViewDelegateFlowLayout {
    
    fileprivate func setUpCells(with video: FeedContent, indexPath: IndexPath) -> UICollectionViewCell {
        
        switch video.type {
        
        case .normalYoutubeVideos:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeFeedCell.cellReuseIdentifier, for: indexPath) as! HomeFeedCell
            let content = feedContentList[indexPath.item]
            cell.configure(with: content)
            return cell
            
        case .shortsYoutubeVideos:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShortsContainerViewCell.cellReuseIdentifier, for: indexPath) as! ShortsContainerViewCell
            let content = feedContentList[indexPath.item]
            cell.bind(shorts: content.shorts ?? [])
            return cell
            
        case .communityPost:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommunityPostCell.cellReuseIdentifier, for: indexPath) as! CommunityPostCell
            let content = feedContentList[indexPath.item]
            let imageHeight = content.post?.imageHeight ?? 0
            cell.thumbnailHeightConstraint.constant = imageHeight
            cell.layoutIfNeeded()
            cell.post = content.post
            return cell
            
        case .stories:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoriesCollectionCell.cellReuseIdentifier, for: indexPath) as! StoriesCollectionCell
            return cell
        }
        
    }
    
    
  
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return setUpCells(with: feedContentList[indexPath.item], indexPath: indexPath)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let content = feedContentList[indexPath.item]

        switch content.type {
        case .normalYoutubeVideos:
            var newHeight = AppConstant.thumbnailImageHeight
            newHeight += 35 + 8
            newHeight += 35//30
            return .init(width: view.frame.width, height: newHeight)
            
        case .shortsYoutubeVideos:
            return .init(width: view.frame.width, height: 320)
            
        case .communityPost:
            var imageHeight = content.post?.imageHeight ?? 0
            imageHeight += 35 // profileImageViewDimen
            imageHeight += 10 // profileImageView top padding
            imageHeight += 10 // captionLabel top padding
            imageHeight += 5 // thumbnailImageView top padding
            imageHeight += 12 // likeButton top padding
            imageHeight += 80 // extra spacing to prevent content hugging
            return .init(width: view.frame.width, height: imageHeight)
        case .stories:
            return .init(width: view.frame.width, height: 270)
        }
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedContentList.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let homeFeedData = feedContentList[indexPath.item]
        delegate?.handleOpenVideoPlayer(for: homeFeedData)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}

//MARK: - StatusBarHiddenDelegate
extension HomeVC: StatusBarHiddenDelegate {
    func handleUpdate(isStatusBarHidden: Bool) {
        self.isStatusBarHidden = isStatusBarHidden
    }
}

