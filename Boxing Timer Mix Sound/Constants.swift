//
//  Constants.swift
//  Boxing Timer Mix Sound
//
//  Created by Len Lin on 2022/8/23.
//

struct K {
    struct Ad {
        static let bannerId: String = "ca-app-pub-4247917994581173/1717378251"
        
        //test
        //        static let bannerId: String = "ca-app-pub-3940256099942544/2934735716"
    }
    struct Timer {
        static let roundTime: Int = 180
        static let intervalTime: Int = 30
        static let waitTime: Int = 3
        static let repeatRound: Int = 10
    }
    struct Sound {
        static let currentSoundTrackStartId: String = "defaulebell1"
        static let currentSoundTrackEndId: String = "defaulebell1"
        static let currentSoundTrackAllEndId: String = "defaulebell1"
        static let customizedSoundTrackId = "customized"
        static let numberOfLoops: Int = 0
        static let volume: Float = 1
        static let isStopBackgroundPlayer: Bool = true
        static let soundTrackMenu: [SoundTrack] = [
            SoundTrack(id: "defaulebell1",
                       displayName: "Default",
                       fileName: "bell_ring_b.m4a",
                       url: SoundManager.getSoundTrackURL(by: "bell_ring_b.m4a")
                      ),
            SoundTrack(id: "defaulebell2",
                       displayName: "Short",
                       fileName: "service-bell-ring.m4a",
                       url: SoundManager.getSoundTrackURL(by: "service-bell-ring.m4a")),
            SoundTrack(id: "defaulebell3",
                       displayName: "Soft",
                       fileName: "mixkit-fairy-bells-583.wav",
                       url: SoundManager.getSoundTrackURL(by: "mixkit-fairy-bells-583.wav")),
            SoundTrack(id: "defaulebell4",
                       displayName: "Energetic",
                       fileName: "mixkit-marimba-waiting-ringtone-1360.m4a",
                       url: SoundManager.getSoundTrackURL(by: "mixkit-marimba-waiting-ringtone-1360.m4a")),
            SoundTrack(id: "defaulebell5",
                       displayName: "Dog",
                       fileName: "mixkit-dog-barking-twice-1.wav",
                       url: SoundManager.getSoundTrackURL(by: "mixkit-dog-barking-twice-1.wav")),
            SoundTrack(id: "customized",
                       displayName: "Customized",
                       fileName: "",
                       url: nil
                      )
        ]
    }
    struct Helper{
        static let useCase: [UseCase] = [
            UseCase(
                title: "Boxing",
                subTitle: "A Very Loud Timer which can catch your attention",
                content: """
                • Set the 'Total Round Number' to 3
                • Set the 'Round Time' to 3 minutes
                • Set the 'Interval Time' to 1 minutes
                • Slide the 'Sound Volume' to 5
                • Enable 'Stop Background Music when Finish'
                • Start!
                """,
                icon: "b.square.fill"
            ),
            UseCase(
                title: "Workout",
                subTitle: "Play Background Music with Timer",
                content: """
                • Choose any music player and put them into background
                • Disable 'Stop Background Music when Finish'
                • Start!
                """,
                icon: "deskclock"
            ),
            UseCase(
                title: "Sleep",
                subTitle: "Stop Background Music after an Hour",
                content: """
                • Choose any music player and put them into background
                • Set the 'Total Round Number' to 1
                • Set the 'Round Time' to 60 minutes
                • Enable 'Stop Background Music when Finish'
                • Slide the 'Sound Volume' to 0
                • Start!
                • The screen will stay on while playing, and it will go to lock mode while not playing (i.e. after the times up).
                """,
                icon: "powersleep"
            ),
            UseCase(
                title: "Customization",
                subTitle: "Choose Your Own Sound",
                content: """
                • Set the 'Start Bell' to 'Customized'
                • Set the 'End Bell' to 'Customized'
                • Set the 'Finish Bell' to 'Customized'
                • Start!
                """,
                icon: "hifispeaker.fill"
            ),
            UseCase(
                title: "Other Questions",
                subTitle: "Report issues and suggestions",
                content: """
                //                • Please feel free to contact len.lin@gonglinli.com
                """,
                icon: "envelope.fill"
            )
        ]
    }
}
