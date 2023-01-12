//
//  SectionHeader.swift
//  ATMs
//
//  Created by Karina Kovaleva on 5.01.23.
//

import UIKit

final class SectionHeader: UICollectionReusableView {

    static let reuseId = "sectionHeader"

    public lazy var headerLabel: UILabel = {
        var headerLabel = UILabel()
        headerLabel.font = UIFont(name: "Helvetica Neue Bold", size: 18)
        headerLabel.backgroundColor = .systemBackground
        headerLabel.numberOfLines = 0
        headerLabel.lineBreakMode = .byWordWrapping
        return headerLabel
    }()

//    var cellViewModel: CellModel? {
//        didSet {
//            self.headerLabel.text = cellViewModel?.city
//        }
//    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        self.addSubview(self.headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
