//
//  paymentConfirmation.h
//  Food Application
//
//  Created by Zainu Corporation on 10/07/2014.
//  Copyright (c) 2014 Zainu Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface paymentConfirmation : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *Address;
@property (weak, nonatomic) IBOutlet UIButton *Confirm;
@property (weak, nonatomic) IBOutlet UILabel *Amount;
@property (weak,nonatomic) NSString *finalAmount;
-(CLLocationCoordinate2D) getLocationFromAddressString:(NSString*) addressStr;
+(NSMutableArray *) tokensArray;
@end
