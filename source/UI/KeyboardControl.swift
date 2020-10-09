//
//  KeyboardControl.swift
//  Test
//
//  Created by Philip Fryklund on 8/Dec/16.
//  Copyright © 2016 Philip Fryklund. All rights reserved.
//

import UIKit





public class KeyboardControl: NSObject {
	public typealias EventHandler = (_ event: KeyboardEvent) -> ()
	public typealias KeyboardDisplayableClass = KeyboardDisplayable
	
	private var toolbar: UIToolbar?
	private var leftArrow: UIBarButtonItem?
	private var rightArrow: UIBarButtonItem?
	
	private let containerView: UIView?
	private let inputs: [KeyboardDisplayableClass]
	private var individualDelegates = [Weak<NSObjectProtocol>]()
	
	private let handler: EventHandler
	
	private weak var currentInput: KeyboardDisplayableClass? {
		didSet {
			updateToolbar()
		}
	}
	private var selectedIndex: Int? {
		return inputs.firstIndex {
			$0 === currentInput
		}
	}
	
	private var _isMoving: Bool = false
	
	
	
	private func handleNotification(_ notification: Notification, isOpening: Bool) {
		let data = KeyboardNotificationData(notification)
		
		if isOpening {
			UIView.performWithoutAnimation {
				toolbar?.frame.size.width = data.frame.width
			}
		}
		
		UIView.animate(withDuration: data.duration, delay: 0, options: data.options,
			animations: {
				if isOpening {
					guard let projectedBottom = self.currentInput?.projectedFrame(to: self.containerView)?.bottom else {
						print("*******************************************", self.currentInput as Any)
						return// self.handler(KeyboardEvent(isOpening: true, keyboardFrame: data.frame, input: nil, distance: nil))
					}
					let top = data.frame.top - 16
					let distance = top - projectedBottom
					
					self.handler(KeyboardEvent(isOpening: true, keyboardFrame: data.frame, input: self.currentInput!, distance: distance))
				}
				else if !self._isMoving {
					self.handler(KeyboardEvent(isOpening: false, keyboardFrame: data.frame, input: nil, distance: nil))
				}
			},
			completion: nil)
	}
	
	
	
	@objc private func keyboardWillShow(_ notification: Notification) {
		handleNotification(notification, isOpening: true)
	}
	
	@objc private func keyboardWillHide(_ notification: Notification) {
		handleNotification(notification, isOpening: false)
	}
	
	@objc private func keyboardDidShow(_ notification: Notification) {
		_isMoving = false
	}
	
	@objc private func keyboardDidHide(_ notification: Notification) {
	}
	
	
	private func moveToInput(_ input: KeyboardDisplayableClass) {
		guard input !== currentInput else { return }
		switch input {
			case let textField as UITextField: _isMoving = textField.isEnabled
			default: _isMoving = true
		}
		currentInput?.resignFirstResponder()
		input.becomeFirstResponder()
	}
	
	@objc private func back() {
		if let input = inputs[safe: selectedIndex! - 1] {
			moveToInput(input)
		}
	}
	
	@objc private func forward() {
		if let input = inputs[safe: selectedIndex! + 1] {
			moveToInput(input)
		}
	}
	
	@objc private func done() {
		currentInput?.resignFirstResponder()
	}
	
	
	private func updateToolbar() {
		guard
			let index = selectedIndex,
			let toolbar = toolbar
		else {
			return
		}
		
		switch index {
			case 0:
				leftArrow?.isEnabled = false
				rightArrow?.isEnabled = true
			
			case self.inputs.count - 1:
				leftArrow?.isEnabled = true
				rightArrow?.isEnabled = false
			
			default:
				leftArrow?.isEnabled = true
				rightArrow?.isEnabled = true
		}
		
		let input = inputs[index]
		
		switch input.keyboardAppearance! {
			case .dark:
				toolbar.barStyle = .black
				toolbar.items!.forEach { $0.tintColor = .white }
			
			default:
				toolbar.barStyle = .default
				toolbar.items!.forEach { $0.tintColor = UIColor(hex: 0x34AADC) }
		}
	}
	
	
	public func deactivate() {
		print("KeyboardControl deactvated")
		
		currentInput?.resignFirstResponder()
		
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
	}
	
	public func activate() {
		print("KeyboardControl activated")
		
		NotificationCenter.default.removeObserver(self)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
	}
	
	
	
