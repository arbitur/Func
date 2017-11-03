//
//  TextAttributes.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import Foundation





@available(*, deprecated: 4.0)
public enum TextAttributes {
	case font(UIFont)
	case paragraphStyle(NSParagraphStyle)
	case foreground(UIColor)
	case background(UIColor)
//	case ligature(Int)
//	case kern(Float)
//	case strikeThroughStyle(Int)
//	case strikeThrough(UIColor)
//	case underlineStyle(NSUnderlineStyle)
//	case underlineColor(UIColor)
//	case strokeColor(UIColor)
//	case strokeWidth(Float)
//	case shadow(NSShadow)
//	case textEffect(String)
//	case attachment(NSTextAttachment)
//	case link(URL)
//	case baselineOffset(Float)
//	case obliqueness(Float)
//	case expansion(Float)
//	case writingDirection([NSNumber])
//	case verticalGlyphForm(Float)
	
	
	var component: (key: NSAttributedStringKey, value: Any) {
		switch self {
			case .font(let font)				: return (.font, font)
			case .paragraphStyle(let style)		: return (.paragraphStyle, style)
			case .foreground(let color)			: return (.foregroundColor, color)
			case .background(let color)			: return (.backgroundColor, color)
//			case .ligature(let ligature)		: return (NSLigatureAttributeName, ligature)
//			case .kern(let kern)				: return (NSKernAttributeName, kern)
//			case .strikeThroughStyle(let style)	: return (NSStrikethroughStyleAttributeName, style)
//			case .strikeThrough(let color)		: return (NSStrikethroughColorAttributeName, color)
//			case .underlineStyle(let style)		: return (NSUnderlineStyleAttributeName, style.rawValue)
//			case .underlineColor(let color)		: return (NSUnderlineColorAttributeName, color)
//			case .strokeColor(let color)		: return (NSStrokeColorAttributeName, color)
//			case .strokeWidth(let width)		: return (NSStrokeWidthAttributeName, width)
//			case .shadow(let shadow)			: return (NSShadowAttributeName, shadow)
//			case .textEffect(let effect)		: return (NSTextEffectAttributeName, effect)
//			case .attachment(let attatchment)	: return (NSAttachmentAttributeName, attatchment)
//			case .link(let link)				: return (NSLinkAttributeName, link)
//			case .baselineOffset(let offset)	: return (NSBaselineOffsetAttributeName, offset)
//			case .obliqueness(let obliqueness)	: return (NSObliquenessAttributeName, obliqueness)
//			case .expansion(let expansion)		: return (NSExpansionAttributeName, expansion)
//			case .writingDirection(let value)	: return (NSWritingDirectionAttributeName, value)
//			case .verticalGlyphForm(let form)	: return (NSVerticalGlyphFormAttributeName, form)
		}
	}
}






@available(*, deprecated: 4.0)
public extension Sequence where Iterator.Element == TextAttributes {
	
	var dictionary: [NSAttributedStringKey: Any] {
		var dict = [NSAttributedStringKey: Any]()
		
		for attr in self {
			let component = attr.component
			dict[component.key] = component.value
		}
		
		return dict
	}
}





@available(*, deprecated: 4.0)
public protocol TextAttributable: class {
	var text: String? {get set}
	var attributedText: NSAttributedString? {get set}
}

@available(*, deprecated: 4.0)
public extension TextAttributable {
	func setAttributes(_ attributes: [TextAttributes]) {
		attributedText = NSAttributedString(string: self.text ?? "", attributes: attributes.dictionary)
	}
	
	// Add attributes to substring
	func addAttributes(_ attributes: [TextAttributes], to part: String) {
		if let attr = self.attributedText, let text = self.text, let range = text.range(of: part) {
			let mattr = NSMutableAttributedString(attributedString: attr)
			
			let start = text.distance(from: text.startIndex, to: range.lowerBound)
			let length = text.distance(from: text.startIndex, to: range.upperBound) - start
			let range = NSMakeRange(start, length)
			
			mattr.addAttributes(attributes.dictionary, range: range)
			
			self.attributedText = mattr
		}
	}
}


@available(*, deprecated: 4.0)
extension UILabel: TextAttributable {}
@available(*, deprecated: 4.0)
extension UITextField: TextAttributable {}


















