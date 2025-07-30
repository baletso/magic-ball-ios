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
    @IBOutlet weak var magicButton: UIButton!
    

    private var messageLabel: UILabel?
    
    let chileanAnswers: [String] = [
        "¡Sí po'!",
        "No cacho",
        "De más po'",
        "No, nica",
        "Ni fu ni fa",
        "Nada es imposible...",
        "Na', olvídalo",
        "Prueba de nuevo",
        "Has la hueá que querai"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Gradient Background and stars
        addMagicStars(amount: 25)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(hex: "#1A237E").cgColor,
            UIColor(hex: "#6A1B9A").cgColor,
            UIColor(hex: "#0B6E75").cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // Subtitle with bold highlighted phrase
        let baseText = "Piensa una pregunta y toca el botón para conocer la respuesta mágica ✨"
        let attributedText = NSMutableAttributedString(string: baseText)
        if let boldRange = baseText.range(of: "respuesta mágica ✨") {
            let nsRange = NSRange(boldRange, in: baseText)
            attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 18), range: nsRange)
        }
        subtitleLabel.attributedText = attributedText
        subtitleLabel.numberOfLines = 0
        
        // Button
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
        
        // --- Magic Ball in code ---
        let ballSize: CGFloat = 300
        
        // Sombra suave, elíptica y con blur bajo la bola mágica
        let shadowWidth: CGFloat = ballSize * 0.64
        let shadowHeight: CGFloat = ballSize * 0.12
        let shadowY: CGFloat = view.bounds.height / 2 + 20 + ballSize / 2 - shadowHeight / 2 // Centrado justo bajo la bola

        let shadowView = UIView(frame: CGRect(
            x: (view.bounds.width - shadowWidth) / 2,
            y: shadowY,
            width: shadowWidth,
            height: shadowHeight
        ))
        shadowView.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        shadowView.layer.cornerRadius = shadowHeight / 1.5
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowView.layer.shadowOpacity = 0.1
        shadowView.layer.shadowRadius = 80

        view.addSubview(shadowView)
        
        let ballView = UIView()
        ballView.backgroundColor = .clear
        ballView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ballView)
        NSLayoutConstraint.activate([
            ballView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ballView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            ballView.widthAnchor.constraint(equalToConstant: ballSize),
            ballView.heightAnchor.constraint(equalToConstant: ballSize)
        ])
        
        //1. Black outside ball
        let outerBall = UIView(frame: CGRect(x: 0, y: 0, width: ballSize, height: ballSize))
        outerBall.backgroundColor = UIColor(hex: "#323232")
        outerBall.layer.cornerRadius = ballSize / 2
        outerBall.layer.masksToBounds = true
        ballView.addSubview(outerBall)

        // 2. Magic Ring - Degradado mágico
        // 2. Magic Ring - Violeta Glow
        let ringLayer = CAShapeLayer()
        let ringWidth: CGFloat = 16
        let ringRadius = ballSize * 0.37
        let ringPath = UIBezierPath(
            arcCenter: CGPoint(x: ballSize / 2, y: ballSize / 2),
            radius: ringRadius,
            startAngle: 0,
            endAngle: CGFloat.pi * 2,
            clockwise: true
        )
        ringLayer.path = ringPath.cgPath
        ringLayer.strokeColor = UIColor(hex: "#8B57F7").cgColor // Violeta mágico
        ringLayer.fillColor = UIColor.clear.cgColor
        ringLayer.lineWidth = ringWidth
        // Agrega efecto glow al anillo:
        ringLayer.shadowColor = UIColor(hex: "#B388FF").cgColor // Violeta claro
        ringLayer.shadowRadius = 12
        ringLayer.shadowOpacity = 0.7
        ringLayer.shadowOffset = .zero
        ballView.layer.addSublayer(ringLayer)

        // 3. Inner circle
        let innerCircleSize = ringRadius * 2 - ringWidth
        let innerCircle = UIView(frame: CGRect(
            x: (ballSize - innerCircleSize) / 2,
            y: (ballSize - innerCircleSize) / 2,
            width: innerCircleSize,
            height: innerCircleSize
        ))
        innerCircle.backgroundColor = UIColor(hex: "#1a1a1a")
        innerCircle.layer.cornerRadius = innerCircleSize / 2
        innerCircle.layer.masksToBounds = true
        ballView.addSubview(innerCircle)
        
        // 4. Centered triangle
        let triangleLayer = CAShapeLayer()
        let centerX = innerCircleSize / 2
        let centerY = innerCircleSize / 2
        let triangleSide: CGFloat = innerCircleSize * 0.8
        let triangleHeight: CGFloat = triangleSide * sqrt(3) / 2
        let centroidToBase = triangleHeight / 3
        let centroidToTop = triangleHeight * 2 / 3

        let p1 = CGPoint(x: centerX, y: centerY - centroidToTop)
        let p2 = CGPoint(x: centerX - triangleSide / 2, y: centerY + centroidToBase)
        let p3 = CGPoint(x: centerX + triangleSide / 2, y: centerY + centroidToBase)

        let trianglePath = UIBezierPath()
        trianglePath.move(to: p1)
        trianglePath.addLine(to: p2)
        trianglePath.addLine(to: p3)
        trianglePath.close()

        triangleLayer.path = trianglePath.cgPath

        // Gradiente para el triángulo
        let triangleGradientLayer = CAGradientLayer()
        triangleGradientLayer.frame = CGRect(x: 0, y: 0, width: innerCircleSize, height: innerCircleSize)
        triangleGradientLayer.colors = [
            UIColor(hex: "#7C3AED").cgColor,
            UIColor(hex: "#38BDF8").cgColor
        ]
        triangleGradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        triangleGradientLayer.endPoint = CGPoint(x: 0.5, y: 1)

        // Aplica el gradiente sólo al triángulo
        triangleGradientLayer.mask = triangleLayer
        innerCircle.layer.addSublayer(triangleGradientLayer)
        
        // 5. Message triangle
        let message = "¡Sí, po!"
        let label = UILabel()
        label.text = message
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 3
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        innerCircle.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: innerCircle.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: innerCircle.centerYAnchor, constant: 20),
            label.widthAnchor
                .constraint(equalToConstant: triangleSide - 38),
            label.heightAnchor.constraint(lessThanOrEqualToConstant: triangleHeight - 18)
        ])
        self.messageLabel = label
        
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
        let randomMessage = chileanAnswers.randomElement() ?? "¡Sí, po!"
        self.messageLabel?.text = randomMessage
    }
}
