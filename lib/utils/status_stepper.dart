import 'dart:developer';

import 'package:flutter/material.dart';

class StatusStepper extends StatefulWidget {
  final int orderStatus;
  final String  shipping_type;
  StatusStepper({this.orderStatus,this.shipping_type});

  @override
  _StatusStepperState createState() => _StatusStepperState();
}

class _StatusStepperState extends State<StatusStepper> {
  final double barsHeight = 30.0;
  final double barsWidth = 3.0;
  final Color inactiveBarColor = Colors.grey;
  final Color activeBarColor = Colors.green;

  Map<String, bool> steps = Map();

  @override
  void initState() {
    super.initState();
    if(widget.shipping_type =="cod") {
      steps['Order Placed'] = true;
      widget.orderStatus == 5 ? steps['Cancelled'] = true :
      steps['Accepted'] = widget.orderStatus >= 2 ? true : false;
      widget.orderStatus == 5 ? steps['Out For Delivery'] = false :
      steps['Out For Delivery'] = widget.orderStatus >= 3 ? true : false;
      widget.orderStatus == 5 ? steps['Delivered'] = false :
      steps['Delivered'] = widget.orderStatus >= 4 ? true : false;
    }  else{
    steps['Pending'] = true;
    widget.orderStatus == 5 ? steps['Cancelled'] = true :
    steps['Accepted'] = widget.orderStatus >= 2 ? true : false;
    widget.orderStatus == 5 ? steps['Picked up'] = false :
    steps['Picked up'] = widget.orderStatus >= 3 ? true : false;

    }
  }

  @override
  Widget build(BuildContext context) {
    double rowPadding = (barsHeight - kRadialReactionRadius) / 2;
    double _barHeight = barsHeight;
    if (rowPadding < 0) {
      rowPadding = 0;
      _barHeight = kRadialReactionRadius;
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Stack(fit: StackFit.loose, children: <Widget>[
        Positioned(
            left: kRadialReactionRadius - barsWidth / 2,
            top: kRadialReactionRadius + rowPadding,
            bottom: kRadialReactionRadius + rowPadding,
            width: barsWidth,
            child: Column(mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(steps.length - 1, (i) =>
                    Container(
                      margin: EdgeInsets.symmetric(vertical: kRadialReactionRadius / 2 - 2),
                      height: _barHeight + 4,
                      color: steps.values.elementAt(i) && steps.values.elementAt(i + 1) ?
                      activeBarColor : inactiveBarColor,
                    )
                ))
        ),
        Theme(
            data: Theme.of(context).copyWith(disabledColor: inactiveBarColor,
                unselectedWidgetColor: inactiveBarColor),
            child: Column(mainAxisSize: MainAxisSize.min, children: steps.keys.map((key) =>
                Padding(
                    padding: EdgeInsets.symmetric(vertical: rowPadding),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                      Checkbox(
                        value: steps[key],
                        onChanged: steps[key] ? (_) {} : null,
                        activeColor: activeBarColor,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      Text(key, style: TextStyle(fontSize: 16),),
                    ])
                )
            ).toList())
        )
      ]),
    );
  }

}