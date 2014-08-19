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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Items" forIndexPath:indexPath];
    
    dispatch_queue_t myqueue = dispatch_queue_create("myqueue", NULL);
    dispatch_async(myqueue, ^(void) {
        
        
        NSString * ProductImage = [[AllProductsOfVendor valueForKey:@"product_imageid"] objectAtIndex:indexPath.row];
        NSLog(@"image name is: %@",ProductImage);
        ProductImagePath = [VENDOR_IMAGE_DIR stringByAppendingString:ProductImage];
        NSLog(@"image path is %@",ProductImagePath);
        NSURL *VendorImageUrl = [NSURL URLWithString:ProductImagePath];
        NSData *data = [[NSData alloc]initWithContentsOfURL:VendorImageUrl];
        UIImage *image = [[UIImage alloc]initWithData:data];
        
        product_price = [[AllProductsOfVendor valueForKey:@"product_price"] objectAtIndex:indexPath.row];
        product_name = [[AllProductsOfVendor valueForKey:@"product_name"] objectAtIndex:indexPath.row];
        
        button = [[UIButton alloc]init];
        //[button addTarget:self action:@selector(menuClicked:) forControlEvents:UIControlEventTouchUpInside];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update UI on main queue
            UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(240, 12, 50, 20)];
            price.textColor = [UIColor blackColor];
            price.text = product_price;
            
            UILabel *prod_name = [[UILabel alloc]initWithFrame:CGRectMake(65, 12, 170, 20)];
            prod_name.textColor = [UIColor blackColor];
            prod_name.text = product_name;
            
            [button setBackgroundImage:image forState:UIControlStateNormal];
            button.frame = CGRectMake(10,5,50,34);
            //button.tag = value;
            [cell addSubview:price];
            [cell addSubview:prod_name];
            [cell addSubview:button];

            // here, spinner for that image view will be removed.
            
        });
        
    });
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
        
        q.prod_name = product_name;
        q.prod_price = product_price;
    }
    
}

-(NSArray*) FetchProductsList
{
    WebService *AllProductsOfVendorRest = [[WebService alloc] init];
    AllProductsOfVendor = [[NSArray alloc] initWithArray:[AllProductsOfVendorRest FilePath:BASEURL ALLPRODUCTS_VENDOR parameterOne:self.vendorId]];
    return  AllProductsOfVendor;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end