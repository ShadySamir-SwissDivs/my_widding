import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const WeddingInvitationApp());
}

class WeddingInvitationApp extends StatelessWidget {
  const WeddingInvitationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wedding Invitation',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const WeddingCardScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffBC9293),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(30),
                  child: Image.asset('assets/ring.png', fit: BoxFit.contain),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Wedding Invitation',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                const Text('💕', style: TextStyle(fontSize: 40)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WeddingCardScreen extends StatefulWidget {
  const WeddingCardScreen({super.key});

  @override
  State<WeddingCardScreen> createState() => _WeddingCardScreenState();
}

class _WeddingCardScreenState extends State<WeddingCardScreen> {
  double dragValue = 0.0; // 0 = closed, 1 = opened

  double widthCard = 326;
  double heightCard = 460;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      var width = MediaQuery.of(context).size.width - 64;
      var height = MediaQuery.of(context).size.height - 200;

      if (height >= width * 1.4) {
        heightCard = width * 1.4;
        widthCard = width;
        print('one');
      } else {
        widthCard = height * .7;
        heightCard = height;
        print('two');
      }
      setState(() {});
    });
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      dragValue += details.delta.dy / 350;
      dragValue = dragValue.clamp(0.0, 1.0);
    });
  }

  void _onDragEnd(DragEndDetails details) {
    setState(() {
      dragValue = dragValue > 0.5 ? 1.0 : 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final angle = pi / 2 * dragValue;

    print('card $widthCard, $heightCard');

    return Scaffold(
      backgroundColor: Color(0xffBC9293),
      body: GestureDetector(
        onVerticalDragUpdate: _onDragUpdate,
        onVerticalDragEnd: _onDragEnd,
        child: Stack(
          alignment: Alignment.center,
          children: [
            /// Romantic hearts before opening
            Center(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Center(
                    child: SizedBox(
                      width: widthCard,
                      height: heightCard,
                      child: Stack(
                        children: [
                          /// Inside content
                          Container(
                            width: widthCard,
                            height: heightCard,
                            decoration: BoxDecoration(
                              color: const Color(0xffFFF1F5),
                              borderRadius: BorderRadius.circular(18),
                              image: DecorationImage(
                                image: AssetImage('assets/lottie/wedding.png'),
                              ),
                            ),
                          ),

                          /// Left cover
                          Transform(
                            alignment: Alignment.centerLeft,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY(-angle),
                            child: _cardCover(isLeft: true),
                          ),
                          Transform(
                            alignment: Alignment.centerRight,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY(angle),
                            child: _cardCover(isLeft: false),
                          ),

                          /// Ring
                          Center(
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(angle),
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 600),
                                opacity: dragValue < 0.8 ? 1 : 0,
                                child: AnimatedScale(
                                  duration: const Duration(milliseconds: 600),
                                  scale: dragValue < 0.8 ? 1 : 0.7,
                                  child: Lottie.asset(
                                    'assets/lottie/down.json',
                                    width: 140,
                                    repeat: false,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/lottie/rings.json', height: 120),
                        SizedBox(width: 32),
                        Lottie.asset(
                          'assets/lottie/hearts_down.json',
                          height: 120,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// Card

            /// Hint text
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Text(
                dragValue < 0.5
                    ? "اسحب لأسفل لفتح الدعوة 💕"
                    : "اسحب لأعلى للإغلاق",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardCover({required bool isLeft}) {
    return Align(
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        width: widthCard / 2,
        height: heightCard,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xff744a4b), Color(0xffBC9293)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.only(
            topLeft: isLeft ? const Radius.circular(18) : Radius.zero,
            bottomLeft: isLeft ? const Radius.circular(18) : Radius.zero,
            topRight: !isLeft ? const Radius.circular(18) : Radius.zero,
            bottomRight: !isLeft ? const Radius.circular(18) : Radius.zero,
          ),
        ),
      ),
    );
  }
}
