//
//  MockData.swift
//  YoutubeVideoPlayer
//
//  Created by Osaretin Uyigue on 9/6/22.
//

import Foundation

enum MockData {    
    static func videoListData() -> Data {
        let fileName = "mockFeedData"
        return readJSONData(fromFile: fileName)
    }
    
    static private func readJSONData(fromFile filename: String) -> Data {
        guard let filePath = Bundle.main.url(forResource: filename, withExtension: "json"),
              let data = NSData(contentsOf: filePath) else {return Data()}
        
        return data as Data
    }
}


