//
//  GeneralSettingsView.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 03/08/2021.
//  Copyright © 2021 Ephod. All rights reserved.
//

import SwiftUI
import Preferences

let GeneralPreferenceViewController: () -> PreferencePane = {
    /// Wrap your custom view into `Preferences.Pane`, while providing necessary toolbar info.
    let paneView = Preferences.Pane(
        identifier: .general,
        title: "General",
        toolbarIcon: NSImage(systemSymbolName: "gearshape", accessibilityDescription: "General preferences")!
    ) {
        GeneralSettingsView()
    }

    return Preferences.PaneHostingController(pane: paneView)
}

struct GeneralSettingsView: View {
    @AppStorage("firstname", store: UserDefaults(suiteName: "group.com.ephod.ghost")) var firstname = ""
    @AppStorage("rescuetime", store: UserDefaults(suiteName: "group.com.ephod.ghost")) var rescuetimeKey = ""
    @AppStorage("autoCloseWindowEditor") var autoCloseWindowEditor = false
    @AppStorage("autoCloseWindowTimer") var autoCloseWindowTimer = 0    
    @AppStorage("notesSizeInGrid") var notesSizeInGrid = 0.0
    
    private let contentWidth: Double = 450.0
            
    var body: some View {
        Preferences.Container(contentWidth: contentWidth) {
            Preferences.Section(title: "Your name:") {
                Preferences.Section(title: "") {
                    TextField("Enter your name", text: $firstname)
                        .frame(width: 220.0)
                }
            }
                
            Preferences.Section(title: "RescueTime API Key:") {
                Preferences.Section(title: "") {
                    TextField("Enter your RescueTime API Key", text: $rescuetimeKey)
                        .frame(width: 220.0)
                    Text("Ghost uses this to fetch your productivity stats from RescueTime. \n\nYou can generate one from your ResuceTime dashboard")
                        .frame(width: 240.0)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                        .preferenceDescription()
                }
            }
            
//            Preferences.Section(label: {
//                Toggle("Auto close editor window", isOn: $autoCloseWindowEditor)
//            }) {
//                Picker("", selection: $autoCloseWindowTimer) {
//                    Text("After 1 minute").tag(0)
//                    Text("After 3 minute").tag(1)
//                    Text("After 5 minute").tag(2)
//                    }
//                .labelsHidden()
//                .frame(width: 120.0)
//                Text("The app will automatically close the window and save the note.")
//                    .preferenceDescription()
//            }
        }
    }
}

struct GeneralSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsView()
    }
}
