//
//  AccountsSettingsView.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 03/08/2021.
//  Copyright © 2021 Ephod. All rights reserved.
//

import SwiftUI
import Preferences

let AccountsPreferenceViewController: () -> PreferencePane = {
    /// Wrap your custom view into `Preferences.Pane`, while providing necessary toolbar info.
    let paneView = Preferences.Pane(
        identifier: .accounts,
        title: "Accounts",
        toolbarIcon: NSImage(systemSymbolName: "person.crop.circle", accessibilityDescription: "Accounts preferences")!
    ) {
        AccountsSettingsView()
    }

    return Preferences.PaneHostingController(pane: paneView)
}

struct AccountsSettingsView: View {
    private let contentWidth : CGFloat = 550.0
    let authViewModel = AuthViewModel()
    @State var googleCalendars = [GoogleCalendar]()
    @State var selectedGoogleCalendar : GoogleCalendar!
    @State var firstname = ""
    @State var account_id = ""
    @State private var bgColor =
            Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
    
    var body: some View {
        HStack(spacing: 0){
            VStack(alignment: .center, spacing: 0){
                List{
                    ForEach(googleCalendars){ calendar in
                        VStack(alignment: .leading){
                            Text(calendar.name).font(.custom("Overpass-Regular", size: 14))
                            Text(calendar.owner).font(.custom("Overpass-Regular", size: 12))
                        }.padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .listRowBackground(self.selectedGoogleCalendar == calendar ? Color.blue.opacity(0.05) : Color("kanbanInside"))
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.selectedGoogleCalendar = calendar
                            self.account_id = self.selectedGoogleCalendar.id
                            self.firstname = authViewModel.getSingleAccountName(accountIDToEdit: self.account_id)
                            self.bgColor = Color(hex: authViewModel.getSingleAccountColor(accountIDToEdit: self.account_id))
                        }
                    }
                }.padding(.vertical, -10)
                .padding(.horizontal, -16).frame(maxHeight: .infinity)
                Button(action: { authViewModel.authorizeNewAccount() }) {
                    HStack{
                        Image("google_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14, height: 14)
                            .padding([.leading], 24)
                        Text("Add Google Account")
                            .font(.custom("Overpass-Regular", size: 12))
                            .padding([.top, .bottom], 10)
                            .padding([.trailing], 24)
                            .padding([.leading], 2)
                    }
                }.buttonStyle(PlainButtonStyle())
                .background(Color("orange"))
                .foregroundColor(.black)
                .cornerRadius(4)
                .padding([.bottom], 10)
            }.frame(width: 210)
            .border(width: 1, edges: [.top, .bottom, .leading, .trailing], color: Color.gray.opacity(0.3))
            .background(Color("kanbanInside"))
            Spacer()
            VStack(alignment: .center, spacing: 14){
                HStack(spacing: 5){
                    Text("Account Name:")
                    TextField("", text: $firstname)
                        .frame(width: 200.0)
                }
                HStack(spacing: 5){
                    Text("Account Color:")
                    HStack(spacing: 0){
                        ColorPicker("", selection: $bgColor)
                            .padding([.leading], -5)
                        Spacer()
                    }.frame(width: 200.0)
                }
                Spacer()
                HStack(alignment: .bottom){
                    Spacer()
                    Button(action: { authViewModel.saveCalendar(accountIDtoEdit: self.account_id, accountName: self.firstname, accountColor: self.bgColor)
                    }) {
                        Text("Save")
                            .font(.custom("Overpass-Regular", size: 12))
                            .padding([.top, .bottom], 10)
                            .padding([.leading, .trailing], 23)
                    }.buttonStyle(PlainButtonStyle())
                    .background(Color("orange"))
                    .foregroundColor(.black)
                    .cornerRadius(4)
                }
            }.padding(12)
            .frame(width: 330)
            .border(width: 1, edges: [.top, .bottom, .leading, .trailing], color: Color.gray.opacity(0.3))
            .background(Color("kanbanInside"))
        }.onAppear(){
            self.googleCalendars = authViewModel.getGoogleAccounts()
            if (self.googleCalendars.count > 0){
                self.selectedGoogleCalendar = self.googleCalendars[0]
                self.account_id = self.selectedGoogleCalendar.id
                self.firstname = authViewModel.getSingleAccountName(accountIDToEdit: self.account_id)
                self.bgColor = Color(hex: authViewModel.getSingleAccountColor(accountIDToEdit: self.account_id))
                
            }
        }.frame(width: contentWidth, height: 300.0)
        .padding(10)
        
    }
}

struct AccountsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsSettingsView()
    }
}
