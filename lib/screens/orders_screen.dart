import 'package:e_commerce/widgets/app_drawer.dart';
import 'package:e_commerce/widgets/order_widget.dart';
import 'package:flutter/material.dart';
import '../providers/order.dart';
import 'package:provider/provider.dart';
class OrderScreen extends StatelessWidget {
 static const routeName = '/orders';
 
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body:FutureBuilder(
        future:Provider.of<Order>(context,listen: false).fetchAndSetOrders(),
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }       

        else{
          if(snapshot.error !=null){
            return Center(child: Text("an error occurred"),);
          }
          else{
            return Consumer<Order>(
              builder: (context,order,_){
                return ListView.builder(
                  itemCount: order.orders.length,
                  itemBuilder:(context,index){
                    return OrderWidget(orderItem: order.orders[index]);
                  },
                );
                //
              }
              
              );
          }
        }




          },



          
      ),
      
     
    );
  }
}