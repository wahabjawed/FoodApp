//
//  menuList.m
//  Food Application
//
//  Created by Zainu Corporation on 17/08/2014.
//  Copyright (c) 2014 Zainu Corporation. All rights reserved.
//

#import "menuList.h"
#import "WebService.h"
#import "Constants.h"
#import "quantity.h"

@interface menuList ()

@end

@implementation menuList{

    NSArray *AllProductsOfVendor;
    NSString *product_price;
    NSString *product_name;
    NSString *ProductImagePath;
    NSString *product_id;
    UIButton *button;
    UIActivityIndicatorView *image_loading;
    NSString * ProductImage;
    NSURL *VendorImageUrl ;
    NSData *data ;
    UIImage *image ;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.product_table.delegate = self;
    self.product_table.dataSource = self;
    
    self.proceed.layer.cornerRadius = 7;
    self.proceed.clipsToBounds = YES;
            
    [self FetchProductsList];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    [label setText:@"                  Item                                           Price"];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:172/255.0 green:62/255.0 blue:62/255.0 alpha:1.0]];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [AllProductsOfVendor count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Selected row of section >> %d",indexPath.row);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifierr = @"Items";
    UILabel *price;
    UILabel *prod_name;
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;
//    UITableViewCell *cell;
//    
//    if (cell == nil) {
//        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifierr];
//        
//    }

    if(cell == nil){
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifierr ];
    
    product_price = [[AllProductsOfVendor valueForKey:@"product_price"] objectAtIndex:indexPath.row];
    product_name = [[AllProductsOfVendor valueForKey:@"product_name"] objectAtIndex:indexPath.row];
    }
    price = [[UILabel alloc]initWithFrame:CGRectMake(240, 12, 50, 20)];
    price.textColor = [UIColor blackColor];
    price.text = product_price;
    
    prod_name = [[UILabel alloc]initWithFrame:CGRectMake(65, 12, 170, 20)];
    prod_name.textColor = [UIColor blackColor];
    prod_name.text = product_name;
    
    [cell addSubview:price];
    [cell addSubview:prod_name];
    
    image_loading = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(20,15,20,20)];
    [image_loading setColor:[UIColor blackColor]];
    [cell addSubview:image_loading];
    
    [image_loading startAnimating];
    
    dispatch_queue_t myqueue = dispatch_queue_create("myqueue", NULL);
    dispatch_async(myqueue, ^(void) {
        
        ProductImage = [[AllProductsOfVendor valueForKey:@"product_imageid"] objectAtIndex:indexPath.row];
        
        ProductImagePath = [VENDOR_IMAGE_DIR stringByAppendingString:ProductImage];

        VendorImageUrl = [NSURL URLWithString:ProductImagePath];
        data = [[NSData alloc]initWithContentsOfURL:VendorImageUrl];
        image = [[UIImage alloc]initWithData:data];
        
        button = [[UIButton alloc]init];
        //[button addTarget:self action:@selector(menuClicked:) forControlEvents:UIControlEventTouchUpInside];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update UI on main queue
            
            [button setBackgroundImage:image forState:UIControlStateNormal];
            button.frame = CGRectMake(10,5,50,34);
            //button.tag = value;
            
            [cell addSubview:button];
            [image_loading stopAnimating];

            // here, spinner for that image view will be removed.
            
        });
        
    });
    
    
    if ([cell.contentView subviews]){
        for (UIView *subview in [cell.contentView subviews]) {
            [subview removeFromSuperview];
        }
    }
    return cell;
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    if ([segue.identifier isEqualToString:@"defineQuantity"]) {
        quantity *q = (quantity*)segue.destinationViewController;
        
        product_price = [[AllProductsOfVendor valueForKey:@"product_price"] objectAtIndex:indexPath.row];
        product_name = [[AllProductsOfVendor valueForKey:@"product_name"] objectAtIndex:indexPath.row];
        product_id = [[AllProductsOfVendor valueForKey:@"product_vendorid"] objectAtIndex:indexPath.row];
        
        q.prod_name = product_name;
        q.prod_price = product_price;
        q.prod_vendor_id = self.vendorId;
        q.prod_item_id = product_id;
        
    }
    
}

-(NSArray*) FetchProductsList
{
    WebService *AllProductsOfVendorRest = [[WebService alloc] init];
    AllProductsOfVendor = [[NSArray alloc] initWithArray:[AllProductsOfVendorRest FilePath:BASEURL ALLPRODUCTS_VENDOR parameterOne:self.vendorId]];
    return  AllProductsOfVendor;
}

@end