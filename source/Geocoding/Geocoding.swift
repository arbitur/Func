//
//  Geocoding-new.swift
//  Pods
//
//  Created by Philip Fryklund on 22/Aug/17.
//
//

import Alamofire
import CoreLocation





public struct GeocodingAPI: API {
	public static var key: String = ""
	public static var language: String = ""
	
//	public static var loggingMode: LoggingMode = .body
	
	public static let baseUrl: String = "https://maps.googleapis.com/maps/api/geocode"
	public static let baseHeaders: HTTPHeaders? = nil
}







public protocol Geocodable: DataRequestable {
}

public extension Geocodable {
	
	var url: String {
		return "json"
	}
}





//TODO: Bounds
public struct Geocode: Geocodable {
	public typealias Model = GeoResponse
	
	public let parameters: Parameters?
	
	
	public typealias Bounds = (sW: CLLocationCoordinate2D, nE: CLLocationCoordinate2D)
	
	public init(address: String, bounds: Bounds? = nil, components: [Component: String]? = nil, region: String? = nil) {
		parameters = [
			"address": address,
			"bounds": (bounds == nil) ? "" : "\(bounds!.sW.description)|\(bounds!.nE.description)",
			"components": components?.map { "\($0.key.rawValue):\($0.value)" }.joined(by: "|") ?? "",
			"region": region ?? "",
			"language": GeocodingAPI.language,
			"key": GeocodingAPI.key
		]
	}
	
	public init(components: [Component: String], bounds: Bounds? = nil, region: String? = nil) {
		parameters = [
			"components": components.map { "\($0.key.rawValue):\($0.value)" }.joined(by: "|"),
			"bounds": (bounds == nil) ? "" : "\(bounds!.sW.description)|\(bounds!.nE.description)",
			"region": region ?? "",
			"language": GeocodingAPI.language,
			"key": GeocodingAPI.key
		]
	}
}





public struct ReverseGeocode: Geocodable {
	public typealias Model = GeoResponse
	
	public let parameters: Parameters?
	
	
	public init(coordinate: CLLocationCoordinate2D, resultTypes: [AddressType]? = nil, locationTypes: [LocationType]? = nil, sensor: Bool? = nil) {
		parameters = [
			"latlng": "\(coordinate.latitude),\(coordinate.longitude)",
			"result_type": resultTypes?.map { $0.rawValue }.joined(by: "|") ?? "",
			"location_type": locationTypes?.map { $0.rawValue }.joined(by: "|") ?? "",
			"sensor": sensor?.description ?? "",
			"language": GeocodingAPI.language,
			"key": GeocodingAPI.key
		]
	}
	
	public init(placeId: String, language: String? = nil, key: String? = nil) {
		parameters = [
			"place_id": placeId,
			"language": GeocodingAPI.language,
			"key": GeocodingAPI.key
		]
	}
}





















