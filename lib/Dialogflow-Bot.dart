import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:tts/tts.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'main.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/translate/v2.dart';
import 'package:location/location.dart';

void main() => runApp(new MyApp());

final _credentials = new ServiceAccountCredentials.fromJson(r'''
{
  "type": "service_account",
  "project_id": "dalmiacement-deb0e",
  "private_key_id": "c0b82ac6b759cbca43afe231dee6aba7ea9b2b84",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDDqDzhfpP45bCG\noWi0qjHNfnL5z2NuhSfIk7E6cgYbFO2bmEga49Y8T6jbPgO+DBVGSSDavV7zwO/Z\n+7xg7tWa555YPzbQMlmiCgzLeMXbZcZYRSMtWgKoWcMtYaIy28RtPktalCgUbM5R\nDiAF7eg2t9s7Cnequ0ohxp8Dup/wuxKjqXbPtGISlY3wW1yu7zjxKFY30wTEwXkb\nngjkl8S7bRGOdqbiSmXyZMcxq6l39uDCWA5YQs/K9hbpJbioL3oOZgb8CRsYuRgP\niWUiYiyDk4VzrEJ4a78s0BuS02QDG2mCrAPtNuZ7UUQO5nWYt11A3rD8U6DmkyBU\ndefWAjgbAgMBAAECggEADqDQ8HEEwiqgwJK9H9N2XBf0o624OuafW1UuKSGmSDcP\n2WlmFrCVxLZAoyenTaRcoNUjLNzUsQ0UlwEbC/Tp/nthBisFFPAhbcZ/lLoyXMgR\nWhR33/z8pDaV1kTtmgzT9PD1NE/4Zn0zYwcB05T+dBIvRLebISYrPDbmjkz72+/B\n0WhYSdL8A84IedojkfYVHtcgvU6ai9QlNnM9F+LAB+TFYgJJbJnJhA5MsN5nQP1Y\npB9Xm6l3bgGTAEGw99bQFhdIPn7g1t1071at3x7Wbx9KLc7KJhpebINhAno5Xe8u\n19s0EXyvhSh2Eh3UX2/tIckqWhb/y+7jC1WGEydM8QKBgQDmpXFRvK5amElDcYBo\nVN2kpf9y4iNO1Blo4SPm8PVwVpeMLn/4tvxCtQE6NV1A964WBhfhF8Gj0KM+Ahzg\n88boj4EMiPOMwGSjR788ryWDsUeNPPLF2pkjlQM6NK04eGGhBDgD2I7bF4AtJg5Z\nTMAzHn4ZwguqZxo/S5IjKOrQywKBgQDZKi0ncVT7ew/RdqEPf1jvbK4uuuV4s6g+\nfOTTp09U20miLJ0ZJDKE6hmS7tJcB0jWXKPgpAWahkZcJXEdfvi4h2ri7sfQGiiG\n9J69HqxpiRHvFTo1Gui0693nIZDJnVlbLKiU8piCan8g7ZqU+P2oL4ub0hvoTst5\nN74jVELb8QKBgDw1bAN+UbVsk5N7iZ2yqblVa/29cqIdVBTA0PJ0bF3K/PynFtkC\nS4/OWGetjo5rGZK+PHWSEgaFbFe/jXJbsMz8yR9QkONpRdwp2o4o2o4qNRd1lZp4\nmglj2NfU8HMRWcsCouy+F2yyEc+3Y3+EPZgamah3szvkdkGXpKpw//tJAoGAVXfc\n95YKDUOcsSKQNuo21VwfnXKfF4cVoypCYO6LMWlwrGwElD2DyH3d/M8TaXbQetVR\nBftn3S4ViPSPdT1gpDdfoNq7NzLkWmDyDJqC3rI8pazkELx7c6EU3399XWwZG+IS\nozRrQ4Cocgwxd4obQtMbjgL+SsqgGCARLBRgj/ECgYAOE8Gn6IgoVUIgExsnbRnN\n/ZMzwZ6XIen6lw0/ATLkEHnX17ra3yO+00BgIV+oty2fqzpZcGXV/7/7ggSFheeU\nsANtCxgM+wqMZs+II9/WT/h4ck9bg3D7/zJt/KdV1QtTLgdmwE4QO0SEXlvSyMuQ\n1cx7IBnV1eLiS8dQB+WeRA==\n-----END PRIVATE KEY-----\n",
  "client_email": "dialogflow-vcfwqs@dalmiacement-deb0e.iam.gserviceaccount.com",
  "client_id": "114107258950375449550",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/dialogflow-vcfwqs%40dalmiacement-deb0e.iam.gserviceaccount.com"
}

''');

