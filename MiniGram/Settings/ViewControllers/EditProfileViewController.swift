//
//  EditProfileViewController.swift
//  MiniGram
//
//  Created by Diego Maceda on 4/3/20.
//  Copyright © 2020 Keegan Black. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var editProfileImageView: UIImageView!
    @IBOutlet weak var editNameTextField: UITextField!
    @IBOutlet weak var editUsernameTextField: UITextField!
    @IBOutlet weak var editEmailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        editProfileImageView.roundCorners(editProfileImageView.frame.size.width / 2)
        editNameTextField.underlined()
        editUsernameTextField.underlined()
        editEmailTextField.underlined()
    }
    
    @IBAction func changeProfilePhoto(_ sender: Any) {
        let controller = UIAlertController(
            title: nil, message: nil,
            preferredStyle: .actionSheet)
        
        controller.addAction(UIAlertAction(
            title: "Take Photo",
            style: .default,
            handler: nil))
        controller.addAction(UIAlertAction(
            title: "Choose from Library",
            style: .default,
            handler: nil))
        controller.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil))
        
        present(controller, animated: true, completion: nil)
    }
}