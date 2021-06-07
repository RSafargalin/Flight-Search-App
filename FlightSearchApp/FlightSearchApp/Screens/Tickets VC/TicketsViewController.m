//
//  TicketsViewController.m
//  FlightSearchApp
//
//  Created by Ruslan Safargalin on 31.05.2021.
//

#import "TicketsViewController.h"
#import "TicketCell.h"
#import "CoreDataHelper.h"

#define TicketCellReuseIdentifier @"TicketCellIdentifier"

@interface TicketsViewController ()

@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *tickets;

@end

@implementation TicketsViewController

BOOL isFavorites;

#pragma mark - Init

- (instancetype)initFavoriteTicketsController {
    self = [super init];
    if (self) {
//        [self defaultInit];
        isFavorites = YES;
        self.tickets = [NSArray new];
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
    }
    return self;
}


- (instancetype)initWithTickets:(NSArray *)tickets {
    self = [super init];
    if (self)
    {
//        [self defaultInit];
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
    
    if (isFavorites) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        _tickets = [[CoreDataHelper sharedInstance] favorites];
        [self.collectionView reloadData];
    }
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
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:favoriteAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
