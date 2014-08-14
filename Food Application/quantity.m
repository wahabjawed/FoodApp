//
//  quantity.m
//  Food Application
//
//  Created by Zainu Corporation on 09/08/2014.
//  Copyright (c) 2014 Zainu Corporation. All rights reserved.
//

#import "quantity.h"

@interface quantity ()

@end

@implementation quantity

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

    self.product_name.text = self.prod_name;
    
    self.basicPrice.text = self.prod_price;
    self.totalPrice.text = self.basicPrice.text;
    basic = [self.basicPrice.text intValue];
    
    quant = 1;
    quanti = [NSString stringWithFormat:@"%i", quant];
    quantit = [@"Quantity " stringByAppendingString:quanti];
    self.quan.text = quantit;
    
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
    
    finalPrice = [NSString stringWithFormat:@"%i", final];
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
    
    finalPrice = [NSString stringWithFormat:@"%i", final];
    self.totalPrice.text = finalPrice;

}
- (IBAction)addToBasket:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
