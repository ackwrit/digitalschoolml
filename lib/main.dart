import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controller = TextEditingController();
  late LanguageIdentifier _languageIdentifier;
  String simpleLang = "";
  String mutlipleLang = "";



  // méthode
  getUniqueLanguage() async {
    if(controller.text == "") return;
    String phrase = controller.text;
    String langageIdentified = await _languageIdentifier.identifyLanguage(phrase);
    setState(() {
      simpleLang = langageIdentified;
    });

  }

  getMultipleLanguage() async{
    String phrase = controller.text;
    if(phrase == "") return;
    final multiple = await _languageIdentifier.identifyPossibleLanguages(phrase);
    if(multiple.isEmpty){
      setState(() {
        mutlipleLang = "Nous n'avons pas trouvé aucune correspondance";
      });

    }
    else
      {
        for(var lang in multiple){
          setState(() {
            mutlipleLang += "${lang.languageTag}, avec une confiance de : ${lang.confidence *100}%";
          });

        }
      }

  }


  @override
  void initState() {
    _languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.3);
    super.initState();
  }

  @override
  void dispose() {
    _languageIdentifier.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: controller,

            ),


            Text("une langue identifié : $simpleLang"),

            Text("les langues identifiées  : $mutlipleLang"),

            ElevatedButton(
                onPressed: getUniqueLanguage,

                child: const Text("Idenfier la langue")
            ),

            ElevatedButton(
                onPressed: getMultipleLanguage,

                child: const Text("Idenfier la langue")
            ),



          ],
        ),
      ),

    );
  }
}
