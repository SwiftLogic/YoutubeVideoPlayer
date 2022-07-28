//
//  HomeFeedDataModel.swift
//  YoutubeVideoPlayer
//
//  Created by Osaretin Uyigue on 7/27/22.
//

import UIKit
struct HomeFeedDataModel {
    
    let channel: Channel
    let videoThumbnailImageUrl: String
    let videoTitle: String
    let videoDuration: String
    let creationDate: String
    let type: HomeFeedDataType
    
    
   static func getMockData() -> [HomeFeedDataModel] {
        
        let hodge_twins_channel = Channel(channelName: "Hodge Twins", channelImageUrl: "hodge_twins_profile_picc")
        
        let hillsong_channel = Channel(channelName: "Hillsong Worship", channelImageUrl: "hsw")

        let sean_allen_channel = Channel(channelName: "Sean Allen", channelImageUrl: "sean_allen")
        
        let kavaSoft_channel = Channel(channelName: "Kavsoft", channelImageUrl: "kavasoft")
        
        let naturalGeoChannel = Channel(channelName: "Natural Geographic", channelImageUrl: "nat_geo")

        let cora_samChannel = Channel(channelName: "Cora & Sam", channelImageUrl: "image9")

        
        let post1 = HomeFeedDataModel(channel: hodge_twins_channel, videoThumbnailImageUrl: "hodgtwins_sandwich", videoTitle: "Eating Burger King's New Crispy Chicken Sandwich", videoDuration: "13:49", creationDate: "3 months ago", type: .normalYoutubeVideos)
        
        let post2 = HomeFeedDataModel(channel: hillsong_channel, videoThumbnailImageUrl: "what_a_beautifulname", videoTitle: "What A Beautiful Name - Hillsong Worship", videoDuration: "5:43", creationDate: "4 years ago", type: .normalYoutubeVideos)
        //shorts
        let post3 = HomeFeedDataModel(channel: hillsong_channel, videoThumbnailImageUrl: "still_hsw", videoTitle: "Still - Hillsong Worship", videoDuration: "6:20", creationDate: "6 years ago", type: .shortsYoutubeVideos)
        
        let post4 = HomeFeedDataModel(channel: hillsong_channel, videoThumbnailImageUrl: "image3", videoTitle: "Still - Hillsong Worship", videoDuration: "6:20", creationDate: "6 years ago", type: .normalYoutubeVideos)

        
        let post5 = HomeFeedDataModel(channel: sean_allen_channel, videoThumbnailImageUrl: "swiftUI_basics", videoTitle: "SwiftUI Basics Tutorial", videoDuration: "1:19:31", creationDate: "7 months ago", type: .normalYoutubeVideos)

        
        let post6 = HomeFeedDataModel(channel: hodge_twins_channel, videoThumbnailImageUrl: "kamala", videoTitle: "Kamala Harris Against New Voter ID", videoDuration: "15:28", creationDate: "19 hours ago", type: .normalYoutubeVideos)

        
        let post7 = HomeFeedDataModel(channel: kavaSoft_channel, videoThumbnailImageUrl: "image6", videoTitle: "Custom Tab Bar Using SwiftUI - Curved Tab Using SwiftUI - SwiftUI Tutorial", videoDuration: "8:21", creationDate: "1 year ago", type: .normalYoutubeVideos)

        
        let post8 = HomeFeedDataModel(channel: naturalGeoChannel, videoThumbnailImageUrl: "image13", videoTitle: "What a Beautiful View", videoDuration: "5:01", creationDate: "3 months ago", type: .normalYoutubeVideos)
       
       // shorts
       let post2ndShort = HomeFeedDataModel(channel: hillsong_channel, videoThumbnailImageUrl: "still_hsw", videoTitle: "Still - Hillsong Worship", videoDuration: "6:20", creationDate: "6 years ago", type: .shortsYoutubeVideos)


        let post9 = HomeFeedDataModel(channel: naturalGeoChannel, videoThumbnailImageUrl: "nat_geo", videoTitle: "Welcome to Our Channel", videoDuration: "0:30", creationDate: "10 years ago", type: .normalYoutubeVideos)

        let post10 = HomeFeedDataModel(channel: kavaSoft_channel, videoThumbnailImageUrl: "tabbarvideothumbnail", videoTitle: "SwiftUI 2.0 Animated Tab Bar - Bubble Tab Bar - SwiftUI Tutorials", videoDuration: "11:04", creationDate: "Premiered Dec 17, 2020", type: .normalYoutubeVideos)
        let post11 = HomeFeedDataModel(channel: kavaSoft_channel, videoThumbnailImageUrl: "pinchtozoomvideo", videoTitle: "Kavsoft - Easier Way To Learn SwiftUI", videoDuration: "24:53", creationDate: "11 months ago", type: .normalYoutubeVideos)

        let post12 = HomeFeedDataModel(channel: cora_samChannel, videoThumbnailImageUrl: "image2", videoTitle: "It's Osas's Dad Birthday", videoDuration: "11:01", creationDate: "4 weeks ago", type: .normalYoutubeVideos)
        
        let post13 = HomeFeedDataModel(channel: cora_samChannel, videoThumbnailImageUrl: "image3", videoTitle: "Our Cabo Vacation", videoDuration: "30:51", creationDate: "4 weeks ago", type: .normalYoutubeVideos)
        
        let post14 = HomeFeedDataModel(channel: cora_samChannel, videoThumbnailImageUrl: "image4", videoTitle: "Osa Enjoying Our Honeymoon", videoDuration: "25:01", creationDate: "2 weeks ago", type: .normalYoutubeVideos)

        
        let post15 = HomeFeedDataModel(channel: cora_samChannel, videoThumbnailImageUrl: "image5", videoTitle: "Summer Time Is Best  Time!!!", videoDuration: "5:00", creationDate: "1 week ago", type: .normalYoutubeVideos)

        
        let post16 = HomeFeedDataModel(channel: cora_samChannel, videoThumbnailImageUrl: "image6", videoTitle: "Visiting National Parks!", videoDuration: "13:51", creationDate: "2 months ago", type: .normalYoutubeVideos)
        
        let post17 = HomeFeedDataModel(channel: cora_samChannel, videoThumbnailImageUrl: "image7", videoTitle: "Our Time In NorthShore", videoDuration: "2:08", creationDate: "1 month ago", type: .normalYoutubeVideos)
        
        let post18 = HomeFeedDataModel(channel: cora_samChannel, videoThumbnailImageUrl: "image8", videoTitle: "We Love Art Exhibitions", videoDuration: "10:03", creationDate: "10 months ago", type: .normalYoutubeVideos)

        
        let post19 = HomeFeedDataModel(channel: cora_samChannel, videoThumbnailImageUrl: "image10", videoTitle: "Sam's Adventures", videoDuration: "11:19", creationDate: "1 minute ago", type: .normalYoutubeVideos)


       let secondPosts = [post11, post4, post5, post10, post6, post7, post8, post2ndShort, post9, post12, post13, post14, post15, post16, post17, post18, post19].shuffled()
        
         return [post1, post2, post3] + secondPosts

    }
    
    
    
        
}



struct Channel {
    let channelName: String
    let channelImageUrl: String
}



enum HomeFeedDataType {
    case normalYoutubeVideos
    case shortsYoutubeVideos
}


//MARK: - FIND A WAY TO DETERMINE DATA TYPE IS YOUTUBE SHORTS WITHOUT HAVING TO INITIALIZE: channel:  videoThumbnailImageUrl: videoTitle:  videoDuration:  creationDate:


struct YouTubeVideo {
    let channel: Channel
    let videoThumbnailImageUrl: String
    let videoTitle: String
    let videoDuration: String
    let creationDate: String
}



struct HomeContentViewModel {
    let youtubeVideo: YouTubeVideo?
}


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
