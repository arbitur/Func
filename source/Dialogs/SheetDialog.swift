//
//  SheetDialog.swift
//  Pods
//
//  Created by Philip Fryklund on 24/Apr/17.
//
//

import UIKit





public final class SheetDialog: Dialog {
	private let contentStackView = UIStackView(axis: .vertical)
	public override var contentView: UIView { return contentStackView }
	fileprivate var cancelActionView: UIView?
	
	public var customView: UIView?
	
	
	
	
	public override func drawBackgroundHole(bezier: UIBezierPath) {
		if !self.isBeingPresented && !self.isBeingDismissed {
			let frame1 = contentStackView.convert(contentBlurView.frame, to: self.view)
			bezier.append(UIBezierPath(roundedRect: frame1, cornerRadius: contentBlurView.cornerRadius))
			
			if let cancelActionView = cancelActionView {
				let frame2 = contentStackView.convert(cancelActionView.frame, to: self.view)
				bezier.append(UIBezierPath(roundedRect: frame2, cornerRadius: cancelActionView.cornerRadius))
			}
		}
	}
	
	
	override public func generateTitleLabel() -> UILabel {
		if let _ = promptSubtitle {
			let font = UIFont.boldSystemFont(ofSize: 13)
			let color = UIColor(white: 0.56, alpha: 1)
			return UILabel(font: font , color: color, alignment: .center, lines: 0)
		}
		return generateSubtitleLabel()
	}
	
	override public func generateSubtitleLabel() -> UILabel {
		let font = UIFont.systemFont(ofSize: 13)
		let color = UIColor(white: 0.56, alpha: 1)
		return UILabel(font: font, color: color, alignment: .center, lines: 0)
	}
	
	class Button: UIButton {
		deinit {
			print("~Button")
		}
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
		
		let button = Button(type: .system, target: self, action: #selector(actionPressed))
		button.setTitleColor(color, for: .normal)
		button.setTitle(action.title, for: .normal)
		
		button.titleLabel!.font = font
		button.titleLabel!.textAlignment = .center
		
		button.lac.height.equal(to: 57)
		
		return button
	}
	
	private func generateBorder() -> UIView {
		return UIView(backgroundColor: UIColor.lightGray.alpha(0.4))
	}
	
	
	
	func dismissSheet() {
		self.dismiss(animated: true, completion: nil)
	}
	
	public override func loadView() {
		super.loadView()
		
		contentStackView.spacing = 8
		
		contentView.lac.make {
			$0.top.greater(thanSuperview: 20)
			$0.left.equal(toSuperview: 10)
			$0.right.equal(toSuperview: -10)
			$0.bottom.equal(toSuperview: -10)
		}
		
		contentStackView.add(arrangedView: contentBlurView)
	}
	public override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissSheet)))
		
		self.modalPresentationStyle = .custom
		self.transitioningDelegate = self
		
		contentBlurView.cornerRadius = 13.5
		
		promptContentView?.layoutMargins = UIEdgeInsets(horizontal: 16, top: 14, bottom: (promptSubtitle == nil) ? 14 : 25)
		promptContentView?.spacing = 12
		
		if let view = customView {
			mainContentStack.add(arrangedView: view)
		}
		
		if !actions.isEmpty {
			let buttonContentView = UIStackView(axis: .vertical)
			
			if let _ = promptContentView {
				mainContentStack.add(arrangedView: generateBorder()) {
					$0.height.equalTo(points(pixels: 1.0))
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
								case .horizontal: $0.width.equalTo(points(pixels: 1.0))
								case .vertical	: $0.height.equalTo(points(pixels: 1.0))
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
					$0.edges.equalToSuperview()
				}
				
				contentStackView.add(arrangedView: blurView)
				
				cancelActionView = blurView
			}
			setCancelAction()
		}
	}
}

extension SheetDialog: DialogBuilder {
	public func addAction(_ action: DialogAction) -> SheetDialog {
		actions.append(action)
		return self
	}
}

extension SheetDialog: UIViewControllerTransitioningDelegate {
	public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return SheetAnimator(dismissing: false, duration: 1.0/3.0, controlPoints: (CGPoint(0.1, 1), CGPoint(1, 1)))
	}
	
	public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return SheetAnimator(dismissing: true, duration: 1.0/3.0, controlPoints: (CGPoint(0.1, 1), CGPoint(1, 1)))
	}
}







fileprivate class SheetAnimator: DialogAnimator<SheetDialog> {
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





















