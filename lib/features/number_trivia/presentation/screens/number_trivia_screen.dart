import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/widgets.dart';
import '../bloc/number_trivia_bloc.dart';
import 'package:numtrivia/injection_container.dart';

class NumberTriviaScreen extends StatefulWidget {
  const NumberTriviaScreen({Key? key}) : super(key: key);

  @override
  _NumberTriviaScreenState createState() => _NumberTriviaScreenState();
}

class _NumberTriviaScreenState extends State<NumberTriviaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: SingleChildScrollView(
          child: BlocProvider<NumberTriviaBloc>(
        create: (ctx) => sl<NumberTriviaBloc>(),
        child: Center(
            child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                        builder: (context, state) {
                      if (state is Empty) {
                        return const MessageWidget(title: 'Start Searching!');
                      } else if (state is Loading) {
                        return const LoadingWidget();
                      } else if (state is Success) {
                        return TriviaWidget(trivia: state.trivia);
                      } else if (state is Error) {
                        return MessageWidget(title: state.message);
                      }
                      return SizedBox(
                        height: MediaQuery.of(context).size.height / 3,
                        child: const Placeholder(),
                      );
                    }),
                    const SizedBox(height: 16),
                    BlocProvider<NumberTriviaBloc>(
                        create: (ctx) => sl<NumberTriviaBloc>(),
                        child: const TriviaControls())
                  ],
                ))),
      )),
    );
  }
}
