//
//  WebViewController.swift
//  tenLongBookstore
//
//  Created by Henry on 2019/10/15.
//  Copyright © 2019 Henry. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController  {
    
    var urlString :String?
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let urlString = urlString else { return }
        
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        webView.load(request)
        
        navigationItem.largeTitleDisplayMode = .never
        
    }

    
}
