import UIKit

/**
This class represents the Detail View Controller in IB. Every view controller (or screen) needs a corresponding
class that implements the UIViewController protocol
*/
class DetailViewController: UITableViewController {
	let book: Book
	
	@IBOutlet var titleLable: UILabel!
	@IBOutlet var authorLabel: UILabel!
	@IBOutlet var imageView: UIImageView!
	@IBOutlet var reviewTextView: UITextView!
	
	@IBAction func updateImage() {
		let imagePicker = UIImagePickerController()
		// this is the class delegating the image picker functionality
		imagePicker.delegate = self
		imagePicker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
		imagePicker.allowsEditing = true
		present(imagePicker, animated: true)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		imageView.image = book.image
		imageView.layer.cornerRadius = 16
		titleLable.text = book.title
		authorLabel.text = book.author
		
		if let review = book.review {
			reviewTextView.text = review
		}
		
		reviewTextView.addDoneButton()
	}
	
	// I don't understand this :S
	required init?(coder: NSCoder) {
		fatalError("This should never be called!")
	}
	
	// I think this is similar to constuctor in JS 
	init?(coder: NSCoder, book: Book) {
		self.book = book
		super.init(coder: coder)
	}
}

/**
We need to tell the picker what to do when we selected a pic or taken a photo using UIImagePickerControllerDelegate.
We also want UINavigationControllerDelegate so that we can present this view
*/
extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	// This specifies what to do once we have a new image
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		
		guard let selectedImage = info[.editedImage] as? UIImage else { return }
		// updates the image in the detail view
		imageView.image = selectedImage
		
		Library.saveImage(selectedImage, forBook: book)
		
		dismiss(animated: true)
	}
}

// We need to ask for permission for the app to access the photo library or camera. This is done in Info.plist

// Tells this view controller it is a UITextViewDelegate. This helps with dismissing the keyboard
extension DetailViewController: UITextViewDelegate {
	func textViewDidEndEditing(_ textView: UITextView) {
		textView.resignFirstResponder()
	}
}

extension UITextView {
	func addDoneButton(){
		let toolbar = UIToolbar()
		toolbar.sizeToFit()
		
		let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.resignFirstResponder))
		
		toolbar.items = [flexSpace, doneButton]
		self.inputAccessoryView = toolbar
	}
}
