//
//  RecentlyViewedVideosContainerCell.swift
//  YoutubeVideoPlayer
//
//  Created by Osaretin Uyigue on 9/21/22.
//



import UIKit
class RecentlyViewedVideosContainerCell: UICollectionViewCell {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Properties
   
    static let cellReuseIdentifier = String(describing: RecentlyViewedVideosContainerCell.self)
    fileprivate let recentLabel: UILabel = {
        let label = UILabel()
        label.text = "Recent"
        label.textColor = .white
        return label
    }()
    
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = APP_BACKGROUND_COLOR
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = .init(top: 0, left: HORIZONTAL_PADDING, bottom: 0, right: HORIZONTAL_PADDING)
        return collectionView
    }()
    
    fileprivate let lineSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    
    
    //MARK: - Handlers
    
    fileprivate func setUpViews() {
        addSubview(recentLabel)
        addSubview(collectionView)
        addSubview(lineSeperator)
        
        recentLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 8, left: HORIZONTAL_PADDING, bottom: 0, right: 0))
        
        
        collectionView.anchor(top: recentLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 10, left: 0, bottom: 25, right: 0))
        
        
        collectionView.register(RecentlyViewedVideoCell.self, forCellWithReuseIdentifier: RecentlyViewedVideoCell.cellReuseIdentifier)
        
        lineSeperator.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 10, right: 0), size: .init(width: 0, height: 0.5))
        
    }
    
    
    
}


//MARK: - CollectionView Protocols
extension RecentlyViewedVideosContainerCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentlyViewedVideoCell.cellReuseIdentifier, for: indexPath) as! RecentlyViewedVideoCell
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: frame.width / 2.3, height: collectionView.frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
}


