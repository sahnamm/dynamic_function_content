import 'package:dart_eval/stdlib/core.dart';
import 'package:flutter/material.dart';
import 'package:dart_eval/dart_eval.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dart Eval Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Dart Eval Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final originalSource = '''
      import 'dart:math';

      String sayGood(){
          //only can update this
          return 'Good!'; 
      }

      String sayHelloTo(String name) {
           //only can update this
          return 'Hello \$name!!';
      }

      int multipleBy10(int a) {
          //only can update this
          return a * 10; 
      }

      double multipleV1(double a, double b) {
          //only can update this
          return a * b; 
      }

      dynamic multipleV2(double a, int b) {
          //only can update this
          return a + b;
      }
  ''';

  String source = '';

  TextEditingController inputTEC = TextEditingController();

  TextEditingController formulaMultipleBy10InputA = TextEditingController();
  int? outputFormulaMultipleBy10;

  TextEditingController formula2MultipleV1InputA = TextEditingController();
  TextEditingController formula2MultipleV1inputB = TextEditingController();
  double? outputFormulaMultipleV1;

  TextEditingController formula3MultipleV2inputA = TextEditingController();
  TextEditingController formula3MultipleV2InputB = TextEditingController();
  dynamic outputFormulaMultipleV2;

  TextEditingController formulaSayHelloToInputName = TextEditingController();
  String? outputFormulaSayHelloTo;

  String? outputFormulaSayGood;

  @override
  void initState() {
    super.initState();
    source = originalSource;
    inputTEC.text = source;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              TextField(
                controller: inputTEC,
                decoration: InputDecoration(
                  labelText: 'Formula',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(width: 2.0),
                  ),
                ),
                maxLines: null,
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                    onPressed: () {
                      _onFormulaUpdate(inputTEC.text);
                    },
                    child: const Text("Update Formula")),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                    onPressed: () => _onResetAll(),
                    child: const Text("Reset All")),
              ),
              buildDivider(),
              buildSayGood(),
              buildDivider(),
              buildSayHelloTo(),
              buildDivider(),
              buildMultipleBy10(),
              buildDivider(),
              buildMultipleV1(),
              buildDivider(),
              buildMultipleV2(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _displayPopUp(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Warning'),
            content: Text(text),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        });
  }

  _onFormulaUpdate(String newFormula) {
    source = newFormula;
    _clearAll();
    setState(() {});
  }

  _clearFormula1() {
    formulaMultipleBy10InputA.clear();
    outputFormulaMultipleBy10 = null;
  }

  _clearFormula2() {
    formula2MultipleV1InputA.clear();
    formula2MultipleV1inputB.clear();
    outputFormulaMultipleV1 = null;
  }

  _clearFormula3() {
    formula3MultipleV2inputA.clear();
    formula3MultipleV2InputB.clear();
    outputFormulaMultipleV2 = null;
  }

  _clearFormula4() {
    formulaSayHelloToInputName.clear();
    outputFormulaSayHelloTo = null;
  }

  _clearFormula5() {
    outputFormulaSayGood = null;
  }

  _clearAll() {
    _clearFormula1();
    _clearFormula2();
    _clearFormula3();
    _clearFormula4();
    _clearFormula5();
  }

  _onResetAll() {
    source = originalSource;
    inputTEC.text = source;
    _clearAll();
  }

  _onCalculateFormula1({List<dynamic> args = const []}) {
    outputFormulaMultipleBy10 =
        eval(source, function: 'multipleBy10', args: args);
    setState(() {});
  }

  _onCalculateFormula2({List<dynamic> args = const []}) {
    outputFormulaMultipleV1 = eval(source, function: 'multipleV1', args: args);
    setState(() {});
  }

  _onCalculateFormula3({List<dynamic> args = const []}) {
    outputFormulaMultipleV2 = eval(source, function: 'multipleV2', args: args);
    setState(() {});
  }

  _onClickFormula4({List<dynamic> args = const []}) {
    outputFormulaSayHelloTo = eval(source, function: 'sayHelloTo', args: args);
    setState(() {});
  }

  _onClickFormula5() {
    outputFormulaSayGood = eval(source, function: 'sayGood');
    setState(() {});
  }

  Widget buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Divider(),
    );
  }

  Widget buildMultipleBy10() {
    return ListView(
      primary: false,
      shrinkWrap: true,
      children: [
        const Text(
          "multipleBy10",
          style: TextStyle(fontSize: 24, color: Colors.blueAccent),
        ),
        const SizedBox(height: 5),
        const Text("Parameter"),
        const SizedBox(height: 10),
        TextField(
          controller: formulaMultipleBy10InputA,
          decoration: InputDecoration(
            labelText: 'a [int]',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(width: 2.0),
            ),
          ),
          maxLines: null,
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.maxFinite,
          child: ElevatedButton(
              onPressed: () {
                String a = formulaMultipleBy10InputA.text;
                int? parseA = int.tryParse(a);
                if (parseA == null) _displayPopUp('Please Input A as int!');

                _onCalculateFormula1(args: [parseA]);
              },
              child: const Text("Calculate")),
        ),
        const SizedBox(height: 10),
        Text(
          "Output: $outputFormulaMultipleBy10",
        ),
      ],
    );
  }

  Widget buildMultipleV1() {
    return ListView(
      primary: false,
      shrinkWrap: true,
      children: [
        const Text(
          "multipleV1",
          style: TextStyle(fontSize: 24, color: Colors.blueAccent),
        ),
        const SizedBox(height: 5),
        const Text("Parameter"),
        const SizedBox(height: 10),
        TextField(
          controller: formula2MultipleV1InputA,
          decoration: InputDecoration(
            labelText: 'a [double]',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(width: 2.0),
            ),
          ),
          maxLines: null,
        ),
        const SizedBox(height: 10),
        TextField(
          controller: formula2MultipleV1inputB,
          decoration: InputDecoration(
            labelText: 'b [double]',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(width: 2.0),
            ),
          ),
          maxLines: null,
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.maxFinite,
          child: ElevatedButton(
              onPressed: () {
                String a = formula2MultipleV1InputA.text;
                double? parseA = double.tryParse(a);
                if (parseA == null) _displayPopUp('Please Input A as double!');

                String b = formula2MultipleV1inputB.text;
                double? parseB = double.tryParse(b);
                if (parseB == null) _displayPopUp('Please Input A as double!');

                _onCalculateFormula2(args: [parseA, parseB]);
              },
              child: const Text("Calculate")),
        ),
        const SizedBox(height: 10),
        Text(
          "Output: $outputFormulaMultipleV1",
        ),
      ],
    );
  }

  Widget buildMultipleV2() {
    return ListView(
      primary: false,
      shrinkWrap: true,
      children: [
        const Text(
          "multipleV2",
          style: TextStyle(fontSize: 24, color: Colors.blueAccent),
        ),
        const SizedBox(height: 5),
        const Text("Parameter"),
        const SizedBox(height: 10),
        TextField(
          controller: formula3MultipleV2inputA,
          decoration: InputDecoration(
            labelText: 'a [double]',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(width: 2.0),
            ),
          ),
          maxLines: null,
        ),
        const SizedBox(height: 10),
        TextField(
          controller: formula3MultipleV2InputB,
          decoration: InputDecoration(
            labelText: 'b [int]',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(width: 2.0),
            ),
          ),
          maxLines: null,
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.maxFinite,
          child: ElevatedButton(
              onPressed: () {
                String a = formula3MultipleV2inputA.text;
                double? parseA = double.tryParse(a);
                if (parseA == null) _displayPopUp('Please Input A as double!');

                String b = formula3MultipleV2InputB.text;
                int? parseB = int.tryParse(b);
                if (parseB == null) _displayPopUp('Please Input B as int!');

                _onCalculateFormula3(args: [parseA, parseB]);
              },
              child: const Text("Calculate")),
        ),
        const SizedBox(height: 10),
        Text(
          "Output: $outputFormulaMultipleV2",
        ),
      ],
    );
  }

  Widget buildSayHelloTo() {
    return ListView(
      primary: false,
      shrinkWrap: true,
      children: [
        const Text(
          "sayHelloTo",
          style: TextStyle(fontSize: 24, color: Colors.blueAccent),
        ),
        const SizedBox(height: 5),
        const Text("Parameter"),
        const SizedBox(height: 10),
        TextField(
          controller: formulaSayHelloToInputName,
          decoration: InputDecoration(
            labelText: 'name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(width: 2.0),
            ),
          ),
          maxLines: null,
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.maxFinite,
          child: ElevatedButton(
              onPressed: () => _onClickFormula4(
                  args: [$String(formulaSayHelloToInputName.text)]),
              child: const Text("Click")),
        ),
        const SizedBox(height: 10),
        Text(
          "Output: $outputFormulaSayHelloTo",
        ),
      ],
    );
  }

  Widget buildSayGood() {
    return ListView(
      primary: false,
      shrinkWrap: true,
      children: [
        const Text(
          "sayGood",
          style: TextStyle(fontSize: 24, color: Colors.blueAccent),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.maxFinite,
          child: ElevatedButton(
              onPressed: () => _onClickFormula5(), child: const Text("Click")),
        ),
        const SizedBox(height: 10),
        Text(
          "Output: $outputFormulaSayGood",
        ),
      ],
    );
  }
}
