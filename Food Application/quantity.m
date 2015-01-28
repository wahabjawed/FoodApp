//
//  quantity.m
//  Food Application
//
//  Created by Zainu Corporation on 09/08/2014.
//  Copyright (c) 2014 Zainu Corporation. All rights reserved.
//

#import "quantity.h"
#import "menuList.h"


@interface quantity ()

@end

@implementation quantity{
    
}
static NSMutableArray* vendor_items_array;


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
    
    if(vendor_items_array == nil){
        vendor_items_array = [[NSMutableArray alloc]init];
    }

    self.product_name.text = self.prod_name;
    
    self.basicPrice.text = self.prod_price;
    self.totalPrice.text = self.basicPrice.text;
    basic = [self.basicPrice.text intValue];
    
    quant = 1;
    quanti = [NSString stringWithFormat:@"%i", quant];
    quantit = [@"Quantity " stringByAppendingString:quanti];
    self.quan.text = quantit;
    
}

+(NSMutableArray*) myBasketArray
{
    return vendor_items_array;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)negative:(id)sender {
    if(quant > 1)
    {
    quant--;
    }
    
    quanti = [NSString stringWithFormat:@"%i", quant];
    quantit = [@"Quantity " stringByAppendingString:quanti];
    self.quan.text = quantit;
    
    final = quant * basic;
    
    finalPrice = [NSString stringWithFormat:@"%f", final];
    self.totalPrice.text = finalPrice;

}

- (IBAction)plus:(id)sender {
    if(quant<20){
            quant++;
    }

    quanti = [NSString stringWithFormat:@"%i", quant];
    quantit = [@"Quantity " stringByAppendingString:quanti];
    self.quan.text = quantit;
    
    
        final = quant * basic;
    NSLog(@"The price is %f",final);
    finalPrice = [NSString stringWithFormat:@"%.2f", final];
    self.totalPrice.text = finalPrice;

}
- (IBAction)addToBasket:(id)sender {
    
    NSMutableDictionary *item = [[NSMutableDictionary alloc]init];
    [item setValue:self.product_name.text forKey:@"product_name"];
    [item setValue:self.totalPrice.text forKey:@"product_price"];
    [item setValue:self.prod_vendor_id forKey:@"Vendor_id"];
    [item setValue:self.prod_item_id forKey:@"Item_id"];
    
    [vendor_items_array addObject:item];
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
