/*
 * Entourage.h
 */

#import <AppKit/AppKit.h>
#import <ScriptingBridge/ScriptingBridge.h>


@class EntourageExchangeAccount, EntourageApplication, EntouragePrintSettings, EntourageWindow, EntourageServerSettings, EntouragePOPAccount, EntourageIMAPAccount, EntourageNewsServer, EntourageLDAPServer, EntourageDelegatedAccount, EntourageOtherUserAccount, EntourageHotmailAccount, EntourageFolder, EntourageNewsGroup, EntourageMessage, EntourageIncomingMessage, EntourageOutgoingMessage, EntourageSMIMESignerInfo, EntourageDraftWindow, EntourageDraftNewsWindow, EntourageMessageWindow, EntourageBrowserWindow, EntourageAddress, EntourageRecipient, EntourageAttachment, EntouragePart, EntourageCalendar, EntourageExchangeCalendar, EntourageEvent, EntourageSchedule, EntourageSignature, EntourageMailingList, EntourageTask, EntourageNote, EntourageIdentity, EntourageCategory, EntourageProject, EntourageCustomView, EntourageMultitypeCustomView, EntourageMailCustomView, EntourageContactsCustomView, EntourageCalendarCustomView, EntourageTasksCustomView, EntourageNotesCustomView, EntourageAddressBook, EntourageExchangeAddressBook, EntourageLDAPAddressList, EntourageContact, EntourageContactWindow, EntourageEmailAddress, EntourageInstantMessageAddress, EntouragePostalAddress, EntourageGroup, EntourageGroupEntry, EntourageImageSettings, EntourageActiveSearch;

enum EntourageXtyp {
	EntourageXtypAll = 'all ' /* all */,
	EntourageXtypCategoryType = 'xcat' /* categories */,
	EntourageXtypProjectType = 'xprj' /* projects */
};
typedef enum EntourageXtyp EntourageXtyp;

enum EntourageXitm {
	EntourageXitmMailItems = 'Xmal' /* mail */,
	EntourageXitmContactItems = 'Xcon' /* contacts */,
	EntourageXitmEventItems = 'Xevt' /* calendar events */,
	EntourageXitmTasksItems = 'Xtsk' /* tasks */,
	EntourageXitmNoteItems = 'Xnot' /* notes */,
	EntourageXitmFileItems = 'Xfil' /* files */,
	EntourageXitmAllItems = 'Xall' /* all */
};
typedef enum EntourageXitm EntourageXitm;

enum EntourageXfmt {
	EntourageXfmtArchive = 'rge ' /* archive */,
	EntourageXfmtContacts = 'cnts' /* tab delimited contacts */
};
typedef enum EntourageXfmt EntourageXfmt;

enum EntourageCnfl {
	EntourageCnflStop = 'stop' /* stop importing if there are conflicts */,
	EntourageCnflSkip = 'skip' /* do not import conflicting records */,
	EntourageCnflReplace = 'rplc' /* overwrite records from the archive */
};
typedef enum EntourageCnfl EntourageCnfl;

enum EntourageSavo {
	EntourageSavoYes = 'yes ' /* Save objects now */,
	EntourageSavoNo = 'no  ' /* Do not save objects */,
	EntourageSavoAsk = 'ask ' /* Ask the user whether to save */
};
typedef enum EntourageSavo EntourageSavo;

enum EntourageKfrm {
	EntourageKfrmIndex = 'indx' /* keyform designating indexed access */,
	EntourageKfrmNamed = 'name' /* keyform designating named access */,
	EntourageKfrmId = 'ID  ' /* keyform designating access by unique identifier */
};
typedef enum EntourageKfrm EntourageKfrm;

enum EntourageEnum {
	EntourageEnumStandard = 'lwst' /* Standard PostScript error handling   */,
	EntourageEnumDetailed = 'lwdt' /* print a detailed report of PostScript errors */
};
typedef enum EntourageEnum EntourageEnum;

enum EntourageESTy {
	EntourageESTyNone = 'eSNn' /* No signature */,
	EntourageESTyRandom = 'eRnS' /* A random signature */,
	EntourageESTyOther = 'eOtS' /* A signature specified by the signature choice */
};
typedef enum EntourageESTy EntourageESTy;

enum EntourageSmSE {
	EntourageSmSENone = 'eSNn' /* The message is not signed with SMIME */,
	EntourageSmSEValid = 'smVS' /* The signature/signer is valid */,
	EntourageSmSEInvalid = 'smIS' /* The signature/signer is invalid */
};
typedef enum EntourageSmSE EntourageSmSE;

enum EntourageSmRv {
	EntourageSmRvUnknown = 'smRu' /* The status is not known */,
	EntourageSmRvValid = 'smVS' /* The signer's certificate has not been revoked */,
	EntourageSmRvRevoked = 'smRV' /* The signer's certificate has been revoked */
};
typedef enum EntourageSmRv EntourageSmRv;

enum EntourageAtrE {
	EntourageAtrENoAttribution = 'atrN' /* Use no attribution */,
	EntourageAtrEInternetAttribution = 'atrI' /* Use internet-style attribution */,
	EntourageAtrEShortAttribution = 'atrS' /* Use short header attribution */
};
typedef enum EntourageAtrE EntourageAtrE;

enum EntourageErty {
	EntourageErtyToRecipient = '!to ' /* “To” recipient */,
	EntourageErtyCcRecipient = '!cc ' /* “CC (carbon copy)” recipient */,
	EntourageErtyBccRecipient = '!bcc' /* “BCC (blind carbon copy)” recipient */,
	EntourageErtyNewsgroupRecipient = '!nws' /* “Newsgroup” recipient */
};
typedef enum EntourageErty EntourageErty;

enum EntourageEdlv {
	EntourageEdlvUnsent = 'unst' /* Message has not been sent yet */,
	EntourageEdlvSent = 'sent' /* Message has been sent */
};
typedef enum EntourageEdlv EntourageEdlv;

enum EntourageErds {
	EntourageErdsUntouched = 'untc' /* Message has not been read */,
	EntourageErdsRead = 'read' /* Message has been read */
};
typedef enum EntourageErds EntourageErds;

enum EntourageFlag {
	EntourageFlagUnflag = 'unfl' /* Is not flagged */,
	EntourageFlagFlag = 'flag' /* Has been flagged */,
	EntourageFlagComplete = 'cmpt' /* Is completed */
};
typedef enum EntourageFlag EntourageFlag;

enum EntourageEpty {
	EntourageEptyLowest = '!low' /* Lowest priority (5) */,
	EntourageEptyLow = '!pr4' /* Low priority (4) */,
	EntourageEptyNormal = '!nrm' /* Normal priority (3) */,
	EntourageEptyHigh = '!pr2' /* High priority (2) */,
	EntourageEptyHighest = '!hgh' /* Highest priority (1) */
};
typedef enum EntourageEpty EntourageEpty;

enum EntourageEEnc {
	EntourageEEncNoEncoding = 'eNoE' /* No encoding */,
	EntourageEEnc7bitEncoding = 'e7BE' /* 7-bit encoding */,
	EntourageEEnc8bitEncoding = 'e8BE' /* 8-bit encoding */,
	EntourageEEncBinhex = 'eBnH' /* Binhex encoding */,
	EntourageEEncBase64 = 'eB64' /* Base64 encoding */,
	EntourageEEncUuencode = 'eUUE' /* UUEncode encoding */,
	EntourageEEncAppleSingle = 'eApS' /* AppleSingle encoding */,
	EntourageEEncAppleDouble = 'eApD' /* AppleDouble encoding */,
	EntourageEEncQuotedPrintable = 'eQP ' /* Quoted-printable encoding */,
	EntourageEEncUnknownEncoding = 'eUnK' /* Unknown encoding */
};
typedef enum EntourageEEnc EntourageEEnc;

enum EntourageEAEn {
	EntourageEAEnBinhex = 'eBnH' /* Binhex encoding */,
	EntourageEAEnBase64 = 'eB64' /* Base64 encoding */,
	EntourageEAEnUuencode = 'eUUE' /* UUEncode encoding */,
	EntourageEAEnAppleDouble = 'eApD' /* AppleDouble encoding */
};
typedef enum EntourageEAEn EntourageEAEn;

enum EntourageECmp {
	EntourageECmpNoCompression = 'cmNo' /* No compression */,
	EntourageECmpZIPCompression = 'cmSt' /* ZIP compression */
};
typedef enum EntourageECmp EntourageECmp;