	/// Remember, `handler` with `self` WILL cause retain-cycle, add [unowned/weak self] in closure
	public init(containerView: UIView? = nil, inputs: [KeyboardDisplayableClass], inputAccessoryView: Bool = true, arrows: Bool = true, handler: @escaping EventHandler) {
		self.containerView = containerView
		self.handler = handler
		self.inputs = inputs
		
		super.init()
		
		// Replace inputs delegates with self and store them separatelly
		inputs.forEach { input in
			self.individualDelegates ++= Weak(data: input._delegate)
			input._delegate = self
		}
		
		
		if inputAccessoryView {
			toolbar = UIToolbar()
			toolbar!.isTranslucent = true
			toolbar!.frame.size.height = 44
			toolbar!.items = []
			
			if arrows && inputs.count > 1 {
				let bundle = Bundle(for: self.classForCoder)
				let leftImage = UIImage(named: "arrow-up", in: bundle, compatibleWith: nil)
				let rightImage = UIImage(named: "arrow-down", in: bundle, compatibleWith: nil)
				
				leftArrow = UIBarButtonItem(image: leftImage, style: .done, target: self, action: #selector(back))
				rightArrow = UIBarButtonItem(image: rightImage, style: .done, target: self, action: #selector(forward))
				toolbar!.items!.append(leftArrow!)
				toolbar!.items!.append(rightArrow!)
			}
			toolbar!.items!.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
			toolbar!.items!.append(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done)))
			
			for input in inputs {
				input.inputAccessoryView = toolbar
			}
		}
	}
	
	public convenience init(superview: UIView, inputAccessoryView: Bool = true, handler: @escaping EventHandler) {
		let inputs = superview.descendants.compactMap { $0 as? KeyboardDisplayable }
		
		self.init(containerView: superview, inputs: inputs, inputAccessoryView: inputAccessoryView, handler: handler)
	}
	
	deinit {
		print("~\(type(of: self))")
	}
}






public struct KeyboardEvent {
	public let isOpening: Bool
	public let keyboardFrame: CGRect
	
	public let input: KeyboardControl.KeyboardDisplayableClass!
	/// Negative distance means input is covered by keyboard
	public let distance: CGFloat!
}



private struct KeyboardNotificationData {
	let frame: CGRect
	let curve: UInt
	let duration: TimeInterval
	let belongsToMe: Bool
	var options: UIView.AnimationOptions {
		return UIView.AnimationOptions(rawValue: curve)
	}
	
	init(_ notification: Notification) {
		let userInfo = notification.userInfo!
		frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
		curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
		duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
		belongsToMe = userInfo[UIResponder.keyboardIsLocalUserInfoKey] as! Bool
	}
}


private struct Weak<T: AnyObject> {
	weak var data: T?
}


public protocol KeyboardDisplayable: UIView, UITextInputTraits {
	var inputAccessoryView: UIView? { get set }
	var isFirstResponder: Bool { get }
	var _delegate: NSObjectProtocol? { get set }
}


extension UITextField: KeyboardDisplayable {
	
	public var _delegate: NSObjectProtocol? {
		get { return self.delegate }
		set { self.delegate = newValue as? UITextFieldDelegate }
	}
}

extension UITextView: KeyboardDisplayable {
	
	public var _delegate: NSObjectProtocol? {
		get { return self.delegate }
		set { self.delegate = newValue as? UITextViewDelegate }
	}
}

extension UISearchBar: KeyboardDisplayable {
	
	public var _delegate: NSObjectProtocol? {
		get { return self.delegate }
		set { self.delegate = newValue as? UISearchBarDelegate }
	}
}



extension KeyboardControl: UITextFieldDelegate {
	
	private func delegate(for textField: UITextField) -> UITextFieldDelegate? {
		if let index = self.inputs.firstIndex(where: { textField === $0 }) {
			return self.individualDelegates[index].data as? UITextFieldDelegate
		}
		return nil
	}
	
	
	
