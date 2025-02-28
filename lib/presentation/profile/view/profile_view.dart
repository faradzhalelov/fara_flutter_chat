
import 'package:fara_chat/app/theme/colors.dart';
import 'package:fara_chat/app/theme/icons.dart';
import 'package:fara_chat/app/theme/text_styles.dart';
import 'package:fara_chat/presentation/auth/view/components/auth_widgets.dart';
import 'package:fara_chat/presentation/profile/view_model/profile_view_model.dart';
import 'package:fara_chat/providers/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

//todo:
class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});
  static const String routePath = 'profile';

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {


  @override
  Widget build(BuildContext context) {
    final asyncProfile = ref.watch(userProfileProvider);
    final viewModel = ref.read(profileViewModelProvider.notifier);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.appBackground,
          title: const Text('Профиль'),
          leading: IconButton(
          icon: const Icon(Icomoon.arrowLeftS, color: Colors.black),
          onPressed: () => context.pop(),
        ),
          actions: [
            IconButton(
              icon: const Icon(Icomoon.outRight, size: 24, color: AppColors.black,),
              onPressed: () async => viewModel.signOut(context),
              tooltip: 'Выйти',
            ),
          ],
        ),
        body: asyncProfile.when(
            data: (profile) => SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.black,
                        backgroundImage: profile.avatarUrl != null
                                ? NetworkImage(profile.avatarUrl!)
                                : null,
                        child: profile.avatarUrl == null
                            ? Text(
                                ref
                                    .read(profileViewModelProvider
                                        .notifier,)
                                    .getInitials(
                                      profile.username,
                                    ),
                                style: AppTextStyles.largeTitle
                                    .copyWith(color: Colors.white),
                              )
                            : null,
                      ),
                      const SizedBox(height: 24),
                  
                      // Email display
                      Text(
                        profile.email,
                        style:
                            AppTextStyles.medium.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 32),
                  
                      // Username field
                      AuthTextField(
                        enabled: false,
                        labelText: profile.username,
                        prefixIcon: Icons.person_outline,
                        validator: viewModel.validateUsername,
                      ),
                    ],
                  ),
                ),
            error: (e, s) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Ошибка загрузки профиля',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => ref.refresh(userProfileProvider),
                        child: const Text('Попробовать снова'),
                      ),
                    ],
                  ),
                ),
              ),
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),),);
  }
}
