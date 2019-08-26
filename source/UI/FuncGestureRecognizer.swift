//
//  File.swift
//  Func
//
//  Created by Philip Fryklund on 13/Aug/19.
//

import Foundation
//import UIKit.UIGestureRecognizerSubclass





open class TapGestureRecognizer: UITapGestureRecognizer {
	
	public typealias Callback = (UIGestureRecognizer.State) -> ()
	private var callback: Callback?
	
	
	@objc private func handleTap() {
		callback?(self.state)
	}
	
	public init(callback: @escaping Callback) {
		super.init(target: nil, action: nil)
		self.addTarget(self, action: #selector(handleTap))
		self.callback = callback
	}
	
	
//	
//	// the following methods are to be overridden by subclasses of UIGestureRecognizer
//	// if you override one you must call super
//	
//	// called automatically by the runtime after the gesture state has been set to UIGestureRecognizerStateEnded
//	// any internal state should be reset to prepare for a new attempt to recognize the gesture
//	// after this is received all remaining active touches will be ignored (no further updates will be received for touches that had already begun but haven't ended)
//	open override func reset() {
//	}
//	
//	
//	// same behavior as the equivalent delegate methods, but can be used by subclasses to define class-wide prevention rules
//	// for example, a UITapGestureRecognizer never prevents another UITapGestureRecognizer with a higher tap count
//	open override func canPrevent(_ preventedGestureRecognizer: UIGestureRecognizer) -> Bool {
//		return true
//	}
//	
//	open override func canBePrevented(by preventingGestureRecognizer: UIGestureRecognizer) -> Bool {
//		return true
//	}
//	
//	
//	
////	// same behavior as the equivalent delegate methods, but can be used by subclasses to define class-wide failure requirements
////	@available(iOS 7.0, *)
////	open func shouldRequireFailure(of otherGestureRecognizer: UIGestureRecognizer) -> Bool {
////	}
////
////	@available(iOS 7.0, *)
////	open func shouldBeRequiredToFail(by otherGestureRecognizer: UIGestureRecognizer) -> Bool {
////	}
//	
//	
//	// mirror of the touch-delivery methods on UIResponder
//	// UIGestureRecognizers aren't in the responder chain, but observe touches hit-tested to their view and their view's subviews
//	// UIGestureRecognizers receive touches before the view to which the touch was hit-tested
//	open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
//		super.touchesBegan(touches, with: event)
//		callback?(self.state)
//	}
//
//	open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
//		super.touchesMoved(touches, with: event)
//		callback?(self.state)
//	}
//
//	open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
//		super.touchesEnded(touches, with: event)
//		callback?(self.state)
//	}
//
//	open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
//		super.touchesCancelled(touches, with: event)
//		callback?(self.state)
//	}
//
////	@available(iOS 9.1, *)
////	open override func touchesEstimatedPropertiesUpdated(_ touches: Set<UITouch>) {
////	}
////
////
////	@available(iOS 9.0, *)
////	open override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent) {
////	}
////
////	@available(iOS 9.0, *)
////	open override func pressesChanged(_ presses: Set<UIPress>, with event: UIPressesEvent) {
////	}
////
////	@available(iOS 9.0, *)
////	open override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent) {
////	}
////
////	@available(iOS 9.0, *)
////	open override func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent) {
////	}
}
