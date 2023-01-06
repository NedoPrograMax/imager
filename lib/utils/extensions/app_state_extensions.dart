import 'package:imager/bloc/app_state.dart';
import 'package:imager/models/exception/exception.dart';

// transforms given appState to the same type but with different parameters(optional)
extension Transform on AppState {
  AppState transform({bool? newIsLoading, GenericException? newException}) {
    final state = this;
    if (this is AppStateAuth) {
      return AppStateAuth(
        isLoading: newIsLoading ?? isLoading,
        exception: newException ?? exception,
      );
    }
    if (state is AppStateMain) {
      return AppStateMain(
        isLoading: newIsLoading ?? isLoading,
        exception: newException ?? exception,
      //  images: state.images,
      );
    }
    return AppState.initial();
  }
}
