//
//  CLLocation+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import CoreLocation.CLLocation





public extension CLLocation {
	
	convenience init(coordinate: CLLocationCoordinate2D) {
		self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
	}
}




public extension CLLocationCoordinate2D {
	
	init(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees) {
		self.init(latitude: latitude, longitude: longitude)
	}
	
	
	func coordinateFrom(distance: Double, bearing: Double) -> CLLocationCoordinate2D {
//		let radius = 6371e3
//		let δ = distance / radius // angular distance in radians
//		let φ1 = self.latitude.rad
//		let λ1 = self.longitude.rad
//		let θ = bearing.rad
//
//		let Δφ = δ * cos(θ)
//
//		var φ2 = φ1 + Δφ
//
//		// check for some daft bugger going past the pole, normalise latitude if so
//		if (abs(φ2) > .pi/2) { φ2 = φ2>0 ? .pi-φ2 : -.pi-φ2 }
//
//		let Δψ = log(tan(φ2/2 + .pi/4)/tan(φ1/2 + .pi/4))
//		let q = abs(Δψ) > 10e-12 ? Δφ / Δψ : cos(φ1) // E-W course becomes ill-conditioned with 0/0
//
//		let Δλ = δ*sin(θ)/q
//
//		var λ2 = λ1 + Δλ
//
//		λ2 = (λ2 + 3 * .pi).remainder(dividingBy: 2 * .pi) - .pi; // normalise to -180..+180°
//
//		return CLLocationCoordinate2D(latitude: φ2.deg, longitude: λ2.deg)
		
		let rEarth = 6371.01
		let epsilon = 0.000001
		
		let rlat1 = self.latitude.rad
		let rlon1 = self.longitude.rad
		let rbearing = bearing.rad
		let rdistance = distance / rEarth // normalize linear distance to radian angle
		
		let rlat = asin( sin(rlat1) * cos(rdistance) + cos(rlat1) * sin(rdistance) * cos(rbearing) )
		
		let rlon: Double
		if cos(rlat) == 0 || abs(cos(rlat)) < epsilon { // Endpoint a pole
			rlon = rlon1
		}
		else {
			rlon = ( (rlon1 - asin( sin(rbearing) * sin(rdistance) / cos(rlat) ) + .pi ) % (2 * .pi) ) - .pi
		}
		
		return CLLocationCoordinate2D(rlat.deg, rlon.deg)
	}
}




extension CLLocationCoordinate2D: CustomStringConvertible {
	
	public var description: String {
		return "\(self.latitude),\(self.longitude)"
	}
}


extension CLLocationCoordinate2D: Equatable {
	
	public static func == (coord1: CLLocationCoordinate2D, coord2: CLLocationCoordinate2D) -> Bool {
		return coord1.description == coord2.description
	}
}
































