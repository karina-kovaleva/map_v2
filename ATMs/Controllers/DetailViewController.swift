//
//  DetailViewController.swift
//  ATMs
//
//  Created by Karina Kovaleva on 6.01.23.
//

import UIKit

final class DetailViewController: UIViewController {

    private var atm: ATM

    private lazy var scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        return scrollView
    }()

    private lazy var mainStackView: UIStackView = {
        var mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillProportionally
        mainStackView.alignment = .leading
        mainStackView.spacing = 5
        [self.addressLabel,
         self.installPlaceLabel,
         self.installPlaceFullLabel,
         self.workTimeLabel,
         self.atmTypeLabel,
         self.atmErrorLabel,
         self.currencyLabel,
         self.cashInLabel,
         self.atmPrinterLabel].forEach { mainStackView.addArrangedSubview($0) }
        return mainStackView
    }()

    private lazy var addressLabel: UILabel = {
        var addressLabel = UILabel()
        addressLabel.numberOfLines = 0
        addressLabel.lineBreakMode = .byWordWrapping
        addressLabel.text = createFullAddress(atm: atm)
        return addressLabel
    }()

    private lazy var installPlaceLabel: UILabel = {
        var installPlaceLabel = UILabel()
        installPlaceLabel.numberOfLines = 0
        installPlaceLabel.lineBreakMode = .byWordWrapping
        var installPlace = atm.installPlace
        installPlace.isEmpty ? (installPlace = "информация отсутствует") : nil
        installPlaceLabel.text = "Место установки: " + installPlace
        return installPlaceLabel
    }()

    private lazy var installPlaceFullLabel: UILabel = {
        var installPlaceFullLabel = UILabel()
        installPlaceFullLabel.numberOfLines = 0
        installPlaceFullLabel.lineBreakMode = .byWordWrapping
        var installPlaceFull = atm.installPlaceFull
        installPlaceFull.isEmpty ? (installPlaceFull = "пояснение отсутствует") : nil
        installPlaceFullLabel.text = "Пояснение места установки банкомата: " + installPlaceFull
        return installPlaceFullLabel
    }()

    private lazy var workTimeLabel: UILabel = {
        var workTimeLabel = UILabel()
        workTimeLabel.numberOfLines = 0
        workTimeLabel.lineBreakMode = .byWordWrapping
        var workTime = atm.workTime
        workTime.isEmpty ? (workTime = "информация отсутствует") : nil
        workTimeLabel.text = "Режим работы: " + workTime
        return workTimeLabel
    }()

    private lazy var atmTypeLabel: UILabel = {
        var atmTypeLabel = UILabel()
        atmTypeLabel.numberOfLines = 0
        atmTypeLabel.lineBreakMode = .byWordWrapping
        var atmType = atm.atmType
        atmType.isEmpty ? (atmType = "информация отсутствует") : nil
        atmTypeLabel.text = "Тип банкомата: " + atmType
        return atmTypeLabel
    }()

    private lazy var atmErrorLabel: UILabel = {
        var atmErrorLabel = UILabel()
        atmErrorLabel.numberOfLines = 0
        atmErrorLabel.lineBreakMode = .byWordWrapping
        var atmError = atm.atmError
        atmError.isEmpty ? (atmError = "информация отсутствует") : nil
        atmErrorLabel.text = "Исправность банкомата: " + atmError
        return atmErrorLabel
    }()

    private lazy var currencyLabel: UILabel = {
        var currencyLabel = UILabel()
        currencyLabel.numberOfLines = 0
        currencyLabel.lineBreakMode = .byWordWrapping
        var currency = atm.currency
        currency.isEmpty ? (currency = "информация отсутствует") : nil
        currencyLabel.text = "Выдаваемая валюта: " + currency
        return currencyLabel
    }()

    private lazy var cashInLabel: UILabel = {
        var cashInLabel = UILabel()
        cashInLabel.numberOfLines = 0
        cashInLabel.lineBreakMode = .byWordWrapping
        var cashIn = atm.cashIn
        cashIn.isEmpty ? (cashIn = "информация отсутствует") : nil
        cashInLabel.text = "Наличие купюроприемника: " + cashIn
        return cashInLabel
    }()

    private lazy var atmPrinterLabel: UILabel = {
        var atmPrinterLabel = UILabel()
        atmPrinterLabel.numberOfLines = 0
        atmPrinterLabel.lineBreakMode = .byWordWrapping
        var atmPrinter = atm.atmPrinter
        atmPrinter.isEmpty ? (atmPrinter = "информация отсутствует") : nil
        atmPrinterLabel.text = "Возможность печати чека: " + atmPrinter
        return atmPrinterLabel
    }()

    private lazy var buildRouteButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.buttonSize = .large
        configuration.baseBackgroundColor = .systemGreen
        configuration.title = "Построить маршрут"
        var buildRouteButton = UIButton(type: .custom)
        buildRouteButton.configuration = configuration
        buildRouteButton.addTarget(self, action: #selector(openMaps), for: .touchUpInside)
        return buildRouteButton
    }()

    init(atm: ATM) {
        self.atm = atm
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupButton()
        setupScrollView()
    }

    private func createFullAddress(atm: ATM) -> String {
        var area = atm.area
        (area == "Минск") ? (area = "") : (area += " область, ")
        var cityType = atm.cityType
        (cityType.isEmpty) ? (cityType = "") : (cityType += " ")
        var city = atm.city
        (city.isEmpty) ? (city = "") : (city += ", ")
        var addressType = atm.addressType
        (addressType.isEmpty) ? (addressType = "") : (addressType += " ")
        var address = atm.address
        (address.isEmpty) ? (address = "") : (address += ", ")
        let house = atm.house
        let fullAddress = "Адрес установки: " + area + cityType + city + addressType + address + house
        return fullAddress
    }

    private func setupScrollView() {
        self.view.addSubview(self.scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(5)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-5)
            make.bottom.equalTo(buildRouteButton.snp.top)
        }

        self.scrollView.addSubview(self.mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
    }

    private func setupButton() {
        self.view.addSubview(self.buildRouteButton)
        buildRouteButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-5)
        }
    }

    @objc private func openMaps() {
        let alert = UIAlertController(title: "Построить маршрут",
                                      message: "Выберите приложение для построения маршрута",
                                      preferredStyle: .actionSheet)
        if let mapsAppleURL = URL(string: "maps://?saddr=Current%20Location&daddr=\(atm.gpsX),\(atm.gpsY)"),
           UIApplication.shared.canOpenURL(mapsAppleURL) {
            alert.addAction(UIAlertAction(title: "Apple Maps", style: .default) { _ in
                UIApplication.shared.open(mapsAppleURL)
            })
        }
        if let mapsGoogleURL = URL(string: "comgooglemaps://?saddr=&daddr=\(atm.gpsX),\(atm.gpsY)"),
           UIApplication.shared.canOpenURL(mapsGoogleURL) {
            alert.addAction(UIAlertAction(title: "Google Maps", style: .default) { _ in
                UIApplication.shared.open(mapsGoogleURL)
            })
        }
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel))
        self.present(alert, animated: true)
    }
}
