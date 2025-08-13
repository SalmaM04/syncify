//
//  Models.swift
//  syncify
//
//  Created by Salma M. on 8/12/25.
//
//  Purpose: Data shapes used by the swipe game.
//  Workflow:
//  - Song: what the card displays (title/artist/album art URL)
//  - Player: each person’s name and (optional) playlist URL
//  - GameSession: snapshot of the game (who’s turn, which song, matches, etc)
//

import Foundation


// what each card shows
struct Song {
    let id: String
    let name: String
    let artist: String
    let albumName: String
    let albumImageURL: String?   // remote image URL string (used by the card to load artwork)

    // helper used for printing
    var displayText: String { "\(name) — \(artist)" }
}

// two players sharing one phone
struct Player {
    let name: String
    var playlistURL: URL?         // optional;  use later with Spotify
    var currentChoice: SwipeChoice?  // their choice for the current song (temp)

    enum SwipeChoice { case like, pass }
}

//  overall game state while swiping
struct GameSession {
    var player1: Player
    var player2: Player

    var currentPlayerIndex: Int   // 0 => player1, 1 => player2
    var currentSongIndex: Int

    var songs: [Song]             // the deck of cards
    var matches: [Song]           // songs both players liked
    var state: GameState

    var currentPlayer: Player { currentPlayerIndex == 0 ? player1 : player2 }

    mutating func switchToNextPlayer() {
        currentPlayerIndex = currentPlayerIndex == 0 ? 1 : 0
    }

    enum GameState {
        case setup
        case player1Turn
        case player2Turn
        case waitingForBothChoices
        case showingResult
        case gameComplete
    }
}
