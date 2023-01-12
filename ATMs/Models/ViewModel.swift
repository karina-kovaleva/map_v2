//
//  AtmViewModel.swift
//  ATMs
//
//  Created by Karina Kovaleva on 9.01.23.
//

import Foundation
import MapKit

class ViewModel: NSObject {

    private let group = DispatchGroup()

    private var service: NetworkAPIProtocol

    public var reloadCollectionView: (() -> Void)?

    private var atms = [ATM]()
    private var infoboxes = [Infobox]()
    private var filials = [Filials]()

    private var infoForCellModel: InfoForModel?

    public var sectionViewModels = [SectionViewModel]() {
        didSet {
            reloadCollectionView?()
        }
    }

    public init(service: NetworkAPIProtocol = NetworkAPI()) {
        self.service = service
    }

    public func getInfoFromApi() {
        if NetworkMonitor.shared.isConnected {
            self.group.enter()
            service.getAtmsList { success, model, error in
                if success, let atms = model {
                    self.atms = atms
                } else {
                    print(error!)
                }
                self.group.leave()
            }
            self.group.enter()
            service.getInfoboxList { success, model, error in
                if success, let infoboxes = model {
                    self.infoboxes = infoboxes
                } else {
                    print(error!)
                }
                self.group.leave()
            }
            self.group.enter()
            service.getFilialsList { success, model, error in
                if success, let filials = model {
                    self.filials = filials
                } else {
                    print(error!)
                }
                self.group.leave()
            }
            group.notify(queue: DispatchQueue.main) {
                self.infoForCellModel = InfoForModel(atms: self.atms,
                                                     infoboxes: self.infoboxes,
                                                     filials: self.filials)
                self.fetchData(infoForModel: self.infoForCellModel!)
            }
        }
    }

    private func fetchData(infoForModel: InfoForModel) {
        let atms = Dictionary(grouping: infoForModel.atms, by: {$0.city})
        let infoboxes = Dictionary(grouping: infoForModel.infoboxes, by: {$0.city})
        let filials = Dictionary(grouping: infoForModel.filials, by: {$0.name})
        let atmsKeys = Array(atms.keys)
        let infoboxesKeys = Array(infoboxes.keys)
        let filialKeys = Array(infoboxes.keys)
        let allKeys = Set(atmsKeys + infoboxesKeys + filialKeys)
        var sectionViewModels = [SectionViewModel]()
        for key in allKeys {
            var section = SectionViewModel(city: key, infoForModel: [CellModel]())
            if let atms = atms[key] {
                let atmsCellModel = atms.map { CellModel(type: "ATM",
                                                         city: $0.city,
                                                         id: $0.id,
                                                         installPlace: $0.installPlace,
                                                         workTime: $0.workTime,
                                                         currency: $0.currency,
                                                         gpsX: $0.gpsX,
                                                         gpsY: $0.gpsY) }
                section.infoForModel.append(contentsOf: atmsCellModel)
            }
            if let infoboxes = infoboxes[key] {
                let infoboxesCellModel = infoboxes.map { CellModel(type: "Infobox",
                                                                   city: $0.city,
                                                                   idInfobox: $0.id,
                                                                   installPlace: $0.installPlace,
                                                                   workTime: $0.workTime,
                                                                   currency: $0.currency,
                                                                   gpsX: $0.gpsX,
                                                                   gpsY: $0.gpsY) }
                section.infoForModel.append(contentsOf: infoboxesCellModel)
            }
            if let filials = filials[key] {
                let filialsCellModel = filials.map { CellModel(type: "Filial",
                                                               filialName: $0.filialName,
                                                               nameType: $0.nameType,
                                                               name: $0.name,
                                                               streetType: $0.streetType,
                                                               street: $0.street,
                                                               homeNumber: $0.homeNumber,
                                                               phoneInfo: $0.phoneInfo,
                                                               gpsX: $0.gpsX,
                                                               gpsY: $0.gpsY,
                                                               infoWorktime: $0.infoWorktime)}
                section.infoForModel.append(contentsOf: filialsCellModel)
            }
            for (index, item) in section.infoForModel.enumerated() {
                guard let latitude = CLLocationDegrees(item.gpsX!),
                      let longitude = CLLocationDegrees(item.gpsY!) else { return }
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                section.infoForModel[index].distance = LocationManager.shared.distanceTo(coordinate: coordinate)

            }
            section.infoForModel.sort(by: { $0.distance! < $1.distance! })
            sectionViewModels.append(section)
        }
        self.sectionViewModels = sectionViewModels
    }

    public func getCellViewModel(at indexPath: IndexPath) -> CellModel {
        return sectionViewModels[indexPath.section].infoForModel[indexPath.row]
    }
}
