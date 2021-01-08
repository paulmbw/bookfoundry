//
//  ViewController.swift
//  BookFoundry
//
//  Created by Paul Waweru on 05/01/2021.
//

import UIKit

class LibraryHeaderView: UITableViewHeaderFooterView {
	static let reuseIdentifier = "\(LibraryHeaderView.self)"
	@IBOutlet var titleLabel: UILabel!

}

class LibraryViewController: UITableViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		// register the custom header and tell the table view where to find it
		tableView.register(UINib(nibName: "\(LibraryHeaderView.self)", bundle: nil), forHeaderFooterViewReuseIdentifier: LibraryHeaderView.reuseIdentifier)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		tableView.reloadData()
	}
	
	/**
	Set the title of the section
	*/
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return section == 1 ? "Books to read!" : nil
	}
	/**
	This tells the table view controller how many sections it needs
	*/
	override func numberOfSections(in tableView: UITableView) -> Int {
		2
	}
	
	/**
	Tells the table view how many rows to display for each section. E.g. if there are 50 books in one section, display 50 rows
	*/
	// MARK:- DataSource
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return section == 0 ? 1 : Library.books.count
	}
	
	/**
	Sets the view for the header in the section
	*/
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		// we only want the header in the second section, so if this is the first section do nothing
		
		if section == 0 {
			return nil
		}
		
		guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: LibraryHeaderView.reuseIdentifier) as? LibraryHeaderView else { return nil }
		
		headerView.titleLabel.text = "Books to read!"
		
		return headerView
	}
	
	/**
	set the height for the header
	*/
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return section != 0 ? 60 : 0
	}
	
	/**
	This SegueAction exists because we want to navigate from this screen (LibraryViewController) to the DetailViewController.
	*/
	@IBSegueAction func showDetailView(_ coder: NSCoder) -> DetailViewController? {
		// get the book for the row that is tapped
		guard let indexPath = tableView.indexPathForSelectedRow else { fatalError("Nothing selected!") }
		let book = Library.books[indexPath.row]
		
		return DetailViewController(coder: coder, book: book)
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
		
		let book = Library.books[indexPath.row ]
		cell.titleLabel?.text = book.title
		cell.authorLabel?.text = book.author
		cell.bookmarkThumbnail?.image = book.image
		cell.bookmarkThumbnail.layer.cornerRadius = 12
		
		return cell
	}
}

