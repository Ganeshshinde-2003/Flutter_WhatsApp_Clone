# WhatsApp Clone 👥📱
This is a WhatsApp Clone project developed using Flutter and Firebase. It aims to replicate some of the core features of the popular messaging application WhatsApp, allowing users to send messages, create groups, and share media files.

## Features 🚀
- User Registration and Login 📲💡: Users can create an account using their phone number and receive an OTP (One-Time Password) for verification.

- Real-time Messaging 💬⚡️: Users can send and receive messages in real-time, with instant updates and synchronization across devices.

- Chatting 💬📷🎥: Users can send and receive text messages, images, videos, and GIFs in both one-on-one and group chats.

- Group chats 👥💬: Users can create groups, add members, and have group conversations.

- Message replies 💬↩️: Users can reply to specific messages in a conversation, providing context and facilitating threaded discussions.

- Emoji and GIF support 😀🎞️: Users can add emojis and GIFs to their messages using a built-in picker.

- Media sharing 📷🎥: Users can select images and videos from their device's gallery and share them in conversations.

- Real-time updates ⚡️: Messages and chat lists are updated in real-time, providing a seamless messaging experience.

- User contacts 👤📞: Users can view and interact with their saved contacts, initiating chats with individual contacts or groups.

## Screenshots 📸
Here are some screenshots of the WhatsApp Clone app:

<div style="display:flex; flex-wrap: wrap; gap: 30px;">

<img src="https://github.com/Ganeshshinde-2003/Flutter_WhatsApp_Clone/assets/115361691/0e9e44ab-63b4-4276-94d0-97401835f9b3" alt="IMG-20230618-WA0007" height="400">

<img src="https://github.com/Ganeshshinde-2003/Flutter_WhatsApp_Clone/assets/115361691/65c1d93b-b652-448a-ab38-6f3e41316dd3" alt="IMG-20230618-WA0014" height="400">

<img src="https://github.com/Ganeshshinde-2003/Flutter_WhatsApp_Clone/assets/115361691/f8134c0e-9e54-4dbe-8851-2f12abf23e1b" alt="IMG-20230618-WA0015" height="400">

<img src="https://github.com/Ganeshshinde-2003/Flutter_WhatsApp_Clone/assets/115361691/2c093b5b-dd0a-46af-aebd-ee70df1dc83c" alt="IMG-20230618-WA0009" height="400">

<img src="https://github.com/Ganeshshinde-2003/Flutter_WhatsApp_Clone/assets/115361691/4170d7b6-dae8-42b4-bd87-23c06192affb" alt="IMG-20230618-WA0010" height="400">

<img src="https://github.com/Ganeshshinde-2003/Flutter_WhatsApp_Clone/assets/115361691/64f23b46-6db9-4bed-a0d8-fa7db34b4e90" alt="IMG-20230618-WA0012" height="400">

<img src="https://github.com/Ganeshshinde-2003/Flutter_WhatsApp_Clone/assets/115361691/975a9085-d187-4e98-94c4-96c2872f4763" alt="IMG-20230618-WA0012" height="400">

  
</div>

## Technologies Used 🛠️
### Flutter 📱: Flutter is an open-source UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase. It is used to develop the front-end of the WhatsApp Clone app, providing a cross-platform user interface.

### Firebase 🔥: Firebase is a comprehensive suite of cloud-based development tools provided by Google. In this project, Firebase is used for the following purposes:

- Firebase Authentication 🔒: Handles user registration, login, and authentication. OTP verification is used for phone number login.

- Firebase Realtime Database or Firestore 🗄️: Stores and syncs chat messages, group data, and user information in real-time.

- Firebase Cloud Storage ☁️: Stores media files such as images and videos shared within chats.


## Getting Started 🚀
To get started with the WhatsApp Clone app, follow these steps:

### Clone the repository:

      https://github.com/Ganeshshinde-2003/Flutter_WhatsApp_Clone.git
      
      
### Set up Firebase Project:

- Create a new project in the Firebase console.

- Enable Firebase Authentication and choose the desired authentication methods (e.g., phone number).

- Set up Firebase Realtime Database or Firestore and configure the database rules.

- Set up Firebase Cloud Storage and configure the storage rules.

- Obtain the Firebase configuration details (API keys, database URL, storage bucket) and update them in the app's configuration files.

### Install dependencies:

    flutter pub get
    
### Run the app:

    flutter run
    
    
## Dependencies

The following dependencies were used to build this app:

- ⚡️ **cupertino_icons: ^1.0.2** - Provides the Cupertino icons for iOS-style design.
- 🔥 **firebase_auth: ^4.6.2** - Handles user authentication using Firebase Authentication.
- 🗄️ **firebase_storage: ^11.2.2** - Enables storing and retrieving files in Firebase Cloud Storage.
- 🔥 **firebase_core: ^2.13.1** - Provides the core functionality for Firebase services.
- 🗄️ **cloud_firestore: ^4.8.0** - Allows interaction with the Firebase Cloud Firestore database.
- 🌍 **country_picker: ^2.0.20** - Provides a picker to select countries and their phone codes.
- 🚿 **riverpod: ^2.3.6** - A simple yet powerful state management library.
- 🚿 **flutter_riverpod: ^2.3.6** - Integration of Riverpod with Flutter.
- 🖼️ **image_picker: ^0.8.7+5** - Allows selecting images and videos from the device's gallery.
- 📚 **flutter_contacts: ^1.1.6** - Retrieves and displays user contacts.
- 🆔 **uuid: ^3.0.7** - Generates unique IDs for documents and entities.
- 🌐 **intl: ^0.18.1** - Provides internationalization and localization support.
- 🖼️ **cached_network_image: ^3.2.3** - Caches network images to improve performance.
- 🎥 **cached_video_player: ^2.0.4** - Caches and plays videos from the network.
- 😃 **emoji_picker_flutter: ^1.6.1** - Provides an emoji picker for selecting emojis in the chat.
- 🎞️ **enough_giphy_flutter: ^0.4.0** - Integrates Giphy for adding animated GIFs to messages.
- 🎙️ **flutter_sound: ^9.2.13** - Records and plays audio messages.
- 🔑 **permission_handler: ^9.2.0** - Handles runtime permissions for accessing device features.
- 📂 **path_provider: ^2.0.15** - Retrieves paths to device directories for file storage.
- 🔊 **audioplayers: ^4.1.0** - Plays audio files with advanced options.
- ↔️ **swipe_to: ^1.0.2** - Implements swipe-to-delete and swipe-to-archive gestures.
- 🔦 **story_view: ^0.14.0** - Displays stories with interactive gestures.


## Contributing 🤝
Contributions to the WhatsApp Clone project are welcome and encouraged! If you find any bugs, have feature requests, or want to contribute in any way, please open an issue or submit a pull request.
