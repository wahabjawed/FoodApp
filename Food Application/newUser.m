//
//  newUser.m
//  Food Application
//
//  Created by Zainu Corporation on 10/07/2014.
//  Copyright (c) 2014 Zainu Corporation. All rights reserved.
//

#import "newUser.h"
#import "Constants.h"
#import "WebService.h"
#import "countries.h"

@interface newUser (){
    NSString *FirstName;
    NSString *LastName;
    NSString *Address;
    NSString *City;
    NSString *StateID;
    NSString *Zip;
    NSString *CountryID;
    NSString *Phone;
    NSString *Cell;
    NSString *Major;
    NSString *GradClass;
    NSString *Email;
    NSString *Password;
    NSString *LocationID;
    NSMutableDictionary *RegisterJsonPost;
}

@end

@implementation newUser

- (IBAction)Register:(id)sender {
    FirstName = [[self fname] text];
    LastName = [[self lname] text];
    Address = [[self address] text];
    City = [[self city] text];
    StateID = [[self stateId] text];
    Zip = [[self zip] text];
    CountryID = [[self countryId] text];
    Phone = [[self phone] text];
    Cell = [[self cell] text];
    Major = [[self major] text];
    GradClass = [[self className] text];
    Email = [[self email] text];
    Password = [[self password] text];
    
    countries *c = [[countries alloc]init];
    LocationID = [c locationid];  // from the intent extra value put here of location ID from previous screen
    
    
    if(RegisterJsonPost == nil)
        RegisterJsonPost = [[NSMutableDictionary alloc] init];
    
    [RegisterJsonPost setValue:FirstName forKey:@"first_name"];
    [RegisterJsonPost setValue:LastName forKey:@"last_name"];
    [RegisterJsonPost setValue:Address forKey:@"address"];
    [RegisterJsonPost setValue:City forKey:@"city"];
    [RegisterJsonPost setValue:StateID forKey:@"stateID"];
    [RegisterJsonPost setValue:Zip forKey:@"zip"];
    [RegisterJsonPost setValue:CountryID forKey:@"countryID"];
    [RegisterJsonPost setValue:Phone forKey:@"phone"];
    [RegisterJsonPost setValue:Cell forKey:@"cell"];
    [RegisterJsonPost setValue:Major forKey:@"major"];
    [RegisterJsonPost setValue:GradClass forKey:@"gradClass"];
    [RegisterJsonPost setValue:Email forKey:@"email"];
    [RegisterJsonPost setValue:LocationID forKey:@"locationID"];
    [RegisterJsonPost setValue:Password forKey:@"password"];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    [tempArray addObject:RegisterJsonPost];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:tempArray
                        options:NSJSONWritingPrettyPrinted
                        error:&error];
    if ([jsonData length] > 0 &&
        error == nil){
        NSString *RegisterStringJSON = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        WebService *RegisterRestService = [[WebService alloc] init];
        [RegisterRestService FilePath:BASEURL REGISTER parameterOne:RegisterStringJSON];
    }
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
    
    UIView *statusBarbg = [[UIView alloc] initWithFrame:CGRectMake(0, 0,320, 20)];
    statusBarbg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:statusBarbg];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"countries_background.png"];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:backgroundImage];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.fname.leftView = paddingView;
    self.fname.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.lname.leftView = paddingView2;
    self.lname.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.className.leftView = paddingView3;
    self.className.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.major.leftView = paddingView4;
    self.major.leftViewMode = UITextFieldViewModeAlways;

    UIView *paddingView5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.email.leftView = paddingView5;
    self.email.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView6 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.password.leftView = paddingView6;
    self.password.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView7 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.cell.leftView = paddingView7;
    self.cell.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView8 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.phone.leftView = paddingView8;
    self.phone.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView9 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.address.leftView = paddingView9;
    self.address.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView10 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.city.leftView = paddingView10;
    self.city.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView11 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.zip.leftView = paddingView11;
    self.zip.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView12 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.countryId.leftView = paddingView12;
    self.countryId.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView13 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.stateId.leftView = paddingView13;
    self.stateId.leftViewMode = UITextFieldViewModeAlways;

    [[self backButton]setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