enum EntourageArEn {
	EntourageArEnMailArea = 'arMl' /* The mail area */,
	EntourageArEnAddressBookArea = 'arCn' /* The address book area */,
	EntourageArEnCalendarArea = 'arCl' /* The calendar area */,
	EntourageArEnTasksArea = 'arTs' /* The tasks area */,
	EntourageArEnNotesArea = 'arNt' /* The notes area */,
	EntourageArEnProjectCenterArea = 'arCV' /* The project center area */,
	EntourageArEnCustomViewsArea = 'arCV' /* The custom views area */
};
typedef enum EntourageArEn EntourageArEn;

enum EntourageESvS {
	EntourageESvSNotOnServer = 'ssNt' /* The message isn't on a server */,
	EntourageESvSHeadersOnly = 'ssHo' /* Only the headers have been downloaded */,
	EntourageESvSPartiallyDownloaded = 'ssPr' /* The message has been partially downloaded */,
	EntourageESvSFullyDownloaded = 'ssFd' /* The message has been fully downloaded */
};
typedef enum EntourageESvS EntourageESvS;

enum EntourageECnA {
	EntourageECnAKeepOnServer = 'caLv' /* The message will be left on the server */,
	EntourageECnADownloadAtNextConnection = 'caDw' /* The message will be fully downloaded from the server */,
	EntourageECnARemoveAtNextConnection = 'caRm' /* The message will be removed from the server */
};
typedef enum EntourageECnA EntourageECnA;

enum EntourageItyp {
	EntourageItypMBOX = 'MBOX' /* import from MBOX */,
	EntourageItypArchive = 'rge ' /* import from archive (.rge) */
};
typedef enum EntourageItyp EntourageItyp;

enum EntourageXAIt {
	EntourageXAItMailItems = 'Xmal' /* messages */,
	EntourageXAItContactItems = 'Xcon' /* contacts */,
	EntourageXAItCalendarItems = 'Xevt' /* calendar events */,
	EntourageXAItTaskItems = 'Xtsk' /* tasks */,
	EntourageXAItNoteItems = 'Xnot' /* notes */,
	EntourageXAItProjectFiles = 'Xfil' /* files included in the project */,
	EntourageXAItAllItems = 'Xall' /* all */
};
typedef enum EntourageXAIt EntourageXAIt;

enum EntourageEFBt {
	EntourageEFBtBusy = 'eSBu' /* busy */,
	EntourageEFBtFree = 'eSFr' /* free */,
	EntourageEFBtTentative = 'eSTe' /* tentative */,
	EntourageEFBtOutOfOffice = 'eSOO' /* out of office */
};
typedef enum EntourageEFBt EntourageEFBt;

enum EntourageEExF {
	EntourageEExFLocal = 'eLFL' /* accessed as the local folder */,
	EntourageEExFExchangePersonal = 'ePFL' /* accessed as the owner account */,
	EntourageEExFExchangePublicFolder = 'epFL' /* accessed publicly */,
	EntourageEExFExchangeDelegated = 'eDFL' /* accessed as a delegate */,
	EntourageEExFExchangeUserSFolder = 'eSFL' /* accessed through the "open other user's folder" */,
	EntourageEExFDirectoryService = 'elFL' /* accessed as a directory service address list */
};
typedef enum EntourageEExF EntourageEExF;

enum EntourageEPAT {
	EntourageEPATHome = 'eHme' /* Home */,
	EntourageEPATWork = 'eWrk' /* Work */,
	EntourageEPATOther = 'eOth' /* Other */
};
typedef enum EntourageEPAT EntourageEPAT;

enum EntourageSrKi {
	EntourageSrKiMailItems = 'eITM' /* mail */,
	EntourageSrKiContactItems = 'eITC' /* contacts */,
	EntourageSrKiEventItems = 'eITE' /* events */,
	EntourageSrKiNoteItems = 'eITN' /* notes */,
	EntourageSrKiTaskItems = 'eITT' /* tasks */,
	EntourageSrKiAllItems = 'eITA' /* all */
};
typedef enum EntourageSrKi EntourageSrKi;

enum EntourageSrSt {
	EntourageSrStSearching = 'eSSS' /* searching */,
	EntourageSrStDone = 'eSSD' /* done */
};
typedef enum EntourageSrSt EntourageSrSt;



/*
 * Terminology Suite
 */

// An Exchange account
@interface EntourageExchangeAccount : SBObject

@property (copy) NSString *freeBusyServer;  // the Exchange free/busy server
@property (copy) NSString *ExchangeServer;  // the address of the Exchange server
@property BOOL DAVRequiresSSL;  // true if an SSL connection is needed for DAV access
@property NSInteger DAVPort;  // the port to use when connecting to the Exchange server via DAV
@property (copy) NSString *LDAPServer;  // the address of the LDAP server
@property BOOL requiresAuthentication;  // true if the LDAP server requires a user name and password
@property BOOL LDAPRequiresSSL;  // true if an SSL connection is needed for the LDAP server
@property NSInteger LDAPPort;  // the port to use when connecting to the LDAP server

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (NSArray *) doOWAGALSearchUsingAccountSearchString:(NSString *)searchString;  // Global Address List search using Outlook Web Access interface 
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end

// An application program
@interface EntourageApplication : SBApplication

@property (copy, readonly) SBObject *inBoxFolder;  // to the inbox
@property (copy, readonly) SBObject *outBoxFolder;  // to the outbox
@property (copy, readonly) SBObject *sentMailFolder;  // to the sent mail folder
@property (copy, readonly) SBObject *deletedMailFolder;  // to the deleted mail folder

- (void) print:(NSArray *)x withProperties:(EntouragePrintSettings *)withProperties printDialog:(BOOL)printDialog;  // Print the specified object(s)
- (void) quitSaving:(EntourageSavo)saving;  // Quit an application program
- (void) connectTo:(NSArray *)x;  // Connect to account (POP, IMAP, or news)
- (void) send:(NSArray *)x sendingLater:(BOOL)sendingLater;  // Send e-mail messages
- (void) download:(NSArray *)x;  // Download an IMAP, Windows Live Hotmail, or News message that's on the server
- (NSArray *) retrieveFreeBusyInfoFor:(NSString *)x from:(NSDate *)from to:(NSDate *)to;  // retrieve free busy info for given email addresses
- (void) saveCalendarAsWebPageTo:(NSURL *)to withTitle:(NSString *)withTitle starting:(NSDate *)starting ending:(NSDate *)ending includingEventDetails:(BOOL)includingEventDetails usingBackgroundGraphics:(NSURL *)usingBackgroundGraphics;  // Save Calendar as a web page
- (id) convert:(id)x from:(NSString *)from to:(NSString *)to;  // Convert between character sets
- (SBObject *) import:(id)x source:(EntourageItyp)source to:(SBObject *)to conflicts:(EntourageCnfl)conflicts;  // Import data into Entourage
- (void) exportArchiveTo:(NSURL *)to only:(SBObject *)only itemTypes:(NSArray *)itemTypes delete:(BOOL)delete_ retain:(BOOL)retain;  // export archive data
- (void) subscribeProjectTo:(NSURL *)to;  // Subscribe to a project
- (NSArray *) find:(NSString *)x;  // Find contacts with an e-mail address
- (NSArray *) lookupJpostalcode:(NSString *)x;  // Lookup a Japanese postal code
- (void) exportContactsTo:(NSURL *)to;  // export contact list
- (void) handleURL:(NSString *)x attaching:(NSArray *)attaching;  // Handle a URL and display it in a window
- (SBObject *) searchWithQueryString:(NSString *)withQueryString withScope:(SBObject *)withScope withItemType:(EntourageSrKi)withItemType withSavedSearch:(NSString *)withSavedSearch;  // perform a search

@end



/*
 * Standard Suite
 */

@interface EntouragePrintSettings : SBObject

@property (readonly) NSInteger copies;  // the number of copies of a document to be printed 
@property (readonly) BOOL collating;  // Should printed copies be collated?
@property (readonly) NSInteger startingPage;  // the first page of the document to be printed
@property (readonly) NSInteger endingPage;  // the last page of the document to be printed
@property (readonly) NSInteger pagesAcross;  // number of logical pages laid across a physical page
@property (readonly) NSInteger pagesDown;  // number of logical pages laid out down a physical page
@property (copy, readonly) NSDate *requestedPrintTime;  // the time at which the desktop printer should print the document...
@property (readonly) EntourageEnum errorHandling;  // how errors are handled
@property (copy, readonly) NSString *faxNumber;  // for fax number
@property (copy, readonly) NSString *targetPrinter;  // for target printer

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end

// An application program
@interface EntourageApplication (StandardSuite)

