import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MoodTrackerApp());
}

class MoodTrackerApp extends StatelessWidget {
  const MoodTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mourad Mood Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SF Pro Display',
        scaffoldBackgroundColor: const Color(0xFF0f0f1e),
      ),
      home: const MoodHomePage(),
    );
  }
}

enum MoodType { happy, neutral, sad, angry, excited }

class MoodEntry {
  final MoodType mood;
  final DateTime timestamp;
  MoodEntry({required this.mood, required this.timestamp});
}

class MoodHomePage extends StatefulWidget {
  const MoodHomePage({super.key});

  @override
  State<MoodHomePage> createState() => _MoodHomePageState();
}

class _MoodHomePageState extends State<MoodHomePage> {
  final List<MoodEntry> _entries = [];
  int? _flippingIndex;

  void _logMood(MoodType mood) {
    setState(() {
      _entries.insert(0, MoodEntry(mood: mood, timestamp: DateTime.now()));
      if (_entries.length > 7) _entries.removeLast();
    });
  }

  void _triggerFlip(int index) {
    setState(() => _flippingIndex = index);
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _flippingIndex = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 32),
              // LEGO TITLE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _LegoTitle(),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tap a brick · log your mood',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white38,
                  letterSpacing: 1.8,
                ),
              ),
              const SizedBox(height: 40),
              // MOOD SELECTOR
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: MoodType.values.map((mood) {
                    return GestureDetector(
                      onTap: () => _logMood(mood),
                      child: _LegoMoodBrick(mood: mood),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 48),
              // TIMELINE LABEL
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    _legoBadge('PAST 7 ENTRIES'),
                    const SizedBox(width: 10),
                    Text(
                      '${_entries.length}/7',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // TIMELINE
              SizedBox(
                height: 200,
                child: _entries.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.mood, color: Colors.white12, size: 40),
                            const SizedBox(height: 8),
                            const Text(
                              'No entries yet',
                              style: TextStyle(
                                color: Colors.white24,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _entries.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => _triggerFlip(index),
                            child: _FlipCard(
                              entry: _entries[index],
                              isFlipping: _flippingIndex == index,
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _legoBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD700),
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFB8860B),
            offset: Offset(0, 3),
            blurRadius: 0,
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          color: Color(0xFF1a1a2e),
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

// ── LEGO TITLE ─────────────────────────────────────────────────
class _LegoTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const letters = ['M', 'O', 'U', 'R', 'A', 'D'];
    const colors = [
      Color(0xFFFF3B30),
      Color(0xFFFFD700),
      Color(0xFF34C759),
      Color(0xFF007AFF),
      Color(0xFFFF9500),
      Color(0xFFAF52DE),
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(letters.length, (i) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: _LegoBrick(letter: letters[i], color: colors[i]),
            );
          }),
        ),
        const SizedBox(height: 8),
        const Text(
          'MOOD TRACKER',
          style: TextStyle(
            fontSize: 11,
            color: Colors.white38,
            letterSpacing: 4,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ── SINGLE LEGO LETTER BRICK ───────────────────────────────────
class _LegoBrick extends StatelessWidget {
  final String letter;
  final Color color;

  const _LegoBrick({required this.letter, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 48,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: _darken(color, 0.35),
            offset: const Offset(0, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Stud on top
          Positioned(
            top: -6,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 18,
                height: 12,
                decoration: BoxDecoration(
                  color: _lighten(color, 0.1),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: _darken(color, 0.2),
                      offset: const Offset(0, 2),
                      blurRadius: 0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Letter
          Center(
            child: Text(
              letter,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                shadows: [Shadow(color: Colors.black26, offset: Offset(0, 2))],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── LEGO MOOD BRICK (selector) ─────────────────────────────────
class _LegoMoodBrick extends StatelessWidget {
  final MoodType mood;
  const _LegoMoodBrick({required this.mood});

  @override
  Widget build(BuildContext context) {
    final color = moodColor(mood);
    return Column(
      children: [
        Container(
          width: 58,
          height: 64,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: _darken(color, 0.4),
                offset: const Offset(0, 5),
                blurRadius: 0,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Stud
              Positioned(
                top: -7,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 22,
                    height: 14,
                    decoration: BoxDecoration(
                      color: _lighten(color, 0.1),
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: _darken(color, 0.25),
                          offset: const Offset(0, 3),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Face
              Center(
                child: CustomPaint(
                  size: const Size(40, 40),
                  painter: MoodPainter(mood: mood),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          moodLabel(mood),
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white54,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

// ── FLIP CARD ──────────────────────────────────────────────────
class _FlipCard extends StatefulWidget {
  final MoodEntry entry;
  final bool isFlipping;

  const _FlipCard({required this.entry, required this.isFlipping});

  @override
  State<_FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<_FlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(_FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipping && !oldWidget.isFlipping) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = moodColor(widget.entry.mood);
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final angle = _animation.value * pi;
        final isBack = angle > pi / 2;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          child: isBack
              ? Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(pi),
                  child: _cardBack(color),
                )
              : _cardFront(color),
        );
      },
    );
  }

  Widget _cardFront(Color color) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF16213e),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Mini lego stud row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) => _miniStud(color)),
          ),
          const SizedBox(height: 8),
          CustomPaint(
            size: const Size(52, 52),
            painter: MoodPainter(mood: widget.entry.mood),
          ),
          const SizedBox(height: 10),
          Text(
            moodLabel(widget.entry.mood),
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatTime(widget.entry.timestamp),
            style: const TextStyle(fontSize: 9, color: Colors.white24),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _cardBack(Color color) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: _darken(color, 0.3),
            offset: const Offset(0, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Center(
        child: Text(
          moodEmoji(widget.entry.mood),
          style: const TextStyle(fontSize: 36),
        ),
      ),
    );
  }

  Widget _miniStud(Color color) {
    return Container(
      width: 10,
      height: 6,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: _lighten(color, 0.15),
        borderRadius: BorderRadius.circular(3),
        boxShadow: [
          BoxShadow(
            color: _darken(color, 0.3),
            offset: const Offset(0, 2),
            blurRadius: 0,
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final min = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '${dt.month}/${dt.day} $hour:$min $period';
  }
}

// ── MOOD PAINTER ───────────────────────────────────────────────
class MoodPainter extends CustomPainter {
  final MoodType mood;
  const MoodPainter({required this.mood});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.44;

    final facePaint = Paint()..color = Colors.white.withOpacity(0.15);
    canvas.drawCircle(Offset(cx, cy), r, facePaint);

    final feature = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final stroke = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.2;

    switch (mood) {
      case MoodType.happy:
        _drawEyes(canvas, cx, cy, r, feature);
        _drawArc(canvas, cx, cy, r, stroke, flip: false);
        break;
      case MoodType.neutral:
        _drawEyes(canvas, cx, cy, r, feature);
        _drawLine(canvas, cx, cy, r, stroke);
        break;
      case MoodType.sad:
        _drawEyes(canvas, cx, cy, r, feature);
        _drawArc(canvas, cx, cy, r, stroke, flip: true);
        _drawSadBrows(canvas, cx, cy, r, stroke);
        break;
      case MoodType.angry:
        _drawEyes(canvas, cx, cy, r, feature);
        _drawArc(canvas, cx, cy, r, stroke, flip: true);
        _drawAngryBrows(canvas, cx, cy, r, stroke);
        break;
      case MoodType.excited:
        _drawWideEyes(canvas, cx, cy, r, feature, stroke);
        _drawArc(canvas, cx, cy, r, stroke, flip: false, wide: true);
        break;
    }
  }

  void _drawEyes(Canvas canvas, double cx, double cy, double r, Paint p) {
    canvas.drawCircle(Offset(cx - r * 0.3, cy - r * 0.15), r * 0.1, p);
    canvas.drawCircle(Offset(cx + r * 0.3, cy - r * 0.15), r * 0.1, p);
  }

  void _drawWideEyes(
    Canvas canvas,
    double cx,
    double cy,
    double r,
    Paint fill,
    Paint stroke,
  ) {
    canvas.drawCircle(Offset(cx - r * 0.3, cy - r * 0.15), r * 0.15, fill);
    canvas.drawCircle(Offset(cx + r * 0.3, cy - r * 0.15), r * 0.15, fill);
  }

  void _drawArc(
    Canvas canvas,
    double cx,
    double cy,
    double r,
    Paint p, {
    required bool flip,
    bool wide = false,
  }) {
    final w = wide ? r * 0.9 : r * 0.65;
    final rect = Rect.fromCenter(
      center: Offset(cx, cy + r * 0.18),
      width: w,
      height: r * 0.4,
    );
    canvas.drawArc(rect, flip ? 0 : pi, pi, false, p);
  }

  void _drawLine(Canvas canvas, double cx, double cy, double r, Paint p) {
    canvas.drawLine(
      Offset(cx - r * 0.35, cy + r * 0.25),
      Offset(cx + r * 0.35, cy + r * 0.25),
      p,
    );
  }

  void _drawAngryBrows(Canvas canvas, double cx, double cy, double r, Paint p) {
    final path1 = Path()
      ..moveTo(cx - r * 0.45, cy - r * 0.42)
      ..lineTo(cx - r * 0.15, cy - r * 0.32);
    canvas.drawPath(path1, p);
    final path2 = Path()
      ..moveTo(cx + r * 0.45, cy - r * 0.42)
      ..lineTo(cx + r * 0.15, cy - r * 0.32);
    canvas.drawPath(path2, p);
  }

  void _drawSadBrows(Canvas canvas, double cx, double cy, double r, Paint p) {
    final path1 = Path()
      ..moveTo(cx - r * 0.45, cy - r * 0.32)
      ..lineTo(cx - r * 0.15, cy - r * 0.42);
    canvas.drawPath(path1, p);
    final path2 = Path()
      ..moveTo(cx + r * 0.45, cy - r * 0.32)
      ..lineTo(cx + r * 0.15, cy - r * 0.42);
    canvas.drawPath(path2, p);
  }

  @override
  bool shouldRepaint(MoodPainter old) => old.mood != mood;
}

// ── HELPERS ────────────────────────────────────────────────────
Color moodColor(MoodType mood) {
  switch (mood) {
    case MoodType.happy:
      return const Color(0xFFFFD700);
    case MoodType.neutral:
      return const Color(0xFF90A4AE);
    case MoodType.sad:
      return const Color(0xFF5C6BC0);
    case MoodType.angry:
      return const Color(0xFFEF5350);
    case MoodType.excited:
      return const Color(0xFF66BB6A);
  }
}

String moodLabel(MoodType mood) {
  switch (mood) {
    case MoodType.happy:
      return 'HAPPY';
    case MoodType.neutral:
      return 'NEUTRAL';
    case MoodType.sad:
      return 'SAD';
    case MoodType.angry:
      return 'ANGRY';
    case MoodType.excited:
      return 'EXCITED';
  }
}

String moodEmoji(MoodType mood) {
  switch (mood) {
    case MoodType.happy:
      return '😄';
    case MoodType.neutral:
      return '😐';
    case MoodType.sad:
      return '😢';
    case MoodType.angry:
      return '😡';
    case MoodType.excited:
      return '🤩';
  }
}

Color _darken(Color color, double amount) {
  final hsl = HSLColor.fromColor(color);
  return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
}

Color _lighten(Color color, double amount) {
  final hsl = HSLColor.fromColor(color);
  return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
}
