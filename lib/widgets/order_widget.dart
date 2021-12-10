import 'package:e_commerce/providers/order.dart';
import 'package:flutter/material.dart';

class OrderWidget extends StatefulWidget {
 
 final OrderItem orderItem;
 OrderWidget({ required this.orderItem});

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  var isExpand = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.orderItem.amount}'),
            subtitle: const Text("aaaaaaaaa"),
            trailing: IconButton(
              onPressed:(){
                setState(() {
                  isExpand = !isExpand;
                });
              },
              icon: Icon(
              isExpand ? Icons.expand_less: Icons.expand_more
                ),
            ),
          ),
          if(isExpand) SizedBox(
            height: 300,
            child: ListView(
              children:widget.orderItem.products!.map((prod) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    prod.title!,style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                  
                  Text("\$${prod.quantity} X \$${prod.price}\n")
                ],
              )           
              ).toList()
            ),

          )

        ],
      ),
    );
  }
}