//
//  UIImage+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 16/Feb/17.
//
//

import UIKit
import Accelerate





public extension UIImage {
	
	var base64: String {
		let data = UIImagePNGRepresentation(self)!
		return data.base64EncodedString(options: .lineLength64Characters)
	}
	
	convenience init?(base64: String) {
		guard let data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
		else {
			return nil
		}
		self.init(data: data)
	}
	
	func jpgData(quality: CGFloat) -> Data? {
		return UIImageJPEGRepresentation(self, quality)
	}
	
	func pngData() -> Data? {
		return UIImagePNGRepresentation(self)
	}
	
	
	
	enum ScalingMode {
		case aspectFill
		case aspectFit
		
		func aspectRatio(between size: CGSize, and otherSize: CGSize) -> CGFloat {
			let aspectWidth  = size.width / otherSize.width
			let aspectHeight = size.height / otherSize.height
			
			switch self {
				case .aspectFill: return max(aspectWidth, aspectHeight)
				case .aspectFit	: return min(aspectWidth, aspectHeight)
			}
		}
	}
	
	func scaled(by scale: CGFloat) -> UIImage! {
		return resized(to: CGSize(width: self.size.width * scale, height: self.size.height * scale))
	}
	
	func resized(to newSize: CGSize, scalingMode: UIImage.ScalingMode) -> UIImage {
		let aspectRatio = scalingMode.aspectRatio(between: newSize, and: self.size)
		
		var scaledImageRect = CGRect.zero
		
		scaledImageRect.size.width  = self.size.width * aspectRatio
		scaledImageRect.size.height = self.size.height * aspectRatio
		scaledImageRect.origin.x    = (newSize.width - scaledImageRect.size.width) / 2.0
		scaledImageRect.origin.y    = (newSize.height - scaledImageRect.size.height) / 2.0
		
		UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
		defer {
			UIGraphicsEndImageContext()
		}
		
		self.draw(in: scaledImageRect)
		return UIGraphicsGetImageFromCurrentImageContext()!
	}
	
	func resized(to size: CGSize) -> UIImage! {
		UIGraphicsBeginImageContextWithOptions(size, false, 0)
		defer { UIGraphicsEndImageContext() }
		self.draw(in: CGRect(origin: CGPoint.zero, size: size))
		return UIGraphicsGetImageFromCurrentImageContext()
	}
	
	
	
	func tinted(with tintColor: UIColor) -> UIImage! {
		UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
		defer { UIGraphicsEndImageContext() }
		
		let ctx = UIGraphicsGetCurrentContext()!
		
		ctx.translateBy(x: 0, y: self.size.height)
		ctx.scaleBy(x: 1.0, y: -1.0)
		ctx.setBlendMode(CGBlendMode.normal) //Color, Hue
		
		let rect = CGRect(origin: .zero, size: self.size)
		ctx.clip(to: rect, mask: self.cgImage!)
		tintColor.setFill()
		ctx.fill(rect)
		
		return UIGraphicsGetImageFromCurrentImageContext()
	}
	
	func alpha(_ alpha: CGFloat) -> UIImage! {
		UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
		defer { UIGraphicsEndImageContext() }
		
		let ctx = UIGraphicsGetCurrentContext()!
		let area = CGRect(origin: CGPoint.zero, size: self.size)
		
		ctx.translateBy(x: 0, y: area.size.height)
		ctx.scaleBy(x: 1.0, y: -1.0)
		ctx.setBlendMode(CGBlendMode.normal)
		ctx.setAlpha(alpha)
		ctx.draw(self.cgImage!, in: area)
		
		return UIGraphicsGetImageFromCurrentImageContext()
	}
	
	
	
