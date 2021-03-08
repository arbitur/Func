//
//  Geocoding-new.swift
//  Pods
//
//  Created by Philip Fryklund on 22/Aug/17.
//
//

import Foundation
import CoreLocation



public typealias GeocodingBounds = (sw: CLLocationCoordinate2D, ne: CLLocationCoordinate2D)


public class GeocodingApiClient: ApiClient {
	
//	public static private(set) var shared: GeocodingApiClient?
	
//	public static func initialize(withKey key: String, language: String) {
//		shared = .init(withKey: key, language: language)
//	}
	
	public let baseUrl: String = "https://maps.googleapis.com/maps/api/geocode"
	public var interceptors: [(RequestBuilder) -> Void] = []
	public var logger: HttpLogger = BaseHttpLogger(level: .medium)
	
	internal let key: String
	internal let language: String
	
	
	public init(withKey key: String, language: String) {
		self.key = key
		self.language = language
	}
}


public extension GeocodingApiClient {
	
	func geocode(address: String? = nil, components: [Component: String]? = nil, bounds: GeocodingBounds? = nil, region: String? = nil) -> Request<GeocodingResponse> {
		return self.request(decoder: DecodableDecoder(decoder: GeocodingResponse.init)) {
			$0.method = .get
			$0.url = "json"
			$0.bodyEncoder = URLBodyEncoder(parameters: [
				"address": address ?? "",
				"bounds": bounds.map { "\($0.sw.description)|\($0.ne.description)" } ?? "",
				"components": components?.map { "\($0.key.rawValue):\($0.value)" }.joined(by: "|") ?? "",
				"region": region ?? "",
				"language": language,
				"key": key
			])
		}
	}
	
	
	func reverseGeocode(coordinate: CLLocationCoordinate2D, resultTypes: [AddressType]? = nil, locationTypes: [LocationType]? = nil, sensor: Bool? = nil) -> Request<GeocodingResponse> {
		return self.request(decoder: DecodableDecoder(decoder: GeocodingResponse.init)) {
			$0.method = .get
			$0.url = "json"
			$0.bodyEncoder = URLBodyEncoder(parameters: [
				"latlng": "\(coordinate.latitude),\(coordinate.longitude)",
				"result_type": resultTypes?.map { $0.rawValue }.joined(by: "|") ?? "",
				"location_type": locationTypes?.map { $0.rawValue }.joined(by: "|") ?? "",
				"sensor": sensor?.description ?? "",
				"language": language,
				"key": key
			])
		}
	}
	
	func reverseGeocode(placeId: String) -> Request<GeocodingResponse> {
		return self.request(decoder: DecodableDecoder(decoder: GeocodingResponse.init)) {
			$0.method = .get
			$0.url = "json"
			$0.bodyEncoder = URLBodyEncoder(parameters: [
				"place_id": placeId,
				"language": language,
				"key": key
			])
		}
	}
}
