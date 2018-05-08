//
//  WebStuffViewController.swift
//  AldoAProject2
//
//  Created by Aldo Ayala on 10/17/17.
//  Copyright © 2017 Aldo Ayala. All rights reserved.
//

import UIKit
import WebKit

class WebStuffViewController: UIViewController, WKUIDelegate {

    
    @IBOutlet weak var webView: WKWebView!
    var webUrl: NewsStuff?
    var newsURL = "https://www.espn.com"

    @IBAction func shareButton(_ sender: UIBarButtonItem) {
        let url = newsURL
        print(url)
        let myActivity = UIActivityViewController(activityItems: ["Check Out This Link From Aldo's Feedr App", url], applicationActivities: nil)
        myActivity.popoverPresentationController?.sourceView = self.view
        
        self.present(myActivity, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if ConnectionCheck.isConnectedToNetwork() {
            print("Network is Reachable :-)")
        } else {
            //                        ConnectionCheck.isConnectedToNetwork()
            print("Network is NOT Reachable :-(")
            let alertController = UIAlertController(title: "Network Issue",
                                                    message: "NOT CONNECTED TO INTERNET",
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK",
                                                    style: .default,
                                                    handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        webView.uiDelegate = self
        webView.load(URLRequest(url: URL(string: newsURL)!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendStuff" {
            newsURL = (webUrl?.someUrl)!
            print(newsURL)
        }
    }



}
