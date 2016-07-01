//
//  ViewController.swift
//  SwiftTest
//
//  Created by  wangzi on 16/6/23.
//  Copyright © 2016年 Compony. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CircleCollectionDelegate {
    
    let adX: CGFloat = 0
    let adY: CGFloat = 44
    var adWidth: CGFloat!
    let adHeight: CGFloat = 200
    
    var circleView: CircleCollectionView!
    
    
    class CollectionTest: UICollectionViewCell {
        
        var imageView: UIImageView = {
           let imageView = UIImageView()
            imageView.backgroundColor = UIColor.lightGrayColor()
            return imageView
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            self.imageView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
            self.contentView.addSubview(self.imageView)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initUI()
        
        self.testUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initUI() {
        self.navigationController?.navigationBar.hidden = true
        self.view.backgroundColor = UIColor.redColor()
    }
    
    func initCollectionView() {
        
        self.adWidth = self.view.frame.size.width
        
        
        self.circleView = CircleCollectionView.init(frame: CGRect(x: self.adX, y: self.adY, width: self.adWidth, height: self.adHeight))
        self.view.addSubview(self.circleView)
        
        let bundlePath = NSBundle.mainBundle().bundlePath
        
        let array = NSMutableArray()
        
        let item1: ItemData = ItemData()
        item1.imagePath = bundlePath+"/demo1.png"
        item1.title = "demo1"
        array.addObject(item1)
        
        let item2: ItemData = ItemData()
        item2.imagePath = bundlePath+"/demo2.png"
        item2.title = "demo2"
        array.addObject(item2)
        
        let item3: ItemData = ItemData()
        item3.imagePath = bundlePath+"/demo3.png"
        item3.title = "demo3"
        array.addObject(item3)
        
        let item4: ItemData = ItemData()
        item4.imagePath = bundlePath+"/demo4.png"
        item4.title = "demo4"
        array.addObject(item4)
        
        let item5: ItemData = ItemData()
        item5.imagePath = bundlePath+"/demo5.png"
        item5.title = "demo5"
        array.addObject(item5)
        
        
        circleView.addCollectionItems(array)
        
//        circleView.circleDelegate = self
        
        circleView.registerClass(CollectionTest.self, forCellWithReuseIdentifier: "testCell")
        
    }
    
    func collectionCell(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell:CollectionTest = collectionView.dequeueReusableCellWithReuseIdentifier("testCell", forIndexPath: indexPath) as! CollectionTest
        
            let index = indexPath.row % self.circleView.itemArray.count
            let curItem = self.circleView.itemArray.objectAtIndex(index) as! ItemData
        
        
            let tImage = UIImage(named: curItem.imagePath)
        
            cell.imageView.image = tImage
        
            return cell
    }
    

    final func testUI() {
        
        
        self.initCollectionView()
        
    
        let labelText: UILabel! = UILabel(frame: CGRect(x: 100, y: 400, width: 200, height: 30))
        labelText.text = "hellow world swift"
        self.view.addSubview(labelText)
    }
    
}

