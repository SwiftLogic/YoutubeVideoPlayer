//
//  VideoDownloader.swift
//  YoutubeVideoPlayer
//
//  Created by Osaretin Uyigue on 9/11/22.
//

import UIKit
import WebKit
import Combine
//downloads video from remote server once we extra the url from javascript injection SEE UIWEBVIEW Delegate

class VideoDownloader: NSObject {
    
    //MARK: - Init
    
    
    //MARK: - Properties
    fileprivate var videoURL: URL? {
        didSet {
            guard let videoURL = videoURL else {
                return
            }
            extractedURLPublisher.send(videoURL)
        }
    }
    
    var extractedURLPublisher = PassthroughSubject<URL, Never>()
    
    fileprivate lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        return webView
    }()
    
    
    //MARK: - Methods
    func loadUrl(from urlLink: URL) {
       let urlRequest = URLRequest(url: urlLink)
       webView.load(urlRequest)
       print("DEBUG VideoDownloader: youtubeVideoLink didSet was triggered")
   }
    
}


//MARK: - WKNavigationDelegate
extension VideoDownloader: WKNavigationDelegate {
    
  
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: (WKNavigationActionPolicy) -> Void) {
        
        print("VideoDownloader decidePolicyFor triged")
        
        if let currentActiveURL = navigationAction.request.url?.absoluteString {
            
            let EXTRACT_VIDEO_URL = "document.getElementsByTagName('video')[0].src" //MARK: This runs an injection into javascript of the baseURL and returns the actual url pointing to the video so we can download it

            webView.evaluateJavaScript(EXTRACT_VIDEO_URL) { videoDownloadURLextractedFromJS, error in
                guard error == nil else {return}

                self.videoURL = URL(string: videoDownloadURLextractedFromJS as! String)
                
                print("DEBUG VideoDownloader: videoDownloadURLextractedFromJS \(videoDownloadURLextractedFromJS)")


            }

        }
        
        decisionHandler(.allow)


    }

}
