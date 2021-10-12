//
//  SingleBacklogView.swift
//  Ghost
//
//  Created by Bezaleel Ashefor on 07/10/2021.
//  Copyright © 2021 Ephod. All rights reserved.
//

import SwiftUI

struct SingleBacklogView: View {
    var backlog : Backlog
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            HStack{
                Text(backlog.summary).font(.custom("Overpass-Regular", size: 15))
                        .lineSpacing(3.2)
                Spacer()
            }
            HStack(alignment: .center){
                Text(backlog.dateAdded.timeAgoDisplay()).font(.custom("Overpass-Regular", size: 12)).opacity(0.5).padding([.top], 6)
                Spacer()
                Button(action: {}) {
                    HStack(spacing: 4){
                        Image(systemName: "calendar.badge.plus")
                            .font(.system(size: 14, weight: .bold))
                            .padding([.leading], 8)
                        Text("Add To Calendar")
                            .font(.custom("Overpass-Regular", size: 14))
                            .padding([.top, .bottom], 6)
                            .padding([.trailing], 10)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .background(Color(NSColor(hex: "262626")!))
                .foregroundColor(Color.white)
                .cornerRadius(4)
            }.padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
        }.contextMenu {
            Button(action: {}){
                Label("Edit Item", systemImage: "pencil")
            }
            Button(action: {}){
                Label("Delete Item", systemImage: "trash")
            }
        }
        .padding([.leading, .trailing], 12)
        .padding([.top, .bottom], 10)
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
          )
        .background(Color("darkBgColor"))
        .cornerRadius(5)
    }
}

struct SingleBacklogView_Previews: PreviewProvider {
    static var backlog = Backlog(summary: "Araea", description: "", dateAdded: Date(), whereAdded: "")
    
    static var previews: some View {
        SingleBacklogView(backlog: backlog)
    }
}
