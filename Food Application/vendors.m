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
#import "countries.h"

@interface vendors ()
@end

@implementation vendors{
    UIScrollView *scroll;
    NSMutableArray * AllVendors;
    NSMutableArray * VendorsNearMeInRadius;
    NSMutableArray * OpenVendors;
    NSMutableArray * ClosedVendors;
    NSString *VendorImagePath;
    NSString * VendorOpeningTime;
    NSString * VendorClosingTime;
    NSString * vendor_id;
    NSString * vendor_name;
    UIButton *button;
    UIActivityIndicatorView *image_loading;
    int LocationArrayCount;
    float PIx;
    double RADIO; // Mean radius of Earth in Km
    
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
    
    PIx = 3.141592653589793;
    RADIO = 6371; // Mean radius of Earth in Km
    
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
    
    if(VendorsNearMeInRadius == nil)
        VendorsNearMeInRadius = [[NSMutableArray alloc] init];
    
    // Webservice for vendor list.
    WebService *VendorsNearMeRest = [[WebService alloc] init];
    AllVendors = [[NSMutableArray alloc] init];
    //self.title = @"Resturants";
    AllVendors = [VendorsNearMeRest FilePath:BASEURL VENDORS_NEAR_ME parameterOne:[self title] parameterTwo:[self CurrentTimeLocal]];
    
    [self OpenOrCloseArrays:AllVendors];
    [self generate_views];
    [self.view addSubview:scroll];
    //NSLog(@"TITLE: %@", [self title]);

}

-(void) OpenOrCloseArrays: (NSArray*) allVendors
{
    for (int i=0; i<[AllVendors count]; i++) {
        if([[[AllVendors objectAtIndex:i] valueForKey:@"'status'"]  isEqual: @"OPEN"])
        {
            [OpenVendors addObject:[AllVendors objectAtIndex:i]];
        }
        else
        {
            [ClosedVendors addObject:[AllVendors objectAtIndex:i]];
        }
    }
}

-(NSString*)CurrentTimeLocal
{
    // get current date/time
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm:ss"];
    // display in 12HR/24HR (i.e. 11:25PM or 23:25) format according to User Settings
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *currentTime = [dateFormatter stringFromDate:today];
    NSLog(@"CURRENT TIME: %@", currentTime);
    return currentTime;
}

-(void)generate_views{
    
    CGRect rect=CGRectMake(0,80,320,480);
    
    scroll = [[UIScrollView alloc] initWithFrame:rect];
    
    //loop for open
    int x=40;
    int y=0;
    
    
    for(int i=0;i<[OpenVendors count];i++)
    {
        
        // after two line break
        
        [self RadiusCalculation:i :OpenVendors];
        
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
        
        NSString * VendorImage = [[OpenVendors valueForKey:@"vendor_imageid"] objectAtIndex:i];
        VendorOpeningTime = [[OpenVendors valueForKey:@"vendor_opentime"] objectAtIndex:i];
        VendorClosingTime = [[OpenVendors valueForKey:@"vendor_closetime"] objectAtIndex:i];
        
        NSLog(@"VendorOpeningTime %@",VendorOpeningTime);
        int hours_ot = [[VendorOpeningTime substringToIndex:2] intValue];
        int minutes_ot = [[VendorOpeningTime substringFromIndex:[VendorOpeningTime length] - 5] intValue];
        NSLog(@"hours_ot: %d", hours_ot);
        NSLog(@"minutes_ot: %d", minutes_ot);
        
        int hours_ct = [[VendorClosingTime substringToIndex:2] intValue];
        int minutes_ct = [[VendorClosingTime substringFromIndex:[VendorClosingTime length] - 5] intValue];
        
        NSLog(@"hours_ct: %d", hours_ct);
        NSLog(@"minutes_ct: %d", minutes_ct);
        
        VendorOpeningTime = [self ConversionFrom24to12hour:hours_ot :minutes_ot];
        VendorClosingTime = [self ConversionFrom24to12hour:hours_ct :minutes_ct];
        
        vendor_id = [[OpenVendors valueForKey:@"vendor_id"] objectAtIndex:i];
        int value = [vendor_id intValue];
        NSLog(@"vendor id :%@",vendor_id);
        
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
        
        UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(x+2, y+105, 105, 10)];
        NSString *Vendortimings = [[VendorOpeningTime stringByAppendingString:@" - "] stringByAppendingString:VendorClosingTime];
        time.text = Vendortimings;
        time.textColor= [UIColor blackColor];
        [time setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:10.f]];
        [scroll addSubview:time];
        
        NSLog(@"------------------------------------- %@", @"---------------------");
        
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
    
    for(int i=0;i<[ClosedVendors count];i++)
    {
        [self RadiusCalculation:i :ClosedVendors];

        if((i>0) && (i%2==0)){
            y+=120;
            x=40;
        }
        else{
            if(i!=0){
                x+=140;
            }
        }
        
        NSString * VendorImage = [[ClosedVendors valueForKey:@"vendor_imageid"] objectAtIndex:i];
        VendorOpeningTime = [[ClosedVendors valueForKey:@"vendor_opentime"] objectAtIndex:i];
        VendorClosingTime = [[ClosedVendors valueForKey:@"vendor_closetime"] objectAtIndex:i];
        vendor_id = [[ClosedVendors valueForKey:@"vendor_id"] objectAtIndex:i];
        int value = [vendor_id intValue];
        

        int hours_ot = [[VendorOpeningTime substringToIndex:2] intValue];
        int minutes_ot = [[VendorOpeningTime substringFromIndex:[VendorOpeningTime length] - 5] intValue];
        
        int hours_ct = [[VendorClosingTime substringToIndex:2] intValue];
        int minutes_ct = [[VendorClosingTime substringFromIndex:[VendorClosingTime length] - 5] intValue];
        
        
        VendorOpeningTime = [self ConversionFrom24to12hour:hours_ot :minutes_ot];
        VendorClosingTime = [self ConversionFrom24to12hour:hours_ct :minutes_ct];
        
        NSLog(@"vendor id :%@",vendor_id);
        
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
            
            [button addTarget:self action:@selector(closetapDetected:) forControlEvents:UIControlEventTouchUpInside];
            
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
        
        UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(x+2, y+105, 105, 10)];
        NSString *Vendortimings = [[VendorOpeningTime stringByAppendingString:@" - "] stringByAppendingString:VendorClosingTime];
        time.text = Vendortimings;
        time.textColor= [UIColor blackColor];
        [time setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:10.f]];
        [scroll addSubview:time];
        
        NSLog(@"------------------------------------- %@", @"---------------------");
        
    }
    
    scroll.contentSize = CGSizeMake(x, y+200);
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
    
    for(NSDictionary *item in AllVendors)
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
                vendor_name = [item valueForKey:@"vendor_name"];
                NSLog(@" selected vendor id is: %@",vendor_id);
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
        
        m.title = vendor_name;
        m.vendorId = vendor_id;
    }
}

