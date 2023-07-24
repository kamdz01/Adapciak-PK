//
//  MainView.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 14/12/2022.
//

import SwiftUI
import Firebase

struct MainView: View {
    @Binding var loggedIn: Bool
    @Binding var email: String
    @Binding var password: String
    
    @EnvironmentObject var viewModel: FirebaseViewModel
    @State var selectedTab = 1
    @State var prevSelectedTab = 1
    @State var tabClicked = false
    
    
    @ObservedObject var activeAnnouncement = ActiveAnnouncement.shared
    
    var body: some View {
        TabView(selection: $selectedTab.onUpdate {
            if(selectedTab == prevSelectedTab){
                tabClicked.toggle()
            }
            prevSelectedTab = selectedTab
        }) {
            AnnouncementListView(loggedIn: $loggedIn, tabClicked: $tabClicked)
                .tabItem {
                    Image("notification-icon")
                    Text("Ogłoszenia")
                }
                .tag(1)

            TimetablesListView(loggedIn: $loggedIn, tabClicked: $tabClicked)
                .tabItem {
                    Image("schedule-icon")
                    Text("Harmonogram")
                }
                .tag(2)
            StaffView(tabClicked: $tabClicked)
                .tabItem {
                    Image("people-icon")
                    Text("Kadra")
                }
                .tag(3)
            
        }
        .onChange(of: activeAnnouncement.announcement.id){ change in
            if (activeAnnouncement.isActive){
                selectedTab = 1
            }
        }
        .onAppear{
            if (loggedIn == true){
                Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                    guard error == nil else {
                        print("Could not sign in user.")
                        loggedIn = false
                        return
                    }
                    switch authResult {
                    case .none:
                        print("Could not sign in user.")
                        loggedIn = false
                    case .some(_):
                        print("User signed in")
                        loggedIn = true
                    }
                    print("LoggedIn: \(loggedIn)")
                }
            }
            if (activeAnnouncement.isActive){
                selectedTab = 1
            }
        }
        
    }
}

extension Binding {
    func onUpdate(_ closure: @escaping () -> Void) -> Binding<Value> {
        Binding(get: {
            wrappedValue
        }, set: { newValue in
            //withAnimation{
            wrappedValue = newValue
            closure()
            //}
        })
    }
}

struct MainView_Previews: PreviewProvider {
    static let viewModel = FirebaseViewModel()
    static var previews: some View {
        MainView(loggedIn: .constant(true), email: .constant("sample@email.com"), password: .constant("password"))
            .environmentObject(viewModel)
            .onAppear{
                viewModel.fetchData()
            }
    }
}
