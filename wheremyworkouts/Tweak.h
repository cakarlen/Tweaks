@interface MailboxPickerController : UITableViewController
@end

@interface EMMessageList : NSObject
@end

@interface EMMessage : NSObject
@end

@interface MessageListViewController : UIViewController
@property(retain, nonatomic) EMMessageList *messageList;
@end
