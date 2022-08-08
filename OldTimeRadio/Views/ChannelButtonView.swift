//
//  ChannelButtonView.swift
//  OldTimeRadio
//
//  Created by Dima Bondarenko on 06.08.2022.
//

import SwiftUI

struct ChannelButtonView: View {
    @Binding var isSelected: Bool
    @State var label: String
    var handler: (String) -> Void
    
    var body: some View {
        Button {
            handler(label)
        } label: {
            HStack {
                Image(systemName: isSelected ? "mic" : "mic.slash")
                Text(label.capitalized)
            }
            
        }
        
    }
}

struct ChannelButtonView_Previews: PreviewProvider {
    static var selectedChannel = ""
    static var previews: some View {
        ChannelButtonView(isSelected: .constant(false), label: "future") { resp in
            if resp == selectedChannel {
                selectedChannel = ""
            } else {
                selectedChannel = resp
            }
        }
    }
}