- (SBElementArray *) windows;
- (SBElementArray *) POPAccounts;
- (SBElementArray *) IMAPAccounts;
- (SBElementArray *) HotmailAccounts;
- (SBElementArray *) ExchangeAccounts;
- (SBElementArray *) LDAPServers;
- (SBElementArray *) addressBooks;
- (SBElementArray *) folders;
- (SBElementArray *) addresses;
- (SBElementArray *) contacts;
- (SBElementArray *) groups;
- (SBElementArray *) newsServers;
- (SBElementArray *) newsGroups;
- (SBElementArray *) calendars;
- (SBElementArray *) events;
- (SBElementArray *) schedules;
- (SBElementArray *) signatures;
- (SBElementArray *) mailingLists;
- (SBElementArray *) categories;
- (SBElementArray *) projects;
- (SBElementArray *) customViews;
- (SBElementArray *) multitypeCustomViews;
- (SBElementArray *) mailCustomViews;
- (SBElementArray *) contactsCustomViews;
- (SBElementArray *) calendarCustomViews;
- (SBElementArray *) tasksCustomViews;
- (SBElementArray *) notesCustomViews;
- (SBElementArray *) tasks;
- (SBElementArray *) notes;

@property (readonly) BOOL frontmost;  // Is this the frontmost application?
@property (copy, readonly) NSString *name;  // The name of the application.
@property (copy) id selection;  // The selection visible to the user.
@property (copy, readonly) NSString *version;  // The version of the application.
@property (copy, readonly) SBObject *mainWindow;  // to the main window.  open main window will open the main window.
@property (copy, readonly) SBObject *progressWindow;  // to the progress window.  open progress window will open the progress window.
@property (readonly) BOOL connectionInProgress;  // Are there any network connections in progress?
@property BOOL workingOffline;  // Is Entourage working offline (not connected to the internet)?
@property (copy) SBObject *defaultMailAccount;  // to the default mail account
@property (copy) SBObject *defaultNewsServer;  // to the default news server
@property (copy) SBObject *defaultLDAPServer;  // to the default LDAP server
@property (copy) SBObject *meContact;  // to the contact that represents the user
@property (copy, readonly) SBObject *inboxFolder;  // to the inbox
@property (copy, readonly) SBObject *outboxFolder;  // to the outbox
@property (copy, readonly) SBObject *sentItemsFolder;  // to the sent items folder
@property (copy, readonly) SBObject *deletedItemsFolder;  // to the deleted items folder
@property (copy, readonly) SBObject *draftsFolder;  // to the drafts folder
@property (copy, readonly) NSArray *currentMessages;  // the current messaged depending on context, including message currently being filtered
@property (copy) SBObject *currentIdentity;  // the current identity.  Set to change identities.
@property (copy, readonly) NSURL *pathToMUD;  // alias to the Microsoft User Data folder
@property (readonly) NSInteger localizedLanguage;  // the Windows language ID for the locale that Entourage is using.

@end

// A window
@interface EntourageWindow : SBObject

@property NSRect bounds;  // the boundary rectangle for the window
@property (readonly) BOOL closeable;  // does the window have a close box?
@property (readonly) BOOL titled;  // does the window have a title bar?
@property NSInteger index;  // the index of the window (frontmost is 1, etc.)
@property (readonly) BOOL floating;  // does the window float?
@property (readonly) BOOL modal;  // is the window modal?
@property (readonly) BOOL resizable;  // is the window resizable?
@property (readonly) BOOL zoomable;  // is the window zoomable?
@property BOOL zoomed;  // is the window zoomed?
@property (copy, readonly) NSString *name;  // the title of the window
@property (readonly) BOOL visible;  // is the window visible?
@property (readonly) NSPoint position;  // upper left coordinates of window
@property (copy, readonly) SBObject *displayedMessage;  // to the message being displayed, if there is one
@property (copy) SBObject *displayedFeature;  // to the feature (folder, server, etc) being displayed, if there is one
@property (copy) NSString *content;  // body of displayed message, if there is one

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end



/*
 * Entourage Mail and News Suite
 */

// access settings for a particular server
@interface EntourageServerSettings : SBObject

@property (copy) NSString *address;  // the address of the server
@property BOOL requiresSSL;  // true if an SSL connection is needed for server access
@property NSInteger port;  // the port to use when connecting to the server

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end

// An account for accessing mail from a POP server
@interface EntouragePOPAccount : SBObject

@property (copy) NSString *name;  // the name of the account
@property (readonly) NSInteger ID;  // the account's unique ID
@property (copy) NSString *fullName;  // the full name of the user
@property (copy) NSString *emailAddress;  // the e-mail address of the account
@property (copy) NSString *SMTPServer;  // the SMTP server used to send mail with the account
@property (copy) NSString *POPServer;  // the POP server used to retrieve mail
@property (copy) NSString *POPID;  // the account ID on the POP server
@property (copy) NSString *password;  // the password used to access the POP server
@property BOOL allowOnlineAccess;  // true to allow online access to the account (and show it in the folder list)
@property BOOL includeInSendAndReceiveAll;  // true to include this account with Send & Receive All
@property BOOL leaveOnServer;  // true to leave a copy of read mail on the server
@property BOOL sendSecurePassword;  // true to always send the password securely
@property BOOL POPRequiresSSL;  // true if an SSL connection is needed for the POP server
@property NSInteger POPPort;  // the port to use when connecting to the POP server
@property BOOL SMTPRequiresSSL;  // true if an SSL connection is needed for the SMTP server
@property NSInteger SMTPPort;  // the port to use when connecting to the SMTP server
@property BOOL SMTPRequiresAuthentication;  // true if authentication is required for the SMTP server
@property BOOL SMTPUsesAccountSettings;  // true if the SMTP server uses the same account ID and password as the incoming server
@property (copy) NSString *SMTPAccountID;  // the account ID for SMTP server, if SMTP requires authentication is true, and SMTP uses account settings is false
@property (copy) NSString *SMTPPassword;  // the password used to access the SMTP server, if SMTP requires authentication is true, and SMTP uses account settings is false
@property (copy) NSString *additionalHeaders;  // additional headers to add to outgoing messages
@property EntourageESTy defaultSignatureType;  // the default type of signature to be used for new messages
@property (copy) SBObject *defaultSignatureChoice;  // to the signature, if default signature type is other
@property NSInteger maximumMessageSize;  // the maximum size in KB of messages you want to receive
@property NSInteger deleteMessagesFromServerAfter;  // delete messages from the server after number of days
@property BOOL deleteMessagesFromServerWhenDeletedFromComputer;  // delete messages from the server when they are deleted from computer
@property (copy) NSString *lastSMTPAuthenticationMethod;  // the last method of authentication used when sending mail
@property (copy) NSString *lastAuthenticationMethod;  // the last method of authentication used when receiving mail

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end

// An account for accessing mail from an IMAP server
@interface EntourageIMAPAccount : SBObject

- (SBElementArray *) folders;

@property (copy) NSString *name;  // the name of the account
@property (readonly) NSInteger ID;  // the account's unique ID
@property (copy) NSString *fullName;  // the full name of the user
@property (copy) NSString *emailAddress;  // the e-mail address of the account
@property (copy) NSString *SMTPServer;  // the SMTP server used to send mail with the account
@property (copy) NSString *IMAPServer;  // the IMAP server used to retrieve mail
@property (copy) NSString *IMAPID;  // the account ID on the IMAP server
@property (copy) NSString *password;  // the password used to access the IMAP server
@property BOOL includeInSendAndReceiveAll;  // true to include this account with Send & Receive All
@property BOOL sendSecurePassword;  // true to always send the password securely
@property BOOL IMAPRequiresSSL;  // true if an SSL connection is needed for the IMAP server
@property NSInteger IMAPPort;  // the port to use when connecting to the IMAP server
@property BOOL SMTPRequiresSSL;  // true if an SSL connection is needed for the SMTP server
@property NSInteger SMTPPort;  // the port to use when connecting to the SMTP server
@property BOOL SMTPRequiresAuthentication;  // true if authentication is required for the SMTP server
@property BOOL SMTPUsesAccountSettings;  // true if the SMTP server uses the same account ID and password as the incoming server
@property (copy) NSString *SMTPAccountID;  // the account ID for SMTP server, if SMTP requires authentication is true, and SMTP uses account settings is false
@property (copy) NSString *SMTPPassword;  // the password used to access the SMTP server, if SMTP requires authentication is true, and SMTP uses account settings is false
@property (copy) NSString *additionalHeaders;  // additional headers to add to outgoing messages
@property (copy) NSString *rootFolderPath;  // the path to IMAP's root folder
@property EntourageESTy defaultSignatureType;  // the default type of signature to be used for new messages
@property (copy) SBObject *defaultSignatureChoice;  // to the signature, if default signature type is other
@property BOOL sendCommandsToIMAPServerSimultaneously;  // false to work better with some error prone servers
@property BOOL downloadCompleteMessagesInIMAPInbox;  // true to download entire message only in the Inbox
@property BOOL partiallyRetrieveMessages;  // true to download messages less than or equal to maximum size
@property NSInteger partiallyRetrieveMessagesSize;  // value of maximum size for Imap message downloads
@property BOOL IMAPLiveSync;  // true to enable Live Sync
@property BOOL IMAPLiveSyncOnlyConnectToInbox;  // true to always Live Sync only to Inbox
@property BOOL IMAPLiveSyncConnectOnLaunch;  // true to have Live Sync immediately connect on Launch
@property BOOL enableIMAPLiveSyncTimeout;  // true to have Live Sync quit after a period of inactivity
@property NSInteger IMAPLiveSyncTimeout;  // number of minutes for Live Sync to stay connected before timing out
@property BOOL checkForUnreadMessagesInSubscribedIMAPFolders;  // true to check number of unread messages in subscribed folders
@property (copy, readonly) SBObject *IMAPInboxFolder;  // path to INBOX folder
@property BOOL storeMessagesInIMAPSentItemsFolder;  // true to move sent messages to Sent Items folder
@property (copy) SBObject *IMAPSentItemsFolder;  // folder to store sent messages in
@property BOOL storeMessagesInIMAPDraftsFolder;  // true to store unsent messages in Drafts folder
@property (copy) SBObject *IMAPDraftsFolder;  // folder to store unsent messages in
@property BOOL moveMessagesToTheIMAPDeletedItemsFolder;  // true to moved deleted messages to Deleted Items folder
@property (copy) SBObject *IMAPDeletedItemsFolder;  // folder to move deleted messages to
@property BOOL emptyIMAPDeletedItemsFolderOnQuit;  // true to delete messages from deleted items folder when quitting
@property BOOL deleteExpiredIMAPMessagesOnQuit;  // true to delete messages older than x days when quitting
@property NSInteger deleteExpiredIMAPMessagesOnQuitAfter;  // number of days after which to delete messages on quit if delete on quit pref is set
@property BOOL deleteAllExpiredIMAPMessagesOnQuit;  // true to delete all messages from deleted items folder when quitting
@property (copy) NSString *lastSMTPAuthenticationMethod;  // the last method of authentication used when sending mail
@property (copy) NSString *lastAuthenticationMethod;  // the last method of authentication used when receiving mail

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end

