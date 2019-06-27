//
//  WKWebViewController.swift
//  foodieApp
//
//  Created by sy on 2019/5/31.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit
import WebKit

class WKWebViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    var url: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9058823529, green: 0.2980392157, blue: 0.2352941176, alpha: 1)
        self.navigationItem.title = self.url.host
        let urlRequst = URLRequest(url: self.url)
        self.webView.load(urlRequst)
    }
    

}
