//
//  ViewController.swift
//  Magic 8 Ball
//
//  Created by Angela Yu on 14/06/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}

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
       
        super.viewDidLoad()
        
        addMagicStars(amount: 25)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(hex: "#1A237E").cgColor, // Azul profundo
            UIColor(hex: "#6A1B9A").cgColor, // Violeta
            UIColor(hex: "#0B6E75").cgColor  // Turquesa
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)
        
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
        
        let magicPurple = UIColor(hex: "#6A1B9A")

        magicButton.setTitle("¡Muéstrame la magia!", for: .normal)
        magicButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        magicButton.backgroundColor = .white
        magicButton.setTitleColor(magicPurple, for: .normal)
        magicButton.layer.cornerRadius = 28
        magicButton.layer.masksToBounds = true
        magicButton.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        magicButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        magicButton.layer.shadowRadius = 8
        magicButton.layer.shadowOpacity = 0.4
        
        }
    
    private func addMagicStars(amount: Int) {
            for _ in 1...amount {
                let size = CGFloat.random(in: 3...7)
                let star = UIView(frame: CGRect(
                    x: CGFloat.random(in: 0...view.bounds.width),
                    y: CGFloat.random(in: 0...view.bounds.height),
                    width: size,
                    height: size
                ))
                star.backgroundColor = UIColor.white.withAlphaComponent(CGFloat.random(in: 0.2...0.6))
                star.layer.cornerRadius = size / 2
                star.layer.shadowColor = UIColor.white.cgColor
                star.layer.shadowRadius = size
                star.layer.shadowOpacity = 0.7
                star.layer.shadowOffset = CGSize(width: 0, height: 0)
                view.addSubview(star)
                view.sendSubviewToBack(star)
            }
        }
    
    @IBAction func magicButtonPressed(_ sender: UIButton) {
            let randomIndex = Int.random(in: 0...4)
            centralBall.image = ballArray[randomIndex]
        }
    
}