// A news server
@interface EntourageNewsServer : SBObject

- (SBElementArray *) newsGroups;

@property (copy) NSString *name;  // the name of the server
@property (readonly) NSInteger ID;  // the server's unique ID
@property (copy) NSString *NNTPServer;  // the address of the NNTP server
@property (copy) NSString *organization;  // the user's organization
@property BOOL requiresAuthentication;  // true if the server requires a user name and password
@property (copy) NSString *userName;  // the user name used to access the NNTP server, if required
@property (copy) NSString *password;  // the password used to access the NNTP server, if required
@property BOOL NNTPRequiresSSL;  // true if an SSL connection is needed for the NNTP server
@property NSInteger NNTPPort;  // the port to use when connecting to the NNTP server
@property (copy) NSString *additionalHeaders;  // additional headers to add to outgoing messages
@property (copy) SBObject *sendingAccount;  // the mail account to use for sending
@property EntourageESTy defaultSignatureType;  // the default type of signature to be used for new messages
@property (copy) SBObject *defaultSignatureChoice;  // to the signature, if default signature type is other
@property NSInteger numberHeadersToGet;  // the number of headers to download at a time
@property (copy) NSString *lastSMTPAuthenticationMethod;  // the last method of authentication used when sending mail
@property (copy) NSString *lastAuthenticationMethod;  // the last method of authentication used when receiving mail

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end

// An LDAP server
@interface EntourageLDAPServer : SBObject

@property (copy) NSString *name;  // the name of the server
@property (readonly) NSInteger ID;  // the server's unique ID
@property (copy) NSString *LDAPServer;  // the address of the LDAP server
@property BOOL requiresAuthentication;  // true if the server requires a user name and password
@property BOOL requiresKerberos;  // true if Kerberos is required for server access (includes account's LDAP access to GAL)
@property (copy) NSString *principal;  // GSSAPI principal name (Kerberos v5) used to acces the LDAP server, if required
@property (copy) NSString *userName;  // the user name used to access the LDAP server, if required
@property (copy) NSString *password;  // the password used to access the LDAP server, if required
@property BOOL LDAPRequiresSSL;  // true if an SSL connection is needed for the LDAP server
@property NSInteger LDAPPort;  // the port to use when connecting to the LDAP server
@property NSInteger maximumEntries;  // the maximum number of entries to return
@property NSInteger searchDuration;  // the number of seconds to wait before timing out
@property (copy) NSString *searchBase;  // the search base
@property BOOL useSimpleSearch;  // true if the server should use simplified search string
@property (readonly) BOOL VLVSupport;  // true if the server supports the virtual list view (VLV) control
@property (readonly) BOOL ANRSupport;  // true if the server supports ambiguous name resolution (ANR) search criteria. Searches against the "anr" meta-attribute check against a set of attributes configured by the server administrators.
@property (readonly) BOOL ExchangeSupport;  // true if the server has Microsoft Exchange configuration information.
@property (copy, readonly) EntourageLDAPAddressList *GAL;  // top level LDAP address book representing the LDAP search or the Exchange global address list (GAL).

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (NSString *) doLDAPSearchUsingAccountName:(NSString *)name emailAddress:(NSString *)emailAddress;  // LDAP search using the specific account for a given name or email address
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end

// An Exchange account
@interface EntourageExchangeAccount (EntourageMailAndNewsSuite)

- (SBElementArray *) folders;
- (SBElementArray *) addressBooks;
- (SBElementArray *) calendars;
- (SBElementArray *) delegatedAccounts;
- (SBElementArray *) otherUserAccounts;

@property (copy) NSString *name;  // the name of the server
@property (readonly) NSInteger ID;  // the server's unique ID
@property BOOL requiresKerberos;  // true if Kerberos is required for server access (includes account's LDAP access to GAL)
@property (copy) NSString *principal;  // GSSAPI principal name (Kerberos v5)
@property (copy) NSString *ExchangeID;  // Exchange ID
@property (copy) NSString *password;  // the Exchange password
@property (copy) NSString *domain;  // the Exchange domain
@property (copy) NSString *fullName;  // the full name of the user
@property (copy) NSString *emailAddress;  // the e-mail address of the account
@property BOOL partiallyRetrieveMessages;  // true to only partially download large messages
@property NSInteger partiallyRetrieveMessagesSize;  // the maximum size for message downloads (in kilobytes)
@property BOOL partiallyRetrieveMessagesOnDialupOnly;  // if true, only download partial messages when on dialup connections
@property EntourageESTy defaultSignatureType;  // the default type of signature to be used for new messages
@property (copy) SBObject *defaultSignatureChoice;  // the signature, if default signature type is other
@property (copy) NSString *additionalHeaders;  // additional headers to add to outgoing messages
@property (copy) EntourageServerSettings *ExchangeServerSettings;  // the Exchange server's settings for DAV access
@property (copy, readonly) SBObject *inboxFolder;  // the Inbox folder
@property (copy, readonly) SBObject *sentItemsFolder;  // the Sent Items folder
@property (copy, readonly) SBObject *deletedItemsFolder;  // the Deleted Items folder
@property (copy, readonly) SBObject *draftsFolder;  // the Drafts folder
@property (copy, readonly) SBObject *junkMailFolder;  // the Junk Mail folder
@property (copy, readonly) SBObject *primaryCalendar;  // the Exchange mailbox's calendar
@property (copy, readonly) SBObject *primaryAddressBook;  // the Exchange mailbox's address book
@property (readonly) long long totalSize;  // the account's storage size on the Exchange server
@property (copy, readonly) NSArray *ExchangeSubfolders;  // the account's subfolders and their storage and total storage amounts
@property (copy) EntourageServerSettings *LDAPServerSettings;  // the LDAP server's settings
@property BOOL LDAPRequiresAuthentication;  // true if the LDAP server requires a user name and password
@property (copy) NSString *searchBase;  // the search base for LDAP queries
@property NSInteger maximumEntries;  // the maximum number of entries to return from LDAP queries
@property (copy) EntourageServerSettings *publicFolderServerSettings;  // the Public Folder server's settings
@property (copy, readonly) SBObject *favoritesFolder;  // the Favorites folder
@property (copy, readonly) EntourageFolder *GAL;  // top level folder representing either the Exchange global address list or LDAP search.
@property BOOL outOfOffice;  // true if out of office auto reply is enabled
@property (copy) NSString *outOfOfficeAutoReply;  // the out of office auto reply message

@end

// An delegated account
@interface EntourageDelegatedAccount : SBObject

- (SBElementArray *) folders;
- (SBElementArray *) addressBooks;
- (SBElementArray *) calendars;

