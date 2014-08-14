//
//  login.h
//  Food Application
//
//  Created by Zainu Corporation on 10/07/2014.
//  Copyright (c) 2014 Zainu Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface login : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *login_newUser;
@property (weak, nonatomic) IBOutlet UIButton *login_enter;
- (IBAction)Login:(id)sender;

- (IBAction)CreateNewUser:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *login_email;
@property (weak, nonatomic) IBOutlet UITextField *login_password;

@end
