# ContactManager
### A simple project for course of Human Computer Interaction
The aims of this project are to model the behavior of a classic contacts manager (CM), using th MVC paradigm.
This CM implements below properties:
- [x] Visualization of all contacts
- [x] Single contact visualization
- [x] Insertion of a new one
- [x] Contact persistence
- [x] Contact tagging and tag search
- [x] Contact editing
- [x] Full text search
- [ ] Asynchronus updating of contacts list

The language used is Swift 4, so it's required Xcode (≥9.x) to compile and run the application. The MVC is implicitly imposed by language: it's possible to draw the view in the .sroryboard file and then link it to a NSViewController class, that can manage all properties of view.

![Xcode Design bulder](https://raw.githubusercontent.com/adelmassimo/ContactManager/master/redameImg/storyboard.png)

### Step1: improve Persistence
The first step was create Contact and ContactsBook classes and improve persistence of a single contacts, this using the UsersDefault strategy, clearly explained in [link this Apple tutorial](https://developer.apple.com/documentation/foundation/userdefaults)

![First launch](https://raw.githubusercontent.com/adelmassimo/ContactManager/master/redameImg/start.png)