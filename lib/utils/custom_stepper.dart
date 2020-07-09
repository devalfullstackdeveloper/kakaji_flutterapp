import 'package:flutter/material.dart';
import 'apptheme.dart';

class AddCartStepper extends StatefulWidget {
  final int initialValue;
  final Function(int) onAdd;
  final Function(int) onRemove;
  AddCartStepper({@required this.onAdd, @required this.onRemove, this.initialValue});

  @override
  _AddCartStepperState createState() => _AddCartStepperState();
}

class _AddCartStepperState extends State<AddCartStepper> {
  bool _showAdd = true;
  int _value;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(borderRadius: BorderRadius.circular(4),
      child: _showAdd == true ?
      GestureDetector(
        child: Container(color: AppTheme.redColor, width: 90, height: 32,
          child: Center(child: Text('Add', style: TextStyle(color: Colors.white),),),
        ),
        onTap: () {
          setState(() {
            widget.onAdd(1);
            _value = widget.initialValue;
            _showAdd = false;
          });
        },
      ) :
      Container(color: Colors.green, width: 90, height: 32,
        child: _value == widget.initialValue ?
        Center(
          child: SizedBox(height: 14, width: 14,
            child: CircularProgressIndicator(valueColor:
              AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2,),
          ),
        ) :
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            GestureDetector(child: Icon(Icons.remove, color: Colors.white),
              onTap: () {
                setState(() {
                  widget.onRemove(-1);
                  _value = widget.initialValue;
                });
              },),
            Text('${widget.initialValue}', style: TextStyle(fontSize: 16.5, color: Colors.white),
              textAlign: TextAlign.center,),
            GestureDetector(child: Icon(Icons.add, color: Colors.white),
              onTap: () {
                setState(() {
                  widget.onAdd(1);
                  _value = widget.initialValue;
                });
              },),
          ],
        ),
      ),
    );
  }
}

class CartChangeStepper extends StatefulWidget {
  final int initialValue;
  final Function(int) onAdd;
  final Function(int) onRemove;
  CartChangeStepper({@required this.initialValue, @required this.onAdd, @required this.onRemove});

  @override
  _CartChangeStepperState createState() => _CartChangeStepperState();
}

class _CartChangeStepperState extends State<CartChangeStepper> {
  int _value;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(borderRadius: BorderRadius.circular(4),
      child: Container(color: Color(0xFFEAECEE), width: 90, height: 32,
        child: _value == widget.initialValue ?
        Center(
          child: SizedBox(height: 14, width: 14,
            child: CircularProgressIndicator(valueColor:
            AlwaysStoppedAnimation<Color>(Colors.red),
              strokeWidth: 2,),
          ),
        ) :
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            GestureDetector(child: Icon(Icons.remove),
              onTap: () {
                setState(() {
                  widget.onRemove(-1);
                  _value = widget.initialValue;
                });
              },),
            Text('${widget.initialValue}', style: TextStyle(fontSize: 16.5),
              textAlign: TextAlign.center,),
            GestureDetector(child: Icon(Icons.add),
              onTap: () {
                setState(() {
                  widget.onAdd(1);
                  _value = widget.initialValue;
                });
              },),
          ],
        ),
      ),
    );
  }
}


class AddProductStepper extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int> onChanged;
  AddProductStepper({@required this.onChanged, this.initialValue});
  @override
  _AddProductStepperState createState() => _AddProductStepperState();
}

class _AddProductStepperState extends State<AddProductStepper> {
  int _value;

//  @override
//  void initState() {
//    super.initState();
//    _value = widget.initialValue ?? 0;
//  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(borderRadius: BorderRadius.circular(4),
      child:  _value == 0 ?
      GestureDetector(
        child: Container(color: Colors.red, width: 90, height: 32,
          child: Center(child: Text('Add', style: TextStyle(color: Colors.white),),),
        ),
        onTap: () {
          setState(() {
            _value = 1;
            _valueChanged();
          });
        },
      ) :
      Container(color: Colors.green, width: 90, height: 32,
        child: _value == widget.initialValue ?
        Center(
          child: SizedBox(height: 14, width: 14,
            child: CircularProgressIndicator(valueColor:
            AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 2,),
          ),
        ) :
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            GestureDetector(child: Icon(Icons.remove, color: Colors.white),
              onTap: () {
                setState(() {
                  _value -= 1;
                  _valueChanged();
                });
              },),
            Text('$_value', style: TextStyle(fontSize: 16.5, color: Colors.white),
              textAlign: TextAlign.center,),
            GestureDetector(child: Icon(Icons.add, color: Colors.white),
              onTap: () {
                setState(() {
                  _value += 1;
                  _valueChanged();
                });
              },),
          ],
        ),
      ),
    );
  }

  _valueChanged() {
    widget.onChanged(_value);
  }
}


class CartStepper extends StatefulWidget {
  final int initialValue;
  final int maxValue;
  final ValueChanged<int> onChanged;
  CartStepper({this.initialValue, this.maxValue, this.onChanged});
  @override
  _CartStepperState createState() => _CartStepperState();
}

class _CartStepperState extends State<CartStepper> {
  int _value;
  int _maxVal;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue ?? 1;
    _maxVal = widget.maxValue;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(borderRadius: BorderRadius.circular(6),
      child: Container(color: Colors.green,
        width: 90, height: 32,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            GestureDetector(child: Icon(Icons.remove, color: Colors.white,),
              onTap: () {
                if (_value > 1) {
                  setState(() {
                    _value -= 1;
                    _valueChanged();
                  });
                }
              },),
            Text('$_value', style: TextStyle(fontSize: 16.5, color: Colors.white,),
              textAlign: TextAlign.center,),
            GestureDetector(child: Icon(Icons.add, color: Colors.white,),
              onTap: () {
                if (_value < _maxVal) {
                  setState(() {
                    _value += 1;
                    _valueChanged();
                  });
                }
              },),
          ],
        ),
      ),
    );
  }

  _valueChanged() {
    widget.onChanged(_value);
  }

}