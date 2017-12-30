//
//  ActivityController.swift
//  Test
//
//  Created by Philip Fryklund on 3/Dec/16.
//  Copyright © 2016 Philip Fryklund. All rights reserved.
//

import Foundation





public class ActivityIndicator: UIView {
	private static let shared = ActivityIndicator()
	static var dismissDelay: Double = 0.25
	
	public static func show() {
//		if shared.showTimer == nil {
//			shared.showTimer = Timer.scheduledTimer(timeInterval: 0.25, target: shared, selector: #selector(shared.show), userInfo: nil, repeats: false)
//		}
		
		if !shared.isShowing {
			shared.show()
		}
	}
	
	public static func dismiss(animated: Bool) {
		shared.removeTimer?.invalidate()
		shared.removeTimer = Timer.scheduledTimer(timeInterval: 0.25, target: shared, selector: #selector(shared.remove(timer:)), userInfo: animated, repeats: false)
	}
	
	
	
	private let contentView = UIView(backgroundColor: UIColor.black.alpha(0.2))
	private let contentStack = StackView(axis: .vertical)
	private let spinner = Spinner(numberOfLines: 1, minSpeed: CGFloat(0.75).rad, maxSpeed: CGFloat(4.25).rad)
//	private let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
	
//	private var showTimer: Timer?
	private var removeTimer: Timer?
	private var isShowing = false
	
	
	
	private func show() {
		isShowing = true
		
		UIWindow.current?.addSubview(self)
		
		self.alpha = 0
		contentView.transform(scale: 1.2)
		self.layoutIfNeeded()
		
		UIView.animate(withDuration: 0.4) {
			self.alpha = 1
			self.contentView.transform(scale: 1.0)
		}
	}
	
	@objc private func remove(timer: Timer) {
		let animated = timer.userInfo as! Bool
		timer.invalidate()
		removeTimer = nil
		
		if animated {
			UIView.animate(withDuration: 0.2,
				animations: {
					self.alpha = 0
				},
				completion: { _ in
					self.isShowing = false
					self.removeFromSuperview()
				})
		}
		else {
			self.isShowing = false
			self.removeFromSuperview()
		}
	}
	
	public override func willMove(toSuperview newSuperview: UIView?) {
		if newSuperview != nil {
			spinner.startAnimating()
		}
	}
	
	public override func didMoveToSuperview() {
		if self.superview == nil {
			spinner.stopAnimating()
		}
	}
	
	
	init() {
		super.init(frame: UIScreen.main.bounds)
		
		self.backgroundColor = UIColor.black.alpha(0.2)
		
		
		contentView.cornerRadius = 30
		self.addSubview(contentView)
		contentView.lac.make {
			$0.centerX.equalToSuperview()
			$0.centerY.equalToSuperview()
			$0.width.equalTo(200)
			$0.height.greaterThan(contentView.lac.width)
		}
		
		contentStack.spacing = 20
		contentStack.isLayoutMarginsRelativeArrangement = true
		contentStack.layoutMargins = UIEdgeInsets(inset: 40)
		contentView.addSubview(contentStack)
		contentStack.lac.make {
			$0.top.equalToSuperview()
			$0.left.equalToSuperview()
			$0.right.equalToSuperview()
			$0.bottom.equalToSuperview()
		}
		
//		spinner.backgroundColor = .red
		spinner.lac.make {
			$0.height.equalTo($0.width)
		}
		contentStack.addArrangedSubview(spinner)
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}







private class Spinner: UIView {
	let numberOfLines: Int
	let spacing: CGFloat = 0
	let innerRadius: CGFloat = 45
	private let paths: [Path]
	
	var timer: Timer!
	var isAnimating = false
	
	
	
	@objc func update() {
		self.setNeedsDisplay()
	}
	
	func startAnimating() {
		print("Spinner.startAnimating")
		
		timer = Timer.scheduledTimer(timeInterval: 1.0/60.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
		isAnimating = true
		
		for (i, path) in paths.enumerated() {
			path.angle = -CGFloat.pi / 2 + CGFloat(i) * CGFloat(45).rad
			path.length = CGFloat.pi / 2
		}
	}
	
	func stopAnimating() {
		print("Spinner.stopAnimating")
		
		timer?.invalidate()
		timer = nil
		
		isAnimating = false
	}
	
	
	
	
	
	
	
	init(numberOfLines lines: Int, minSpeed: CGFloat, maxSpeed: CGFloat) {
		self.numberOfLines = lines
		
		let speedRange = maxSpeed - minSpeed
		
		paths = (0..<lines).map { i in
			let percent = CGFloat(i + 1) / CGFloat(lines)
			
			let path = Path()
//			path.angle = -CGFloat.pi / 2
			path.speed = minSpeed + speedRange * percent
//			path.length = CGFloat.pi / 2
			path.color = UIColor(hex: 0x2DBDB6).lightened(by: percent * 0.25 + 0.065)
			
			return path
		}
		
		super.init(frame: CGRect.zero)
		
		self.isOpaque = false
		
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	
	
	fileprivate override func draw(_ rect: CGRect) {
		UIColor.white.alpha(0.2).setFill()
		UIBezierPath(ovalIn: rect).fill()
		
		let totalRadius = rect.width/2
		let availableRadius = totalRadius - innerRadius - CGFloat(numberOfLines-1) * spacing
		
		let center = rect.center
		let lineWidth = availableRadius / CGFloat(numberOfLines)
		
		let x = paths.first!.angle
//		let curve = cos(x * 0.3) * 0.4 + 0.6
		let curve = (1 - abs(cos(x * 0.5))) * 0.95 + 0.05
		let length = CGFloat.pi * 2 * curve
//		print(curve)
		
		for (i, path) in paths.enumerated() {
			let percent = CGFloat(i + 1) / CGFloat(numberOfLines)
			
			let radius = availableRadius * percent - lineWidth / 2 + spacing * CGFloat(i) + innerRadius
			path.length = length
			let sa = path.angle - path.length / 2
			let ea = path.angle + path.length / 2
			path.angle += path.speed
			
			path.lineWidth = lineWidth
			
			path.removeAllPoints()
			path.addArc(withCenter: center, radius: radius, startAngle: sa, endAngle: ea, clockwise: true)
			
			path.color.setStroke()
			path.stroke()
		}
	}
	
	
	
	private class Path: UIBezierPath {
		var angle: CGFloat = 0
		var speed: CGFloat = 0
		var length: CGFloat = 0
		var color: UIColor = .black
	}
}

























