//
//  PreviewStoryCell.swift
//  YoutubeVideoPlayer
//
//  Created by Osaretin Uyigue on 9/8/22.
//

import UIKit
class PreviewStoryCell: UICollectionViewCell {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Properties
    static let cellReuseIdentifier = String(describing: PreviewStoryCell.self)
    
   
    
    
    
    
    //MARK: - Handlers
    
    fileprivate func setUpViews() {
        
        
    }
    
    
    
    
    
}

struct UserStory {
    
    let username: String
    let profileImageUrl: String
    
    
}
