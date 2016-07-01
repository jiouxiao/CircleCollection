//
//  CircleCollectionView.swift
//  SwiftTest
//
//  Created by  wangzi on 16/6/30.
//  Copyright © 2016年 Compony. All rights reserved.
//

import Foundation
import UIKit



@objc protocol CircleCollectionDelegate {
    func collectionCell(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
}

class ItemData{
    var title: String = ""
    var imagePath: String = ""
}

class CollectionImageCell: UICollectionViewCell {
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.lightGrayColor()
        return imageView
    }()
    var title: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .Left
        label.font = UIFont.systemFontOfSize(14)
        label.textColor = UIColor.blackColor()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.imageView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        self.contentView.addSubview(self.imageView)
        self.title.frame = CGRect(x: 100, y: 100, width: frame.size.width, height: 30)
        self.contentView.addSubview(self.title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CircleCollectionView: UICollectionView, UICollectionViewDelegate,UICollectionViewDataSource {
    
    private var layout: UICollectionViewFlowLayout
    private let identContentStr: String = "idenContentString"
    var itemArray: NSMutableArray = NSMutableArray()
    private var itemCount: NSInteger = 0
    var curIndex: NSInteger = 0
    
    override var frame: CGRect{
        didSet{
            self.layout.itemSize = CGSizeMake(self.frame.width, self.frame.height)
            self.setCollectionViewLayout(self.layout, animated: true)
        }
    }
    
    var circleDelegate: CircleCollectionDelegate?
    
    init(frame: CGRect){
        
        self.layout = UICollectionViewFlowLayout.init()
        self.layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        self.layout.itemSize = CGSizeMake(frame.size.width, frame.size.height)
        self.layout.minimumLineSpacing = 0
        super.init(frame: frame, collectionViewLayout: self.layout)
        
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = UIColor.blueColor()
        self.pagingEnabled = true
        self.registerClass(CollectionImageCell.self, forCellWithReuseIdentifier: self.identContentStr)
        
    }
    
    convenience override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        self.init(frame: frame);
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        if let del = self.circleDelegate{
            return del.collectionCell(collectionView, cellForItemAtIndexPath: indexPath)
        }else{
            let cell:CollectionImageCell = collectionView.dequeueReusableCellWithReuseIdentifier(self.identContentStr, forIndexPath: indexPath) as! CollectionImageCell
            
            let index = indexPath.row % self.itemArray.count
            let curItem = self.itemArray.objectAtIndex(index) as! ItemData
            
            
            let tImage =  UIImage(contentsOfFile: curItem.imagePath)
            
            cell.imageView.image = tImage
            cell.title.text = curItem.title
            return cell
        }
    }
    
    func dispatchReload() {
        dispatch_async(dispatch_get_main_queue(), {
            [unowned self]() -> Void in
            self.reloadData()
            });
    }
    
    func dispatchReloadAndRepositioned(){
        dispatch_async(dispatch_get_main_queue(), {
            [unowned self]() -> Void in
            self.reloadData()
            let offX:CGFloat = self.frame.size.width * (CGFloat)(self.itemArray.count)
            self.contentOffset = CGPoint(x: offX, y: 0)
            });
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.row == (self.itemCount - 2){
            self.itemCount += self.itemArray.count
            self.dispatchReload()
            
        } else if indexPath.row == 1{
            self.itemCount += self.itemArray.count
            self.dispatchReloadAndRepositioned()
        }
        
        self.curIndex = indexPath.row % self.itemArray.count
    }
    
    func addCollectionItems(items: NSArray){
        self.itemArray.removeAllObjects()
        self.itemArray.addObjectsFromArray(items as [AnyObject])
        self.itemCount = self.itemArray.count*2
        self.dispatchReloadAndRepositioned()
    }

}
