//
//  PushNotificationSender.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 13/02/2023.
//

import Foundation

class PushNotificationSender {
    func sendPushNotification(to token: String, title: String, body: String, viewModel: FirebaseViewModel) {
        var serverKey = ""
        viewModel.getKey(){key in
            serverKey = key
            let urlString = "https://fcm.googleapis.com/fcm/send"
            let url = NSURL(string: urlString)!
            let paramString: [String : Any] = ["to" : token,
                                               "notification" : ["title" : title, "body" : body, "sound": "default"],
                                               "data" : ["user" : "test_id"]
            ]
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
            let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
                do {
                    if let jsonData = data {
                        if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                            NSLog("Received data:\n\(jsonDataDict))")
                        }
                    }
                } catch let err as NSError {
                    print(err.debugDescription)
                }
            }
            task.resume()
        }
    }
    
    
    
    func sendToTopic(title: String, body: String, id: String, collection: String, viewModel: FirebaseViewModel, completion: @escaping (Result<Bool, Error>) -> Void) {
        var requestsFinished = 0
        var serverKey = ""
        viewModel.getKey() { key in
            serverKey = key
            let urlString = "https://fcm.googleapis.com/fcm/send"
            let url = NSURL(string: urlString)!
            let paramString_ios: [String : Any] = ["to" : "/topics/notifications_ios",
                                                   "notification" : ["title" : title, "body" : body,"documentID": id, "collection": collection, "sound": "default"],
                                                   "data" : ["announcementID" : id],
            ]
            
            let paramString_android: [String : Any] = ["to" : "/topics/notifications_android",
                                                       "data" : ["title" : title, "body" : body,"documentID": id, "collection": collection]
            ]
            let request_ios = NSMutableURLRequest(url: url as URL)
            request_ios.httpMethod = "POST"
            request_ios.httpBody = try? JSONSerialization.data(withJSONObject:paramString_ios, options: [.prettyPrinted])
            request_ios.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request_ios.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
            let task_ios =  URLSession.shared.dataTask(with: request_ios as URLRequest)  { (data, response, error) in
                if (error != nil){
                    DispatchQueue.main.async {
                        print(error.debugDescription)
                        completion(.failure(error!))
                        return
                    }
                }
                else {
                    do {
                        if let jsonData = data {
                            if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                                NSLog("(NotifURLSession) Received data:\n\(jsonDataDict))")
                            }
                        }
                    } catch let err as NSError {
                        DispatchQueue.main.async {
                            print(err.debugDescription)
                            completion(.failure(err))
                            return
                        }
                    }
                    DispatchQueue.main.async {
                        requestsFinished += 1
                        if (requestsFinished >= 2) {
                            completion(.success(true))
                        }
                    }
                }
            }
            task_ios.resume()
            
            let request_android = NSMutableURLRequest(url: url as URL)
            request_android.httpMethod = "POST"
            request_android.httpBody = try? JSONSerialization.data(withJSONObject:paramString_android, options: [.prettyPrinted])
            request_android.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request_android.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
            let task_android =  URLSession.shared.dataTask(with: request_android as URLRequest)  { (data, response, error) in
                if (error != nil){
                    DispatchQueue.main.async {
                        print(error.debugDescription)
                        completion(.failure(error!))
                        return
                    }
                }
                else
                {
                    do {
                        if let jsonData = data {
                            if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                                NSLog("(NotifURLSession) Received data:\n\(jsonDataDict))")
                            }
                        }
                    } catch let err as NSError {
                        DispatchQueue.main.async {
                            print(err.debugDescription)
                            completion(.failure(err))
                            return
                        }
                    }
                    DispatchQueue.main.async {
                        requestsFinished += 1
                        if (requestsFinished >= 2) {
                            completion(.success(true))
                        }
                    }
                }
            }
            task_android.resume()
        }
    }
}
