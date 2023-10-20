import UIKit

class TableViewController: UITableViewController {

    var itemList: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }

    //add button click function
    @IBAction func addBtn(_ sender: Any) {
        showAddItemAlert()
    }


    //function to create a alert for add the item
    func showAddItemAlert() {
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Write an Item"
        }
        //adding the action cancel and confirm
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            if let textField = alert.textFields?.first, let item = textField.text, !item.isEmpty {
                self.addItem(item)
            }
        })
        present(alert, animated: true, completion: nil)
    }

    //logic to add item when we add it in list
    func addItem(_ item: String) {
        itemList.insert(item, at: 0)
        saveItems()
        tableView.reloadData()
    }
    
    //function to get data of todo list from userdefaults
    func loadItems() {
        if let savedItems = UserDefaults.standard.stringArray(forKey: "ToDoList") {
            itemList = savedItems
        }
    }

    //saving the todo item to userDefault
    func saveItems() {
        UserDefaults.standard.set(itemList, forKey: "ToDoList")
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rowOfCell", for: indexPath)
        cell.textLabel?.text = itemList[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedItem = itemList.remove(at: sourceIndexPath.row)
        itemList.insert(movedItem, at: destinationIndexPath.row)
        saveItems()
    }

    //delete by swapping the item function
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
               deleteItem(at: indexPath)
           }
       }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //deleting the item from the list
    func deleteItem(at indexPath: IndexPath) {
        itemList.remove(at: indexPath.row)
        saveItems()
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
}
