//
//  menu.h
//  Food Application
//
//  Created by Zainu Corporation on 10/07/2014.
//  Copyright (c) 2014 Zainu Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface menu : UIViewController{
    BOOL checkboxSelected;
}

@property (weak, nonatomic) IBOutlet UIButton *proceedCheckout;
@property (weak,nonatomic) NSString *vendorId;

@end
