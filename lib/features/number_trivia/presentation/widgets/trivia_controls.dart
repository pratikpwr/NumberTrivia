import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numtrivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:numtrivia/features/number_trivia/presentation/widgets/widgets.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({Key? key}) : super(key: key);

  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          onSubmitted: (_) {
            _dispatchConcrete();
          },
          decoration: InputDecoration(
              hintText: 'Input a number!',
              border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1.5),
                  borderRadius: BorderRadius.circular(10))),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
                child: CustomButton(title: 'Search', onTap: _dispatchConcrete)),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: CustomButton(
                  title: 'Get Random Trivia', onTap: _dispatchRandom),
            ),
          ],
        ),
      ],
    );
  }

  void _dispatchConcrete() {
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(controller.text));
    controller.clear();
  }

  void _dispatchRandom() {
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
    controller.clear();
  }
}
