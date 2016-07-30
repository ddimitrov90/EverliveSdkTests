# Progress Backend Servies (Everlive) iOS Swift SDK 

This SDK is built to work with the [Progress Backend Services](https://platform.telerik.com) in order to create native iOS application by using the Swift language.

This SDK is built to work with the Telerik Backend Services in order to create native iOS application by using the Swift language.


## Features

The features that are covered in the first version:

- Setup your own data model
- Work with data items
- Work with users
- Work with files

There is a [sample application](https://github.com/ddimitrov90/EverliveSampleApp) that demonstrates all features in a real case scenario here.

## Requirements

The SDK itself does not have any specific requirements, so all the required versions come from the used libraries in it.

- iOS 9.0+ / Mac OS X 10.9+ / tvOS 9.0+ / watchOS 2.0+
- Xcode 7.3+

## Installation
Just add the following to your Podfile.

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'EverliveSDK', '~> 1.0'
end
```

## Issues
Please bear in mind that I have worked on this in my spare time and there might be some bugs. If you find any, please submit them as issue in the git repo. I'll try to respond as soon as possible. Also if you have problems or need more information on how to achieve something, you can write in the [sample app](https://github.com/ddimitrov90/EverliveSampleApp) repo or on my email.

## License

EverliveSDK is released under the MIT license. See LICENSE for details.

Any MR/suggestions are more than welcome.


## Basic usage
All you have to do is import the **EverliveSwift** library and setup your application object. It takes as argument your application identifier. For easier usage, you can create a singleton instance of the SDK that can be used throughout your application. 

    import EverliveSDK
	public class EverliveSwiftApp {
    	static let sharedInstance = EverliveApp(appId: "app-id-here")
    	private init() {}
	}

## Data Model
Before you actually start working with the data stored in your cloud, you’ll have to create Swift Class for each Content Type that you have and want to work with. This way the SDK will automatically populate the properties of that object with the values stored in Everlive. There is a base DataItem, which holds the fundamental properties for each item:

- Id - of type String - the Id of the object
- CreatedAt - NSDate - when the item was created
- ModifiedAt - NSDate - when the item was modified for last time
- CreatedBy - String - the id of the owner of that item
- ModifiedBy - String - the id of the last user that has modified the item
 
The next step is to extend the DataItem, by creating your own class named after the content type you have. For each column stored in Backend Services, you’ll create a property of your class with the appropriate data type. Here is an example:

    import EverliveSDK

	public class Activity : DataItem {
	    var Text: String? {
	        didSet {
	            super.propertyChanged.raise("Text")
	        }
	    }
	    
	    override public func getTypeName() -> String {
	        return "Activities"
	    }
	}

Usually the name of your content type will be in plural form, while the Swift class will be singular, so you’ll have to override the **getTypeName** function and return the name of your content type as seen on the server.

The **didSet** function is needed in order to track the changed properties, when you have data objects that you want to update.

Each DataItem object support custom properties. If you have a custom class and some properties are not mapped as such, you can still get their value. You have to specift the return type and a default value, if the property was not set or missing.

	let nonMappedValue:Int = item.getValue("NonMappedProp", defaultValue: 0)

## CRUD operations
For the examples below, i'll use the following swift class that represents a Book.

    
	public class Book: DataItem {   
	    public var Likes: Int = 0 {
	        didSet {
	            super.propertyChanged.raise("Likes")
	        }
	    }
	    public var PublishedAt: NSDate? {
	        didSet {
	            super.propertyChanged.raise("PublishedAt")
	        }
	    }
	    
	    public var Title: String? {
	        didSet {
	            super.propertyChanged.raise("Title")
	        }
	    }
	}

	let everliveApp = EverliveApp("app-id-here")

### Read items

#### read by Id
	
    everliveApp.Data().getById("item-id").execute { (result: Book?, error: EverliveError?) -> Void in
        // result as a Book class
		// error if the item was not found for this Id
    }

#### ready all

    everliveApp.Data().getAll().execute { (result: [Book]?, error: EverliveError?) -> Void in
        // result as an array of Books
		// empty array if there are no items
    }

#### read by filter

	let query = EverliveQuery()
    query.filter("Likes", greaterThan: 20.0, orEqual: true)
    
    everliveApp.Data().getByFilter(query).execute { (result: [Book]?, error: EverliveError?) -> Void in
        // result as an array of Books
		// empty array if no items found
    }

More examples for filtering in the Filter section

#### get items count

	let dataHandler: DataHandler<Book> = everliveApp.Data()
    dataHandler.getCount().execute { (result:Int?, err:EverliveError?) -> Void in
        // there might be an error getting the count, so the result is Optional
    }

### Create items

### create single item

	let book = Book()
    book.Title = "Crime and Punishment"
    book.Likes = 30
    book.PublishedAt = NSDate.init()
	everliveApp.Data().create(book).execute { (success:Bool, error: EverliveError?) -> Void in
        // success - if the item was created, otherwise there will an error object
    }

### create multiple items

	let book1 = Book()
    book1.Title = "Frankenstein"
    book1.Likes = 40
    book1.PublishedAt = NSDate.init()
    
    let book2 = Book()
    book2.Title = "Game of Thrones"
    book2.Likes = 50
    book2.PublishedAt = NSDate.init()

	everliveApp.Data().create([book1, book2]).execute { ( result: [Book], error: EverliveError?) -> Void in
        // result array will contain the items with populated server properties - Id, CreatedAt etc..
    }

### Update items

Items can be updated in two ways - by using the default propertyChange notifier or by specifying an update object.

#### update by setting item's property value
Every subclass of DataItem should be set as the example Book class above. By raising the propertyChanged event, the property will be updated on executing an update query and passing the whole object. 

	everliveApp.Data().getById("item-id").execute { (result: Book?, error: EverliveError?) -> Void in
        result!.Title = "New Title"
        result!.Likes = 100
        let updateHandler: DataHandler<Book> = everliveApp.Data()
        updateHandler.updateById("item-id", updateObject: result!).execute { (result:UpdateResult, error:EverliveError?) -> Void in
            // update result will contain the ModifiedAt date and the number of updated items
        }
    }

It can also be used in the following way

	let book = Book()
    book.Likes = 17
    
    let updateHandler: DataHandler<Book> = everliveApp.Data()
    updateHandler.updateById("itme-id", updateObject: book).execute { (result:UpdateResult, error:EverliveError?) -> Void in
        // only the Likes property will be updated
    }

A filter can be applied on update

	let book = Book()
    book.Title = "Changed Title"
    
    let query = EverliveQuery()
    query.filter("Likes", greaterThan: 25, orEqual: false)
    
    let updateHandler: DataHandler<Book> = everliveApp.Data()
    updateHandler.updateByFilter(query, updateObject: book).execute { (result:UpdateResult, error:EverliveError?) -> Void in
        // the update result will contain the number of updated items 
    }

#### update by using update object

For more specific updates, you can use **UpdateObject**. The definition of single object contains the name of the field to be updated, the modifier that should be applied to that field and the new value.

	let updateObject = UpdateObject(updateFields: [])
    updateObject.UpdatedFields.append(UpdateField(fieldName: "Likes", modifier: UpdateModifier.Increment, value: 5))
    
    let updateHandler: DataHandler<Book> = everliveApp.Data()
    updateHandler.updateById("item-id", updateObject: updateObject).execute { (result:UpdateResult, error:EverliveError?) -> Void in
        // update result count should be one
    }
	
Also can be applied with filter

	let updateObject = UpdateObject(updateFields: [])
    updateObject.UpdatedFields.append(UpdateField(fieldName: "Likes", modifier: UpdateModifier.Increment, value: 2))
    
    let query = EverliveQuery()
    query.filter("Likes", greaterThan: 25, orEqual: false)
    
    let updateHandler: DataHandler<Book> = everliveApp.Data()
    updateHandler.updateByFilter(query, updateObject: updateObject).execute { (result:UpdateResult, error:EverliveError?) -> Void in
        // update result will contain the number of updated items 
    }

Currently supported modifiers are: $set/$unset/$inc.

### Delete items

Deleting items can be achieved by specifing an Id or deleting all items. The delete by filter is too dangerous and is not supported at the moment ( just by passing an incorrect filter, you can lose all your data)

#### delete by id

	let deleteHandler: DataHandler<Book> = everliveApp.Data()
    deleteHandler.deleteById("item-id").execute { (deletedItems: Int?, error: EverliveError?) -> Void in
        // if there was no error, deletedItems will be equal to 1
    }

#### delete all

	let deleteHandler: DataHandler<Book> = everliveApp.Data()
    deleteHandler.deleteAll().execute { (deletedItems: Int?, error: EverliveError?) -> Void in
        // deleted items count will returned
    }

## Expand

Expand of items is supported for all read operations by using the ExpandDefinition class. Be careful with the number of expanded items, because there is currently a limitation of maximum 50 returned items. In order to use the expand, you should have two properties in your class - the field that is defined in your content type as relation and new property that will hold the expand result. Here is an example with the User's definition in the [sample app](https://github.com/ddimitrov90/EverliveSampleApp).

	class SampleUser: User {
		var Picture: String?
    	var ProfilePicture: File?
	}

The **Picture** property is defined as a String and will hold the Id of the user's profile picture. The ProfilePicture property is of type **File** because the relation is to the Files content type.

### Single
	let picExpand = ExpandDefinition(relationField: "Picture", returnAs: "ProfilePicture")
    picExpand.TargetTypeName = "System.Files"
    everliveApp.Users().getById("user-id").expand(picExpand).execute { (result: SampleUser?, err:EverliveError?) in
        if let profilePic = result?.ProfilePicture?.Uri {
			// set profile picture
        }
    }

### Multiple & Nested
You have the ability to expand on more than field and also have nested expand. The example is from the sample backend services data - each activity has author, which is a User and this user has profile picture which is a File. Here is the result expand definition:

	let pictureExpand = ExpandDefinition(relationField: "Picture", returnAs: "ActivityPic")
    pictureExpand.TargetTypeName = "System.Files"
    let userExpand = ExpandDefinition(relationField: "UserId", returnAs: "UserProfile")
    userExpand.TargetTypeName = "Users"
    let profilePicExpand = ExpandDefinition(relationField: "Picture", returnAs: "ProfilePicture")
    profilePicExpand.TargetTypeName = "System.Files"
    userExpand.ChildExpand = profilePicExpand
    
    let multipleExpand = MultipleExpandDefinition(expandDefinitions: [pictureExpand, userExpand])
    EverliveSwiftApp.sharedInstance.Data().getAll().expand(multipleExpand).execute { (activities:[Activity]?, err: EverliveError?) in         
        // each activity from the array will have its Picture expanded and will contain a User author with expanded profile picture.
    }

## Filter/Sort/Skip/Take

### Filter

The filter object is specified by using the **EverliveQuery** class. All basic query operators are supported are seprate functions of the query class. Here are some examples.

	let query = EverliveQuery()
    query.filter("Title", equalTo: "Lolita")
	query.filter("Likes", equalTo: 20)
	query.filter("Likes", notEqualTo: 20)
	query.filter("Likes", greaterThan: 20, orEqual: false)
	query.filter("Likes", lessThan: 20, orEqual: true)
	query.filter("Title", startsWith: "lol", caseSensitive: true)
	query.filter("Title", contains: "lol", caseSensitive: true)	

All of the above basic filters can be chained to form a complex query. All you have to do is specify as last function call, the operator that should be used between the different filters - **and / or**.

	let query = EverliveQuery()
    query.filter("Likes", lessThan: 30, orEqual: false).filter("Likes", greaterThan: 10, orEqual: false).and()
	query.filter("Title", notEqualTo: "Game of Thrones").filter("Likes", lessThan: 30, orEqual: true).or()
	
By using the basic **EverliveQuery** class, you can create most of the basic filters. Then comes the **EverliveCompoundQuery** that is basically a set of basic filters combined together.

	let query = EverliveQuery()
    query.filter("Likes", lessThan: 40, orEqual: false).filter("Likes", greaterThan: 20, orEqual: false).and()
    let query2 = EverliveQuery()
    query2.filter("Title", startsWith: "lol", caseSensitive: false)
    let compoundQuery = EverliveCompoundQuery()
    compoundQuery.and([query2, query])

	let query = EverliveQuery()
    query.filter("Likes", lessThan: 40, orEqual: false).filter("Likes", greaterThan: 20, orEqual: false).and()
    let query2 = EverliveQuery()
    query2.filter("Title", contains: "lol", caseSensitive: true)
    let compoundQuery = EverliveCompoundQuery()
    compoundQuery.or([query2, query])

Both types of queries can be used in order to filter items for update or read.

### Sort

Sorting expressions are defined by using the **Sorting** class.

	let sortDef = Sorting(fieldName: "Likes", orderDirection: OrderDirection.Descending)
	everliveApp.Data().getAll().sort(sortDef).execute { (result: [Book]?, error: EverliveError?) -> Void in
       	// the result array will be ordered by the Likes
    }

### Skip/Take

For paging you can use the Skip and Take options. The functions are directly applied to the read operation. Usually the skip/take options are used with sorting.

	let sortDef = Sorting(fieldName: "Likes", orderDirection: OrderDirection.Ascending)	
	everliveApp.Data().getAll().skip(2).take(1).sort(sortDef).execute { (result: [Book]?, error: EverliveError?) -> Void in
        // the resulted array will contain only one element
    }


Here is an example of combined filter with sort, skip and take

	let query = EverliveQuery()
    query.filter("Likes", greaterThan: 20.0, orEqual: true)
    let sortDef = Sorting(fieldName: "Likes", orderDirection: OrderDirection.Ascending)
    
    everliveApp.Data().getByFilter(query).skip(1).take(2).sort(sortDef).execute { (result: [Book]?, error: EverliveError?) -> Void in
        // the result array should contain two items
    }


## Users

The SDK comes with a predefined User class that represents the users in the backend. The class is simply based on the DataItem class with a few properties added. So all CRUD operations are valid in the same way, but only by using the **User()** handler of the **EverliveApp** instance.

### Register user
The registration of new user is just creating a new object.

	let newUser = User()
    newUser.Username = "username"
    newUser.Password = "password"
    newUser.Email = "valid@email.address"
    newUser.DisplayName = "display name"
    everliveApp.Users().create(newUser).execute { (success:Bool, err:EverliveError?) in
        // success is true if everything was ok
    }

### Login

The login/logout operations are provided by the **Authentication** handler. To login a user, you have to pass the username/email and the password. The result is the access token, that you won't have to use. The **SDK** saves the current logged user in the **NSUserDefaults** for the current application, so you won't have to login the user on every opening of the application. Also the token is saved in the **EverliveApp** instance, so all requests will pass the token as Authorization header.

	everliveApp.Authentication().login("username", password: "password").execute { (_:AccessToken?, err:EverliveError?) -> Void in
        // error if the credentials were invalid
    }

### Logout
When you call logout, the current user is removed from the **NSUserDefaults** and the access token is removed from the current instance of the **EverliveApp**.

	everliveApp.Authentication().logout().execute { (success:Bool, err:EverliveError?) in
        
    }

### Get Me
If you want to check for currently logged user, use the **getMe() ** function.

	everliveApp.Users().getMe().execute({ (currentUser: User?, err: EverliveError?) -> Void in
        if err == nil {
            // there is a user currently logged in
        }
    })

### Custom user fields
You have the option to add custom properties to your User's definition. Respectively you can create a subclass of the User class.

	@objc(SampleUser)
	class SampleUser: User {
	    var Picture: String?
	    var ProfilePicture: File?
	}

The @objc is very important in order to successfully have all properties set

## Files

There is predefined class for working with Files that corresponds to the Files Content Type. The added properties are **Filename**, **Uri**, **ContentType** and **Data**. Most often files are used as a relation to another content type and by using expand definition, you can get the file metadata - Filename, Uri and ContentType. The file data is download explicitly by using the **download** function of the **FilesHandler**.

### Download

	everliveApp.Files().download("file-id").execute { (fileResult:File?, err: EverliveError?) in
        // all properties are setm including the Data
    }

My advice is not to use this function as it is simply performs a GET request that always downloads the file content, without caching and it may be slow. You better use libraries like [Kingfisher](https://github.com/onevcat/Kingfisher) or  [AlamofireImage](https://github.com/Alamofire/AlamofireImage) that will download the file for you just by providing the file **Uri**. This is demonstrated in the [sample application](https://github.com/ddimitrov90/EverliveSampleApp).

### Upload

Full demo of the upload functionality by using ImagePicker can be seen in the [sample application](https://github.com/ddimitrov90/EverliveSampleApp). But once you have the data of your file, here is the code.

	let newFile = File()
    newFile.Filename = "newfile.jpeg"
    newFile.ContentType = "image/jpeg"
    newFile.Data = some-data-here
    EverliveSwiftApp.sharedInstance.Files().upload(newFile).execute { (success: Bool, err: EverliveError?) in
        // newFile properties are populated, including the Id, which is needed for relations
    }	

## Cloud functions

Currently there is no specific handler for cloud functions, but you can manually make any requests by using the **connection** properrty of the **EverliveApp**.

	let likeRequest = EverliveRequest(httpMethod: "GET", url: "Functions/likeActivity?activityId=\(activity-id)")
    everliveApp.connection.executeRequest(likeRequest, completionHandler: { (response:Response<AnyObject, NSError>) in
        switch response.result {
        case .Success( _):
			// succesffully called the cloud function
			// the cloud function response object is currently custom
        case .Failure(let error):
            print("Request failed with error: \(error)")
        }
    })

The EverliveRequest object has functions if you need to make a POST request with a body or pass custom headers.

## Error handling

All function calls may return an error represented by the EverliveError object. It has two properties:

- message - that is the error message returned from the server
- errorCode - the custom error code returned by the server. This code is specific for each error and can be checked in the official documentation of Everlive.

If the error object in your callback is not nil, this means that the operation was not successfull and you want receive the expected result.

## Tests

There are already a number of tests, but the project with the tests will soon be added to this pod.

## Used Libraries

- Alamofire - https://github.com/Alamofire/Alamofire
- SwiftyJSON - https://github.com/SwiftyJSON/SwiftyJSON
- EVReflection - https://github.com/evermeer/EVReflection