var currentLocation = <String, double>{};

var location = new Location();

// Platform messages may fail, so we use a try/catch PlatformException.

const _SCOPES = const [TranslateApi.CloudTranslationScope];
/**
const LanguagesforSpeech = {
/**
    'Belarusian',
    'Bosnian',
    'Burmese',
    'Cebuano',
    'Chichewa',
    'Corsican',
    'Esperanto',  'Estonian',  ,
    ,  'Frisian',
    ,  'Haitian Creole',
    'Hausa',  'Hawaiian',
    'Hmong',  ,
    ,  'Igbo',
    ,  'Irish',
    'Kazakh',  ,
    ,  'Kurdish (Kurmanji)',
    'Kyrgyz',  ,
    'Latin',  ,
    ,  'Luxembourgish',
    'Macedonian',  'Malagasy',
    'Maltese',  'Maori',
    ,  'Mongolian',
    'Pashto',
    'Punjabi',  'Romanian',
    ,  'Samoan',
    'Scots Gaelic',  ,
    'Sesotho',  'Shona',
    'Sindhi',
    'Somali','Tajik',
    'Uzbek',
    'Welsh',  'Xhosa',
    'Yiddish',  'Yoruba',

 **/

  'Afrikaans': 'af_ZA',
  'Amharic': 'am_ET',
  'Armenian': 'hy_AM',
  'Azerbaijani': 'az_AZ',
  'Indonesian': 'id_ID',
  'Malay': 'ms_MY',
  'Bengali': 'bn_IN',
  'Catalan': 'ca_ES',
  'Czech': 'cs_CZ',
  'Danish': 'da_DK',
  'German': 'de_DE',
  'English': 'en_US',
  'Spanish': 'es_ES',
  'Basque': 'eu_ES',
  'Filipino': 'fil_PH',
  'French': 'fr_FR',
  'Galician': 'gl_ES',
  'Georgian': 'ka_GE',
  'Gujarati': 'gu_IN',
  'Croatian': 'hr_HR',
  'Zulu': 'zu_ZA',
  'Icelandic': 'is_IS',
  'Italian': 'it_IT',
  'Javanese': 'jv_ID',
  'Kannada': 'kn_IN',
  'Khmer': 'km_KH',
  'Lao': 'lo_LA',
  'Latvian': 'lv_LV',
  'Lithuanian': 'lt_LT',
  'Hungarian': 'hu_HU',
  'Malayalam': 'ml_IN',
  'Marathi': 'mr_IN',
  'Dutch': 'nl_NL',
  'Nepali': 'ne_NP',
  'Norwegian (Bokmål)': 'nb_NO',
  'Polish': 'pl_PL',
  'Portuguese': 'pt_PT',
  'Sinhala': 'si_LK',
  'Slovak': 'sk_SK',
  'Slovenian': 'sl_SI',
  'Sundanese': 'su_ID',
  'Swahili': 'sw_KE',
  'Finnish': 'fi_FI',
  'Swedish': 'sv_SE',
  'Tamil': 'ta_IN',
  'Telugu': 'te_IN',
  'Vietnamese': 'vi_VN',
  'Turkish': 'tr_TR',
  'Urdu': 'ur_PK',
  'Greek': 'el_GR',
  'Bulgarian': 'bg_BG',
  'Russian': 'ru_RU',
  'Serbian': 'sr_RS',
  'Ukrainian': 'uk_UA',
  'Hebrew': 'he_IL',
  'Persian': 'fa_IR',
  'Hindi': 'hi_IN',
  'Thai': 'th_TH',
  'Korean': 'ko_KR',
  'Chinese': 'zh',
  'Japanese': 'ja_JP',
}; **/

const languages = const [
  const Language('Francais', 'fr_FR'),
  const Language('English', 'en_US'),
  const Language('Pусский', 'ru_RU'),
  const Language('Italiano', 'it_IT'),
  const Language('Español', 'es_ES'),
];

class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}

Map<String, String> fromTranslation = new HashMap();

