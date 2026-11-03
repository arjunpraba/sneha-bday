
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const SnehaBirthdayApp());
}

class SnehaBirthdayApp extends StatelessWidget {
  const SnehaBirthdayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'A Surprise for Sneha',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const BirthdayExperience(),
    );
  }
}

class BirthdayExperience extends StatefulWidget {
  const BirthdayExperience({super.key});

  @override
  State<BirthdayExperience> createState() =>
      _BirthdayExperienceState();
}

class _BirthdayExperienceState extends State<BirthdayExperience>
    with TickerProviderStateMixin {

  late AnimationController ambientController;
  late AnimationController entranceController;
  late AnimationController envelopeController;
  late AnimationController heartController;

  bool envelopeOpened = false;
  bool showLetter = false;
  bool showFinalMessage = false;
  bool typingFinished = false;

  String displayedMessage = '';
  Timer? typingTimer;

  final String birthdayMessage =
      "Hey Scene! ❤️\n\n"
      "Some people enter our lives and make ordinary "
      "moments feel a little more beautiful.\n\n"
      "You are one of those people.\n\n"
      "Maybe I don't always express it, but seeing you "
      "smile genuinely makes the day better.\n\n"
      "I hope your life is always filled with beautiful "
      "memories, unexpected happiness, endless laughter "
      "and everything your heart wishes for.\n\n"
      "Never change the wonderful person you are. "
      "Keep shining, keep smiling and always be happy.\n\n"
      "Happy Birthday, Sneha! 🌸";

  @override
  void initState() {
    super.initState();

    ambientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();

    entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();

    envelopeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    typingTimer?.cancel();
    ambientController.dispose();
    entranceController.dispose();
    envelopeController.dispose();
    heartController.dispose();
    super.dispose();
  }

  // OPEN ENVELOPE

  Future<void> openEnvelope() async {
    if (envelopeOpened) return;

    setState(() {
      envelopeOpened = true;
    });

    await envelopeController.forward();

    if (!mounted) return;

    setState(() {
      showLetter = true;
    });
  }

  // TYPING ANIMATION

  void startTyping() {
    if (typingTimer != null) return;

    setState(() {
      showFinalMessage = true;
      typingFinished = false;
      displayedMessage = '';
    });

    int index = 0;

    typingTimer = Timer.periodic(
      const Duration(milliseconds: 32),
          (timer) {
        if (!mounted) {
          timer.cancel();
          typingTimer = null;
          return;
        }

        if (index >= birthdayMessage.length) {
          timer.cancel();
          typingTimer = null;

          setState(() {
            typingFinished = true;
          });
          return;
        }

        setState(() {
          displayedMessage += birthdayMessage[index];
          index++;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10051E),
      body: Stack(
        children: [
          // AURORA BACKGROUND

          AnimatedBuilder(
            animation: ambientController,
            builder: (context, child) {
              return CustomPaint(
                painter: AuroraPainter(
                  progress: ambientController.value,
                ),
                child: const SizedBox.expand(),
              );
            },
          ),

          // STARS AND PARTICLES

          AnimatedBuilder(
            animation: ambientController,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlePainter(
                  progress: ambientController.value,
                ),
                child: const SizedBox.expand(),
              );
            },
          ),

          // MAIN CONTENT - CENTERED LAYOUT

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                      minWidth: constraints.maxWidth,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 35,
                      ),
                      child: Center(
                        child: SizedBox(
                          width: min(
                            constraints.maxWidth - 40,
                            500,
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 900),
                            switchInCurve: Curves.easeOutBack,
                            switchOutCurve: Curves.easeIn,
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: ScaleTransition(
                                  scale: animation,
                                  child: child,
                                ),
                              );
                            },
                            child: showLetter
                                ? buildBirthdayCard(
                              key: const ValueKey('letter'),
                            )
                                : buildIntro(
                              key: const ValueKey('intro'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // FLOATING HEART

          Positioned(
            top: 35,
            right: 25,
            child: AnimatedBuilder(
              animation: heartController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 0.85 + heartController.value * 0.3,
                  child: const Text(
                    '💗',
                    style: TextStyle(fontSize: 28),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // INTRO SCREEN
  // --------------------------------------------------

  Widget buildIntro({Key? key}) {
    return FadeTransition(
      key: key,
      opacity: entranceController,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'SOMEONE SPECIAL HAS A SURPRISE FOR YOU',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFFFC6E1),
              fontSize: 10,
              letterSpacing: 3,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            'Hey Scene...',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'cursive',
              fontSize: 55,
              color: Color(0xFFFFD9EA),
              shadows: [
                Shadow(
                  color: Colors.pinkAccent,
                  blurRadius: 25,
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'There is a little something waiting for you.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.7,
            ),
          ),

          const SizedBox(height: 45),

          // ANIMATED ENVELOPE

          AnimatedBuilder(
            animation: envelopeController,
            builder: (context, child) {
              final value = envelopeController.value;

              return Transform.translate(
                offset: Offset(0, -value * 25),
                child: Transform.rotate(
                  angle: sin(value * pi) * -0.05,
                  child: child,
                ),
              );
            },
            child: GestureDetector(
              onTap: openEnvelope,
              child: SizedBox(
                width: 245,
                height: 175,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 5,
                      child: Container(
                        width: 190,
                        height: 135,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE4EF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'For Sneha ❤️',
                            style: TextStyle(
                              color: Color(0xFF9D3B70),
                              fontFamily: 'cursive',
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 0,
                      child: AnimatedBuilder(
                        animation: envelopeController,
                        builder: (context, child) {
                          return CustomPaint(
                            size: const Size(245, 135),
                            painter: EnvelopePainter(
                              open: envelopeController.value,
                            ),
                          );
                        },
                      ),
                    ),

                    Positioned(
                      bottom: 45,
                      child: AnimatedOpacity(
                        opacity: envelopeOpened ? 0 : 1,
                        duration: const Duration(milliseconds: 300),
                        child: const Icon(
                          Icons.favorite,
                          color: Color(0xFFFF4F93),
                          size: 38,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),

          GestureDetector(
            onTap: openEnvelope,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFF5DAB),
                    Color(0xFFB65CFF),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pinkAccent.withOpacity(0.45),
                    blurRadius: 25,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.mail_outline, size: 20),
                  SizedBox(width: 10),
                  Text(
                    'OPEN YOUR SURPRISE',
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'A little moment made just for you ✨',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white54,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // BIRTHDAY CARD
  // --------------------------------------------------

  Widget buildBirthdayCard({Key? key}) {
    return Column(
      key: key,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'TODAY IS ALL ABOUT YOU',
          textAlign: TextAlign.center,
          style: TextStyle(
            letterSpacing: 3,
            fontSize: 10,
            color: Color(0xFFFFC6E1),
          ),
        ),

        const SizedBox(height: 12),

        const Text(
          'Happy Birthday',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'cursive',
            fontSize: 58,
            color: Color(0xFFFFD6E9),
            shadows: [
              Shadow(
                color: Colors.pinkAccent,
                blurRadius: 25,
              ),
            ],
          ),
        ),

        const Text(
          'SNEHA  •  SCENE 🌸',
          textAlign: TextAlign.center,
          style: TextStyle(
            letterSpacing: 4,
            color: Color(0xFFFFB5D5),
            fontSize: 12,
          ),
        ),

        const SizedBox(height: 28),

        // GLOWING PHOTO FRAME

        AnimatedBuilder(
          animation: heartController,
          builder: (context, child) {
            return Container(
              width: 245,
              height: 300,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(125),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFF8FBD),
                    Color(0xFFFFD9EB),
                    Color(0xFFB56BFF),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pinkAccent.withOpacity(
                      0.25 + heartController.value * 0.35,
                    ),
                    blurRadius: 20 + heartController.value * 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: child,
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(125),
            child: Image.asset(
              'assets/images/sneha.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) {
                return Container(
                  color: const Color(0xFF5B2854),
                  child: const Center(
                    child: Icon(
                      Icons.favorite,
                      size: 75,
                      color: Colors.pinkAccent,
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 25),

        const Text(
          'Some smiles make the world brighter...',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'cursive',
            fontSize: 26,
            color: Color(0xFFFFD9EA),
          ),
        ),

        const SizedBox(height: 12),

        const Text(
          'And yours is definitely one of them. ❤️',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),

        const SizedBox(height: 30),

        // SECRET MESSAGE BUTTON

        if (!showFinalMessage)
          GestureDetector(
            onTap: startTyping,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFF5DAB),
                    Color(0xFFB65CFF),
                  ],
                ),
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pinkAccent.withOpacity(0.4),
                    blurRadius: 25,
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome),
                  SizedBox(width: 10),
                  Text(
                    'READ SOMETHING SPECIAL',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // TYPING MESSAGE

        if (showFinalMessage) ...[
          const SizedBox(height: 10),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.09),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.pinkAccent.withOpacity(0.12),
                  blurRadius: 25,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'A little message for you...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'cursive',
                    fontSize: 30,
                    color: Color(0xFFFFC5DE),
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  displayedMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 2,
                    color: Colors.white,
                  ),
                ),

                if (!typingFinished)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      '♥',
                      style: TextStyle(
                        color: Colors.pinkAccent,
                        fontSize: 18,
                      ),
                    ),
                  ),

                if (typingFinished) ...[
                  const SizedBox(height: 20),
                  const Text(
                    '🌸  💗  ✨  💗  🌸',
                    style: TextStyle(fontSize: 23),
                  ),
                ],
              ],
            ),
          ),
        ],

        const SizedBox(height: 30),

        const Text(
          'MADE WITH A LITTLE EXTRA HEART ❤️',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 9,
            letterSpacing: 2,
            color: Colors.white54,
          ),
        ),
      ],
    );
  }
}

// --------------------------------------------------
// AURORA BACKGROUND
// --------------------------------------------------

class AuroraPainter extends CustomPainter {
  final double progress;

  AuroraPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        70,
      );

    final x = size.width *
        (0.5 + 0.25 * sin(progress * 2 * pi));

    final y = size.height *
        (0.35 + 0.15 * cos(progress * 2 * pi));

    paint.color = const Color(0xFF8B2B9C).withOpacity(0.32);

    canvas.drawCircle(
      Offset(x, y),
      size.width * 0.45,
      paint,
    );

    paint.color = const Color(0xFFFF398B).withOpacity(0.20);

    canvas.drawCircle(
      Offset(
        size.width * (0.8 - 0.25 * sin(progress * 2 * pi)),
        size.height * 0.75,
      ),
      size.width * 0.35,
      paint,
    );

    paint.color = const Color(0xFF553CFF).withOpacity(0.18);

    canvas.drawCircle(
      Offset(
        size.width * 0.1,
        size.height * (0.6 + 0.1 * cos(progress * 2 * pi)),
      ),
      size.width * 0.3,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant AuroraPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// --------------------------------------------------
// PARTICLES AND SPARKLES
// --------------------------------------------------

class ParticlePainter extends CustomPainter {
  final double progress;

  ParticlePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(42);

    final paint = Paint()
      ..color = Colors.white.withOpacity(0.65);

    for (int i = 0; i < 65; i++) {
      final x = random.nextDouble() * size.width;
      final initialY = random.nextDouble() * size.height;

      final speed = 0.5 + random.nextDouble();

      final y = (initialY -
          progress * size.height * speed) %
          size.height;

      final radius = 0.8 + random.nextDouble() * 1.8;

      final opacity = 0.25 +
          0.55 *
              (0.5 +
                  0.5 *
                      sin(progress * 2 * pi + i));

      paint.color = Colors.white.withOpacity(opacity);

      canvas.drawCircle(
        Offset(x, y),
        radius,
        paint,
      );
    }

    // SPARKLES

    for (int i = 0; i < 12; i++) {
      final x = (i * 83.0 + 30) % size.width;
      final y = (i * 127.0 + 50) % size.height;

      final opacity =
          0.2 +
              0.8 *
                  (0.5 +
                      0.5 *
                          sin(progress * 2 * pi + i));

      paint.color = const Color(0xFFFFD5EC)
          .withOpacity(opacity);

      canvas.drawCircle(
        Offset(x, y),
        2.0,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// --------------------------------------------------
// ENVELOPE DESIGN
// --------------------------------------------------

class EnvelopePainter extends CustomPainter {
  final double open;

  EnvelopePainter({required this.open});

  @override
  void paint(Canvas canvas, Size size) {
    final bodyPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFFF9AC5),
          Color(0xFFE75D9B),
        ],
      ).createShader(
        Rect.fromLTWH(
          0,
          0,
          size.width,
          size.height,
        ),
      );

    final body = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(body, bodyPaint);

    final flapPaint = Paint()
      ..color = const Color(0xFFFFB5D5);

    final flap = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height * 0.72)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(flap, flapPaint);

    final bottomFlap = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, size.height * 0.42)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(
      bottomFlap,
      Paint()..color = const Color(0xFFFF77AC),
    );

    // Envelope flap fades away as it opens.

    final flapOpacity = (1 - open).clamp(0.0, 1.0);

    final topFlap = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height * 0.7)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(
      topFlap,
      Paint()
        ..color = const Color(0xFFFFD0E5)
            .withOpacity(flapOpacity),
    );
  }

  @override
  bool shouldRepaint(covariant EnvelopePainter oldDelegate) {
    return oldDelegate.open != open;
  }
}