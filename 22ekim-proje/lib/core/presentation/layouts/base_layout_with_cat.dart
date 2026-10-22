import 'package:flutter/material.dart';

class BaseLayoutWithCat extends StatefulWidget {
  final Widget child;
  final Alignment catAlignment;
  final String catAsset;
  final String? message;
  final VoidCallback? onCatTap;

  const BaseLayoutWithCat({
    super.key,
    required this.child,
    this.catAlignment = Alignment.bottomRight,
    this.catAsset = 'assets/images/cat_pamuk.png',
    this.message,
    this.onCatTap,
  });

  @override
  State<BaseLayoutWithCat> createState() => _BaseLayoutWithCatState();
}

class _BaseLayoutWithCatState extends State<BaseLayoutWithCat>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0.0, end: -8.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          widget.child,
          _buildCatAnimation(),
        ],
      ),
    );
  }

  Widget _buildCatAnimation() {
    return Align(
      alignment: widget.catAlignment,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: AnimatedBuilder(
            animation: _bounceAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _bounceAnimation.value),
                child: child,
              );
            },
            child: _buildCatBubble(),
          ),
        ),
      ),
    );
  }

  Widget _buildCatBubble() {
    return GestureDetector(
      onTap: widget.onCatTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildSpeechBubble(),
          const SizedBox(height: 4),
          _buildCatImageContainer(),
        ],
      ),
    );
  }

  Widget _buildSpeechBubble() {
    if (widget.message != null && widget.message!.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.only(right: 6, bottom: 2),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withAlpha(80),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          widget.message!,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildCatImageContainer() {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          widget.catAsset,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.pets, color: Colors.grey);
          },
        ),
      ),
    );
  }
}
