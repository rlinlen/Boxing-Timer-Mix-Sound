//
//  Constants.swift
//  Boxing Timer Mix Sound
//
//  Created by Len Lin on 2022/8/23.
//

struct K {
    struct Ad {
        //        static let bannerId: String = "ca-app-pub-4247917994581173/1717378251"
        //test
        static let bannerId: String = "ca-app-pub-3940256099942544/2934735716"
    }
    struct Timer {
        static let roundTime: Int = 180
        static let intervalTime: Int = 30
        static let waitTime: Int = 2
        static let repeatRound: Int = 10
    }
    struct Sound {
        static let currentSoundTrackStartId: String = "defaulebell1"
        static let currentSoundTrackEndId: String = "defaulebell2"
        static let currentSoundTrackAllEndId: String = "defaulebell2"
        static let customizedSoundTrackId = "customized"
        static let numberOfLoops: Int = 0
        static let volume: Float = 1
        static let isStopBackgroundPlayer: Bool = true
        static let soundTrackMenu: [SoundTrack] = [
            SoundTrack(id: "defaulebell1",
                       displayName: "Default Bell 1",
                       fileName: "bell_ring_b.m4a",
                       url: SoundManager.getSoundTrackURL(by: "bell_ring_b.m4a")
                      ),
            SoundTrack(id: "defaulebell2",
                       displayName: "Short Bell 1",
                       fileName: "service-bell-ring.m4a",
                       url: SoundManager.getSoundTrackURL(by: "service-bell-ring.m4a")),
            SoundTrack(id: "defaulebell3",
                       displayName: "Soft Bell 1",
                       fileName: "mixkit-fairy-bells-583.wav",
                       url: SoundManager.getSoundTrackURL(by: "mixkit-fairy-bells-583.wav")),
            SoundTrack(id: "defaulebell4",
                       displayName: "Energy Bell 1",
                       fileName: "mixkit-marimba-waiting-ringtone-1360.m4a",
                       url: SoundManager.getSoundTrackURL(by: "mixkit-marimba-waiting-ringtone-1360.m4a")),
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
                Set the 'Total Round Number' to 3
                Set the 'Round Time' to 3 minutes
                Set the 'Interval Time' to 1 minutes
                Slide the 'Sound Volume' to 5
                Enable 'Stop Background Music when Finish'
                Start!
                """,
                icon: "b.square.fill"
            ),
            UseCase(
                title: "Workout",
                subTitle: "Play Background Music with Timer",
                content: """
                Choose any music player and put them into background
                Disable 'Stop Background Music when Finish'
                Start!
                """,
                icon: "deskclock"
            ),
            UseCase(
                title: "Sleep",
                subTitle: "Stop background music after an hour",
                content: """
                Choose any music player and put them into background
                Set the 'Total Round Number' to 1
                Set the 'Round Time' to 60 minutes
                Enable 'Stop Background Music when Finish'
                Slide the 'Sound Volume' to 0
                Start!
                The screen will stay on while playing, while it will go to lock mode while not playing.
                """,
                icon: "powersleep"
            )
        ]
    }
}
