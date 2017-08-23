//
//  GeoResponse.swift
//  Pods
//
//  Created by Philip Fryklund on 27/Apr/17.
//
//

import CoreLocation





public struct GeoResponse: Decodable, CustomStringConvertible {
	public let results: [Result]
	public let status: Status
	
	public var description: String {
		return "GeoResponse(results: [\(results.count)], status: \(status.rawValue))"
	}

	
	public init?(json: Dict) {
		do {
			results = try json.decode("results")
			status = try json.decode("status")
		}
		catch {
			return nil
		}
	}
	
	
	
	/// Filter results by type
	public subscript(_ type: AddressType) -> [Result]? {
		return results.filter { type ?== $0.types }
	}
	
	
	
	public struct Result: Decodable {
		public let addressComponents: [AddressComponent]
		public let formattedAddress: String
		public let geometry: Geometry
		public let types: [AddressType]
		public let placeId: String

		
		public init?(json: Dict) {
			do {
				addressComponents = try json.decode("address_components")
				formattedAddress = try json.decode("formatted_address")
				geometry = try json.decode("geometry")
				placeId = try json.decode("place_id")
				types = try json.decode("types")
			}
			catch {
				return nil
			}
		}
		
		
		
		/// Filter AddressComponents by type
		public subscript(_ type: AddressType) -> [AddressComponent]? {
			return addressComponents.filter { type ?== $0.types }
		}
		
		
		
		public struct AddressComponent: Decodable {
			public let longName: String
			public let shortName: String
			public let types: [AddressType]
			
			
			public init?(json: Dict) {
				do {
					longName = try json.decode("long_name")
					shortName = try json.decode("short_name")
					types = try json.decode("types")
				}
				catch {
					return nil
				}
			}
		}
		
		public struct Geometry: Decodable {
			public let location: Coordinate
			public let locationType: LocationType
			public let viewport: Viewport
			
			
			public init?(json: Dict) {
				do {
					location = try json.decode("location")
					locationType = try json.decode("location_type")
					viewport = try json.decode("viewport")
				}
				catch {
					return nil
				}
			}
			
			
			public struct Coordinate: Decodable {
				public let lat: Double
				public let long: Double
				public let coordinate: CLLocationCoordinate2D
				
				
				public init?(json: Dict) {
					do {
						lat = try json.decode("lat")
						long = try json.decode("lng")
						coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
					}
					catch {
						return nil
					}
				}
			}
			
			public struct Viewport: Decodable {
				public let southWest: Coordinate
				public let northEast: Coordinate
				
				
				public init?(json: Dict) {
					do {
						southWest = try json.decode("southwest")
						northEast = try json.decode("northeast")
					}
					catch {
						return nil
					}
				}
			}
		}
	}
}



















