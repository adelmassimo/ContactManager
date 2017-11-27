# ContactManager
### A simple project for course of Human Computer Interaction
The aims of this project are to model the behavior of a classic contacts manager (CM), using th MVC paradigm.
This CM implements below properties:
- [x] Visualization of all contacts
- [x] Allow to order contacts by each fiel displayed
- [x] Single contact visualization
- [x] Insertion of a new one
- [x] Contact persistence
- [x] Contact tagging and tag search
- [x] Contact editing
- [x] Full text search
- [ ] Asynchronus updating of contacts list

The language used is Swift 4, so it's required Xcode (≥9.x) to compile and run the application. The MVC is implicitly imposed by language: it's possible to draw the view in the .sroryboard file and then link it to a NSViewController class, that can manage all properties of view.

![Xcode Design bulder](https://raw.githubusercontent.com/adelmassimo/ContactManager/master/redameImg/storyboard.png)

### Step1: Improve Persistence
The first step was create Contact and ContactsBook classes and improve persistence of a single contacts, this using the UsersDefault strategy, clearly explained in [this tutorial](https://developer.apple.com/documentation/foundation/userdefaults). Shortly, a file is created in the users folder, for me (/Users/ME/Library/Containers/my-name.ContactManager/Data/Documents/contacts). This strategy obviusly isn't able to easly manage asynchronus changes: that's why i've not implemented this features.

### Step2: Design and link View
The principal purpose was to define alle the elements needed to represent the contacts (i.e. a TableView and some Buttons). Once defined, these elements are linked to the class ViewController to add behavior.
Some refiniments, like windows transparency was reached following [this tutorial](https://developer.apple.com/documentation/appkit/nsvisualeffectview)

### Little things and known bugs:
* ContactsBook have a state, defined by a seatchFilter, tagFilter and the contacts array: the persistence interests only the contacts array (i.e. on reopen the eventuals filters are losed!)
* The sorting is implemented using a lambda function that defines the rules for compare two elements.
* Lots of warnig raised from the layout constrains used in storyboard: i'm not a good designer!
* On the right is shown the selected contact, and it's editable: a good treatment for this area could be lock before select a row, otherwise allow to edit a "smoke" field.
* Tag visualization on the right is not well implemented. Only show the descriptor of tags array in the Contact class, too boring to refine.
* Isn't possible add a tag by the interface, but it's easly to do by back end.

![First launch](https://raw.githubusercontent.com/adelmassimo/ContactManager/master/redameImg/start.png)