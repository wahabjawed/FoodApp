//
//  paymentConfirmation.m
//  Food Application
//
//  Created by Zainu Corporation on 10/07/2014.
//  Copyright (c) 2014 Zainu Corporation. All rights reserved.
//

#import "paymentConfirmation.h"

@interface paymentConfirmation ()

@end

@implementation paymentConfirmation

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"Done";
    
    self.Confirm.layer.cornerRadius = 7;
    self.Confirm.clipsToBounds = YES;
    
    UIColor *black = [UIColor blackColor];
    self.phoneNumber.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Phone Number" attributes:@{NSForegroundColorAttributeName: black}];
    
    self.Address.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Deleivery Address" attributes:@{NSForegroundColorAttributeName: black}];
    
    NSString *order_amount = @"200000";
    NSString *ord_amt = [@"$" stringByAppendingString:order_amount];
    self.Amount.text = ord_amt;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView * txt in self.view.subviews){
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
