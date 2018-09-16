//
//  SlideMenuController.swift
//  Alamofire
//
//  Created by Philip Fryklund on 3/Oct/17.
//

import UIKit





open class SlideMenuController: DebugViewController {

	open var rootViewController: UIViewController! { didSet {
		updateRootViewController(old: oldValue, new: rootViewController)
	}}
	open var menuViewController: UIViewController! { didSet {
		updateMenuViewController(old: oldValue, new: menuViewController)
	}}
	open var isMenuShowing: Bool {
		return !(menuViewController?.presentingViewController).isNil
	}

	private let transitionManager = TransitionManager()


	open override var childViewControllerForStatusBarStyle: UIViewController? {
		let top = rootViewController?.childViewControllerForStatusBarStyle ?? rootViewController
		if let presented = top?.presentedViewController {
			if presented.isBeingDismissed {
				return top
			}
			else {
				return presented
			}
		}
		else {
			return top
		}
	}
	open override var childViewControllerForStatusBarHidden: UIViewController? {
		return self.childViewControllerForStatusBarStyle
	}
	open override func childViewControllerForHomeIndicatorAutoHidden() -> UIViewController? {
		return self.childViewControllerForStatusBarStyle
	}
	open override func childViewControllerForScreenEdgesDeferringSystemGestures() -> UIViewController? {
		return self.childViewControllerForStatusBarStyle
	}



	@objc open func openMenu() {
		self.present(menuViewController, animated: true, completion: nil)
	}

	open func closeMenu(animated: Bool = true) {
		menuViewController?.dismiss(animated: animated, completion: nil)
	}


	
	open func configureViewControllerAsRoot(_ viewController: UIViewController) {
		if let containerViewController = viewController as? RootContainerViewControllable {
			containerViewController.wasAddedToSlideMenuController(self)
		}
		
		if let nc = viewController as? UINavigationController, let viewController = nc.rootViewController {
			let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: transitionManager, action: #selector(TransitionManager.gestureOpen(_:)))
			edgePanGesture.edges = .left
			
			if let rootViewControllable = viewController as? RootViewControllable {
				rootViewControllable.viewForEdgePanGestureRecognizer.addGestureRecognizer(edgePanGesture)
			}
			else {
				viewController.view.addGestureRecognizer(edgePanGesture)
			}
		}
		else {
			let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: transitionManager, action: #selector(TransitionManager.gestureOpen(_:)))
			edgePanGesture.edges = .left
			
			if let rootViewControllable = viewController as? RootViewControllable {
				rootViewControllable.viewForEdgePanGestureRecognizer.addGestureRecognizer(edgePanGesture)
			}
			else {
				viewController.view.addGestureRecognizer(edgePanGesture)
			}
		}
	}

	private func updateRootViewController(old: UIViewController?, new: UIViewController) {
		old?.view.removeFromSuperview()
		old?.willMove(toParentViewController: nil)
		old?.removeFromParentViewController()

		self.addChildViewController(new)
		new.didMove(toParentViewController: self)

		self.loadViewIfNeeded()
		new.loadViewIfNeeded()
		self.view.add(view: new.view) {
			$0.top.equalToSuperview()
			$0.left.equalToSuperview()
			$0.right.equalToSuperview()
			$0.bottom.equalToSuperview()
		}

		configureViewControllerAsRoot(new)
	}

	private func updateMenuViewController(old: UIViewController?, new: UIViewController) {
		if isMenuShowing {
			old!.dismiss(animated: true, completion: openMenu)
		}

		new.transitioningDelegate = transitionManager
		new.modalPresentationStyle = .overCurrentContext
	}



	open override func loadView() {
		self.view = UIView()
//		self.view.backgroundColor = .white
	}

	open override func viewDidLoad() {
		super.viewDidLoad()

		transitionManager.slideMenuController = self

//		let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: transitionManager, action: #selector(TransitionManager.gestureOpen(_:)))
//		edgePanGesture.edges = .left
//		self.view.addGestureRecognizer(edgePanGesture)
	}

	open override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		closeMenu(animated: false)
	}
}





public protocol RootContainerViewControllable {

	func wasAddedToSlideMenuController(_ controller: SlideMenuController)
}

extension UINavigationController: RootContainerViewControllable {

	public func wasAddedToSlideMenuController(_ controller: SlideMenuController) {
		guard let rootViewController = self.rootViewController else {
			return
		}

		enableOpenMenuForViewController(rootViewController)
		
//		let bundle = Bundle(for: SlideMenuController.self)
//		let image = UIImage(named: "hamburger-icon.png", in: bundle, compatibleWith: nil)!
//		let menuButton = UIBarButtonItem(image: image, style: .plain, target: controller, action: #selector(SlideMenuController.openMenu))
//		rootViewController.navigationItem.leftBarButtonItem = menuButton
	}
	
