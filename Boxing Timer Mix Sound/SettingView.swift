//
//  SettingView.swift
//  Boxing Timer Mix Sound
//
//  Created by Len Lin on 2022/8/22.
//

import SwiftUI


struct SettingView: View{
    @State var isShowingSettingSheet = false
    
    var body: some View{
        VStack{
            Button("Settings"){
                self.isShowingSettingSheet.toggle()
            }
            .sheet(isPresented: $isShowingSettingSheet) {
                SettingsGrid(showSheetView: self.$isShowingSettingSheet)
            }
            //                .foregroundColor(.white)
            //            SettingsGrid()
        }
        .padding(.top, 50)
        .padding(.bottom, 50)
    }
}

struct SettingsGrid: View{
    @EnvironmentObject var timerManager: TimerManager
    
    @Binding var showSheetView: Bool
    
    @State var roundNumberIndex: Int = 0
    
    
    var gridItemLayout = [GridItem(.adaptive(minimum: 150, maximum: 300), spacing: 25)]
    
    var body: some View{
        NavigationView {
            VStack(spacing: 30){
                //            LazyVGrid(columns: gridItemLayout, spacing: 25){
                SettingItemInt(
                    timerParameter: $timerManager.repeatRound,
                    //                        timerParameterRemaining: $timerManager.repeatRoundRemaining,
                    label: "Round Number: ",
                    action: { value in
                        print(value)
                        timerManager.repeatRoundRemaining = Int(value)
                    })
                SettingItemTime(
                    timerParameter: $timerManager.waitTime,
                    timerParameterRemaining: $timerManager.waitTimeRemaining,
                    label: "Wait Time: ")
                SettingItemTime(
                    timerParameter: $timerManager.roundTime,
                    timerParameterRemaining: $timerManager.roundTimeRemaining,
                    label: "Round Time: ")
                SettingItemTime(
                    timerParameter: $timerManager.intervalTime,
                    timerParameterRemaining: $timerManager.intervalTimeRemaining,
                    label: "Interval Time: ")
                SettingItemInt(
                    timerParameter: $timerManager.soundManager.numberOfLoops,
                    label: "Sound Loop Number: ",
                    action: {
                        value in
                    })
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
                Spacer()
                //            }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.teal)
            //            .background(Color.teal.ignoresSafeArea(.all, edges: .all))
            //        .disabled(timerManager.isTiming)
            .navigationBarTitle(Text("Settings"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                //                    print("Dismissing sheet view...")
                self.showSheetView = false
            }) {
                Text("Done").bold()
            })
        }
        
    }
    
    
}

struct SheetView: View {
    //
    enum Flavor: String, CaseIterable, Identifiable {
        case chocolate, vanilla, strawberry
        var id: Self { self }
    }
    
    @State private var selectedFlavor: Flavor = .chocolate
    
    
    var body: some View {
        Picker("Flavor", selection: $selectedFlavor) {
            Text("Chocolate")
            //                .foregroundColor(.white)
                .tag(Flavor.chocolate)
            Text("Vanilla")
            //                .foregroundColor(.white)
                .tag(Flavor.vanilla)
            Text("Strawberry")
            //                .foregroundColor(.white)
                .tag(Flavor.strawberry)
        }
        .pickerStyle(WheelPickerStyle())
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

struct SettingItemInt: View {
    @Binding var timerParameter: Int
    
    @State var label: String
    @State var action: (Int)->Void
    
    var body: some View{
        GeometryReader { geometry in
            VStack(spacing: 0){
                Text(label)
                
                Picker(label, selection: $timerParameter){
                    ForEach(1..<61) { round in
                        Text(String(round)).tag(round)
                    }
                }
                .onChange(of: timerParameter) { value in
                    self.action(value)
                }
                
                
                .pickerStyle(.wheel)
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                .compositingGroup()
                .clipped()
            }
        }
    }
}

struct SettingItemTime: View {
    @Binding var timerParameter: Int
    @Binding var timerParameterRemaining: Int
    @State var label: String
    //    @State var items: View
    //TODO: generelaize this
    
    var body: some View{
//        HStack{
//            Text(label).foregroundColor(.white)
//            Picker(label, selection: $timerParameter){
//                ForEach(0..<30) { round in
//                    Text(String(round))
//                }
//            }.onChange(of: timerParameter) { value in
//                print(value)
//                //                timerManager.repeatRound = Int(value)
//                timerParameterRemaining = Int(value)
//            }
//            //            .pickerStyle(MenuPickerStyle())
//        }
        VStack{
            Text(label)
            TimePicker()
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
