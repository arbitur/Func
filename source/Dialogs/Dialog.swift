//
//  SheetDialog.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Apr/17.
//
//

import UIKit



public protocol DialogBuilder: class {
	var actions: [DialogAction] {get set}
	var customView: UIView? {get set}
	var customViewAddedToSuperview: ((Self)->())? {get set}
	
	func addAction(_ action: DialogAction) -> Self
}

public extension DialogBuilder {
	public func addNormal(title: String, callback: @escaping Closure) -> Self {
		return addAction(DialogAction(title: title, type: .normal, callback: callback))
	}
	
	public func addDelete(title: String, callback: @escaping Closure) -> Self {
		return addAction(DialogAction(title: title, type: .delete, callback: callback))
	}
	
	public func addCancel(title: String) -> Self {
		return addAction(DialogAction(title: title, type: .cancel, callback: nil))
	}
	
	public func setCustomView(_ view: UIView, addedToSuperview: ((Self)->())? = nil) -> Self {
		customView = view
		customViewAddedToSuperview = addedToSuperview
		return self
	}
}



public class DialogAction {
	let title: String
	let type: DialogActionType
	let callback: Closure?
	
	public init(title: String, type: DialogActionType, callback: Closure? = nil) {
		print("DialogAction(\"\(title)\")")
		self.title = title
		self.type = type
		self.callback = callback
	}
	
	deinit {
		print("~DialogAction")
	}
}

public enum DialogActionType {
	case normal, delete, cancel
}





open class Dialog: UIViewController {
	public final let contentBlurView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
	public final let mainContentStack = UIStackView(axis: .vertical)
	open var contentView: UIView { return contentBlurView }
	
	public final let promptTitle: String?
	public final let promptSubtitle: String?
	public final var promptContentView: UIStackView?
	
	public final var actions = [DialogAction]()
	
	
	
	
	
	public final func actionPressed(_ view: UIView) {
		actions[view.tag].callback?()
		self.dismiss(animated: true, completion: nil)
	}
	
	open func drawBackgroundHole(bezier: UIBezierPath) {
		bezier.append(UIBezierPath(roundedRect: contentView.frame, cornerRadius: contentView.cornerRadius))
	}
	
	
	open func generateTitleLabel() -> UILabel { fatalError() }
	open func generateSubtitleLabel() -> UILabel { fatalError() }
	
	
	
	open override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.view.setNeedsDisplay()
	}
	
	open override func loadView() {
		let view = MaskBackgroundView(frame: UIScreen.main.bounds)
		view.isOpaque = false
		view.viewController = self
		self.view = view
		self.view.add(view: contentView)
		
		if let title = promptTitle {
			promptContentView = UIStackView(axis: .vertical)
			promptContentView!.isLayoutMarginsRelativeArrangement = true
			promptContentView!.setContentCompressionResistancePriority(1000, for: .vertical)
			
			let titleLabel = generateTitleLabel()
			titleLabel.text = title
			titleLabel.setContentCompressionResistancePriority(1000, for: .vertical)
			promptContentView!.add(arrangedView: titleLabel)
			
			if let subtitle = promptSubtitle {
				let subtitleLabel = generateSubtitleLabel()
				subtitleLabel.text = subtitle
				subtitleLabel.setContentCompressionResistancePriority(1000, for: .vertical)
				promptContentView!.add(arrangedView: subtitleLabel)
			}
		}
		
		contentBlurView.contentView.add(view: mainContentStack) {
			$0.top.equalToSuperview()
			$0.left.equalToSuperview()
			$0.right.equalToSuperview()
			$0.bottom.equalToSuperview()
		}
		
		mainContentStack.add(arrangedView: promptContentView)
	}
	
	
	
	public init(title: String?, subtitle: String?) {
		promptTitle = title
		promptSubtitle = subtitle
		
		super.init(nibName: nil, bundle: nil)
		
		self.modalPresentationStyle = .overFullScreen
		self.modalTransitionStyle = .crossDissolve
	}
	
	// Have to override >:(
	public override init(nibName: String?, bundle: Bundle?) { fatalError() }
	public required init?(coder aDecoder: NSCoder)			{ fatalError() }
}








fileprivate class MaskBackgroundView: UIView {
	weak var viewController: Dialog?
	
	
	override func draw(_ rect: CGRect) {
		let bezier = UIBezierPath(rect: rect)
		viewController?.drawBackgroundHole(bezier: bezier)
		bezier.usesEvenOddFillRule = true
		
		UIColor.black.alpha(0.4).setFill()
		bezier.fill()
	}
}



















public class DialogAnimator<T: Dialog>: NSObject, UIViewControllerAnimatedTransitioning {
	public final let dismissing: Bool
	public final let duration: TimeInterval
	public final let controlPoints: (CGPoint, CGPoint)
	
	public init(dismissing: Bool, duration: TimeInterval, controlPoints: (CGPoint, CGPoint)) {
		self.dismissing = dismissing
		self.duration = duration
		self.controlPoints = controlPoints
		super.init()
	}
	
	open func prepareAnimation(_ viewController: T)				{ fatalError() }
	open func animation(_ viewController: T)					{ fatalError() }
	open func completion(_ viewController: T, finished: Bool)	{ fatalError() }
	
	
	
	public final func transitionDuration(using ctx: UIViewControllerContextTransitioning?) -> TimeInterval {
		return duration
	}
	
	public final func animateTransition(using ctx: UIViewControllerContextTransitioning) {
		let viewController: T
		switch dismissing {
			case true: viewController = ctx.viewController(forKey: .from) as! T
			case false: viewController = ctx.viewController(forKey: .to) as! T
		}
		
		prepareAnimation(viewController)
		ctx.containerView.add(view: viewController.view)
		
		if #available(iOS 10, *) {
			let animator = UIViewPropertyAnimator(duration: duration, controlPoint1: controlPoints.0, controlPoint2: controlPoints.1) {
				self.animation(viewController)
			}
			animator.addCompletion { pos in
				if pos == .end {
					ctx.completeTransition(true)
					self.completion(viewController, finished: true)
				}
			}
			animator.startAnimation()
		}
		else {
			UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut,
				animations: {
					self.animation(viewController)
				},
				completion: {
					ctx.completeTransition($0)
					self.completion(viewController, finished: $0)
				})
		}
	}
}


















