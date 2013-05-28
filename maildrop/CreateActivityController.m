// Copyright (c) 2006-2013 Simon Fell
//
// Permission is hereby granted, free of charge, to any person obtaining a 
// copy of this software and associated documentation files (the "Software"), 
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense, 
// and/or sell copies of the Software, and to permit persons to whom the 
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included 
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN 
// THE SOFTWARE.
//

#import "CreateActivityController.h"
#import "Email.h"
#import "ZKSforce.h"
#import "ZKDescribeSObject_additions.h"
#import "Attachment.h"
#import "WhoWhat.h"
#import "Constants.h"
#import "CreateContactController.h"
#import "CreateLeadController.h"
#import "WhoWhatSearch.h"

@interface ZKSObject (AccountNameHelper)
-(NSString *)accountName;
@end

@interface CreateActivityController ()
@property (retain, nonatomic) ZKSforceClient *sforce;
@property (retain, nonatomic) ActivityBuilder *activityBuilder;
@end

@implementation ZKSObject (AccountNameHelper)

-(NSString *)accountName {
	if ([[self type] isEqualToString:LEAD])
		return [self fieldValue:@"Company"];
	return [[self fieldValue:@"Account"] fieldValue:@"Name"];
}

@end
@implementation CreateActivityController

@synthesize activityBuilder;
@synthesize email, closedTaskStatus;
@synthesize sforce, storeTaskStatusDefault;

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    if ([key isEqualToString:@"emailSubject"])
        return [NSSet setWithObject:@"email"];
    if ([key isEqualToString:@"hasStatusField"])
        return [NSSet setWithObject:@"email"];
    return [super keyPathsForValuesAffectingValueForKey:key];
}

- (void)dealloc {
	[sforce release];
	[selectedWho release];
	[selectedWhat release];
	[pendingTaskWhoWhat release];
	[taskStatus release];
	[closedTaskStatus release];
    [activityBuilder release];
    [subjectOnlyConstraints release];
    [subjectAndStatusConstraints release];
	[super dealloc];
}

