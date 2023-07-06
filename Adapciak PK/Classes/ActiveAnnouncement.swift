//
//  ActiveAnnouncement.swift
//  Adapciak PK
//
//  Created by Kamil Dziedzic on 06/07/2023.
//

import SwiftUI
import Foundation
import FirebaseFirestore

class ActiveAnnouncement: ObservableObject {
    
    var db = Firestore.firestore()
    
    @State static var shared = ActiveAnnouncement()
    @Published var isActive: Bool
    @Published var announcement: Announcement
    init() {
        isActive = false
        announcement = Announcement()
    }
    
    func getAnnouncement(id: String, completion: @escaping (Announcement) -> Void){
        let docRef = db.collection("Announcements").document(id)
        var announcement = Announcement()
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let id = id
                let title = data?["title"] as? String ?? ""
                let subTitle = data?["subTitle"] as? String ?? ""
                let content = data?["content"] as? String ?? ""
                let hidden = data?["hidden"] as? Bool ?? true
                let date = data?["date"] as? String ?? ""
                let isImage = data?["isImage"] as? Bool ?? false
                let priority = data?["priority"] as? Bool ?? false
                announcement = Announcement(id: id, title: title, subTitle: subTitle, content: content, hidden: hidden, date: date, isImage: isImage, priority: priority)
            }
            else {
                print("Document does not exist")
                announcement = Announcement(id: "-1")
            }
            completion(announcement)
        }
    }
}
