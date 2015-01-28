//
//  quantity.h
//  Food Application
//
//  Created by Zainu Corporation on 09/08/2014.
//  Copyright (c) 2014 Zainu Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface quantity : UIViewController{
    double final;
    double basic;
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
@property (strong,nonatomic) NSString *prod_vendor_id;
@property (strong,nonatomic) NSString *prod_item_id;
@property (weak, nonatomic) IBOutlet UIButton *basket;

+(NSMutableArray*) myBasketArray;

- (IBAction)addToBasket:(id)sender;


@end
