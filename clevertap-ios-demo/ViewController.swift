//
//  ViewController.swift
//  clevertap-ios-demo
//
//  Created by Dev Bathani on 14/04/25.
//

import UIKit
import CleverTapSDK

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    // UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private var textFields: [UITextField] = []
    private let functionDropdown = UITextField()
    private let functionPicker = UIPickerView()
    private let actionButton = UIButton()
    
    // Data
    private let functions = ["onUserLogin","getClevertapId","recordEvent","profilePush"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Setup ScrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        // Setup ContentView
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Set up constraints for scroll view
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        setupTitleLabels()
        setupTextFields()
        setupFunctionDropdown()
        setupActionButton()
        
        // Add a height constraint for content view
        let contentViewHeightConstraint = contentView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
        contentViewHeightConstraint.priority = .defaultLow
        contentViewHeightConstraint.isActive = true
        
        // Handle keyboard dismissal
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupTitleLabels() {
        // Main title
        titleLabel.text = "Clevertap Flutter Demo"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // Subtitle
        subtitleLabel.text = "Enter the data to check the entry on dashboard"
        subtitleLabel.font = UIFont.systemFont(ofSize: 18)
        subtitleLabel.textAlignment = .left
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupTextFields() {
        let fieldLabels = ["Enter name", "Enter email", "Enter phone number", "Enter identity", "Enter Stuff"]
        var lastView: UIView = subtitleLabel
        
        for label in fieldLabels {
            // Label for text field
            let fieldLabel = UILabel()
            fieldLabel.text = label
            fieldLabel.font = UIFont.systemFont(ofSize: 16)
            fieldLabel.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(fieldLabel)
            
            // Text field
            let textField = UITextField()
            textField.borderStyle = .roundedRect
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.delegate = self
            contentView.addSubview(textField)
            textFields.append(textField)
            
            // Add sample data based on field type
            if label == "Enter name" {
                textField.text = "Dev Bathani"
            } else if label == "Enter email" {
                textField.text = "dev.bathani@clevertap.com"
                textField.keyboardType = .emailAddress
            } else if label == "Enter phone number" {
                textField.text = "+91 7202897611"
                textField.keyboardType = .phonePad
            } else if label == "Enter identity" {
                textField.text = "abc@123"
            } else if label == "Enter Stuff" {
                textField.text = "data"
            }
            
            NSLayoutConstraint.activate([
                fieldLabel.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: 20),
                fieldLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                fieldLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                
                textField.topAnchor.constraint(equalTo: fieldLabel.bottomAnchor, constant: 8),
                textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                textField.heightAnchor.constraint(equalToConstant: 44)
            ])
            
            lastView = textField
        }
    }
    
    private func setupFunctionDropdown() {
        // Function picker setup
            functionPicker.delegate = self
            functionPicker.dataSource = self
            
            // Create toolbar with Done button
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePicker))
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolbar.setItems([flexSpace, doneButton], animated: false)
            
            // Set up dropdown field
            functionDropdown.inputView = functionPicker
            functionDropdown.inputAccessoryView = toolbar
            functionDropdown.text = functions[0] // Default value
            functionDropdown.borderStyle = .roundedRect
            functionDropdown.translatesAutoresizingMaskIntoConstraints = false
            
            // Add dropdown chevron indicator with padding
            let chevronImage = UIImage(systemName: "chevron.down")
            let chevronImageView = UIImageView(image: chevronImage)
            chevronImageView.tintColor = .gray
            chevronImageView.contentMode = .scaleAspectFit
            
            // Create a container view for padding
            let paddingView = UIView()
            paddingView.translatesAutoresizingMaskIntoConstraints = false
            paddingView.addSubview(chevronImageView)
            chevronImageView.translatesAutoresizingMaskIntoConstraints = false
            
            // Set the size of the container and position the chevron inside with padding
            NSLayoutConstraint.activate([
                paddingView.widthAnchor.constraint(equalToConstant: 30), // Width of container including padding
                paddingView.heightAnchor.constraint(equalToConstant: 30),
                
                chevronImageView.centerYAnchor.constraint(equalTo: paddingView.centerYAnchor),
                chevronImageView.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor, constant: -8), // Right padding
                chevronImageView.widthAnchor.constraint(equalToConstant: 14),
                chevronImageView.heightAnchor.constraint(equalToConstant: 14)
            ])
            
            functionDropdown.rightView = paddingView
            functionDropdown.rightViewMode = .always
            
            contentView.addSubview(functionDropdown)
            
            // Position the dropdown below the last text field
            NSLayoutConstraint.activate([
                functionDropdown.topAnchor.constraint(equalTo: textFields.last!.bottomAnchor, constant: 30),
                functionDropdown.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                functionDropdown.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                functionDropdown.heightAnchor.constraint(equalToConstant: 44)
            ])
    }
    
    private func setupActionButton() {
        // Main action button
        actionButton.setTitle(functionDropdown.text, for: .normal)
        actionButton.backgroundColor = UIColor(hexString: "6EC6A9")
        actionButton.setTitleColor(.black, for: .normal)
        actionButton.layer.cornerRadius = 0
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        contentView.addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: functionDropdown.bottomAnchor, constant: 30),
            actionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            actionButton.heightAnchor.constraint(equalToConstant: 50),
            actionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func actionButtonTapped() {
        switch functionDropdown.text {
        case "onUserLogin":
            performOnUserLogin()
        case "recordEvent":
            performRecordEvent()
        case "profilePush":
            performProfilePush()
        case "getClevertapId":
            getCleverTapID()
        default:
            break
        }
    }
    
    @objc private func donePicker() {
        // Update button title when dropdown selection changes
        actionButton.setTitle(functionDropdown.text, for: .normal)
        functionDropdown.resignFirstResponder()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - CleverTap Functions
    
    private func performOnUserLogin() {
        guard let name = textFields[0].text,
              let email = textFields[1].text,
              let phone = textFields[2].text,
              let identity = textFields[3].text,
              !name.isEmpty, !email.isEmpty, !phone.isEmpty, !identity.isEmpty else {
            showAlert(title: "Error", message: "Please fill all the required fields")
            return
        }
        
        let profile: [String: Any] = [
            "Name": name,
            "Email": email,
            "Phone": phone,
            "Identity": identity
        ]
        
        CleverTap.sharedInstance()?.onUserLogin(profile)
        showAlert(title: "Success", message: "User profile updated with onUserLogin")
    }
    private func performProfilePush() {
        guard let name = textFields[0].text,
              let email = textFields[1].text,
              let phone = textFields[2].text,
              let identity = textFields[3].text,
              !name.isEmpty, !email.isEmpty, !phone.isEmpty, !identity.isEmpty else {
            showAlert(title: "Error", message: "Please fill all the required fields")
            return
        }
        
        let profile: [String: Any] = [
            "Name": name,
            "Email": email,
            "Phone": phone,
            "Identity": identity
        ]
        
        CleverTap.sharedInstance()?.profilePush(profile)
        showAlert(title: "Success", message: "User profile updated with onUserLogin")
    }
    
    private func performRecordEvent() {
        guard let eventName = textFields[4].text, !eventName.isEmpty else {
            showAlert(title: "Error", message: "Please enter an event name in the 'Enter Stuff' field")
            return
        }
        
        // Create dynamic properties dictionary
        let props = [
            "Product name": "Casio Chronograph Watch",
            "Category": "Mens Accessories",
            "Price": 59.99,
            "Date": NSDate()
        ] as [String : Any]
        
        // Record the event with CleverTap using the user-provided event name
        CleverTap.sharedInstance()?.recordEvent(eventName, withProps: props)
        
        showAlert(title: "Success", message: "Event '\(eventName)' recorded successfully")
    }
    
    private func getCleverTapID() {
        if let cleverTapID = CleverTap.sharedInstance()?.profileGetID() {
            showAlert(title: "CleverTap ID", message: cleverTapID)
        } else {
            showAlert(title: "Error", message: "Unable to fetch CleverTap ID.")
        }
    }

    
    
    // MARK: - Helper Functions
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if title ==  "CleverTap ID"{
            // Add Copy button
            alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { _ in
                UIPasteboard.general.string = message
            }))
        }
            
            
            // Add OK button
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            DispatchQueue.main.async { [weak self] in
                self?.present(alert, animated: true, completion: nil)
            }
    }
    
    // MARK: - UIPickerViewDelegate & DataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return functions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return functions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        functionDropdown.text = functions[row]
        // Update button title when dropdown selection changes
        actionButton.setTitle(functions[row], for: .normal)
    }
}

// MARK: - UIColor Extension for Hex

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
