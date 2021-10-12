//
//  CheckView.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 04/10/2021.
//  Copyright © 2021 Ephod. All rights reserved.
//

import SwiftUI

typealias OnChange = ((Bool) -> Void)?

struct CheckView: View {
    var action: OnChange

     func onChanged(perform action: OnChange) -> Self {
       var copy = self
       copy.action = action
       return copy
     }
    
    @State var isChecked : Bool = false
    
    func toggle(){
        isChecked = !isChecked
        action!(isChecked)
    }
    
    var body: some View {
        Button(action: toggle){
            HStack{
                Image(systemName: isChecked ? "checkmark.square": "app").resizable().frame(width: 18, height: 18)
            }
        }.buttonStyle(PlainButtonStyle()).padding([.trailing], 2)
    }
}

struct CheckView_Previews: PreviewProvider {
    static var action = OnChange(nil)
    
    static var previews: some View {
        CheckView(action: action)
    }
}
