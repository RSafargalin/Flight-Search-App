//
//  TicketCell.m
//  FlightSearchApp
//
//  Created by Ruslan Safargalin on 31.05.2021.
//

#import "TicketCell.h"
#import "Ticket.h"
#import "CoreDataHelper.h"

@implementation TicketCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.layer.shadowColor = [[[UIColor blackColor] colorWithAlphaComponent:0.2] CGColor];
        self.contentView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
        self.contentView.layer.shadowRadius = 10.0;
        self.contentView.layer.shadowOpacity = 1.0;
        self.contentView.layer.cornerRadius = 6.0;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _priceLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _priceLabel.font = [UIFont systemFontOfSize:24.0 weight:UIFontWeightBold];
        [self.contentView addSubview:_priceLabel];
        
        _airlineLogoView = [[UIImageView alloc] initWithFrame:self.bounds];
        _airlineLogoView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_airlineLogoView];
        
        _placesLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _placesLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightLight];
        _placesLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_placesLabel];
        
        _dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _dateLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightRegular];
        [self.contentView addSubview:_dateLabel];
        
    } else {
        NSLog(@"error");
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.frame = CGRectMake(10.0, 10.0, [UIScreen mainScreen].bounds.size.width - 20.0, self.frame.size.height - 20.0);
    _priceLabel.frame = CGRectMake(10.0, 10.0, self.contentView.frame.size.width - 110.0, 40.0);
    _airlineLogoView.frame = CGRectMake(CGRectGetMaxX(_priceLabel.frame) + 10.0, 10.0, 80.0, 80.0);
    _placesLabel.frame = CGRectMake(10.0, CGRectGetMaxY(_priceLabel.frame) + 8.0, 100.0, 20.0);
    _dateLabel.frame = CGRectMake(10.0, CGRectGetMaxY(_placesLabel.frame) + 8.0, self.contentView.frame.size.width - 20.0, 20.0);
}

- (void)setTicket:(Ticket *)ticket {
    _ticket = ticket;
    
    _priceLabel.text = [NSString stringWithFormat:@"%@ ₽.", ticket.price];
    _placesLabel.text = [NSString stringWithFormat:@"%@ - %@", ticket.from, ticket.to];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd MMMM yyyy hh:mm";
    _dateLabel.text = [dateFormatter stringFromDate:ticket.departure];
}

- (void)setFavoriteTicket:(TicketCoreData *)favoriteTicket {
    _favoriteTicket = favoriteTicket;
    
    _priceLabel.text = [NSString stringWithFormat:@"%lld ₽.", favoriteTicket.price];
    _placesLabel.text = [NSString stringWithFormat:@"%@ - %@", favoriteTicket.from, favoriteTicket.to];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd MMMM yyyy hh:mm";
    _dateLabel.text = [dateFormatter stringFromDate:favoriteTicket.departure];
}






@end
