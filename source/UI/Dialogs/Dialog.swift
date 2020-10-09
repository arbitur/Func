//
//  SheetDialog.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Apr/17.
//
//

import UIKit


// MARK: - Dialog

open class DialogController: UIViewController {
	
	/// Box background blur view
	public let contentBlurView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
	/// StackView separating title container, custom views and action container.
	public let mainContentStack = UIStackView(axis: .vertical)
	/// The view to cut a hole from?
	open var contentView: UIView { return contentBlurView }
	
	/// The title of the dialog
	public let promptTitle: String?
	/// The subtitle of the dialog
	public let promptSubtitle: String?
//	/// The view containing title and subtitle labels
	public var promptContentView: UIStackView?
	
	/// Custom views
	public var customViews: [UIView] = []
	
	
	open class func makeTitleLabel() -> UILabel { fatalError() }
	open class func makeSubtitleLabel() -> UILabel { fatalError() }
	
	
	open func addCustomView(_ view: UIView, at index: Int? = nil) {
		if let index = index {
			customViews.insert(view, at: index)
		}
		else {
			customViews.append(view)
		}
	}
	
	
	open func drawBackgroundHole(bezier: UIBezierPath) {
		bezier.append(UIBezierPath(roundedRect: contentView.frame, cornerRadius: contentView.cornerRadius))
	}
	
	
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
		
		contentBlurView.contentView.add(view: mainContentStack) {
			$0.edges.equalToSuperview()
		}
		
		// Titles
		if promptTitle != nil || promptSubtitle != nil {
			let promptContentView = UIStackView(axis: .vertical)
			promptContentView.isLayoutMarginsRelativeArrangement = true
			promptContentView.setContentCompressionResistancePriority(.required, for: .vertical)
			
			if let title = promptTitle, title.isNotEmpty {
				let label = Self.makeTitleLabel()
				label.text = title
				label.setContentCompressionResistancePriority(.required, for: .vertical)
				promptContentView.add(arrangedView: label)
			}
			
			if let subtitle = promptSubtitle, subtitle.isNotEmpty {
				let label = Self.makeSubtitleLabel()
				label.text = subtitle
				label.setContentCompressionResistancePriority(.required, for: .vertical)
				promptContentView.add(arrangedView: label)
			}
			
			self.promptContentView = promptContentView
			mainContentStack.add(arrangedView: promptContentView)
		}
		
		// Custom views
		customViews.forEach(mainContentStack.addArrangedSubview(_:))
	}
	
	public required init(title: String?, subtitle: String?) {
		promptTitle = title
		promptSubtitle = subtitle
		
		super.init(nibName: nil, bundle: nil)
		
		self.modalPresentationStyle = .overFullScreen
		self.modalTransitionStyle = .crossDissolve
	}
	
	public override init(nibName: String?, bundle: Bundle?) { fatalError() }
	public required init?(coder aDecoder: NSCoder) { fatalError() }
}


// MARK: - Action dialog

open class ActionDialogController: DialogController {
	
	public var actions: [DialogAction] = []
	public var actionButtons: [UIButton] = []
	
	
	open class func makeActionButton(for type: DialogActionType) -> UIButton { fatalError("Abstract") }
	
	@objc private func handleActionButtonPressed(_ button: UIButton) {
		guard let index = actionButtons.firstIndex(of: button) else {
			return assertionFailure()
		}
		self.dismiss(animated: true, completion: nil)
		actions[index].action?()
	}
	
	open func addAction(_ action: DialogAction) {
		actions.append(action)
	}
	
	@discardableResult
	open func addNormal(title: String, action: Closure? = nil) -> DialogAction {
		let action = DialogAction(title: title, type: .normal, action: action)
		addAction(action)
		return action
	}
	
	@discardableResult
	open func addDelete(title: String, action: @escaping Closure) -> DialogAction {
		let action = DialogAction(title: title, type: .delete, action: action)
		addAction(action)
		return action
	}
	
	@discardableResult
	open func addCancel(title: String, action: Closure? = nil) -> DialogAction {
		let action = DialogAction(title: title, type: .cancel, action: action)
		addAction(action)
		return action
	}
	
	
	open override func loadView() {
		super.loadView()
		
		for action in actions {
			let button = Self.makeActionButton(for: action.type)
			button.setTitle(action.title, for: .normal)
			button.isEnabled = action.isEnabled
			button.addTarget(self, action: #selector(handleActionButtonPressed(_:)))
			actionButtons.append(button)
			action.button = button
		}
	}
}


// MARK: - Action model

public enum DialogActionType: UInt {
	case normal
	case delete
	case cancel
}

public class DialogAction {
	
	let title: String
	let type: DialogActionType
	let action: Closure?
	public var isEnabled: Bool = true {
		didSet {
			button?.isEnabled = isEnabled
		}
	}
	internal weak var button: UIButton?
	
	public init(title: String, type: DialogActionType, action: Closure? = nil) {
		self.title = title
		self.type = type
		self.action = action
	}
}

extension DialogAction: CustomStringConvertible {
	
	public var description: String {
		return "DialogAction(\(title), \(type.rawValue)"
	}
}



// MARK: - Background hole view

private class MaskBackgroundView: UIView {
	
	weak var viewController: DialogController?
	
	override func draw(_ rect: CGRect) {
		let bezier = UIBezierPath(rect: rect)
		viewController?.drawBackgroundHole(bezier: bezier)
		bezier.usesEvenOddFillRule = true
		bezier.fill(UIColor.black.alpha(0.4))
	}
}




// MARK: - Animator

public class DialogAnimator<T: DialogController>: NSObject, UIViewControllerAnimatedTransitioning {
	
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
