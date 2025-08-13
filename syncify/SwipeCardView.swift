//
//  SwipeCardView.swift
//  syncify
//
//  Created by Salma M. on 8/12/25.
//
// Reusable view from XIB. Handles pan gesture & thresholds.

import UIKit

protocol SwipeCardDelegate: AnyObject {
    func cardDidSwipeRight(_ song: Song) // Like
    func cardDidSwipeLeft(_ song: Song)  // Pass
}

final class SwipeCardView: UIView {

    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    
    weak var delegate: SwipeCardDelegate?
    private var startCenter: CGPoint = .zero
    private var song: Song?

    override func awakeFromNib() {
        super.awakeFromNib()

        // basic styling
        layer.cornerRadius = 16
        layer.masksToBounds = true
        backgroundColor = .secondarySystemBackground
        albumImageView.contentMode = .scaleAspectFill
        albumImageView.clipsToBounds = true

        // add the pan gesture
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(pan)
    }

    func configure(with song: Song) {
        // card gets its content here
        self.song = song
        songTitleLabel.text = song.name
        artistLabel.text = "\(song.artist) • \(song.albumName)"

        albumImageView.image = UIImage(systemName: "music.note") // placeholder
        if let urlString = song.albumImageURL, let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                if let d = data, let img = UIImage(data: d) {
                    DispatchQueue.main.async { self?.albumImageView.image = img }
                }
            }.resume()
        }
    }

    @objc private func handlePan(_ g: UIPanGestureRecognizer) {
        // track translation;apply thresholds
        let t = g.translation(in: superview)

        switch g.state {
        case .began:
            startCenter = center

        case .changed:
            // follow the finger + tiny tilt
            center = CGPoint(x: startCenter.x + t.x, y: startCenter.y + t.y * 0.2)
            let angle = (t.x / 300) * 0.35
            transform = CGAffineTransform(rotationAngle: angle)

        case .ended, .cancelled:
            // simple threshold (right = like, left = pass)
            if t.x > 120 {
                fling(toRight: true) { [weak self] in
                    guard let self, let s = self.song else { return }
                    self.delegate?.cardDidSwipeRight(s)
                }
            } else if t.x < -120 {
                fling(toRight: false) { [weak self] in
                    guard let self, let s = self.song else { return }
                    self.delegate?.cardDidSwipeLeft(s)
                }
            } else {
                // snap back to start
                UIView.animate(withDuration: 0.35,
                               delay: 0,
                               usingSpringWithDamping: 0.7,
                               initialSpringVelocity: 0.7,
                               options: []) {
                    self.center = self.startCenter
                    self.transform = .identity
                }
            }

        default: break
        }
    }

    private func fling(toRight: Bool, completion: @escaping () -> Void) {
        // fling off-screen then notify 
        UIView.animate(withDuration: 0.25, animations: {
            self.center.x += toRight ? 600 : -600
            self.alpha = 0.2
        }) { _ in
            completion()
            self.removeFromSuperview()
        }
    }
}
