//
//  AlertDialog.swift
//  Pods
//
//  Created by Philip Fryklund on 21/Apr/17.
//
//

import UIKit

public typealias AlertDialog = AlertDialogController // For backwards compatibility

open class AlertDialogController: ActionDialogController {
	
	override open class func makeTitleLabel() -> UILabel {
		return UILabel(font: UIFont.boldSystemFont(ofSize: 17), alignment: .center, lines: 0)
	}
	
	override open class func makeSubtitleLabel() -> UILabel	{
		return UILabel(font: UIFont.systemFont(ofSize: 13), alignment: .center, lines: 0)
	}
	
	open override class func makeActionButton(for type: DialogActionType) -> UIButton {
		let color: UIColor
		let font: UIFont
		switch type {
		case .normal: color = UIColor(red: 0.0, green: 0.48, blue: 1.00, alpha: 1.0) ; font = UIFont.systemFont(ofSize: 17)
		case .delete: color = UIColor(red: 1.0, green: 0.23, blue: 0.19, alpha: 1.0) ; font = UIFont.systemFont(ofSize: 17)
		case .cancel: color = UIColor(red: 0.0, green: 0.48, blue: 1.00, alpha: 1.0) ; font = UIFont.boldSystemFont(ofSize: 17)
		}
		
		let button = UIButton(type: .system)
		button.contentEdgeInsets = UIEdgeInsets(horizontal: 8, vertical: 0)
		button.setTitleColor(color, for: .normal)
		button.setTitleColor(color.alpha(0.4), for: .disabled)
		
		button.titleLabel!.font = font
		button.titleLabel!.textAlignment = .center
		button.titleLabel!.adjustsFontSizeToFitWidth = true
		
		button.heightAnchor.constraint(equalToConstant: 44).isActive = true
		
		return button
	}
	
	private func makeBorder() -> UIView {
		UIView(backgroundColor: UIColor.lightGray.alpha(0.4))
	}
	
	
	open override func loadView() {
		super.loadView()
		
		contentView.cornerRadius = 13.5
		contentView.clipsToBounds = true
		contentView.lac.make {
			$0.width.equalTo(270)
			$0.centerX.equalToSuperview()
			$0.centerY.equalToSuperview()
			$0.top.greaterThan(self.topLayoutGuide.lac.bottom, constant: 10)
			$0.bottom.lessThan(self.bottomLayoutGuide.lac.top, constant: -10) //TODO: Check still works
		}
		
		promptContentView?.layoutMargins = UIEdgeInsets(horizontal: 16, vertical: 20)
		promptContentView?.spacing = 3
		
		if actionButtons.isNotEmpty {
			let buttonContentView = UIStackView(axis: (actionButtons.count == 2) ? .horizontal : .vertical)
			buttonContentView.setContentCompressionResistancePriority(.required, for: .vertical)
			
			if mainContentStack.arrangedSubviews.isNotEmpty {
				mainContentStack.add(arrangedView: makeBorder()) {
					$0.height.equalTo(points(pixels: 1))
				}
			}
			
			var previousButton: UIButton?
			for button in actionButtons {
				if previousButton != nil {
					buttonContentView.add(arrangedView: makeBorder()) {
						switch buttonContentView.axis {
							case .horizontal: $0.width.equalTo(points(pixels: 1))
							case .vertical	: $0.height.equalTo(points(pixels: 1))
							@unknown default: assertionFailure()
						}
					}
				}
				
				buttonContentView.add(arrangedView: button)
				
				if let previousButton = previousButton, buttonContentView.axis == .horizontal {
					button.lac.width.equalTo(previousButton.lac.width)
				}
				
				previousButton = button
			}
			
			mainContentStack.addArrangedSubview(buttonContentView)
		}
	}
	
	open override func viewDidLoad() {
		super.viewDidLoad()
		
		self.modalPresentationStyle = .custom
		self.transitioningDelegate = self
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



// MARK: - Animator

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


















