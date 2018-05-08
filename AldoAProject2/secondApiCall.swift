//
//  secondApiCall.swift
//  AldoAProject2
//
//  Created by Aldo Ayala on 10/17/17.
//  Copyright © 2017 Aldo Ayala. All rights reserved.
//

import Foundation



/*
var newsThings: [NewsStuff] = []
func updateFeed () {
    let urlString = "https://api.nytimes.com/svc/topstories/v2/home.json?api-key=70364b1ba25a4c519557315024fe43db"
    let requestUrl = URL(string:urlString)
    let request = URLRequest(url:requestUrl!)
    let task = URLSession.shared.dataTask(with: request) {
        (data, response, error) in
        if error == nil,let usableData = data {
            print("JSON Received...File Size: \(usableData) \n")
            do {
                let jobject = try JSONSerialization.jsonObject(with: usableData, options: .allowFragments)
                if let dictionary = jobject as? [String : Any] {
                    if let articles = dictionary["articles"] as? [[String: Any]] {
                        for article in articles {
                            if let title = article["title"] {
                                if let imgUrl = article["urlToImage"] {
                                    if let description = article["description"]{
                                        if let someUrl = article["url"]{
                                            newsThings.append(NewsStuff(title: title as! String, description: description as! String, someUrl: someUrl as! String, imageUrl: imgUrl as! String))
                                            print("it worked, \(newsThings)")
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
                    //theTableView.reloadData()
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
 /**/*/
