//
//  Book.swift
//  BookFoundry
//
//  Created by Paul Waweru on 05/01/2021.
//

import UIKit

struct Book {
	let title: String
	let author: String
	var review: String?
	
	// computed property - if there is a photo of a book, use it, otherwise use the first letter of the book as an image
	var image: UIImage {
		Library.loadImage(forBook: self) ??
		LibrarySymbol.letterSquare(letter: title.first).image
	}
}
