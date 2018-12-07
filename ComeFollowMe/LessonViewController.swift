//
//  LessonViewController.swift
//  ComeFollowMe
//
//  Created by Kyle Gill on 12/7/18.
//  Copyright © 2018 Razeware. All rights reserved.
//

import UIKit
import CoreData

class LessonViewController : UITableViewController, UITextViewDelegate {
  // MARK - Constants
  private struct Storyboard {
    static let cornerRadius: CGFloat = 5.0
    static let borderWidth: CGFloat = 1.0
  }
  
  // MARK - Properties
//  var lessonName = ""
//  var lessonGoal = ""
//  var lessonNotes = ""
//  var lessonStartDate = ""
//  var lessonEndDate = ""
  var lesson: NSManagedObject?
  var lessonId = 1
  
  // MARK - Outlets
  @IBOutlet weak var lessonTitle: UILabel!
  @IBOutlet weak var goalTextView: UITextView!
  @IBOutlet weak var notesTextView: UITextView!
  @IBOutlet weak var lessonDateRange: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // remove table cell lines
    self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    title = "Lesson Journal"
    
    // assign delegates for text views
    self.goalTextView.delegate = self
    self.notesTextView.delegate = self
    
    if let lesson = lesson {
      lessonTitle.text = lesson.value(forKey: "name") as? String
      goalTextView.text = lesson.value(forKey: "goal") as? String
      notesTextView.text = lesson.value(forKey: "notes") as? String
      let startdate: String = lesson.value(forKey: "startdate") as? String ?? ""
      let enddate: String = lesson.value(forKey: "enddate") as? String ?? ""
      lessonDateRange.text = startdate + " - " + enddate
    }
    
    goalTextView.layer.cornerRadius = Storyboard.cornerRadius
    goalTextView.layer.borderColor = UIColor.lightGray.cgColor
    goalTextView.layer.borderWidth = Storyboard.borderWidth
    notesTextView.layer.cornerRadius = Storyboard.cornerRadius
    notesTextView.layer.borderColor = UIColor.lightGray.cgColor
    notesTextView.layer.borderWidth = Storyboard.borderWidth
  }
  
  // MARK - DELEGATES
  func textViewDidEndEditing(_ textView: UITextView) {
    print("Saving input...")
    saveLesson()
  }
  
  // MARK - Helpers
  private func saveLesson() {
    print("find right thing to update here")
    if let lesson = lesson {
      print(goalTextView.text)
      lesson.setValue(goalTextView.text, forKey: "goal")
      lesson.setValue(notesTextView.text, forKey: "notes")
    }
  }
}

