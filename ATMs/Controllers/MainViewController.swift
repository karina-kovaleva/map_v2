//
//  ViewController.swift
//  ATMs
//
//  Created by Karina Kovaleva on 26.12.22.
//

import UIKit
import SnapKit

protocol MainViewControllerDelegate: AnyObject {
    func updateAtms()
}

final class MainViewController: UIViewController {

    private var atms: [ATM] = []

    private lazy var listVC = ListViewController()
    private lazy var mapVC = MapViewController()

    weak var delegate: MainViewControllerDelegate?

    private lazy var segmentedControl: UISegmentedControl = {
        var segmentedControl = UISegmentedControl(items: ["Карта", "Список банкоматов"])
        segmentedControl.backgroundColor = .systemGreen
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(changeSegmentedControlValue), for: .valueChanged)
        return segmentedControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        configureNavBarAppearance()
        setupSegmentedControl()
        listVC.delegate = self
    }

    private func configureNavBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.systemGreen]
        self.title = "Банкоматы Беларусбанка"
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh,
                                                                 target: self,
                                                                 action: #selector(updateAtms))
        self.navigationController?.navigationBar.tintColor = .systemGreen
    }

    private func setupSegmentedControl() {
        self.view.addSubview(segmentedControl)
        segmentedControl.sendActions(for: .valueChanged)
        segmentedControl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
    }

    @objc private func changeSegmentedControlValue() {
        if segmentedControl.selectedSegmentIndex == 0 {
            remove(asChildViewController: listVC)
            add(asChildViewController: mapVC)
        } else {
            remove(asChildViewController: mapVC)
            add(asChildViewController: listVC)
        }
    }

    @objc private func updateAtms() {
        self.delegate?.updateAtms()
    }

    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }

    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.segmentedControl.snp.bottom).offset(5)
        }
        viewController.didMove(toParent: self)
    }

    public func chooseMapViewController() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.sendActions(for: .valueChanged)
    }
}

extension MainViewController: ListViewControllerDelegate {
    func selectAnnotation(_ id: String) {
        mapVC.selectAnnotation(id)
    }
}
