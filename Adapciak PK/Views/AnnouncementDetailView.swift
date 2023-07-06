//
//  AnnouncementView.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 12/12/2022.
//

import SwiftUI
import UserNotifications

struct AnnouncementDetailView: View {
    
    @AppStorage("loggedIn") var loggedIn = false
    @ObservedObject private var viewModel = FirebaseViewModel()
    @State var activeAnnouncement = ActiveAnnouncement.shared
    @State var announcement: Announcement
    
    var body: some View {
        if (activeAnnouncement.isActive == false){
            AnnouncementDetails(announcement: announcement)
        }
        else{
            AnnouncementDetailsClicked()
        }
    }
}

struct AnnouncementDetails: View {
    
    @State private var showingAdvancedOptions = false
    @State private var chosenDelete = false
    @State private var deleted = 0
    @AppStorage("loggedIn") var loggedIn = false
    @ObservedObject private var viewModel = FirebaseViewModel()
    @ObservedObject var activeAnnouncement = ActiveAnnouncement.shared
    @State var announcement: Announcement
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all)
            if deleted == 1{
                Text("Poprawnie usunięto ogłoszenie")
            }
            else
            {
                ScrollView{
                    VStack {
                        if (announcement.isImage ?? false){
                            FirebaseImage(path: "images/", imageID: .constant("\(announcement.id!).jpg"))
                        }
                        VStack(alignment: .leading) {
                            Text(announcement.title!).font(.title)
                            Text(announcement.subTitle!).font(.title3)
                            Text(announcement.content!)
                        }
                        .padding()
                        
                    }
                    .toolbar {
                        if loggedIn{
                            Button("Usuń") {
                                chosenDelete.toggle()
                            }
                            
                        }
                    }
                }
                .actionSheet(isPresented: $chosenDelete) {
                    ActionSheet(
                        title: Text("Czy na pewno chcesz usunąć to ogłoszenie?"),
                        buttons: [
                            .destructive(Text("Usuń")) {
                                self.viewModel.hideAnnouncement(id: announcement.id ?? "ERROR")
                                chosenDelete = false
                                deleted = 1
                            },
                            .default(Text("Anuluj")) {
                                showingAdvancedOptions = false
                            },
                        ]
                    )
                }
            }
        }
    }
}

struct AnnouncementDetailsClicked: View {
    
    @State private var showingAdvancedOptions = false
    @State private var chosenDelete = false
    @State private var deleted = 0
    @AppStorage("loggedIn") var loggedIn = false
    @ObservedObject private var viewModel = FirebaseViewModel()
    @ObservedObject var activeAnnouncement = ActiveAnnouncement.shared
    @State var imageID = "-1"
    
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all)
            if deleted == 1{
                Text("Poprawnie usunięto ogłoszenie")
            }
            else
            {
                ScrollView{
                    VStack {
                        if (activeAnnouncement.announcement.isImage ?? false){
                            FirebaseImage(path: "images/", imageID: $imageID)
                        }
                        VStack(alignment: .leading) {
                            Text(activeAnnouncement.announcement.title!).font(.title)
                            Text(activeAnnouncement.announcement.subTitle!).font(.title3)
                            Text(activeAnnouncement.announcement.content!)
                        }
                        .padding()
                        
                    }
                    .toolbar {
                        if loggedIn{
                            Button("Usuń") {
                                chosenDelete.toggle()
                            }
                            
                        }
                    }
                }
                .actionSheet(isPresented: $chosenDelete) {
                    ActionSheet(
                        title: Text("Czy na pewno chcesz usunąć to ogłoszenie?"),
                        buttons: [
                            .destructive(Text("Usuń")) {
                                self.viewModel.hideAnnouncement(id: activeAnnouncement.announcement.id ?? "ERROR")
                                chosenDelete = false
                                deleted = 1
                            },
                            .default(Text("Anuluj")) {
                                showingAdvancedOptions = false
                            },
                        ]
                    )
                }
            }
        }
        .onAppear{
            imageID = "\(activeAnnouncement.announcement.id!).jpg"
        }
        .onChange(of: activeAnnouncement.announcement.id){ id in
            imageID = "\(activeAnnouncement.announcement.id!).jpg"
        }
    }
}
struct AnnouncementView_Previews: PreviewProvider {
    static var previews: some View {
        let announcement_prev = Announcement(title: "Title", subTitle: "subTitle", content: "content")
        AnnouncementDetailView(announcement: announcement_prev)
    }
}
