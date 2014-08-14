//
//  payment.m
//  Food Application
//
//  Created by Zainu Corporation on 10/07/2014.
//  Copyright (c) 2014 Zainu Corporation. All rights reserved.
//

#import "payment.h"

@interface payment ()

@end

@implementation payment{
    NSMutableArray *users;
    UIAlertView *alert;
}

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
    users = [[NSMutableArray alloc]init];
    self.title = @"Payment";
    
    self.personsTable.delegate = self;
    self.personsTable.dataSource = self;
    
    NSString *rem_amount = @"200";
    NSString *remai_amount = [@"$" stringByAppendingString:rem_amount];
    self.remainingAmount.text = remai_amount;
    
    NSString *owed_amount = @"50";
    NSString *owe_amount = [@"$" stringByAppendingString:owed_amount];
    self.amountOwed.text = owe_amount;
    
    alert =[[UIAlertView alloc ] initWithTitle:@"Payment Splitting" message:@"Add a Freind" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert addButtonWithTitle:@"Done"];
    
//    passwordAlert = [[UIAlertView alloc] initWithTitle:@"Server Password" message:@"\n\n\n"
//                                                           delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",nil) otherButtonTitles:NSLocalizedString(@"OK",nil), nil];
//    
//    passwordField = [[UITextField alloc] initWithFrame:CGRectMake(16,83,252,25)];
//    passwordField.font = [UIFont systemFontOfSize:18];
//    passwordField.backgroundColor = [UIColor whiteColor];
//    passwordField.keyboardAppearance = UIKeyboardAppearanceAlert;
//    passwordField.delegate = self;
//    [passwordField becomeFirstResponder];
//    [passwordAlert addSubview:passwordField];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button Index =%d",buttonIndex);
    if (buttonIndex == 1) {  //Login
        UITextField *username = [alertView textFieldAtIndex:0];
        //NSLog(@"username: %@", username);
        
        NSString *name = username.text;
        
        NSLog(@"users name is : %@",name);
        [users addObject:name];
        
    }
    [self.personsTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"users length is : %d",[users count]);
    return [users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSLog(@"Index: %@ ",indexPath.row);
    static NSString *simpleTableIdentifierr = @"SimpleTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifierr];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifierr];
    }
    
    cell.textLabel.text = [users objectAtIndex:indexPath.row];
    
    UILabel *creditCardNumber = [[UILabel alloc]initWithFrame:CGRectMake(150, 16, 120, 12)];
    creditCardNumber.text = @"53254235";
    creditCardNumber.textColor = [UIColor blueColor];
    [cell addSubview:creditCardNumber];
    
    return cell;
    
}

- (IBAction)addUser:(id)sender {
    [alert show];
}
@end
