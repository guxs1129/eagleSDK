//
//  EGChainKitHeader.h
//  ChainProperty
//
//  Created by TengShuQiang on 2017/12/25.
//  Copyright © 2017年 TTeng. All rights reserved.
//

#ifndef EGChainKitHeader_h
#define EGChainKitHeader_h

#import <UIKit/UIKit.h>

#import "EGChainKitForUIView.h"
#import "EGChainKitForUIControl.h"
#import "EGChainKitForUILabel.h"
#import "EGChainKitForUIScrollView.h"
#import "EGChainKitForUIButton.h"
#import "EGChainKitForUIImageView.h"
#import "EGChainKitForUITextView.h"
#import "EGChainKitForUITextField.h"
#import "EGChainKitForUITableView.h"
#import "EGChainKitForUICollectionViewFlowLayout.h"
#import "EGChainKitForUICollectionView.h"

#import "EGChainKitForCALayer.h"

#endif /* EGChainKitHeader_h */


//这里，UILabel的链不能直接调用UIView链上的属性或方法，需要先调用到UIView的链上面，也就是.viewMaker(),同样的，其他子类也要调用父类的时候属性或方法的时候也需要这么做，同时，父类也可以再调用到子类的链上面，比如.labelMaker()
//
//要注意的一点，调用到CALayer的链.layerMaker()之后，不能再回调回来，所以，最好在最后调用Layer链。因为这个属性的特殊性，每个子类都能直接调用.layerMaker()
//
//目前支持的类有UIView,UILabel,UIScrollView,UITableView,UICollectionView,UICollectionViewFlowLayout,UIControl UIButton,UITextView,UITextField,UIImageView,还有CALayer
//
//作为UITextField和UITextView最常用且比较容易忽略的UITextInputTraits协议中的方法，这里分别复制到了UITextField和UITextView 两个类中，以便使用。。。我在想UIControl中的方法要不要也复制到UIButton和UITextField中去。。。

