//
//  paymentConfirmation.m
//  Food Application
//
//  Created by Zainu Corporation on 10/07/2014.
//  Copyright (c) 2014 Zainu Corporation. All rights reserved.
//

#import "paymentConfirmation.h"
#import "STPCard.h"
#import "Stripe.h"
#import "WebService.h"
#import "payment.h"
#import "Constants.h"
#import "quantity.h"

@interface paymentConfirmation (){
    NSString *amount;
    int custom_counter;
    
    
}

@end

@implementation paymentConfirmation{
    BOOL threadStill;
}
static NSMutableArray *tokens;



- (IBAction)stripeRequestSend:(id)sender {
    
    custom_counter =0;
    

    
    tokens = [[NSMutableArray alloc] init];
    
    CLLocationCoordinate2D coordinates = [self getLocationFromAddressString:self.Address.text];
     NSLog(@"the latitude is: %f",coordinates.latitude);
     NSLog(@"the longitude is: %f",coordinates.longitude);
    NSLog(@"Button Clicked");
    
    for (int i=0; i<[[payment CreditCardArray]count]; i++ )
    {
        NSLog(@"loop index: %i", i);
        
        threadStill = YES;
        
        NSString *ccNumber = [[[payment CreditCardArray] valueForKey:@"user_number"]objectAtIndex:i];
        NSString *expMonth = [[[payment CreditCardArray] valueForKey:@"user_month"]objectAtIndex:i];
        NSString *expYear = [[[payment CreditCardArray] valueForKey:@"user_year"]objectAtIndex:i];
        NSString *cvc = [[[payment CreditCardArray] valueForKey:@"user_cvc"]objectAtIndex:i];
        amount = [[[payment CreditCardArray] valueForKey:@"user_amount"]objectAtIndex:i];
        
        STPCard *card = [[STPCard alloc] init];
        card.number = ccNumber;
        card.expMonth = [expMonth intValue];
        card.expYear = [expYear intValue];
        card.cvc = cvc;
        [Stripe createTokenWithCard:card completion:^(STPToken *token, NSError *error) {
            if (error) {
                [self handleError:error];
            } else {
                [self handleToken:token index:i];
            }
        }];
    }
    
    
    
    
}

- (void)handleError:(NSError *)error
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                      message:[error localizedDescription]
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                            otherButtonTitles:nil];
    [message show];
}

- (NSString *)handleToken:(STPToken *)token index:(int)index
{
    custom_counter = custom_counter + 1;
    
    NSLog(@"index: %i", index);
    NSLog(@"Count: %i" ,[[payment CreditCardArray]count]);
    NSString *price = [[[payment CreditCardArray] valueForKey:@"user_amount"]objectAtIndex:index];
    
    NSMutableDictionary *currentToken = [[NSMutableDictionary alloc] init];
    [currentToken setValue:token.tokenId forKey:@"token"];
    [currentToken setValue:price forKey:@"price"];
    
    [tokens addObject:currentToken];
    
    NSLog(@"TOKEN: %@", [currentToken valueForKey:@"token"]);
    NSLog(@"PRICE: %@", price);
   
    if([[payment CreditCardArray] count ] == custom_counter)
    {
        NSLog(@"condition met");
        WebService *w = [[WebService alloc] init];
        NSArray *returnArray = [w FilePath:STRIPE parameterOne:[NSString stringWithFormat:@"%@",[w convertingArrayIntoJsonString:[ paymentConfirmation tokensArray]]] parameterTwo:amount parameterThree:[NSString stringWithFormat:@"%@",[w convertingArrayIntoJsonString:[payment usersArray]]] parameterFour:[NSString stringWithFormat:@"%@",[w convertingArrayIntoJsonString:[quantity myBasketArray]]] ];
        NSLog(@"Return Array %@", returnArray);
    }
    
    
    threadStill = NO;
    
    
     return token.tokenId;
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
    self.Amount.text = self.finalAmount;
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    
    self.title = @"Done";
    
    self.Confirm.layer.cornerRadius = 7;
    self.Confirm.clipsToBounds = YES;
    
    UIColor *black = [UIColor blackColor];
    self.phoneNumber.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Phone Number" attributes:@{NSForegroundColorAttributeName: black}];
    
    self.Address.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Deleivery Address" attributes:@{NSForegroundColorAttributeName: black}];
    
    NSString *order_amount = @"100";
    NSString *ord_amt = [@"$" stringByAppendingString:order_amount];
    self.Amount.text = ord_amt;
    //CLLocationCoordinate2D *coordinates;
    
    NSLog(@"The month in payment is : %@",[[payment CreditCardArray ]valueForKey:@"user_month"]);
    
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

-(CLLocationCoordinate2D) getLocationFromAddressString:(NSString*) addressStr {
    
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;
    return center;
    
}

+(NSMutableArray *) tokensArray{
    return tokens;
}

//-(void) postUserCount{
//    
//    WebService *w = [[WebService alloc]init];
//    
//    [w FilePath:BASEURL TRANSACTION parameterOne:[NSString stringWithFormat:@"%@",[w convertingArrayIntoJsonString:[payment usersArray]]] parameterTwo:[NSString stringWithFormat:@"%@",[w convertingArrayIntoJsonString:[quantity myBasketArray]]]];
//    
//}


@end
