//
//  vendors.m
//  Food Application
//
//  Created by Zainu Corporation on 10/07/2014.
//  Copyright (c) 2014 Zainu Corporation. All rights reserved.
//

#import "vendors.h"
#import "SWRevealViewController.h"
#import "menuList.h"
#import "Constants.h"
#import "WebService.h"

@interface vendors ()
@end

@implementation vendors{
    UIScrollView *scroll;
    NSArray * VendorsNearMe;
    NSMutableArray * OpenVendors;
    NSMutableArray * ClosedVendors;
    NSString *VendorImagePath;
    NSString * VendorOpeningTime;
    NSString * VendorClosingTime;
    NSString * vendor_id;
    UIButton *button;
    UIActivityIndicatorView *image_loading;
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
    
    if(self.title ==NULL){
    self.title = @"Resturants";
    }
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
   [[self.navigationController navigationBar]setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];

    if(OpenVendors == nil)
        OpenVendors = [[NSMutableArray alloc] init];
    if(ClosedVendors == nil)
        ClosedVendors = [[NSMutableArray alloc] init];

    // Webservice for vendor list.
    WebService *VendorsNearMeRest = [[WebService alloc] init];
    VendorsNearMe = [[NSArray alloc] init];
    //self.title = @"Resturants";
    VendorsNearMe = [VendorsNearMeRest FilePath:BASEURL VENDORS_NEAR_ME parameterOne:[self title]];
    

    
    [self generate_views];
    [self.view addSubview:scroll];
    NSLog(@"TITLE: %@", [self title]);
    
}

-(void)generate_views{
    
    CGRect rect=CGRectMake(0,80,320,480);
    
    scroll = [[UIScrollView alloc] initWithFrame:rect];
    
    //loop for open
    int x=40;
    int y=0;
    
    
    for(int i=0;i<[VendorsNearMe count];i++){
        if((i>0) && (i%2==0))
        {
            y+=120;
            x=40;
        }
        else
        {
            if(i!=0)
            {
                x+=140;
            }
        }
        
        /* Timings. AM PM should be appended in the dashboard. */
        
        NSString * VendorImage = [[VendorsNearMe valueForKey:@"vendor_imageid"] objectAtIndex:i];
        VendorOpeningTime = [[VendorsNearMe valueForKey:@"vendor_opentime"] objectAtIndex:i];
        VendorClosingTime = [[VendorsNearMe valueForKey:@"vendor_closetime"] objectAtIndex:i];
        vendor_id = [[VendorsNearMe valueForKey:@"vendor_id"] objectAtIndex:i];
        int value = [vendor_id intValue];
        
        NSLog(@" my vendor is :%@",vendor_id);
        /* Downloading Images */
        
        image_loading = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(x+25,y+25,40,40)];
        [image_loading setColor:[UIColor whiteColor]];
        [scroll addSubview:image_loading];
        
        [image_loading startAnimating];
        dispatch_queue_t myqueue = dispatch_queue_create("myqueue", NULL);
        dispatch_async(myqueue, ^(void) {
            
            // setting individual spinner for image view here //
            
            VendorImagePath = [VENDOR_IMAGE_DIR stringByAppendingString:VendorImage];
            NSURL *VendorImageUrl = [NSURL URLWithString:VendorImagePath];
            NSData *data = [[NSData alloc]initWithContentsOfURL:VendorImageUrl];

            UIImage *img = [[UIImage alloc]initWithData:data];
            button = [[UIButton alloc]init];

            [button addTarget:self action:@selector(tapDetected:) forControlEvents:UIControlEventTouchUpInside];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update UI on main queue
                
                [button setBackgroundImage:img forState:UIControlStateNormal];
                button.frame = CGRectMake(x,y,100,100);
                button.tag = value;
                [scroll addSubview:button];
                [image_loading stopAnimating];
                // here, spinner for that image view will be removed.
                
            });
            
        });
        
        /*  ---------  */
        
        UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(x+20, y+105, 100, 10)];
        NSString *Vendortimings = [[VendorOpeningTime stringByAppendingString:@" - "] stringByAppendingString:VendorClosingTime];
        time.text = Vendortimings;
        time.textColor= [UIColor blackColor];
        [time setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:11.f]];
        [scroll addSubview:time];
        
    }
 
    UILabel *closed = [[UILabel alloc]initWithFrame:CGRectMake(0, y+120, self.view.frame.size.width, 20)];
    
    closed.text = @"    Closed";
    closed.textColor= [UIColor blackColor];
    [closed setBackgroundColor:[UIColor whiteColor]];
    [closed setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13.f]];
    [scroll addSubview:closed];
    
    //loop for close
    x=40;
    y+=150;
    
    for(int i=0;i<4;i++){
        if((i>0) && (i%2==0)){
            y+=120;
            x=40;
        }
        else{
            if(i!=0){
                x+=140;
            }
        }
        
        UIButton *button2 = [[UIButton alloc]init];
        UIImage *image = [UIImage imageNamed:@"burgerking.png"];
        [button2 setBackgroundImage:image forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(closetapDetected:) forControlEvents:UIControlEventTouchUpInside];
        button2.frame = CGRectMake(x,y,100,100);
        [scroll addSubview:button2];
    }
    
    scroll.contentSize = CGSizeMake(x, y+190);
    scroll.showsHorizontalScrollIndicator = YES;
    scroll.showsVerticalScrollIndicator = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tapDetected:(id)sender{

    button = (UIButton*) sender;
    
    NSString *tag = [NSString stringWithFormat: @"%d", (int)button.tag];;
    NSLog(@"tag: %@",tag);
    
    for(NSDictionary *item in VendorsNearMe)
    {
        NSLog(@" item: %@", item);
        
        bool foundMatch = NO;
        
        if(foundMatch == NO)
        {
            if([[item valueForKey:@"vendor_id"] isEqualToString:tag])
            {
                //[SecondViewController.friendWhoUseAppStaticFunction removeObject:item];
                NSLog(@"Found Object  %@", item);
                foundMatch = YES;
                vendor_id = [item valueForKey:@"vendor_id"];
                
            }
        }
    }
    
    //vendor_id = [[VendorsNearMe valueForKey:@"vendor_id"] objectAtIndex:button.tag];
    [self performSegueWithIdentifier:@"menutime" sender:self];
    NSLog(@"single Tap on imageview");
    
}

-(void)closetapDetected:(id)sender{
    
    NSLog(@"clicked on closed vendor");

}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    if ([segue.identifier isEqualToString:@"menutime"]) {
        menuList *m = (menuList*)segue.destinationViewController;
        
        m.title = @"Vendor Name";
        m.vendorId = vendor_id;
    }
}
@end
