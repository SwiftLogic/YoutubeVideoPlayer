//
//  Protocols.swift
//  YoutubeVideoPlayer
//
//  Created by Osaretin Uyigue on 8/6/22.
//

import Foundation

//MARK: - StatusBarHiddenDelegate
protocol StatusBarHiddenDelegate: AnyObject {
    func handleUpdate(isStatusBarHidden: Bool)
}



//MARK: - HomeVCDelegate
protocol HomeVCDelegate: AnyObject {
    func handleOpenVideoPlayer(for homeFeedData: HomeFeedDataModel)
}
