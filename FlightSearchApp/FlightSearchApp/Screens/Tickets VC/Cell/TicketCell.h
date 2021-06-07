//
//  TicketCell.h
//  FlightSearchApp
//
//  Created by Ruslan Safargalin on 31.05.2021.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "NetworkService.h"
#import "Ticket.h"
#import "CoreDataHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface TicketCell : UICollectionViewCell
@property (nonatomic, strong) Ticket *ticket;
@property (nonatomic, strong) TicketCoreData *favoriteTicket;
@property (nonatomic, strong) UIImageView *airlineLogoView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *placesLabel;
@property (nonatomic, strong) UILabel *dateLabel;
- (instancetype)init;
@end

NS_ASSUME_NONNULL_END
