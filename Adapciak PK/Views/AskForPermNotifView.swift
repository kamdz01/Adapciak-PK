//
//  AskForPermNotifView.swift
//  Adapciak PK
//
//  Created by Kamil Dziedzic on 06/07/2023.
//

import SwiftUI

struct AskForPermNotifView: View {
    
    @State var NotificationsOK = 0
    @State var chosenNotToAsk = false
    @Binding var showNotificationDialog: Bool
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all)
            VStack(spacing: 15){
                if (NotificationsOK == 0){
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .foregroundColor(Color.red)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .frame(width: 150.0, height: 150.0)
                    Text("Prosimy, włącz powiadomienia w ustawieniach aplikacji. To pozwoli Ci być na bieżąco z wszystkimi ogłoszeniami.")
                        .font(.title3)
                    Button(action: {
                        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }) {
                        Text("Chcę powiadomienia!")
                            .MainButtonBold()
                    }
                    Button(action: {
                        chosenNotToAsk.toggle()
                    }) {
                        Text("Nie chcę, nie pytaj więcej")
                            .MainButtonBold()
                    }
                    .actionSheet(isPresented: $chosenNotToAsk) {
                        ActionSheet(
                            title: Text("Czy na pewno Nie chcesz otrzymywać powiadomień z tej aplikacji?"),
                            buttons: [
                                .destructive(Text("Nie chcę")) {
                                    @AppStorage("notificationAskCnt") var notificationAskCnt = 0
                                    notificationAskCnt = -1
                                    NotificationsOK = 2
                                },
                                .default(Text("Anuluj")) {
                                    chosenNotToAsk = false
                                },
                            ]
                        )
                    }
                    Button(action: {
                        showNotificationDialog.toggle()
                    }) {
                        Text("Nie chcę")
                            .MainButtonBold()
                    }
                    
                }
                else if (NotificationsOK == 1){
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .foregroundColor(Color.green)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .frame(width: 150.0, height: 150.0)
                    Text("Dziękujemy za włączenie powiadomień!")
                        .font(.title3)
                }
                else {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .foregroundColor(Color.red)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .frame(width: 150.0, height: 150.0)
                    Text("Przykro nam, że nie chcesz otrzymywać powiadomień. Pamiętaj, że w każdej chwili możesz to zmienić w ustawieniach aplikacji.")
                        .font(.title3)
                }
            }
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    let center = UNUserNotificationCenter.current()
                    center.getNotificationSettings { settings in
                        guard (settings.authorizationStatus == .authorized) ||
                                (settings.authorizationStatus == .provisional) else {
                            return
                        }
                        NotificationsOK = 1
                    }
                }
            }
        }
    }
}

struct AskForPermNotifView_Previews: PreviewProvider {
    static var previews: some View {
        AskForPermNotifView(showNotificationDialog: .constant(true))
    }
}
