//
//  Annotation.swift
//  ATMs
//
//  Created by Karina Kovaleva on 6.01.23.
//

import MapKit

final class Annotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let installPlace: String
    let workTime: String
    let currency: String
    let cashIn: String
    let id: String

    init(attraction: ATM) {
        coordinate = Annotation.createCoordinate(attraction.gpsX, attraction.gpsY)
        self.installPlace = attraction.installPlace
        self.workTime = attraction.workTime
        self.currency = attraction.currency
        self.cashIn = attraction.cashIn
        self.id = attraction.id
    }

    static func createCoordinate(_ gpsX: String, _ gpsY: String) -> CLLocationCoordinate2D {
        guard let latitude = CLLocationDegrees(gpsX),
              let longitude = CLLocationDegrees(gpsY) else { return CLLocationCoordinate2D() }
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return coordinate
    }
}
