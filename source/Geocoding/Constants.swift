//
//  Constants.swift
//  Pods
//
//  Created by Philip Fryklund on 22/Aug/17.
//
//

import Foundation





//public enum GeoError: Error {
//	case zero(String)
//	case overLimit(String)
//	case denied(String)
//	case invalid(String)
//	case unknown(String)
//}



public enum Status: String {
	case ok				= "OK"
	case zeroResults	= "ZERO_RESULTS"
	case overQueryLimit	= "OVER_QUERY_LIMIT"
	case requestDenied	= "REQUEST_DENIED"
	case invalidRequest	= "INVALID_REQUEST"
	case unknownError	= "UNKNOWN_ERROR"
}



public enum AddressType: String {
	case streetAddress		= "street_address"				// a precise street address.
	case route				= "route"						// a named route (such as "US 101").
	case intersection		= "intersection"				// a major intersection, usually of two major roads.
	case political			= "political"					// a political entity. Usually, this type indicates a polygon of some civil administration.
	case country			= "country"						// the national political entity, and is typically the highest order type returned by the Geocoder.
	case administrative1	= "administrative_area_level_1"	// a first-order civil entity below the country level. Within the United States, these administrative levels are states. Not all nations exhibit these administrative levels.
	case administrative2	= "administrative_area_level_2" // a second-order civil entity below the country level. Within the United States, these administrative levels are counties. Not all nations exhibit these administrative levels.
	case administrative3	= "administrative_area_level_3" // a third-order civil entity below the country level. This type indicates a minor civil division. Not all nations exhibit these administrative levels.
	case administrative4	= "administrative_area_level_4" // a fourth-order civil entity below the country level. This type indicates a minor civil division. Not all nations exhibit these administrative levels.
	case administrative5	= "administrative_area_level_5" // a fifth-order civil entity below the country level. This type indicates a minor civil division. Not all nations exhibit these administrative levels.
	case colloquialArea		= "colloquial_area"				// a commonly-used alternative name for the entity.
	case locality			= "locality"					// an incorporated city or town political entity.
	case ward				= "ward"						// a specific type of Japanese locality, to facilitate distinction between multiple locality components within a Japanese address.
	case subLocality		= "sublocality"					// a first-order civil entity below a locality. For some locations may receive one of the additional types: sublocality_level_1 to sublocality_level_5. Each sublocality level is a civil entity. Larger numbers indicate a smaller geographic area.
	case subLocality1		= "sublocality_level_1"
	case subLocality2		= "sublocality_level_2"
	case subLocality3		= "sublocality_level_3"
	case subLocality4		= "sublocality_level_4"
	case subLocality5		= "sublocality_level_5"
	case neighborhood		= "neighborhood"				// a named neighborhood
	case premise			= "premise"						// a named location, usually a building or collection of buildings with a common name
	case subpremise			= "subpremise"					// a first-order entity below a named location, usually a singular building within a collection of buildings with a common name
	case postalCode			= "postal_code"					// a postal code as used to address postal mail within the country.
	case naturalFeature		= "natural_feature"				// a prominent natural feature.
	case airport			= "airport"						// an airport.
	case park				= "park"						// a named park.
	case pointOfInterest	= "point_of_interest"			// a named point of interest. Typically, these "POI"s are prominent local entities that don't easily fit in another category, such as "Empire State Building" or "Statue of Liberty."
	
	//NOTE: This list is not exhaustive, and is subject to change.
	case floor				= "floor"						// indicates the floor of a building address.
	case establishment		= "establishment"				// typically indicates a place that has not yet been categorized.
	case parking			= "parking"						// indicates a parking lot or parking structure.
	case postBox			= "post_box"					// indicates a specific postal box.
	case postalTown			= "postal_town"					// indicates a grouping of geographic areas, such as locality and sublocality, used for mailing addresses in some countries
	case room				= "room"						// indicates the room of a building address.
	case streetNumber		= "street_number"				// indicates the precise street number.
	case busStation			= "bus_station"					// indicate the location of a bus stop
	case traintStation		= "train_station"				// indicate the location of a train stop
	case transitStation		= "transit_station"				// indicate the location of a public transit stop
}



public enum LocationType: String {
	case roofTop			= "ROOFTOP"				// addresses for which we have location information accurate down to street address precision.
	case rangeInterpolated	= "RANGE_INTERPOLATED"	// those that reflect an approximation (usually on a road) interpolated between two precise points (such as intersections). An interpolated range generally indicates that rooftop geocodes are unavailable for a street address.
	case geometricCenter	= "GEOMETRIC_CENTER"	// geometric centers of a location such as a polyline (for example, a street) or polygon (region).
	case approximate		= "APPROXIMATE"			// those that are characterized as approximate.
}



public enum Component: String {
	case route			= "route"				// matches long or short name of a route.
	case locality		= "locality"			// matches against both locality and sublocality types.
	case administrative = "administrative_area"	// matches all the administrative_area levels.
	case postalCode		= "postal_code"			// matches postal_code and postal_code_prefix.
	case country		= "country"				// matches a country name or a two letter ISO 3166-1 country code.
}
