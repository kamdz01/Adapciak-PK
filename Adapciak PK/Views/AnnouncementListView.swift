//
//  AnnouncementsView.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 12/12/2022.
//

import SwiftUI

struct AnnouncementList: View{
    
    @Binding var loggedIn: Bool
    @EnvironmentObject var viewModel: FirebaseViewModel
    @State private var chosenDelete = false
    @State private var announcementToDeleteID = ""
    @Binding var tabClicked: Bool
    
    
    var body: some View{
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.announcements) { announcement in
                        if(!(announcement.content ?? "").isEmpty && !(announcement.title ?? "").isEmpty &&
                           !(announcement.hidden ?? false)) {
                            let dateArr = announcement.date?.components(separatedBy: " ")
                            AnnouncementViewItem(loggedIn: $loggedIn, announcement: announcement, dateArr: dateArr)
                                .contextMenu {
                                    if (loggedIn){
                                        if #available(iOS 15.0, *) {
                                            Button(role: .destructive) {
                                                chosenDelete = true
                                                announcementToDeleteID = announcement.id ?? ""
                                            } label: {
                                                Label("Usuń", systemImage: "trash.fill")
                                            }
                                        } else {
                                            Button() {
                                                chosenDelete = true
                                                announcementToDeleteID = announcement.id ?? ""
                                            } label: {
                                                Label("Usuń", systemImage: "trash.fill")
                                            }
                                        }
                                    }
                                }
                        }
                    }
                    .onChange(of: tabClicked){ clicked in
                        withAnimation{
                            proxy.scrollTo(viewModel.announcements[0].id, anchor: .top)
                        }
                    }
                    .actionSheet(isPresented: $chosenDelete) {
                        ActionSheet(
                            title: Text("Czy na pewno chcesz usunąć to ogłoszenie?"),
                            buttons: [
                                .destructive(Text("Usuń")) {
                                    self.viewModel.hideAnnouncement(id: announcementToDeleteID)
                                    chosenDelete = false
                                },
                                .default(Text("Anuluj")) {
                                    chosenDelete = false
                                },
                            ]
                        )
                    }
                }
                .padding([.leading, .bottom, .trailing])
            }
            .padding(.top)
        }
    }
}


struct AnnouncementListView: View {
    
    @Binding var loggedIn: Bool
    @EnvironmentObject var viewModel: FirebaseViewModel
    @ObservedObject var activeAnnouncement = ActiveAnnouncement.shared
    @State var ifAdding = false
    @Binding var tabClicked: Bool
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all)
            NavigationView {
                VStack {
                    if (activeAnnouncement.isActive){
                        NavigationLink(destination: AnnouncementDetailView(announcement: activeAnnouncement.announcement), isActive: $activeAnnouncement.isActive) { EmptyView() }
                    }
                    NavigationLink(destination: AnnouncementFormContainer(ifAdding: $ifAdding), isActive: $ifAdding) {
                        EmptyView()
                    }
                    if #available(iOS 16.0, *) {
                        AnnouncementList(loggedIn: $loggedIn, tabClicked: $tabClicked)
                            .refreshable {
                                print("ODSWIEŻONO")
                            }
                            .background(LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom))
                            .scrollContentBackground(.hidden)
                    }
                    else if #available(iOS 15.0, *) {
                        AnnouncementList(loggedIn: $loggedIn, tabClicked: $tabClicked)
                            .refreshable {
                                print("ODSWIEŻONO")
                            }
                            .background(LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom))
                    } else {
                        AnnouncementList(loggedIn: $loggedIn, tabClicked: $tabClicked)
                            .onAppear() {
                                UITableView.appearance().backgroundColor = UIColor.clear
                                UITableViewCell.appearance().backgroundColor = UIColor.clear
                            }
                            .background(LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom))
                    }
                }
                .navigationTitle("Ogłoszenia")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing){
                        if (loggedIn){
                            Button(action: {
                                ifAdding = true
                            }, label: {
                                Image("plus-icon")
                            })
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading){
                        HStack {
                            Text("")
                            NavigationLink(destination: SignInView()){
                                Image("login-icon")
                            }
                        }
                    }
                }
            }
        }
    }
}


struct AnnouncementViewItem: View {
    
    @Binding var loggedIn: Bool
    let announcement: Announcement
    let dateArr: [String]?
    var body: some View {
        NavigationLink(destination: AnnouncementDetailView(announcement: announcement))
        {
            ZStack(alignment: .leading) {
                HStack {
                    if (announcement.priority ?? true){
                        Rectangle()
                            .fill(.red)
                            .frame(width: 4)
                            .cornerRadius(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)
                    }
                    VStack(alignment: .leading) {
                        if (announcement.priority ?? false){
                                HStack {
                                    VStack {
                                        Text(announcement.title!)
                                            .font(.title2)
                                            .fontWeight(.semibold)
                                            .multilineTextAlignment(.leading)
                                            .lineLimit(2)
                                    }
                                    Spacer()
                                    VStack {
                                        Text(dateArr?[0] ?? "")
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                        Text(dateArr?[1] ?? "")
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                }
                                .padding(.bottom, 1)
                                Text(announcement.subTitle!).font(.title3)
                                    .fontWeight(.medium)
                                    .lineLimit(2)
                                Text(announcement.content!)
                                    .fontWeight(.medium)
                                    .lineLimit(2)
                        }
                        else {
                                HStack {
                                    VStack {
                                        Text(announcement.title!)
                                            .font(.title2)
                                            .multilineTextAlignment(.leading)
                                            .lineLimit(2)
                                    }
                                    Spacer()
                                    VStack {
                                        Text(dateArr?[0] ?? "")
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                        Text(dateArr?[1] ?? "")
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.bottom, 1)
                                Text(announcement.subTitle!).font(.title3)
                                    .lineLimit(2)
                                Text(announcement.content!)
                                    .lineLimit(2)
                        }
                    }
                    Spacer()
                }
            }
            .padding()
            .padding(.vertical, 5.0)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color("FieldColor"))       .padding(.horizontal, 7.0)
                .padding(.vertical, 3))
        }
    }
}

struct AnnouncementsView_Previews: PreviewProvider {
    static let viewModel = FirebaseViewModel()
    static var previews: some View {
        AnnouncementListView(loggedIn: .constant(true), tabClicked: .constant(true))
            .environmentObject(viewModel)
            .onAppear{
                viewModel.fetchData()
            }
        MainView(loggedIn: .constant(true), email: .constant("sample@email.com"), password: .constant("password"))
            .previewDisplayName("MainView")
            .environmentObject(viewModel)
            .onAppear{
                viewModel.fetchData()
            }
    }
}
