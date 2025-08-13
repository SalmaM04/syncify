//
//  PlayerSetupViewController.swift
//  syncify
//
//  Created by Salma M. on 8/11/25.
//

// Work flow:
// - User types in either text field
// - textFieldsDidChange fires
// - validateInputs() runs
// - Button enabled/disabled updates instantly
// - User taps Start -> create a game + navigate next

import UIKit

class PlayerSetupViewController: UIViewController{
    
    
    @IBOutlet weak var player1TextField: UITextField!
    @IBOutlet weak var player2TextField: UITextField!
    
    @IBOutlet weak var player1LinkTextField: UITextField!
    
    
    @IBOutlet weak var player2LinkTextField: UITextField!
    
    
    
    @IBOutlet weak var startGameButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Who's Playing?"
        player1TextField.borderStyle = .roundedRect
        player2TextField.borderStyle = .roundedRect
        startGameButton.layer.cornerRadius = 12
        
        // make all fields trigger validation
           [player1TextField, player2TextField, player1LinkTextField, player2LinkTextField].forEach {
               $0?.addTarget(self, action: #selector(validateInputs), for: .editingChanged)
           }

           //  for link fields
           player1LinkTextField.keyboardType = .URL
           player1LinkTextField.clearButtonMode = .whileEditing
           player2LinkTextField.keyboardType = .URL
           player2LinkTextField.clearButtonMode = .whileEditing

           validateInputs()
    }
    
    
    @objc private func validateInputs() {
        let p1 = !(player1TextField.text ?? "").trimmingCharacters(in: .whitespaces).isEmpty
        let p2 = !(player2TextField.text ?? "").trimmingCharacters(in: .whitespaces).isEmpty
        startGameButton.isEnabled = p1 && p2   // links remain optional
        startGameButton.backgroundColor = startGameButton.isEnabled ? .systemGreen : .systemGray4
    }
    
    
    @IBAction func startGameButtonTapped(_ sender: Any) {
        let name1 = (player1TextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            let name2 = (player2TextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

            func parseURL(_ s: String?) -> URL? {
                guard let s = s?.trimmingCharacters(in: .whitespacesAndNewlines), !s.isEmpty else { return nil }
                return URL(string: s)
            }

            let url1 = parseURL(player1LinkTextField?.text)
            let url2 = parseURL(player2LinkTextField?.text)
        
        GameManager.shared.startNewGame(
            player1Name: name1, player1URL: url1,
            player2Name: name2, player2URL: url2
        )
        
        //  navigate to the Game Screen
        // instantiate the GameViewController from storyboard
        // push it onto the navigation stack so it transitions to the game UI
        if let vc = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController {
            navigationController?.pushViewController(vc, animated: true)
        }

    }
    
}