	public func enableOpenMenuForViewController(_ viewController: UIViewController) {
		guard let controller = self.slideMenuController else {
			return
		}

		let bundle = Bundle(for: SlideMenuController.self)
		let image = UIImage(named: "hamburger-icon.png", in: bundle, compatibleWith: nil)!
		let menuButton = UIBarButtonItem(image: image, style: .plain, target: controller, action: #selector(SlideMenuController.openMenu))
		viewController.navigationItem.leftBarButtonItem = menuButton
	}
}


public protocol RootViewControllable: class {
	
	var viewForEdgePanGestureRecognizer: UIView { get }
}

extension UINavigationController: RootViewControllable {
	
	public var viewForEdgePanGestureRecognizer: UIView {
		guard let rootViewController = self.rootViewController else {
			self.loadViewIfNeeded()
			return self.view
		}
		
		rootViewController.loadViewIfNeeded()
		return rootViewController.view
	}
}

//extension UIViewController: RootViewControllable {
//
//	public func viewForEdgePanGestureRecognizer() -> UIView {
//		self.loadViewIfNeeded()
//		return self.view
//	}
//}

public extension UIViewController {
	
	var slideMenuController: SlideMenuController? {
		return (self.parent ?? self.presentingViewController) as? SlideMenuController
	}
}





private class TransitionManager: UIPercentDrivenInteractiveTransition {
	var isPresenting = false
	var isInteractive = false

	weak var slideMenuController: SlideMenuController?

	lazy var closeGestureRecognizer: UIGestureRecognizer = {
		let gesture = UIPanGestureRecognizer(target: self, action: #selector(gestureClose(_:)))
		gesture.delegate = self
		return gesture
	}()
}

extension TransitionManager {

	@objc func gestureOpen(_ gesture: UIScreenEdgePanGestureRecognizer) {
		let percent = gesture.point.x / slideMenuController!.menuViewController.view.bounds.width

		switch gesture.state {
		case .began:
			isInteractive = true
			slideMenuController!.openMenu()
			self.update(.leastNonzeroMagnitude)

		case .changed:
			self.update(min(percent, 1.0))

		default:
			isInteractive = false

			let velocity = gesture.velocity(in: gesture.view)
			if percent > 0.5 || velocity.x > 500 {
				self.finish()
			}
			else {
				self.cancel()
			}
		}
	}

 	@objc func gestureClose(_ gesture: UIPanGestureRecognizer) {
		let point = gesture.translation(in: gesture.view)
		let percent = -point.x / slideMenuController!.menuViewController.view.bounds.width

		switch gesture.state {
		case .began:
			isInteractive = true
			slideMenuController!.closeMenu()
			self.update(.leastNonzeroMagnitude)

		case .changed:
			self.update(min(percent, 1.0))

		default:
			self.isInteractive = false

			let velocity = gesture.velocity(in: gesture.view)
			if percent > 0.5 || -velocity.x > 500 {
				self.finish()
			}
			else {
				self.cancel()
			}
		}
	}
}

extension TransitionManager: UIViewControllerAnimatedTransitioning {

	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return isInteractive ? 0.2 : 0.3
	}

	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		let containerView = transitionContext.containerView
		let menuView = transitionContext.viewController(forKey: isPresenting ? .to : .from)!.view!
		let rootView = transitionContext.viewController(forKey: isPresenting ? .from : .to)!.view!

		menuView.frame.size = containerView.bounds.size * CGSize(0.8, 1)
		containerView.addSubview(menuView)

		if isPresenting {
			menuView.frame.right = 0
			containerView.backgroundColor = UIColor.clear
		}

		func animations() {
			if isPresenting {
				menuView.frame.left = 0
				containerView.backgroundColor = UIColor.black.alpha(0.25)
			}
			else {
				menuView.frame.right = 0
				containerView.backgroundColor = UIColor.clear
			}

			if isInteractive {
				// To get rid of unwanted behavior. (Animation finishes non-interactive)
				DispatchQueue.main.async {
					self.update(.leastNonzeroMagnitude)
				}
			}
		}

		let duration = transitionDuration(using: transitionContext)
//		let options: UIViewAnimationOptions = isInteractive ? .curveLinear : .curveEaseOut
		let options: UIViewAnimationOptions = .curveEaseOut

		UIView.animate(withDuration: duration, delay: 0, options: options,
			animations: animations,
			completion: { _ in
				if self.isPresenting && !transitionContext.transitionWasCancelled {
					containerView.addGestureRecognizer(self.closeGestureRecognizer)
				}

				transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
			})
	}
}

extension TransitionManager: UIGestureRecognizerDelegate {

	public func gestureRecognizerShouldBegin(_ gesture: UIGestureRecognizer) -> Bool {
		return gesture.point.x > slideMenuController!.menuViewController.view.bounds.width - 44
	}
}


