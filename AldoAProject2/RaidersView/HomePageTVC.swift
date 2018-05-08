//
//  HomePageTVC.swift
//  AldoAProject2
//
//  Created by Aldo Ayala on 10/9/17.
//  Copyright © 2017 Aldo Ayala. All rights reserved.
//

import UIKit

class HomePageTVC: UITableViewController {
    var newsThings: [NewsStuff] = []
    
    func searchForStuff() {
        let apiServer: String = "http://beta.newsapi.org/v2/everything?q="
        let myApiKey: String = "&from=2017-10-18&to=2017-10-19&sortBy=popularity&apiKey=fc47234bc27e4f5a806b0a45cde11ac4"
        
        enum MySearches: String {
            case raiders, athletics, warriors, lakers, giants
        }
        var APIEndPoint: String = apiServer + (MySearches.raiders.rawValue) + myApiKey
        print(APIEndPoint)
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
        self.searchForStuff()
        self.updateFeed()
        //        self.searchForStuff()
    
    }
    
    func updateFeed () {
        let urlString = "http://beta.newsapi.org/v2/everything?q=raiders&from=2017-10-18&to=2017-10-19&sortBy=popularity&apiKey=fc47234bc27e4f5a806b0a45cde11ac4"
        let requestUrl = URL(string:urlString)
        let request = URLRequest(url:requestUrl!)
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if error == nil,let usableData = data {
                //   print("JSON Received...File Size: \(usableData) \n")
                do {
                    let jobject = try JSONSerialization.jsonObject(with: usableData, options: .allowFragments)
                    if let dictionary = jobject as? [String : Any] {
                        if let articles = dictionary["articles"] as? [[String: Any]] {
                            for article in articles {
                                if let title = article["title"] {
                                    if let imgUrl = article["urlToImage"] {
                                        if let description = article["description"]{
                                            if let someUrl = article["url"]{
                                                self.newsThings.append(NewsStuff(title: title as! String, description: description as! String, someUrl: someUrl as! String, imageUrl: imgUrl as! String))
                                                //print("it worked, \(self.newsThings)")
                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            print("TERRIBLE")
                        }
                    }
                    
                    DispatchQueue.main.async() {
                        self.tableView.reloadData()
                    }
                } catch {
                    print("ERROR")
                }
            }  else {
                print("network issues")
            }
        }
        task.resume()
    }
    func getImage(imageUrl: String) {
        let urlString = ""
        let requestUrl = URL(string:urlString)
        let request = URLRequest(url:requestUrl!)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {return newsThings.count}
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(#line, #function, newsThings[indexPath.row].imageUrl)
        let cell = tableView.dequeueReusableCell(withIdentifier: "raidersCell", for: indexPath) as? RaidersTableViewCell
        cell?.raidersImage.downloadImageFrom(link: newsThings[indexPath.row].imageUrl!)
        cell?.raidersImage.contentMode = .scaleToFill
        cell?.raidersLabel?.text = newsThings[indexPath.row].title
        
        return cell!
    }
    
    //this func is called when apple is setting up the tableview and setting up the height of each row
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {return 400}
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //self.performSegue(withIdentifier: "sendStuff", sender: newsThings[indexPath.row])
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextView = segue.destination as? WebStuffViewController {
            if let newWebCell = sender as? RaidersTableViewCell {
                let row = tableView.indexPath(for: newWebCell)!.row
                let newWeb = newsThings[row]
                nextView.newsURL = newWeb.someUrl!
                
                print(nextView.newsURL = newWeb.someUrl!)
            }
        }
    }
    
}



