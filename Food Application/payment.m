//
//  payment.m
//  Food Application
//
//  Created by Zainu Corporation on 10/07/2014.
//  Copyright (c) 2014 Zainu Corporation. All rights reserved.
//

#import "payment.h"
#import "quantity.h"
#import "WebService.h"
#import "Constants.h"
#import "paymentConfirmation.h"

@interface payment (){
UIPopoverController *splitters;
}
@end

@implementation payment{
    
    UIAlertView *error_alert;
    UIAlertView *alert;
    UITextField *toPay;
    NSNotificationCenter *notificationCenter;
    int original_amount;
    NSMutableArray *user_amounts;
    
}
static NSMutableArray *users;
static NSMutableArray *creditCardDetails;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+(NSMutableArray *) CreditCardArray{
    return creditCardDetails;
}

- (IBAction)payNow:(id)sender {
    
    [self performSegueWithIdentifier:@"confirmThePayment" sender:self];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    users = [[NSMutableArray alloc]init];
    user_amounts = [[NSMutableArray alloc]init];
    self.title = @"Payment";
    
    creditCardDetails = [[NSMutableArray alloc]init];
    
    notificationCenter = [NSNotificationCenter defaultCenter];
    
    self.personsTable.delegate = self;
    self.personsTable.dataSource = self;
    
    self.basketTable.delegate = self;
    self.basketTable.dataSource = self;
    
    [error_alert setAlertViewStyle:UIAlertViewStyleDefault];
    
    toPayAmount = 0;
    
    owed_amount = [NSString stringWithFormat:@"%i", toPayAmount];
    dollar_owed_amount = [@"$" stringByAppendingString:owed_amount];
    self.amountOwed.text = dollar_owed_amount;
    
    alert =[[UIAlertView alloc ] initWithTitle:@"Add a friend" message:@"Add 3 digit CVC number with Hyphen seperated" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    
    [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    UITextField *userDate = [alert textFieldAtIndex:0];
    [userDate setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];

    userDate.placeholder=@"mm/yy";
    [[alert textFieldAtIndex:1] setSecureTextEntry:NO];
    
    UITextField *cardNumber= [alert textFieldAtIndex:1];
        [cardNumber setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    cardNumber.placeholder=@"Credit Card Number - CVC Number";
    [alert addButtonWithTitle:@"Done"];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button Index =%d",buttonIndex);
    if (buttonIndex == 1) {  //Login
        UITextField *username = [alertView textFieldAtIndex:0];
        UITextField *userCard = [alertView textFieldAtIndex:1];
        
        NSString *date = username.text;
        NSArray *enteredDate = [date componentsSeparatedByString: @"/"];
        NSString *month = [enteredDate objectAtIndex: 0];
        NSString *Year = [enteredDate objectAtIndex: 1];
        
        NSString *number = userCard.text;
        NSArray *enteredNumber = [number componentsSeparatedByString: @"-"];
        NSString *creditCard = [enteredNumber objectAtIndex: 0];
        NSString *CVC = [enteredNumber objectAtIndex: 1];
        
        NSMutableDictionary *testing = [[NSMutableDictionary alloc]init];
        [testing setValue:month forKey:@"user_month"];
        [testing setValue:Year forKey:@"user_year"];
        [testing setValue:creditCard forKey:@"user_number"];
        [testing setValue:CVC forKey:@"user_cvc"];
        [testing setValue:@"100" forKey:@"user_amount"];
        
        [creditCardDetails addObject:testing];
        [users addObject:testing];

        username.text = nil;
        userCard.text = nil;

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
    if(tableView == self.personsTable){
    NSLog(@"users length is : %d",[users count]);
    return [users count];
    }
    else{
        return [[quantity myBasketArray] count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section

{
    tableView.sectionHeaderHeight = 30.0;
    if(tableView == self.personsTable) {
    
        return @"Name        Number                      Amount ";
}
    else{
        return @"Item                             Price";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSLog(@"Index: %@ ",indexPath.row);
    static NSString *simpleTableIdentifierr = @"SimpleTableCell";
    UITableViewCell *cell;
    
    if(tableView == self.personsTable){
    
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifierr];
        }
    
    NSString *CcN = [[users valueForKey:@"user_number"] objectAtIndex:indexPath.row];
    NSString *Cvc = [[users valueForKey:@"user_cvc"] objectAtIndex:indexPath.row];
    NSString *month = [[users valueForKey:@"user_month"] objectAtIndex:indexPath.row];
    NSString *year = [[users valueForKey:@"user_year"] objectAtIndex:indexPath.row];
        NSLog(@"the CcN is %@",CcN);
        NSLog(@"the Cvc is %@",Cvc);
        NSLog(@"the month is %@",month);
        NSLog(@"the year is %@",year);
        
        cell.textLabel.text = [month stringByAppendingString:year];
    UILabel *creditCardNumber = [[UILabel alloc]initWithFrame:CGRectMake(60, 16, 150, 12)];
        
    creditCardNumber.text = [CcN stringByAppendingString:Cvc];
        
        NSLog(@"The CVC number is %@",[[users valueForKey:@"user_cvc"] objectAtIndex:indexPath.row]);
        
    creditCardNumber.textColor = [UIColor blueColor];
    
    toPay = [[UITextField alloc]initWithFrame:CGRectMake(230, 10, 50, 24)];
    toPay.backgroundColor = [UIColor lightGrayColor];
    //toPay.text = [[users valueForKey:@"user_number" ] objectAtIndex:indexPath.row];
    toPay.textColor = [UIColor blackColor];
        toPay.placeholder = [[users valueForKey:@"user_amount"] objectAtIndex:indexPath.row];
    [toPay setKeyboardType:UIKeyboardTypeNumberPad];
    toPay.tag = indexPath.row;
    [toPay addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
        
    [user_amounts addObject:toPay.text];
        toPay.text = 0;
    
    [cell addSubview:toPay];
    [cell addSubview:creditCardNumber];
    
    return cell;
    }
    else
    {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifierr];
    }
        
        cell.textLabel.text = [[[quantity myBasketArray] valueForKey:@"product_name"] objectAtIndex:indexPath.row];
        
        UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(260, 12, 140, 20)];
        price.text = [[[quantity myBasketArray] valueForKey:@"product_price"] objectAtIndex:indexPath.row];
        price.textColor = [UIColor blueColor];
        
        toPayAmount = toPayAmount + [price.text intValue];
        
        self.amountOwed.text = price.text;
        [cell addSubview:price];
        
        owed_amount = [NSString stringWithFormat:@"%i", toPayAmount];
        dollar_owed_amount = [@"$" stringByAppendingString:owed_amount];
        self.amountOwed.text = dollar_owed_amount;
        
        amount = toPayAmount;
        original_amount = amount;
        rem_amount = [NSString stringWithFormat:@"%i", amount];
        dollar_rem_amount = [@"$" stringByAppendingString:rem_amount];
        self.remainingAmount.text = dollar_rem_amount;
        return cell;
    }
}

- (void)textFieldDidChange:(UITextField *)sender{
    
    //getting the tag to update particular textfeild
    toPay = (UITextField *) sender;
    NSString *tag = [NSString stringWithFormat: @"%d", (int)toPay.tag];
    NSLog(@"tag: %@",tag);
    
    //updating the entered value
    NSString *temp_value = toPay.text;
    [[users objectAtIndex:toPay.tag] setValue:temp_value forKey:@"user_amount"];
    
    int collection=0;
    for(int i =0; i<[users count]; i++){
        NSString *collective_amount = [[users valueForKey:@"user_amount"] objectAtIndex:i];
       collection  = collection + [collective_amount intValue];
        
        NSLog(@"The collective amount is: %i",collection);
    }
    
    //value testing
    if(collection > original_amount)
    {
        amount = original_amount;
        error_alert =[[UIAlertView alloc] initWithTitle:@"Sorry" message:@"You have exceeded the total amount" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
        [error_alert show];
        
    }
    else
    {
        amount = original_amount - collection;
    }
        rem_amount = [NSString stringWithFormat:@"%i", amount];
        dollar_rem_amount = [@"$" stringByAppendingString:rem_amount];
        self.remainingAmount.text = dollar_rem_amount;
        [toPay resignFirstResponder];
}

- (IBAction)addUser:(id)sender {
    [alert show];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView * txt in self.view.subviews){
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
}

+(NSMutableArray *) usersArray{
    return users;
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    
    if ([segue.identifier isEqualToString:@"confirmThePayment"]) {
        paymentConfirmation *p = (paymentConfirmation*)segue.destinationViewController;
        p.finalAmount = [NSString stringWithFormat:@"%d",106];
    }
}

@end
