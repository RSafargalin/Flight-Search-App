//
//  TicketsViewController.m
//  FlightSearchApp
//
//  Created by Ruslan Safargalin on 31.05.2021.
//

#import "TicketsViewController.h"
#import "TicketCell.h"
#import "CoreDataHelper.h"
#import "NotificationCenter.h"

#define TicketCellReuseIdentifier @"TicketCellIdentifier"

@interface TicketsViewController ()

@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *tickets;

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UITextField *dateTextField;
@end

@implementation TicketsViewController

BOOL isFavorites;
TicketCell *notificationCell;

#pragma mark - Init

- (instancetype)initFavoriteTicketsController {
    self = [super init];
    if (self) {
//        [self defaultInit];
        isFavorites = YES;
        [self navigationControllerSetup];
        self.title = @"Избранное";
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 10.0;
        layout.minimumInteritemSpacing = 50.0;
        layout.itemSize = CGSizeMake(self.view.bounds.size.width, 140.0);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [self.collectionView registerClass: [TicketCell class] forCellWithReuseIdentifier:TicketCellReuseIdentifier];
        [self.view addSubview:_collectionView];
        [self segmentedControlSetup];
    }
    return self;
}


- (instancetype)initWithTickets:(NSArray *)tickets {
    self = [super init];
    if (self)
    {
        _tickets = tickets;
        self.title = @"Билеты";
        isFavorites = NO;
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 10.0;
        layout.minimumInteritemSpacing = 50.0;
        layout.itemSize = CGSizeMake(self.view.bounds.size.width, 140.0);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass: [TicketCell class] forCellWithReuseIdentifier:TicketCellReuseIdentifier];
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        _datePicker.minimumDate = [NSDate date];
        
        _dateTextField = [[UITextField alloc] initWithFrame:self.view.bounds];
        _dateTextField.hidden = YES;
        _dateTextField.inputView = _datePicker;
        
        UIToolbar *keyboardToolbar = [[UIToolbar alloc] init];
        [keyboardToolbar sizeToFit];
        keyboardToolbar.backgroundColor = UIColor.systemRedColor;
        UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonDidTap:)];
        keyboardToolbar.items = @[flexBarButton, doneBarButton];
        
        _dateTextField.inputAccessoryView = keyboardToolbar;
        
        [self.view addSubview:_dateTextField];
        [self.view addSubview:_collectionView];
        
    }
    return self;
}

- (void) defaultInit {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.minimumLineSpacing = 10.0;
    layout.minimumInteritemSpacing = 50.0;
    layout.itemSize = CGSizeMake(self.view.bounds.size.width, 140.0);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void) navigationControllerSetup {
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.view.backgroundColor = [UIColor systemBackgroundColor];
}

- (void) segmentedControlSetup {
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"In search", @"On map"]];
    [_segmentedControl addTarget:self
                          action:@selector(changeSource)
                forControlEvents:UIControlEventValueChanged];
    
    _segmentedControl.tintColor = [UIColor blackColor];
    self.navigationItem.titleView = _segmentedControl;
    _segmentedControl.selectedSegmentIndex = 0;
    [self changeSource];
}

- (void)changeSource {
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0:
            _tickets = [[NSMutableArray alloc] initWithArray: [[CoreDataHelper sharedInstance] favoritesFromMap: NO]];
            break;
        case 1:
            _tickets = [[NSMutableArray alloc] initWithArray: [[CoreDataHelper sharedInstance] favoritesFromMap: YES]];
            break;
        default:
            break;
    }
    [self.collectionView reloadData];
}

#pragma mark - Collection view data source

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TicketCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: TicketCellReuseIdentifier forIndexPath: indexPath];
    
    if (isFavorites) {
        cell.favoriteTicket = [_tickets objectAtIndex:indexPath.row];
    } else {
        cell.ticket = [_tickets objectAtIndex:indexPath.row];
    }
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _tickets.count;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (isFavorites) return;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Действия с билетом" message:@"Что необходимо сделать с выбранным билетом?" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *favoriteAction;
    if ([[CoreDataHelper sharedInstance] isFavorite: [_tickets objectAtIndex:indexPath.row]]) {
        favoriteAction = [UIAlertAction actionWithTitle:@"Удалить из избранного" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[CoreDataHelper sharedInstance] removeFromFavorite:[self->_tickets objectAtIndex:indexPath.row]];
        }];
    } else {
        favoriteAction = [UIAlertAction actionWithTitle:@"Добавить в избранное" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[CoreDataHelper sharedInstance] addToFavorite:[self->_tickets objectAtIndex:indexPath.row]];
        }];
    }
    
    UIAlertAction *notificationAction = [UIAlertAction actionWithTitle:@"Напомнить" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        notificationCell = [collectionView cellForItemAtIndexPath:indexPath];
        [self->_dateTextField becomeFirstResponder];
        }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:favoriteAction];
    [alertController addAction:notificationAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    cell.transform = CGAffineTransformMakeTranslation(0, cell.frame.size.height);
    cell.alpha = 0;
       
       [UIView animateWithDuration:0.5 delay:0.03 * indexPath.row
   usingSpringWithDamping:1 initialSpringVelocity:0.1
   options:UIViewAnimationOptionCurveEaseInOut animations:^{
           
           cell.alpha = 1;
           cell.transform = CGAffineTransformMakeTranslation(0, 0);
           
       } completion:nil];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    cell.transform = CGAffineTransformMakeTranslation(0, 0);
    cell.alpha = 0;
       
       [UIView animateWithDuration:0.5 delay:0.03 * indexPath.row
   usingSpringWithDamping:1 initialSpringVelocity:0.1
   options:UIViewAnimationOptionCurveEaseInOut animations:^{
           
           cell.alpha = 1;
           cell.transform = CGAffineTransformMakeTranslation(0, cell.frame.size.height);
           
       } completion:nil];
}

- (void)doneButtonDidTap:(UIBarButtonItem *)sender
{
    if (_datePicker.date && notificationCell) {
        NSString *message = [NSString stringWithFormat:@"%@ - %@ за %@ руб.", notificationCell.ticket.from, notificationCell.ticket.to, notificationCell.ticket.price];

        NSURL *imageURL;
        Notification notification = NotificationMake(@"Напоминание о билете", message, _datePicker.date, imageURL);
        [[NotificationCenter sharedInstance] sendNotification:notification];

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Успешно" message:[NSString stringWithFormat:@"Уведомление будет отправлено - %@", _datePicker.date] preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            self->_dateTextField.canResignFirstResponder;
            self->_dateTextField.hidden = YES;
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    _datePicker.date = [NSDate date];
    notificationCell = nil;
    [self.view endEditing:YES];
}
@end
