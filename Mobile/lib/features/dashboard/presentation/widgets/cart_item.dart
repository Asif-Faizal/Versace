import 'package:flutter/material.dart';

class CartItem extends StatefulWidget {
  const CartItem({
    super.key,
    required this.isDark,
    required this.textTheme,
    required this.onDelete,
    required this.onMoveToCart,
    required this.title,
    required this.description,
    required this.image,
    required this.price,
  });

  final bool isDark;
  final TextTheme textTheme;
  final VoidCallback onDelete;
  final VoidCallback onMoveToCart;
  final String title;
  final String description;
  final String image;
  final double price;

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  int quantity = 1;
  String selectedSize = '1';

  void incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = widget.price * quantity;
    
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            border: Border.all(
              color: widget.isDark ? Colors.white : Colors.black,
              width: 0.5,
            ),
          ),
          margin: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(3),
                  ),
                  child: Image.asset(widget.image, fit: BoxFit.cover),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.title,
                        style: widget.textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        widget.description,
                        style: widget.textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DropdownButton<String>(
                            isDense: true,
                            underline: const SizedBox(),
                            value: selectedSize,
                            style: widget.textTheme.bodyMedium,
                            icon: const Icon(Icons.arrow_drop_down),
                            dropdownColor: widget.isDark ? Colors.black : Colors.white,
                            padding: EdgeInsets.zero,
                            menuMaxHeight: 200,
                            items: [
                              DropdownMenuItem(
                                value: '1',
                                child: Text('Size S', style: widget.textTheme.bodyMedium),
                              ),
                              DropdownMenuItem(
                                value: '2',
                                child: Text('Size M', style: widget.textTheme.bodyMedium),
                              ),
                              DropdownMenuItem(
                                value: '3',
                                child: Text('Size L', style: widget.textTheme.bodyMedium),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedSize = value;
                                });
                              }
                            },
                          ),
                          VerticalDivider(
                            color: widget.isDark ? Colors.white : Colors.black,
                            width: 1,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: decrementQuantity,
                                icon: Icon(
                                  Icons.remove_circle_outline,
                                  size: 20,
                                  color: widget.isDark ? Colors.white : Colors.black,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  quantity.toString(),
                                  style: widget.textTheme.bodyMedium,
                                ),
                              ),
                              IconButton(
                                onPressed: incrementQuantity,
                                icon: Icon(
                                  Icons.add_circle_outline,
                                  size: 20,
                                  color: widget.isDark ? Colors.white : Colors.black,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Color: ', style: widget.textTheme.bodyMedium),
                          SizedBox(width: 4),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.brown,
                              shape: BoxShape.circle,
                            ),
                            width: 15,
                            height: 15,
                          ),
                        ],
                      ),
                      SizedBox(height: 2),
                      Divider(
                        color: widget.isDark ? Colors.white : Colors.black,
                        height: 0.5,
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('\$${widget.price.toStringAsFixed(2)} * $quantity', style: widget.textTheme.bodyMedium),
                          Text('-----'),
                          Text('\$${totalPrice.toStringAsFixed(2)}', style: widget.textTheme.labelLarge?.copyWith(decoration: TextDecoration.underline)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            onPressed: widget.onDelete,
            icon: Icon(Icons.close, size: 20),
          ),
        ),
      ],
    );
  }
}
