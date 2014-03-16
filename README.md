hangouts-profile-switcher
=========================

A profile switcher and settings panel inspired by the one from the latest release of Google Hangouts for iOS.

The core functionality is the animated panels when tapping the profile image at the top. There are two panels or containers: a hidden panel, and a top panel that covers the hidden panel when closed. The hidden panel (profileContainerView) is where you want to put content to be shown when the user taps on the navigation bar image. On the top panel (contentView), you can add any content as a normal full-screen view.

Content on the top panel can be set programmatically, but also from a nib file without having to do any extra steps (just add views normally to the controller view on the nib). If the controller is linked with a nib file (including storyboards), the top panel will take ownership of the controls of the nib view adding them as subviews. The only drawback is that if the nib file uses Auto Layout, some views will not be displayed correctly.

The class that manages this core functionality is EVProfileViewerViewController. In order to make use of it, it's sufficient to inherit from this class. It was done this way in order to maintain the inners of the code out of the way of the user and provide simplicity. Even so, the class provides many methods to customize it, and blocks for adding custom animations. 

Built on top of this funcionality, is the profile switcher and settings panel modeled after Google Hangouts new account switcher.
