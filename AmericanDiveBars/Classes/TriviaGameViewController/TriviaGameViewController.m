//
//  TriviaGameViewController.m
//  AmericanDiveBars
//
//  Created by spaculus on 4/22/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import "TriviaGameViewController.h"


#import "TriviaQuestionCell.h"
#import "TriviaAnswerCell.h"
#import "TriviaButtonCell.h"



static NSString * const TriviaQuestionCellIdentifier = @"TriviaQuestionCell";

@interface TriviaGameViewController () <MBProgressHUDDelegate,FPPopoverControllerDelegate>
{
    //HUD
    MBProgressHUD *HUD;
    
    //POPOVER
    FPPopoverController *popover;
    
    NSInteger queCount;
    NSInteger totalCount;
   
    NSString *queNumber;
    NSString *timerValue;
   
    NSString *ans1;
    NSString *ans2;
    NSString *ans3;
    NSString *ans4;
   
    NSString *question;

    NSTimer *timer;
    NSInteger timeCount;
    NSInteger answerTime;
    
    
    NSMutableArray *aryResults;
}


//Main Table
@property (strong, nonatomic) IBOutlet UITableView *tblView;
/*
 @property (assign, nonatomic)
 @property (assign, nonatomic)
 
 @property (strong, nonatomic)
 @property (strong, nonatomic)
 
 @property (strong, nonatomic)
 @property (strong, nonatomic)
 @property (strong, nonatomic)
 @property (strong, nonatomic)
 
 @property (strong, nonatomic)
 */

@end



@implementation TriviaGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [CommonUtils setTitleLabel:@"BAR TRIVIA GAME"];
    
    [self configureTopButtons];
    //[self configureBarTableView];
    
    [self initializeDataStructure];
}

-(void)initializeDataStructure {
    
    ans1 = @"";
    ans2 = @"";
    ans3 = @"";
    ans4 = @"";
    queCount = 0;
    totalCount = [[self.game aryQuestions] count];
    
    aryResults = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<20; i++) {
        NSNumber *time = [NSNumber numberWithInteger:0];
        NSString *answered = @"no";
        NSDictionary *dict = @{@"result":@"0",@"time":time,@"answered":answered};
        [aryResults addObject:dict];
    }
    
    NSLog(@"%@",aryResults);
    
    self.lblTimer.text = @"20";
    [self stopTimer];
    [self callTimer];
    [self updateQuestion];
    [self configUI];
    
}
#pragma mark - update Timer

-(void)callTimer {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(updateCountdown) userInfo:nil repeats: YES];
}

-(void)resetTimer {
    self.lblTimer.text = @"20"; //[NSString stringWithFormat:@"%ld",20];
    [self stopTimer];
    [self callTimer];
}

-(void)stopTimer {
    answerTime = timeCount;
    timeCount = 0;
    [timer invalidate];
    timer = nil;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)updateCountdown {
    timeCount++;
    
    timerValue = [NSString stringWithFormat:@"%ld",(20-timeCount)];
    
    self.lblTimer.text = timerValue;
    
    if (timeCount == 20) {
        [self btnNextClicked:nil];
        
    }
    
}



#pragma mark - Update Question
-(void)updateQuestion {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"que count = %ld",(long)queCount);
    Question *que = [[self.game aryQuestions] objectAtIndex:queCount];
    
    
    question = que.que;
    
    ans1 = [[[que aryOptions] objectAtIndex:0] ans];
    ans2 = [[[que aryOptions] objectAtIndex:1] ans];
    ans3 = [[[que aryOptions] objectAtIndex:2] ans];
    ans4 = [[[que aryOptions] objectAtIndex:3] ans];
    
}

-(void)updateLabelAndTimer {
    
    NSInteger realCount = queCount+1;
    
    queNumber = [NSString stringWithFormat:@"%ld/%ld",(long)realCount,(long)totalCount];
    
    self.lblQueCount.text = queNumber;
    
    
    
//    queNumber = [NSString stringWithFormat:@"1/%ld",(long)totalCount];
//    self.lblQueCount.text = queNumber;
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)configUI {
    
    self.questionCountView.layer.borderColor = [[UIColor colorWithRed:189.0/255.0 green:127.0/255.0 blue:52.0/255.0 alpha:1.0] CGColor];
    self.questionCountView.layer.borderWidth = 1.0f;
    self.questionCountView.layer.cornerRadius = 2.0f;
    self.questionCountView.layer.masksToBounds = YES;
    
    self.timerView.layer.borderColor = [[UIColor colorWithRed:189.0/255.0 green:127.0/255.0 blue:52.0/255.0 alpha:1.0] CGColor];
    self.timerView.layer.borderWidth = 1.0f;
    self.timerView.layer.cornerRadius = 2.0f;
    self.timerView.layer.masksToBounds = YES;
    
    [self updateLabelAndTimer];
    
    [self.tblView reloadData];
}