-(void) RadiusCalculation: (int) withIndex : (NSMutableArray*)VendorArray
{
    NSArray *LocationArrayObjects = [[VendorArray objectAtIndex:withIndex] valueForKey:@"location_id_details"];
    LocationArrayCount = [LocationArrayObjects count];
    
    NSLog(@"current %@",LocationArrayObjects);
    NSLog(@"count of vendors %i",LocationArrayCount);
    NSLog(@"count of session %i", [[countries CurrentSessionLongitudeFunction] count]);
    
    for (int j=0; j<[[countries CurrentSessionLongitudeFunction] count]; j++) {
       
        for (int i = 0; i<LocationArrayCount; i++) {
            int CurrentVendorLatitude = [[[LocationArrayObjects objectAtIndex:i] valueForKey:@"coordinates_lat"] intValue];
            int CurrentVendorLongitude = [[[LocationArrayObjects objectAtIndex:i] valueForKey:@"coordinates_long"] intValue];
            int SessionLat = [[[countries CurrentSessionLatitudeFunction] objectAtIndex:j] intValue];
            int SessionLong = [[[countries CurrentSessionLongitudeFunction ] objectAtIndex:j] intValue];
            
            int radius_km = [[[LocationArrayObjects objectAtIndex:i] valueForKey:@"radius_km"] intValue];
            double radius_calculated = [self radiusCalculationFormula:SessionLat :SessionLong :CurrentVendorLatitude :CurrentVendorLongitude];
            
            if(radius_calculated > radius_km)
            {
                NSLog(@"object at index: %@", [VendorArray objectAtIndex:withIndex]);
                NSLog(@"OBJECT REMOVED");
               // [VendorArray removeObject:[VendorArray objectAtIndex:withIndex]];
            }
            else
            {
                
            }
            
        }

        
    }
    
    
}

-(double) convertToRadians: (double) val
{
    return val * PIx / 180;
}

-(double) radiusCalculationFormula:(int)sessionLat :(int) sessionLong :(int) vendorLat : (int) vendorLong
{
    
    NSLog(@"sessionLat: %i",sessionLat);
    NSLog(@"sessionLong: %i",sessionLong);
    NSLog(@"vendorLat: %i",vendorLat);
    NSLog(@"vendorLong: %i",vendorLong);

    double dlon = [self convertToRadians:(vendorLong - sessionLong)];
    double dlat = [self convertToRadians:(vendorLat - sessionLat)];
    
    double a =  pow(sin(dlat / 2), 2) + cos([self convertToRadians:(sessionLat)]) * cos([self convertToRadians:(vendorLat)]) * pow(sin(dlon / 2), 2);
    double angle = 2 * asin(sqrt(a));
    NSLog(@"Radius: %f", (angle * RADIO));
    return angle * RADIO;
    
}

-(NSString *)ConversionFrom24to12hour :(int)hours : (int)minutes
{
    NSString * convertedTime;
    NSString * min;
    NSLog(@"hours %i",hours);
    NSLog(@"minutes %i",minutes);
    
    
    if(minutes == 0)
        min = @"00";
    else
        min = [NSString stringWithFormat:@"%d",minutes];
    
    
    if(hours>12)
    {
        hours = hours - 12;
        convertedTime = [[[[NSString stringWithFormat:@"%d", hours] stringByAppendingString:@":"] stringByAppendingString:min] stringByAppendingString:@" PM"];
        NSLog(@"vendor in 12 hour: %@", convertedTime);
    }
    else
    {
        convertedTime = [[[[NSString stringWithFormat:@"%d", hours] stringByAppendingString:@":"] stringByAppendingString:min] stringByAppendingString:@" AM"];
        NSLog(@"vendor in 12 hour: %@", convertedTime);
    }
    
    return convertedTime;
}

@end
