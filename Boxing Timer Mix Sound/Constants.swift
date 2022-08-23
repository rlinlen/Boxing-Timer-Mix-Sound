//
//  Constants.swift
//  Boxing Timer Mix Sound
//
//  Created by Len Lin on 2022/8/23.
//

struct K {
    struct Timer {
        static let roundTime: Int = 180
        static let intervalTime: Int = 30
        static let waitTime: Int = 2
        static let repeatRound: Int = 10
    }
    struct Sound {
        static let currentSoundTrackId: String = "defaulebell1"
        static let customizedSoundTrackId = "customized"
        static let numberOfLoops: Int = 0
        static let volume: Float = 1
        static let soundTrackMenu: [SoundTrack] = [
            SoundTrack(id: "defaulebell1",
                       displayName: "Default Bell 1",
                       fileName: "bell_ring_b.m4a",
                       url: SoundManager.getSoundTrackURL(by: "bell_ring_b.m4a")
                      ),
            SoundTrack(id: "defaulebell2",
                       displayName: "Default Bell 2",
                       fileName: "service-bell-ring.m4a",
                       url: SoundManager.getSoundTrackURL(by: "service-bell-ring.m4a")),
            SoundTrack(id: "customized",
                       displayName: "Customized",
                       fileName: "",
                       url: nil
                      )
        ]
    }
    
}
