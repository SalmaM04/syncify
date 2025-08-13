//
//  GameManager.swift
//  syncify
//
//  Created by Salma M. on 8/12/25.
//
//  Purpose: Tiny game engine used by the GameViewController.
//  Workflow:
//  1) startNewGame(...) builds a GameSession with mock songs
//  2) getCurrentSong() returns the song for the curr index
//  3) processPlayerChoice(.like/.pass) records a choice,
//     swaps turns, advances song when both have chosen,
//     and returns the new GameState so the VC can react
//

import Foundation


final class GameManager {
    static let shared = GameManager()
    private init() {}

    private var session: GameSession?

    // start a new game (names required; playlist URLs optional)
    func startNewGame(player1Name: String,
                      player1URL: URL? = nil,
                      player2Name: String,
                      player2URL: URL? = nil) {

        var p1 = Player(name: player1Name, playlistURL: player1URL, currentChoice: nil)
        var p2 = Player(name: player2Name, playlistURL: player2URL, currentChoice: nil)

        let deck = createMockSongs()

        // first turn = player 1
        session = GameSession(
            player1: p1,
            player2: p2,
            currentPlayerIndex: 0,
            currentSongIndex: 0,
            songs: deck,
            matches: [],
            state: .player1Turn
        )
    }

    // read helpers for the VC
    func getCurrentSession() -> GameSession? { session }

    func getCurrentSong() -> Song? {
        guard let s = session, s.currentSongIndex < s.songs.count else { return nil }
        return s.songs[s.currentSongIndex]
    }

    // core logic: record choice, maybe advance turn/song
    @discardableResult
    func processPlayerChoice(_ choice: Player.SwipeChoice) -> GameSession.GameState {
        guard var s = session else { return .setup }

        // record choice on the active player
        if s.currentPlayerIndex == 0 {
            s.player1.currentChoice = choice
        } else {
            s.player2.currentChoice = choice
        }

        // if both players have a choice for this song, evaluate + advance
        if let c1 = s.player1.currentChoice, let c2 = s.player2.currentChoice {
            // both chose — if both liked, add to matches
            if c1 == .like && c2 == .like, s.currentSongIndex < s.songs.count {
                s.matches.append(s.songs[s.currentSongIndex])
            }

            // move to next song
            s.currentSongIndex += 1
            s.player1.currentChoice = nil
            s.player2.currentChoice = nil

            if s.currentSongIndex >= s.songs.count {
                s.state = .gameComplete
            } else {
                s.currentPlayerIndex = 0
                s.state = .player1Turn
            }
        } else {
            // only one player has chosen so far → swap to other player
            s.switchToNextPlayer()
            s.state = (s.currentPlayerIndex == 0) ? .player1Turn : .player2Turn
        }

        session = s
        return s.state
    }

    // mock data
    private func createMockSongs() -> [Song] {
        return [
               Song(id: "1", name: "Anti-Hero", artist: "Taylor Swift",
                    albumName: "Midnights",
                    albumImageURL: "https://picsum.photos/seed/taylorswift/400"),

               Song(id: "2", name: "As It Was", artist: "Harry Styles",
                    albumName: "Harry's House",
                    albumImageURL: "https://picsum.photos/seed/harrystyles/400"),

               Song(id: "3", name: "Bad Habit", artist: "Steve Lacy",
                    albumName: "Gemini Rights",
                    albumImageURL: "https://picsum.photos/seed/stevelacy/400"),

               Song(id: "4", name: "About Damn Time", artist: "Lizzo",
                    albumName: "Special",
                    albumImageURL: "https://picsum.photos/seed/lizzo/400"),

               Song(id: "5", name: "Running Up That Hill", artist: "Kate Bush",
                    albumName: "Hounds of Love",
                    albumImageURL: "https://picsum.photos/seed/katebush/400")
           ]
    }
}
