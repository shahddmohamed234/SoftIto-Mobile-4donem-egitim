import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/state/app_state.dart';
import '../../navigation/app_navigation_scaffold.dart';

class MascotSelectionView extends StatefulWidget {
  final bool isFromRegister;

  const MascotSelectionView({
    super.key,
    this.isFromRegister = false,
  });

  @override
  State<MascotSelectionView> createState() => _MascotSelectionViewState();
}

class _MascotSelectionViewState extends State<MascotSelectionView> {
  late String _currentSelectedId;

  @override
  void initState() {
    super.initState();
    _currentSelectedId = AppState.instance.selectedMascotId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Maskotunu Seç'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildIntroduction(context),
            Expanded(
              child: _buildMascotGrid(context),
            ),
            _buildConfirmationSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroduction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        children: [
          Text(
            'Sana Yol Arkadaşlığı Edecek Kedini Seç',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Seçtiğin kedi her gün hedeflerinde seni izleyecek ve motive edecek!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.black54,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildMascotGrid(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      itemCount: AppConstants.mascots.length,
      itemBuilder: (context, index) {
        final mascot = AppConstants.mascots[index];
        final isSelected = mascot.id == _currentSelectedId;
        return _buildMascotCard(context, mascot, isSelected);
      },
    );
  }

  Widget _buildMascotCard(BuildContext context, CatMascot mascot, bool isSelected) {
    final Color borderColor;
    final double borderWidth;
    if (isSelected) {
      borderColor = Theme.of(context).colorScheme.primary;
      borderWidth = 2.5;
    } else {
      borderColor = Colors.black12;
      borderWidth = 1.0;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentSelectedId = mascot.id;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor, width: borderWidth),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isSelected ? 25 : 8),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildCatAvatar(mascot),
            const SizedBox(width: 14),
            Expanded(child: _buildCatDetails(context, mascot)),
            _buildSelectionCheck(context, isSelected),
          ],
        ),
      ),
    );
  }

  Widget _buildCatAvatar(CatMascot mascot) {
    return Container(
      width: 68,
      height: 68,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFF9F6F0),
      ),
      child: ClipOval(
        child: Image.asset(
          mascot.assetPath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildCatDetails(BuildContext context, CatMascot mascot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mascot.name,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          mascot.personality,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.black54,
              ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withAlpha(25),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '"${mascot.greeting}"',
            style: TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionCheck(BuildContext context, bool isSelected) {
    if (isSelected) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.primary,
        ),
        child: const Icon(Icons.check, color: Colors.white, size: 18),
      );
    } else {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black26, width: 1.5),
        ),
      );
    }
  }

  Widget _buildConfirmationSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _saveSelection,
          child: const Text('Bu Kediyi Seç ve Devam Et'),
        ),
      ),
    );
  }

  void _saveSelection() async {
    await AppState.instance.selectMascot(_currentSelectedId);
    if (mounted) {
      if (widget.isFromRegister) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const AppNavigationScaffold(),
          ),
        );
      } else {
        Navigator.of(context).pop();
      }
    }
  }
}
