//
//  HomeScreen.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 08/07/2021.
//  Copyright © 2021 Ephod. All rights reserved.
//

import SwiftUI
import AppKit

struct HomeScreen: View {
    @State private var date = Date()
    
    var today : Date!
    let daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var daysArray = [String]()
    var datesArray = [String]()
    let helper = DateHelper()
    
    init() {
        today = Date()
        for i in 0..<14 {
            let dayDiff = i - 7
            let nextDate = Calendar.current.date(byAdding: .day, value: dayDiff, to: today)
            let index = helper.getDayOfWeek(today: nextDate!)! - 1
            datesArray.append(helper.formatDateToBeauty(thisDate: nextDate!, type: "day"))
            daysArray.append(daysOfWeek[index])
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(alignment: .center){
                VStack(alignment: .leading){
                    Text("Hi Bezaleel")
                        .font(.system(size: 20, weight: .bold))
                    Text("Seeking today's productivity")
                        .font(.system(size: 12))
                }
                .padding([.leading, .trailing], 14)
                .padding([.top], 10)
                .padding([.bottom], 14)
                Spacer()
                VStack{
                    Button(action: {print("balls")}) {
                        HStack{
                            Image(systemName: "calendar.badge.plus")
                                .font(.system(size: 16, weight: .bold))
                                .padding([.leading], 10)
                            Text("Add Schedule")
                                .padding([.top, .bottom], 6)
                                .padding([.trailing], 10)
                                .padding([.leading], 2)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .background(Color("orange"))
                    .foregroundColor(.black)
                    .cornerRadius(4)
                }
                .padding([.leading, .trailing], 14)
            }.frame(maxWidth: .infinity)
            .background(Color("GhostBlue"))
            ScrollViewReader{ scrollView in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0){
                        ForEach(0..<14, id: \.self) { i in
                            VStack(alignment: .leading, spacing: 0) {
                                VStack(alignment: .leading, spacing: 0){
                                    Text(daysArray[i] + ", " +  datesArray[i]).font(.custom("Overpass-Regular", size: 14))
                                        .padding([.leading, .trailing], 6)
                                        .padding([.top, .bottom], 10)
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                        .background(Color("GhostBlue"))
                                    Spacer()
                                }
                                .frame(width: 310)
                                .background(Color("bgColor"))
                                .cornerRadius(4)
                            }
                            .id(i)
                            .padding([.top, .leading, .bottom], 15)
                        }
                    }
                    .padding([.trailing], 15)
                    .frame(width: .infinity, height: .infinity)
                }.onAppear(){
                    scrollView.scrollTo(7, anchor: .leading)
                }
            }
        
        }.frame(minWidth: 700,  maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)
        .background(Color("darkBgColor"))
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}

class HomeHostingController: NSHostingController<HomeScreen> {

    @objc required dynamic init?(coder: NSCoder) {
           super.init(coder: coder, rootView: HomeScreen())
    }

}

