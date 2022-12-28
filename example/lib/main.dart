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
    var controller = ControllerProvider.of<HomeController>(context);

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            debugPrint(controller.state.toString());
          },
          child: const Text('Home page'),
        ),
      ),
      body: ControllerConsumer<HomeController, HomeState>(
        builderWhen: (before, after) {
          return before.name != after.name;
        },
        // child: const Center(child: CircularProgressIndicator()),
        listenWhen: (before, after) {},
        builder: (context, state) {
          debugPrint(state.toString());
          if (state.status == Status.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Center(
            child: GestureDetector(
              onTap: () {
                controller.changeName('lucas', Status.loading);
              },
              child: Text('Status ${state.status}, name: ${state.name}'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.changeName('firmino', Status.success);
        },
      ),
    );
  }
}

// State
class HomeState extends StateController {
  const HomeState({super.status, this.name});

  final String? name;

  @override
  copyWith({
    Status? status,
    String? name,
  }) {
    return HomeState(
      status: status ?? this.status,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [status, name];
}

// Controller
class HomeController extends Controller<HomeState> {
  HomeController() : super(const HomeState());

  changeStatus([Status? status]) {
    emit(state.copyWith(status: status ?? Status.success));
  }

  changeName(String name, Status status) {
    emit(state.copyWith(name: name, status: status));
  }
}
