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



//MARK: - MiniPlayerControlViewDelegate
protocol MiniPlayerControlViewDelegate: AnyObject {
    func handleExpandVideoPlayer()
    func handleDismissVideoPlayer()
}



//MARK: - VideoPlayerView
protocol VideoPlayerViewDelegate: AnyObject {
    func handleMinimizeVideoPlayer()
    func handleMaximizeVideoPlayer()
    func handleUpdateSlideBar(with progress: Float)
}
