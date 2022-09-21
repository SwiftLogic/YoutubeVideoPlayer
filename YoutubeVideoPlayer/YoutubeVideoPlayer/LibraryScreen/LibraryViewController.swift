//
//  LibraryViewController.swift
//  YoutubeVideoPlayer
//
//  Created by Osaretin Uyigue on 9/21/22.
//



import UIKit
enum LibrarySections: CaseIterable {
    case recentlyWatchedVideos
    case actionButtons
    case playlists
}

extension Int {
    static let playlists = 2
}

fileprivate let actionButtonsCellReuseIdentifier = "actionButtonsCellReuseIdentifier"
fileprivate let playlistCellReuseIdentifier = "playlistCellReuseIdentifier"

fileprivate let playlistHeaderReuseIdentifier = "playlistHeaderReuseIdentifier"
fileprivate let footerReuseIdentifier = "footerReuseIdentifier"
class LibraryViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        handleSetUpNavBar()
    }
    
    
    
    //MARK: - View LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleRefreshNavigationBar()
    }

    
    //MARK: - Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    
    fileprivate let librarySections: [LibrarySections] = LibrarySections.allCases
    
  fileprivate let playlists = [Playlist.init(thumbnailImageUrl: "tabbarvideothumbnail", playlistTitle: "All Thing SwiftUI", numberOfContent: "124 videos"), Playlist.init(thumbnailImageUrl: "swiftUI_basics", playlistTitle: "Computer Science", numberOfContent: "89 videos"), Playlist.init(thumbnailImageUrl: "image13", playlistTitle: "The binary mind", numberOfContent: "32 videos"), Playlist.init(thumbnailImageUrl: "what_a_beautifulname", playlistTitle: "Christian music", numberOfContent: "155 videos"), Playlist.init(thumbnailImageUrl: "still_hsw", playlistTitle: "Praise & Worship", numberOfContent: "287 videos"), Playlist.init(thumbnailImageUrl: "image10", playlistTitle: "Vacation Goals", numberOfContent: "120 videos")]
   
    
    
    //MARK: - Handlers
    fileprivate func setUpCollectionView() {
        collectionView.register(RecentlyViewedVideosContainerCell.self, forCellWithReuseIdentifier: RecentlyViewedVideosContainerCell.cellReuseIdentifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: actionButtonsCellReuseIdentifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: playlistCellReuseIdentifier)
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: playlistHeaderReuseIdentifier)
        collectionView.backgroundColor = APP_BACKGROUND_COLOR
        view.backgroundColor = APP_BACKGROUND_COLOR
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = .init(top: 8, left: 0, bottom: 0, right: 0)
    }
    
    
    
    fileprivate func handleSetUpCell(section: Int, indexPath: IndexPath) -> UICollectionViewCell {
        switch librarySections[indexPath.section] {
            
        case .recentlyWatchedVideos:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentlyViewedVideosContainerCell.cellReuseIdentifier, for: indexPath) as! RecentlyViewedVideosContainerCell
            return cell
            
        case .actionButtons:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: actionButtonsCellReuseIdentifier, for: indexPath)
            cell.backgroundColor = .yellow

            return cell
            
        case .playlists:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: playlistCellReuseIdentifier, for: indexPath)
            cell.backgroundColor = .green

            return cell
        }
        
    }
    
    
    //MARK: - CollectionView Protocols
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return handleSetUpCell(section: indexPath.section, indexPath: indexPath)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch librarySections[indexPath.section] {
            
        case .recentlyWatchedVideos, .actionButtons:
            return .init(width: view.frame.width, height: 220)

        case .playlists:
            return .init(width: view.frame.width, height: 50)

        }

    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return librarySections.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        switch librarySections[section] {
            
        case .recentlyWatchedVideos, .actionButtons:
            return 1

        case .playlists:
            return playlists.count

        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return section == .playlists ? .init(top: 20, left: 0, bottom: 0, right: 0) : .zero
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: playlistHeaderReuseIdentifier, for: indexPath)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return section == .playlists ? .init(width: view.frame.width, height: 75) : .zero
    }
    
}
