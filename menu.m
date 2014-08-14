//
//  menu.m
//  Food Application
//
//  Created by Zainu Corporation on 10/07/2014.
//  Copyright (c) 2014 Zainu Corporation. All rights reserved.
//

#import "menu.h"
#import "WebService.h"
#import "Constants.h"
#import "quantity.h"

@interface menu ()

@end

@implementation menu{
    UIScrollView *scroll;
    NSArray *AllProductsOfVendor;
    UIImage *checkboximage;
    NSMutableArray *testing;
    NSString *product_price;
    NSString *product_name;
    NSString *ProductImagePath;
    UIActivityIndicatorView *image_loading;
    NSString * product_id;
    UIButton *button;
    BOOL flag;
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
    
    testing = [[NSMutableArray alloc]init];
    
    for(int i= 0; i<32; i++){
    [testing addObject:@"no"];
    }
    WebService *AllProductsOfVendorRest = [[WebService alloc] init];
    AllProductsOfVendor = [[NSArray alloc] initWithArray:[AllProductsOfVendorRest FilePath:BASEURL ALLPRODUCTS_VENDOR parameterOne:self.vendorId]];
    checkboxSelected = 0;
	// Do any additional setup after loading the view.
    self.proceedCheckout.layer.cornerRadius = 7;
    self.proceedCheckout.clipsToBounds = YES;
    //[self.menuImage setImage:[UIImage imageNamed:@"menu1.png"]];
    [self generate_views];
    [self.view addSubview:scroll];
    
    // NSLog(@" vendor id is: %@",self.vendorId);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)generate_views{
    
    CGRect rect=CGRectMake(0,170,320,480);
    
    scroll = [[UIScrollView alloc] initWithFrame:rect];
    
    //loop for open
    int x=12.5;
    int y=0;
    
    for(int i=0;i<[AllProductsOfVendor count];i++){
        if((i>0) && (i%4==0))
        {
            y+=105;
            x=12.5;
        }
        else
        {
            if(i!=0)
            {
                x+=75;
            }
        }
        
        product_id = [[AllProductsOfVendor valueForKey:@"product_id"] objectAtIndex:i];
        int value = [product_id intValue];
        
        image_loading = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(x+15,y+15,30,40)];
        //[testing setBackgroundColor:[UIColor blackColor]];
        [image_loading setColor:[UIColor whiteColor]];
        [scroll addSubview:image_loading];
        
        [image_loading startAnimating];
        dispatch_queue_t myqueue = dispatch_queue_create("myqueue", NULL);
        dispatch_async(myqueue, ^(void) {
            
            
            NSString * ProductImage = [[AllProductsOfVendor valueForKey:@"product_imageid"] objectAtIndex:i];
            NSLog(@"image name is: %@",ProductImage);
            ProductImagePath = [VENDOR_IMAGE_DIR stringByAppendingString:ProductImage];
            NSLog(@"image path is %@",ProductImagePath);
            NSURL *VendorImageUrl = [NSURL URLWithString:ProductImagePath];
            NSData *data = [[NSData alloc]initWithContentsOfURL:VendorImageUrl];
            UIImage *image = [[UIImage alloc]initWithData:data];
            checkboximage = [UIImage imageNamed:@"checkbox.png"];
            
            button = [[UIButton alloc]init];
            
//            UIButton *checkBoxButton = [[UIButton alloc]init];
//            UITextField *quantity = [[UITextField alloc]init];
//            
//            [testing addObject:flag];
//            NSString *Str=[NSString stringWithFormat:@"%@",quantity.text];
//            flag= false;
//            
//            
//            quantity.textColor = [UIColor blackColor];
//            quantity.backgroundColor = [UIColor whiteColor];
//            [quantity setFont:[UIFont boldSystemFontOfSize:13.0f]];
//            [checkBoxButton addTarget:self action:@selector(check:) forControlEvents:UIControlEventTouchUpInside];
//            quantity.frame = CGRectMake(x+70,y+60,25,25);
//            
//            [checkBoxButton setBackgroundImage:checkboximage forState:UIControlStateNormal];
//            checkBoxButton.frame = CGRectMake(x+75,y+30,15,15);
//            [scroll addSubview:quantity];
//                        [scroll addSubview:checkBoxButton];
        [button addTarget:self action:@selector(menuClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update UI on main queue
                [button setBackgroundImage:image forState:UIControlStateNormal];
                button.frame = CGRectMake(x,y,70,95);
                button.tag = value;
                [scroll addSubview:button];
                [image_loading stopAnimating];
                // here, spinner for that image view will be removed.
                
            });
            
        });

    }
    
    scroll.contentSize = CGSizeMake(x, y+180);
    scroll.showsHorizontalScrollIndicator = YES;
    scroll.showsVerticalScrollIndicator = YES;
    
}

-(void)menuClicked:(id)sender{
    
    NSLog(@"This menu is Selected");
    
    button = (UIButton*) sender;
    
    //NSLog(@"product name is :%@",product_name);
    //NSLog(@"product price is :%@",product_price);
    
    NSString *tag = [NSString stringWithFormat: @"%d", (int)button.tag];;
    NSLog(@"tag: %@",tag);
    
    
    
    for(NSDictionary *item in AllProductsOfVendor)
    {
        NSLog(@" item: %@", item);
        
        bool foundMatch = NO;
        
        if(foundMatch == NO)
        {
            if([[item valueForKey:@"product_id"] isEqualToString:tag])
            {
                //[SecondViewController.friendWhoUseAppStaticFunction removeObject:item];
                NSLog(@"Found Object  %@", item);
                foundMatch = YES;
                product_name = [item valueForKey:@"product_name"];
                product_price = [item valueForKey:@"product_price"];


                
            }
            
        }
    }
    
    [self performSegueWithIdentifier:@"defineQuantity" sender:self];
    
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // Set the title of navigation bar by using the menu items
    //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    if ([segue.identifier isEqualToString:@"defineQuantity"]) {
        quantity *q = (quantity*)segue.destinationViewController;
        q.prod_name = product_name;
        q.prod_price = product_price;
    }

}

//-(void)check:(UIButton*)sender{
//    
//    NSLog(@"clicked");
//    long value = sender.tag;
//    
//    NSLog(@"khali =%li",value);
//
//    
//    if ([[testing objectAtIndex:value] isEqualToString:@"no"])
//    {
//        NSLog(@"if = %li",value);
//
//		//[sender setSelected:1];
//        [sender setImage:[UIImage imageNamed:@"checkbox-checked.png"] forState:UIControlStateNormal];
//        
//        [testing setObject:@"yes" atIndexedSubscript:value];
//     //   [[testing objectAtIndex:value]setObject:@"yes" atIndex:value];
//        checkboxSelected = 1;
//        
//	}
//    else
//    {
//        
//        NSLog(@"else = %li",value);
//		//[sender setSelected:0];
//        [sender setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
//        //checkboxSelected=0;
//        [testing setObject:@"no" atIndexedSubscript:value];
//    }
//}

@end
