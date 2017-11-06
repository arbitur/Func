//
//  TextAttributes.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import Foundation





public enum TextAttributes {
	case font(UIFont)
	case paragraphStyle(NSParagraphStyle)
	case foreground(UIColor)
	case background(UIColor)
	case ligature(Int)
	case kern(Float)
	case strikethroughStyle(NSUnderlineStyle)
	case strikethrough(UIColor)
	case underlineStyle(NSUnderlineStyle)
	case underlineColor(UIColor)
	case strokeColor(UIColor)
	case strokeWidth(Float)
	case shadow(NSShadow)
	case textEffect(String)
	case attachment(NSTextAttachment)
	case link(URL)
	case baselineOffset(Float)
	case obliqueness(Float)
	case expansion(Float)
	case writingDirection([Int])
	case verticalGlyphForm(Int)
	
	
	var component: (key: NSAttributedStringKey, value: Any) {
		switch self {
			case .font(let font)				: return (.font, font)
			case .paragraphStyle(let style)		: return (.paragraphStyle, style)
			case .foreground(let color)			: return (.foregroundColor, color)
			case .background(let color)			: return (.backgroundColor, color)
			case .ligature(let ligature)		: return (.ligature, ligature)
			case .kern(let kern)				: return (.kern, kern)
			case .strikethroughStyle(let style)	: return (.strikethroughStyle, style.rawValue)
			case .strikethrough(let color)		: return (.strikethroughColor, color)
			case .underlineStyle(let style)		: return (.underlineStyle, style.rawValue)
			case .underlineColor(let color)		: return (.underlineColor, color)
			case .strokeColor(let color)		: return (.strokeColor, color)
			case .strokeWidth(let width)		: return (.strokeWidth, width)
			case .shadow(let shadow)			: return (.shadow, shadow)
			case .textEffect(let effect)		: return (.textEffect, effect)
			case .attachment(let attatchment)	: return (.attachment, attatchment)
			case .link(let link)				: return (.link, link)
			case .baselineOffset(let offset)	: return (.baselineOffset, offset)
			case .obliqueness(let obliqueness)	: return (.obliqueness, obliqueness)
			case .expansion(let expansion)		: return (.expansion, expansion)
			case .writingDirection(let value)	: return (.writingDirection, value)
			case .verticalGlyphForm(let form)	: return (.verticalGlyphForm, form)
		}
	}
}






public extension Sequence where Iterator.Element == TextAttributes {
	
	var attributedDictionary: [NSAttributedStringKey: Any] {
		var dict = [NSAttributedStringKey: Any]()
		
		for attr in self {
			let component = attr.component
			dict[component.key] = component.value
		}

		return dict
	}
}





public protocol TextAttributable: class {
	var text: String? {get set}
	var attributedText: NSAttributedString? {get set}
}


public extension TextAttributable {
	
	var textAttributes: [TextAttributes] {
		get { return [] }
		set {
			self.attributedText = NSAttributedString(string: self.text ?? "", attributes: newValue.attributedDictionary)
		}
	}
	
	// Add attributes to substring
	func addAttributes(_ attributes: [TextAttributes], to part: String) {
		if let attr = self.attributedText, let text = self.text, let range = text.range(of: part) {
			let mattr = NSMutableAttributedString(attributedString: attr)

			let start = text.distance(from: text.startIndex, to: range.lowerBound)
			let length = text.distance(from: text.startIndex, to: range.upperBound) - start
			let range = NSMakeRange(start, length)

			mattr.addAttributes(attributes.attributedDictionary, range: range)

			self.attributedText = mattr
		}
	}
}


extension UILabel: TextAttributable {}
extension UITextField: TextAttributable {}


















