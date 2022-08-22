//
//  SettingView.swift
//  Boxing Timer Mix Sound
//
//  Created by Len Lin on 2022/8/22.
//

import SwiftUI


struct SettingView: View{
    var body: some View{
        VStack{
            Text("Settings:").foregroundColor(.white)
            SettingsGrid()
        }
        .padding(.top, 50)
    }
}

struct SettingsGrid: View{
    @EnvironmentObject var timerManager: TimerManager
    
    @State var roundNumberIndex: Int = 0
    

    
    private var gridItemLayout = [GridItem(.adaptive(minimum: 150, maximum: 300), spacing: 25)]
    
    var body: some View{
        LazyVGrid(columns: gridItemLayout, spacing: 25){
//            SettingItem(repeatRound: $timerManager.repeatRound, repeatRoundRemaining: $timerManager.repeatRoundRemaining)
            SettingItem(
                timerParameter: $timerManager.repeatRound,
                timerParameterRemaining: $timerManager.repeatRoundRemaining,
                label: "Round Number: ")
            SettingItem(
                timerParameter: $timerManager.waitTime,
                timerParameterRemaining: $timerManager.waitTimeRemaining,
                label: "Wait Time: ")
            SettingItem(
                timerParameter: $timerManager.roundTime,
                timerParameterRemaining: $timerManager.roundTimeRemaining,
                label: "Round Time: ")
            SettingItem(
                timerParameter: $timerManager.intervalTime,
                timerParameterRemaining: $timerManager.intervalTimeRemaining,
                label: "Interval Time: ")
            SettingTimerItem(
                timerParameter: $timerManager.soundManager.numberOfLoops,
                label: "Sound Loop Number: ")
            SettingSoundTrack(
                timerParameter: $timerManager.soundManager.soundTrackType,
                soundManager: $timerManager.soundManager,
                label: "Sound track: ",
                action: { value in
//                    print("action!")
//                    print(value)
                    timerManager.soundManager.soundTrackFullURL = value
                }
            )
        }.disabled(timerManager.isTiming)
        
    }
    
}

struct SettingItem: View {
    @Binding var timerParameter: Int
    @Binding var timerParameterRemaining: Int
    @State var label: String
//    @State var items: View
    //TODO: generelaize this
    
    var body: some View{
        HStack{
            Text(label).foregroundColor(.white)
            Picker(label, selection: $timerParameter){
                ForEach(0..<30) { round in
                    Text(String(round))
                }
            }.onChange(of: timerParameter) { value in
                print(value)
//                timerManager.repeatRound = Int(value)
                timerParameterRemaining = Int(value)
            }
//            .pickerStyle(MenuPickerStyle())
        }
//        .onAppear(){
//            roundNumberIndex = timerManager.repeatRound
//        }
    }
}

struct SettingTimerItem: View {
    @Binding var timerParameter: Int
    @State var label: String
//    @State var items: View
    //TODO: generelaize this
    
    var body: some View{
        HStack{
            Text(label).foregroundColor(.white)
            Picker(label, selection: $timerParameter){
                ForEach(0..<30) { round in
                    Text(String(round))
                }
            }.onChange(of: timerParameter) { value in
                print(value)
            }
        }
    }
}

struct SettingSoundTrack: View {
    @Binding var timerParameter: String
    @Binding var soundManager: SoundManager
    @State var label: String
    @State private var isImporting: Bool = false
    @State var action: (URL)->Void
    
    var body: some View{
        HStack{
            Text(label).foregroundColor(.white)
//            Text("\(timerParameter)").foregroundColor(.white)
            Picker(label, selection: $timerParameter){
//                Text("Default Ring 1").tag("Default Ring 1")
//                Text("Default Ring 2").tag("Default Ring 2")
//                Text("Customized").tag("Customized")
//                ForEach(SoundManager.soundTrackMenu.allCases, id: \.rawValue) { value in
//                    Text(value.rawValue)
//                                        .tag(value)
//                }
                ForEach(soundManager.soundTrackMenu, id: \.id){ item in
                    Text(item.displayName).tag(item.id)
                }
//                ForEach(0..<30) { round in
//                    Text(String(round))
//                }
            }
            .onChange(of: timerParameter) { value in
//                print(value)
                if(value == "customized"){
                    isImporting = true
                }else{
                    for item in soundManager.soundTrackMenu {
                        if (item.id == value) {
                            print(item.fileName)
                            soundManager.soundTrackFullURL = soundManager.getSoundTrackURL(by: item.fileName as NSString)!
                        }
                    }
                }
                
            }
            .fileImporter(isPresented: $isImporting,
                          allowedContentTypes: [.audio],
                          allowsMultipleSelection: false){ result in
                do {
                    guard let selectedFile: URL = try result.get().first else { return }
                    self.action(selectedFile)
//                            print(selectedFile)
//                    print(selectedFile.pathExtension)
//                    print(selectedFile.deletingPathExtension())
//                    print(selectedFile.deletingPathExtension().lastPathComponent)
                    
                } catch {
                    // Handle failure.
                    print("Unable to read file contents")
                    print(error.localizedDescription)
                }
            }
        }
    }
}
