//
//  PointCell.m
//  FlightSearchApp
//
//  Created by Ruslan Safargalin on 23.05.2021.
//

#import "PointCell.h"

@implementation PointCell
  
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void) configureWithName: (NSString*) name andCode: (NSString*) code {
    self.textLabel.text = name;
    self.detailTextLabel.text = code;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
