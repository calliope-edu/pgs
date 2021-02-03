import UIKit

class Dashboard_DisplayAnimation: UIView_DashboardItemAnimation, CAAnimationDelegate {
	
    var matrix = [
            [ false, false, false, false, false ],
            [ false, false, false, false, false ],
            [ false, false, false, false, false ],
            [ false, false, false, false, false ],
            [ false, false, false, false, false ],
        ]
    let len = 4
    
    var draw = true
    
    //MARK: - animator
    
    override func run(_ completionBlock: @escaping ((Bool) -> Void)) {
        addMatrixAnimation(totalDuration: 2.0, completionBlock: completionBlock)
    }
    
	//MARK: - Life Cycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		super.init(coder: aDecoder)
	}
	
    // MARK: -
  
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let inner = bounds.insetBy(percentage: 0.5)
        let insetPerc:CGFloat = 0.8
        let max_size = max(inner.size.width, inner.size.height)
        let size = max_size*insetPerc
        let offset = (bounds.size.width - size) * 0.5
        
        let bw = (size / 13.0)
        let bh = (size / 7.0)
        let bwo = bw * 2.0
        let bho = bh / 2.0
        
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.saveGState()
        ctx?.translateBy(x: offset, y: offset)
        
        for x in 0...len {
            for y in 0...len {
                let box = UIBezierPath(roundedRect: CGRect(
                    x: CGFloat(x) * (bw + bwo),
                    y: CGFloat(y) * (bh + bho),
                    width: bw,
                    height: bh
                ), cornerRadius: 2.0)
                if matrix[x][y] {
                    UIColor.red.setFill()
                } else {
                    UIColor.white.setFill()
                }
                box.fill()
            }
        }
        
        ctx?.restoreGState()
    }
	
	//MARK: - Animation Setup
	
	func addMatrixAnimation(totalDuration: CFTimeInterval, resetTime:CFTimeInterval = 0.3, completionBlock: @escaping ((Bool) -> Void)) {
        let delayTime:Double = totalDuration / 30
        for x in 0...len {
            let xdelay = delayTime * Double(x)
            for y in 0...len {
                let ydelay = xdelay + (delayTime * Double(y))
                delay(time: ydelay) { [weak self] in
                    self?.matrix[x][y] = true
                    self?.setNeedsDisplay()
                    // reset
                    delay(time: resetTime) { [weak self] in
                        self?.matrix[x][y] = false
                        self?.setNeedsDisplay()
                        if (x == 4 && y == 4) {
                            completionBlock(true)
                        }
                    }
                }
            }
        }
	}
	
	//MARK: - Animation Cleanup
	
	func animationDidStop(_ anim: CAAnimation, finished flag: Bool){
		
	}
	
}
