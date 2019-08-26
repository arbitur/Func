//
//  NSAttributedString+Func.swift
//  Func
//
//  Created by Philip Fryklund on 8/Dec/17.
//

import Foundation





public extension NSAttributedString {
	
	convenience init?(html: String) {
		guard
			let data = html.data(using: .utf16, allowLossyConversion: false),
			let string = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
		else {
			return nil
		}
		
		self.init(attributedString: string)
	}
}





public extension NSAttributedString {
	
	typealias Attributes = [NSAttributedString.Key: Any]
	
	class AttributesBuilder {
		
		public var font: UIFont?
		public var foregroundColor: UIColor? // UIColor, default blackColor
		public var backgroundColor: UIColor? // UIColor, default nil: no background
		public var ligature: Bool? // NSNumber containing integer, default 1: default ligatures, 0: no ligatures
		public var kern: Float? // NSNumber containing floating point value, in points; amount to modify default kerning. 0 means kerning is disabled.
		public var strikethroughStyle: Int? // NSNumber containing integer, default 0: no strikethrough
		public var underlineStyle: Int? // NSNumber containing integer, default 0: no underline
		public var strokeColor: UIColor? // UIColor, default nil: same as foreground color
		public var strokeWidth: Float? // NSNumber containing floating point value, in percent of font point size, default 0: no stroke; positive for stroke alone, negative for stroke and fill (a typical value for outlined text would be 3.0)
		public var shadow: NSShadow? // NSShadow, default nil: no shadow
		public var textEffect: String? // NSString, default nil: no text effect
		
		public var attachment: NSTextAttachment? // NSTextAttachment, default nil
		public var link: URL? // NSURL (preferred) or NSString
		public var baselineOffset: Float? // NSNumber containing floating point value, in points; offset from baseline, default 0
		public var underlineColor: UIColor? // UIColor, default nil: same as foreground color
		public var strikethroughColor: UIColor? // UIColor, default nil: same as foreground color
		public var obliqueness: Float? // NSNumber containing floating point value; skew to be applied to glyphs, default 0: no skew
		public var expansion: Float? // NSNumber containing floating point value; log of expansion factor to be applied to glyphs, default 0: no expansion
		public var writingDirection: [Int]? // NSArray of NSNumbers representing the nested levels of writing direction overrides as defined by Unicode LRE, RLE, LRO, and RLO characters.  The control characters can be obtained by masking NSWritingDirection and NSWritingDirectionFormatType values.  LRE: NSWritingDirectionLeftToRight|NSWritingDirectionEmbedding, RLE: NSWritingDirectionRightToLeft|NSWritingDirectionEmbedding, LRO: NSWritingDirectionLeftToRight|NSWritingDirectionOverride, RLO: NSWritingDirectionRightToLeft|NSWritingDirectionOverride,
		public var verticalGlyphForm: Bool? // An NSNumber containing an integer value.  0 means horizontal text.  1 indicates vertical text.  If not specified, it could follow higher-level vertical orientation settings.  Currently on iOS, it's always horizontal.  The behavior for any other value is undefined.
		
		
		public var attributes: Attributes {
			var attributes = Attributes()
			font.map { attributes[.font] = $0 }
			foregroundColor.map { attributes[.foregroundColor] = $0 }
			backgroundColor.map { attributes[.backgroundColor] = $0 }
			ligature.map { attributes[.ligature] = NSNumber(value: $0) }
			kern.map { attributes[.kern] = NSNumber(value: $0) }
			strikethroughStyle.map { attributes[.strikethroughStyle] = NSNumber(value: $0) }
			underlineStyle.map { attributes[.underlineStyle] = NSNumber(value: $0) }
			strokeColor.map { attributes[.strokeColor] = $0 }
			strokeWidth.map { attributes[.strokeWidth] = $0 }
			shadow.map { attributes[.shadow] = $0 }
			textEffect.map { attributes[.textEffect] = NSString(string: $0) }
			
			attachment.map { attributes[.attachment] = $0 }
			link.map { attributes[.link] = $0 as NSURL }
			baselineOffset.map { attributes[.baselineOffset] = NSNumber(value: $0) }
			underlineColor.map { attributes[.underlineColor] = $0 }
			strikethroughColor.map { attributes[.strikethroughColor] = $0 }
			obliqueness.map { attributes[.obliqueness] = NSNumber(value: $0) }
			expansion.map { attributes[.expansion] = NSNumber(value: $0) }
			writingDirection.map { attributes[.writingDirection] = NSArray(array: $0.map(NSNumber.init)) }
			verticalGlyphForm.map { attributes[.verticalGlyphForm] = NSNumber(value: $0) }
			return attributes
		}
	}
	
	
	