	public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		let shouldBeginEditing = delegate(for: textField)?.textFieldShouldBeginEditing?(textField) ?? true
		if shouldBeginEditing {
			self.currentInput = textField
		}
		return shouldBeginEditing
	}
	
	public func textFieldDidBeginEditing(_ textField: UITextField) {
		delegate(for: textField)?.textFieldDidBeginEditing?(textField)
		self.currentInput = textField
	}
	
	public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		return delegate(for: textField)?.textFieldShouldEndEditing?(textField) ?? true
	}
	
	public func textFieldDidEndEditing(_ textField: UITextField) {
		delegate(for: textField)?.textFieldDidEndEditing?(textField)
		if textField === currentInput {
			self.currentInput = nil
		}
	}
	
	@available(iOS 10.0, *)
	public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
		let d = delegate(for: textField)
		if d?.textFieldDidEndEditing?(textField, reason: reason) == nil {
			d?.textFieldDidEndEditing?(textField)
		}
		if textField === currentInput {
			self.currentInput = nil
		}
	}
	
	public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		return delegate(for: textField)?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true
	}
	
	public func textFieldShouldClear(_ textField: UITextField) -> Bool {
		return delegate(for: textField)?.textFieldShouldClear?(textField) ?? true
	}
	
	public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		switch textField.returnKeyType {
			case .next: self.forward()
			default: self.done()
		}
		
		return delegate(for: textField)?.textFieldShouldReturn?(textField) ?? true
	}
}


extension KeyboardControl: UISearchBarDelegate {
	
	private func delegate(for searchBar: UISearchBar) -> UISearchBarDelegate? {
		if let index = self.inputs.firstIndex(where: { searchBar === $0 }) {
			return self.individualDelegates[index].data as? UISearchBarDelegate
		}
		return nil
	}
	
	
	
	public func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
		let shouldBegin = delegate(for: searchBar)?.searchBarShouldBeginEditing?(searchBar) ?? true
		if shouldBegin {
			self.currentInput = searchBar
		}
		return shouldBegin
	}
	
	public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		delegate(for: searchBar)?.searchBarTextDidBeginEditing?(searchBar)
		currentInput = searchBar
	}
	
	public func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
		return delegate(for: searchBar)?.searchBarShouldEndEditing?(searchBar) ?? true
	}
	
	public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		delegate(for: searchBar)?.searchBarTextDidEndEditing?(searchBar)
		if searchBar === currentInput {
			self.currentInput = nil
		}
	}
	
	public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		delegate(for: searchBar)?.searchBar?(searchBar, textDidChange: searchText)
	}
	
	public func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		return delegate(for: searchBar)?.searchBar?(searchBar, shouldChangeTextIn: range, replacementText: text) ?? true
	}
	
	public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		delegate(for: searchBar)?.searchBarSearchButtonClicked?(searchBar)
	}
	
	public func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
		delegate(for: searchBar)?.searchBarBookmarkButtonClicked?(searchBar)
	}
	
	public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		delegate(for: searchBar)?.searchBarCancelButtonClicked?(searchBar)
	}
	
	public func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
		delegate(for: searchBar)?.searchBarResultsListButtonClicked?(searchBar)
	}
	
	public func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
		delegate(for: searchBar)?.searchBar?(searchBar, selectedScopeButtonIndexDidChange: selectedScope)
	}
}


extension KeyboardControl: UITextViewDelegate {
	
	private func delegate(for textView: UITextView) -> UITextViewDelegate? {
		if let index = self.inputs.firstIndex(where: { textView === $0 }) {
			return self.individualDelegates[index].data as? UITextViewDelegate
		}
		return nil
	}
	
	
	
	public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
		let shouldBeginEditing = delegate(for: textView)?.textViewShouldBeginEditing?(textView) ?? true
		if shouldBeginEditing {
			self.currentInput = textView
		}
		return shouldBeginEditing
	}
	
	public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
		return delegate(for: textView)?.textViewShouldEndEditing?(textView) ?? true
	}
	
	public func textViewDidBeginEditing(_ textView: UITextView) {
		delegate(for: textView)?.textViewDidBeginEditing?(textView)
		self.currentInput = textView
	}
	
	public func textViewDidEndEditing(_ textView: UITextView) {
		delegate(for: textView)?.textViewDidEndEditing?(textView)
		if textView === currentInput {
			self.currentInput = nil
		}
	}
	
	public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		return delegate(for: textView)?.textView?(textView, shouldChangeTextIn: range, replacementText: text) ?? true
	}
	
	public func textViewDidChange(_ textView: UITextView) {
		delegate(for: textView)?.textViewDidChange?(textView)
	}
	
	public func textViewDidChangeSelection(_ textView: UITextView) {
		delegate(for: textView)?.textViewDidChangeSelection?(textView)
	}
	
	@available(iOS 10, *)
	public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
		return delegate(for: textView)?.textView?(textView, shouldInteractWith: URL, in: characterRange, interaction: interaction) ?? true
	}
	
	@available(iOS 10, *)
	public func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
		return delegate(for: textView)?.textView?(textView, shouldInteractWith: textAttachment, in: characterRange, interaction: interaction) ?? true
	}
}