@property (copy) NSString *name;  // the name of the server
@property (readonly) NSInteger ID;  // the server's unique ID
@property (copy, readonly) SBObject *account;  // the Exchange account containing the delegation credentials
@property (copy) EntourageServerSettings *ExchangeServerSettings;  // the Exchange server's settings
@property (copy) NSString *emailAddress;  // the email address of the delegator
@property (copy, readonly) SBObject *inboxFolder;  // the inbox folder of the delated account
@property (copy, readonly) SBObject *junkMailFolder;  // the junk mail folder of the delated account
@property (copy, readonly) SBObject *draftsFolder;  // the drafts folder of the delated account
@property (copy, readonly) SBObject *sentItemsFolder;  // the sent items folder of the delated account
@property (copy, readonly) SBObject *deletedItemsFolder;  // the deleted items folder of the delated account
@property (copy, readonly) SBObject *primaryCalendar;  // the primary calendar of the delegated account
@property (copy, readonly) SBObject *primaryAddressBook;  // the primary address book of the delegated account
@property (readonly) long long size;  // the size, in bytes, of the account's root level folder not including subfolders
@property (readonly) long long totalSize;  // the size, in bytes, of the account's root level folder including subfolders

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end

// An Exchange other user's folder account
@interface EntourageOtherUserAccount : SBObject

- (SBElementArray *) folders;
- (SBElementArray *) addressBooks;
- (SBElementArray *) calendars;

@property (copy) NSString *name;  // the name of the server
@property (readonly) NSInteger ID;  // the server's unique ID
@property (copy, readonly) SBObject *account;  // the Exchange account containing the access credentials
@property (copy, readonly) EntourageServerSettings *ExchangeServerSettings;  // the Exchange server's settings
@property (copy, readonly) NSString *emailAddress;  // the email address of the other user
@property BOOL inboxOpen;  // true if the other user's inbox is open
@property BOOL calendarOpen;  // true if the other user's calendar is open
@property BOOL addressBookOpen;  // true if the other user's address book is open
@property (copy, readonly) SBObject *inboxFolder;  // the inbox folder of the delated account
@property (copy, readonly) SBObject *primaryCalendar;  // the primary calendar of the delated account
@property (copy, readonly) SBObject *primaryAddressBook;  // the primary address book of the delated account

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end

// An account for accessing mail from Hotmail.com
@interface EntourageHotmailAccount : SBObject

- (SBElementArray *) folders;

@property (copy) NSString *name;  // the name of the account
@property (readonly) NSInteger ID;  // the account's unique ID
@property (copy) NSString *fullName;  // the full name of the user
@property (copy) NSString *emailAddress;  // the e-mail address of the account
@property (copy) NSString *HotmailID;  // the Windows Live Hotmail account ID
@property (copy) NSString *password;  // the password used to access the Windows Live Hotmail account
@property BOOL includeInSendAndReceiveAll;  // true to include this account with Send & Receive All
@property BOOL saveInServerSentItems;  // true to save sent items on the server instead of lacally
@property (copy) NSString *additionalHeaders;  // additional headers to add to outgoing messages
@property EntourageESTy defaultSignatureType;  // the default type of signature to be used for new messages
@property (copy) SBObject *defaultSignatureChoice;  // to the signature, if default signature type is other

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end

// A folder for storing e-mail
@interface EntourageFolder : SBObject

- (SBElementArray *) folders;
- (SBElementArray *) addressBooks;
- (SBElementArray *) calendars;
- (SBElementArray *) messages;
- (SBElementArray *) incomingMessages;
- (SBElementArray *) outgoingMessages;

@property (copy) NSString *name;  // the name of the folder
@property (readonly) NSInteger ID;  // the folder's unique ID
@property (copy, readonly) SBObject *parent;  // to the folder that contains the folder, or the application if it's a top level folder
@property (readonly) NSInteger unreadMessageCount;  // the number of unread messages in the folder
@property (copy) NSArray *category;  // the list of categories
@property BOOL subscribed;  // folder's subscribed status on some servers
@property (copy, readonly) SBObject *account;  // account associated with the folder
@property (readonly) EntourageEExF kind;  // type of folder
@property (copy, readonly) NSString *URL;  // URL of the folder on a server
@property (copy, readonly) NSString *ELCPolicyComment;  // the email life-cycle policy description
@property (readonly) BOOL organizationalFolder;  // is the folder an Exchange organizational folder?
@property (readonly) BOOL mustDisplayELCPolicy;  // must the email life-cycle policy description be displayed?
@property (readonly) NSInteger ELCQuota;  // the email life-cycle folder quota in KB
@property (readonly) long long ELCSize;  // the email life-cycle folder size
@property (readonly) long long size;  // folder's storage size on the Exchange server (not including subfolders)
@property (readonly) long long totalSize;  // folder's storage size on the Exchange server (including subfolders)
@property (copy, readonly) NSArray *ExchangeSubfolders;  // folder's subfolders and their storage and total storage amounts

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end

// A news group
@interface EntourageNewsGroup : SBObject

- (SBElementArray *) messages;
- (SBElementArray *) incomingMessages;

@property (copy, readonly) NSString *name;  // the name of the news group
@property (readonly) NSInteger ID;  // the group's unique ID
@property (copy, readonly) SBObject *newsServer;  // to the server that the group belongs to
@property (readonly) NSInteger unreadMessageCount;  // the number of unread messages in the group
@property BOOL subscribed;  // newsgroup's subscribed status

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end

// An e-mail message
@interface EntourageMessage : SBObject

- (SBElementArray *) attachments;
- (SBElementArray *) recipients;
- (SBElementArray *) parts;

@property (readonly) NSInteger ID;  // the message's unique ID
@property (copy) NSString *subject;  // subject of the message
@property (copy) NSString *content;  // content of message
@property (copy) NSDate *timeReceived;  // time at which the message was received
@property (copy) NSDate *timeSent;  // time at which the message was sent
@property (copy) SBObject *storage;  // to the folder that contains the message
@property (copy) EntourageAddress *sender;  // sender of the message
@property EntourageEpty priority;  // the priority of the message
@property (readonly) BOOL ExchangePost;  // Is the message an Exchange post message?
@property (copy) SBObject *account;  // account associated with the message
@property (copy, readonly) NSString *headers;  // the message headers
@property (copy, readonly) NSString *source;  // the raw source text of the message
@property (copy) NSString *characterSet;  // the character set used by the message
@property (copy) NSColor *color;  // the color of the message when displayed in lists
@property (readonly) BOOL hasHtml;  // does the message have html text?
@property (readonly) EntourageESvS onlineStatus;  // the online status of the message
@property EntourageECnA connectionAction;  // what will be done with the message at the next connection?
@property EntourageErds readStatus;  // has the message been read?
@property BOOL repliedTo;  // has the message been replied to?
@property BOOL forwarded;  // has the message been forwarded?
@property BOOL redirected;  // has the message been redirected?
@property BOOL flagged;  // has the message been flagged for followup? (Deprecated. Use flag state. Completed is not flagged.)
@property EntourageFlag flagState;  // has the message been flagged or completed?
@property (readonly) BOOL edited;  // has the message been edited?
@property (copy, readonly) NSDate *modificationDate;  // when the message was last modified
@property (copy) NSArray *category;  // the list of categories
@property (copy) NSArray *projectList;  // the list of projects
@property (copy) NSArray *projectSharingList;  // the list of projects that will share this item
@property (copy, readonly) NSArray *links;  // the list of linked items
@property (copy) NSDictionary *properties;  // property that allows setting a list of properties
@property BOOL hasStartDate;  // whether or not the To Do has a start date
@property (copy) NSDate *startDate;  // the date and time a To Do is scheduled to begin.  Setting this will set the flag state of the item to flag
@property (copy, readonly) NSDate *completedDate;  // the date and time a To Do was completed
@property BOOL hasReminder;  // whether or not the To Do has a reminder
@property BOOL hasDueDate;  // whether or not the To Do has a due date
@property (copy) NSDate *dueDate;  // the date a To Do is due.  Setting this will set the flag state of the item to flag
@property (copy) NSDate *remindDateAndTime;  // the date and time to remind of a due date.  Setting this will set the flag state of the item to flag
@property BOOL SMIMESigned;  // whether or not the message is signed with SMIME
@property BOOL SMIMEEncrypted;  // whether or not the message is encrypted with SMIME

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (NSArray *) burstTo:(SBObject *)to;  // Burst a digest message into constituent messages
- (SBObject *) forwardTo:(NSString *)to openingWindow:(BOOL)openingWindow htmlText:(BOOL)htmlText;  // Forward a message
- (SBObject *) redirectTo:(NSString *)to openingWindow:(BOOL)openingWindow;  // Redirect a message
- (SBObject *) replyToOpeningWindow:(BOOL)openingWindow attributionStyle:(EntourageAtrE)attributionStyle replyToAll:(BOOL)replyToAll placeInsertionPointOnTop:(BOOL)placeInsertionPointOnTop htmlText:(BOOL)htmlText quoteEntireMessage:(BOOL)quoteEntireMessage;  // Reply to a message
- (SBObject *) resendOpeningWindow:(BOOL)openingWindow;  // Resend a message
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end

