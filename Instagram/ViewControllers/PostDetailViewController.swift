//
//  PostDetailViewController.swift
//  Instagram
//
//  Created by Chung Tran on 04/04/2019.
//  Copyright © 2019 Chung Tran. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController, StoryboardInitializableViewController {

    var post: Post!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.sd_setImage(with: URL(string: post.image))
        captionLabel.text = post.caption
        likesCountLabel.text = "\(post.likesCount)"
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
