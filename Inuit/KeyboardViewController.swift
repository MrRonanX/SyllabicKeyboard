//
//  KeyboardViewController.swift
//  Inuit
//
//  Created by Roman Kavinskyi on 8/19/22.
//

import UIKit

final class KeyboardViewController: UIInputViewController {
    
    private var layoutConstants             = LayoutConstants()

    private var mainStackView               = UIStackView()
    private var suggestionView              = SuggestionsView()

    private var buttonWidth                 = CGFloat()

    private var backspaceTimer              : Timer?

    private var syllablesActive             = false
    private var twoDotsActive               = false

    private var tappedButton                : UIView?
    
    private var accessoryPortraitHeight     = CGFloat()
    private var accessoryLandscapeHeight    = CGFloat()
    
    private var suggestionCore              = SuggestionCore()
    private var currentWord                 = String() {
        didSet {
            showSuggestions()
        }
    }
    
    private var spaceLastTapped             = Date()
    
    
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
        print("deinit")
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
        let yPoint = accessoryViewHeight + 10
        let verticalPadding = 15 + accessoryViewHeight
        
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
        createSuggestionsSection()
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
            canonicalPortraitHeight = 392
            canonicalLandscapeHeight = 392
            accessoryPortraitHeight = 40
            accessoryLandscapeHeight = 40
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
        