	class Builder: AttributesBuilder {
		
		public var paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
		
		public override var attributes: Attributes {
			var attributes = super.attributes
			attributes[.paragraphStyle] = paragraphStyle
			return attributes
		}
		
		public var string: String = ""
		private var attributedStrings = [(string: String, attributes: Attributes)]()
		
		
		
		public func append(_ string: String, closure: (AttributesBuilder) -> () = {_ in}) {
			let attributesBuilder = AttributesBuilder()
			closure(attributesBuilder)
			attributedStrings.append((string, attributesBuilder.attributes))
		}
		
		
		internal func build() -> NSAttributedString {
			let completeString = string + attributedStrings.map({ $0.string }).joined()
			
			guard completeString.isNotEmpty else {
				fatalError("Builder should not build an empty string")
			}
			
			let mutableAttributedString = NSMutableAttributedString(string: completeString, attributes: attributes)
			
			for attributedString in attributedStrings {
				let range = completeString.range(of: attributedString.string)!
				let nsRange = NSRange.init(range, in: completeString)
				mutableAttributedString.addAttributes(attributedString.attributes, range: nsRange)
			}
			
			return mutableAttributedString
		}
	}
	
	
	static func build(with closure: (Builder) -> ()) -> NSAttributedString {
		let builder = Builder()
		closure(builder)
		return builder.build()
	}
	
	
	func modifiedAttributes(for string: String, closure: (AttributesBuilder) -> ()) -> NSAttributedString {
		let builder = AttributesBuilder()
		closure(builder)
		let range = self.string.range(of: string)!
		let nsRange = NSRange.init(range, in: self.string)
		let mutableString = self.mutableCopy() as! NSMutableAttributedString
		mutableString.addAttributes(builder.attributes, range: nsRange)
		return mutableString
	}
}


public extension NSParagraphStyle {
	
	class Builder {
		
		public var lineSpacing: CGFloat?
		public var paragraphSpacing: CGFloat?
		public var alignment: NSTextAlignment?
		public var firstLineHeadIndent: CGFloat?
		public var headIndent: CGFloat?
		public var tailIndent: CGFloat?
		public var lineBreakMode: NSLineBreakMode?
		public var minimumLineHeight: CGFloat?
		public var maximumLineHeight: CGFloat?
		public var baseWritingDirection: NSWritingDirection?
		public var lineHeightMultiple: CGFloat?
		public var paragraphSpacingBefore: CGFloat?
		public var hyphenationFactor: Float?
		public var tabStops: [NSTextTab]?
		public var defaultTabInterval: CGFloat?
		public var allowsDefaultTighteningForTruncation: Bool?
		
		//		open var isConfigured: Bool {
		//			return lineSpacing != nil || alignment != nil
		//		}
		
		internal func build() -> NSParagraphStyle {
			let p = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
			lineSpacing.map { p.lineSpacing = $0 }
			paragraphSpacing.map { p.paragraphSpacing = $0 }
			alignment.map { p.alignment = $0 }
			firstLineHeadIndent.map { p.firstLineHeadIndent = $0 }
			headIndent.map { p.headIndent = $0 }
			tailIndent.map { p.tailIndent = $0 }
			lineBreakMode.map { p.lineBreakMode = $0 }
			minimumLineHeight.map { p.minimumLineHeight = $0 }
			maximumLineHeight.map { p.maximumLineHeight = $0 }
			baseWritingDirection.map { p.baseWritingDirection = $0 }
			lineHeightMultiple.map { p.lineHeightMultiple = $0 }
			paragraphSpacingBefore.map { p.paragraphSpacingBefore = $0 }
			hyphenationFactor.map { p.hyphenationFactor = $0 }
			tabStops.map { p.tabStops = $0 }
			defaultTabInterval.map { p.defaultTabInterval = $0 }
			allowsDefaultTighteningForTruncation.map { p.allowsDefaultTighteningForTruncation = $0 }
			return p
		}
	}
}
