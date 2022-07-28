//
//  ShortsContainerViewCell.swift
//  YoutubeVideoPlayer
//
//  Created by Osaretin Uyigue on 7/27/22.
//

import UIKit
class ShortsContainerViewCell: UICollectionViewCell {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        backgroundColor = APP_BACKGROUND_COLOR

    }
    
    
    
    
    //MARK: - Properties
    static let cellReuseIdentifier = String(describing: ShortsContainerViewCell.self)

   fileprivate let imageNames = (2...13).map{"image\($0)"}.shuffled()

    fileprivate let shortsTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Shorts"
        label.textColor = .white
        return label
    }()
    
    
    fileprivate let betaTextLabel: UILabel = {
        let label = UILabel()
        label.text = "beta"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    fileprivate let shortsLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = YOUTUBE_SHORTS_IMAGE
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
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
    
    
    
    fileprivate let topLineSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 55, green: 55, blue: 55)
        return view
    }()
    
    fileprivate let bottomLineSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 55, green: 55, blue: 55)
        return view
    }()
    
    
    
    
    //MARK: - Handlers
    
    fileprivate func setUpViews() {
        addSubview(shortsLogoImageView)
        addSubview(shortsTextLabel)
        addSubview(betaTextLabel)
        addSubview(collectionView)

        shortsLogoImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10, left: 15, bottom: 0, right: 0), size: .init(width: 30, height: 30))
        
        shortsTextLabel.anchor(top: nil, leading: shortsLogoImageView.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 5, bottom: 0, right: 0))
        shortsTextLabel.centerYAnchor.constraint(equalTo: shortsLogoImageView.centerYAnchor).isActive = true
        
        betaTextLabel.anchor(top: nil, leading: shortsTextLabel.trailingAnchor, bottom: shortsTextLabel.topAnchor, trailing: nil, padding: .init(top: 0, left: 3, bottom: -12, right: 0))
        
        collectionView.anchor(top: shortsLogoImageView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 15, left: 0, bottom: 10, right: 0))
        
        collectionView.register(PreviewShortsCell.self, forCellWithReuseIdentifier: PreviewShortsCell.cellReuseIdentifier)
        
        collectionView.contentInset = .init(top: 0, left: HORIZONTAL_PADDING, bottom: 0, right: HORIZONTAL_PADDING)

    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



//MARK: - CollectionView Delegate
extension ShortsContainerViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviewShortsCell.cellReuseIdentifier, for: indexPath) as! PreviewShortsCell
        let imageName = imageNames[indexPath.item]
        cell.configure(with: imageName)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: frame.width / 2.2, height: collectionView.frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }
}
