//
//  TimePicker.swift
//  Boxing Timer Mix Sound
//
//  Created by Len Lin on 2022/8/23.
//

import SwiftUI
import Foundation

struct TimePicker: View {
    @Binding var time: Int
    @State var action: (Int)->Void
    
    @State var minuteSelection = 0
    @State var secondSelection = 0
    
    
    var minutes = [Int](0..<61)
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
                .onChange(of: minuteSelection) { newValue in
//                    print("Name changed to \(newValue)!")
                    let totalTime = newValue * 60 + secondSelection
//                    print("totalTime \(totalTime)!")
                    time = totalTime
                    action(totalTime)
                }
                
                Picker(selection: self.$secondSelection, label: Text("")) {
                    ForEach(0 ..< self.seconds.count) { index in
                        Text("\(self.seconds[index]) s").tag(index)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: geometry.size.width/2, height: geometry.size.height, alignment: .center)
                .compositingGroup()
                .clipped()
                .onChange(of: secondSelection) { newValue in
//                    print("Name changed to \(newValue)!")
                    let totalTime = minuteSelection * 60 + newValue
//                    print("totalTime \(totalTime)!")
                    time = totalTime
                    action(totalTime)
                }
            }.onAppear(){
                self.minuteSelection = time / 60
                self.secondSelection = time % 60
            }
        }
    }
}

//https://stackoverflow.com/questions/71635032/swiftui-scrolling-on-3-wheel-pickers-inside-a-hstack-is-inaccurate/71637928#71637928
extension UIPickerView {
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
    }
}
