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
	open var menuViewController: (UIViewController & MenuViewControllable)! { didSet {
		updateMenuViewController(old: oldValue, new: menuViewController)
	}}
	open var isMenuShowing: Bool {
		return !(menuViewController?.presentingViewController).isNil
	}
	
	private let transitionManager = TransitionManager()
	
	
	open override var childViewControllerForStatusBarStyle: UIViewController? {
		return self.presentedViewController ?? rootViewController
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
		
		if let nc = new as? UINavigationController, let rc = nc.rootViewController {
			let bundle = Bundle(for: SlideMenuController.self)
			let image = UIImage(named: "hamburger-icon.png", in: bundle, compatibleWith: nil)!
			let menuButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(openMenu))
			rc.navigationItem.leftBarButtonItem = menuButton
			
			if let c = rc as? RootViewControllable {
				let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: transitionManager, action: #selector(TransitionManager.gestureOpen(_:)))
				edgePanGesture.edges = .left
				c.viewForEdgePanGestureRecognizer().addGestureRecognizer(edgePanGesture)
			}
		}
		
		if let c = new as? RootViewControllable {
			let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: transitionManager, action: #selector(TransitionManager.gestureOpen(_:)))
			edgePanGesture.edges = .left
			c.viewForEdgePanGestureRecognizer().addGestureRecognizer(edgePanGesture)
		}
	}
	
	private func updateMenuViewController(old: (UIViewController & MenuViewControllable)?, new: UIViewController & MenuViewControllable) {
		if isMenuShowing {
			old!.dismiss(animated: true, completion: openMenu)
		}
		
		new.controller = self
		new.attached(to: self)
		new.transitioningDelegate = transitionManager
		new.modalPresentationStyle = .overCurrentContext
	}
	
	
	
	open override func loadView() {
		self.view = UIView()
		self.view.backgroundColor = .white
	}
	
	open override func viewDidLoad() {
		super.viewDidLoad()
		
		transitionManager.slideMenuController = self
		
		let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: transitionManager, action: #selector(TransitionManager.gestureOpen(_:)))
		edgePanGesture.edges = .left
		self.view.addGestureRecognizer(edgePanGesture)
	}
	
	open override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		closeMenu(animated: false)
	}
}





class TransitionManager: UIPercentDrivenInteractiveTransition {
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
		let options: UIViewAnimationOptions = isInteractive ? .curveLinear : .curveEaseOut
		
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









public extension UIViewController {
	
	var slideMenuController: SlideMenuController? {
		return self.parent as? SlideMenuController
	}
}





public protocol RootViewControllable: class {
	func viewForEdgePanGestureRecognizer() -> UIView
}




public protocol MenuViewControllable: class {
	weak var controller: SlideMenuController? { get set }
	
	func attached(to controller: SlideMenuController)
}

public extension MenuViewControllable {
	
	func close() {
		controller?.closeMenu()
	}
}


















