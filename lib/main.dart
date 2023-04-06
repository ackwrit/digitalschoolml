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

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController controller;
  late LanguageIdentifier _languageIdentifier;
  late OnDeviceTranslator translator;
  String simpleLang = "";
  String mutlipleLang = "";
  String traductionText = "";



  // méthode
  getUniqueLanguage() async {
    simpleLang = "";
    String phrase = controller.text;
    if(phrase == "") return;
    final langage = await _languageIdentifier.identifyLanguage(phrase);
    setState(() {
      simpleLang = langage;
    });

  }

  getMultipleLanguage() async{
    mutlipleLang = "";
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

  traduction() async{
    traductionText = "";
    if(controller.text == "") return;
    String phrase = controller.text;
    final tr = await translator.translateText(phrase);
    setState(() {
      traductionText = tr;
    });
  }


  @override
  void initState() {
    controller = TextEditingController();
    _languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.3);
    translator = OnDeviceTranslator(sourceLanguage: TranslateLanguage.french, targetLanguage: TranslateLanguage.croatian);
    super.initState();
  }

  @override
  void dispose() {
    _languageIdentifier.close();
    translator.close();
    controller.dispose();
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

            Text("Message traduit  : $traductionText"),

            ElevatedButton(
                onPressed: getUniqueLanguage,

                child: const Text("Idenfier la langue")
            ),

            ElevatedButton(
                onPressed: getMultipleLanguage,

                child: const Text("Idenfier les langues")
            ),
            ElevatedButton(
                onPressed: traduction,

                child: const Text("Traduire de français en croate")
            ),



          ],
        ),
      ),

    );
  }
}
