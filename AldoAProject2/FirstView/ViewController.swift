import UIKit
import Foundation
import WebKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var theTableView: UITableView!
    var newsThings: [NewsStuff] = []
    var myUrlsToSearchWith = "apple"
   
    @IBOutlet weak var mySearchBar: UISearchBar!
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var keyWords = mySearchBar.text

        myUrlsToSearchWith = (keyWords?.replacingOccurrences(of: " ", with: "+")) ?? "apple"
        
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
        
        updateFeed()
        self.view.endEditing(true)
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
                
        updateFeed()
    }
//   http://beta.newsapi.org/v2/everything?q=apple&from=2017-10-18&to=2017-10-19&sortBy=popularity&apiKey=fc47234bc27e4f5a806b0a45cde11ac4
// http://beta.newsapi.org/v2/everything?q=bitcoin&apiKey=fc47234bc27e4f5a806b0a45cde11ac4
    
    public func updateFeed() {
        let urlStringPart1 =  "http://beta.newsapi.org/v2/everything?q="
        let urlStringPart2 = "&from=2017-10-18&to=2017-10-18&sortBy=popularity&apiKey=fc47234bc27e4f5a806b0a45cde11ac4"
        let urlString = urlStringPart1 + myUrlsToSearchWith + urlStringPart2
        print(urlString, "<<<")
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
                            self.newsThings = []
                            for article in articles {
                                if let title = article["title"] {
                                    if let imgUrl = article["urlToImage"] {
                                        if let description = article["description"]{
                                            if let someUrl = article["url"]{
                                                self.newsThings.append(NewsStuff(title: title as? String, description: description as? String, someUrl: someUrl as? String, imageUrl: imgUrl as? String))
                                                print("it worked, \(someUrl)")
                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            print("TERRIBLE")
                        }
                    }
                    DispatchQueue.main.async {
                        print("We made it -Drake")
                       // self.theTableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {return newsThings.count}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // print(#line, #function, newsThings[indexPath.row].imageUrl!)
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? HomePageTableViewCell
        if cell == nil {
            updateFeed()
        } else {
        
        cell?.articleImage.downloadImageFrom(link: newsThings[indexPath.row].imageUrl!)
        cell?.articleImage.contentMode = .scaleToFill
        cell?.articleTitle?.text = newsThings[indexPath.row].title
       // cell?.articleTitle?.numberOfLines = 2
     
    }
        return cell!
    }
    //this func is called when apple is setting up the tableview and setting up the height of each row
 //  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {return 400}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //self.performSegue(withIdentifier: "sendStuff", sender: newsThings[indexPath.row])
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextView = segue.destination as? WebStuffViewController {
            if let newWebCell = sender as? HomePageTableViewCell {
                let row = theTableView.indexPath(for: newWebCell)!.row
                let newWeb = newsThings[row]
                nextView.newsURL = newWeb.someUrl!
                
                print(nextView.newsURL = newWeb.someUrl!)
            }
        }
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "sendStuff" {
//            guard let nextViewController = segue.destination as? WebStuffViewController else {return}
//
//            let urlToPass = NewsStuff().someUrl
//            print("AAAAAAAAAA\(urlToPass)")
//            if urlToPass != nil {
//                nextViewController.newsURL = urlToPass
//
//            } else {
//
//                let alertController = UIAlertController(title: "Sorry no Article",
//                                                        message: "The article is not available",
//                                                        preferredStyle: .actionSheet)
//                alertController.addAction(UIAlertAction(title: "Ok",
//                                                        style: .default,
//                                                        handler: nil))
//
//                self.present(alertController, animated: true, completion: nil)
//
//                print("did this work \(urlToPass)")
//            }
//
//        }
//    }
}
//This extenstion extends the capabilities of the UIImageView so that we can fetch images lazily, or as needed.
extension UIImageView {
    
    func downloadImageFrom(link: String)  {
        URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
            (data, response, error) -> Void in
            if error != nil {
                print("error", error!, Date())
            }
            DispatchQueue.main.async {
                // print(#line, "<-Reached")
                self.image = nil
                self.contentMode =  .scaleToFill
                if let data = data {
                    //print(#line, #function)
                    
                    self.image = UIImage(data: data)
                }
            }
        }).resume()
    }
}

