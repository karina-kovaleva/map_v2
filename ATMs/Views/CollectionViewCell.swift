//
//  CollectionViewCell.swift
//  ATMs
//
//  Created by Karina Kovaleva on 3.01.23.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {

    static let reuseId = "atmCell"

    private let font = UIFont(name: "Helvetica Neue", size: 12)

    var cellViewModel: CellModel? {
        didSet {
            switch cellViewModel?.type {
            case "ATM":
                self.installPlaceLabel.text = self.cellViewModel?.installPlace
                guard var workTime = self.cellViewModel?.workTime else { return }
                workTime.isEmpty ? workTime = "Режим работы неизвестен" : nil
                self.workTimeLabel.text = workTime
                guard var currency = self.cellViewModel?.currency else { return }
                currency.isEmpty ? currency = "неизвестно" : nil
                self.currencyLabel.text = "Валюта: " + currency
                self.setupStackView(mainStackViewForAtm)
                self.backgroundColor = .yellow
            case "Infobox":
                self.installPlaceLabel.text = self.cellViewModel?.installPlace
                guard var workTime = self.cellViewModel?.workTime else { return }
                workTime.isEmpty ? workTime = "Режим работы неизвестен" : nil
                self.workTimeLabel.text = workTime
                guard var currency = self.cellViewModel?.currency else { return }
                currency.isEmpty ? currency = "неизвестно" : nil
                self.currencyLabel.text = "Валюта: " + currency
                [self.installPlaceLabel,
                 self.workTimeLabel,
                 self.currencyLabel].forEach { mainStackViewForInfobox.addArrangedSubview($0) }
                self.setupStackView(mainStackViewForInfobox)
                self.backgroundColor = .blue
            case "Filial":
                self.installPlaceLabel.text = self.cellViewModel?.filialName
                //                self.nameType = nameType
                //                self.name = name
                //                self.streetType = streetType
                //                self.street = street
                //                self.homeNumber = homeNumber
                //                self.phoneInfo = phoneInfo
//                guard var nameType = self.cellViewModel?.nameType else { return }
//                (nameType.isEmpty) ? (nameType = "") : (nameType += " ")
//                guard var name = self.cellViewModel?.name else { return }
//                (name.isEmpty) ? (name = "") : (name += ", ")
//                guard var streetType = self.cellViewModel?.streetType else { return }
//                (streetType.isEmpty) ? (streetType = "") : (streetType += " ")
//                guard var street = self.cellViewModel?.street else { return }
//                (street.isEmpty) ? (street = "") : (street += ", ")
//                guard var homeNumber = self.cellViewModel?.homeNumber else { return }
//                let fullAddress = nameType + name + streetType + street + homeNumber
                self.workTimeLabel.text = self.cellViewModel?.infoWorktime
                self.phoneNumberLabel.text = self.cellViewModel?.phoneInfo
                [self.installPlaceLabel,
                 self.workTimeLabel,
                 self.phoneNumberLabel].forEach { mainStackViewForFilial.addArrangedSubview($0) }
                self.setupStackView(mainStackViewForFilial)
                self.backgroundColor = .orange
            case .none:
                break
            case .some:
                break
            }
        }
    }

    private lazy var mainStackViewForAtm: UIStackView = {
        var mainStackViewForAtm = UIStackView()
        mainStackViewForAtm.axis = .vertical
        mainStackViewForAtm.distribution = .equalSpacing
        mainStackViewForAtm.alignment = .leading
        mainStackViewForAtm.spacing = 0
        [self.installPlaceLabel,
         self.workTimeLabel,
         self.currencyLabel].forEach { mainStackViewForAtm.addArrangedSubview($0) }
        return mainStackViewForAtm
    }()

    private lazy var mainStackViewForInfobox: UIStackView = {
        var mainStackViewForInfobox = UIStackView()
        mainStackViewForInfobox.axis = .vertical
        mainStackViewForInfobox.distribution = .equalSpacing
        mainStackViewForInfobox.alignment = .leading
        mainStackViewForInfobox.spacing = 0
        [self.installPlaceLabel,
         self.workTimeLabel,
         self.currencyLabel].forEach { mainStackViewForInfobox.addArrangedSubview($0) }
        return mainStackViewForInfobox
    }()

    private lazy var mainStackViewForFilial: UIStackView = {
        var mainStackViewForFilial = UIStackView()
        mainStackViewForFilial.axis = .vertical
        mainStackViewForFilial.distribution = .equalSpacing
        mainStackViewForFilial.alignment = .leading
        mainStackViewForFilial.spacing = 0
        [self.installPlaceLabel,
         self.workTimeLabel,
         self.currencyLabel].forEach { mainStackViewForFilial.addArrangedSubview($0) }
        return mainStackViewForFilial
    }()

    private lazy var installPlaceLabel: UILabel = {
        var installPlaceLabel = UILabel()
        installPlaceLabel.font = font
        installPlaceLabel.numberOfLines = 0
        installPlaceLabel.lineBreakMode = .byWordWrapping
        return installPlaceLabel
    }()

    private lazy var workTimeLabel: UILabel = {
        var workTimeLabel = UILabel()
        workTimeLabel.font = font
        workTimeLabel.numberOfLines = 0
        workTimeLabel.lineBreakMode = .byWordWrapping
        return workTimeLabel
    }()

    private lazy var currencyLabel: UILabel = {
        var currencyLabel = UILabel()
        currencyLabel.font = font
        currencyLabel.numberOfLines = 0
        currencyLabel.lineBreakMode = .byWordWrapping
        return currencyLabel
    }()

    private lazy var phoneNumberLabel: UILabel = {
        var phoneNumberLabel = UILabel()
        phoneNumberLabel.font = font
        phoneNumberLabel.numberOfLines = 0
        phoneNumberLabel.lineBreakMode = .byWordWrapping
        return phoneNumberLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = .systemGreen

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 10
    }

    private func setupStackView(_ stackView: UIStackView) {
        self.contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(self.contentView.snp.leading).offset(5)
            make.trailing.equalTo(self.contentView.snp.trailing).offset(-5)
            make.top.equalTo(self.contentView.snp.top).offset(2)
            make.bottom.lessThanOrEqualTo(self.contentView.snp.bottom).offset(-2)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.installPlaceLabel.text = nil
        self.phoneNumberLabel.text = nil
        self.workTimeLabel.text = nil
        self.currencyLabel.text = nil
    }
}
