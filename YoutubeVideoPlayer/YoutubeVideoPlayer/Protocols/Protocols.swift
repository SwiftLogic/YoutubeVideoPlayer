//
//  Protocols.swift
//  YoutubeVideoPlayer
//
//  Created by Osaretin Uyigue on 8/6/22.
//

import UIKit

//MARK: - StatusBarHiddenDelegate
protocol StatusBarHiddenDelegate: AnyObject {
    func handleUpdate(isStatusBarHidden: Bool)
}



//MARK: - HomeVCDelegate
protocol HomeVCDelegate: AnyObject {
    func handleOpenVideoPlayer(for url: URL, content: FeedContent)
}



//MARK: - MiniPlayerControlViewDelegate
protocol MiniPlayerControlViewDelegate: AnyObject {
    func handleExpandVideoPlayer()
    func handleDismissVideoPlayer()
    func handleChangePlayStatus(play: Bool)
}



//MARK: - VideoPlayerView
protocol VideoPlayerViewDelegate: AnyObject {
    func handleMinimizeVideoPlayer()
    func handleMaximizeVideoPlayer()
    func handleUpdateSlideBar(with progress: Float)
    func videoPlayStatusChanged(isPlaying: Bool)
}
