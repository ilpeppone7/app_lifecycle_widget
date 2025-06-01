import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

/// This widget will emulate the lifecycle of an Activity or ViewController, providing the tools to intercept creation,
/// resuming, pausing and disposing of the widget.
///
/// This widget provides few overlapping methods for handling the resume state, in case you need a more granular
/// management of your widget's lifecycle.
/// The [onResumed] method will be triggered on each instance of widget resume event, overlapping with the other events:
/// - when created (overlapping with [onCreate] method);
/// - when the user comes back from another view (overlapping with [onResumedFromStack] method);
/// - when the user resumes the app from a background state (overlapping with [onAppResumed] method);
/// If you want to handle all resume events singularly, don't define the [onResumed] method.
class LifecycleWidget extends StatefulWidget {
  const LifecycleWidget({
    required this.child,
    this.onAppPaused,
    this.onAppResumed,
    this.onCreate,
    this.onResumed,
    this.onResumedFromStack,
    this.onPaused,
    this.onDispose,
    super.key,
  });

  final Widget child;

  /// Will be triggered when the app is sent to background
  final VoidCallback? onAppPaused;

  /// Will be triggered when the app is resumed from background to foreground
  final VoidCallback? onAppResumed;

  /// Will be triggered when the widget is created and pushed in the navigation stack
  final VoidCallback? onCreate;

  /// Will be triggered when the widget is resumed and shown after popping another widget
  final VoidCallback? onResumedFromStack;

  /// Will be triggered when the widget is created and pushed in the navigation stack, when the widget is resumed and
  /// shown after popping another widget and when the app is resumed from background to foreground. To have a more
  /// granular and custom management of this three states, don't use this method to avoid overlapping and define
  /// [onCreate], [onResumedFromStack] and [onAppResumed] methods respectively.
  final VoidCallback? onResumed;

  /// Will be triggered when another widget is pushed in front of the current widget
  final VoidCallback? onPaused;

  /// Will be triggered when the widget is disposed and removed from the navigation stack
  final VoidCallback? onDispose;

  @override
  State<LifecycleWidget> createState() => _LifecycleWidgetState();
}

class _LifecycleWidgetState extends State<LifecycleWidget>
    with RouteAware, WidgetsBindingObserver {
  /// it's nullable because possible future nested navigation flows may not define a route observer
  RouteObserver? _routeObserver;

  /// Guard flag to avoid subscribing multiple times to [WidgetsBinding] lifecycle
  bool _isObserverRegistered = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      _subscribe();

      final currentNavigatorObservers = Navigator.of(context).widget.observers;
      final routeObserver = currentNavigatorObservers.firstWhereOrNull(
        (it) => it is RouteObserver,
      );
      if (routeObserver != null) {
        _routeObserver = routeObserver as RouteObserver;
        routeObserver.subscribe(this, ModalRoute.of(context)!);
      }
    });
    super.initState();
  }

  void _subscribe() {
    if (!_isObserverRegistered) {
      WidgetsBinding.instance.addObserver(this);
      _isObserverRegistered = true;
    }
  }

  void _unsubscribe() {
    if (_isObserverRegistered) {
      WidgetsBinding.instance.removeObserver(this);
      _isObserverRegistered = false;
    }
  }

  /// Called when the current route has been pushed.
  @override
  void didPush() {
    _subscribe();
    widget.onCreate?.call();
    widget.onResumed?.call();
    super.didPush();
  }

  /// Called when the current route has been popped off.
  @override
  void didPop() {
    _unsubscribe();
    widget.onPaused?.call();
    super.didPop();
  }

  /// Called when the top route has been popped off, and the current route
  /// shows up.
  @override
  void didPopNext() {
    _subscribe();
    widget.onResumedFromStack?.call();
    widget.onResumed?.call();
    super.didPopNext();
  }

  /// Called when a new route has been pushed, and the current route is no
  /// longer visible.
  @override
  void didPushNext() {
    _unsubscribe();
    widget.onPaused?.call();
    super.didPushNext();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      widget.onAppResumed?.call();
      widget.onResumed?.call();
    } else if (state == AppLifecycleState.paused) {
      widget.onAppPaused?.call();
      widget.onPaused?.call();
    }
  }

  @override
  void dispose() {
    widget.onDispose?.call();
    _unsubscribe();
    _routeObserver?.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
