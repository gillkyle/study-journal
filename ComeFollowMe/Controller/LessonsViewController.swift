//
//  LessonsViewController.swift
//  ComeFollowMe
//
//  Created by Kyle Gill on 12/5/18.
//  Copyright © 2018 Kyle Gill. All rights reserved.
//

import UIKit
import CoreData

class LessonsViewController : UITableViewController {
  // MARK - Constants
  private struct Storyboard {
    static let LessonCellIdentifier = "LessonTitleCell"
    static let ShowLessonSegue = "ShowLesson"
  }
  
  // MARK - Properties
  var lessons: [NSManagedObject] = []
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Lesson")
    
    do {
      lessons = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Storyboard.ShowLessonSegue {
      if let lessonVC = segue.destination as? LessonViewController {
        if let indexPath = sender as? IndexPath {
          lessonVC.lesson = lessons[indexPath.row]
          lessonVC.lessonId = indexPath.row + 1
        }
      }
    }
  }
  
  // MARK - Table View data source
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return lessons.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.LessonCellIdentifier, for: indexPath)
    cell.textLabel?.text = lessons[indexPath.row].value(forKey: "name") as? String
    cell.detailTextLabel?.text = lessons[indexPath.row].value(forKey: "startdate") as? String
    
    return cell
  }
  
  // MARK - Table View delegate
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: Storyboard.ShowLessonSegue, sender: indexPath)
  }
}
