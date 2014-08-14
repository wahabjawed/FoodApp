//
//  quantity.h
//  Food Application
//
//  Created by Zainu Corporation on 09/08/2014.
//  Copyright (c) 2014 Zainu Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface quantity : UIViewController{
    int final;
    int basic;
    int quant;
    NSString *quanti;
    NSString *quantit;
    NSString *basePrice;
    NSString *finalPrice;
}
- (IBAction)negative:(id)sender;
- (IBAction)plus:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *basicPrice;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *product_name;
@property (weak, nonatomic) IBOutlet UILabel *quan;
@property (strong,nonatomic) NSString *prod_name;
@property (strong,nonatomic) NSString *prod_price;
@property (weak, nonatomic) IBOutlet UIButton *basket;

- (IBAction)addToBasket:(id)sender;


@end
