import 'package:flutter/material.dart';

class TimeComponent extends StatefulWidget {
  DateTime date;
  ValueChanged<DateTime> onSelectedTime;

  TimeComponent({
    Key key,
    @required this.date,
    @required this.onSelectedTime,
  }) : super(key: key);

  @override
  _TimeComponentState createState() => _TimeComponentState();
}

class _TimeComponentState extends State<TimeComponent> {
  final List<String> _hours = List.generate(24, (index) => index++)
      .map((h) => '${h.toString().padLeft(2, '0')}')
      .toList();

  final List<String> _min = List.generate(60, (index) => index++)
      .map((h) => '${h.toString().padLeft(2, '0')}')
      .toList();

  final List<String> _sec = List.generate(60, (index) => index++)
      .map((h) => '${h.toString().padLeft(2, '0')}')
      .toList();

  String _hourSelect = '00';
  String _minSelect = '00';
  String _secSelect = '00';

  void invokeCallback() {
    var newDate = DateTime(
      widget.date.year,
      widget.date.month,
      widget.date.day,
      int.parse(_hourSelect),
      int.parse(_minSelect),
      int.parse(_secSelect),
    );
    widget.onSelectedTime(newDate);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildBox(_hours, (String value){
          setState(() {
            _hourSelect = value;
            invokeCallback();
          });
        }),
        _buildBox(_min, (String value){
          setState(() {
            _minSelect = value;
            invokeCallback();
          });
        }),
        _buildBox(_sec, (String value){
          setState(() {
            _secSelect = value;
            invokeCallback();
          });
        }),
      ],
    );
  }

  Widget _buildBox(List<String> options, ValueChanged<String> onChanged) {
    return Container(
      height: 120,
      width: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            spreadRadius: 0,
            blurRadius: 10,
            color: Theme.of(context).primaryColor,
            offset: Offset(5, 2),
          ),
        ],
      ),
      child: ListWheelScrollView(
        onSelectedItemChanged: (value) => onChanged(value.toString().padLeft(2)),
        physics: FixedExtentScrollPhysics(),
        perspective: 0.008,
        itemExtent: 60,
        children: options
            .map<Text>(
              (e) => Text(
                e,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 40),
              ),
            )
            .toList(),
      ),
    );
  }
}
