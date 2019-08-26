import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'Dialogflow-Bot.dart'; //important fix
import 'dataEntry.dart';
import 'package:flutter_search_panel/flutter_search_panel.dart';
import 'package:simple_permissions/simple_permissions.dart';

void main() {
  runApp(new MaterialApp(title: "Dalmia Assistance", home: new MyHome()));
}

class UserDetails {
  final String providerId;
  final String uid;
  final String displayName;
  final String photoUrl;
  final String email;
  final bool isAnonymous;
  final bool isEmailVerified;
  final List<UserInfoDetails> providerData;
  UserDetails(this.providerId, this.uid, this.displayName, this.photoUrl,
      this.email, this.isAnonymous, this.isEmailVerified, this.providerData);
}

class UserInfoDetails {
  UserInfoDetails(
      this.providerId, this.displayName, this.email, this.photoUrl, this.uid);
  final String providerId;
  final String uid;
  final String displayName;
  final String photoUrl;
  final String email;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Dalmia Assistance',
        theme: new ThemeData(
            primarySwatch: Colors.lightBlue,
            primaryTextTheme: TextTheme(title: TextStyle(color: Colors.white))),
        home: new MyHome(),
        debugShowCheckedModeBanner: false // Default or main screen of the app
        );
  }
}

class MyHome extends StatefulWidget {
  @override
  MyHomeState createState() => new MyHomeState();
}

String emailDetails;
String langSelected;
String displayName;

final FirebaseAuth _fAuth = FirebaseAuth.instance;
final GoogleSignIn _gSignIn = new GoogleSignIn(scopes: [
  'email',
  'https://www.googleapis.com/auth/cloud-platform',
  'https://www.googleapis.com/auth/dialogflow'
]);

class MyHomeState extends State<MyHome> {
  static Future<FirebaseUser> _signIn(BuildContext context) async {
    GoogleSignInAccount googleSignInAccount = await _gSignIn.signIn();
    GoogleSignInAuthentication authentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken);

    FirebaseUser user = await _fAuth.signInWithCredential(credential);

    UserInfoDetails userInfo = new UserInfoDetails(
        user.providerId, user.displayName, user.email, user.photoUrl, user.uid);

    List<UserInfoDetails> providerData = new List<UserInfoDetails>();
    providerData.add(userInfo);

    UserDetails details = new UserDetails(
        user.providerId,
        user.uid,
        user.displayName,
        user.photoUrl,
        user.email,
        user.isAnonymous,
        user.isEmailVerified,
        providerData);

    emailDetails = details.email;
    displayName = details.displayName;
    print("User Name : ${user.displayName}");

    return user;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // Appbar
      appBar: new AppBar(
        // Title
        title: new Text("Dalmia Assistance"),
      ),
      // Body
      body: new Container(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Center(
              child: new MaterialButton(
                minWidth: 200.0,
                onPressed: () => _signIn(context)
                    .then((FirebaseUser user) => print(user.email))
                    .catchError((e) => print(e)),
                child: new Text('Sign in with Google'),
                color: Colors.white,
              ),
            ),
            new Center(
              child: new FlutterSearchPanel(
                padding: EdgeInsets.all(10.0),
                selected: 'English',
                title: 'Select Language',
                data: [
                  'Afrikaans',
                  'Albanian',
                  'Amharic',
                  'Arabic',
                  'Armenian',
                  'Azerbaijani',
                  'Basque',
                  'Belarusian',
                  'Bengali',
                  'Bosnian',
                  'Bulgarian',
                  'Burmese',
                  'Catalan',
                  'Cebuano',
                  'Chichewa',
                  'Chinese',
                  'Corsican',
                  'Croatian',
                  'Czech',
                  'Danish',
                  'Dutch',
                  'English',
                  'Esperanto',
                  'Estonian',
                  'Filipino',
                  'Finnish',
                  'French',
                  'Frisian',
                  'Galician',
                  'Georgian',
                  'German',
                  'Greek',
                  'Gujarati',
                  'Haitian Creole',
                  'Hausa',
                  'Hawaiian',
                  'Hebrew',
                  'Hindi',
                  'Hmong',
                  'Hungarian',
                  'Icelandic',
                  'Igbo',
                  'Indonesian',
                  'Irish',
                  'Italian',
                  'Japanese',
                  'Javanese',
                  'Kannada',
                  'Kazakh',
                  'Khmer',
                  'Korean',
                  'Kurdish (Kurmanji)',
                  'Kyrgyz',
                  'Lao',
                  'Latin',
                  'Latvian',
                  'Lithuanian',
                  'Luxembourgish',
                  'Macedonian',
                  'Malagasy',
                  'Malay',
                  'Malayalam',
                  'Maltese',
                  'Maori',
                  'Marathi',
                  'Mongolian',
                  'Nepali',
                  'Norwegian (Bokmål)',
                  'Pashto',
                  'Persian',
                  'Polish',
                  'Portuguese',
                  'Punjabi',
                  'Romanian',
                  'Russian',
                  'Samoan',
                  'Scots Gaelic',
                  'Serbian',
                  'Sesotho',
                  'Shona',
                  'Sindhi',
                  'Sinhala',
                  'Slovak',
                  'Slovenian',
                  'Somali',
                  'Spanish',
                  'Sundanese',
                  'Swahili',
                  'Swedish',
                  'Tajik',
                  'Tamil',
                  'Telugu',
                  'Thai',
                  'Turkish',
                  'Ukrainian',
                  'Urdu',
                  'Uzbek',
                  'Vietnamese',
                  'Welsh',
                  'Xhosa',
                  'Yiddish',
                  'Yoruba',
                  'Zulu'
                ],
                icon: new Icon(Icons.language, color: Colors.green),
                color: Colors.white,
                textStyle: new TextStyle(
                    color: Colors.black,
                    decorationStyle: TextDecorationStyle.dotted),
                onChanged: (value) {
                  langSelected = value;
                },
              ),
            ),
            new Center(
              child: new MaterialButton(
                minWidth: 200.0,
                onPressed: () => Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) =>
                            new DataEntry(emailDetails: emailDetails),
                      ),
                    ), //_signOut(context),
                child: new Text("Put some data!"),
                color: Colors.white,
              ),
            ),
            new Center(
              child: new MaterialButton(
                minWidth: 200.0,
                onPressed: () => Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new MyHomePage(
                            emailDetails: emailDetails,
                            langSel: langSelected,
                            displayName: displayName),
                      ),
                    ), //_signOut(context),
                child: new Text("Let's get started!"),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyInhWidget extends InheritedWidget {
  const MyInhWidget({Key key, this.userName, Widget child})
      : super(key: key, child: child);

  final String userName;

  //const MyInhWidget(userName, Widget child) : super(child: child);

  @override
  bool updateShouldNotify(MyInhWidget old) {
    return userName != old.userName;
  }

  static MyInhWidget of(BuildContext context) {
    // You could also just directly return the name here
    // as there's only one field
    return context.inheritFromWidgetOfExactType(MyInhWidget);
  }
}
