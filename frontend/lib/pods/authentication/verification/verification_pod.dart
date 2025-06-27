import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'verification_pod.g.dart';

@riverpod
class VerificationNotifier extends _$VerificationNotifier {
  final _verificationNotifierModel = VerificationNotifierModel();

  @override
  VerificationNotifierModel build() {
    return _verificationNotifierModel;
  }

  void update({
    String? verificationCode,
  }) {
    state = state.copyWith(
      verificationCode: verificationCode,
    );
  }

}

class VerificationNotifierModel {
  final String verificationCode;

  VerificationNotifierModel({
    this.verificationCode = '',
  });

  VerificationNotifierModel copyWith({
    String? verificationCode,
  }) {
    return VerificationNotifierModel(
      verificationCode: verificationCode ?? this.verificationCode,
    );
  }
}