import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  double xAngle = 0;
  double prevXAngle = 0;
  double yAngle = 0;
  double prevYAngle = 0;
  double zAngle = 0;
  double prevZAngle = 0;
  final streamsub = <StreamSubscription<dynamic>>[];
  double width = 330;
  double height = 500;

  @override
  void initState() {
    super.initState();

    streamsub.add(accelerometerEvents.listen((event) {
      setState(() {
        prevXAngle = xAngle;
        xAngle = event.x;
        prevYAngle = yAngle;
        yAngle = double.parse(event.y.toString());
        prevZAngle = zAngle;
        zAngle = double.parse(event.z.toString());
      });
    }));
  }

  @override
  void dispose() {
    super.dispose();
    for (final sub in streamsub) {
      sub.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.grey.shade800,
              Colors.black,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              left: xAngle * -3,
              right: xAngle * 3,
              top: zAngle * -3,
              bottom: zAngle * 3,
              duration: Duration(milliseconds: 300),
              child: Center(
                child: TweenAnimationBuilder(
                    tween: Tween(begin: prevXAngle, end: xAngle),
                    duration: const Duration(milliseconds: 300),
                    builder: (context, double xValue, _) {
                      return TweenAnimationBuilder(
                          tween: Tween(begin: prevZAngle, end: zAngle),
                          duration: const Duration(milliseconds: 300),
                          builder: (context, double zValue, _) {
                            return Transform(
                              origin: Offset(width / 2, height / 2),
                              transform: Matrix4.identity()
                                ..setEntry(2, 1, 0.001)
                                ..rotateX(-zValue / 30)
                                ..rotateY(xValue / 30),
                              child: Container(
                                width: width,
                                height: height,
                                decoration: BoxDecoration(
                                  image: const DecorationImage(
                                      image: AssetImage("assets/bg1.png"),
                                      fit: BoxFit.cover),
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5),
                                  border:
                                      Border.all(color: Colors.grey.shade800),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 10,
                                      spreadRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    }),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 100),
              left: xAngle * 3,
              right: xAngle * -3,
              top: 150,
              child: Center(
                child: Container(
                  height: height,
                  width: width,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: const EdgeInsets.only(top: 30),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.yellowAccent.shade100,
                            spreadRadius: 15,
                            blurRadius: 90,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
