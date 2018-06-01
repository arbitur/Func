//
//  KeyboardControl.swift
//  Test
//
//  Created by Philip Fryklund on 8/Dec/16.
//  Copyright © 2016 Philip Fryklund. All rights reserved.
//

import UIKit





public class KeyboardControl: NSObject {
	public typealias EventHandler = (_ event: KeyboardEvent)->()
	
	private var toolbar: UIToolbar?
	private var leftArrow: UIBarButtonItem?
	private var rightArrow: UIBarButtonItem?
	
	private let inputs: [KeyboardDisplayable]
	private var individualDelegates = [Weak<NSObjectProtocol>]()
	
	private let handler: EventHandler
	
	private weak var currentInput: KeyboardDisplayable? {
		didSet {
			updateToolbar()
		}
	}
	private var selectedIndex: Int? {
		return inputs.index {
			$0 === currentInput
		}
	}
	
	
	
	
	private func handleNotification(_ notification: Notification, isOpening: Bool) {
		let data = KeyboardNotificationData(notification)
		
		if isOpening {
			UIView.performWithoutAnimation {
				toolbar?.frame.widt = data.frame.width
			}
		}
		
		UIView.animate(withDuration: data.duration, delay: 0, options: data.options,
			animations: {
				if let input = self.currentInput {
					let projectedBottom = input.superview!.convert(input.frame, to: nil).bottom + 16
					let top = data.frame.top
					let distance = top - projectedBottom
					
					self.handler(KeyboardEvent(isOpening: isOpening, keyboardFrame: data.frame, input: input, distance: distance))
				}
				else {
					self.handler(KeyboardEvent(isOpening: isOpening, keyboardFrame: data.frame, input: nil, distance: nil)) 
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
		
	}
	
	@objc private func keyboardDidHide(_ notification: Notification) {
	}
	
	
	
	@objc private func back() {
		let index = max(0, selectedIndex! - 1)
		let input = inputs[safe: index]
		currentInput?.resignFirstResponder()
		input?.becomeFirstResponder()
	}
	
	@objc private func forward() {
		let index = min(inputs.count - 1, selectedIndex! + 1)
		let input = inputs[safe: index]
		currentInput?.resignFirstResponder()
		input?.becomeFirstResponder()
	}
	
	@objc private func done() {
		let input = inputs[selectedIndex!]
		input.resignFirstResponder()
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
		
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidShow, object: nil)
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidHide, object: nil)
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
	}
	
	public func activate() {
		print("KeyboardControl activated")
		
		NotificationCenter.default.removeObserver(self)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: .UIKeyboardDidShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: .UIKeyboardDidHide, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
	}
	
	
	
	/// Remember, `handler` with `self` WILL cause retain-cycle, add [unowned/weak self] in closure
	public init(inputs: [KeyboardDisplayable], inputAccessoryView: Bool = true, arrows: Bool = true, handler: @escaping EventHandler) {
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
			toolbar!.frame.heigt = 44
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
		
		self.init(inputs: inputs, inputAccessoryView: inputAccessoryView, handler: handler)
	}
	
	deinit {
		print("~\(type(of: self))")
	}
}






public struct KeyboardEvent {
	public let isOpening: Bool
	public let keyboardFrame: CGRect
	
	public let input: KeyboardDisplayable!
	public let distance: CGFloat!
}



private struct KeyboardNotificationData {
	let frame: CGRect
	let curve: UInt
	let duration: TimeInterval
	let belongsToMe: Bool
	var options: UIViewAnimationOptions {
		return UIViewAnimationOptions(rawValue: curve)
	}
	
	init(_ notification: Notification) {
		let userInfo = notification.userInfo!
		frame = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
		curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! UInt
		duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
		belongsToMe = userInfo[UIKeyboardIsLocalUserInfoKey] as! Bool
	}
}





public protocol KeyboardDisplayable: class, UITextInputTraits {
	var superview: UIView? {get}
	var inputAccessoryView: UIView? {get set}
	var frame: CGRect {get set}
	var isFirstResponder: Bool {get}
	var _delegate: NSObjectProtocol? {get set}
	
	@discardableResult
	func becomeFirstResponder() -> Bool
	@discardableResult
	func resignFirstResponder() -> Bool
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





private struct Weak<T: AnyObject> {
	weak var data: T?
}












extension KeyboardControl: UITextFieldDelegate {
	
	private func delegate(for textField: UITextField) -> UITextFieldDelegate? {
		if let index = self.inputs.index(where: { textField === $0 }) {
			return self.individualDelegates[index].data as? UITextFieldDelegate
		}
		return nil
	}
	
	
	
	public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		let shouldBegin = delegate(for: textField)?.textFieldShouldBeginEditing?(textField) ?? true
		if shouldBegin {
			self.currentInput = textField
		}
		return shouldBegin
	}
	
	public func textFieldDidBeginEditing(_ textField: UITextField) {
		delegate(for: textField)?.textFieldDidBeginEditing?(textField)
	}
	
	public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		return delegate(for: textField)?.textFieldShouldEndEditing?(textField) ?? true
	}
	
	public func textFieldDidEndEditing(_ textField: UITextField) {
		delegate(for: textField)?.textFieldDidEndEditing?(textField)
	}
	
	@available(iOS 10.0, *)
	public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
//		if currentInput === textField {
//			self.currentInput = nil
//		}
		let d = delegate(for: textField)
		if d?.textFieldDidEndEditing?(textField) == nil {
			d?.textFieldDidEndEditing?(textField, reason: reason)
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
		if let index = self.inputs.index(where: { searchBar === $0 }) {
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
	}
	
	public func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
		return delegate(for: searchBar)?.searchBarShouldEndEditing?(searchBar) ?? true
	}
	
	public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		delegate(for: searchBar)?.searchBarTextDidEndEditing?(searchBar)
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
		if let index = self.inputs.index(where: { textView === $0 }) {
			return self.individualDelegates[index].data as? UITextViewDelegate
		}
		return nil
	}
	
	
	
	public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
		let shouldBegin = delegate(for: textView)?.textViewShouldBeginEditing?(textView) ?? true
		if shouldBegin {
			self.currentInput = textView
		}
		return shouldBegin
	}
	
	public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
		return delegate(for: textView)?.textViewShouldEndEditing?(textView) ?? true
	}
	
	public func textViewDidBeginEditing(_ textView: UITextView) {
		delegate(for: textView)?.textViewDidBeginEditing?(textView)
	}
	
	public func textViewDidEndEditing(_ textView: UITextView) {
		delegate(for: textView)?.textViewDidEndEditing?(textView)
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

