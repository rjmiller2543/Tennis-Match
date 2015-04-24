//
//  NewPlayerView.m
//  Tennis Match
//
//  Created by Robert Miller on 4/5/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import "NewPlayerView.h"
#import "AppDelegate.h"
#import "Stats.h"

@implementation NewPlayerView

-(instancetype)init {
    self = [super init];
    if (self) {
        //retrieve the players
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Player"];
        
        // Set the batch size to a suitable number.
        [fetchRequest setFetchBatchSize:10];
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
        NSArray *sortDescriptors = @[sortDescriptor];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[AppDelegate sharedInstance] managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
        _fetchedResultsController.delegate = self;
        
        NSError *error = nil;
        if (![self.fetchedResultsController performFetch:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        //set up the view
        UICollectionViewFlowLayout *aFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        [aFlowLayout setItemSize:CGSizeMake(200, 140)];
        [aFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:aFlowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
        
        [self addSubview:_collectionView];
    }
    
    return self;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 6.0;
    
    if (indexPath.row == [[_fetchedResultsController fetchedObjects] count]) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"New Player";
        [label sizeToFit];
        label.center = CGPointMake(cell.frame.size.width / 2, cell.frame.size.height / 2);
        cell.backgroundColor = [UIColor greenColor];
        
        [cell addSubview:label];
    }
    
    else if (indexPath.row == ([[_fetchedResultsController fetchedObjects] count] +1)) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"Cancel";
        [label sizeToFit];
        label.center = CGPointMake(cell.frame.size.width / 2, cell.frame.size.height / 2);
        
        [cell addSubview:label];
    }
    
    else {
        NSManagedObject *object = [_fetchedResultsController objectAtIndexPath:indexPath];
        Player *player = (Player*)object;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 90, 90)];
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.layer.cornerRadius = 45;
        imageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        imageView.layer.borderWidth = 2.0;
        if ([player playerImage]) {
            imageView.image = [UIImage imageWithData:[player playerImage]];
        }
        else {
            imageView.image = [UIImage imageNamed:@"no-player-image.png"];
        }
        [cell addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 100, 15)];
        label.text = [player playerName];
        label.textAlignment = NSTextAlignmentRight;
        cell.backgroundColor = [UIColor asbestosColor];
        
        [cell addSubview:label];
    }
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[_fetchedResultsController fetchedObjects] count] + 2;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(60, 60, 60, 60);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeZero;
    
    if (indexPath.row == [[_fetchedResultsController fetchedObjects] count]) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"New Player";
        [label sizeToFit];
        size = label.frame.size;
        size.height = size.height + 10;
        size.width = size.width + 10;
    }
    
    else if (indexPath.row == ([[_fetchedResultsController fetchedObjects] count] +1)) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"Cancel";
        [label sizeToFit];
        size = label.frame.size;
        size.height = size.height + 10;
        size.width = size.width + 10;
    }
    
    else {
        /*
        NSManagedObject *object = [_fetchedResultsController objectAtIndexPath:indexPath];
        Player *player = (Player*)object;
        
        UILabel *label = [[UILabel alloc] init];
        label.text = [player playerName];
        [label sizeToFit];
        
        size = label.frame.size;
        size.height = size.height + 10;
        size.width = size.width + 10;
         */
        size = CGSizeMake(120, 120);
    }
    
    return size;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [[_fetchedResultsController fetchedObjects] count]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add New Player" message:@"Add a temporary player with just a name.. The player can be edited later.." preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Player's First Name";
            textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        }];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            //Do Nothing...
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Player" inManagedObjectContext:[[AppDelegate sharedInstance] managedObjectContext]];
            Player *player = (Player*)newManagedObject;
            
            UITextField *textField = [[alert textFields] objectAtIndex:0];
            
            [player setTimeStamp:[NSDate date]];
            [player setPlayerName:textField.text];
            [player setPlayerStats:[[Stats alloc] init]];
            [player setOpponents:[[NSArray alloc] init]];
            
            NSError *contextError = nil;
            if (![[[AppDelegate sharedInstance] managedObjectContext] save:&contextError]) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog(@"Unresolved error %@, %@", contextError, [contextError userInfo]);
                abort();
            }
            [self.delegate pickedPlayer:player];
        }]];
        
        [_parentViewController presentViewController:alert animated:YES completion:^{
            //up up
        }];
    }
    
    else if (indexPath.row == ([[_fetchedResultsController fetchedObjects] count] + 1)) {
        [self.delegate pickedPlayer:nil];
    }
    
    else {
        Player *player = [[_fetchedResultsController fetchedObjects] objectAtIndex:indexPath.row];
        [self.delegate pickedPlayer:player];
    }
    
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Player" inManagedObjectContext:[[AppDelegate sharedInstance] managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[AppDelegate sharedInstance] managedObjectContext] sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    //[self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.collectionView reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
