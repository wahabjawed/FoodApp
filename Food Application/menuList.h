//
//  menuList.h
//  Food Application
//
//  Created by Zainu Corporation on 17/08/2014.
//  Copyright (c) 2014 Zainu Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface menuList : UITableViewController
@property (strong, nonatomic) IBOutlet UITableView *product_table;
@property (weak, nonatomic) IBOutlet UIButton *proceed;

@property (weak,nonatomic) NSString *vendorId;

@end
