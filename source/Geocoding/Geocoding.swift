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
	
	public static var loggingMode: LoggingMode = .body
	
	public static var baseUrl: String = "https://maps.googleapis.com/maps/api/geocode"
	public static var baseHeaders: [String : String]? = nil
}







public protocol Geocodable: DataRequestable {
}

public extension Geocodable {
	public var url: String {
		return "json"
	}
	
	public var decoder: JSONDecoder {
		return .default
	}
	
	public func makeModel(data: JSONData) -> GeoResponse? {
		return GeoResponse(json: data.dictionary!)
	}
	
	@discardableResult
	public func fetch(success: @escaping (M) -> (), failure: @escaping (String) -> (), finally: Closure? = nil) -> Request {
		return GeocodingAPI.fetch(self, success: success, failure: failure, finally: finally)
	}
}





//TODO: Bounds
public struct Geocode: Geocodable {
	public let body: Dict?
	
	public typealias Bounds = (sW: CLLocationCoordinate2D, nE: CLLocationCoordinate2D)
	
	public init(address: String, bounds: Bounds? = nil, components: [Component: String]? = nil, region: String? = nil) {
		body = [
			"address": address,
			"bounds": (bounds == nil) ? "" : "\(bounds!.sW.description),\(bounds!.nE.description)",
			"components": components?.map { "\($0.key.rawValue):\($0.value)" }.joined(by: "|") ?? "",
			"region": region ?? "",
			"language": GeocodingAPI.language,
			"key": GeocodingAPI.key
		]
	}
	
	public init(components: [Component: String], bounds: Bounds? = nil, region: String? = nil) {
		body = [
			"components": components.map { "\($0.key.rawValue):\($0.value)" }.joined(by: "|"),
			"bounds": (bounds == nil) ? "" : "\(bounds!.sW.description),\(bounds!.nE.description)",
			"region": region ?? "",
			"language": GeocodingAPI.language,
			"key": GeocodingAPI.key
		]
	}
}





public struct ReverseGeocode: Geocodable {
	public let body: Dict?
	
	
	public init(coordinate: CLLocationCoordinate2D, resultTypes: [AddressType]? = nil, locationTypes: [LocationType]? = nil, sensor: Bool? = nil) {
		body = [
			"latlng": "\(coordinate.latitude),\(coordinate.longitude)",
			"result_type": resultTypes?.map { $0.rawValue }.joined(by: "|") ?? "",
			"location_type": locationTypes?.map { $0.rawValue }.joined(by: "|") ?? "",
			"sensor": sensor?.description ?? "",
			"language": GeocodingAPI.language,
			"key": GeocodingAPI.key
		]
	}
	
	public init(placeId: String, language: String? = nil, key: String? = nil) {
		body = [
			"place_id": placeId,
			"language": GeocodingAPI.language,
			"key": GeocodingAPI.key
		]
	}
}





















