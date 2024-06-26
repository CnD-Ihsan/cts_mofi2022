import 'package:flutter/material.dart';

class _ArticleDescription extends StatelessWidget {
  const _ArticleDescription({
    required this.title,
    required this.subtitle,
    required this.group,
    required this.date,
    required this.time,
    required this.ticketStatus,
  });

  final String title;
  final String subtitle;
  final String group;
  final String date;
  final String time;
  final String ticketStatus;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Badge(
                    label: Text(ticketStatus, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold),),
                    backgroundColor: ticketStatus == 'Open' ? Colors.green : Colors.black12,
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(bottom: 2.0)),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              const Padding(padding: EdgeInsets.only(bottom: 2.0)),
              Text(
                group,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black87,
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 2.0)),
              Row(
                children: [
                  Text(
                    '$date, $time',
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OrderItem extends StatelessWidget {
  const OrderItem({
    super.key,
    required this.thumbnail,
    required this.title,
    required this.subtitle,
    required this.group,
    required this.date,
    required this.time,
    required this.ticketStatus,
  });

  final Widget thumbnail;
  final String title;
  final String subtitle;
  final String group;
  final String date;
  final String time;
  final String ticketStatus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        decoration: const BoxDecoration(border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.indigoAccent
          ),
        )),
        child: SizedBox(
          height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1.0,
                child: thumbnail,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                  child: _ArticleDescription(
                    title: title,
                    subtitle: subtitle,
                    group: group,
                    date: date,
                    time: time,
                    ticketStatus: ticketStatus,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

