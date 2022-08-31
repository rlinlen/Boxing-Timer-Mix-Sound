//
//  SettingView.swift
//  Boxing Timer Mix Sound
//
//  Created by Len Lin on 2022/8/22.
//

import SwiftUI


struct SettingView: View{
    @EnvironmentObject var timerManager: TimerManager
    @State var isShowingSettingSheet = false
    
    var body: some View{
        VStack{
            Button("Settings"){
                self.isShowingSettingSheet.toggle()
            }
            .sheet(isPresented: $isShowingSettingSheet) {
                SettingsGrid(showSheetView: self.$isShowingSettingSheet)
                                    .environmentObject(timerManager)
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
    @State var showHelperView: Bool = false
    
//    var gridItemLayout = [GridItem(.adaptive(minimum: 150, maximum: 300), spacing: 25)]
    var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View{
        NavigationView {
            VStack(spacing: 10){
                Group {
                    SettingItemInt(
                        timerParameter: $timerManager.repeatRound,
                        label: "Total Round Number: ",
                        range: 1..<61,
                        action: { value in
                            print(value)
                            timerManager.repeatRoundRemaining = Int(value)
                        })
                    Divider()
                }
                Group {
                    SettingItemTime(
                        timerParameter: $timerManager.waitTime,
                        //                        timerParameterRemaining: $timerManager.waitTimeRemaining,
                        label: "Initial Wait Time: "){value in
                            //                            print(value)
                            timerManager.waitTimeRemaining = Int(value)
                        }
                    Divider()
                    SettingItemTime(
                        timerParameter: $timerManager.roundTime,
                        //                        timerParameterRemaining: $timerManager.roundTimeRemaining,
                        label: "Round Time: "){value in
                            //                            print(value)
                            timerManager.roundTimeRemaining = Int(value)
                        }
                    Divider()
                    SettingItemTime(
                        timerParameter: $timerManager.intervalTime,
                        //                        timerParameterRemaining: $timerManager.intervalTimeRemaining,
                        label: "Interval Time: "){value in
                            //                            print(value)
                            timerManager.intervalTimeRemaining = Int(value)
                        }
                    Divider()
                }
                Group{
                    SettingItemInt(
                        timerParameter: $timerManager.soundManager.numberOfLoops,
                        label: "Sound Loop Number: ",
                        range: 0..<61,
                        action: {
                            value in
                        })
                    Divider()
                    SettingItemToggle(
                        timerParameter: $timerManager.soundManager.isStopBackgroundPlayer,
                        label: "Stop Background Music when Finish: "
                    )
                    
                    Divider()
                    Text("Sound Track")
                    LazyVGrid(columns: gridItemLayout, spacing: 0) {
                        SettingSoundTrackItem(
                            timerParameter: $timerManager.soundManager.currentSoundTrackStartId,
                            soundManager: $timerManager.soundManager,
                            soundTrackKey: "currentSoundTrackStartId",
                            label: "Start Bell: "
                        )
                        SettingSoundTrackItem(
                            timerParameter: $timerManager.soundManager.currentSoundTrackEndId,
                            soundManager: $timerManager.soundManager,
                            soundTrackKey: "currentSoundTrackEndId",
                            label: "End Bell: "
                        )
                        SettingSoundTrackItem(
                            timerParameter: $timerManager.soundManager.currentSoundTrackAllEndId,
                            soundManager: $timerManager.soundManager,
                            soundTrackKey: "currentSoundTrackAllEndId",
                            label: "Finish Bell: "
                        )
                    }
                    
                    Spacer()
                }
                
                //            }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            //            .background(Color.teal)
            //            .background(Color.teal.ignoresSafeArea(.all, edges: .all))
            //        .disabled(timerManager.isTiming)
            .navigationBarTitle(Text("Settings"), displayMode: .inline)
            .navigationBarItems(
                leading: Button(action:{
                    showHelperView.toggle()
                }){
                    Image(systemName: "questionmark.circle")
                        .font(.system(size: 20))
//                        .foregroundColor(.white)
//                        .buttonStyle(PlainButtonStyle())
                }
                    .sheet(isPresented: $showHelperView) {
                        HelperView(isDisplay: $showHelperView)
                    }
                ,
                
                trailing: Button(action: {
                self.showSheetView = false
                    self.timerManager.soundManager.stopSound()
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





struct SettingItemInt: View {
    @Binding var timerParameter: Int
    
    @State var label: String
    @State var range: Range<Int>
    @State var action: (Int)->Void
    
    var body: some View{
        GeometryReader { geometry in
            VStack(spacing: 0){
                Text(label)
                
                if #available(iOS 14, *){
                    Picker(label, selection: $timerParameter){
                        ForEach(self.range, id: \.self) { round in
                            Text(String(round)).tag(round)
                        }
//                        Text("1").tag(1)
//                                    Text("2").tag(2)
//                                    Text("3").tag(3)
                    }
                    .onChange(of: timerParameter) { value in
    //                    print(value)
                        self.action(value)
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.75, alignment: .center)
                    .compositingGroup()
                    .clipped()
                } else {
                    Picker(label, selection: $timerParameter){
                        ForEach(self.range) { round in
                            Text(String(round)).tag(round)
                        }
                    }
                    .onChange(of: timerParameter) { value in
    //                    print(value)
                        self.action(value)
                    }
                    .pickerStyle(.wheel)
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.75, alignment: .center)
                    .compositingGroup()
                    .clipped()
                }
                
            }
        }
    }
}


struct SettingItemToggle: View {
    @Binding var timerParameter: Bool
    
    @State var label: String
    
    var body: some View{
        Toggle(isOn: $timerParameter){
            Text(label)
        }
        .padding(.leading, 26)
    }
}

struct SettingItemTime: View {
    @Binding var timerParameter: Int
    @State var label: String
    @State var action: (Int)->Void
    //    @State var items: View
    //TODO: generelaize this
    
    var body: some View{
        VStack(spacing: 0   ){
            Text(label)
            TimePicker(
                time: $timerParameter,
                action: self.action
            )
        }
        
        //        .onAppear(){
        //            roundNumberIndex = timerManager.repeatRound
        //        }
    }
}

struct SettingSoundTrackItem: View {
    @Binding var timerParameter: String
    @Binding var soundManager: SoundManager

    @State var soundTrackKey: String
    @State var label: String
    @State private var isImporting: Bool = false
    
    func getLabel(by id: String) -> String {
        for soundTrack in soundManager.soundTrackMenu {
            if soundTrack.id == id {
                return soundTrack.displayName
            }
        }
        return soundManager.soundTrackMenu[0].displayName
    }
    //    @State var action: (URL)->Void
    
    var body: some View{
        VStack{
            Text(label)
            //                .foregroundColor(.white)
            if #available(iOS 14, *) {
                Picker(selection: $timerParameter, label: Text(getLabel(by: timerParameter))){
                    ForEach(soundManager.soundTrackMenu, id: \.id){ item in
                        Text(item.displayName)
                            .tag(item.id)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: timerParameter) { value in
                    print(value)
                    
                    if(value == K.Sound.customizedSoundTrackId){
                        isImporting = true
                    }else{
                        timerParameter = value
                        soundManager.playSound(currentSoundTrackId: timerParameter)
                    }
                    
                }
                .fileImporter(isPresented: $isImporting,
                              allowedContentTypes: [.audio],
                              allowsMultipleSelection: false){ result in
                    do {
                        guard let selectedFile: URL = try result.get().first else { return }
                        let result = selectedFile.startAccessingSecurityScopedResource()
                        defer {
                            if (result){
                                selectedFile.stopAccessingSecurityScopedResource()
                            }
                        }
                        timerParameter = K.Sound.customizedSoundTrackId
                        try soundManager[self.soundTrackKey] = selectedFile.bookmarkData()
    //                    print("bookmarkData saved to : \(self.soundTrackKey)")
                        soundManager.playSound(
                            currentSoundTrackId: timerParameter,
                            customizedBookMark: soundManager[self.soundTrackKey] as? Data)
                    } catch {
                        // Handle failure.
                        print("Unable to read file contents")
                        print(error.localizedDescription)
                    }
                }
            } else {
                
                
                Picker(label, selection: $timerParameter){
                    ForEach(soundManager.soundTrackMenu, id: \.id){ item in
                        Text(item.displayName)
                            .tag(item.id)
                    }
                }
                .onChange(of: timerParameter) { value in
                    print(value)
                    
                    if(value == K.Sound.customizedSoundTrackId){
                        isImporting = true
                    }else{
                        timerParameter = value
                        soundManager.playSound(currentSoundTrackId: timerParameter)
                    }
                    
                }
                .fileImporter(isPresented: $isImporting,
                              allowedContentTypes: [.audio],
                              allowsMultipleSelection: false){ result in
                    do {
                        guard let selectedFile: URL = try result.get().first else { return }
                        let result = selectedFile.startAccessingSecurityScopedResource()
                        defer {
                            if (result){
                                selectedFile.stopAccessingSecurityScopedResource()
                            }
                        }
                        timerParameter = K.Sound.customizedSoundTrackId
                        try soundManager[self.soundTrackKey] = selectedFile.bookmarkData()
    //                    print("bookmarkData saved to : \(self.soundTrackKey)")
                        soundManager.playSound(
                            currentSoundTrackId: timerParameter,
                            customizedBookMark: soundManager[self.soundTrackKey] as? Data)
                    } catch {
                        // Handle failure.
                        print("Unable to read file contents")
                        print(error.localizedDescription)
                    }
                }
            }
            
        }
    }
}
