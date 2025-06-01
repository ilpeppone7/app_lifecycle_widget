# Lifecycle Widget

The widget provided in this package '**LifecycleWidget**' will emulate the lifecycle of an Activity or ViewController, providing the tools to intercept creation, resuming, pausing and disposing of the widget.

## Platform Support

| Android | iOS | MacOS | Web | Linux | Windows |
|:-------:|:---:|:-----:|:---:|:-----:|:-------:|
|    ✅    |  ✅  |   ?   |  ?  |   ?   |    ?    |

This package has been created for mobile support. Other platform may work, but they didn't have been tested.

## Requirements

- Flutter >=3.10.0
- Dart >=3.0.0

## Setup

Before you can use the **LifecycleWidget**, you have to create a RouteObserver and add it to you MaterialApp.

```dart
final RouteObserver<ModalRoute<dynamic>> routeObserver = RouteObserver<ModalRoute<dynamic>>();

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyApp',
      home: MyPage(),
      navigatorObservers: [
        routeObserver // <--- add it here
      ],
    );
  }
}
```

## Usage

By wrapping your page in the **LifecycleWidget**, you can provide callback function to each event available.

```dart
import 'package:app_lifecycle_widget/app_lifecycle_widget.dart';

...

@override
  Widget build(BuildContext context) {
    return LifecycleWidget(
      onAppPaused: () => _addEvent('onAppPaused'),
      onPaused: () => _addEvent('onPaused'),
      onDispose: () => _addEvent('onDispose'),
      onResumed: () => _addEvent('onResumed'),
      onAppResumed: () => _addEvent('onAppResumed'),
      onCreate: () => _addEvent('onCreate'),
      onResumedFromStack: () => _addEvent('onResumedFromStack'),
      child: Scaffold(...),
    );
  }
```

This widget provides few overlapping methods for handling the resume state, in case you need a more granular management of your widget's lifecycle.

The `onResumed` method will be triggered on each instance of widget resume event, overlapping with the other events:
- when created (overlapping with `onCreate` method);
- when the user comes back from another view (overlapping with `onResumedFromStack` method);
- when the user resumes the app from a background state (overlapping with `onAppResumed` method);
  If you want to handle all resume events singularly, don't define the `onResumed` method.

| Methods            | Description                                                                                                                                                                                                                                                                                                                                                                                                       |
|--------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| onAppPaused        | Will be triggered when the app is sent to background                                                                                                                                                                                                                                                                                                                                                              |
| onAppResumed       | Will be triggered when the app is resumed from background to foreground                                                                                                                                                                                                                                                                                                                                           |
| onCreate           | Will be triggered when the widget is created and pushed in the navigation stack                                                                                                                                                                                                                                                                                                                                   |
| onResumedFromStack | Will be triggered when the widget is resumed and shown after popping another widget                                                                                                                                                                                                                                                                                                                               |
| onResumed          | Will be triggered when the widget is created and pushed in the navigation stack, when the widget is resumed and shown after popping another widget and when the app is resumed from background to foreground. To have a more granular and custom management of this three states, don't use this method to avoid overlapping and define *onCreate*, *onResumedFromStack* and *onAppResumed* methods respectively. |
| onPaused           | Will be triggered when another widget is pushed in front of the current widget                                                                                                                                                                                                                                                                                                                                    |
| onDispose          | Will be triggered when the widget is disposed and removed from the navigation stack                                                                                                                                                                                                                                                                                                                               |