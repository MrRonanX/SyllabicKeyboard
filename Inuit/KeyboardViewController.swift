//
//  KeyboardViewController.swift
//  Inuit
//
//  Created by Roman Kavinskyi on 8/19/22.
//

import UIKit

final class KeyboardViewController: UIInputViewController {
    
    private var layoutConstants        = LayoutConstants()

    private var mainStackView          = UIStackView(frame: .zero)
    private var consonantsButton       : KeyboardButton!
    private var twoDotsButton          : KeyboardButton!

    private var buttonWidth            = CGFloat()

    private var backspaceTimer         : Timer?

    private var consonantsActive       = false
    private var twoDotsActive          = false
    
    
    
    private var isIpad: Bool { UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad }
    private var keySpacing: CGFloat { isIpad ? 7.0 : 5.0 }
    
    private var isLandscape: Bool {
        let size: CGSize = UIScreen.main.bounds.size
        return size.width / size.height > 1
    }
    
    private var heightConstraint: NSLayoutConstraint?

    private var keyboardHeight: CGFloat {
        get {
            guard let constraint = heightConstraint else { return 0 }
            return constraint.constant
        }
        set {
            setHeight(newValue)
        }
    }
    
    deinit {
        mainStackView.removeFromSuperview()
    }
    
    private var lastLayoutBounds: CGRect?
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if view.bounds == .zero { return }
        
        let orientationSavvyBounds = CGRect(x: 0, y: 10, width: view.bounds.width, height: height(for: UIScreen.main.orientation) - 15)
        