const LangForTranslation = {
  'Afrikaans': 'af',
  'Albanian': 'sq',
  'Amharic': 'am',
  'Arabic': 'ar',
  'Armenian': 'hy',
  'Azerbaijani': 'az',
  'Basque': 'eu',
  'Belarusian': 'be',
  'Bengali': 'bn',
  'Bosnian': 'bs',
  'Bulgarian': 'bg',
  'Burmese': 'my',
  'Catalan': 'ca',
  'Cebuano': 'ceb',
  'Chichewa': 'ny',
  'Chinese': 'zh',
  'Corsican': 'co',
  'Croatian': 'hr',
  'Czech': 'cs',
  'Danish': 'da',
  'Dutch': 'nl',
  'English': 'en',
  'Esperanto': 'eo',
  'Estonian': 'et',
  'Filipino': 'tl',
  'Finnish': 'fi',
  'French': 'fr',
  'Frisian': 'fy',
  'Galician': 'gl',
  'Georgian': 'ka',
  'German': 'de',
  'Greek': 'el',
  'Gujarati': 'gu',
  'Haitian Creole': 'ht',
  'Hausa': 'ha',
  'Hawaiian': 'haw',
  'Hebrew': 'iw',
  'Hindi': 'hi',
  'Hmong': 'hmn',
  'Hungarian': 'hu',
  'Icelandic': 'is',
  'Igbo': 'ig',
  'Indonesian': 'id',
  'Irish': 'ga',
  'Italian': 'it',
  'Japanese': 'ja',
  'Javanese': 'jw',
  'Kannada': 'kn',
  'Kazakh': 'kk',
  'Khmer': 'km',
  'Korean': 'ko',
  'Kurdish (Kurmanji)': 'ku',
  'Kyrgyz': 'ky',
  'Lao': 'lo',
  'Latin': 'la',
  'Latvian': 'lv',
  'Lithuanian': 'lt',
  'Luxembourgish': 'lb',
  'Macedonian': 'mk',
  'Malagasy': 'mg',
  'Malay': 'ms',
  'Malayalam': 'ml',
  'Maltese': 'mt',
  'Maori': 'mi',
  'Marathi': 'mr',
  'Mongolian': 'mn',
  'Nepali': 'ne',
  'Norwegian (Bokmål)': 'no',
  'Pashto': 'ps',
  'Persian': 'fa',
  'Polish': 'pl',
  'Portuguese': 'pt',
  'Punjabi': 'pa',
  'Romanian': 'ro',
  'Russian': 'ru',
  'Samoan': 'sm',
  'Scots Gaelic': 'gd',
  'Serbian': 'sr',
  'Sesotho': 'st',
  'Shona': 'sn',
  'Sindhi': 'sd',
  'Sinhala': 'si',
  'Slovak': 'sk',
  'Slovenian': 'sl',
  'Somali': 'so',
  'Spanish': 'es',
  'Sundanese': 'su',
  'Swahili': 'sw',
  'Swedish': 'sv',
  'Tajik': 'tg',
  'Tamil': 'ta',
  'Telugu': 'te',
  'Thai': 'th',
  'Turkish': 'tr',
  'Ukrainian': 'uk',
  'Urdu': 'ur',
  'Uzbek': 'uz',
  'Vietnamese': 'vi',
  'Welsh': 'cy',
  'Xhosa': 'xh',
  'Yiddish': 'yi',
  'Yoruba': 'yo',
  'Zulu': 'zu',
};

