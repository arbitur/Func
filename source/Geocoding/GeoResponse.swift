//
//  GeoResponse.swift
//  Pods
//
//  Created by Philip Fryklund on 27/Apr/17.
//
//

import Foundation
import Gloss
import CoreLocation





public struct GeoResponse: Decodable {
	public let results: [Result]
	public let status: Geocoding.Status
	public init?(json: JSON) {
		results = ("results" <~~ json)!
		status = ("status" <~~ json)!
	}
	
	
	/// Get Result
	public subscript(_ type: Geocoding.AddressType) -> [Result]? {
		return results.filter({ $0.types.contains(type) })
	}
	
	
	public struct Result: Decodable {
		public let addressComponents: [AddressComponent]
		public let formattedAddress: String
		public let geometry: Geometry
		public let types: [Geocoding.AddressType]
		public let placeId: String
		public init?(json: JSON) {
			addressComponents = ("address_components" <~~ json)!
			formattedAddress = ("formatted_address" <~~ json)!
			geometry = ("geometry" <~~ json)!
			types = ("types" <~~ json) ?? []
			placeId = ("place_id" <~~ json)!
		}
		
		
		/// Get AddressComponents
		public subscript(_ type: Geocoding.AddressType) -> [AddressComponent]? {
			return addressComponents.filter({ $0.types.contains(type) })
		}
		
		
		public struct AddressComponent: Decodable {
			public let longName: String
			public let shortName: String
			public let types: [Geocoding.AddressType]
			public init?(json: JSON) {
				longName = ("long_name" <~~ json)!
				shortName = ("short_name" <~~ json)!
				types = ("types" <~~ json)!
			}
		}
		
		public struct Geometry: Decodable {
			public let location: Coordinate
			public let locationType: Geocoding.Location
			public let viewport: Viewport
			public init?(json: JSON) {
				location = ("location" <~~ json)!
				locationType = ("location_type" <~~ json)!
				viewport = ("viewport" <~~ json)!
			}
			
			
			public struct Coordinate: Decodable {
				public let lat: Double
				public let long: Double
				public let coordinate: CLLocationCoordinate2D
				public init?(json: JSON) {
					lat = ("lat" <~~ json)!
					long = ("lng" <~~ json)!
					coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
				}
			}
			
			public struct Viewport: Decodable {
				public let southWest: Coordinate
				public let northEast: Coordinate
				public init?(json: JSON) {
					southWest = ("southwest" <~~ json)!
					northEast = ("northeast" <~~ json)!
				}
			}
		}
	}
}



