// An incoming e-mail message
@interface EntourageIncomingMessage : EntourageMessage

- (SBElementArray *) attachments;
- (SBElementArray *) recipients;

@property (readonly) EntourageSmSE SMIMESignature;  // does the signature match the content?
@property (readonly) EntourageSmSE SMIMESigner;  // is the signer of the message valid? (for details, see SMIME signer info)
@property (copy, readonly) EntourageSMIMESignerInfo *SMIMESignerInfo;  // information about the signer of the message (if SMIME signature is not none)


@end

// An outgoing e-mail message
@interface EntourageOutgoingMessage : EntourageMessage

- (SBElementArray *) attachments;
- (SBElementArray *) recipients;

@property EntourageEdlv deliveryStatus;  // Has the message been sent?
@property BOOL resent;  // Has the message been resent?
@property EntourageEAEn encoding;  // the encoding of the attachments
@property EntourageECmp compressionType;  // the compression setting for attachments
@property BOOL sendAttachmentsToCcRecipients;  // Should the attachments be sent to CC and BCC recipients?
@property BOOL useWindowsFileNames;  // Should attachments be sent with Windows file name extensions?


@end

// Information about the signer of an SMIME signed message
@interface EntourageSMIMESignerInfo : SBObject

@property (readonly) BOOL trusted;  // is the signer's certificate trusted?
@property (readonly) BOOL expired;  // has the signer's certificate expired?
@property (readonly) BOOL emailMatches;  // does the signer's email address match the sender of the message?
@property (copy, readonly) NSString *address;  // the signer's email address
@property (readonly) EntourageSmRv revocationStatus;  // has the signer's certificate been revoked?

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end

// A window with an unsent message
@interface EntourageDraftWindow : EntourageWindow

- (SBElementArray *) attachments;
- (SBElementArray *) recipients;

@property (copy) NSString *subject;  // Subject of the message
@property (copy) NSString *content;  // Content of message
@property (copy) SBObject *account;  // Account associated with the message
@property EntourageEpty priority;  // The priority of the message
@property (copy) NSString *toRecipients;  // The “to” recipients of the message as text
@property (copy) NSString *CCRecipients;  // The “CC” recipients of the message as text
@property (copy) NSString *BCCRecipients;  // The “BCC” recipients of the message as text
@property EntourageESTy signatureType;  // Type of signature to be used for the message
@property (copy) SBObject *otherSignatureChoice;  // to the signature, if signature type is other
@property EntourageEAEn encoding;  // the encoding of the attachments
@property EntourageECmp compressionType;  // the compression setting for attachments
@property BOOL sendAttachmentsToCcRecipients;  // Should the attachments be sent to CC and BCC recipients?
@property BOOL useWindowsFileNames;  // Should attachments be sent with Windows file names?


@end

// A window with an unsent message
@interface EntourageDraftNewsWindow : EntourageWindow

- (SBElementArray *) attachments;

@property (copy) NSString *subject;  // Subject of the message
@property (copy) NSString *content;  // Content of message
@property (copy) SBObject *account;  // Account associated with the message
@property EntourageEpty priority;  // The priority of the message
@property (copy) NSString *newsGroupRecipients;  // The newsgroups the message will be posted to
@property (copy) NSString *CCRecipients;  // The “CC” recipients of the message as text
@property EntourageESTy signatureType;  // Type of signature to be used for the message
@property (copy) SBObject *otherSignatureChoice;  // to the signature, if signature type is other
@property EntourageEAEn encoding;  // the encoding of the attachments
@property EntourageECmp compressionType;  // the compression setting for attachments
@property BOOL sendAttachmentsToCcRecipients;  // Should the attachments be sent to CC and BCC recipients?
@property BOOL useWindowsFileNames;  // Should attachments be sent with Windows file names?


@end

// A window displaying a message that has been sent or received
@interface EntourageMessageWindow : EntourageWindow


@end

// A browser window
@interface EntourageBrowserWindow : EntourageWindow

@property EntourageArEn displayedArea;  // the functional area displayed in the window


@end

// An e-mail message address
@interface EntourageAddress : SBObject

@property (copy) NSString *displayName;  // the name used for display
@property (copy) NSString *address;  // the e-mail address

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end

// Message recipient
@interface EntourageRecipient : SBObject

@property (copy) EntourageAddress *address;  // the recipient's address
@property EntourageErty recipientType;  // the type of recipient

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end

// An attachment to a message
@interface EntourageAttachment : SBObject

@property (copy, readonly) NSString *name;  // the name of the attachment
@property (copy, readonly) NSNumber *fileType;  // the type of file
@property (copy, readonly) NSNumber *fileCreator;  // the creator of file
@property (readonly) EntourageEEnc encoding;  // the MIME encoding of the data
@property (copy, readonly) NSURL *file;  // alias to the associated file (if there is one)
@property (copy, readonly) NSString *content;  // the encoded content (if it has been encoded)
@property (copy) NSDictionary *properties;  // property that allows setting a list of properties

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end

// A message part
@interface EntouragePart : SBObject

- (SBElementArray *) parts;

@property (copy, readonly) NSString *type;  // the MIME type of the data
@property (copy, readonly) NSString *subtype;  // the MIME subtype of the data
@property (readonly) EntourageEEnc encoding;  // the MIME encoding of the data
@property (copy, readonly) NSString *characterSet;  // the character set of the data
@property (copy, readonly) NSString *headers;  // The part headers
@property (copy, readonly) NSString *content;  // the contents of the part
@property (copy) NSDictionary *properties;  // property that allows setting a list of properties

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end

// A calendar
@interface EntourageCalendar : SBObject

- (SBElementArray *) folders;
- (SBElementArray *) addressBooks;
- (SBElementArray *) calendars;
- (SBElementArray *) events;

@property (copy) NSString *name;  // the name of the calendar
@property (readonly) NSInteger ID;  // the calendar's unique ID

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end

// A calendar on an Exchange server
@interface EntourageExchangeCalendar : EntourageCalendar

@property (copy) NSArray *category;  // the list of categories
@property (copy, readonly) SBObject *account;  // account to which the calendar belongs
@property (readonly) EntourageEExF kind;  // type of calendar
@property (copy, readonly) NSString *URL;  // the path of the calendar on a server


@end

// A calendar event
@interface EntourageEvent : SBObject

@property (readonly) NSInteger ID;  // the event's unique ID
@property (copy, readonly) NSString *GUID;  // the item's global unique identifier
@property (copy, readonly) NSString *iCalData;  // iCal data representing the item (can be used as property at creation time)
@property (copy) NSString *subject;  // subject of the event
@property (copy) NSString *location;  // location of the event
@property (copy) NSString *content;  // description of the event
@property (copy) NSDate *startTime;  // time at which the event starts
@property (copy) NSDate *endTime;  // time at which the event ends
@property BOOL allDayEvent;  // is the event an all day event?
@property (readonly) BOOL recurring;  // is the event recurring?
@property (copy) NSString *recurrence;  // the iCal recurrence rule
@property (copy, readonly) NSDate *modificationDate;  // when the event was last modified
@property (copy) NSArray *category;  // the list of categories
@property (copy) NSArray *projectList;  // the list of projects
@property (copy) NSArray *projectSharingList;  // the list of projects that will share this item
@property (copy, readonly) NSArray *links;  // the list of linked items
@property (copy) NSDictionary *properties;  // property that allows setting a list of properties
@property NSInteger remindTime;  // time in minutes from the start time
@property BOOL hasReminder;  // whether or not the event has a reminder
@property (copy) NSString *toRecipients;  // The “to” recipients of the invitation
@property (copy) SBObject *account;  // account associated with the invitation
@property NSInteger timeZone;  // time zone id of the event
@property EntourageEFBt freeBusyStatus;  // the free busy status for the event
@property (copy, readonly) SBObject *calendar;  // the calendar to which the event belongs

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (NSArray *) calculateRecurringDatesForFrom:(NSDate *)from to:(NSDate *)to;  // calculate recurring dates for a recurring event
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end

// A schedule
@interface EntourageSchedule : SBObject

@property (copy) NSString *name;  // the name of the schedule
@property (readonly) NSInteger ID;  // the schedule's unique ID
@property BOOL enabled;  // is the schedule enabled?

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end

// A signature
@interface EntourageSignature : SBObject

