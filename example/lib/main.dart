import 'package:eagle_provider/eagle_provider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ControllerProvider(
      controllers: [HomeController()],
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

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = ControllerProvider.of<HomeController>();
    Future.delayed(const Duration(seconds: 3)).then(
      (value) {
        controller.changeStatus();
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home page'),
      ),
      body: ControllerBuilder<HomeController, HomeState>(
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

// State
class HomeState extends StateController {
  HomeState({super.status});

  @override
  copyWith({
    Status? status,
  }) {
    return HomeState(
      status: status ?? this.status,
    );
  }
}

// Controller
class HomeController extends Controller<HomeState> {
  HomeController() : super(HomeState());

  changeStatus() {
    emit(state.copyWith(status: Status.success));
  }
}
