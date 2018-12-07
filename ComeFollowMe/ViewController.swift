/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import CoreData

class ViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  var people: [NSManagedObject] = []
  var lessons: [NSManagedObject] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Lessons"
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
  }

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

  @IBAction func addName(_ sender: UIBarButtonItem) {
    let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .alert)

    let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in

      guard let textField = alert.textFields?.first,
        let nameToSave = textField.text else {
          return
      }

      self.save(name: nameToSave)
      self.tableView.reloadData()
    }

    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    alert.addTextField()
    alert.addAction(saveAction)
    alert.addAction(cancelAction)

    present(alert, animated: true)
  }

  func save(name: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: "Lesson", in: managedContext)!
    let lesson = NSManagedObject(entity: entity, insertInto: managedContext)
    lesson.setValue(name, forKeyPath: "name")

    do {
      try managedContext.save()
      lessons.append(lesson)
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }
}



// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
  // MARK - Constants
  private struct Storyboard {
    static let ShowLessonSegue = "ShowLesson"
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return lessons.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let lesson = lessons[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.textLabel?.text = lesson.value(forKeyPath: "name") as? String
    return cell
  }
  

  
  // MARK: - Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Storyboard.ShowLessonSegue {
      if let lessonVC = segue.destination as? LessonViewController {
        if let indexPath = sender as? IndexPath {
          lessonVC.lesson = lessons[indexPath.row]
          lessonVC.lessonId = indexPath.row
        }
      }
    }
  }
}

// MARK - Table View delegate
extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print(indexPath)
    performSegue(withIdentifier: Storyboard.ShowLessonSegue, sender: indexPath)
  }
}
