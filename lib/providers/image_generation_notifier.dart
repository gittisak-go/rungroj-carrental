import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/aiIntegrations/image_generation_service.dart';

class ImageGenerationConfig {
  final String provider;
  final String model;

  const ImageGenerationConfig({required this.provider, required this.model});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageGenerationConfig &&
          provider == other.provider &&
          model == other.model;

  @override
  int get hashCode => provider.hashCode ^ model.hashCode;
}

class ImageGenerationState {
  final Map<String, dynamic>? image;
  final bool isLoading;
  final Exception? error;

  const ImageGenerationState({this.image, this.isLoading = false, this.error});

  ImageGenerationState copyWith({
    Map<String, dynamic>? image,
    bool? isLoading,
    Exception? error,
    bool clearError = false,
    bool clearImage = false,
  }) {
    return ImageGenerationState(
      image: clearImage ? null : (image ?? this.image),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class ImageGenerationNotifier extends Notifier<ImageGenerationState> {
  late final ImageGenerationConfig config;

  @override
  ImageGenerationState build() => const ImageGenerationState();

  void setConfig(ImageGenerationConfig config) {
    this.config = config;
  }

  Future<Map<String, dynamic>?> generate(
    String prompt, {
    Map<String, dynamic> parameters = const {},
  }) async {
    state = const ImageGenerationState(isLoading: true);
    try {
      final result = await generateImage(
        config.provider,
        config.model,
        prompt,
        parameters: parameters,
      );
      state = ImageGenerationState(image: result, isLoading: false);
      return result;
    } catch (error) {
      state = ImageGenerationState(
        error: error is Exception ? error : Exception(error.toString()),
        isLoading: false,
      );
      return null;
    }
  }

  void clearImage() => state = const ImageGenerationState();
}

final imageGenerationNotifierProvider =
    NotifierProvider<ImageGenerationNotifier, ImageGenerationState>(ImageGenerationNotifier.new);