#pragma mark -

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavImage];
    self.navigationController.navigationBar.topItem.title = @" ";
    [self registerCell];
    [self.tblView reloadData];
}

-(void)setStatusBarVisibility {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

-(void)viewDidLayoutSubviews {
    [self setStatusBarVisibility];
    popover.contentSize = CGSizeMake(150, self.view.bounds.size.height-20);
}

-(void)setNavImage {
    CGSize blankImageSize = CGSizeMake(self.view.bounds.size.width, 64);
    UIImage *blank = [CommonUtils imageFromColor:[UIColor colorWithRed:187.0/255.0 green:124.0/255.0 blue:37.0/255.0 alpha:1.0] forSize:blankImageSize withCornerRadius:0.0];
    [CommonUtils setNavigationBarImage:blank forNavigationBar:self.navigationController.navigationBar];
}



- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGFloat topInset = self.navigationController.navigationBar.frame.size.height+([UIApplication sharedApplication].isStatusBarHidden ? 0.f : [UIApplication sharedApplication].statusBarFrame.size.height);
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0) topInset = 0.f;
    
    // [self updateFilterProperties];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Right Menu

-(void)configureTopButtons {
    UIBarButtonItem *btnFilter;
    btnFilter = [CommonUtils barItemWithImage:[UIImage imageNamed:@"three-dit.png"] highlightedImage:nil xOffset:2 target:self action:@selector(openRightMenu_Clicked:)];
    
    [btnFilter setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                       [UIFont systemFontOfSize:17.0], NSFontAttributeName,
                                       [UIColor lightGrayColor], NSForegroundColorAttributeName,
                                       nil]
                             forState:UIControlStateNormal];
    UIBarButtonItem *btnTopSearch;
    btnTopSearch = [CommonUtils barItemWithImage:[UIImage imageNamed:@"top-home.png"] highlightedImage:nil xOffset:-5 target:self action:@selector(btnTopSearch_Clicked:)];
    
    self.navigationItem.rightBarButtonItems = @[btnFilter,btnTopSearch];
}



-(void)btnTopSearch_Clicked:(UIButton *)btnTopSearch {
    [self btnTopSearchClicked:btnTopSearch];
}

-(void)btnTopSearchClicked:(UIButton *)btnTopSearch {
    [self.navigationController popToRootViewControllerAnimated:YES];
    // FindBarViewController *findBar = [[FindBarViewController alloc] initWithNibName:@"FindBarViewController" bundle:nil];
    // [self.navigationController pushViewController:findBar animated:YES];
}


-(void)openRightMenu_Clicked:(UIButton *)btnRightMenu {
    [self btnFilterClicked:btnRightMenu];
}

-(void)btnFilterClicked:(id)sender
{
    LeftMenu_Popup *controller = [[LeftMenu_Popup alloc] initWithStyle:UITableViewStylePlain];
    controller.gameDelegate = self;
    if ([CommonUtils isLoggedIn]) {
        //All
        controller.aryItems = @[@{@"image":@"user-no_image_LM.png",@"title":@"User"},
                                @{@"image":@"dashboard-LM.png",@"title":@"My Dashboard"},
                                @{@"image":@"bar-LM.png",@"title":@"Find Bar"},
                                @{@"image":@"beer-LM.png",@"title":@"Beer Directory"},
                                @{@"image":@"cocktail-LM.png",@"title":@"Cocktail Recipes"},
                                @{@"image":@"liquor-LM.png",@"title":@"Liquor Directory"},
                                @{@"image":@"taxi-RM.png",@"title":@"Taxi Directory"},
                                @{@"image":@"article-RM.png",@"title":@"Articles"},
                                @{@"image":@"bar-trivia-RM.png",@"title":@"Bar Trivia Game"}];
    }
    else {
        //All
        controller.aryItems = @[@{@"image":@"login-LM.png",@"title":@"Sign In"},
                                @{@"image":@"register-LM.png",@"title":@"Sign Up"},
                                @{@"image":@"bar-LM.png",@"title":@"Find Bar"},
                                @{@"image":@"beer-LM.png",@"title":@"Beer Directory"},
                                @{@"image":@"cocktail-LM.png",@"title":@"Cocktail Recipes"},
                                @{@"image":@"liquor-LM.png",@"title":@"Liquor Directory"},
                                @{@"image":@"taxi-RM.png",@"title":@"Taxi Directory"},
                                @{@"image":@"article-RM.png",@"title":@"Articles"},
                                @{@"image":@"bar-trivia-RM.png",@"title":@"Bar Trivia Game"}];
    }
    popover = [[FPPopoverController alloc] initWithViewController:controller];
    
    popover.contentSize = CGSizeMake(150, self.view.bounds.size.height-20);
    
    popover.arrowDirection = FPPopoverArrowDirectionUp;
    [popover presentPopoverFromView:sender];
    
}

