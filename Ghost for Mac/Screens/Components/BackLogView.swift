//
//  BackLogView.swift
//  Ghost
//
//  Created by Bezaleel Ashefor on 07/10/2021.
//  Copyright © 2021 Ephod. All rights reserved.
//

import SwiftUI

struct BackLogView: View {
    @StateObject var backlogDH = BacklogDH()
    var eventViewModel = EventsViewModel()
    
    var body: some View {
        VStack(spacing: 0){
            HStack(alignment: .center){
                Text("Backlog")
                    .font(.custom("Overpass-Bold", size: 18))
                Spacer()
                Button(action: {}) {
                    HStack{
                        Image(systemName: "note.text.badge.plus")
                            .font(.system(size: 16, weight: .bold))
                            .padding([.leading], 8)
                        Text("Add Item")
                            .font(.custom("Overpass-Regular", size: 14))
                            .padding([.top, .bottom], 6)
                            .padding([.trailing], 10)
                            .padding([.leading], 0)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .background(Color("orange"))
                .foregroundColor(.black)
                .cornerRadius(4)
            }.padding([.top], 16).padding([.leading, .trailing], 18)
            if (backlogDH.backlog.count > 0){
                List {
                    ForEach(backlogDH.backlog, id: \.id){ backlog in
                       SingleBacklogView(backlog: backlog)
                            .padding([.bottom], 14)
                    }.listRowBackground(Color.clear)
                }
                .listStyle(PlainListStyle())
                .padding(.horizontal, 8)
                .padding([.top], 16)
                Spacer()
            } else {
                Spacer()
                Text("Put things you want to do but don't know when you want to do them, here")
                    .font(.custom("Overpass-Regular", size: 14))
                Spacer()
            }
        }
        .frame(width: 320)
        .background(Color("kanbanInside"))
        .border(width: 1, edges: [.leading], color: Color("kanbanItemBorder"))
        .onAppear(perform: {
            eventViewModel.fetchBacklog(completion: { results in
                self.backlogDH.backlog = results
            })
        })
    }
}

struct BackLogView_Previews: PreviewProvider {
    
    static var previews: some View {
        BackLogView()
    }
}
