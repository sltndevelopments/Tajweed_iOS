//
//  Created by Tagir Nafikov on 18/03/2018.
//

import UIKit


class BookModuleViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Public properties
    
    var module: BookModule!
    

    // MARK: - View's lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = module.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(
            false,
            animated: true)
    }


    


}
