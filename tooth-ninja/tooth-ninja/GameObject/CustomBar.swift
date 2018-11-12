//
//  Created by David Lopez and Kushagra Vashisht on 8/10/18.
//  Copyright © 2018 David Lopez and Kushagra Vashisht. All rights reserved.
//

import Foundation
import SpriteKit

class CustomBar : SKSpriteNode {
    
    init(color: UIColor, size: CGSize) {
        super.init(texture: nil, color: color, size: size)
        self.anchorPoint = CGPoint(x: 0.0, y: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setProgress(x: CGFloat) {
        if (x > 0) {
            self.xScale = CGFloat(x)
        }
    }
}

