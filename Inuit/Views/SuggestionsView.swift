//
//  SuggestionsView.swift
//  Inuit
//
//  Created by Roman Kavinskyi on 8/30/22.
//

import UIKit

final class SuggestionsView: UIView {
    
    private let stackView = UIStackView()
    
    var suggestionAccepted: ((String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        commonSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonSetup()
    }
    
    
    private func commonSetup() {
        setupStackView()
    }
    
    private func setupStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillProportionally
        
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
    
    func insertSuggestions(list: [String]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for suggestion in list {
            if stackView.arrangedSubviews.count > 0 {
                let separator = UIView()
                separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
                separator.backgroundColor = .systemBlack.withAlphaComponent(0.6)
                stackView.addArrangedSubview(separator)
                separator.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.4).isActive = true
            }
            
            let button = UIButton()
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.lineBreakMode = .byCharWrapping
            button.setCustomFont(with: suggestion, color: .label, size: 16)
            
            button.addTarget(self, action: #selector(suggestionSelected), for: .touchUpInside)
            stackView.addArrangedSubview(button)
            
            if let firstButton = stackView.arrangedSubviews.first as? UIButton {
                button.widthAnchor.constraint(equalTo: firstButton.widthAnchor).isActive = true
              }
        }
    }
    
    @objc private func suggestionSelected(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }
        suggestionAccepted?(title)
    }
}