- (void)presentedNewPopoverController:(FPPopoverController *)newPopoverController shouldDismissVisiblePopover:(FPPopoverController*)visiblePopoverController
{
    [visiblePopoverController dismissPopoverAnimated:YES];
}

-(void)selectedTableRow:(NSUInteger)rowNum
{
    [popover dismissPopoverAnimated:YES];
    
    //All
    switch (rowNum) {
        case 0:
            if ([CommonUtils isLoggedIn]) {
                MyProfileViewController *profile = [[MyProfileViewController alloc]  initWithNibName:@"MyProfileViewController" bundle:nil];
                [self.navigationController pushViewController:profile animated:YES];
            }
            else {
                [CommonUtils redirectToLoginScreenWithTarget:self];
            }
            
            break;
            
        case 1:
        {
            if ([CommonUtils isLoggedIn]) {
                DashboardViewController *dashBoard = [[DashboardViewController alloc]  initWithNibName:@"DashboardViewController" bundle:nil];
                dashBoard.isLoggoutFromDashBoard = YES;
                [self.navigationController pushViewController:dashBoard animated:YES];
            }
            else {
                [CommonUtils redirectToLoginScreenWithTarget:self];
            }
        }
            
            break;
            
        case 2:
        {
            FindBarViewController *findBar = [[FindBarViewController alloc] initWithNibName:@"FindBarViewController" bundle:nil];
            [self.navigationController pushViewController:findBar animated:YES];
        }
            break;
            
        case 3:
        {
            BeerDirectoryViewController *beer = [[BeerDirectoryViewController alloc]  initWithNibName:@"BeerDirectoryViewController" bundle:nil];
            [self.navigationController pushViewController:beer animated:YES];
        }
            break;
        case 4:
        {
            CocktailDirectoryViewController *cocktail = [[CocktailDirectoryViewController alloc]  initWithNibName:@"CocktailDirectoryViewController" bundle:nil];
            [self.navigationController pushViewController:cocktail animated:YES];
        }
            break;
            
        case 5:
        {
            LiquorDirectoryViewController *liquor = [[LiquorDirectoryViewController alloc]  initWithNibName:@"LiquorDirectoryViewController" bundle:nil];
            [self.navigationController pushViewController:liquor animated:YES];
        }
            break;
            
        case 6:
        {
            TaxiDirectoryViewController *taxi = [[TaxiDirectoryViewController alloc] initWithNibName:@"TaxiDirectoryViewController" bundle:nil];
            [self.navigationController pushViewController:taxi animated:YES];
        }
            break;
            
        case 7:
        {
            PhotoGalleryViewController *photo = nil;
            if ([CommonUtils isiPad]) {
                photo = [[PhotoGalleryViewController alloc]  initWithNibName:@"PhotoGalleryViewController_iPad" bundle:nil];
            }
            else {
                photo = [[PhotoGalleryViewController alloc]  initWithNibName:@"PhotoGalleryViewController" bundle:nil];
            }
            [self.navigationController pushViewController:photo animated:YES];
        }
            break;
        case 8:
        {
            ArticleViewController *article = [[ArticleViewController alloc]  initWithNibName:@"ArticleViewController" bundle:nil];
            [self.navigationController pushViewController:article animated:YES];
        }
            break;
        
        default:
            break;
    }
    
}