@property (copy) NSString *name;  // the name of the signature
@property (readonly) NSInteger ID;  // the signature's unique ID
@property (copy) NSString *content;  // the text of the signature
@property BOOL includeInRandom;  // is the signature included in the random list?

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end

// A mailing list
@interface EntourageMailingList : SBObject

@property (copy) NSString *name;  // the name of the mailing list
@property (readonly) NSInteger ID;  // the mailing list's unique ID
@property BOOL enabled;  // is the mailing list enabled?
@property (copy) SBObject *storage;  // the folder to which mailing list message will be filed
@property BOOL fileOutgoing;  // if true, file outgoing messages that I send to the list in the folder specified
@property (copy) NSString *listAddress;  // the list address of the mailing list
@property (copy) NSString *notes;  // notes about the mailing list
@property (copy) NSString *alternateAddress;  // the alternate address of the mailing list
@property (copy) NSString *administrativeAddress;  // the address of the administrator of the mailing list
@property (copy) NSString *serverAddress;  // the address of the list server of the mailing list
@property BOOL markAsRead;  // if true, mark messages in this mailing list as read
@property BOOL changeCategory;  // if true, change the category of this message
@property (copy) SBObject *category;  // the category of mailing list messages
@property (copy) NSArray *projectList;  // the list of projects
@property (copy) NSArray *projectSharingList;  // the list of projects that will share this item
@property BOOL addPrefix;  // if true, add prefix to mailing list messages
@property (copy) NSString *prefix;  // the list address of the mailing list
@property BOOL deleteMyMail;  // if true, delete copies of incoming messages that I sent to the list
@property BOOL burstMessage;  // if true, burst digests into individual messages
@property BOOL deleteOriginal;  // if true, delete original after bursting
@property BOOL applyRules;  // if true, apply rules to messages from the mailing list
@property BOOL override;  // if true, override the default reply behavior (if override, default is always send to list address)
@property BOOL alwaysSendToListAddress;  // used only if override is true:   if this is true, always send to list address   if this is false, always send to the sender

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end

// A task
@interface EntourageTask : SBObject

@property (copy) NSString *name;  // the name of the task
@property (readonly) NSInteger ID;  // the task's unique ID
@property (copy, readonly) NSString *GUID;  // the item's global unique identifier
@property (copy, readonly) NSString *iCalData;  // iCal data representing the item (can be used as property at creation time)
@property BOOL completed;  // is the task marked as completed?
@property (copy) NSString *content;  // the content (note) of the task
@property (readonly) BOOL recurring;  // is the task marked as recurring?
@property BOOL hasDueDate;  // whether or not the To Do has a due date
@property (copy) NSDate *dueDate;  // the date the task is due
@property (copy) NSDate *remindDateAndTime;  // the date and time to remind of a due date
@property BOOL hasReminder;  // whether or not the event has a reminder
@property EntourageEpty priority;  // the priority of the task
@property (copy, readonly) NSDate *modificationDate;  // when the task was last modified
@property (copy) NSArray *category;  // the list of categories
@property BOOL hasStartDate;  // whether or not the task has a start date
@property (copy) NSDate *startDate;  // the date and time a task is scheduled to begin
@property (copy, readonly) NSDate *completedDate;  // the date and time a task was completed
@property (copy) NSArray *projectList;  // the list of projects
@property (copy) NSArray *projectSharingList;  // the list of projects that will share this item
@property (copy, readonly) NSArray *links;  // the list of linked items

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end

// A note
@interface EntourageNote : SBObject

@property (copy) NSString *name;  // the name of the note
@property (readonly) NSInteger ID;  // the note's unique ID
@property (copy, readonly) NSString *GUID;  // the item's global unique identifier
@property (copy, readonly) NSString *iCalData;  // iCal data representing the item (can be used as property at creation time)
@property (copy) NSString *content;  // the text of the note
@property (copy, readonly) NSDate *modificationDate;  // when the note was last modified
@property (copy) NSArray *category;  // the list of categories
@property (copy) NSArray *projectList;  // the list of projects
@property (copy) NSArray *projectSharingList;  // the list of projects that will share this item
@property (copy, readonly) NSArray *links;  // the list of linked items
@property (copy, readonly) NSDate *creationDate;  // the date the note was created

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end

// An Entourage Identity
@interface EntourageIdentity : SBObject

@property (copy, readonly) NSString *name;  // the name of the identity

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end

// A category
@interface EntourageCategory : SBObject

@property (copy) NSString *name;  // the name of the category
@property (readonly) NSInteger ID;  // the category's unique ID
@property (copy) NSColor *color;  // the color of the category

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end

// A project
@interface EntourageProject : SBObject

@property (copy) NSString *name;  // the name of the project
@property (readonly) NSInteger ID;  // the project's unique ID
@property (copy, readonly) NSString *GUID;  // the item's global unique identifier
@property (copy) NSColor *color;  // the color associated with the project
@property BOOL hasDueDate;  // Does the project have a due date?
@property BOOL completed;  // Has the project been completed?
@property (copy) NSDate *dueDate;  // the date the project is due
@property (copy) NSString *objectDescription;  // the description of the project
@property (copy) NSDate *syncDate;  // the last date the project was synched

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (void) shareLocation:(NSURL *)location currentItems:(BOOL)currentItems addedItems:(BOOL)addedItems;  // Share a project
- (void) unshare;  // Stop  sharing a project
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end

// A custom view
@interface EntourageCustomView : SBObject

@property (copy) NSString *name;  // the name of the custom view
@property (readonly) NSInteger ID;  // the custom view's unique ID
@property (readonly) NSInteger recordCount;  // the number of returned records

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end

// A multitype custom view
@interface EntourageMultitypeCustomView : EntourageCustomView


@end

// A mail custom view
@interface EntourageMailCustomView : EntourageCustomView


@end

// A contacts custom view
@interface EntourageContactsCustomView : EntourageCustomView


@end

// A calendar custom view
@interface EntourageCalendarCustomView : EntourageCustomView


@end

// A tasks custom view
@interface EntourageTasksCustomView : EntourageCustomView


@end

// A notes custom view
@interface EntourageNotesCustomView : EntourageCustomView


@end



/*
 * Entourage Contact Suite
 */

// An address book. This is used by the displayed feature property of windows, or to open the address book window (open address book 1).
@interface EntourageAddressBook : SBObject

- (SBElementArray *) folders;
- (SBElementArray *) addressBooks;
- (SBElementArray *) calendars;

@property (copy) NSString *name;  // the name of the address book
@property (readonly) NSInteger ID;  // the address book's unique ID
@property (copy) NSString *customPhoneNumberOneName;  // the name of the first custom phone number
@property (copy) NSString *customPhoneNumberTwoName;  // the name of the second custom phone number
@property (copy) NSString *customPhoneNumberThreeName;  // the name of the third custom phone number
@property (copy) NSString *customPhoneNumberFourName;  // the name of the fourth custom phone number
@property (copy) NSString *customFieldOneName;  // the name of the first custom field
@property (copy) NSString *customFieldTwoName;  // the name of the second custom field
@property (copy) NSString *customFieldThreeName;  // the name of the third custom field
@property (copy) NSString *customFieldFourName;  // the name of the fourth custom field
@property (copy) NSString *customFieldFiveName;  // the name of the fifth custom field
@property (copy) NSString *customFieldSixName;  // the name of the sixth custom field
@property (copy) NSString *customFieldSevenName;  // the name of the seventh custom field
@property (copy) NSString *customFieldEightName;  // the name of the eighth custom field
@property (copy) NSString *customDateFieldOneName;  // the name of the first custom date field
@property (copy) NSString *customDateFieldTwoName;  // the name of the second custom date field

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end

// an address book on an Exchange server
@interface EntourageExchangeAddressBook : EntourageAddressBook

@property (copy) NSArray *category;  // the list of categories
@property (copy, readonly) SBObject *account;  // the account to which the address book belongs
@property (readonly) EntourageEExF kind;  // type of address book
@property (copy, readonly) NSString *URL;  // the path of the address book on a server


@end

// an address list on an LDAP server
@interface EntourageLDAPAddressList : EntourageAddressBook

@property (copy, readonly) NSString *distinguishedName;  // the distinguished name (DN) of the address list


@end

// A contact in the address book
@interface EntourageContact : EntourageAddress

- (SBElementArray *) emailAddresses;
- (SBElementArray *) instantMessageAddresses;

