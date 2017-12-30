//
//  SheetDialog.swift
//  Pods
//
//  Created by Philip Fryklund on 24/Apr/17.
//
//

import UIKit





open class SheetDialog: Dialog, DialogBuilder {
	
	private let contentStackView = UIStackView(axis: .vertical)
	open override var contentView: UIView { return contentStackView }
	fileprivate var cancelActionView: UIView?
	
	open var customViews = [UIView]()
	open var didAddCustomViewToSuperview: ((SheetDialog, UIView) -> ())?
	
	
	
	
	open override func drawBackgroundHole(bezier: UIBezierPath) {
		if !self.isBeingPresented && !self.isBeingDismissed {
			let frame1 = contentStackView.convert(contentBlurView.frame, to: self.view)
			bezier.append(UIBezierPath(roundedRect: frame1, cornerRadius: contentBlurView.cornerRadius))
			
			if let cancelActionView = cancelActionView {
				let frame2 = contentStackView.convert(cancelActionView.frame, to: self.view)
				bezier.append(UIBezierPath(roundedRect: frame2, cornerRadius: cancelActionView.cornerRadius))
			}
		}
	}
	
	
	override open func generateTitleLabel() -> UILabel {
		if let _ = promptSubtitle {
			let font = UIFont.boldSystemFont(ofSize: 13)
			let color = UIColor(white: 0.56, alpha: 1)
			return UILabel(font: font , color: color, alignment: .center, lines: 0)
		}
		return generateSubtitleLabel()
	}
	
	override open func generateSubtitleLabel() -> UILabel {
		let font = UIFont.systemFont(ofSize: 13)
		let color = UIColor(white: 0.56, alpha: 1)
		return UILabel(font: font, color: color, alignment: .center, lines: 0)
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
			case .normal: font = UIFont.systemFont(ofSize: 20)
			case .delete: font = UIFont.systemFont(ofSize: 20)
			case .cancel: font = UIFont.boldSystemFont(ofSize: 20)
		}
		
		let button = UIButton(type: .system, target: self, action: #selector(actionPressed))
		button.setTitleColor(color, for: .normal)
		button.setTitle(action.title, for: .normal)
		
		button.titleLabel!.font = font
		button.titleLabel!.textAlignment = .center
		
		button.lac.height.equalTo(57)
		
		return button
	}
	
	private func generateBorder() -> UIView {
		return UIView(backgroundColor: UIColor.lightGray.alpha(0.4))
	}
	
	
	
	@objc func dismissSheet() {
		self.dismiss(animated: true, completion: nil)
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
		
		contentStackView.add(arrangedView: contentBlurView)
	}
	open override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissSheet)))
		
		self.modalPresentationStyle = .custom
		self.transitioningDelegate = self
		
		contentBlurView.cornerRadius = 13.5
		
		promptContentView?.layoutMargins = UIEdgeInsets(horizontal: 16, top: 14, bottom: (promptSubtitle == nil) ? 14 : 25)
		promptContentView?.spacing = 12
		
		for view in customViews {
			mainContentStack.add(arrangedView: view)
			didAddCustomViewToSuperview?(self, view)
		}
		
		if !actions.isEmpty {
			let buttonContentView = UIStackView(axis: .vertical)
			
			if let _ = promptContentView {
				mainContentStack.add(arrangedView: generateBorder()) {
					$0.height.equalTo(points(pixels: 1))
				}
			}
			
			mainContentStack.add(arrangedView: buttonContentView)
			
			// Insert upper actions
			func insertUpperActions() {
				if actions.isEmpty { return }
				var lastButton: UIButton?
				for i in 0..<actions.count-1 {
					let button = generateActionButton(actions[i])
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
					lastButton = button
				}
			}
			insertUpperActions()
			
			// Set cancel action
			func setCancelAction() {
				let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
				blurView.cornerRadius = contentBlurView.cornerRadius
				
				let button = generateActionButton(actions.last!)
				button.tag = actions.count-1
				blurView.contentView.add(view: button) {
					$0.top.equalToSuperview()
					$0.left.equalToSuperview()
					$0.right.equalToSuperview()
					$0.bottom.equalToSuperview()
				}
				
				contentStackView.add(arrangedView: blurView)
				
				cancelActionView = blurView
			}
			setCancelAction()
		}
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





