-(void)awakeFromNib {
    NSDictionary *views = NSDictionaryOfVariableBindings(topContainer, subjectLabel, subjectText, statusLabel, statusPopup, statusDefaultCheckbox);
    for (NSView *view in [views allValues])
        [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSArray *h1 = [NSLayoutConstraint constraintsWithVisualFormat:@"|-[subjectLabel]-[subjectText(>=100)]-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:views];
    NSArray *h2 = [NSLayoutConstraint constraintsWithVisualFormat:@"|-[statusLabel]-[statusPopup(>=100)]-[statusDefaultCheckbox]-|"
                                                          options:NSLayoutFormatAlignAllBaseline metrics:nil views:views];
    
    // one of these is added later on.
    subjectAndStatusConstraints = [[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[subjectLabel]-[statusLabel]-|" options:0 metrics:nil views:views] retain];
    subjectOnlyConstraints      = [[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[subjectLabel]-|" options:0 metrics:nil views:views] retain];
    
    [topContainer addConstraints:h1];
    [topContainer addConstraints:h2];

    // make subjectText and statusPopup start at the same starting point left to right.
    [topContainer addConstraint:[NSLayoutConstraint constraintWithItem:subjectText
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:statusPopup
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1.0 constant:0]];
    
    // make the end of the statusText and the end of the checkbox line up
    [topContainer addConstraint:[NSLayoutConstraint constraintWithItem:subjectText
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:statusDefaultCheckbox
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1.0 constant:0]];
    [statusPopup setContentHuggingPriority:240 forOrientation:NSLayoutConstraintOrientationHorizontal];
    
    [[topContainer superview] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-2-[topContainer]" options:0 metrics:nil views:views]];
    [[topContainer superview] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[topContainer(>=400@800)]-|" options:0 metrics:nil views:views]];
}

- (IBAction)cancel:(id)sender {
	[NSApp abortModal];
}

- (void)windowWillClose:(NSNotification *)notification {
	[NSApp abortModal];
}

- (IBAction)showActivityHelp:(id)sender {
    [[NSApp delegate] showActivityHelp:sender];
}

- (ZKSObject *)selectedWho {
    return [whoController selected];
}

- (ZKSObject *)selectedWhat {
    return [whatController selected];
}

-(void)updateWhoWhat:(SObjectWhoWhat **)whoWhat from:(ZKSObject *)o {
	if (o == nil) {
		[*whoWhat release];
		*whoWhat = nil;
	} else {
		if (*whoWhat == nil) 
			*whoWhat = [[SObjectWhoWhat alloc] initWithClient:sforce];
		[*whoWhat setSobject:o];
	}
}

-(NSArray *)selectedWhoWhats {
	[self updateWhoWhat:&selectedWho from:[self selectedWho]];
	[self updateWhoWhat:&selectedWhat from:[self selectedWhat]];
	NSMutableArray *s = [NSMutableArray arrayWithCapacity:2];
	if (selectedWho != nil)  [s addObject:selectedWho];
	if (selectedWhat != nil) [s addObject:selectedWhat];
	[s addObject:pendingTaskWhoWhat];
	return s;
}

// there was a selection change in one of the results tables, notifiy that this changes the selectedWhoWhats property
-(void)tableViewSelectionDidChange:(NSNotification *)aNotification {
	[self willChangeValueForKey:@"selectedWhoWhats"];
	[self selectedWhoWhats];
	[self didChangeValueForKey:@"selectedWhoWhats"];
	for (Attachment *a in [email attachments]) {
		if ([a parentWhoWhat] == nil)
			[a setParentWhoWhat:selectedWho != nil ? selectedWho : selectedWhat];
	}
}

-(void)activityBuilder:(ActivityBuilder *)builder builtActivity:(ZKSObject *)activity {
    ZKSaveResult *sr = [[sforce create:[NSArray arrayWithObject:activity]] objectAtIndex:0];
	if ([sr success]) {
		taskId = [[sr id] copy];
		[pendingTaskWhoWhat setTaskId:[sr id]];
		[NSApp stopModal];
	} else {
		NSAlert * a = [NSAlert alertWithMessageText:@"Unable to create email"
                                      defaultButton:@"OK"
                                    alternateButton:nil
                                        otherButton:nil
                          informativeTextWithFormat:[sr message]];
		[a runModal];
	}
    self.activityBuilder = nil;
}

-(void)activityBuilderCanceled:(ActivityBuilder *)builder {
    self.activityBuilder = nil;
}

-(BOOL)hasStatusField {
    NSString *type = [[NSUserDefaults standardUserDefaults] objectForKey:EMAIL_ACTIVITY_TYPE_PREF];
    return [type isEqualToString:EMAIL_ACTIVITY_TYPE_TASK];
}

- (IBAction)create:(id)sender {
    NSString *type = [[NSUserDefaults standardUserDefaults] objectForKey:EMAIL_ACTIVITY_TYPE_PREF];
    Class builderType = [type isEqualToString:EMAIL_ACTIVITY_TYPE_TASK] ? [TaskActivityBuilder class] : [EventActivityBuilder class];
    ActivityBuilder *builder = [[[builderType alloc] init] autorelease];
    builder.email  = email;
    builder.who  = [self selectedWho];
    builder.what = [self selectedWhat];
    builder.status = [self closedTaskStatus];
    builder.sforce = sforce;
    builder.window = window;

    if (self.storeTaskStatusDefault)
		[[NSUserDefaults standardUserDefaults] setObject:builder.status forKey:DEFAULT_TASK_STATUS_PREF];

    self.activityBuilder = builder;
    [builder build:self];
}

-(void)createWhoWithController:(CreateContactController *)controller {
    NSString *type = [controller typeOfSObject];
    [controller showSheetFromEmail:self.email inWindow:window client:sforce created:^(NSString *recordId) {
        [whoController insertNewRecordOfType:type withId:recordId];
        
    } canceled:^ {
    }];
}

- (IBAction)showCreateContact:(id)sender {
    CreateContactController *c = [[[CreateContactController alloc] init] autorelease];
    [self createWhoWithController:c];
}

- (IBAction)showCreateLead:(id)sender {
    CreateLeadController *c = [[[CreateLeadController alloc] init] autorelease];
    [self createWhoWithController:c];
}

- (NSString *)emailSubject {
	return [email subject];
}

- (void)setEmailSubject:(NSString *)aEmailSubject {
	[email setSubject:aEmailSubject];
}

- (void)resetState {
    [whoController setSearchResults:nil];
    [whatController setWhatSearchResultsData:nil];
    [whoController setSearchText:@""];
    [whatController setSearchText:@""];
	[pendingTaskWhoWhat autorelease];
	pendingTaskWhoWhat = [[PendingTaskWhoWhat alloc] init];
}

- (NSString *)makeNotNull:(NSString *)s {
	 if (s == nil || [s length] == 0)
		return @" ";
	return s;
}

-(IBAction)configureWhatSearchColumns:(id)sender {
	[NSApp beginSheet:whatSearchConfigWindow modalForWindow:window modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

- (IBAction)closeWhatConfig:(id)sender {
	[NSApp endSheet:whatSearchConfigWindow];
	[whatSearchConfigWindow orderOut:sender];
}

-(NSArray *)taskStatus {
	if (taskStatus == nil && [sforce hasEntity:@"TaskStatus"]) {
		ZKQueryResult *qr = [sforce query:@"select MasterLabel,IsClosed from TaskStatus order by sortOrder"];
		taskStatus = [[qr records] retain];
	}
	return taskStatus;
}

-(NSString *)defaultTaskStatus {
	NSArray *s = [self taskStatus];
	NSEnumerator *re = [s reverseObjectEnumerator];
	ZKSObject *r;
	NSString *sysDefault = nil;
	NSString *userDefault = [[NSUserDefaults standardUserDefaults] stringForKey:DEFAULT_TASK_STATUS_PREF];
	BOOL sawUserDefault = NO;
	while (r = [re nextObject]) {
		// default is the last status with a IsClosed=true.
		if ((sysDefault == nil) && [r boolValue:@"IsClosed"])
			sysDefault = [r fieldValue:@"MasterLabel"];
		// double check that the users default still exists.
		if ((!sawUserDefault) && [[r fieldValue:@"MasterLabel"] isEqualToString:userDefault])
			sawUserDefault = YES;
	}
	return sawUserDefault ? userDefault : sysDefault;
}

- (void)setSforce:(ZKSforceClient *)sf {
	if (sf == sforce) return;
	[sforce autorelease];
	sforce = [sf retain];
    [whoController setSforce:sforce];
    [whatController setSforce:sforce];
    
    
	[taskStatus release];
	taskStatus = nil;
	[selectedWho release];
	selectedWho = nil;
	[selectedWhat release];
	selectedWhat = nil;
	[self willChangeValueForKey:@"taskStatus"];
	[self didChangeValueForKey:@"taskStatus"];
	[self willChangeValueForKey:@"selectedWhoWhats"];
	[self didChangeValueForKey:@"selectedWhoWhats"];
}

- (NSString *)createActivity:(Email *)theEmail sforce:(ZKSforceClient *)sf {
	[self resetState];
	[self setSforce:sf];
	[self setEmail:theEmail];
	whoController.searchText = email.addrOfInterest;
    whatController.searchText = email.subject;
	[self setClosedTaskStatus:[self defaultTaskStatus]];
	self.storeTaskStatusDefault = NO;
	[NSApp activateIgnoringOtherApps:YES];
	if ([whoController canSearch]) {
		NSTimer *t = [NSTimer timerWithTimeInterval:0.01 target:whoController selector:@selector(search:) userInfo:nil repeats:NO];
		[[NSRunLoop currentRunLoop] addTimer:t forMode:NSModalPanelRunLoopMode];
	}
    if (email.subject.length > 0) {
        NSTimer *t = [NSTimer timerWithTimeInterval:0.01 target:whatController selector:@selector(search:) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:t forMode:NSModalPanelRunLoopMode];
    }
    
    if ([self hasStatusField]) {
        [topContainer removeConstraints:subjectOnlyConstraints];
        [topContainer addConstraints:subjectAndStatusConstraints];
    } else {
        [topContainer removeConstraints:subjectAndStatusConstraints];
        [topContainer addConstraints:subjectOnlyConstraints];
    }
    
	[NSApp runModalForWindow:window];
	[window orderOut:self];
	// todo
	[self setEmail:nil];
	NSString *sfId = [taskId autorelease];
	taskId = nil;
	return sfId;
}

static const float MIN_PANE_SIZE = 70.0f;

- (CGFloat)splitView:(NSSplitView *)sender constrainMinCoordinate:(CGFloat)proposedMin ofSubviewAt:(NSInteger)offset {
	return proposedMin + (offset == 1 ? MIN_PANE_SIZE : MIN_PANE_SIZE *2);
}

- (CGFloat)splitView:(NSSplitView *)sender constrainMaxCoordinate:(CGFloat)proposedMax ofSubviewAt:(NSInteger)offset {
	return proposedMax - (offset == 1 ? MIN_PANE_SIZE : MIN_PANE_SIZE *2);
}

@end
