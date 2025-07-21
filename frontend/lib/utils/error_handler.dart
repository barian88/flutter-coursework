import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../apis/apis.dart';

class ErrorHandler {
  static String getErrorMessage(Object error) {
    if (error is AppException) {
      return error.message;
    }
    
    if (error is NetworkException) {
      return '网络连接失败，请检查网络连接';
    }
    
    if (error is ServerException) {
      switch (error.statusCode) {
        case 404:
          return '请求的资源不存在';
        case 500:
          return '服务器内部错误，请稍后重试';
        case 503:
          return '服务暂时不可用，请稍后重试';
        default:
          return error.message;
      }
    }
    
    if (error is ValidationException) {
      return error.message;
    }
    
    if (error is AuthException) {
      return error.message;
    }
    
    return '发生未知错误，请稍后重试';
  }

  static void showErrorSnackBar(BuildContext context, Object error) {
    final message = getErrorMessage(error);
    final colorScheme = Theme.of(context).colorScheme;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colorScheme.error,
        action: SnackBarAction(
          label: '关闭',
          textColor: colorScheme.onError,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  static void showErrorDialog(BuildContext context, Object error) {
    final message = getErrorMessage(error);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('错误'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  static Widget buildErrorWidget(Object error, {VoidCallback? onRetry, BuildContext? context}) {
    final message = getErrorMessage(error);
    
    return Builder(
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: onRetry,
                  child: const Text('重试'),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

// 扩展方法，方便在Widget中使用
extension AsyncValueErrorHandling<T> on AsyncValue<T> {
  Widget buildErrorWidget({VoidCallback? onRetry}) {
    return when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => ErrorHandler.buildErrorWidget(error, onRetry: onRetry),
      data: (data) => const SizedBox.shrink(),
    );
  }
}