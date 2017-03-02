//
//  LinearGradientView.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import UIKit





public class LinearGradientView: UIView {
	public override class var layerClass: AnyClass { return CAGradientLayer.self }
	private var gradientLayer: CAGradientLayer {
		return self.layer as! CAGradientLayer
	}
	
	
	public var colorComponents: [(color: UIColor, location: NSNumber)]? {
		get { return zip(gradientLayer.colors ?? [], gradientLayer.locations ?? []).map { (UIColor(cgColor: $0.0 as! CGColor), $0.1) } }
		set {
			gradientLayer.colors = newValue?.map { $0.color.cgColor }
			gradientLayer.locations = newValue?.map { $0.location }
		}
	}
	
	var startPoint: CGPoint {
		get { return gradientLayer.startPoint }
		set { gradientLayer.startPoint = newValue }
	}
	
	var endPoint: CGPoint {
		get { return gradientLayer.endPoint }
		set { gradientLayer.endPoint = newValue }
	}
}
