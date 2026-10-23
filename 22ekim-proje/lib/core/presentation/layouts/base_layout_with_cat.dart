import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BaseLayoutWithCat extends StatefulWidget {
  final Widget child;
  final Alignment catAlignment;
  final String catAsset;
  final String? catLottieAsset;
  final String? message;
  final VoidCallback? onCatTap;

  const BaseLayoutWithCat({
    super.key,
    required this.child,
    this.catAlignment = Alignment.bottomRight,
    this.catAsset = 'assets/images/cat_pamuk.png',
    this.catLottieAsset,
    this.message,
    this.onCatTap,
  });

  @override
  State<BaseLayoutWithCat> createState() => _BaseLayoutWithCatState();
}

class _BaseLayoutWithCatState extends State<BaseLayoutWithCat>
    with TickerProviderStateMixin {
  late final AnimationController _idleController;
  late final AnimationController _tapController;
  late final Animation<double> _bounceAnimation;
  late final Animation<double> _tapBounceAnimation;

  bool _isBubbleVisible = true;
  Timer? _bubbleDismissTimer;

  @override
  void initState() {
    super.initState();

    // Idle gentle floating animation
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0.0, end: -6.0).animate(
      CurvedAnimation(
        parent: _idleController,
        curve: Curves.easeInOutSine,
      ),
    );

    // Tap happy jump animation
    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _tapBounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: -16.0), weight: 40),
      TweenSequenceItem(tween: Tween<double>(begin: -16.0, end: 0.0), weight: 60),
    ]).animate(CurvedAnimation(parent: _tapController, curve: Curves.easeOutQuad));

    _startBubbleTimer();
  }

  void _startBubbleTimer() {
    _bubbleDismissTimer?.cancel();
    if (widget.message != null && widget.message!.isNotEmpty) {
      _isBubbleVisible = true;
      _bubbleDismissTimer = Timer(const Duration(milliseconds: 4500), () {
        if (mounted) {
          setState(() {
            _isBubbleVisible = false;
          });
        }
      });
    }
  }

  void _handleCatTap() {
    _tapController.forward(from: 0.0);
    setState(() {
      _isBubbleVisible = !_isBubbleVisible;
    });
    if (_isBubbleVisible) {
      _startBubbleTimer();
    }
    if (widget.onCatTap != null) {
      widget.onCatTap!();
    }
  }

  @override
  void didUpdateWidget(covariant BaseLayoutWithCat oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.message != widget.message) {
      setState(() {
        _isBubbleVisible = true;
      });
      _startBubbleTimer();
    }
  }

  @override
  void dispose() {
    _bubbleDismissTimer?.cancel();
    _idleController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          widget.child,
          _buildInteractiveCatOverlay(),
        ],
      ),
    );
  }

  Widget _buildInteractiveCatOverlay() {
    return Align(
      alignment: widget.catAlignment,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 12.0, bottom: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildSpeechBubble(),
              const SizedBox(height: 4),
              _buildAnimatedCatFigure(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpeechBubble() {
    final hasMessage = widget.message != null && widget.message!.isNotEmpty;
    if (!hasMessage) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedOpacity(
      opacity: _isBubbleVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      child: IgnorePointer(
        ignoring: !_isBubbleVisible,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _isBubbleVisible = false;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(right: 8, bottom: 2),
            constraints: const BoxConstraints(maxWidth: 220),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2C2E38) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withAlpha(120),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(isDark ? 50 : 25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    widget.message!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFFEDE9E3) : const Color(0xFF3A3A3A),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.close,
                  size: 14,
                  color: isDark ? Colors.white54 : Colors.black38,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCatFigure() {
    return GestureDetector(
      onTap: _handleCatTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_idleController, _tapController]),
        builder: (context, child) {
          final totalBounce = _bounceAnimation.value + _tapBounceAnimation.value;
          return Transform.translate(
            offset: Offset(0, totalBounce),
            child: child,
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Real animated character via Lottie
            SizedBox(
              width: 100,
              height: 100,
              child: widget.catLottieAsset != null
                  ? Lottie.asset(
                      widget.catLottieAsset!,
                      fit: BoxFit.contain,
                      repeat: true,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(widget.catAsset, fit: BoxFit.contain);
                      },
                    )
                  : Image.asset(widget.catAsset, fit: BoxFit.contain),
            ),
            // Subtle grounding shadow
            Container(
              width: 50,
              height: 6,
              margin: const EdgeInsets.only(top: 1),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(25),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
