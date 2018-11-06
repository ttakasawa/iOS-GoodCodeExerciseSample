//
//  DetailViewController.swift
//  iOS-GoodCodeExerciseSample
//
//  Created by Tomoki Takasawa on 11/5/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import NVActivityIndicatorView

class DetailViewController: UIViewController, NVActivityIndicatorViewable {
    
    let url: URL
    let name: String
    let themeColor: UIColor
    let logo: UIImage
    
    let cover = UIView()
    var webView: WKWebView!
    var logoView = UIImageView()
    
    init(stringUrl: String, name: String, themeColor: UIColor, logo: UIImage){
        self.url = URL(string: stringUrl)!
        self.name = name
        self.themeColor = themeColor
        self.logo = logo
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        let myURL = self.url
        let myRequest = URLRequest(url: myURL)
        webView.load(myRequest)
        
        webView.uiDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(webView)
        
        webView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        self.hideViewWhileLoading()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func hideViewWhileLoading(){
        
        cover.backgroundColor = self.themeColor
        cover.translatesAutoresizingMaskIntoConstraints = false
        
        logoView.image = self.logo.withRenderingMode(.alwaysTemplate)
        logoView.tintColor = .white
        logoView.contentMode = .scaleAspectFit
        logoView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(cover)
        cover.addSubview(logoView)
        
        cover.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        cover.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        cover.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        cover.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        logoView.centerXAnchor.constraint(equalTo: cover.centerXAnchor).isActive = true
        logoView.centerYAnchor.constraint(equalTo: cover.centerYAnchor).isActive = true
        logoView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        logoView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.startAnimating(CGSize(width: 190, height: 190), message: nil, messageFont: nil, type: NVActivityIndicatorType.ballClipRotateMultiple, color: .white, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: .clear, textColor: nil, fadeInAnimation: nil)
        }
        
        self.navigationController?.navigationBar.isHidden = true
    }
}


extension DetailViewController: WKUIDelegate, WKNavigationDelegate {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        print(self.webView.estimatedProgress)
        if (Float(self.webView.estimatedProgress) >= 0.85){
            
            UIView.animate(withDuration: 1.5, animations: {
                self.cover.alpha = 0.0
            }, completion: { (value: Bool) in
                
                self.cover.removeFromSuperview()
                self.navigationController?.navigationBar.isHidden = false
                self.stopAnimating()
            })
            
        }
    }
}
