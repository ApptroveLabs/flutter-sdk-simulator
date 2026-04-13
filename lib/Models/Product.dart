class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;

  Product(this.id, this.name, this.description, this.price, this.category, this.imageUrl);
}

class PreloadedProducts {
  static final List<Product> products = [
    Product(1, "Smartphone", "Latest smartphone with 128GB storage", 699.99, "Electronics", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/smartphone.jpg"),
    Product(2, "Laptop", "High-performance laptop with 16GB RAM", 1299.99, "Electronics", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/laptop.jpg"),
    Product(3, "Headphones", "Noise-cancelling wireless headphones", 199.99, "Electronics", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/headphones.jpg"),
    Product(4, "T-Shirt", "Comfortable cotton t-shirt", 19.99, "Clothing", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/t-shirt.jpg"),
    Product(5, "Jeans", "Slim-fit denim jeans", 49.99, "Clothing", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/jeans.jpg"),
    Product(6, "Sneakers", "Stylish and durable sneakers", 79.99, "Clothing", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/sneakers.jpg"),
    Product(7, "Novel", "Bestselling fiction novel", 14.99, "Books", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/novel.jpg"),
    Product(8, "Cookbook", "Collection of delicious recipes", 24.99, "Books", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/cookbook.jpg"),
    Product(9, "Sofa", "Comfortable 3-seater sofa", 499.99, "Home", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/sofa.jpg"),
    Product(10, "Table Lamp", "Modern LED table lamp", 39.99, "Home", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/table_lamp.jpg"),
    Product(11, "Smartwatch", "Fitness tracking and notifications", 199.99, "Electronics", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/smartphone.jpg"),
    Product(12, "Bluetooth Speaker", "Portable speaker with great sound", 59.99, "Electronics", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/bluetooth_speaker.jpg"),
    Product(13, "Gaming Mouse", "High-precision gaming mouse", 49.99, "Electronics", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/gaming_mouse.jpg"),
    Product(14, "Backpack", "Durable and spacious backpack", 39.99, "Accessories", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/backpack.jpg"),
    Product(15, "Sunglasses", "UV-protected stylish sunglasses", 29.99, "Clothing", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/sunglasses.jpg"),
    Product(16, "Desk Chair", "Ergonomic office chair", 149.99, "Home", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/desk_chair.jpg"),
    Product(17, "Coffee Maker", "Automatic drip coffee maker", 89.99, "Home", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/coffee_maker.jpg"),
    Product(18, "Blender", "High-speed kitchen blender", 79.99, "Home", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/blender.jpg"),
    Product(19, "Running Shoes", "Lightweight running shoes", 89.99, "Clothing", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/running_shoes.jpg"),
    Product(20, "Winter Jacket", "Warm and waterproof jacket", 129.99, "Clothing", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/winter_jacket.jpg"),
    Product(21, "Yoga Mat", "Non-slip yoga mat", 29.99, "Fitness", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/yoga_mat.jpg"),
    Product(22, "Dumbbell Set", "Adjustable dumbbell set", 99.99, "Fitness", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/dumbbell_set.jpg"),
    Product(23, "Wireless Earbuds", "True wireless earbuds", 129.99, "Electronics", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/wireless_earbuds.jpg"),
    Product(24, "External Hard Drive", "1TB portable hard drive", 69.99, "Electronics", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/external_hard_drive.jpg"),
    Product(25, "Printer", "All-in-one wireless printer", 149.99, "Electronics", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/printer.jpg"),
    Product(26, "Electric Toothbrush", "Rechargeable electric toothbrush", 49.99, "Health", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/electric_toothbrush.jpg"),
    Product(27, "Air Purifier", "HEPA air purifier", 199.99, "Home", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/air_purifier.jpg"),
    Product(28, "Vacuum Cleaner", "Bagless vacuum cleaner", 129.99, "Home", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/vacuum_cleaner.jpg"),
    Product(30, "Toaster", "2-slice stainless steel toaster", 39.99, "Home", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/toaster.jpg"),
    Product(31, "Plant Pot", "Ceramic plant pot", 24.99, "Home", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/plant_pot.jpg"),
    Product(32, "Throw Blanket", "Soft and cozy throw blanket", 34.99, "Home", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/throw_blanket.jpg"),
    Product(33, "Wall Art", "Framed wall art", 59.99, "Home", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/wall_art.jpg"),
    Product(34, "Water Bottle", "Insulated stainless steel bottle", 29.99, "Accessories", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/water_bottle.jpg"),
    Product(35, "Luggage", "Hard-shell suitcase", 199.99, "Accessories", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/luggage.jpg"),
    Product(36, "Sports Cap", "Breathable sports cap", 19.99, "Accessories", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/sports_cap.jpg"),
    Product(37, "Action Camera", "Waterproof 4K action camera", 299.99, "Electronics", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/action_camera.jpg"),
    Product(38, "Tripod", "Lightweight camera tripod", 49.99, "Photography", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/tripod.jpg"),
    Product(39, "VR Headset", "Immersive virtual reality headset", 499.99, "Electronics", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/vr_headset.jpg"),
    Product(40, "Electric Kettle", "1.5L electric kettle", 39.99, "Home", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/electric_kettle.jpg"),
    Product(41, "Board Game", "Family-friendly strategy game", 29.99, "Toys", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/board_game.jpg"),
    Product(42, "Fitness Tracker", "Track steps and heart rate", 99.99, "Fitness", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/fitness_tracker.jpg"),
    Product(43, "E-Reader", "Compact and lightweight e-reader", 129.99, "Electronics", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/e-reader.jpg"),
    Product(44, "Ski Jacket", "Waterproof and insulated ski jacket", 149.99, "Clothing", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/ski_jacket.jpg"),
    Product(45, "Bean Bag Chair", "Large and comfortable bean bag", 89.99, "Home", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/bean_bag_chair.jpg"),
    Product(46, "Cookware Set", "Non-stick pots and pans set", 129.99, "Home", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/cookware_set.jpg"),
    Product(47, "Gaming Chair", "Adjustable gaming chair", 199.99, "Home", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/gaming_chair.jpg"),
    Product(48, "Dog Bed", "Comfortable bed for pets", 49.99, "Pets", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/dog_bed.jpg"),
    Product(49, "Cat Tree", "Multi-level cat tree", 79.99, "Pets", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/cat_tree.jpg"),
    Product(50, "Digital Piano", "88-key digital piano", 599.99, "Music", "https://storage.googleapis.com/static.trackier.io/images/test-data/downloaded_images/digital_piano.jpg")
  ];
}
