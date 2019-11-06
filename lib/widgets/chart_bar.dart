import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String day_label;
  final double spending_amount;
  final double percen_of_total;

  ChartBar(this.day_label, this.spending_amount, this.percen_of_total);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      //LayoutBuilder = dynamically lay out widget based on contraints sent by calling widget. 
      builder: (context, contraints) {
        return Column(          
          children: <Widget>[
            Container(              
              child: FittedBox(
                //FittedBox = content is kept within the widget.
                child: Text('\$${spending_amount.toStringAsFixed(0)}'),
                fit: BoxFit.cover,
              ),
              height: contraints.maxHeight * 0.15,
            ),
            Container(              
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.0,
                        color: Colors.grey,
                      ),
                      color: Color.fromRGBO(220, 220, 220, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  FractionallySizedBox(
                    heightFactor: percen_of_total,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.amber[700],
                      ),
                    ),
                  ),
                ],
              ),
              height: contraints.maxHeight * 0.70,
              width: 10,
            ),
            Container(
              child: Text(day_label),
              height: contraints.maxHeight * 0.15,
            ),
          ],
        );
      },
    );
  }
}
