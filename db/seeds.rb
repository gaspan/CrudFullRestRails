# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

category = Category.create([{name:'fashion',enable:true},{name:'dapur',enable:true}])
category_products = CategoryProduct.create([{product_id:1,category_id:1},{product_id:2,category_id:2}])
products = Product.create([{name:'kemeja',description:'lengan panjang',enable:true},{name:'sendok',description:'ukuran lebar',enable:true}])
