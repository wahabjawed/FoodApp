//
//  countries.h
//  Food Application
//
//  Created by Zainu Corporation on 10/07/2014.
//  Copyright (c) 2014 Zainu Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface countries : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *countries_tableView;
@property (weak, nonatomic) IBOutlet UIButton *Enter;
@property NSMutableArray* SchoolList;
- (IBAction)press_enterButton:(id)sender;
@property (weak, nonatomic) NSString *locationid;

+ (NSMutableArray *)CurrentSessionLatitudeFunction;
+ (NSMutableArray *)CurrentSessionLongitudeFunction;
@end
