import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  final List<String> _currencies = [
    'Sri Lankan Rupees (LKR)',
    'Dollars',
    'Pounds'
  ];
  String _currentItemSelected = 'Sri Lankan Rupees (LKR)';
  double _conversionRate = 1.0; // Default conversion rate
  String _conversionCurrency = 'Sri Lankan Rupees (LKR)';

  final TextEditingController principalController = TextEditingController();
  final TextEditingController roiController = TextEditingController();
  final TextEditingController termController = TextEditingController();
  String displayResult = '';

  @override
  void initState() {
    super.initState();
    // Fetch the latest exchange rates from an API
    _fetchExchangeRates();
  }

  Future<void> _fetchExchangeRates() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.exchangerate-api.com/v4/latest/USD'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _conversionRate =
            data['rates']['LKR']; // Sri Lankan Rupees (LKR) exchange rate

        // Fetch the Pound exchange rate
        double poundExchangeRate =
            data['rates']['GBP']; // Pounds (GBP) exchange rate

        setState(() {
          // Rebuild the UI with the fetched exchange rates
          _conversionRates['Dollars'] = 1.0; // Default rate for Dollars
          _conversionRates['Sri Lankan Rupees (LKR)'] = _conversionRate;
          _conversionRates['Pounds'] = poundExchangeRate;
        });
      } else {
        throw Exception('Failed to fetch exchange rates');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Map<String, double> _conversionRates = {
    'Dollars': 1.0,
    'Sri Lankan Rupees (LKR)': 1.0,
    'Pounds': 1.0,
  };

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.titleLarge;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
                child: DropdownButtonFormField<String>(
                  value: _currentItemSelected,
                  items: _currencies.map((String currency) {
                    return DropdownMenuItem<String>(
                      value: currency,
                      child: Text(currency),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _currentItemSelected = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Select Currency for Calculation',
                    labelStyle: textStyle,
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
                      color: Colors.red,
                      fontSize: 15.0,
                    ),
                    hintText: 'Enter Principal e.g. 12000',
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
                      color: Colors.red,
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
                      color: Colors.red,
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
                child: DropdownButtonFormField<String>(
                  value: _conversionCurrency,
                  items: _currencies.map((String currency) {
                    return DropdownMenuItem<String>(
                      value: currency,
                      child: Text(currency),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _conversionCurrency = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Select Currency for Conversion',
                    labelStyle: textStyle,
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

    if (_currentItemSelected != _conversionCurrency) {
      totalAmountPayable /= _conversionRates[_currentItemSelected]!;
      totalAmountPayable *= _conversionRates[_conversionCurrency]!;
    }

    String result =
        'After $term years, your investment will be worth $totalAmountPayable $_conversionCurrency';
    return result;
  }

  void _reset() {
    principalController.text = '';
    roiController.text = '';
    termController.text = '';
    displayResult = '';
    _currentItemSelected = 'Sri Lankan Rupees (LKR)';
    _conversionCurrency = 'Sri Lankan Rupees (LKR)';
  }

  double _tryParseDouble(String? value) {
    try {
      return double.parse(value ?? '0.0');
    } catch (e) {
      return 0.0; // Return a default value (0.0) if parsing fails
    }
  }
}
