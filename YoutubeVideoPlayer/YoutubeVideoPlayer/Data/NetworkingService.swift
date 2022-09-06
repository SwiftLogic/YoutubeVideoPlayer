//
//  NetworkingService.swift
//  YoutubeVideoPlayer
//
//  Created by Osaretin Uyigue on 9/6/22.
//

import Foundation
import Combine

class NetworkingService {
    //MARK: - Methods
    static func fetchVideos() -> Future<Data, Error> {
        return Future { promise in
            let videosData = MockData.videoListData()
            promise(.success(videosData))
        }
    }
    
}
