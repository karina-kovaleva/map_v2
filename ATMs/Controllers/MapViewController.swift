//
//  MapViewController.swift
//  ATMs
//
//  Created by Karina Kovaleva on 27.12.22.
//

import UIKit
import MapKit

final class MapViewController: UIViewController {

//    private let network = NetworkAPI()
//    private var atms: [ATM] = []

    private lazy var viewModel = {
        ViewModel()
    }()

    private lazy var mapView: MKMapView = {
        var mapView = MKMapView()
        return mapView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
//        let mainVC = self.navigationController?.viewControllers.first as? MainViewController
//        mainVC?.delegate = self
        checkAuthorizationStatus()
        setupMapView()
//        getAtmsList()
    }

    private func initViewModel() {
//        // Get employees data
//        viewModel.getAtms()
//        // Reload TableView closure
//        viewModel.reloadCollectionView = { [weak self] in
//            DispatchQueue.main.async {
//                self?.mapView.reloadInputViews()
//            }
//        }
    }

    private func setupMapView() {
        mapView.delegate = self
        self.view.addSubview(self.mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func checkAuthorizationStatus() {
        LocationManager.shared.checkAuthorizationStatus()
        if LocationManager.shared.isAllowed == .denied ||
            LocationManager.shared.isAllowed == .restricted {
            let alert = UIAlertController(title: "Карты не знают, где вы находитесь",
                                          message: """
                                                   Разрешите им определять Ваше местоположение:
                                                   это делается в настройках устройства.
                                                   """,
                                          preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Отменить", style: .cancel)
            alert.addAction(cancel)
            if let settings = URL(string: UIApplication.openSettingsURLString),
               UIApplication.shared.canOpenURL(settings) {
                alert.addAction(UIAlertAction(title: "Настройки", style: .default) { _ in
                    UIApplication.shared.open(settings)
                })
            }
            self.present(alert, animated: true)
        }
    }

    private func centerTheMap() {
        LocationManager.shared.getUserLocation { [weak self] location in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                        longitude: location.coordinate.longitude)
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let coordinateRegion = MKCoordinateRegion(center: coordinate, span: span)
                strongSelf.mapView.setRegion(coordinateRegion, animated: true)
            }
        }
    }

//    private func getAtmsList() {
//        guard let mainVC = self.navigationController?.viewControllers.first as? MainViewController else { return }
//        let navItem = mainVC.navigationItem.rightBarButtonItem
//        if NetworkMonitor.shared.isConnected {
//            navItem?.isEnabled = false
//            network.getATMsList { atms in
//                self.atms = atms
//                self.fetchATMsOnMap(atms)
//                self.centerTheMap()
//                DispatchQueue.main.async {
//                    navItem?.isEnabled = true
//                }
//            }
//        } else {
//            let alert = UIAlertController(title: "Нет соединения с сетью",
//                                          message: "Для работы приложения необходимо соединение с интернетом",
//                                          preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Понятно", style: .cancel))
//            self.present(alert, animated: true)
//        }
//    }

    private func fetchATMsOnMap(_ atms: [ATM]) {
        DispatchQueue.main.async {
            let annotations = atms.map { Annotation(attraction: $0) }
            self.mapView.addAnnotations(annotations)
            self.mapView.showAnnotations(annotations, animated: true)
        }
    }

    public func selectAnnotation(_ id: String) {
        guard var annotations = mapView.annotations as? [Annotation] else { return }
        annotations = annotations.filter { $0.id == id }
        guard let annotation = annotations.first else { return }
        mapView.selectAnnotation(annotation, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
        annotationView.markerTintColor = UIColor.systemGreen
        annotationView.glyphText = "$"
        if let annotation = annotation as? Annotation {
            annotationView.canShowCallout = true
            let calloutView = CalloutView(annotation: annotation)
            calloutView.delegate = self
            annotationView.detailCalloutAccessoryView = calloutView
        }
        return annotationView
    }
}

extension MapViewController: CalloutViewDelegate {
    func openDetailViewController(_ id: String) {
//        guard let atm = atms.first(where: {$0.id == id}) else { return }
//        let viewController = DetailViewController(atm: atm)
//        navigationController?.pushViewController(viewController, animated: true)
    }
}

//extension MapViewController: MainViewControllerDelegate {
//    func updateAtms() {
//        getAtmsList()
//    }
//}
