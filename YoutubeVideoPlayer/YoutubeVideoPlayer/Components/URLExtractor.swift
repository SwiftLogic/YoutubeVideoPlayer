//
//  URLExtractor.swift
//  YoutubeVideoPlayer
//
//  Created by Osaretin Uyigue on 9/11/22.
//

import UIKit
import WebKit
import Combine

/// extracts streammable youtube video from remote server using javascript injection into Webview
class URLExtractor: NSObject {
    
    
    //MARK: - Properties
    fileprivate var videoURL: URL? {
        didSet {
            guard let videoURL = videoURL else {return}
            publishExtractedURL.send(videoURL)
        }
    }
    
    var publishExtractedURL = PassthroughSubject<URL, Never>()
    
    fileprivate lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        return webView
    }()
    
    
    //MARK: - Methods
    func load(youtubeVideoLink: URL) {
        let urlRequest = URLRequest(url: youtubeVideoLink)
        webView.load(urlRequest)
    }
    
    /// Extracts a strammable url from the webview using a JS evaluator
    fileprivate func extractStreamableURL(from webView: WKWebView) {
        webView.evaluateJavaScript(AppConstant.javascriptYoutubeUrlEvaluator) {[weak self] videoDownloadURLextractedFromJS, error in
            guard error == nil, let self = self else {return}
            let streammableURL = URL(string: videoDownloadURLextractedFromJS as! String)
            guard self.videoURL != streammableURL else {return}
            self.videoURL = streammableURL
        }
    }
    
}


//MARK: - WKNavigationDelegate
extension URLExtractor: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: (WKNavigationActionPolicy) -> Void) {
        extractStreamableURL(from: webView)
        decisionHandler(.allow)
    }

}
