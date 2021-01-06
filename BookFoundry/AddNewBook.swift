import UIKit

class AddNewBookViewController: UITableViewController {
	@IBOutlet var titleTextField: UITextField!
	@IBOutlet var authorTextField: UITextField!
	@IBOutlet var bookImageView: UIImageView!
	
	@IBAction func updateImage(){
		let imagePicker = UIImagePickerController()
		// this is the class delegating the image picker functionality
		imagePicker.delegate = self
		imagePicker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
		imagePicker.allowsEditing = true
		present(imagePicker, animated: true)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		bookImageView.layer.cornerRadius = 17
	}
}

/**
We need to tell the picker what to do when we selected a pic or taken a photo using UIImagePickerControllerDelegate.
We also want UINavigationControllerDelegate so that we can present this view
*/
extension AddNewBookViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	// This specifies what to do once we have a new image
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		
		guard let selectedImage = info[.editedImage] as? UIImage else { return }
		// updates the image in the detail view
		bookImageView.image = selectedImage
		
	//	Library.saveImage(selectedImage, forBook: book)
		
		dismiss(animated: true)
	}
}

/**
if the first field is the text field, set the return key to "next". Else, set it to "done". This helps with navigating
between different input fields using the keyboard
*/
extension AddNewBookViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField == titleTextField {
			return authorTextField.becomeFirstResponder()
		} else {
			return textField.resignFirstResponder()
		}
	}
}
