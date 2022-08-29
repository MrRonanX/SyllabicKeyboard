//
//  KeyboardViewController.swift
//  Inuit
//
//  Created by Roman Kavinskyi on 8/19/22.
//

import UIKit

final class KeyboardViewController: UIInputViewController {
    
    private var layoutConstants             = LayoutConstants()

    private var mainStackView               = UIStackView(frame: .zero)
    private var consonantsButton            : KeyboardButton!
    private var twoDotsButton               : KeyboardButton!

    private var buttonWidth                 = CGFloat()

    private var backspaceTimer              : Timer?

    private var syllablesActive             = false
    private var twoDotsActive               = false

    private var tappedButton                : UIView?
    
    private var accessoryPortraitHeight     = CGFloat()
    private var accessoryLandscapeHeight    = CGFloat()
    
    
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

        let orientationSavvyBounds = createMainViewFrame()
        
        if (lastLayoutBounds != nil && lastLayoutBounds == orientationSavvyBounds) {
            // do nothing
        } else {
            mainStackView.frame = orientationSavvyBounds
            calculateViewWidth()
            addViewsToStackView()
            lastLayoutBounds = orientationSavvyBounds
        }
    }
    
    private func createMainViewFrame() -> CGRect {
        let accessoryViewHeight = isLandscape ? accessoryLandscapeHeight : accessoryPortraitHeight
        let yPoint = isIpad ? 10 : accessoryViewHeight + 10
        let verticalPadding = isIpad ? 15 : 15 + accessoryViewHeight
        
        return CGRect(x: 0, y: yPoint, width: view.bounds.width, height: height(for: UIScreen.main.orientation) - verticalPadding)
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
        var canonicalPortraitHeight: CGFloat
        var canonicalLandscapeHeight: CGFloat
        if isIpad {
            canonicalPortraitHeight = 352
            canonicalLandscapeHeight = 352
        }
        else {
            canonicalPortraitHeight = orientation.isPortrait && actualScreenWidth >= 420 ? 216 : 206
            canonicalLandscapeHeight = 172
            accessoryPortraitHeight = (canonicalPortraitHeight - 15 - 21) / 3
            accessoryLandscapeHeight = (canonicalLandscapeHeight - 15 - 21) / 3
            canonicalPortraitHeight += accessoryPortraitHeight
            canonicalLandscapeHeight += accessoryLandscapeHeight
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
    
    private var rowHasArrows: Bool {
        selectedKeyboardType == .numericSection && !twoDotsActive && !syllablesActive
    }
    
    private func createFirstRow() -> UIStackView {
        let rowKeys             = createKeyboardRow(row: selectedKeyboardType.firstRow(syllablesActive, twoDotsActive))
        let firstSectionButton  = createAccessoryButton(type: .sectionOne(onTap: firstSectionSelected))
        
        let rowView             = UIStackView(arrangedSubviews: [firstSectionButton, rowKeys])
        rowView.distribution    = .fillProportionally
        rowView.spacing         = keySpacing
        
        guard rowHasConsonants else { return rowView }
        
        consonantsButton   = createAccessoryButton(type: .syllables(onTap: consonantsTapped, keyboardType: selectedKeyboardType))
        rowView.addArrangedSubview(consonantsButton)
        
        return rowView
    }
    
    private func createSecondRow() -> UIStackView {
        let rowKeys             = createKeyboardRow(row: selectedKeyboardType.secondRow(syllablesActive, twoDotsActive))
        let secondSectionButton = createAccessoryButton(type: .sectionTwo(onTap: secondSectionSelected))
        
        let rowView             = UIStackView(arrangedSubviews: [secondSectionButton, rowKeys])
        rowView.distribution    = .fillProportionally
        rowView.spacing         = keySpacing
        
        if rowHasArrows {
            let leftArrow  = createAccessoryButton(type: .arrowLeft(onTap: arrowLeftTapped))
            let rightArrow = createAccessoryButton(type: .arrowRight(onTap: arrowRightTapped))
            rowView.addArrangedSubview(leftArrow)
            rowView.addArrangedSubview(rightArrow)
        }
        
        guard rowHasConsonants else { return rowView }
        
        twoDotsButton = createAccessoryButton(type: .twoDots(onTap: twoDotsTapped, keyboardType: selectedKeyboardType))
        rowView.addArrangedSubview(twoDotsButton)
        
        return rowView
        
    }
    
    private func createThirdRow() -> UIStackView {
        let rowKeys             = createKeyboardRow(row: selectedKeyboardType.thirdRow(syllablesActive, twoDotsActive))
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
        let inuktitutCharacter = inuktitutCharacter(title) || SpecialCharacters.numericFilter.contains(title)
        let specialCharacter = SpecialCharacters.filter.contains(title) && selectedKeyboardType == .numericSection && (twoDotsActive || syllablesActive)
        return inuktitutCharacter || specialCharacter
    }
    
    private func inuktitutCharacter(_ title: String) -> Bool {
        title >=  "᐀" && title <= "ᙿ"
    }
    
    private func createKeyButton(title: String) -> KeyboardButton {
        let button = KeyboardButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        
        if inuktitutCharacter(title) {
            button.addTopPadding()
        }
        
        let coloredBackground = hasColoredBackground(title)
        
        button.defaultBackgroundColor = coloredBackground ? selectedKeyboardType.backgroundColor : .systemWhite
        button.setCustomFont(with: title, color: coloredBackground ? selectedKeyboardType.foregroundColor : .appGray)
    
        if !isIpad {
            button.highlightBackgroundColor = .clear
        }
      
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        if !isIpad {
            button.addTarget(self, action: #selector(touchedDownButton), for: .touchDown)
            button.addTarget(self, action: #selector(dragExit), for: .touchDragExit)
            button.addTarget(self, action: #selector(dragIn), for: .touchDragInside)
        }
        
        return button
    }
    
    @objc private func touchedDownButton(_ sender: KeyboardButton) {
        tappedButton?.removeFromSuperview()

        let popUpColor = hasColoredBackground(sender.titleLabel?.text ?? "") ? selectedKeyboardType.backgroundColor : .systemWhite
        let multiplier = DeviceTypes.olderIphone ? 2.8 : 2.6
        
        let popUpView = KeyPopUp(frame: .zero, color: popUpColor)
        popUpView.label.setAttributedTitle(with: sender.titleLabel?.text ?? "", color: sender.titleLabel?.textColor ?? .orange)
        
        tappedButton = popUpView
        view.addSubview(popUpView)
        popUpView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            popUpView.bottomAnchor.constraint(equalTo: sender.bottomAnchor),
            popUpView.centerXAnchor.constraint(equalTo: sender.centerXAnchor),
            popUpView.widthAnchor.constraint(equalTo: sender.widthAnchor, multiplier: 1.78),
            popUpView.heightAnchor.constraint(equalTo: sender.widthAnchor, multiplier: multiplier)
        ])
    }
    
    @objc private func dragExit(_ sender: KeyboardButton) {
        tappedButton?.removeFromSuperview()
    }
    
    @objc private func dragIn(_ sender: KeyboardButton) {
        touchedDownButton(sender)
    }
    
    @objc private func didTapButton(_ sender: KeyboardButton) {
        guard let title = sender.titleLabel?.text else { return }

        tappedButton?.removeFromSuperview()
        playSound()
        
        textDocumentProxy.insertText(title)

    }
    
    private func createAccessoryButton(type: SpecialButtonType) -> KeyboardButton {
        let button = KeyboardButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.action = type.action
        
        button.setTitle(for: type)
        button.adjustTitleForSyllables(type: type, active: syllablesActive)
        button.adjustTitleForTwoDots(type: type, active: twoDotsActive)
        
        button.setImage(for: type)
        button.adjustImageForSyllables(type: type, active: syllablesActive)
        
        button.setBackgroundColor(for: type)

        switch type {
        case .delete, .enter, .space:
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
        syllablesActive = false
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
        syllablesActive.toggle()
        twoDotsActive = false
        addViewsToStackView()
    }
    
    private func twoDotsTapped() {
        playSound()
        twoDotsActive.toggle()
        syllablesActive = false
        
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


