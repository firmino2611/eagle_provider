

## Eagle Provider

A simple state management package that uses only ValueNotifier and InheritedWidget.


## Usage

To use it, just create a state class and another to be the state controller.

To create a state class follow the example below:

#### OBS: State class must always extend from StateController.

```dart
// State
class HomeState extends StateController {
  HomeState({this.title, super.status});

  final String? title;

  @override
  copyWith({
    Status? status,
    String? title,
  }) {
    return HomeState(
      status: status ?? this.status,
      title: title ?? this.title,
    );
  }

  @override
  List<Object?> get props => [status, title];
}
```

And to create the controller is simple. The controller must extend from Controller of type StateController:

```dart 
// Controller
class HomeController extends Controller<HomeState> {
  HomeController() : super(HomeState());

  changeStatus() {
    emit(state.copyWith(status: Status.success));
  }
}
```
To inject the dependencies use the ControllerProvider at the top of the widget tree.

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ControllerProvider(
      controllers: [
        HomeController(),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}
```
## Usage of the ControllerBuilder
The ControllerBuilder is a widget that allows you to build your user interface in a reactive way to the states controlled by your application.

You can use the ControllerBuilder by passing your controller as a parameter or, if it is not passed, the widget will search for it in the widget tree using the ControllerProvider.

The widget also calls the [builder] whenever the [buildWhen] condition is met and returns the output of the [builder] as its child. If the [buildWhen] condition is not met, it returns the last output of the [builder].
To update your interface according to state changes, use the following widget:

```dart
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = HomeController();
    Future.delayed(const Duration(seconds: 3)).then(
      (value) {
        controller.changeStatus();
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home page'),
      ),
      body:  ControllerBuilder<HomeController, HomeState>(
        buildWhen: (before, after) {
          return before.status != after.status;
        },
        builder: (BuildContext context, state) {
          if (state.status == Status.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return const Center(
            child: Text('Home completed loading'),
          );
        },
      ),
    );
  }
}
```

### Example

For more questions, run the sample project.

## Additional information

#### This package was inspired by the Cubit Provider, but does not make use of packages in its implementation.
