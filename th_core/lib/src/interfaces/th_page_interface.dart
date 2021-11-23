
///abstract [THModule] class used to handling common events of a page
abstract class THPageInterface {
  ///Pop the current route off
  void dismiss();
  ///Show loading
  void showLoading({String message});
  ///Show error
  void showError({String title, String message});
  ///Dismiss the on screen keyboard
  void unFocus();
}
