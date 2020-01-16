
import UIKit
import RealmSwift

//
// MARK: - Add New Entry View Controller
//
class AddNewEntryViewController: UIViewController {
  @IBOutlet weak var categoryTextField: UITextField!
  @IBOutlet weak var descriptionTextField: UITextView!
  @IBOutlet weak var nameTextField: UITextField!
  
  //
  // MARK: - Variables And Properties
  //
  var selectedAnnotation: SpecimenAnnotation!
    var selectedCategory: Category!
    var specimen: Specimen!
    
  //
  // MARK: - IBActions
  //
  @IBAction func unwindFromCategories(segue: UIStoryboardSegue) {
    if segue.identifier == "CategorySelectedSegue" {
        let categoriesController = segue.source as! CategoriesTableViewController
        selectedCategory = categoriesController.selectedCategory
        print(selectedCategory)
        categoryTextField.text = selectedCategory.name
    }
  }
    
    func addNewSpecimen() {
        let realm = try! Realm()
        
        try! realm.write() {
            let newSpecimen = Specimen()
            
            newSpecimen.category = selectedCategory
            print(newSpecimen.category)
            newSpecimen.name = nameTextField.text!
            newSpecimen.specimenDescription = descriptionTextField.text!
            newSpecimen.latitude = selectedAnnotation.coordinate.latitude
            newSpecimen.longitude = selectedAnnotation.coordinate.longitude
            
            realm.add(newSpecimen)
            specimen = newSpecimen
        }
    }
    
    func fillTextFields() {
      nameTextField.text = specimen.name
      categoryTextField.text = specimen.category.name
      descriptionTextField.text = specimen.specimenDescription

      selectedCategory = specimen.category
    }
    
    func updateSpecimen() {
      let realm = try! Realm()
        
      try! realm.write {
        specimen.name = nameTextField.text!
        specimen.category = selectedCategory
        specimen.specimenDescription = descriptionTextField.text
      }
    }
  
  //
  // MARK: - Private Methods
  //
  func validateFields() -> Bool {
    if nameTextField.text!.isEmpty || descriptionTextField.text!.isEmpty || selectedCategory == nil {
      let alertController = UIAlertController(title: "Validation Error",
                                              message: "All fields must be filled",
                                              preferredStyle: .alert)
      
      let alertAction = UIAlertAction(title: "OK", style: .destructive) { alert in
        alertController.dismiss(animated: true, completion: nil)
      }
      
      alertController.addAction(alertAction)
      
      present(alertController, animated: true, completion: nil)
      
      return false
    } else {
      return true
    }
  }
  
  //
  // MARK: - View Controller
  //
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let specimen = specimen {
      title = "Edit \(specimen.name)"
          
      fillTextFields()
    } else {
      title = "Add New Specimen"
    }
  }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if validateFields() {
            if specimen != nil {
              updateSpecimen()
            } else {
              addNewSpecimen()
            }
            
            return true
        } else {
            return false
        }
    }
}

//
// MARK: - Text Field Delegate
//
extension AddNewEntryViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    performSegue(withIdentifier: "Categories", sender: self)
  }
}
