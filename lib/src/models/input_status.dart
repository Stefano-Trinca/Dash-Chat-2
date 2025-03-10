part of '../../../dash_chat_2.dart';

enum InputStatus {
  none,
  error,
  loading,
  success;

  bool get isNone => this == InputStatus.none;
  bool get isError => this == InputStatus.error;
  bool get isLoading => this == InputStatus.loading;
  bool get isSuccess => this == InputStatus.success;
}
