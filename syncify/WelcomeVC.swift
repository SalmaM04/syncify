//
//  WelcomeVC.swift
//  syncify
//
//  Created by Salma M. on 8/8/25.
//

import UIKit

class WelcomeVC: UIViewController {

    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var howItWorksTextView: UITextView!
    
    @IBOutlet weak var startButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // TextView styling so it behaves like a label with bullets
        howItWorksTextView.isEditable = false
        howItWorksTextView.isScrollEnabled = false
        howItWorksTextView.backgroundColor = .clear
        howItWorksTextView.textContainerInset = .zero
        howItWorksTextView.textContainer.lineFragmentPadding = 0

        let para = NSMutableParagraphStyle()
        para.lineSpacing = 4

        let howText = """
        How it works:
        • Two friends share one phone and add Spotify playlists
        • Tap “Start Swiping” to enter names
        • Player 1 swipes Like/Pass
        • Then Player 2 swipes the same song
        • Only songs both like = a match
        • Create a shared Spotify playlist
        """

        howItWorksTextView.attributedText = NSAttributedString(
            string: howText,
            attributes: [
                .font: UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor.secondaryLabel,
                .paragraphStyle: para
            ]
        )

    }
    
//    @IBAction func startTapped(_ sender: Any) {
//        performSegue(withIdentifier: "ShowPlayerSetup", sender: self)
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
