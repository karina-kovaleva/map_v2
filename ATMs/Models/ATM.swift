//
//  ATM.swift
//  ATMs
//
//  Created by Karina Kovaleva on 27.12.22.
//

import Foundation

struct SectionViewModel: Hashable {
    let city: String
    var infoForModel: [CellModel]
}

struct InfoForModel: Hashable {
    var atms: [ATM]
    var infoboxes: [Infobox]
    var filials: [Filials]
}

//struct InfoForCell: Hashable {
//    var atms: CellModel?
//    var infoboxes: InfoBoxCellModel?
//    var filials: FilialsCellModel?
//}

struct CellModel: Hashable {
    var type: String?
    var city: String?
    var id: String?
    var idInfoBox: Int?
    var installPlace: String?
    var workTime: String?
    var currency: String?
    var filialName: String?
    var nameType, name: String?
    var streetType, street, homeNumber: String?
    var phoneInfo: String?
    var gpsX, gpsY: String?
    var distance: Double?
    var infoWorktime: String?

    init(type: String, city: String, id: String, installPlace: String,
         workTime: String, currency: String, gpsX: String, gpsY: String) {
        self.type = type
        self.city = city
        self.id = id
        self.installPlace = installPlace
        self.workTime = workTime
        self.currency = currency
        self.gpsX = gpsX
        self.gpsY = gpsY
    }

    init(type: String, city: String, idInfobox: Int, installPlace: String,
         workTime: String, currency: String, gpsX: String, gpsY: String) {
        self.type = type
        self.city = city
        self.idInfoBox = idInfobox
        self.installPlace = installPlace
        self.workTime = workTime
        self.currency = currency
        self.gpsX = gpsX
        self.gpsY = gpsY
    }

    init(type: String, filialName: String, nameType: String, name: String,
         streetType: String, street: String, homeNumber: String, phoneInfo: String,
         gpsX: String, gpsY: String, infoWorktime: String) {
        self.type = type
        self.filialName = filialName
        self.nameType = nameType
        self.name = name
        self.streetType = streetType
        self.street = street
        self.homeNumber = homeNumber
        self.phoneInfo = phoneInfo
        self.gpsX = gpsX
        self.gpsY = gpsY
        self.infoWorktime = infoWorktime
    }
}

struct InfoBoxCellModel: Hashable {
    let city: String
    let id: Int
    let installPlace: String
    let workTime: String
    let currency: String
}

struct FilialsCellModel: Hashable {
    let filialName: String
    let nameType, name: String
    let streetType, street, homeNumber: String
    let phoneInfo: String
}

struct ATM: Codable, Hashable {
    let id: String
    let area: String
    let cityType: String
    let city: String
    let addressType: String
    let address, house, installPlace, workTime: String
    let gpsX, gpsY: String
    let installPlaceFull, workTimeFull: String
    let atmType: String
    let atmError: String
    let currency: String
    let cashIn, atmPrinter: String

    enum CodingKeys: String, CodingKey {
        case id, area
        case cityType = "city_type"
        case city
        case addressType = "address_type"
        case address, house
        case installPlace = "install_place"
        case workTime = "work_time"
        case gpsX = "gps_x"
        case gpsY = "gps_y"
        case installPlaceFull = "install_place_full"
        case workTimeFull = "work_time_full"
        case atmType = "ATM_type"
        case atmError = "ATM_error"
        case currency
        case cashIn = "cash_in"
        case atmPrinter = "ATM_printer"
    }
}
