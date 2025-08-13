//
//  GameViewController.swift
//  syncify
//
//  Created by Salma M. on 8/12/25.
//
//  WHAT THIS SCREEN DOES
//  1) Reads the current game session from GameManager (players, songs, index)
//  2) Shows header text: "<current player's name>'s Turn" and "Song X of Y"
//  3) Loads one swipe card into cardContainerView (album art + song + artist)
//  4) When the user swipes the card:
//        - tell GameManager the choice (.like / .pass)
//        - ask for the next song
//        - reload the next card
//  5) When no songs remain,  navigate to the Results screen
//
//  RELATD FILES
//  - Models.swift: Song, Player, GameSession ( data types)
//  - GameManager.swift: owns the current GameSession & game logic
//  - SwipeCardView(.xib + .swift): the visual card + gesture handling
//  - PlayerSetupViewController.swift: creates the session, pushes this screen
import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var currentPlayerLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var cardContainerView: UIView!
    
    private var currentCard: SwipeCardView? // refernce to curr card so we can remove it before adding next card
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Syncify"
        navigationItem.hidesBackButton = true
        
        // 1 - Update the header w/ player name + song counter
        updateHeader()
        
        // 2 - show the first song's card
        showNextSong()
    }
    
    // pulls data from GameManager and updates the two labels
    private func updateHeader() {
        guard let session = GameManager.shared.getCurrentSession() else { return }
        
        currentPlayerLabel.text = "\(session.currentPlayer.name)'s Turn"
        counterLabel.text = "Song \(session.currentSongIndex + 1) of \(session.songs.count)"
    }
    
    // removes the old card (if any), asks the GameManager for the current song,
    // loads the SwipeCardView from its XIB, configures it, and drops it into the container
    private func showNextSong() {
        // clear old card from the container
        currentCard?.removeFromSuperview()
        
        // ask the GameManager for the current song at currentSongIndex
        guard let song = GameManager.shared.getCurrentSong() else {
            // pop back with a simple alert (temp - will add result screen )
            let alert = UIAlertController(title: "All done!",
                                          message: "You’ve reached the end of the list.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            })
            present(alert, animated: true)
            return
        }
        
        // load the reusable card view from its XIB
        guard let card = Bundle.main
            .loadNibNamed("SwipeCardView", owner: nil, options: nil)?
            .first as? SwipeCardView else {
            print("Could not load SwipeCardView.xib")
            return
        }
        
        // hook delegate so swipes report back here
        card.delegate = self
        
        // fill in the UI on the card (labels + image)
        card.configure(with: song)
        
        // make the card fill the container with a tiny inset so it looks nice
        card.frame = cardContainerView.bounds.insetBy(dx: 8, dy: 8)
        card.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // put it on screen
        cardContainerView.addSubview(card)
        currentCard = card
        
        // refresh header
        updateHeader()
    }
    
}


// the card tells us which way it was swiped -> we forward that choice to GameManager -> updates the game state ->
//  load the next card
extension GameViewController: SwipeCardDelegate {
    func cardDidSwipeRight(_ song: Song) {
        // player liked the song
        let _ = GameManager.shared.processPlayerChoice(.like)
        // ask for the next song/card
        showNextSong()
    }

    func cardDidSwipeLeft(_ song: Song) {
        // player passed the song
        let _ = GameManager.shared.processPlayerChoice(.pass)
        // ask for the next song/card
        showNextSong()
    }
}