#pragma mark - Table View
-(void)registerCell
{
    [self.tblView registerNib:[UINib nibWithNibName:@"TriviaQuestionCell" bundle:nil] forCellReuseIdentifier:TriviaQuestionCellIdentifier];
}

#pragma mark Number of Section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
    /*if(offset < totalRecords && totalRecords>10) {
        return 2;
    }
    else
    {
        return 1;
    }*/
    
}

#pragma mark Number of Row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*if (temp) {
     return 10;
     }
     else {
     return 0;
     }*/
    
    /*if (section == 0) {
        return [CommonUtils getArrayCountFromArray:self.aryList];
    }
    else {
        return 1;
    }*/
    return 1;
}

#pragma mark Cell for Row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
        {
            return [self TriviaQuestionCellAtIndexPath:indexPath];
        }
            break;
            
        case 1:
        {
            static NSString *simpleTableIdentifier = @"TriviaAnswerCell";
            
            TriviaAnswerCell *cell = (TriviaAnswerCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib;
                if([CommonUtils isiPad])
                {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"TriviaAnswerCell" owner:self options:nil];
                }
                else
                {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"TriviaAnswerCell" owner:self options:nil];
                }
                cell = [nib objectAtIndex:0];
            }
            
            [cell.btnAns1 setTitle:[NSString stringWithFormat:@"  %@",ans1] forState:UIControlStateNormal];
            [cell.btnAns2 setTitle:[NSString stringWithFormat:@"  %@",ans2] forState:UIControlStateNormal];
            [cell.btnAns3 setTitle:[NSString stringWithFormat:@"  %@",ans3] forState:UIControlStateNormal];
            [cell.btnAns4 setTitle:[NSString stringWithFormat:@"  %@",ans4] forState:UIControlStateNormal];
            
            [cell.btnAns1 addTarget:self action:@selector(btnAns1Clicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnAns2 addTarget:self action:@selector(btnAns2Clicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnAns3 addTarget:self action:@selector(btnAns3Clicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnAns4 addTarget:self action:@selector(btnAns4Clicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
            
        }
            break;
            
           
        case 2:
        {
            static NSString *simpleTableIdentifier = @"TriviaButtonCell";
            
            TriviaButtonCell *cell = (TriviaButtonCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib;
                if([CommonUtils isiPad]) {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"TriviaButtonCell" owner:self options:nil];
                }
                else {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"TriviaButtonCell" owner:self options:nil];
                }
                cell = [nib objectAtIndex:0];
            }
            
            if (queCount+1 == 20)
            {
                [cell.btnNext setTitle:@"Finish" forState:UIControlStateNormal];
            }
            
            [cell.btnNext addTarget:self action:@selector(btnNextClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnQuitGame addTarget:self action:@selector(btnQuitGameClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnStartNew addTarget:self action:@selector(btnStartNewClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
            break;
            
        default:
        {
            static NSString * Identifier = @"defaultcell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
            if (cell==nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            }
            return cell;
        }
            break;
    }
}

#pragma mark - Trivia Answer Cell

-(void)btnAns1Clicked:(UIButton *)btnAns1 {
    [self stopTimer];
    Question *que = [[self.game aryQuestions] objectAtIndex:queCount];
    
    Answer *answer1 = [[que aryOptions] objectAtIndex:0];
    Answer *answer2 = [[que aryOptions] objectAtIndex:1];
    Answer *answer3 = [[que aryOptions] objectAtIndex:2];
    Answer *answer4 = [[que aryOptions] objectAtIndex:3];
    
    TriviaAnswerCell *cell = (TriviaAnswerCell *) [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    NSString *answered = @"yes";
    
    if ([answer1 isRight]) {
        
        
        NSNumber *time = [NSNumber numberWithInteger:answerTime];
        NSDictionary *dict = @{@"result":@"1",@"time":time,@"answered":answered};
        [aryResults replaceObjectAtIndex:queCount withObject:dict];
        
        [cell.btnAns1 setBackgroundColor:[UIColor greenColor]];
        [cell.btnAns2 setBackgroundColor:answer2.color];
        [cell.btnAns3 setBackgroundColor:answer3.color];
        [cell.btnAns4 setBackgroundColor:answer4.color];
    }
    else {
        NSNumber *time = [NSNumber numberWithInteger:answerTime];
        NSDictionary *dict = @{@"result":@"0",@"time":time,@"answered":answered};
        [aryResults replaceObjectAtIndex:queCount withObject:dict];

        
        [cell.btnAns1 setBackgroundColor:[UIColor redColor]];
        [cell.btnAns2 setBackgroundColor:answer2.color];
        [cell.btnAns3 setBackgroundColor:answer3.color];
        [cell.btnAns4 setBackgroundColor:answer4.color];
    }
    
    if ([que.ans isEqualToString:@"1"]) {
        [cell.btnAns1 setBackgroundColor:[UIColor greenColor]];
    }
    else if ([que.ans isEqualToString:@"2"]) {
        [cell.btnAns2 setBackgroundColor:[UIColor greenColor]];
    }
    else if ([que.ans isEqualToString:@"3"]) {
        [cell.btnAns3 setBackgroundColor:[UIColor greenColor]];
    }
    else  {
        [cell.btnAns4 setBackgroundColor:[UIColor greenColor]];
    }
}

-(void)btnAns2Clicked:(UIButton *)btnAns2 {
    [self stopTimer];
    Question *que = [[self.game aryQuestions] objectAtIndex:queCount];
    
    Answer *answer1 = [[que aryOptions] objectAtIndex:0];
    Answer *answer2 = [[que aryOptions] objectAtIndex:1];
    Answer *answer3 = [[que aryOptions] objectAtIndex:2];
    Answer *answer4 = [[que aryOptions] objectAtIndex:3];
    
    TriviaAnswerCell *cell = (TriviaAnswerCell *) [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    NSString *answered = @"yes";
    if ([answer2 isRight]) {
        NSNumber *time = [NSNumber numberWithInteger:answerTime];
        NSDictionary *dict = @{@"result":@"1",@"time":time,@"answered":answered};
        [aryResults replaceObjectAtIndex:queCount withObject:dict];
        
        [cell.btnAns1 setBackgroundColor:answer1.color];
        [cell.btnAns2 setBackgroundColor:[UIColor greenColor]];
        [cell.btnAns3 setBackgroundColor:answer3.color];
        [cell.btnAns4 setBackgroundColor:answer4.color];
    }
    else {
        NSNumber *time = [NSNumber numberWithInteger:answerTime];
        NSDictionary *dict = @{@"result":@"0",@"time":time,@"answered":answered};
        [aryResults replaceObjectAtIndex:queCount withObject:dict];
        
        [cell.btnAns1 setBackgroundColor:answer1.color];
        [cell.btnAns2 setBackgroundColor:[UIColor redColor]];
        [cell.btnAns3 setBackgroundColor:answer3.color];
        [cell.btnAns4 setBackgroundColor:answer4.color];
    }
    
    
    if ([que.ans isEqualToString:@"1"]) {
        [cell.btnAns1 setBackgroundColor:[UIColor greenColor]];
    }
    else if ([que.ans isEqualToString:@"2"]) {
        [cell.btnAns2 setBackgroundColor:[UIColor greenColor]];
    }
    else if ([que.ans isEqualToString:@"3"]) {
        [cell.btnAns3 setBackgroundColor:[UIColor greenColor]];
    }
    else  {
        [cell.btnAns4 setBackgroundColor:[UIColor greenColor]];
    }
}

-(void)btnAns3Clicked:(UIButton *)btnAns3 {
    [self stopTimer];
    Question *que = [[self.game aryQuestions] objectAtIndex:queCount];
    
    Answer *answer1 = [[que aryOptions] objectAtIndex:0];
    Answer *answer2 = [[que aryOptions] objectAtIndex:1];
    Answer *answer3 = [[que aryOptions] objectAtIndex:2];
    Answer *answer4 = [[que aryOptions] objectAtIndex:3];
    
    TriviaAnswerCell *cell = (TriviaAnswerCell *) [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    NSString *answered = @"yes";
    if ([answer3 isRight]) {
        NSNumber *time = [NSNumber numberWithInteger:answerTime];
        NSDictionary *dict = @{@"result":@"1",@"time":time,@"answered":answered};
        [aryResults replaceObjectAtIndex:queCount withObject:dict];
        
        [cell.btnAns1 setBackgroundColor:answer1.color];
        [cell.btnAns2 setBackgroundColor:answer2.color];
        [cell.btnAns3 setBackgroundColor:[UIColor greenColor]];
        [cell.btnAns4 setBackgroundColor:answer4.color];
    }
    else {
        NSNumber *time = [NSNumber numberWithInteger:answerTime];
        NSDictionary *dict = @{@"result":@"0",@"time":time,@"answered":answered};
        [aryResults replaceObjectAtIndex:queCount withObject:dict];
        
        [cell.btnAns1 setBackgroundColor:answer1.color];
        [cell.btnAns2 setBackgroundColor:answer2.color];
        [cell.btnAns3 setBackgroundColor:[UIColor redColor]];
        [cell.btnAns4 setBackgroundColor:answer4.color];
    }
    
    
    if ([que.ans isEqualToString:@"1"]) {
        [cell.btnAns1 setBackgroundColor:[UIColor greenColor]];
    }
    else if ([que.ans isEqualToString:@"2"]) {
        [cell.btnAns2 setBackgroundColor:[UIColor greenColor]];
    }
    else if ([que.ans isEqualToString:@"3"]) {
        [cell.btnAns3 setBackgroundColor:[UIColor greenColor]];
    }
    else  {
        [cell.btnAns4 setBackgroundColor:[UIColor greenColor]];
    }
}

-(void)btnAns4Clicked:(UIButton *)btnAns4 {
    [self stopTimer];
    Question *que = [[self.game aryQuestions] objectAtIndex:queCount];
    
    Answer *answer1 = [[que aryOptions] objectAtIndex:0];
    Answer *answer2 = [[que aryOptions] objectAtIndex:1];
    Answer *answer3 = [[que aryOptions] objectAtIndex:2];
    Answer *answer4 = [[que aryOptions] objectAtIndex:3];
    
    TriviaAnswerCell *cell = (TriviaAnswerCell *) [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    NSString *answered = @"yes";
    if ([answer4 isRight]) {
        NSNumber *time = [NSNumber numberWithInteger:answerTime];
        NSDictionary *dict = @{@"result":@"1",@"time":time,@"answered":answered};
        [aryResults replaceObjectAtIndex:queCount withObject:dict];
        
        [cell.btnAns1 setBackgroundColor:answer1.color];
        [cell.btnAns2 setBackgroundColor:answer2.color];
        [cell.btnAns3 setBackgroundColor:answer3.color];
        [cell.btnAns4 setBackgroundColor:[UIColor greenColor]];
    }
    else {
        NSNumber *time = [NSNumber numberWithInteger:answerTime];
        NSDictionary *dict = @{@"result":@"0",@"time":time,@"answered":answered};
        [aryResults replaceObjectAtIndex:queCount withObject:dict];
        
        [cell.btnAns1 setBackgroundColor:answer1.color];
        [cell.btnAns2 setBackgroundColor:answer2.color];
        [cell.btnAns3 setBackgroundColor:answer3.color];
        [cell.btnAns4 setBackgroundColor:[UIColor redColor]];
    }
    
    if ([que.ans isEqualToString:@"1"]) {
        [cell.btnAns1 setBackgroundColor:[UIColor greenColor]];
    }
    else if ([que.ans isEqualToString:@"2"]) {
        [cell.btnAns2 setBackgroundColor:[UIColor greenColor]];
    }
    else if ([que.ans isEqualToString:@"3"]) {
        [cell.btnAns3 setBackgroundColor:[UIColor greenColor]];
    }
    else  {
        [cell.btnAns4 setBackgroundColor:[UIColor greenColor]];
    }
}

#pragma mark - Trivia Button Cell

-(void)btnNextClicked:(UIButton *)btnNext {
    
    //,@"answered":answered
    
    
    
    NSDictionary *dict = [aryResults objectAtIndex:queCount];
    NSString *answered = [dict valueForKey:@"answered"];
    
    if ([answered isEqualToString:@"no"]) {
        NSString *result = [dict valueForKey:@"result"];
        NSNumber * time = [NSNumber numberWithInteger:answerTime];
        
        NSDictionary *dict_ = @{@"result":result,@"time":time,@"answered":answered};
        
        [aryResults replaceObjectAtIndex:queCount withObject:dict_];
    }
    
    queCount++;
    
    if (queCount >= totalCount) {
        [self stopTimer];
        queCount = totalCount -1;
        NSLog(@"que count = %ld",(long)queCount);
        NSLog(@"Result = %@",aryResults);
        
        Result *result = [Result getResultWithArray:aryResults];
        
        NSLog(@"Result = %@",result.result);
        NSLog(@"Duration = %@",result.duration);
        
        
        TriviaGameResultViewController *gameResult = [[TriviaGameResultViewController alloc]  initWithNibName:@"TriviaGameResultViewController" bundle:nil];
        gameResult.result = result;
        [self.navigationController pushViewController:gameResult animated:YES];
        
        return;
    }

    
    NSLog(@"que count = %ld",(long)queCount);
    
    NSInteger realCount = queCount+1;
    queNumber = [NSString stringWithFormat:@"%ld/%ld",(long)realCount,(long)totalCount];
    
    self.lblQueCount.text = queNumber;
    
    
    [self resetTimer];
    
    [self updateQuestion];
    
    [self.tblView reloadData];
}

-(void)btnQuitGameClicked:(UIButton *)btnQuitGame {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeScreen" object:nil];
}

-(void)btnStartNewClicked:(UIButton *)btnStartNew {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark
#pragma mark - TriviaQuestionCell Cell Configuration
- (TriviaQuestionCell *)TriviaQuestionCellAtIndexPath:(NSIndexPath *)indexPath
{
    static TriviaQuestionCell *cell = nil;
    cell = [self.tblView dequeueReusableCellWithIdentifier:TriviaQuestionCellIdentifier];
    [self configureTriviaQuestionCell:cell atIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)configureTriviaQuestionCell:(TriviaQuestionCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    cell.lblQue.text = question;
    
}


#pragma mark Height For Row

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section)
    {
            // TriviaQuestionCell
        case 0:
        {
            CGFloat cellHeight = [self heightForTriviaQuestionCellAtIndexPath:indexPath];
            return cellHeight;
        }
            break;
            
            // TriviaAnswerCell
        case 1:
            return 208;
            break;
        
            // TriviaButtonCell
        case 2:
            return 69;
            break;
            
        default:
        {
            return 0;
        }
    }
}

#pragma mark
#pragma mark TriviaQuestionCell Cell With Height Configuration
- (CGFloat)heightForTriviaQuestionCellAtIndexPath:(NSIndexPath *)indexPath
{
    static TriviaQuestionCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tblView dequeueReusableCellWithIdentifier:TriviaQuestionCellIdentifier];
    });
    
    [self configureTriviaQuestionCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

#pragma mark Calculate Height for Cell

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell
{
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tblView.frame), CGRectGetHeight(sizingCell.bounds));
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}

#pragma mark Estmated Height For Row
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
            // TriviaQuestionCell
        case 0:
            return 43;
            break;
            
            // TriviaAnswerCell
        case 1:
            return 208;
            break;
            
            // TriviaButtonCell
        case 2:
            return 69;
            break;
        default:
            return 0;
    }
    
}
#pragma mark Did Select Row
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}



#pragma mark - Oriantation

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self setStatusBarVisibility];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         CGSize blankImageSize = CGSizeMake(self.view.bounds.size.width, 64);
         UIImage *blank = [CommonUtils imageFromColor:[UIColor colorWithRed:187.0/255.0 green:124.0/255.0 blue:37.0/255.0 alpha:1.0] forSize:blankImageSize withCornerRadius:0.0];
         [CommonUtils setNavigationBarImage:blank forNavigationBar:self.navigationController.navigationBar];
         
         UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
         
         switch (orientation) {
             case UIInterfaceOrientationPortrait:
             case UIInterfaceOrientationPortraitUpsideDown:
                 if (![CommonUtils isiPad]) {
                     
                     
                     if ([CommonUtils isIPhone4]) {
                     }
                     else if ([CommonUtils isIPhone5]) {
                     }
                     else if ([CommonUtils isIPhone6]) {
                     }
                     else {
                     }
                     
                     
                 }
                 else {
                 }
                 
                 
                 break;
                 
             case UIInterfaceOrientationLandscapeLeft:
             case UIInterfaceOrientationLandscapeRight:
                 if (![CommonUtils isiPad]) {
                     
                     if ([CommonUtils isIPhone4_Landscape]) {
                     }
                     else if ([CommonUtils isIPhone5_Landscape]) {
                     }
                     else if ([CommonUtils isIPhone6_Landscape]) {
                     }
                     else {
                         self.navigationController.navigationBar.frame = CGRectMake(0,32, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height+20);
                         
                     }
                 }
                 else {
                 }
                 break;
                 
             default:
                 break;
         }
         
         
         
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}





@end
