import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../authentication.dart';

final class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});
  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

final class _SignInPageState extends ConsumerState<SignInPage> {
  final _pinController = TextEditingController();
  String _selectedUser = 'USER_1';

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(authenticationControllerProvider);
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) => Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.lock_person, size: 64),
                    const SizedBox(height: 16),
                    Text(
                      'English Acquisition',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Private two-user Windows learning application',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedUser,
                      decoration: const InputDecoration(
                        labelText: 'Local profile',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'USER_1',
                          child: Text('USER_1 • Furkan'),
                        ),
                        DropdownMenuItem(
                          value: 'USER_2',
                          child: Text('USER_2 • Learner 2'),
                        ),
                      ],
                      onChanged: controller.isBusy
                          ? null
                          : (value) => setState(
                              () => _selectedUser = value ?? 'USER_1',
                            ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _pinController,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Six-digit PIN',
                        helperText:
                            'First sign-in creates a separate PIN for this profile.',
                      ),
                      onSubmitted: controller.isBusy
                          ? null
                          : (_) => _submit(controller),
                    ),
                    if (controller.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          controller.errorMessage!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: controller.isBusy
                          ? null
                          : () => _submit(controller),
                      icon: const Icon(Icons.login),
                      label: Text(
                        controller.isBusy
                            ? 'Checking locally...'
                            : 'Unlock profile',
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Five incorrect attempts lock only the selected profile for five minutes. PIN hashes are stored in Windows secure storage.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit(AuthenticationController controller) =>
      controller.signIn(password: _pinController.text, userName: _selectedUser);
}
