import 'package:flutter/foundation.dart';
import 'package:easy_rent/features/auth/data/models/user_model.dart';
import 'package:easy_rent/features/auth/data/repositories/mock_auth_repository.dart';
import '../../data/models/faq_item_model.dart';
import '../../data/repositories/mock_profile_repository.dart';

class ProfileController {
  final MockAuthRepository _authRepo = MockAuthRepository.instance;
  final MockProfileRepository _profileRepo = MockProfileRepository.instance;

  final ValueNotifier<UserModel?> user = ValueNotifier<UserModel?>(MockAuthRepository.instance.currentUser);
  final ValueNotifier<List<FaqItemModel>> faqs = ValueNotifier<List<FaqItemModel>>([]);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  Future<void> init() async {
    isLoading.value = true;
    user.value = _authRepo.currentUser;
    faqs.value = await _profileRepo.getFaqs();
    isLoading.value = false;
  }

  Future<void> logout() async {
    await _authRepo.logout();
    user.value = null;
  }

  void dispose() {
    user.dispose();
    faqs.dispose();
    isLoading.dispose();
  }
}
