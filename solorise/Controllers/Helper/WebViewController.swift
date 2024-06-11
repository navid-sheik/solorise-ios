//
//  WebViewController.swift
//  solorise
//
//  Created by Navid Sheikh on 08/06/2024.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    
    private let webView : WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    
    private let urlString : String
    
    
    init(with urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url  = URL(string : self.urlString) else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        self.webView.load(URLRequest(url: url))
        self.setUpView()

        // Do any additional setup after loading the view.
    }
    
    private func setUpView(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDone))
        self.navigationController?.navigationBar.backgroundColor =  .secondarySystemBackground
        self.view.addSubview(webView)
        webView.anchor(top: view.topAnchor ,left: view.leadingAnchor, right: view.trailingAnchor, bottom: view.bottomAnchor, paddingTop: 0, paddingLeft: 20, paddingRight: -20, paddingBottom: -20, width: nil, height: nil)
        
    }
    
    @objc private func didTapDone(){
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
