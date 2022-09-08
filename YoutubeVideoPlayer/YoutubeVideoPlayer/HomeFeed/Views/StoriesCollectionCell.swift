//
//  StoriesCollectionCell.swift
//  YoutubeVideoPlayer
//
//  Created by Osaretin Uyigue on 9/8/22.
//

import UIKit
class StoriesCollectionCell: UICollectionViewCell {
    
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        backgroundColor = APP_BACKGROUND_COLOR
        handleLoadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    //MARK: - Properties
    var stories = [UserStory]()

    fileprivate let topLineSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    fileprivate let storiesLabel: UILabel = {
        let label = UILabel()
        label.text = "Stories"
        label.textColor = .white
        return label
    }()
    
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = APP_BACKGROUND_COLOR
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    
    
    
    
    
    //MARK: - Handlers
    
    fileprivate func setUpViews() {
        addSubview(topLineSeperator)
        addSubview(storiesLabel)
        addSubview(collectionView)

        topLineSeperator.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, size: .init(width: 0, height: 0.5))
        
        storiesLabel.anchor(top: topLineSeperator.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10, left: HORIZONTAL_PADDING, bottom: 0, right: 0))
        
        collectionView.anchor(top: storiesLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 10, left: 0, bottom: 10, right: 0))
        
        collectionView.register(PreviewStoryCell.self, forCellWithReuseIdentifier: PreviewStoryCell.cellReuseIdentifier)
        
        collectionView.contentInset = .init(top: 0, left: HORIZONTAL_PADDING, bottom: 0, right: HORIZONTAL_PADDING)
        
    }
    
    
    func handleLoadData() {
        let data = [UserStory.init(username: "Emmanuel", profileImageUrl: "imageplaceholder"), UserStory.init(username: "YungJunko", profileImageUrl: "imageplaceholder"), UserStory.init(username: "WorthTheHype", profileImageUrl: "imageplaceholder"), UserStory.init(username: "HodgeTwins", profileImageUrl: "imageplaceholder"), UserStory.init(username: "Dr. SaxLove", profileImageUrl: "imageplaceholder"), UserStory.init(username: "VacationLife is Good", profileImageUrl: "imageplaceholder")].shuffled()
        stories = data
        collectionView.reloadData()
    }
    
    
}



//MARK: - CollectionView Delegate & DataSource
extension StoriesCollectionCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviewStoryCell.cellReuseIdentifier, for: indexPath) as! PreviewStoryCell
        cell.story = stories[indexPath.item]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: frame.width / 3.5, height: collectionView.frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stories.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            
            
            let copyLinkOptions = UIAction(title: "Copy",
                                      image: UIImage(systemName: "link"),
                                      identifier: nil,
                                      discoverabilityTitle: nil,
                                      state: .off) { _ in
                print("tapped open")
            }
            
            
            let favoriteOption = UIAction(title: "Favorite",
                                          image: UIImage(systemName: "star"),
                                          identifier: nil,
                                          discoverabilityTitle: nil,
                                          state: .off) { _ in
                print("tapped favoriteOption")
            }
            
            
            let shareOption = UIAction(title: "Share",
                                       image: UIImage(systemName: "square.and.arrow.up"),
                                       identifier: nil,
                                       discoverabilityTitle: nil,
                                       state: .off) { _ in
                print("tapped favoriteOption")
            }
            
            
            let playOptions = UIAction(title: "Play",
                                       image: UIImage(systemName: "play"),
                                       identifier: nil,
                                       discoverabilityTitle: nil,
                                       state: .off) { _ in
                print("tapped bookmarkOption")
            }
            
            
            let reportOptions = UIAction(title: "Report",
                                        image: UIImage(systemName: "flag"),
                                        identifier: nil,
                                        discoverabilityTitle: nil,
                                        state: .off) { _ in
                print("tapped deleteOption")
            }
            
            return UIMenu(title: "",
                          image: nil,
                          identifier: nil,
                          options: .displayInline,
                          children: [playOptions, favoriteOption, shareOption, copyLinkOptions, reportOptions])
        }
        
        return config
    }
    
    
    
}
