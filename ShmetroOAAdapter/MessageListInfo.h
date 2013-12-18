//
//  MessageListInfo.h
//  ShmetroOA
//
//  Created by gisteam on 6/13/13.
//
//

#import <Foundation/Foundation.h>

@interface MessageListInfo : NSObject{
    NSString *messageId;
    NSString *title;
    NSString *pubDate;
}
@property(nonatomic,retain)NSString *messageId;
@property(nonatomic,retain)NSString *title;
@property(nonatomic,retain)NSString *pubDate;
@end
