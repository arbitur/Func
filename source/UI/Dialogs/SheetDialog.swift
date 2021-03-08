//
//  SheetDialog.swift
//  Pods
//
//  Created by Philip Fryklund on 24/Apr/17.
//
//

import UIKit



public typealias SheetDialog = SheetDialogController // For backwards compatibility

open class SheetDialogController: ActionDialogController {
	
	private let contentStackView = UIStackView(axis: .vertical)
	open override var contentView: UIView { return contentStackView }
	fileprivate var cancelActionView: UIView?
	
	
	override open class func makeTitleLabel() -> UILabel {
		let font = UIFont.boldSystemFont(ofSize: 13)
		let color = UIColor(white: 0.56, alpha: 1)
		return UILabel(font: font , color: color, alignment: .center, lines: 0)
	}
	
	override open class func makeSubtitleLabel() -> UILabel	{
		let font = UIFont.systemFont(ofSize: 13)
		let color = UIColor(white: 0.56, alpha: 1)
		return UILabel(font: font, color: color, alignment: .center, lines: 0)
	}
	
	open override class func makeActionButton(for type: DialogActionType) -> UIButton {
		let color: UIColor
		let font: UIFont
		switch type {
		case .normal: color = UIColor(red: 0.0, green: 0.48, blue: 1.00, alpha: 1.0) ; font = UIFont.systemFont(ofSize: 20)
		case .delete: color = UIColor(red: 1.0, green: 0.23, blue: 0.19, alpha: 1.0) ; font = UIFont.systemFont(ofSize: 20)
		case .cancel: color = UIColor(red: 0.0, green: 0.48, blue: 1.00, alpha: 1.0) ; font = UIFont.boldSystemFont(ofSize: 20)
		}
		
		let button = UIButton(type: .system)
		button.setTitleColor(color, for: .normal)
		
		button.titleLabel!.font = font
		button.titleLabel!.textAlignment = .center
		
		button.lac.height.equalTo(57)
		
		return button
	}
	
	private func makeBorder() -> UIView {
		UIView(backgroundColor: UIColor.lightGray.alpha(0.4))
	}
	
	
	override open func addAction(_ action: DialogAction) {
		if action.type == .cancel, actions.contains(where: { $0.type == .cancel }) {
			fatalError("There can only be one cancel action")
		}
		super.addAction(action)
	}
	
	
	@objc func dismissSheet() {
		self.dismiss(animated: true, completion: nil)
	}
	
	
	open override func drawBackgroundHole(bezier: UIBezierPath) {
		guard !self.isBeingPresented && !self.isBeingDismissed else {
			return
		}
		
		let frame1 = contentStackView.convert(contentBlurView.frame, to: self.view)
		bezier.append(UIBezierPath(roundedRect: frame1, cornerRadius: contentBlurView.cornerRadius))
		
		if let cancelActionView = cancelActionView {
			let frame2 = contentStackView.convert(cancelActionView.frame, to: self.view)
			bezier.append(UIBezierPath(roundedRect: frame2, cornerRadius: cancelActionView.cornerRadius))
		}
	}
	
	open override func loadView() {
		super.loadView()
		
		contentStackView.spacing = 8
		
		contentView.lac.make {
			$0.left.equalToSuperview(10)
			$0.right.equalToSuperview(-10) //TODO: Check still works
			$0.top.greaterThan(self.topLayoutGuide.lac.bottom, constant: 10)
			// iPhone X
			$0.bottom.equalTo(self.bottomLayoutGuide.lac.top, priority: .defaultHigh)
			$0.bottom.lessThanSuperview(-10)
		}
		
		contentBlurView.cornerRadius = 13.5
		contentBlurView.clipsToBounds = true
		contentStackView.add(arrangedView: contentBlurView)
		
		promptContentView?.layoutMargins = UIEdgeInsets(horizontal: 16, top: 14, bottom: (promptSubtitle == nil) ? 14 : 25)
		promptContentView?.spacing = 12
		
		if actions.isNotEmpty {
			var actionButtons = self.actionButtons
			let cancelButton = actions.firstIndex(where: { $0.type == .cancel }).map { actionButtons.remove(at: $0) }
			
			let buttonContentView = UIStackView(axis: .vertical)
			
			if promptContentView != nil || customViews.isNotEmpty {
				mainContentStack.add(arrangedView: makeBorder()) {
					$0.height.equalTo(points(pixels: 1))
				}
			}
			
			var previousButton: UIButton?
			for button in actionButtons {
				if previousButton != nil {
					buttonContentView.add(arrangedView: makeBorder()) {
						$0.height.equalTo(points(pixels: 1))
					}
				}
				buttonContentView.add(arrangedView: button)
				previousButton = button
			}
			
			mainContentStack.addArrangedSubview(buttonContentView)
			
			if let button = cancelButton {
				let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
				blurView.cornerRadius = contentBlurView.cornerRadius
				blurView.clipsToBounds = true
				blurView.contentView.add(view: button) {
					$0.edges.equalToSuperview()
				}
				contentStackView.add(arrangedView: blurView)
				cancelActionView = blurView
			}
		}
	}
	
	open override func viewDidLoad() {
		super.viewDidLoad()
		
		// Dont dismiss when tapping background if there is no cancel option
		if actions.contains(where: { $0.type == .cancel }) {
			self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissSheet)))
		}
		
		self.modalPresentationStyle = .custom
		self.transitioningDelegate = self
	}
}


extension SheetDialog: UIViewControllerTransitioningDelegate {
	
	public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return SheetAnimator(dismissing: false, duration: 1.0/3.0, controlPoints: (CGPoint(0.1, 1), CGPoint(0.85, 1)))
	}
	
	public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return SheetAnimator(dismissing: true, duration: 1.0/3.0, controlPoints: (CGPoint(0.1, 1), CGPoint(0.85, 1)))
	}
}





private class SheetAnimator: DialogAnimator<SheetDialog> {
	
	override func prepareAnimation(_ viewController: SheetDialog) {
		viewController.contentBlurView.backgroundColor = .white
		viewController.cancelActionView?.backgroundColor = .white
		
		if !dismissing {
			viewController.contentView.layoutIfNeeded()
			viewController.contentView.transform(moveX: 0, y: viewController.contentView.frame.height)
			viewController.view.alpha = 0.0
		}
	}
	
	override func animation(_ viewController: SheetDialog) {
		if dismissing {
			viewController.view.alpha = 0.0
			viewController.contentView.transform(moveX: 0, y: viewController.contentView.frame.height)
			viewController.view.setNeedsDisplay()
		}
		else {
			viewController.view.alpha = 1.0
			viewController.contentView.transform(moveX: 0, y: 0)
		}
	}
	
	override func completion(_ viewController: SheetDialog, finished: Bool) {
		if !dismissing {
			viewController.view.setNeedsDisplay()
			viewController.contentBlurView.backgroundColor = nil
			viewController.cancelActionView?.backgroundColor = nil
		}
	}
}
