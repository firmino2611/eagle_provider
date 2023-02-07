// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:eagle_provider/eagle_provider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class HomeState extends StateController {
  final String? name;

  const HomeState({
    super.status,
    this.name,
  });

  @override
  HomeState copyWith({
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

class HomeController extends Controller<HomeState> {
  HomeController(super.value);

  @override
  void onChange(HomeState? previous, HomeState current) {
    print('PREVIOUS ${previous?.name}');
    print('CURRENT ${current.name}');
  }

  setName(String name) {
    emit(value.copyWith(
      name: name,
      status: Status.success,
    ));
  }

  setStatus([Status? status]) {
    emit(value.copyWith(status: status ?? Status.failure));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ControllerProvider(
      controllers: [
        HomeController(
          const HomeState(
            status: Status.loading,
            name: 'Lucas',
          ),
        ),
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var controller = ControllerProvider.of<HomeController>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Eagle Provider',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              controller!.setName('Sabrina');
              controller.setStatus(Status.loading);
            },
            child: const Text('change'),
          ),
        ],
      ),
      body: ControllerConsummer<HomeController, HomeState>(
        listener: (context, state) {
          print('LISTENER ${state.name}');
        },
        listenWhen: (previous, current) {
          return previous.name != current.name;
        },
        buildWhen: (previous, current) {
          return previous.name != current.name ||
              previous.status != current.status;
        },
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Center(
            child: Text(state.name.toString()),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // controller!.setName('Pryscilla');
          controller!.setStatus();
        },
      ),
    );
  }
}