	var averageColor: UIColor {
		let rgba = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		let info = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
		let context = CGContext(data: rgba, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: info.rawValue)!
		
		context.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: 1, height: 1))
		
		if rgba[3] > 0 {
			let alpha: CGFloat = CGFloat(rgba[3]) / 255.0
			let multiplier: CGFloat = alpha / 255.0
			
			return UIColor(red: CGFloat(rgba[0]) * multiplier, green: CGFloat(rgba[1]) * multiplier, blue: CGFloat(rgba[2]) * multiplier, alpha: alpha)
		}
		else {
			return UIColor(red: CGFloat(rgba[0])/255.0, green: CGFloat(rgba[1])/255.0, blue: CGFloat(rgba[2])/255.0, alpha: CGFloat(rgba[3])/255.0)
		}
	}
	
	
	
	
	func blurred(radius: CGFloat, tintColor: UIColor? = nil, saturation: CGFloat = 1.0, maskImage: UIImage? = nil) -> UIImage! {
		if self.size.width < 1 || self.size.height < 1 {
			return nil
		}
		
		guard let cgImage = self.cgImage else {
			return nil
		}
		
		if let mask = maskImage, mask.cgImage == nil {
			return nil
		}
		
		let hasBlur = radius > .ulpOfOne
		let hasSaturation = fabs(saturation - 1.0) > .ulpOfOne
		
		let bitmapInfo = cgImage.bitmapInfo
		let alphaInfo = CGImageAlphaInfo(rawValue: bitmapInfo.rawValue & CGBitmapInfo.alphaInfoMask.rawValue)
		
		let scale = self.scale
		let outputSize = self.size
		let outputRect = CGRect(size: outputSize)
		
		
		let opaqueContext = (alphaInfo == .none || alphaInfo == .noneSkipLast || alphaInfo == .noneSkipFirst)
		
		UIGraphicsBeginImageContextWithOptions(outputRect.size, opaqueContext, scale)
		defer { UIGraphicsEndImageContext() }
		
		guard let ctx = UIGraphicsGetCurrentContext() else {
			return nil
		}
		
		ctx.scaleBy(x: 1.0, y: -1.0)
		ctx.translateBy(x: 0, y: -outputRect.height)
		
		
		if hasBlur || hasSaturation {
			var effectInBuffer = vImage_Buffer()
			var scratchBuffer1 = vImage_Buffer()
			
			var inputBuffer: UnsafeMutablePointer<vImage_Buffer>
			var outputBuffer: UnsafeMutablePointer<vImage_Buffer>
			
			var format = vImage_CGImageFormat(
				bitsPerComponent: 8,
				bitsPerPixel: 32,
				colorSpace: nil,
				bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue),
				version: 0,
				decode: nil,
				renderingIntent: .defaultIntent)
			
			let error = vImageBuffer_InitWithCGImage(&effectInBuffer, &format, nil, cgImage, UInt32(kvImagePrintDiagnosticsToConsole))
			if error != kvImageNoError {
				return nil
			}
			
			vImageBuffer_Init(&scratchBuffer1, effectInBuffer.height, effectInBuffer.width, format.bitsPerPixel, UInt32(kvImageNoFlags))
			inputBuffer = UnsafeMutablePointer(&effectInBuffer)
			outputBuffer = UnsafeMutablePointer(&scratchBuffer1)
			
			
			if hasBlur {
				var inputRadius = radius * scale
				if inputRadius - 2.0 < .ulpOfOne {
					inputRadius = 2.0
				}
				
				let _a = (inputRadius * 3.0 * sqrt(2.0 * .pi) / 4.0 + 0.5)
				var realRadius = UInt32(floor(_a / 2))
				realRadius |= 1
				
				let _b = kvImageGetTempBufferSize | kvImageEdgeExtend
				let tempBufferSize = vImageBoxConvolve_ARGB8888(inputBuffer, outputBuffer, nil, 0, 0, realRadius, realRadius, nil, UInt32(_b))
				let tempBuffer = malloc(tempBufferSize)
				
				vImageBoxConvolve_ARGB8888(inputBuffer, outputBuffer, tempBuffer, 0, 0, realRadius, realRadius, nil, UInt32(kvImageEdgeExtend))
				vImageBoxConvolve_ARGB8888(outputBuffer, inputBuffer, tempBuffer, 0, 0, realRadius, realRadius, nil, UInt32(kvImageEdgeExtend))
				vImageBoxConvolve_ARGB8888(inputBuffer, outputBuffer, tempBuffer, 0, 0, realRadius, realRadius, nil, UInt32(kvImageEdgeExtend))
				
				free(tempBuffer)
				
				let _temp = inputBuffer
				inputBuffer = outputBuffer
				outputBuffer = _temp
			}
			
			if hasSaturation {
				let s = saturation
				let floatingPointSaturationMatrix: [CGFloat] = [
					0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
					0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
					0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
					0,                    0,                    0,                    1
				]
				
				let divisor: Int32 = 256
				let matrixSize = floatingPointSaturationMatrix.count
				var saturationMatrix = Array(repeating: Int16(), count: matrixSize)
				for i in 0..<matrixSize {
					saturationMatrix[i] = Int16(round(floatingPointSaturationMatrix[i] * CGFloat(divisor)))
				}
				vImageMatrixMultiply_ARGB8888(inputBuffer, outputBuffer, saturationMatrix, divisor, nil, nil, UInt32(kvImageNoFlags))
				
				let _temp = inputBuffer
				inputBuffer = outputBuffer
				outputBuffer = _temp
			}
			
			var effectCGImage = vImageCreateCGImageFromBuffer(inputBuffer, &format, { userData, bufData in free(bufData) }, nil, UInt32(kvImageNoAllocate), nil)
			if effectCGImage == nil {
				effectCGImage = vImageCreateCGImageFromBuffer(inputBuffer, &format, nil, nil, UInt32(kvImageNoFlags), nil)
				free(inputBuffer.pointee.data)
			}
			
			if maskImage != nil {
				ctx.draw(cgImage, in: outputRect)
			}
			
			ctx.saveGState()
			
			if let maskImage = maskImage?.cgImage {
				ctx.clip(to: outputRect, mask: maskImage)
			}
			ctx.draw(effectCGImage!.takeRetainedValue(), in: outputRect)
			ctx.restoreGState()
			
			free(outputBuffer.pointee.data)
		}
		else {
			ctx.draw(cgImage, in: outputRect)
		}
		
		if let tintColor = tintColor {
			ctx.saveGState()
			ctx.setFillColor(tintColor.cgColor)
			ctx.fill(outputRect)
			ctx.restoreGState()
		}
		
		return UIGraphicsGetImageFromCurrentImageContext()
	}
	
	
	
	public func applyBlur(radius blurRadius: CGFloat, tintColor: UIColor?, saturationDeltaFactor: CGFloat, maskImage: UIImage? = nil) -> UIImage? {
		func preconditionsValid() -> Bool {
			if size.width < 1 || size.height < 1 {
				print("error: invalid image size: (\(size.width, size.height). Both width and height must >= 1)")
				return false
			}
			if cgImage == nil {
				print("error: image must be backed by a CGImage")
				return false
			}
			if let maskImage = maskImage {
				if maskImage.cgImage == nil {
					print("error: effectMaskImage must be backed by a CGImage")
					return false
				}
			}
			return true
		}
		
		guard preconditionsValid() else {
			return nil
		}
		
		let hasBlur = blurRadius > .ulpOfOne
		let hasSaturationChange = fabs(saturationDeltaFactor - 1) > .ulpOfOne
		
		let inputCGImage = cgImage!
		let inputImageScale = scale
		let inputImageBitmapInfo = inputCGImage.bitmapInfo
		let inputImageAlphaInfo = CGImageAlphaInfo(rawValue: inputImageBitmapInfo.rawValue & CGBitmapInfo.alphaInfoMask.rawValue)
		
		let outputImageSizeInPoints = size
		let outputImageRectInPoints = CGRect(origin: CGPoint.zero, size: outputImageSizeInPoints)
		
		let useOpaqueContext = inputImageAlphaInfo == .none || inputImageAlphaInfo == .noneSkipLast || inputImageAlphaInfo == .noneSkipFirst
		UIGraphicsBeginImageContextWithOptions(outputImageRectInPoints.size, useOpaqueContext, inputImageScale)
		let outputContext = UIGraphicsGetCurrentContext()
		outputContext?.scaleBy(x: 1, y: -1)
		outputContext?.translateBy(x: 0, y: -outputImageRectInPoints.height)
		
		if hasBlur || hasSaturationChange {
			var effectInBuffer = vImage_Buffer()
			var scratchBuffer1 = vImage_Buffer()
			var inputBuffer: UnsafeMutablePointer<vImage_Buffer>
			var outputBuffer: UnsafeMutablePointer<vImage_Buffer>
			
			let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
			var format = vImage_CGImageFormat(bitsPerComponent: 8,
			                                  bitsPerPixel: 32,
			                                  colorSpace: nil,
			                                  bitmapInfo: bitmapInfo,
			                                  version: 0,
			                                  decode: nil,
			                                  renderingIntent: .defaultIntent)
			
			let error = vImageBuffer_InitWithCGImage(&effectInBuffer, &format, nil, inputCGImage, vImage_Flags(kvImagePrintDiagnosticsToConsole))
			if error != kvImageNoError {
				print("error: vImageBuffer_InitWithCGImage returned error code \(error)")
				UIGraphicsEndImageContext()
				return nil
			}
			
			vImageBuffer_Init(&scratchBuffer1, effectInBuffer.height, effectInBuffer.width, format.bitsPerPixel, vImage_Flags(kvImageNoFlags))
			inputBuffer = withUnsafeMutablePointer(to: &effectInBuffer, { (address) -> UnsafeMutablePointer<vImage_Buffer> in
				return address
			})
			outputBuffer = withUnsafeMutablePointer(to: &scratchBuffer1, { (address) -> UnsafeMutablePointer<vImage_Buffer> in
				return address
			})
			
			if hasBlur {
				var inputRadius = blurRadius * inputImageScale
				if inputRadius - 2 < .ulpOfOne {
					inputRadius = 2
				}
				let _a = (inputRadius * CGFloat(3) * CGFloat(sqrt(2 * .pi)) / 4 + 0.5)
				var radius = UInt32(floor(_a / 2))
				radius |= 1
				
				let flags = vImage_Flags(kvImageGetTempBufferSize) | vImage_Flags(kvImageEdgeExtend)
				let tempBufferSize: Int = vImageBoxConvolve_ARGB8888(inputBuffer, outputBuffer, nil, 0, 0, radius, radius, nil, flags)
				let tempBuffer = malloc(tempBufferSize)
				
				vImageBoxConvolve_ARGB8888(inputBuffer, outputBuffer, tempBuffer, 0, 0, radius, radius, nil, vImage_Flags(kvImageEdgeExtend))
				vImageBoxConvolve_ARGB8888(outputBuffer, inputBuffer, tempBuffer, 0, 0, radius, radius, nil, vImage_Flags(kvImageEdgeExtend))
				vImageBoxConvolve_ARGB8888(inputBuffer, outputBuffer, tempBuffer, 0, 0, radius, radius, nil, vImage_Flags(kvImageEdgeExtend))
				
				free(tempBuffer)
				
				let temp = inputBuffer
				inputBuffer = outputBuffer
				outputBuffer = temp
			}
			
			if hasSaturationChange {
				let s = saturationDeltaFactor
				let floatingPointSaturationMatrix: [CGFloat] = [
					0.0722 + 0.9278 * s, 0.0722 - 0.0722 * s, 0.0722 - 0.0722 * s, 0,
					0.7152 - 0.7152 * s, 0.7152 + 0.2848 * s, 0.7152 - 0.7152 * s, 0,
					0.2126 - 0.2126 * s, 0.2126 - 0.2126 * s, 0.2126 + 0.7873 * s, 0,
					0,					 0,					  0,				   1,
				]
				
				let divisor: Int32 = 256
				let matrixSize = floatingPointSaturationMatrix.count
				var saturationMatrix = Array(repeating: Int16(), count: matrixSize)
				for i in 0..<matrixSize {
					saturationMatrix[i] = Int16(round(floatingPointSaturationMatrix[i] * CGFloat(divisor)))
				}
				vImageMatrixMultiply_ARGB8888(inputBuffer, outputBuffer, saturationMatrix, divisor, nil, nil, vImage_Flags(kvImageNoFlags))
				
				let temp = inputBuffer
				inputBuffer = outputBuffer
				outputBuffer = temp
			}
			
			let cleanupBuffer: @convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?) -> Void = {(userData, buf_data) -> Void in
				free(buf_data)
			}
			var effectCGImage = vImageCreateCGImageFromBuffer(inputBuffer, &format, cleanupBuffer, nil, vImage_Flags(kvImageNoAllocate), nil)
			if effectCGImage == nil {
				effectCGImage = vImageCreateCGImageFromBuffer(inputBuffer, &format, nil, nil, vImage_Flags(kvImageNoFlags), nil)
				free(inputBuffer.pointee.data)
			}
			if let _ = maskImage {
				outputContext?.draw(inputCGImage, in: outputImageRectInPoints)
			}
			
			outputContext?.saveGState()
			if let maskImage = maskImage {
				outputContext?.clip(to: outputImageRectInPoints, mask: maskImage.cgImage!)
			}
			outputContext?.draw(effectCGImage!.takeRetainedValue(), in: outputImageRectInPoints)
			outputContext?.restoreGState()
			
			free(outputBuffer.pointee.data)
		} else {
			outputContext?.draw(inputCGImage, in: outputImageRectInPoints)
		}
		
		if let tintColor = tintColor {
			outputContext?.saveGState()
			outputContext?.setFillColor(tintColor.cgColor)
			outputContext?.fill(outputImageRectInPoints)
			outputContext?.restoreGState()
		}
		
		let outputImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return outputImage
	}
	


	convenience init(color: UIColor) {
		let rect = CGRect(origin: .zero, size: .zero + 1)
		UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
		defer { UIGraphicsEndImageContext() }
		color.setFill()
		UIRectFill(rect)
		let img = UIGraphicsGetImageFromCurrentImageContext()!
		self.init(cgImage: img.cgImage!)
	}
}























