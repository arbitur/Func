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
	case strikeThroughStyle(Int)
	case strikeThrough(UIColor)
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
	case writingDirection([NSNumber])
	case verticalGlyphForm(Float)
	
	
	var component: (key: String, value: Any) {
		switch self {
		case .font(let font):					return (NSFontAttributeName, font)
		case .paragraphStyle(let style):		return (NSParagraphStyleAttributeName, style)
		case .foreground(let color):			return (NSForegroundColorAttributeName, color)
		case .background(let color):			return (NSBackgroundColorAttributeName, color)
		case .ligature(let ligature):			return (NSLigatureAttributeName, ligature)
		case .kern(let kern):					return (NSKernAttributeName, kern)
		case .strikeThroughStyle(let style):	return (NSStrikethroughStyleAttributeName, style)
		case .strikeThrough(let color):			return (NSStrikethroughColorAttributeName, color)
		case .underlineStyle(let style):		return (NSUnderlineStyleAttributeName, style.rawValue)
		case .underlineColor(let color):		return (NSUnderlineColorAttributeName, color)
		case .strokeColor(let color):			return (NSStrokeColorAttributeName, color)
		case .strokeWidth(let width):			return (NSStrokeWidthAttributeName, width)
		case .shadow(let shadow):				return (NSShadowAttributeName, shadow)
		case .textEffect(let effect):			return (NSTextEffectAttributeName, effect)
		case .attachment(let attatchment):		return (NSAttachmentAttributeName, attatchment)
		case .link(let link):					return (NSLinkAttributeName, link)
		case .baselineOffset(let offset):		return (NSBaselineOffsetAttributeName, offset)
		case .obliqueness(let obliqueness):		return (NSObliquenessAttributeName, obliqueness)
		case .expansion(let expansion):			return (NSExpansionAttributeName, expansion)
		case .writingDirection(let value):		return (NSWritingDirectionAttributeName, value)
		case .verticalGlyphForm(let form):		return (NSVerticalGlyphFormAttributeName, form)
		}
	}
}





public extension Sequence where Iterator.Element == TextAttributes {
	var attributes: [String: Any] {
		var dict = [String: Any]()
		
		for attr in self {
			let component = attr.component
			dict[component.key] = component.value
		}
		
		return dict
	}
}





protocol TextAttributable: class {
	var text: String? {get set}
	var attributedText: NSAttributedString? {get set}
}

extension TextAttributable {
	func setAttributes(_ attributes: [TextAttributes]) {
		attributedText = NSAttributedString(string: self.text ?? "", attributes: attributes.attributes)
	}
}



extension UILabel: TextAttributable {}
extension UITextField: TextAttributable {}


















