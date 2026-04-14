import '../Models/Product.dart';
import '../Screens/AddtoCartScreen.dart';

class CartManager {
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;
  CartManager._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem(Product product) {
    for (var item in _items) {
      if (item.product.id == product.id) {
        item.quantity++;
        return;
      }
    }
    _items.add(CartItem(product: product, quantity: 1));
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
    }
  }

  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);
  
  void clear() {
    _items.clear();
  }
}
