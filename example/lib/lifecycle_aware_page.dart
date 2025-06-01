import 'package:example/utils.dart';
import 'package:flutter/material.dart';
import 'package:lifecycle_widget/lifecycle_widget.dart';

class LifecycleAwarePage extends StatefulWidget {
  LifecycleAwarePage({super.key}) {
    pageColor = randomColor();
  }

  late final Color pageColor;

  @override
  State<LifecycleAwarePage> createState() => _LifecycleAwarePageState();
}

class _LifecycleAwarePageState extends State<LifecycleAwarePage> {
  final List<String> _events = [];
  static bool _granularMode = false;

  void _addEvent(String event) => setState(() {
    _events.add(event);
  });

  void _switchGranularMode() => setState(() {
    _granularMode = !_granularMode;
  });

  @override
  Widget build(BuildContext context) {
    return LifecycleWidget(
      onAppPaused: () => _addEvent('onAppPaused'),
      onPaused: () => _addEvent('onPaused'),
      onDispose: () => _addEvent('onDispose'),
      onResumed: _granularMode ? null : () => _addEvent('onResumed'),
      onAppResumed: _granularMode ? () => _addEvent('onAppResumed') : null,
      onCreate: _granularMode ? () => _addEvent('onCreate') : null,
      onResumedFromStack: _granularMode ? () => _addEvent('onResumedFromStack') : null,
      child: Theme(
        data: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: widget.pageColor)),
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _events.clear();
                  });
                },
                icon: Icon(Icons.delete),
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Granular mode: ${_granularMode ? 'ENABLED' : 'DISABLED'}\nTap the button enable/disable granular mode (use onAppResumed, onCreate and onResumedFromStack instead of onResume)',
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _switchGranularMode,
                    child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [Text('Switch granular mode')]),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) => Text(_events[index], textAlign: TextAlign.center),
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      itemCount: _events.length,
                      shrinkWrap: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => LifecycleAwarePage()));
                      },
                      child: Text("Go to next page"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
