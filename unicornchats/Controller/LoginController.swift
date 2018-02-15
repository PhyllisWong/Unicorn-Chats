//
//  LoginController.swift
//  unicornchats
//
//  Created by Phyllis Wong on 2/1/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginController: UIViewController {
    
    // Create the container for user input
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        // Must set this property for the anchors to work
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
//        button.backgroundColor = UIColor(r: 210, g: 59, b: 124) // pink color
        button.backgroundColor = UIColor(r: 148, g: 194, b: 61) // lime green color
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    @objc func handleLogin() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        // call authentication fun from FirebaseAuth
        Auth.auth().signIn(withEmail: email, password: password) { (user: User?, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            // successfully logged in user
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @objc func handleRegister() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        // call authentication fun from FirebaseAuth
        Auth.auth().createUser(withEmail: email, password: password) { (user: User?, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            // Successfully authenticated user
            let ref = Database.database().reference(fromURL: "https://unicornchats.firebaseio.com/")
            let usersReference = ref.child("users").child(uid)
            
            let values = ["name": name, "email": email]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err!)
                    return
                }
                // Dissmiss view controller to view the appication
                self.dismiss(animated: true, completion: nil)
                print("Saved user successfully into Firebase db")
            })

        }
    }
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email address"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        // mask the text when the user types
        tf.isSecureTextEntry = true
        return tf
    }()

    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "unicorn")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        // default value is false
        imageView.isUserInteractionEnabled = true
        return imageView
        
    }()

    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    @objc func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        // When the login active: perform a check if the user data is correct
        loginRegisterButton.setTitle(title, for: .normal)
        
        // Change height of input container view
        inputContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        // Change height of nameTextField
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        // Change height of emailTextField
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
     
        // Change height of emailTextField
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    
   let footerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "drunk-unicorn")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        
        setUpContainerView()
        setUpLoginRegisterButton()
        setupProfileImageView()
        setupLoginRegisterSegmentedControl()
    }
    
  func setupFooterImageView() {
        // Need x, y, width, and height contraints
        footerImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        footerImageView.topAnchor.constraint(equalTo: loginRegisterButton.bottomAnchor, constant: 12).isActive = true
        footerImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        footerImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    
    func setupLoginRegisterSegmentedControl() {
        // Need x, y, width, and height contraints
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(lessThanOrEqualToConstant: 36).isActive = true
        
    }
    
    func setupProfileImageView() {
        // Need x, y, width, and height contraints
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    var inputContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    func setUpContainerView() {
        // Constraints for the containerView x, y, width, and height
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
            inputContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputContainerViewHeightAnchor?.isActive = true
        
        // All the subviews within the login Container View
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        
            // Contraints: x, y, width, and height of Name field
            nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
            nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
            nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
            nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
            nameTextFieldHeightAnchor?.isActive = true
        
                // Constraints for line below the Name
                nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
                nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
                nameSeparatorView.widthAnchor.constraint(equalTo: nameTextField.widthAnchor).isActive = true
                nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
            // Contraints: x, y, width, and height of Email field
            emailTextField.leftAnchor.constraint(equalTo: nameTextField.leftAnchor).isActive = true
            emailTextField.topAnchor.constraint(equalTo: nameSeparatorView.bottomAnchor).isActive = true
            emailTextField.widthAnchor.constraint(equalTo: nameTextField.widthAnchor).isActive = true
    
            emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor)
            emailTextFieldHeightAnchor?.isActive = true
        
                // Constraints for line below the email
                emailSeparatorView.leftAnchor.constraint(equalTo: nameSeparatorView.leftAnchor).isActive = true
                emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
                emailSeparatorView.widthAnchor.constraint(equalTo: emailTextField.widthAnchor).isActive = true
                emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
            // Constrain x, y, width, and height of Password text field
            passwordTextField.leftAnchor.constraint(equalTo: nameTextField.leftAnchor).isActive = true
            passwordTextField.topAnchor.constraint(equalTo: emailSeparatorView.bottomAnchor).isActive = true
            passwordTextField.widthAnchor.constraint(equalTo: emailTextField.widthAnchor).isActive = true
        
            passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor)
            passwordTextFieldHeightAnchor?.isActive = true
        
        
 
    }
    
    func setUpLoginRegisterButton() {
        // Need x, y, width, and height contraints
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // testing git
        loginRegisterButton.tintColor = UIColor.black
    }

    // Make the Status Bar Light/Dark Content for this View
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
        //return UIStatusBarStyle.default   // Make dark again
    }
  

}


extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