        let firstSectionButton  = createAccessoryButton(type: .sectionOne)
        firstSectionButton.addTarget(self, action: #selector(firstSectionSelected), for: .touchUpInside)
        
        let rowView             = KeyboardRowView(arrangedSubviews: [firstSectionButton, rowKeys])
        
        guard rowHasConsonants else { return rowView }
        
        let consonantsButton   = createAccessoryButton(type: .syllables(keyboardType: selectedKeyboardType))
        consonantsButton.addTarget(self, action: #selector(consonantsTapped), for: .touchUpInside)
        
        rowView.addArrangedSubview(consonantsButton)
        
        return rowView
    }
    
    private func createSecondRow() -> UIStackView {
        let rowKeys             = createKeyboardRow(row: selectedKeyboardType.secondRow(syllablesActive, twoDotsActive))
        
        let secondSectionButton = createAccessoryButton(type: .sectionTwo)
        secondSectionButton.addTarget(self, action: #selector(secondSectionSelected), for: .touchUpInside)
        
        let rowView             = KeyboardRowView(arrangedSubviews: [secondSectionButton, rowKeys])
        
        if rowHasArrows {
            let leftArrow  = createAccessoryButton(type: .arrowLeft)
            let rightArrow = createAccessoryButton(type: .arrowRight)
            leftArrow.addTarget(self, action: #selector(arrowLeftTapped), for: .touchUpInside)
            rightArrow.addTarget(self, action: #selector(arrowRightTapped), for: .touchUpInside)
            rowView.addArrangedSubview(leftArrow)
            rowView.addArrangedSubview(rightArrow)
        }
        
        guard rowHasConsonants else { return rowView }
        
        let twoDotsButton = createAccessoryButton(type: .twoDots(keyboardType: selectedKeyboardType))
        twoDotsButton.addTarget(self, action: #selector(twoDotsTapped), for: .touchUpInside)
        rowView.addArrangedSubview(twoDotsButton)
        
        return rowView
        
    }
    
    private func createThirdRow() -> UIStackView {
        let rowKeys             = createKeyboardRow(row: selectedKeyboardType.thirdRow(syllablesActive, twoDotsActive))
        let thirdSectionButton  = createAccessoryButton(type: .sectionThree)
        thirdSectionButton.addTarget(self, action: #selector(thirdSectionSelected), for: .touchUpInside)
        
        let longPressGesture    = UILongPressGestureRecognizer(target: self, action: #selector(onLongPressOfBackSpaceKey))
        longPressGesture.minimumPressDuration       = 0.5
        longPressGesture.numberOfTouchesRequired    = 1
        longPressGesture.allowableMovement          = 0.1
        
        let backSpaceButton = createAccessoryButton(type: .delete)
        backSpaceButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        backSpaceButton.addGestureRecognizer(longPressGesture)
        
        let rowView = KeyboardRowView(arrangedSubviews: [thirdSectionButton, rowKeys, backSpaceButton])
        
        return rowView
    }
    
    private func createFourthRow() -> UIStackView {
        let fourthSectionButton     = createAccessoryButton(type: .sectionFour)
        let numericSectionButton    = createAccessoryButton(type: .numericSection)
        let spaceKey                = createAccessoryButton(type: .space)
        let returnButton            = createAccessoryButton(type: .enter)
        
        fourthSectionButton.addTarget(self, action: #selector(fourthSectionSelected), for: .touchUpInside)
        numericSectionButton.addTarget(self, action: #selector(numericSectionSelected), for: .touchUpInside)
        spaceKey.addTarget(self, action: #selector(spaceTapped), for: .touchUpInside)
        returnButton.addTarget(self, action: #selector(returnTapped), for: .touchUpInside)
        
        let rowView = KeyboardRowView(arrangedSubviews: [fourthSectionButton, numericSectionButton, spaceKey, returnButton])
        
        if isIpad || DeviceTypes.olderIphone {
            let changeLanguageButton = createAccessoryButton(type: .changeLanguage)
            changeLanguageButton.addTarget(self, action: #selector(playSound), for: .touchUpInside)
            changeLanguageButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
            rowView.insertArrangedSubview(changeLanguageButton, at: 2)
        }

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

        guard !title.companionCharacter.isEmpty else { return button }

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(buttonLongTapped))
        longPressGesture.minimumPressDuration       = 0.5
        longPressGesture.numberOfTouchesRequired    = 1
        longPressGesture.allowableMovement          = 0.1

        button.addGestureRecognizer(longPressGesture)
        
        return button
    }

    @objc private func buttonLongTapped(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            tappedButton?.removeFromSuperview()
            createLongTapView(from: gesture)
        }

        if gesture.state == .ended {
            let keyButton = gesture.view as? KeyboardButton
            keyButton?.isHighlighted = false
            tappedButton?.removeFromSuperview()

            guard let tappedButton = tappedButton as? LongTappable, !tappedButton.selectedCharacter.isEmpty else { return }
            handleTappedCharacter(char: tappedButton.selectedCharacter)
        }

        if gesture.state == .changed {
            let tapLocation = gesture.location(in: view)
            guard let tappedButton = tappedButton as? LongTappable else { return }
            if tappedButton.largerFrame.contains(tapLocation) {
                tappedButton.handleSelection(for: gesture)
            } else {
                gesture.cancel()
                tappedButton.removeFromSuperview()
                let keyButton = gesture.view as? KeyboardButton
                keyButton?.isHighlighted = false
            }
        }
    }

    private func createLongTapView(from gesture: UILongPressGestureRecognizer) {
        guard let keyButton = gesture.view as? KeyboardButton,
                let char = keyButton.titleLabel?.text,
                inuktitutCharacter(char),
                !char.companionCharacter.isEmpty else { return }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) { [weak keyButton] in
            keyButton?.isHighlighted = true
        }

        let popUpColor = DeviceTypes.isiPad ? selectedKeyboardType.longTapBackgroundColor : selectedKeyboardType.backgroundColor
        let tapLocation = gesture.location(in: view)
        let direction: Direction = tapLocation.x > view.frame.midX + buttonWidth / 2 ? .left : .right

        let popUpView = LongTapPopUp(direction: direction, color: popUpColor)
        popUpView.setLabels(title1: char, title2: char.companionCharacter)
        view.addSubview(popUpView)
        tappedButton = popUpView
        popUpView.translatesAutoresizingMaskIntoConstraints = false

        DeviceTypes.isiPad ? popUpView.setIPadConstraints(for: keyButton, and: direction) :
                             popUpView.setIPhoneConstraint(for: keyButton, and: direction, and: buttonWidth)
    }
    
    private func createAccessoryButton(type: SpecialButtonType) -> KeyboardButton {
        let button = KeyboardButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    // MARK: - Suggestions Section Creation
    
    private func createSuggestionsSection() {
        suggestionView.suggestionAccepted = { [weak self] suggestion in
            self?.suggestionTapped(suggestion)
        }
        
        view.addSubview(suggestionView)
        
        NSLayoutConstraint.activate([
            suggestionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            suggestionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            suggestionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            suggestionView.heightAnchor.constraint(equalToConstant: isIpad ? 20 : 40)
        ])
    }
    
    private func showSuggestions() {
        suggestionView.insertSuggestions(list: suggestionCore.provideSuggestions(for: currentWord))
    }
    
    private func suggestionTapped(_ suggestion: String) {
        for _ in 0..<currentWord.count {
            textDocumentProxy.deleteBackward()
        }
        textDocumentProxy.insertText(suggestion)
        textDocumentProxy.insertText(" ")
        suggestionCore.wordTyped(word: suggestion)
        currentWord = ""
    }
    
    // MARK: - Keys Pressed Logic
    
    @objc private func onLongPressOfBackSpaceKey(_ gesture: UILongPressGestureRecognizer) {
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
    
    @objc private func touchedDownButton(_ sender: KeyboardButton) {
        tappedButton?.removeFromSuperview()

        let popUpColor = hasColoredBackground(sender.titleLabel?.text ?? "") ? selectedKeyboardType.backgroundColor : .systemWhite
        var heightMultiplier = DeviceTypes.olderIphone ? 2.8 : 2.6
        if DeviceTypes.olderIphone && isLandscape {
            heightMultiplier -= 0.3
        }

        let widthMultiplier = isLandscape ? 1.4 : 1.78
        
        let popUpView = KeyPopUp(frame: .zero, color: popUpColor)
        popUpView.label.setAttributedTitle(with: sender.titleLabel?.text ?? "", color: sender.titleLabel?.textColor ?? .orange)
        
        tappedButton = popUpView
        view.addSubview(popUpView)
        popUpView.translatesAutoresizingMaskIntoConstraints = false

        let width = sender.frame.width
        let height = sender.frame.height
        let heightAnchor: NSLayoutDimension = width > height ? sender.heightAnchor : sender.widthAnchor

        NSLayoutConstraint.activate([
            popUpView.bottomAnchor.constraint(equalTo: sender.bottomAnchor),
            popUpView.centerXAnchor.constraint(equalTo: sender.centerXAnchor),
            popUpView.widthAnchor.constraint(equalTo: sender.widthAnchor, multiplier: widthMultiplier),
            popUpView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: heightMultiplier)
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
        handleTappedCharacter(char: title)
    }

    func handleTappedCharacter(char: String) {
        tappedButton?.removeFromSuperview()
        playSound()

        textDocumentProxy.insertText(char)

        guard inuktitutCharacter(char) else {
            suggestionCore.wordTyped(word: currentWord.trimmingCharacters(in: .whitespaces))
            currentWord = ""
            return
        }
        currentWord.append(char)
    }
    
    private func resetState() {
        syllablesActive = false
        twoDotsActive = false
    }
    
    @objc private func firstSectionSelected() {
        resetState()
        playSound()
        selectedKeyboardType = .sectionOne
    }
    
    @objc private func secondSectionSelected() {
        resetState()
        playSound()
        selectedKeyboardType = .sectionTwo
    }
    
    @objc private func thirdSectionSelected() {
        resetState()
        playSound()
        selectedKeyboardType = .sectionThree
    }
    
    @objc private func fourthSectionSelected() {
        resetState()
        playSound()
        selectedKeyboardType = .sectionFour
    }
    
    @objc private func numericSectionSelected() {
        resetState()
        playSound()
        selectedKeyboardType = .numericSection
    }
    
    @objc private func arrowRightTapped() {
        playSound()
        textDocumentProxy.adjustTextPosition(byCharacterOffset: 1)
    }
    
    @objc private func arrowLeftTapped() {
        playSound()
        textDocumentProxy.adjustTextPosition(byCharacterOffset: -1)
    }
    
    @objc private func consonantsTapped() {
        playSound()
        syllablesActive.toggle()
        twoDotsActive = false
        addViewsToStackView()
    }
    
    @objc private func twoDotsTapped() {
        playSound()
        twoDotsActive.toggle()
        syllablesActive = false
        
        if selectedKeyboardType != .numericSection {
            selectedKeyboardType = .sectionOne
            return
        }
        
        addViewsToStackView()
    }
    
    @objc private func spaceTapped(){
        if spaceLastTapped.isDoubleTap {
            spaceDoubleTapped()
            return
        }
        playSound()
        textDocumentProxy.insertText(" ")
        suggestionCore.wordTyped(word: currentWord.trimmingCharacters(in: .whitespaces))
        currentWord = ""
        spaceLastTapped = Date()
        
    }
    
    private func spaceDoubleTapped() {
        playSound()
        textDocumentProxy.deleteBackward()
        textDocumentProxy.insertText(". ")
        suggestionCore.wordTyped(word: currentWord.trimmingCharacters(in: .whitespaces))
        currentWord = ""
    }
    
    @objc private func returnTapped() {
        playSound()
        textDocumentProxy.insertText("\n")
        suggestionCore.wordTyped(word: currentWord)
        currentWord = ""
    }
    
    @objc private func deleteTapped() {
        playSound()
        textDocumentProxy.deleteBackward()
        
        if !currentWord.isEmpty {
            currentWord.removeLast()
        }
    }
    
    @objc private func playSound() {
        inputView?.playInputClick​()
    }
}
