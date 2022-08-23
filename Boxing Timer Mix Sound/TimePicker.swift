//
//  TimePicker.swift
//  Boxing Timer Mix Sound
//
//  Created by Len Lin on 2022/8/23.
//

import SwiftUI
import Foundation

struct TimePicker: View {
    
    @State var minuteSelection = 0
    @State var secondSelection = 0
    
    
    var minutes = [Int](0..<60)
    var seconds = [Int](0..<60)
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                
                Picker(selection: self.$minuteSelection, label: Text("")) {
                    ForEach(0 ..< self.minutes.count) { index in
                        Text("\(self.minutes[index]) m").tag(index)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: geometry.size.width/2, height: geometry.size.height, alignment: .center)
                .compositingGroup()
                .clipped()
                
                Picker(selection: self.$secondSelection, label: Text("")) {
                    ForEach(0 ..< self.seconds.count) { index in
                        Text("\(self.seconds[index]) s").tag(index)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: geometry.size.width/2, height: geometry.size.height, alignment: .center)
                .compositingGroup()
                .clipped()
            }
        }
    }
}
