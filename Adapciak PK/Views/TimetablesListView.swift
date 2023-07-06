//
//  TimetableView.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 15/12/2022.
//

import SwiftUI

struct TimetablesList: View{
    
    @Binding var loggedIn: Bool
    @EnvironmentObject var viewModel: FirebaseViewModel
    @Binding var tabClicked: Bool
    
    var body: some View{
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.timetables) {timetable in
                        if(!(timetable.day ?? "").isEmpty) {
                            TimetablesViewItem(loggedIn: $loggedIn, timetable: timetable)
                        }
                    }
                    .onChange(of: tabClicked){ clicked in
                        withAnimation{
                            proxy.scrollTo(viewModel.timetables[0].id, anchor: .top)
                        }
                    }
                }
                .padding([.leading, .bottom, .trailing])
            }
            .padding(.top)
        }
    }
}

struct TimetablesListView: View {
    @Binding var loggedIn: Bool
    @EnvironmentObject var viewModel: FirebaseViewModel
    @Binding var tabClicked: Bool
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all)
            NavigationView {
                VStack {
                    if #available(iOS 16.0, *) {
                        TimetablesList(loggedIn: $loggedIn, tabClicked: $tabClicked)
                            .refreshable {
                                print("ODSWIEŻONO")
                            }
                            .background(LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom))
                            .scrollContentBackground(.hidden)
                    }
                    else if #available(iOS 15.0, *) {
                        TimetablesList(loggedIn: $loggedIn, tabClicked: $tabClicked)
                            .refreshable {
                                print("ODSWIEŻONO")
                            }
                            .background(LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom))
                    } else {
                        TimetablesList(loggedIn: $loggedIn, tabClicked: $tabClicked)
                            .onAppear() {
                                UITableView.appearance().backgroundColor = UIColor.clear
                                UITableViewCell.appearance().backgroundColor = UIColor.clear
                            }
                            .background(LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom))
                    }
                }
                .navigationTitle("Harmonogram")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
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

struct TimetablesViewItem: View {
    
    @Binding var loggedIn: Bool
    let timetable: Timetable
    @State var tapped = false
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10).fill(Color("FieldColor"))
            VStack{
                if(!tapped){
                    HStack{
                        Spacer()
                        VStack(alignment: .center) {
                            Text("\(timetable.day!)")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .lineLimit(2)
                                .padding(.bottom, 1.0)
                        }
                        Spacer()
                        Image(systemName: "chevron.down")
                    }
                }
                else{
                    HStack{
                        Spacer()
                        VStack(alignment: .center) {
                            Text("\(timetable.day!)")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .padding(.bottom, 1.5)
                        }
                        Spacer()
                        Image(systemName: "chevron.up")
                    }
                    if (timetable.subTitle != ""){
                        Text("\(timetable.subTitle!)")
                            .padding(.bottom, 1.5)
                    }
                    VStack(alignment: .leading, spacing: 5){
                        if (timetable.name1 != "" && timetable.content1 != ""){
                            Text("\(timetable.name1!)")
                                .fontWeight(.semibold)
                            Text("\(timetable.content1!)")
                        }
                        if (timetable.name2 != "" && timetable.content2 != ""){
                            Text("\(timetable.name2!)")
                                .fontWeight(.semibold)
                            Text("\(timetable.content2!)")
                        }
                        if (timetable.name3 != "" && timetable.content3 != ""){
                            Text("\(timetable.name3!)")
                                .fontWeight(.semibold)
                            Text("\(timetable.content3!)")
                        }
                    }
                }
            }
        }
        .onTapGesture {
            withAnimation(.easeOut(duration: 0.1)) {
                tapped.toggle()
            }
        }
        .padding()
        .padding(.vertical, 5.0)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color("FieldColor"))        .padding(.horizontal, 7.0)
            .padding(.vertical, 3))
    }
}

struct TimetablesListView_Previews: PreviewProvider {
    static let viewModel = FirebaseViewModel()
    static var previews: some View {
        TimetablesListView(loggedIn: .constant(true), tabClicked: .constant(true))
            .environmentObject(viewModel)
            .onAppear{
                viewModel.fetchData()
            }
    }
}
