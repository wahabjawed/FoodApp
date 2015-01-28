//
//  login.m
//  Food Application
//
//  Created by Zainu Corporation on 10/07/2014.
//  Copyright (c) 2014 Zainu Corporation. All rights reserved.
//

#import "login.h"
#import <QuartzCore/QuartzCore.h>
#import "WebService.h"
#import "Constants.h"
#import "vendors.h"

@interface login (){
    UIAlertView *alert;
}

@end

@implementation login

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
    
    UIImage *backgroundImage = [UIImage imageNamed:@"countries_background.png"];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:backgroundImage];
    
    UIView *statusBarbg = [[UIView alloc] initWithFrame:CGRectMake(0, 0,320, 20)];
    statusBarbg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:statusBarbg];
    
    self.login_newUser.layer.cornerRadius = 7;
    self.login_newUser.clipsToBounds = YES;
    
    
    UIColor *color = [UIColor blueColor];
    self.login_email.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter Email" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.login_password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView * txt in self.view.subviews){
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
}

- (IBAction)Login:(id)sender {
    
    NSString *email = [[self login_email] text];
    NSString *password = [[self login_password] text];
    
    if([self.login_email.text isEqualToString:@""] ||[self.login_password.text isEqualToString:@""]) {
        // There's no text in the box.
        
        alert = [[UIAlertView alloc]initWithTitle:@"Incomplete Information" message:@" Please Fill the fields first." delegate:self cancelButtonTitle:Nil otherButtonTitles:@"OK", nil];
        [alert show];

    }
    else{
    NSMutableDictionary *loginJsonPost = [[NSMutableDictionary alloc] init];
    [loginJsonPost setValue:email forKey:@"email"];
    [loginJsonPost setValue:password forKey:@"password"];
    
    NSArray *LoginArray = [[NSArray alloc] initWithObjects:loginJsonPost, nil];
    
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:LoginArray
                        options:NSJSONWritingPrettyPrinted
                        error:&error];
    
    if ([jsonData length] > 0 &&
        error == nil)
    {
        NSString *LoginJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        WebService *loginRest = [[WebService alloc] init];
        NSArray *result = [loginRest FilePath:BASEURL LOGIN parameterOne:LoginJson];
        
        if([[result valueForKey:@"success"] isEqualToString:@"OK"]){
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"reveal_time"];
            vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:vc animated:YES completion:NULL];

        }
        else{
            alert = [[UIAlertView alloc]initWithTitle:@"Wrong Credentials" message:@"You have entered wrong email or password." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    }
}

- (IBAction)CreateNewUser:(id)sender {
}
@end
