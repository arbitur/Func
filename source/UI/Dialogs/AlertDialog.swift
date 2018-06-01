//
//  AlertDialog.swift
//  Pods
//
//  Created by Philip Fryklund on 21/Apr/17.
//
//

import UIKit





open class AlertDialog: Dialog, DialogBuilder {
	
	open var customViews = [UIView]()
	public var didAddCustomViewToSuperview: ((AlertDialog, UIView)->())?
	
	
	
	override open func generateTitleLabel() -> UILabel	{
		return UILabel(font: UIFont.boldSystemFont(ofSize: 17), alignment: .center, lines: 0)
	}
	
	override open func generateSubtitleLabel() -> UILabel	{
		return UILabel(font: UIFont.systemFont(ofSize: 13), alignment: .center, lines: 0)
	}
	
	private func generateActionButton(_ action: DialogAction) -> UIButton {
		let color: UIColor
		switch action.type {
			case .normal: color = UIColor(red: 0.0, green: 0.48, blue: 1.00, alpha: 1.0)
			case .delete: color = UIColor(red: 1.0, green: 0.23, blue: 0.19, alpha: 1.0)
			case .cancel: color = UIColor(red: 0.0, green: 0.48, blue: 1.00, alpha: 1.0)
		}
		
		let font: UIFont
		switch action.type {
			case .normal: font = UIFont.systemFont(ofSize: 17)
			case .delete: font = UIFont.systemFont(ofSize: 17)
			case .cancel: font = UIFont.boldSystemFont(ofSize: 17)
		}
		
		let button = UIButton(type: .system, target: self, action: #selector(actionPressed))
		button.setTitleColor(color, for: .normal)
		button.setTitleColor(color.alpha(0.4), for: .disabled)
		button.setTitle(action.title, for: .normal)
		
		button.titleLabel!.font = font
		button.titleLabel!.textAlignment = .center
		
		button.lac.height.equalTo(44)
		
		return button
	}
	
	private func generateBorder() -> UIView {
		return UIView(backgroundColor: UIColor.lightGray.alpha(0.4))
	}
	
	
	
	open override func viewDidLoad() {
		super.viewDidLoad()
		
		self.modalPresentationStyle = .custom
		self.transitioningDelegate = self
		
		contentView.cornerRadius = 13.5
		contentView.lac.make {
			$0.width.equalTo(270)
			$0.centerX.equalToSuperview()
			$0.centerY.equalToSuperview()
			$0.top.greaterThan(self.topLayoutGuide.lac.bottom, constant: 10)
			$0.bottom.lessThan(self.bottomLayoutGuide.lac.top, constant: -10) //TODO: Check still works
		}
		
		promptContentView?.layoutMargins = UIEdgeInsets(horizontal: 16, vertical: 20)
		promptContentView?.spacing = 3
		
		for view in customViews {
			mainContentStack.add(arrangedView: view)
			didAddCustomViewToSuperview?(self, view)
		}
		
		if actions.isNotEmpty {
			let buttonContentView = UIStackView(axis: (actions.count == 2) ? .horizontal : .vertical)
			buttonContentView.setContentCompressionResistancePriority(.required, for: .vertical)
			
			if let _ = promptContentView {
				mainContentStack.add(arrangedView: generateBorder()) {
					$0.height.equalTo(points(pixels: 1))
				}
			}
			
			mainContentStack.add(arrangedView: buttonContentView)
			
			var lastButton: UIButton?
			for (i, action) in actions.enumerated() {
				let button = generateActionButton(action)
				button.tag = i
				
				if let _ = lastButton {
					buttonContentView.add(arrangedView: generateBorder()) {
						switch buttonContentView.axis {
							case .horizontal: $0.width.equalTo(points(pixels: 1))
							case .vertical	: $0.height.equalTo(points(pixels: 1))
						}
					}
				}
				
				buttonContentView.add(arrangedView: button)
				
				if buttonContentView.axis == .horizontal, let last = lastButton {
					button.lac.width.equalTo(last.lac.width)
				}
				
				lastButton = button
			}
		}
	}
}

extension AlertDialog: UIViewControllerTransitioningDelegate {
	
	public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return AlertAnimator(dismissing: false, duration: 0.3, controlPoints: (CGPoint(0.1, 1), CGPoint(0.85, 1)))
	}
	
	public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return AlertAnimator(dismissing: true, duration: 0.3, controlPoints: (CGPoint(0.1, 1), CGPoint(0.85, 1)))
	}
}





private class AlertAnimator: DialogAnimator<AlertDialog> {
	
	override func prepareAnimation(_ viewController: AlertDialog) {
		viewController.contentBlurView.backgroundColor = .white
		
		if !dismissing {
			viewController.contentView.transform(scale: 1.175)
			viewController.view.alpha = 0.0
		}
	}
	
	override func animation(_ viewController: AlertDialog) {
		if dismissing {
			viewController.view.alpha = 0.0
		}
		else {
			viewController.view.alpha = 1.0
			viewController.contentView.transform(scale: 1.0)
		}
	}
	
	override func completion(_ viewController: AlertDialog, finished: Bool) {
		if !dismissing {
			viewController.contentView.backgroundColor = nil
		}
	}
}


















