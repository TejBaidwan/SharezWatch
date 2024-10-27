//
//  CustomAnimation.swift
//  SharezWatch
//
//  Created by Tejvir Baidwan on 2024-10-26.
//

import UIKit

/**
 This class represents the CustomAnimation which is shown when watchlisting a stock
 */

class CustomAnimation: UIView {
    
    //MARK: - Properties
    
    var dialogTitle: NSString = ""
    var dialogFillColour = UIColor(red: 1/255, green: 110/255, blue: 28/255, alpha: 0.95)
    var imageType: String?
    
    //MARK: - Attributes of the dialogue
    
    //Method which draws the dialogue
    override func draw(_ rect: CGRect) {
        
        //Dimensions
        let width: CGFloat = bounds.size.width - 20
        let height: CGFloat = 100
        
        //Dialogue rectangle dimensions
        let viewRect = CGRect(x: round(bounds.size.width - width) / 2, y: round(bounds.size.height - height) / 7, width: width, height: height)
        let insideRect = UIBezierPath(roundedRect: viewRect, cornerRadius: 25)
        dialogFillColour.setFill()
        insideRect.fill()
        
        //Image dimensions and positioning
        guard let image = UIImage(systemName: imageType ?? "chart.line.uptrend.xyaxis")?.withTintColor(.white) else { return }
        image.draw(in: CGRect(x: viewRect.midX - (viewRect.midX - 25), y: viewRect.midY - 20, width: 50, height: 50))
        
        //Font attributes
        let attributes = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 30),
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        
        //Text styles and positioning
        dialogTitle.size(withAttributes: attributes)
        let textPoint = CGPoint(x: viewRect.midX - (viewRect.midX - 100), y: viewRect.midY - 10)
        
        dialogTitle.draw(at: textPoint, withAttributes: attributes)
        
    }
    
    //Animations and transitions when showing the CustomAnimation
    func showDialog(){
        alpha = 0
        
        UIView.animate(withDuration: 1.0, delay: 0,options: .curveEaseInOut, animations: {
            self.alpha = 1
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
}