        if (lastLayoutBounds != nil && lastLayoutBounds == orientationSavvyBounds) {
            // do nothing
        } else {
            mainStackView.frame = orientationSavvyBounds
            calculateViewWidth()
            addViewsToStackView()
            lastLayoutBounds = orientationSavvyBounds
        }

    }
    
    private var selectedKeyboardType: KeyboardType = .sectionOne {
        didSet {
            addViewsToStackView()
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        keyboardHeight = height(for: newCollection.orientation)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardHeight = height(for: UIScreen.main.orientation)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createMainStackView()
    }

    // MARK: - View Size Setup
    
    private func calculateViewWidth() {
        let bounds = mainStackView.bounds
        if bounds.height == 0 || bounds.width == 0 { return }
        
        var sideEdges = isLandscape ? layoutConstants.sideEdgesLandscape : layoutConstants.sideEdgesPortrait(bounds.width) * 3
        
        let normalKeyboardSize = bounds.width - CGFloat(2) * sideEdges
        let shrunkKeyboardSize = layoutConstants.keyboardShrunkSize(normalKeyboardSize)
        
        sideEdges += ((normalKeyboardSize - shrunkKeyboardSize) / CGFloat(2))
        
        buttonWidth = (bounds.width - sideEdges - keySpacing * 8) / 9
    }
    
    private func height(for orientation: UIInterfaceOrientation) -> CGFloat {
        let actualScreenWidth = UIScreen.main.nativeBounds.size.width / UIScreen.main.nativeScale
        let canonicalPortraitHeight: CGFloat
        let canonicalLandscapeHeight: CGFloat
        if isIpad {
            canonicalPortraitHeight = 352
            canonicalLandscapeHeight = 352
        }
        else {
            canonicalPortraitHeight = orientation.isPortrait && actualScreenWidth >= 420 ? 216 : 206
            canonicalLandscapeHeight = 172
        }
        
        return CGFloat(orientation.isPortrait ? canonicalPortraitHeight : canonicalLandscapeHeight)
    }
    
    private func setHeight(_ height: CGFloat) {
        guard heightConstraint == nil else {
            heightConstraint?.constant = height
            return
        }
        
        heightConstraint = NSLayoutConstraint(
            item: view,
            attribute: NSLayoutConstraint.Attribute.height,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: nil,
            attribute: NSLayoutConstraint.Attribute.notAnAttribute,
            multiplier: 0,
            constant: height)
        heightConstraint?.priority = .init(rawValue: 999)
        heightConstraint?.isActive = true
    }
    
    // MARK: - Keyboard Creation
    
    private func createMainStackView() {
        mainStackView.axis          = .vertical
        mainStackView.spacing       = 7.0
        mainStackView.distribution  = .fillEqually
        mainStackView.alignment     = .center
        view.addSubview(mainStackView)
    }
    
    private func addViewsToStackView() {
        if buttonWidth < 1 { return }
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        mainStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let firstRow    = createFirstRow()
        let secondRow   = createSecondRow()
        let thirdRow    = createThirdRow()
        let fourthRow   = createFourthRow()
        
        mainStackView.addArrangedSubview(firstRow)
        mainStackView.addArrangedSubview(secondRow)
        mainStackView.addArrangedSubview(thirdRow)
        mainStackView.addArrangedSubview(fourthRow)
        CATransaction.commit()
    }
    
    private func createKeyboardRow(row: [String]) -> UIView {
        let rowStackView            = UIStackView()
        rowStackView.spacing        = keySpacing
        rowStackView.axis           = .horizontal
        rowStackView.alignment      = .fill
        rowStackView.distribution   = .fillEqually
        
        row.forEach { rowStackView.addArrangedSubview(createKeyButton(title: $0))}
        
        return rowStackView
    }
    
    private var rowHasConsonants: Bool {
        !(twoDotsActive && selectedKeyboardType != .numericSection)
    }
    
    private var rowHasTabButton: Bool {
        selectedKeyboardType == .numericSection && !twoDotsActive && !consonantsActive
    }
    
    private func createFirstRow() -> UIStackView {
        let rowKeys             = createKeyboardRow(row: selectedKeyboardType.firstRow(consonantsActive, twoDotsActive))
        let firstSectionButton  = createAccessoryButton(type: .sectionOne(onTap: firstSectionSelected))
        
        let rowView             = UIStackView(arrangedSubviews: [firstSectionButton, rowKeys])
        rowView.distribution    = .fillProportionally
        rowView.spacing         = keySpacing
        
        if rowHasTabButton {
            let tabButton = createAccessoryButton(type: .tab(onTap: tabButtonTapped))
            rowView.addArrangedSubview(tabButton)
        }
       
        
        guard rowHasConsonants else { return rowView }
        
        consonantsButton   = createAccessoryButton(type: .syllables(onTap: consonantsTapped))
        rowView.addArrangedSubview(consonantsButton)
        
        return rowView
    }
    
    private func createSecondRow() -> UIStackView {
        let rowKeys             = createKeyboardRow(row: selectedKeyboardType.secondRow(consonantsActive, twoDotsActive))
        let secondSectionButton = createAccessoryButton(type: .sectionTwo(onTap: secondSectionSelected))
        
        let rowView             = UIStackView(arrangedSubviews: [secondSectionButton, rowKeys])
        rowView.distribution    = .fillProportionally
        rowView.spacing         = keySpacing
        
        if rowHasTabButton {
            let leftArrow  = createAccessoryButton(type: .arrowLeft(onTap: arrowLeftTapped))
            let rightArrow = createAccessoryButton(type: .arrowRight(onTap: arrowRightTapped))
            rowView.addArrangedSubview(leftArrow)
            rowView.addArrangedSubview(rightArrow)
        }
        
        guard rowHasConsonants else { return rowView }
        
        twoDotsButton = createAccessoryButton(type: .twoDots(onTap: twoDotsTapped))
        rowView.addArrangedSubview(twoDotsButton)
        
        return rowView
        
    }
    
    private func createThirdRow() -> UIStackView {
        let rowKeys             = createKeyboardRow(row: selectedKeyboardType.thirdRow(consonantsActive, twoDotsActive))
        let thirdSectionButton  = createAccessoryButton(type: .sectionThree(onTap: thirdSectionSelected))
        
        let longPressGesture    = UILongPressGestureRecognizer(target: self, action: #selector(onLongPressOfBackSpaceKey))
        longPressGesture.minimumPressDuration       = 0.5
        longPressGesture.numberOfTouchesRequired    = 1
        longPressGesture.allowableMovement          = 0.1
        
        let backSpaceButton = createAccessoryButton(type: .delete(onTap: deleteTapped))
        backSpaceButton.addGestureRecognizer(longPressGesture)
        
        let rowView = UIStackView(arrangedSubviews: [thirdSectionButton, rowKeys, backSpaceButton])
        rowView.distribution = .fillProportionally
        rowView.spacing = keySpacing
        
        return rowView
    }
    
    private func createFourthRow() -> UIStackView {
        let fourthSectionButton     = createAccessoryButton(type: .sectionFour(onTap: fourthSectionSelected))
        let numericSectionButton    = createAccessoryButton(type: .numericSection(onTap: numericSectionSelected))
       
        let spaceKey                = createAccessoryButton(type: .space(onTap: spaceTapped))
        let returnButton            = createAccessoryButton(type: .enter(onTap: returnTapped))
        
        let rowView = UIStackView(arrangedSubviews: [fourthSectionButton, numericSectionButton, spaceKey, returnButton])
        
        if isIpad || DeviceTypes.olderIphone {
            let changeLanguageButton = createAccessoryButton(type: .changeLanguage(onTap: playSound))
            changeLanguageButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
            rowView.insertArrangedSubview(changeLanguageButton, at: 2)
        }
        
        rowView.distribution = .fillProportionally
        rowView.spacing = keySpacing
        
        return rowView
    }
    
    private func hasColoredBackground(_ title: String) -> Bool {
        let inuktitutCharacter = title >=  "᐀" && title <= "ᙿ" || SpecialCharacters.numericFilter.contains(title)
        let specialCharacter = SpecialCharacters.filter.contains(title) && selectedKeyboardType == .numericSection && (twoDotsActive || consonantsActive)
        return inuktitutCharacter || specialCharacter
        
    }
    
    private func createKeyButton(title: String) -> KeyboardButton {
        let button = KeyboardButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
    
        if hasColoredBackground(title) {
            button.defaultBackgroundColor = selectedKeyboardType.backgroundColor
            button.addTopPadding(to: title, color: selectedKeyboardType.foregroundColor)
        } else {
            button.defaultBackgroundColor = .systemWhite
            button.setTitle(title, for: .normal)
            button.setTitleColor(.appGray, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        }
      
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        return button
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }
        
        playSound()
        textDocumentProxy.insertText(title)

    }
    
    private func createAccessoryButton(type: SpecialButtonType) -> KeyboardButton {
        let button = KeyboardButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.action = type.action
        
        
        if let title = type.title {
            button.setTitle(title, for: .normal)
            button.setTitleColor(.appGray, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
            
            if case .syllables = type {
                button.setTitleColor(consonantsActive ? selectedKeyboardType.backgroundColor : .appGray, for: .normal)
            }
            
            if case .twoDots = type {
                button.setTitleColor(twoDotsActive ? selectedKeyboardType.backgroundColor : .appGray, for: .normal)
            }
            
        } else if let image = type.image {
            button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
            button.tintColor = type.imageColor
            
            if case .delete = type {
                button.pushToRight(image)
                
            } else if case .tab = type {
                button.resizeRight(with: buttonWidth)

            } else if type.hasArrow {
                button.resizeImageView(with: buttonWidth)
            }
        }
        
        if type.hasColoredBackground {
            button.defaultBackgroundColor = selectedKeyboardType.backgroundColor
            button.setTitleColor(.white, for: .normal)
        }

        switch type {
        case .tab, .delete, .enter, .space:
            var multiplier = 2.0
            if case .space = type {
                let constant: CGFloat = isIpad || DeviceTypes.olderIphone ? 2 : 3
                multiplier += constant
            }
            button.widthAnchor.constraint(equalToConstant: buttonWidth * multiplier + keySpacing * (multiplier - 1)).isActive = true
            return button
        default:
            button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
            return button
        }
    }
    
    // MARK: - Keys Pressed Logic
    
    @objc func onLongPressOfBackSpaceKey(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            (gesture.view as! KeyboardButton).longTouchStarted()
            backspaceTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                self.deleteTapped()
            }
        } else if gesture.state == .ended || gesture.state == .cancelled {
            backspaceTimer?.invalidate()
            backspaceTimer = nil
            (gesture.view as! KeyboardButton).longTouchEnded()
        }
    }
    
    private func resetState() {
        consonantsActive = false
        twoDotsActive = false
    }
    
    private func firstSectionSelected() {
        resetState()
        playSound()
        selectedKeyboardType = .sectionOne
    }
    
    private func secondSectionSelected() {
        resetState()
        playSound()
        selectedKeyboardType = .sectionTwo
    }
    
    private func thirdSectionSelected() {
        resetState()
        playSound()
        selectedKeyboardType = .sectionThree
    }
    
    private func fourthSectionSelected() {
        resetState()
        playSound()
        selectedKeyboardType = .sectionFour
    }
    
    private func numericSectionSelected() {
        resetState()
        playSound()
        selectedKeyboardType = .numericSection
    }
    
    private func tabButtonTapped() {
        playSound()
        textDocumentProxy.insertText("\t")
    }
    
    private func arrowRightTapped() {
        playSound()
        textDocumentProxy.adjustTextPosition(byCharacterOffset: 1)
    }
    
    private func arrowLeftTapped() {
        playSound()
        textDocumentProxy.adjustTextPosition(byCharacterOffset: -1)
    }
    
    private func consonantsTapped() {
        playSound()
        consonantsActive.toggle()
        twoDotsActive = false
        addViewsToStackView()
    }
    
    private func twoDotsTapped() {
        playSound()
        twoDotsActive.toggle()
        consonantsActive = false
        
        if selectedKeyboardType != .numericSection {
            selectedKeyboardType = .sectionOne
            return
        }
        
        addViewsToStackView()
    }
    
    private func spaceTapped(){
        playSound()
        textDocumentProxy.insertText(" ")
    }
    
    private func returnTapped() {
        playSound()
        textDocumentProxy.insertText("\n")
    }
    
    private func deleteTapped() {
        playSound()
        textDocumentProxy.deleteBackward()
    }
    
    private func playSound() {
        inputView?.playInputClick​()
    }
}


