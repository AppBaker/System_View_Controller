//
//  ViewController.swift
//  System View Controller
//
//  Created by Ivan Nikitin on 21/04/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import MessageUI
import SafariServices

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        activityIndicator.style = .whiteLarge
        // Do any additional setup after loading the view.
    }
    //MARK:- IB Actions
    @IBAction func shareButtonPressed(_ sender: Any) {
        activitiIndicator(run: true)
        guard let image = imageView.image else { return }
        let activityController = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil)
        present(activityController, animated: true) {
            self.activitiIndicator(run: false)
        }
    }
    @IBAction func safariButtonPressed(_ sender: Any) {
        activitiIndicator(run: true)
        let url = URL(string: "http://starrywings.ru")!
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true) {
            self.activitiIndicator(run: false)
        }
    }
    @IBAction func cameraButtonPressed(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        let alertController = UIAlertController(title: "Choose source", message: nil, preferredStyle: .actionSheet)
        let cancellAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
                self.activitiIndicator(run: true)
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true) {
                    self.activitiIndicator(run: false)
                }
            }
            alertController.addAction(cameraAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let photoLibraryAction = UIAlertAction(title: "Photo Libraty", style: .default) { action in
                self.activitiIndicator(run: true)
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true) {
                    self.activitiIndicator(run: false)
                }
            }
            alertController.addAction(photoLibraryAction)
        }
        
        alertController.addAction(cancellAction)
        present(alertController, animated: true)
    }
    @IBAction func emailButtonPressed(_ sender: Any) {
        activitiIndicator(run: true)
        guard MFMailComposeViewController.canSendMail() else {
            let alert = UIAlertController(title: "Can't send e-mail", message: nil, preferredStyle: .alert)
            let okllAction = UIAlertAction(title: "Ok", style: .cancel)
            alert.addAction(okllAction)
            present(alert, animated: true)
            activitiIndicator(run: false)
            return
        }
        
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients(["myEmail@ya.ru"])
        mailComposer.setSubject("Photo")
        mailComposer.setMessageBody("It's my favorite photo", isHTML: false)
        if let image = imageView.image?.pngData() {
            mailComposer.addAttachmentData(image, mimeType: "image/jpeg", fileName: "Photo")
        }

        present(mailComposer, animated: true) {
            self.activitiIndicator(run: false)
        }
        
    }
    @IBAction func messageButtonPressed(_ sender: Any) {
        activitiIndicator(run: true)
        guard MFMessageComposeViewController.canSendText() else {
            let alert = UIAlertController(title: "Can't send message", message: nil, preferredStyle: .alert)
            let okllAction = UIAlertAction(title: "Ok", style: .cancel)
            alert.addAction(okllAction)
            present(alert, animated: true)
            activitiIndicator(run: false)
            return
        }
        let messageComposer = MFMessageComposeViewController()
        messageComposer.messageComposeDelegate = self
        messageComposer.body = "Hello, it's my favorite photo"
        if let image = imageView.image?.pngData() {
            messageComposer.addAttachmentData(image, typeIdentifier: "public.png", filename: "Photo.png")
        }
        
        present(messageComposer, animated: true) {
            self.activitiIndicator(run: false)
        }
    }
    
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let data = info[UIImagePickerController.InfoKey.editedImage] else { return }
        let image = data as? UIImage
        imageView.image = image
        dismiss(animated: true)
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension ViewController: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true)
    }
}

extension ViewController: MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true)
    }
    
    
}

// MARK: - Custom Methods
extension ViewController {
    func activitiIndicator(run: Bool) {
        activityIndicator.isHidden = !run
        if run {
            view.alpha = 0.5
            activityIndicator.startAnimating()
        } else {
            view.alpha = 1
            activityIndicator.stopAnimating()
        }
    }
}
