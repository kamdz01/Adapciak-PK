//
//  ContentView.swift
//  Adapciak PK
//
//  Created by Kamil Dziedzic on 06/07/2023.
//

import SwiftUI
import Firebase
import UserNotifications
import FirebaseMessaging


struct ContentView: View {
    @AppStorage("loggedIn") var loggedIn = false
    @AppStorage("verificated") var verificated = false
    @AppStorage("email") var email = ""
    @AppStorage("password") var password = ""
    @State var showNotificationDialog = false
    @Environment (\.scenePhase) private var scenePhase
    
    @ObservedObject var activeAnnouncement = ActiveAnnouncement.shared
    
    @StateObject var viewModel = FirebaseViewModel()
    
    init() {
        if #available(iOS 15.0, *) {
            UITabBar.appearance().backgroundColor = UIColor(Color("TabColor"))
            UITabBar.appearance().barTintColor = UIColor(Color("TabColor"))
        }
        else{
            UITabBar.appearance().backgroundColor = UIColor(Color("IOS14-bottom-bar"))
        }
        UINavigationBar.appearance().barTintColor = UIColor(Color("TabColor"))
        if #available(iOS 16.0, *) {}
        else{
            UITableView.appearance().backgroundColor = .clear
        }
        let tabBarAppearance = UITabBarAppearance()
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
    
    
    var body: some View {
        VStack{
            if(verificated){
                MainView(loggedIn: $loggedIn, email: $email, password: $password)
                    .environmentObject(viewModel)
                    .onAppear(){
                        let center = UNUserNotificationCenter.current()
                        center.getNotificationSettings { settings in
                            guard (settings.authorizationStatus == .authorized) ||
                                    (settings.authorizationStatus == .provisional) else {
                                @AppStorage("notificationAskCnt") var notificationAskCnt = 0
                                print("No Notifications")
                                if(notificationAskCnt >= 0){
                                    if(notificationAskCnt % 3 == 0 ){
                                        showNotificationDialog = true
                                    }
                                    notificationAskCnt += 1
                                }
                                return
                            }
                            print("Notifications OK")
                        }
                        
                        Messaging.messaging().subscribe(toTopic: "notifications_ios") { error in
                            print("Subscribed to notifications_ios topic")
                        }
                    }
                    .sheet(isPresented: $showNotificationDialog){
                        AskForPermNotifView(showNotificationDialog: $showNotificationDialog)
                            .environment(\.scenePhase, scenePhase)
                    }
            }
            else{
                VerificationView()
                    .environmentObject(viewModel)
            }
        }
        .onAppear(){
            self.viewModel.fetchData()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @AppStorage("loggedIn") var loggedIn = true
    @AppStorage("verificated") var verificated = true
    static var previews: some View {
        ContentView()
            .onAppear{
                @AppStorage("verificated") var verificated = true
            }
    }
}