extension TransitionManager: UIViewControllerTransitioningDelegate {

	public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		isPresenting = true
		return self
	}

	public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		isPresenting = false
		return self
	}

	public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		isPresenting = true
		return isInteractive ? self : nil
	}

	public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		isPresenting = false
		return isInteractive ? self : nil
	}
}









@available(iOS, obsoleted: 1.0)
open class SlideMenuViewController: UIViewController {
	
	open var rootViewController: UIViewController? {
		willSet {
			rootViewController?.view.removeFromSuperview()
			rootViewController?.willMove(toParentViewController: nil)
			rootViewController?.removeFromParentViewController()
		}
		didSet {
			self.viewIfLoaded?.setNeedsLayout()
		}
	}
	
	open var menuViewController: UIViewController? {
		willSet {
			if isMenuShowing {
				fatalError("Can't change menu when menu is showing")
			}
			menuViewController?.willMove(toParentViewController: nil)
			menuViewController?.removeFromParentViewController()
		}
		didSet {
			guard let menu = menuViewController else {
				return
			}
			
			self.addChildViewController(menu)
			menu.didMove(toParentViewController: self)
		}
	}
	
	private var isMenuShowing: Bool {
		return menuViewController?.view.superview != nil
	}
	
	
	
	
	private let animationDuration: TimeInterval = 0.25
	private func animateShowMenu() {
		guard let menu = menuViewController else {
			return
		}
		
		menu.loadViewIfNeeded()
		menu.beginAppearanceTransition(true, animated: true)
		self.view.addSubview(menu.view)
		menu.view.frame = self.view.bounds
		menu.view.frame.widt *= 0.8
		menu.view.frame.right = 0
		
		rootViewController?.view.isUserInteractionEnabled = false
		
		UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut,
			animations: {
				menu.view.frame.left = 0
			},
			completion: { _ in
				self.rootViewController?.view.isUserInteractionEnabled = true
				menu.endAppearanceTransition()
				menu.view.removeFromSuperview()
			})
	}
	
	
	private func startInteractive() {
		self.view.layer.speed = 0.0
		animateShowMenu()
	}
	
	private var lastPercent: CFTimeInterval = 0
	private func updateInteractive(_ percent: CFTimeInterval) {
		let percent = boundary(percent, min: 0.0, max: 1.0)
		lastPercent = percent
		let offset = percent * animationDuration
//		print(percent, offset)
		self.view.layer.timeOffset = offset
	}
	
	private func endInteractive() {
//		let speed = Float((1 - lastPercent) * animationDuration)
//		self.view.layer.speed = speed
//		print(speed)

		self.view.layer.speed = 1
//		let pausedTime = self.view.layer.timeOffset
//		self.view.layer.timeOffset = 0
//		self.view.layer.beginTime = CACurrentMediaTime() -  pausedTime
////		self.view.layer.beginTime = self.view.layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
//		print(self.view.layer.beginTime)
		
		
//		self.view.layer.timeOffset = 0
//		self.view.layer.beginTime = 0
//		let speed = Float((1 - lastPercent) * animationDuration)
//		self.view.layer.speed = speed
	}
	
	
	@objc private func edgePanLeft(_ gesture: UIScreenEdgePanGestureRecognizer) {
		switch gesture.state {
		case .began:
			startInteractive()
		
		case .changed:
			let panDistance = gesture.translation(in: self.view).x
			let percent = Double( panDistance / menuViewController!.view.frame.width )
			updateInteractive(percent)
		
		default:
			endInteractive()
		}
	}
	
	
	
	private func addRootViewController() {
		guard let root = rootViewController, root.parent != self else {
			return
		}
		
		self.addChildViewController(root)
		
		self.loadViewIfNeeded()
		root.loadViewIfNeeded()
		
		root.view.frame = self.view.bounds
		root.beginAppearanceTransition(true, animated: false)
		self.view.insertSubview(root.view, at: 0)
		
		root.view.lac.make {
			$0.top.equalToSuperview()
			$0.left.equalToSuperview()
			$0.right.equalToSuperview()
			$0.bottom.equalToSuperview()
		}
		
		root.endAppearanceTransition()
		root.didMove(toParentViewController: self)
		
		let panGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgePanLeft(_:)))
		panGesture.edges = .left
		
		switch root {
			case let r as RootViewControllable: r.viewForEdgePanGestureRecognizer.addGestureRecognizer(panGesture)
			default: root.view.addGestureRecognizer(panGesture)
		}
	}
	
	
	open override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		addRootViewController()
	}
	
	
	open override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		addRootViewController()
	}
}


//public extension UIViewController {
//	
//	var slideMenuViewController: SlideMenuViewController? {
//		return self.parent as? SlideMenuViewController
//	}
//}


















