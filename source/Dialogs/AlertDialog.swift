//
//  AlertDialog.swift
//  Pods
//
//  Created by Philip Fryklund on 21/Apr/17.
//
//

import UIKit





public final class AlertDialog: Dialog {
	public var customView: UIView?
	public var customViewAddedToSuperview: ((AlertDialog) -> ())?
	
	
	
	override public func generateTitleLabel() -> UILabel	{
		return UILabel(font: UIFont.boldSystemFont(ofSize: 17), alignment: .center, lines: 0)
	}
	
	override public func generateSubtitleLabel() -> UILabel	{
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
		button.setTitle(action.title, for: .normal)
		
		button.titleLabel!.font = font
		button.titleLabel!.textAlignment = .center
		
		button.lac.height.equal(to: 44)
		
		return button
	}
	
	private func generateBorder() -> UIView {
		return UIView(backgroundColor: UIColor.lightGray.alpha(0.4))
	}
	
	
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		
		self.modalPresentationStyle = .custom
		self.transitioningDelegate = self
		
		contentView.cornerRadius = 13.5
		contentView.lac.make {
			$0.top.greaterThanSuperview(20)
			$0.bottom.lessThanSuperview(-20)
			$0.centerX.equalToSuperview()
			$0.centerY.equalToSuperview()
			$0.width.equal(to: 270)
		}
		
		promptContentView?.layoutMargins = UIEdgeInsets(vertical: 20, horizontal: 16)
		promptContentView?.spacing = 3
		
		if let view = customView {
			mainContentStack.add(arrangedView: view)
		}
		
		if !actions.isEmpty {
			let buttonContentView = UIStackView(axis: (actions.count == 2) ? .horizontal : .vertical)
			buttonContentView.setContentCompressionResistancePriority(1000, for: .vertical)
			
			if let _ = promptContentView {
				mainContentStack.add(arrangedView: generateBorder()) {
					$0.height.equal(to: points(pixels: 1.0))
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
							case .horizontal: $0.width.equal(to: points(pixels: 1.0))
							case .vertical	: $0.height.equal(to: points(pixels: 1.0))
						}
					}
				}
				
				buttonContentView.add(arrangedView: button)
				
				if buttonContentView.axis == .horizontal, let last = lastButton {
					button.lac.width.equal(to: last.lac.width)
				}
				
				lastButton = button
			}
		}
	}
	
	public override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		customViewAddedToSuperview?(self)
	}
}

extension AlertDialog: DialogBuilder {
	public func addAction(_ action: DialogAction) -> AlertDialog {
		actions ++= action
		return self
	}
}

extension AlertDialog: UIViewControllerTransitioningDelegate {
	public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return AlertAnimator(dismissing: false, duration: 0.3, controlPoints: (CGPoint(0.1, 1), CGPoint(1, 1)))
	}
	
	public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return AlertAnimator(dismissing: true, duration: 0.3, controlPoints: (CGPoint(0.1, 1), CGPoint(1, 1)))
	}
}







fileprivate class AlertAnimator: DialogAnimator<AlertDialog> {
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


















