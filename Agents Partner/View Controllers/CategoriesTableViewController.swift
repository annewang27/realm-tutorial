
import UIKit
import RealmSwift
//
// MARK: - Categories Table View Controller
//
class CategoriesTableViewController: UITableViewController {
  //
  // MARK: - Variables And Properties
  //
    let realm = try! Realm()
    lazy var categories: Results<Category> = { self.realm.objects(Category.self) } ()
    var selectedCategory: Category!
    
  //
  // MARK: - View Controller
  //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateDefaultCategories()
    }
    
    private func populateDefaultCategories() {
        if categories.count == 0 {
            try! realm.write() {
                let defaultCategories = ["Birds", "Mammals", "Flora", "Reptiles", "Arachnids" ]
                
                for category in defaultCategories {
                    let newCategory = Category()
                    newCategory.name = category
                    
                    realm.add(newCategory)
                }
            }
            categories = realm.objects(Category.self)
        }
    }
    
}

//
// MARK: - Table View Data Source
//
extension CategoriesTableViewController {
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    
    let category = categories[indexPath.row]
    cell.textLabel?.text = category.name
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories.count
  }
  
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    selectedCategory = categories[indexPath.row]
    
    print(selectedCategory)
    
    return indexPath
  }
}
