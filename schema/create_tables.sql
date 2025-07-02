create database skincare_store;

use skincare_store;

CREATE TABLE users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  age INT,
  gender ENUM('female', 'male', 'other'),
  skin_type ENUM('dry', 'oily', 'combination', 'sensitive', 'normal', 'acne-prone'),
  skin_concerns VARCHAR(255)
);

CREATE TABLE products (
  product_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  brand VARCHAR(100),
  category VARCHAR(50),
  price DECIMAL(10,2),
  rating DECIMAL(2,1)
);

CREATE TABLE ingredients (
  ingredient_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  benefits TEXT,
  comedogenic_rating INT
);

CREATE TABLE product_ingredients (
  product_id INT,
  ingredient_id INT,
  FOREIGN KEY (product_id) REFERENCES products(product_id),
  FOREIGN KEY (ingredient_id) REFERENCES ingredients(ingredient_id),
  PRIMARY KEY (product_id, ingredient_id)
);

-- CREATE TABLE orders (
--   order_id INT AUTO_INCREMENT PRIMARY KEY,
--   user_id INT,
--   product_id INT,
--   order_date DATE,
--   quantity INT,
--   FOREIGN KEY (user_id) REFERENCES users(user_id),
--   FOREIGN KEY (product_id) REFERENCES products(product_id)
-- );

drop table orders;

CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  user_id INT,
  order_date DATE,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE order_items (
  order_item_id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT,
  product_id INT,
  quantity INT,
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE reviews (
  review_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  product_id INT,
  rating DECIMAL(2,1),
  review_text TEXT,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

