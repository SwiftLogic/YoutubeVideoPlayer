//
//  FeedContent.swift
//  YoutubeVideoPlayer
//
//  Created by Osaretin Uyigue on 7/27/22.
//

import UIKit
struct FeedContent: Decodable {
    var stories: [UserStory]?
    var post: YoutubeCommunityPost?
    var channel: Channel?
    var videoUrl: String?
    let videoThumbnailImageUrl: String?
    let videoTitle: String?
    var videoDuration: String?
    var creationDate: String?
    let views: String?
    let type: HomeFeedDataType
    var shorts: [YoutubeShort]?
    
    
    var channelUnwrapped: Channel {
        return channel ?? .init(channelName: "", channelImageUrl: "")
    }
    
    var videoUrlUnwrapped: String {
        return videoUrl ?? ""
    }
       
    
    var thumbnailImageUrlUnwrapped: String {
        return videoThumbnailImageUrl ?? ""
    }
    
    
    var videoTitleUnwrapped: String {
        return videoTitle ?? ""
    }
    
    var videoDurationUnwrapped: String {
        return videoDuration ?? ""
    }
    
        
    var creationDateUnwrapped: String {
        return creationDate ?? ""
    }
    
    var viewsUnwrapped: String {
        return views ?? ""
    }
    
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
    case communityPost
    case stories
}


struct YoutubeShort: Decodable {
    var title, imageUrl, views: String
}


struct YoutubeCommunityPost: Decodable {
    let profileImageUrl, channelName, creationDate, caption, likeCount, commentCount: String
    let thumbnailImageUrl: String?
    let imageHeight: CGFloat?
}




//struct ContentTableViewCellViewModel {
//    let image: UIImage?
//    let title: String?
//
//    enum CellContent {
//        case image(UIImage?)
//        case title(String)
//    }
//
//    init(content: CellContent) {
//        switch content {
//        case let .image(image):
//            self.image = image
//            self.title = nil
//        case let .title(title):
//            self.title = title
//            self.image = nil
//        }
//    }
//}




//
//"shorts": ["https://i.ytimg.com/vi/ohRO9Cwu_vg/mqdefault.jpg"],
//"videoTitle": "When She Says, I have a Boyfriend",
//"views": "258K views",
//"type": 1
