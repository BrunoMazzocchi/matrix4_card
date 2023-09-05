import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palette_generator/palette_generator.dart';

void main() {
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
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
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

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {

  String image = "https://i0.wp.com/codigoespagueti.com/wp-content/uploads/2023/05/One-Piece-Live-action-Netflix.jpg?resize=1280%2C1903&quality=80&ssl=1";     
  double x = 0;
  double y = 0;
  double z = 0;

  /// Generate a [PaletteGenerator] from an [ImageProvider].
  Future<PaletteGenerator> generatePalette(ImageProvider imageProvider) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(imageProvider);
    return paletteGenerator;
  }

  late Future<PaletteGenerator> palete;
  @override
  void initState() {
    palete = generatePalette( NetworkImage(
        image));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: palete,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              color: snapshot.data!.dominantColor!.color,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Transform(
                      transform: Matrix4(
                        1,
                        0,
                        0,
                        0,
                        0,
                        1,
                        0,
                        0,
                        0,
                        0,
                        1,
                        0.002,
                        0,
                        0,
                        0,
                        1,
                      )
                        ..rotateX(x)
                        ..rotateY(y)
                        ..rotateZ(z),
                      alignment: FractionalOffset.center,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            x += details.delta.dy / 100;
                            y += details.delta.dx / 100;
                          });
                        },
                        onPanEnd: (details) {
                          setState(() {
                            x = 0;
                            y = 0;
                          });
                        },
                        child: Container(
                          height: 450.0,
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                              image: NetworkImage(
                                  image),
                              fit: BoxFit.cover,
                            ),
                             // Box shadow based on the dominant color
                            boxShadow: [
                              BoxShadow(
                                color: snapshot.data!.colors.elementAt(1),
                                blurRadius: 20.0,
                                spreadRadius: 5.0,
                                offset: const Offset(0.0, 5.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
