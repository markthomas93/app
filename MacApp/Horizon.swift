import AppKit

final class Horizon: NSView {
    var altitude = Double()
    var azimuth = Double()
    private(set) weak var moon: Moon!
    private let period = CGFloat(360)
    private weak var path: CAShapeLayer!
    private weak var border: CAShapeLayer!
    private weak var dash: CAShapeLayer!
    
    override var frame: NSRect {
        didSet {
            resize()
        }
    }
    
    private var radius: CGFloat {
        min(bounds.width, bounds.height) * 0.4
    }
    
    private var diameter: CGFloat {
        radius * 2
    }
    
    private var amplitude: CGFloat {
        radius / 2
    }
    
    private var center: CGPoint {
        .init(x: bounds.width / 2, y: bounds.height / 2)
    }
    
    private var location: CGPoint {
        let y: CGFloat
        if abs(altitude) <= .pi * 0.5 {
            y = center.y + (CGFloat(altitude) / (.pi / 2) * amplitude)
        } else if altitude > 0 {
            y = center.y - (CGFloat(altitude) - .pi) / (.pi / 2) * amplitude
        } else {
            y = center.y - (CGFloat(altitude) + .pi) / (.pi / 2) * amplitude
        }
        return .init(x: center.x + (.init(altitude) / .pi * (radius * 2 / 3)) - (radius / 3), y: y)
    }
    
    override var mouseDownCanMoveWindow: Bool { false }
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let path = CAShapeLayer()
        path.fillColor = .clear
        path.lineWidth = 2
        path.strokeColor = .shade()
        path.lineCap = .round
        layer = path
        wantsLayer = true
        self.path = path
        
        let border = CAShapeLayer()
        border.fillColor = .clear
        border.lineWidth = 2
        border.strokeColor = .shade()
        path.addSublayer(border)
        self.border = border
        
        let dash = CAShapeLayer()
        dash.fillColor = .clear
        dash.lineWidth = 1
        dash.strokeColor = .shade()
        dash.lineDashPattern = [NSNumber(value: 1), NSNumber(value: 2)]
        path.addSublayer(dash)
        self.dash = dash
        
        let moon = Moon()
        path.addSublayer(moon)
        self.moon = moon
    }
    
    func update() {
        moon.center = location
        moon.update()
    }
    
    private func resize() {
        border.path = {
            $0.addArc(center: center, radius: radius + 1, startAngle: 0, endAngle: .pi * 2, clockwise: false)
            return $0
        } (CGMutablePath())
        
        dash.path = {
            $0.move(to: .init(x: center.x + radius, y: center.y))
            $0.addLine(to: .init(x: center.x - radius, y: center.y))
            return $0
        } (CGMutablePath())
        
        path.path = { p in
            p.move(to: .init(x: center.x - radius, y: center.y))
            stride(from: 2, through: period, by: 2).forEach {
                p.addLine(to: CGPoint(x: center.x - radius + ($0 / period * diameter),
                                      y: center.y - (cos($0 / 180 * .pi) * amplitude)))
            }
            return p
        } (CGMutablePath())
        
        moon.radius = radius / 6
        moon.center = location
        moon.resize()
    }
}
