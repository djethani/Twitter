//
//  NavBarController.swift
//  Twitter
//
//  Created by Dimple Jethani on 6/29/16.
//  Copyright © 2016 Dimple Jethani. All rights reserved.
//

import UIKit

class NavBarController: UINavigationController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationBar.barStyle = UIBarStyle.Black
        self.navigationBar.tintColor = UIColor.whiteColor()
        
    //    navigationController!.navigationBar.titleTextAttributes =
     //       [NSForegroundColorAttributeName: UIColor.whiteColor()]
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