class MyApp extends StatelessWidget {
  final String emailDetails;
  final String langSel;
  final String displayName;
  // This widget is the root of your application.
  MyApp(
      {Key key,
      @required this.emailDetails,
      this.langSel,
      @required this.displayName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Dalmia Assistance',
      theme: new ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: new MyHomePage(title: 'Dalmia Assistance'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String emailDetails;
  final String langSel;
  final String displayName;
  MyHomePage(
      {Key key,
      this.title,
      @required this.emailDetails,
      @required this.displayName,
      this.langSel})
      : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SpeechRecognition _speech;
  AutoRefreshingAuthClient http_c;

  bool currentWidget = true;

  Image image1;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;

  String qVal;
  String apple(query) {
    print(widget.langSel);
    List<String> a = [""];
    a.add(query);
    TranslateApi translateApi = new TranslateApi(http_c);
    TranslateTextRequest textRequest = new TranslateTextRequest();
    textRequest.q = a;
    textRequest.source = LangForTranslation[widget.langSel];
    textRequest.target = "en";
    textRequest.format = "text";
    TranslationsResourceApi x = translateApi.translations;
    Future<TranslationsListResponse> w = x.translate(textRequest);
    w.then((value) =>
        {qVal = value.translations.removeLast().translatedText: print(qVal)});
    a.clear();
  }

  String mango(query) {
    print(widget.langSel);
    List<String> a = [""];
    a.add(query);
    TranslateApi translateApi = new TranslateApi(http_c);
    TranslateTextRequest textRequest = new TranslateTextRequest();
    textRequest.q = a;
    textRequest.source = "en";
    textRequest.target = LangForTranslation[widget.langSel];
    textRequest.format = "text";
    TranslationsResourceApi x = translateApi.translations;
    Future<TranslationsListResponse> w = x.translate(textRequest);
    w.then((value) =>
        {qVal = value.translations.removeLast().translatedText: print(qVal)});
    a.clear();
  }

  Language selectedLang = languages.first;

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();
    clientViaServiceAccount(_credentials, _SCOPES).then((http_client) {
      http_c = http_client;
    });
  }

  void activateSpeechRecognizer() {
    print('_MyAppState.activateSpeechRecognizer... ');
    _speech = new SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setCurrentLocaleHandler(onCurrentLocale);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech
        .activate()
        .then((res) => setState(() => _speechRecognitionAvailable = res));
  }

  Widget _buildButton({String label, VoidCallback onPressed}) => new Padding(
      padding: new EdgeInsets.all(12.0),
      child: new RaisedButton(
        color: Colors.cyan.shade600,
        onPressed: onPressed,
        child: new Icon(Icons.keyboard_voice),
      ));

  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            _buildButton(
              onPressed: _speechRecognitionAvailable && !_isListening
                  ? () => start()
                  : null,
              label: "Listening",
            ),
            new Flexible(
              child: new TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: () => _handleSubmitted(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }

  void start() => _speech
      .listen(locale: selectedLang.code)
      .then((result) => print('_MyAppState.start => result $result'));

  void cancel() =>
      _speech.cancel().then((result) => setState(() => _isListening = result));

  void stop() => _speech.stop().then((result) {
        setState(() => _isListening = result);
      });

  void onSpeechAvailability(bool result) =>
      setState(() => _speechRecognitionAvailable = result);

  void onCurrentLocale(String locale) {
    print('_MyAppState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() => setState(() => _isListening = true);

  void onRecognitionResult(String text) =>
      setState(() => _textController.text = text);

  void onRecognitionComplete() => setState(() => _isListening = false);

  void errorHandler() => activateSpeechRecognizer();

  void Response(query) async {
    _textController.clear();
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "json_files/DalmiaCement-c0b82ac6b759.json")
            .build();
    Dialogflow dialogflow = Dialogflow(authGoogle: authGoogle);
    AIResponse response = await dialogflow.detectIntent(
        query, widget.emailDetails, widget.displayName);
    String op = response.getMessage();
    if (widget.langSel == null || LangForTranslation[widget.langSel] == "en") {
      qVal = op;
    } else {
      mango(op);
    }

    Future.delayed(const Duration(milliseconds: 1000), () {
      ChatMessage message = new ChatMessage(
        text: qVal,
        name: "Dalmia Cement Bot",
        type: false,
      );
      Tts.speak(qVal);
      setState(() {
        _messages.insert(0, message);
      });
    });
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = new ChatMessage(
      text: text,
      name: "Me",
      type: true,
    );
    setState(() {
      _messages.insert(0, message);
    });

    if (widget.langSel == null || LangForTranslation[widget.langSel] == "en") {
      qVal = text;
    } else {
      apple(text);
    }

    Future.delayed(const Duration(milliseconds: 800), () {
      Response(qVal);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Dalmia Assistance"),
      ),
      body: new Column(children: <Widget>[
        new Flexible(
            child: new ListView.builder(
          padding: new EdgeInsets.all(8.0),
          reverse: true,
          itemBuilder: (_, int index) => _messages[index],
          itemCount: _messages.length,
        )),
        new Divider(height: 1.0),
        new Container(
          decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          child: _buildTextComposer(),
        ),
      ]),
    );
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.name, this.type});

  final String text;
  final String name;
  final bool type;

  List<Widget> otherMessage(context) {
    return <Widget>[
      new Container(
        margin: const EdgeInsets.only(right: 16.0),
        child: new CircleAvatar(child: new Text(this.name[0])),
      ),
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(this.name,
                style: new TextStyle(fontWeight: FontWeight.bold)),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: new Text(text),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> myMessage(context) {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Text(this.name,
                style: new TextStyle(fontWeight: FontWeight.bold)),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: new Text(text),
            ),
          ],
        ),
      ),
      new Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: new CircleAvatar(child: new Text(this.name[0])),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.type ? myMessage(context) : otherMessage(context),
      ),
    );
  }
}