@property (readonly) NSInteger ID;  // the contact's unique ID
@property (copy, readonly) NSString *GUID;  // the item's global unique identifier
@property (copy) NSArray *category;  // the list of categories
@property (copy) NSArray *projectList;  // the list of projects
@property (copy) NSArray *projectSharingList;  // the list of projects that will share this item
@property (copy, readonly) NSArray *links;  // the list of linked items
@property (copy, readonly) NSString *vcardData;  // information about the contact in vCard format.  Can be used to create a contact from vCard data.
@property (copy) NSString *firstName;  // the contact's first (given) name
@property (copy) NSString *firstNameFurigana;  // the furigana for the contact's first name (Japanese format contacts only)
@property (copy) NSString *lastName;  // the contact's last (sur) name
@property (copy) NSString *lastNameFurigana;  // the furigana for the contact's last name (Japanese format contacts only)
@property (copy) NSString *title;  // the contact's title
@property (copy) NSString *phone;  // the contact's default phone number
@property (copy) NSString *office;  // the contact's office
@property (copy) NSString *domainAlias;  // the contact's alias (unique identifier within domain)
@property (copy) NSString *suffix;  // the contact's name suffix
@property (copy) NSString *nickname;  // the contact's nickname
@property (copy) NSString *company;  // the contact's company
@property (copy) NSString *companyFurigana;  // the furigana for the contact's company name (Japanese format contacts only)
@property (copy) NSString *jobTitle;  // the contact's job title
@property (copy) NSString *department;  // the contact's department
@property (copy) SBObject *defaultEmailAddress;  // reference to the contact's default email address
@property (copy) SBObject *defaultInstantMessageAddress;  // reference to the contact's default instant message address
@property (copy) NSString *objectDescription;  // a text note for the contact
@property EntourageEPAT defaultPostalAddress;  // which postal address is the default
@property (copy) EntouragePostalAddress *homeAddress;  // the contact's home postal address
@property (copy) EntouragePostalAddress *businessAddress;  // the contact's business postal address
@property (copy) NSString *homeWebPage;  // the contact's home web page
@property (copy) NSString *businessWebPage;  // the contact's business web page
@property (copy) NSString *homePhoneNumber;  // the contact's home phone number
@property (copy) NSString *otherHomePhoneNumber;  // the contact's other home phone number
@property (copy) NSString *homeFaxPhoneNumber;  // the contact's home fax phone number
@property (copy) NSString *businessPhoneNumber;  // the contact's business phone number
@property (copy) NSString *otherBusinessPhoneNumber;  // the contact's other business phone number
@property (copy) NSString *businessFaxPhoneNumber;  // the contact's business fax phone number
@property (copy) NSString *pagerPhoneNumber;  // the contact's pager phone number
@property (copy) NSString *mobilePhoneNumber;  // the contact's mobile phone number
@property (copy) NSString *mainPhoneNumber;  // the contact's main phone number
@property (copy) NSString *assistantPhoneNumber;  // the contact's assistant's phone number
@property (copy) NSString *customPhoneNumberOne;  // the contact's first custom phone number
@property (copy) NSString *customPhoneNumberTwo;  // the contact's second custom phone number
@property (copy) NSString *customPhoneNumberThree;  // the contact's third custom phone number
@property (copy) NSString *customPhoneNumberFour;  // the contact's fourth custom phone number
@property (copy) NSString *customFieldOne;  // the contact's first custom field
@property (copy) NSString *customFieldTwo;  // the contact's second custom field
@property (copy) NSString *customFieldThree;  // the contact's third custom field
@property (copy) NSString *customFieldFour;  // the contact's fourth custom field
@property (copy) NSString *customFieldFive;  // the contact's fifth custom field
@property (copy) NSString *customFieldSix;  // the contact's sixth custom field
@property (copy) NSString *customFieldSeven;  // the contact's seventh custom field
@property (copy) NSString *customFieldEight;  // the contact's eighth custom field
@property (copy) NSString *age;  // the contact's age
@property (copy) NSString *astrologySign;  // the contact's astrology sign
@property (copy) NSString *spouse;  // the contact's spouse
@property (copy) NSString *spouseFurigana;  // the furigana for the contact's spouse's name (Japanese format contacts only)
@property (copy) NSString *interests;  // the contact's interests
@property (copy) NSString *bloodType;  // the contact's blood type (Japanese format contacts only)
@property (copy) NSArray *children;  // the contact's children as a list
@property (copy) NSString *customDateFieldOne;  // the contact's first custom date field
@property (copy) NSString *customDateFieldTwo;  // the contact's second custom date field
@property (copy) NSString *birthday;  // the contact's birthday
@property (copy) NSString *anniversary;  // the contact's anniversary
@property BOOL flagged;  // has the contact been flagged? (Deprecated. Use flag state. Completed is not flagged.)
@property EntourageFlag flagState;  // has the contact been flagged or completed?
@property BOOL JapaneseFormat;  // does the contact use the Japanese format?
@property (copy, readonly) NSDate *modificationDate;  // when the contact was last modified
@property (copy, readonly) NSDate *lastSentDate;  // when you last sent mail to this contact
@property (copy, readonly) NSDate *lastReceivedDate;  // when you last received mail from this contact
@property (copy) NSDictionary *properties;  // property that allows setting a list of properties
@property (copy, readonly) SBObject *addressBook;  // the address book containing the contact
@property (copy) NSDate *startDate;  // the date and time a To Do is scheduled to begin.  Setting this will set the flag state of the item to flag
@property BOOL hasStartDate;  // whether or not the To Do has a start date
@property (copy, readonly) NSDate *completedDate;  // the date and time a To Do was completed
@property BOOL hasReminder;  // whether or not the To Do has a reminder
@property BOOL hasDueDate;  // whether or not the To Do has a due date
@property (copy) NSDate *dueDate;  // the date a To Do is due.  Setting this will set the flag state of the item to flag
@property (copy) NSDate *remindDateAndTime;  // the date and time to remind of a due date.   Setting this will set the flag state of the item to flag
@property (copy) EntourageImageSettings *image;  // image information


@end

// A window displaying a contact. You can get the contact with the displayed feature property.
@interface EntourageContactWindow : EntourageWindow


@end

// An e-mail address
@interface EntourageEmailAddress : SBObject

@property (copy) NSString *contents;  // the address
@property EntourageEPAT label;  // which type of email address this is
@property (copy) NSDictionary *properties;  // property that allows getting or setting a list of properties

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end

// An instant message address
@interface EntourageInstantMessageAddress : SBObject

@property (copy) NSString *contents;  // the address
@property EntourageEPAT label;  // which type of IM address this is
@property (copy) NSDictionary *properties;  // property that allows getting or setting a list of properties

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end

// A postal (street) address
@interface EntouragePostalAddress : SBObject

@property (copy) NSString *streetAddress;  // the street address
@property (copy) NSString *city;  // the city
@property (copy) NSString *state;  // the state
@property (copy) NSString *zip;  // the zip code
@property (copy) NSString *country;  // the country/region

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end

// A group
@interface EntourageGroup : SBObject

- (SBElementArray *) groupEntries;

@property (copy) NSString *name;  // the name of the group
@property (copy, readonly) NSString *GUID;  // the item's global unique identifier
@property BOOL showOnlyNameInMessages;  // if true, only the name of the group is shown in sent messages
@property (copy) NSArray *category;  // the list of categories
@property (copy, readonly) SBObject *addressBook;  // the address book containing the group
@property (copy) NSArray *projectList;  // the list of projects
@property (copy) NSArray *projectSharingList;  // the list of projects that will share this item
@property (copy, readonly) NSArray *links;  // the list of linked items
@property (copy) NSDictionary *properties;  // property that allows setting a list of properties

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end

// An entry in a group
@interface EntourageGroupEntry : SBObject

@property (copy, readonly) EntourageAddress *content;  // address of entry

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end

// information about an image
@interface EntourageImageSettings : SBObject

@property (copy) NSNumber *type;  // the data type of the image
@property (copy) id data;  // raw image bytes

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end



/*
 * Entourage Search Suite
 */

// active search
@interface EntourageActiveSearch : SBObject

@property (readonly) EntourageSrSt searchStatus;  // the status of the active search
@property (readonly) NSInteger itemCount;  // the count of the found items
@property (copy, readonly) NSArray *foundItems;  // a list containing all the found items

- (void) closeSaving:(EntourageSavo)saving savingIn:(NSURL *)savingIn;  // Close an object
- (NSInteger) dataSizeAs:(NSNumber *)as;  // Return the size, in bytes, of an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) open;  // Open the specified object(s)
- (void) saveIn:(NSString *)in_ as:(NSNumber *)as;  // Save an object
- (void) refresh;  // Refresh an object
- (void) purge;  // purge a folder
- (void) execute;  // Execute a schedule
- (void) linkTo:(SBObject *)to;  // Link an item to another item
- (void) unlinkFrom:(SBObject *)from;  // Remove a link between two items
- (void) unsubscribe;  // unsubscribe a folder
- (void) remove;  // remove an item from its container
- (void) emptyCache;  // empty local cache of an Exchange folder
- (void) sync;  // sync an Exchange folder
- (void) closeSearch;  // closes the search

@end

