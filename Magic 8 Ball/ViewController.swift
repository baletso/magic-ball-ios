//
//  ViewController.swift
//  Magic 8 Ball
//
//  Created by Angela Yu on 14/06/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var magicTitle: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var centralBall: UIImageView!
    
    let ballArray = [
        UIImage(named: "ball1"),
        UIImage(named: "ball2"),
        UIImage(named: "ball3"),
        UIImage(named: "ball4"),
        UIImage(named: "ball5")
    ]
    
    @IBOutlet weak var magicButton: UIButton!
    
    override func viewDidLoad() {
        
        let baseText = "Piensa una pregunta y toca el botón para conocer la respuesta mágica ✨"
        
        let attributedText = NSMutableAttributedString(string: baseText)
        
        if let boldRange = baseText.range(of: "respuesta mágica ✨") {
                let nsRange = NSRange(boldRange, in: baseText)
                attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 18), range: nsRange)
            }
        
        subtitleLabel.attributedText = attributedText
        subtitleLabel.numberOfLines = 0
        
        super.viewDidLoad()
            centralBall.image = UIImage(named: "ball1")
        }
    
    @IBAction func magicButtonPressed(_ sender: UIButton) {
            let randomIndex = Int.random(in: 0...4)
            centralBall.image = ballArray[randomIndex]
        }
    
}

