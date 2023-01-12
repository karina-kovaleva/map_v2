//
//  Callout.swift
//  ATMs
//
//  Created by Karina Kovaleva on 6.01.23.
//

import MapKit

protocol CalloutViewDelegate: AnyObject {
    func openDetailViewController(_ id: String)
}

final class CalloutView: UIView {

    private let annotation: Annotation
    private let font = UIFont(name: "Helvetica Neue", size: 14)

    weak var delegate: CalloutViewDelegate?

    private lazy var mainStackView: UIStackView = {
        var mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillProportionally
        mainStackView.alignment = .leading
        mainStackView.spacing = 2
        [self.installPlaceLabel,
         self.workTimeLabel,
         self.currencyLabel,
         self.cashInLabel,
         self.moreButton].forEach { mainStackView.addArrangedSubview($0) }
        return mainStackView
    }()

    private lazy var installPlaceLabel: UILabel = {
        var installPlaceLabel = UILabel()
        installPlaceLabel.numberOfLines = 0
        installPlaceLabel.font = font
        installPlaceLabel.textColor = .systemGreen
        installPlaceLabel.text = annotation.installPlace
        return installPlaceLabel
    }()

    private lazy var workTimeLabel: UILabel = {
        var workTimeLabel = UILabel()
        workTimeLabel.numberOfLines = 0
        workTimeLabel.font = font
        workTimeLabel.textColor = .systemGreen
        var workTime = annotation.workTime
        workTime.isEmpty ? (workTime = "Информация о режиме работы недоступна") : nil
        workTimeLabel.text = workTime
        return workTimeLabel
    }()

    private lazy var currencyLabel: UILabel = {
        var currencyLabel = UILabel()
        currencyLabel.font = font
        currencyLabel.textColor = .systemGreen
        var currency = annotation.currency
        currency.isEmpty ? (currency = "Информация недоступна") : nil
        currencyLabel.text = "Выдаваемая валюта: " + currency
        return currencyLabel
    }()

    private lazy var cashInLabel: UILabel = {
        var cashInLabel = UILabel()
        cashInLabel.font = font
        cashInLabel.textColor = .systemGreen
        var cashIn = annotation.cashIn
        cashIn.isEmpty ? (cashIn = "Информация недоступна") : nil
        cashInLabel.text = "Наличие купюроприемника: " + cashIn
        return cashInLabel
    }()

    private lazy var moreButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.buttonSize = .medium
        configuration.baseBackgroundColor = .systemGreen
        configuration.title = "Подробнее"
        var moreButton = UIButton(type: .custom)
        moreButton.configuration = configuration
        moreButton.addTarget(self, action: #selector(openDetailViewController), for: .touchUpInside)
        return moreButton
    }()

    init(annotation: Annotation) {
        self.annotation = annotation
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        self.addSubview(self.mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @objc private func openDetailViewController(_ sender: UIButton) {
        delegate?.openDetailViewController(self.annotation.id)
    }
}
