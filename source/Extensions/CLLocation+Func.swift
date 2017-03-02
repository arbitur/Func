//
//  CLLocation+Func.swift
//  Pods
//
//  Created by Philip Fryklund on 17/Feb/17.
//
//

import CoreLocation





public extension CLLocation {
	convenience init(coordinate: CLLocationCoordinate2D) {
		self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
	}
}




extension CLLocationCoordinate2D: CustomStringConvertible, Equatable {
	public var description: String {
		return "\(self.latitude),\(self.longitude)"
	}
	
	
	
	func coordinateFrom(distance: Double, angle bearing: Double) -> CLLocationCoordinate2D {
		let radius = 6371e3
		let δ = distance / radius // angular distance in radians
		let φ1 = self.latitude.rad
		let λ1 = self.longitude.rad
		let θ = bearing.rad
		
		let Δφ = δ * cos(θ)
		
		var φ2 = φ1 + Δφ
		
		// check for some daft bugger going past the pole, normalise latitude if so
		if (abs(φ2) > M_PI_2) { φ2 = φ2>0 ? M_PI-φ2 : -M_PI-φ2 }
		
		let Δψ = log(tan(φ2/2+M_PI_4)/tan(φ1/2+M_PI_4))
		let q = abs(Δψ) > 10e-12 ? Δφ / Δψ : cos(φ1) // E-W course becomes ill-conditioned with 0/0
		
		let Δλ = δ*sin(θ)/q
		
		var λ2 = λ1 + Δλ
		
		
		λ2 = remainder((λ2 + 3*M_PI), (2*M_PI)) - M_PI; // normalise to -180..+180°
		
		return CLLocationCoordinate2D(latitude: φ2.deg, longitude: λ2.deg)
	}
}





public func == (coord1: CLLocationCoordinate2D, coord2: CLLocationCoordinate2D) -> Bool {
	//	print(coord1.latitude, coord2.latitude, coord1.longitude, coord2.longitude)
	//	print(coord1.latitude == coord2.latitude, coord1.longitude == coord2.longitude)
	return coord1.latitude.description == coord2.latitude.description && coord1.longitude.description == coord2.longitude.description
}


























