//
//  Cluster.swift
//  Dengue Fever
//
//  Created by Jimmy on 2018/4/17.
//  Copyright © 2018年 Jimmy. All rights reserved.
//

import Foundation
import MapKit

class DengueCaseView: MKMarkerAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            if let data = newValue as? DengueCase {
                clusteringIdentifier = "dengueCase"
                switch data.sex {
                case .女:
                    markerTintColor = UIColor.female
                    glyphImage = #imageLiteral(resourceName: "girl")
                    displayPriority = .defaultHigh
                case .男:
                    markerTintColor = UIColor.male
                    glyphImage = #imageLiteral(resourceName: "boy")
                    displayPriority = .defaultLow
                default:
                    break
                }
            }
        }
    }
}

class DengueCaseClusterView: MKAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            newValue.flatMap(configure(with:))
        }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        displayPriority = .defaultHigh
        collisionMode = .circle
        centerOffset = CGPoint(x: 0.0, y: -10.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension DengueCaseClusterView {
    func configure(with annotation: MKAnnotation) {
        
        if let cluster = annotation as? MKClusterAnnotation {
            let render = UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40))
            let counter = cluster.memberAnnotations.count
            let male = cluster.memberAnnotations.filter({ member -> Bool in
                return (member as! DengueCase).sex == .男
            }).count
            
            image = render.image(actions: { _ in
                // Fill full circle with female color
                UIColor.female.setFill()
                UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 40, height: 40)).fill()
                // Fill pie with male color
                UIColor.male.setFill()
                let piePath = UIBezierPath()
                piePath.addArc(withCenter: CGPoint(x:20, y:20), radius: 20, startAngle: 0, endAngle: (CGFloat.pi * 2.0 * CGFloat(male)/CGFloat(counter)), clockwise: true)
                piePath.addLine(to: CGPoint(x: 20, y: 20))
                piePath.close()
                piePath.fill()
                
                // Fill inner circle with white color
                UIColor.white.setFill()
                UIBezierPath(ovalIn: CGRect(x: 4, y: 4, width: 32, height: 32)).fill()
                
                // Finally draw count text vertically and horizontally centered
                let attributes = [ NSAttributedStringKey.foregroundColor: UIColor.black,
                                   NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20)]
                let text = "\(counter)"
                let size = text.size(withAttributes: attributes)
                let rect = CGRect(x: 20 - size.width / 2, y: 20 - size.height / 2, width: size.width, height: size.height)
                text.draw(in: rect, withAttributes: attributes)
                
            })
        }
        
        
        
    }
    
    
}
