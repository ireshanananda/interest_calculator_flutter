import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Simple Interest Calculator App',
    home: SIForm(),
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
  ));
}

class SIForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SIFormState();
  }
}

class _SIFormState extends State<SIForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<String> _currencies = ['Rupees', 'Dollars', 'Pounds'];
  String _currentItemSelected = 'Rupees';

  final TextEditingController principalController = TextEditingController();
  final TextEditingController roiController = TextEditingController();
  final TextEditingController termController = TextEditingController();
  String displayResult = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.titleLarge;
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Interest Calculator'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              getImageAsset(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  style: textStyle,
                  controller: principalController,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter a Value';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Principal',
                    labelStyle: textStyle,
                    errorStyle: TextStyle(
                      color: Colors.yellowAccent,
                      fontSize: 15.0,
                    ),
                    hintText: 'Enter Principal e.g. 12000',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
              // Similar TextFormField widgets for Rate of Interest and Term.
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  style: textStyle,
                  controller: roiController,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter a Value';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Rate of Interest',
                    labelStyle: textStyle,
                    errorStyle: TextStyle(
                      color: Colors.yellowAccent,
                      fontSize: 15.0,
                    ),
                    hintText: 'Enter Rate of Interest e.g. 5%',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  style: textStyle,
                  controller: termController,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter a Value';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Term',
                    labelStyle: textStyle,
                    errorStyle: TextStyle(
                      color: Colors.yellowAccent,
                      fontSize: 15.0,
                    ),
                    hintText: 'Enter Term in Years e.g. 5',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          foregroundColor: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          setState(() {
                            if (_formKey.currentState!.validate()) {
                              displayResult = _calculateTotalReturns();
                            }
                          });
                        },
                        child: Text('Calculate'),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColorDark,
                          foregroundColor: Theme.of(context).primaryColorLight,
                        ),
                        onPressed: () {
                          setState(() {
                            _reset();
                          });
                        },
                        child: Text('Reset'),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  displayResult,
                  style: textStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage('images/money.png');
    Image image = Image(
      image: assetImage,
      height: 130.0,
    );
    return Container(
      child: image,
      margin: EdgeInsets.all(50),
    );
  }

  String _calculateTotalReturns() {
    double principal = _tryParseDouble(principalController.text);
    double roi = _tryParseDouble(roiController.text);
    double term = _tryParseDouble(termController.text);

    double totalAmountPayable = principal + (principal * roi * term) / 100;

    String result =
        'After $term years, your investment will be worth $totalAmountPayable $_currentItemSelected';
    return result;
  }

  void _reset() {
    principalController.text = '';
    roiController.text = '';
    termController.text = '';
    displayResult = '';
    _currentItemSelected = 'Rupees';
  }

  double _tryParseDouble(String? value) {
    try {
      return double.parse(value ?? '0.0');
    } catch (e) {
      return 0.0; // Return a default value (0.0) if parsing fails
    }
  }
}
