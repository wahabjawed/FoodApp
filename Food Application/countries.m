//
//  countries.m
//  Food Application
//
//  Created by Zainu Corporation on 10/07/2014.
//  Copyright (c) 2014 Zainu Corporation. All rights reserved.
//

#import "countries.h"
#import <QuartzCore/QuartzCore.h>
#import "WebService.h"
#import "checkInternet.h"
#import "Constants.h"

@interface countries (){
    UIActivityIndicatorView *progress;
    checkInternet *c;
}
@end

@implementation countries
@synthesize countries_tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_SchoolList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSLog(@"Index: %@ ",indexPath.row);
    static NSString *simpleTableIdentifierr = @"SimpleTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifierr];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifierr];
    }
    
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 120, 13)];
    
    
    self.locationid = [[_SchoolList valueForKey:@"location_id"] objectAtIndex:indexPath.row];
    NSString *location_name = [[_SchoolList valueForKey:@"location_name"] objectAtIndex:indexPath.row];
    //NSString *display = [[_SchoolList valueForKey:@"display"] objectAtIndex:indexPath.row];
    
    [name setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.f]];
    name.text=location_name;
    [cell addSubview:name];
    
    return cell;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    self.countries_tableView.delegate = self;
    self.countries_tableView.dataSource = self;
    self.countries_tableView.separatorColor = [UIColor lightGrayColor];
    
    
    UIView *statusBarbg = [[UIView alloc] initWithFrame:CGRectMake(0, 0,320, 20)];
    statusBarbg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:statusBarbg];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"countries_background.png"];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:backgroundImage];
    
    self.Enter.layer.cornerRadius = 7; // this value vary as per your desire
    self.Enter.clipsToBounds = YES;
    
    c= [[checkInternet alloc]init];
    
    [c viewWillAppear:YES];
    
    progress = [c indicatorprogress:progress];
    [self.view addSubview:progress];
    [progress bringSubviewToFront:self.view];
    
    dispatch_queue_t myqueue = dispatch_queue_create("myqueue", NULL);
    dispatch_async(myqueue, ^(void) {
        
        [progress startAnimating];
        [self FetchSchoolList];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update UI on main queue
            
            [self.countries_tableView reloadData];
            [progress stopAnimating];
        });
        
    });

    
    
}

-(NSArray*) FetchSchoolList
{
    WebService *RestObj = [[WebService alloc] init ];
    NSArray *FetchSchoolList = [RestObj FilePath:BASEURL SCHOOLS_LIST];
    
    _SchoolList = [[NSMutableArray alloc] init];
    for(NSDictionary *item in FetchSchoolList)
    {
        [_SchoolList addObject:item];
    }
    return  _SchoolList;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)press_enterButton:(id)sender {
}
@end
