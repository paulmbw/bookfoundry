//
//  ViewController.swift
//  BookFoundry
//
//  Created by Paul Waweru on 05/01/2021.
//

import UIKit

class LibraryViewController: UITableViewController {
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		tableView.reloadData()
	}
	
	/**
	This SegueAction exists because we want to navigate from this screen (LibraryViewController) to the DetailViewController.
	*/
	@IBSegueAction func showDetailView(_ coder: NSCoder) -> DetailViewController? {
		// get the book for the row that is tapped
		guard let indexPath = tableView.indexPathForSelectedRow else { fatalError("Nothing selected!") }
		let book = Library.books[indexPath.row - 1]
		
		return DetailViewController(coder: coder, book: book)
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}
	
	/**
	Tells the table view how many rows to display for each section. E.g. if there are 50 books in one section, display 50 rows
	*/
	// MARK:- DataSource
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Library.books.count + 1
	}
	
	/**
	Used to set up each cell. This is where dequeueing happens. iPhone screens can only hold x amount of table view cells (if there are
	50 books, it can only show 15 at a time). When you start scrolling, the table view needs a new cell for each row that appears. If a brand new cell was created everytime the user scrolls down or creating views and deleting them continiously, this will create bad UX and potentially slow down the app. This is where the concept of dequeueing takes place. As you scroll, the tableview will dequeue any cell that is not visible on the screen (e.g. cell 1, max is 10). When you scroll to cell 11, cell 1 is requested using tableView.dequeueReusableCell and we set the contents of the cell on lines 32 to 34. This cell then appears as row 11, and so on so forth. Benefit: a smooth UX!
	*/
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		// if we are at the first section and first row, add a new cell
		if indexPath == IndexPath(row: 0, section: 0) {
			return tableView.dequeueReusableCell(withIdentifier: "NewBookCell", for: indexPath)
		}
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(BookCell.self)", for: indexPath) as? BookCell else { fatalError() }
		
		let book = Library.books[indexPath.row - 1]
		cell.titleLabel?.text = book.title
		cell.authorLabel?.text = book.author
		cell.bookmarkThumbnail?.image = book.image
		cell.bookmarkThumbnail.layer.cornerRadius = 12
		
		return cell
	}
}

