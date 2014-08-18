//
//  payment.h
//  Food Application
//
//  Created by Zainu Corporation on 10/07/2014.
//  Copyright (c) 2014 Zainu Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface payment : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSString *rem_amount;
    NSString *dollar_rem_amount;
    NSString *owed_amount;
    NSString *dollar_owed_amount;
    int amount;
    int toPayAmount;
}
@property (weak, nonatomic) IBOutlet UITableView *personsTable;
@property (weak, nonatomic) IBOutlet UITableView *basketTable;
@property (weak, nonatomic) IBOutlet UIButton *addComment;
@property (weak, nonatomic) IBOutlet UILabel *remainingAmount;
@property (weak, nonatomic) IBOutlet UILabel *amountOwed;
@property (weak, nonatomic) IBOutlet UIButton *addUser;
- (IBAction)addUser:(id)sender;


@end
