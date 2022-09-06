//
//  Video.swift
//  YoutubeVideoPlayer
//
//  Created by Osaretin Uyigue on 7/27/22.
//

import UIKit
struct Video: Decodable {
    
    let channel: Channel
    let videoUrl: String
    let videoThumbnailImageUrl: String
    let videoTitle: String
    let videoDuration: String
    let creationDate: String
    let views: String
    let type: HomeFeedDataType
    
    
   
        
}



struct Channel: Decodable {
    let channelName: String
    let channelImageUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case channelName = "name"
        case channelImageUrl = "imageUrl"
    }
}



enum HomeFeedDataType: Int, Decodable {
    case normalYoutubeVideos
    case shortsYoutubeVideos
}


//MARK: - FIND A WAY TO DETERMINE DATA TYPE IS YOUTUBE SHORTS WITHOUT HAVING TO INITIALIZE: channel:  videoThumbnailImageUrl: videoTitle:  videoDuration:  creationDate:


struct ContentTableViewCellViewModel {
    let image: UIImage?
    let title: String?

    enum CellContent {
        case image(UIImage?)
        case title(String)
    }
    
    init(content: CellContent) {
        switch content {
        case let .image(image):
            self.image = image
            self.title = nil
        case let .title(title):
            self.title = title
            self.image = nil
        }
    }
}
