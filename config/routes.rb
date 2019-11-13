Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post 'products' => 'product#create_product'
  get 'products' => 'product#show_all'
  get 'products/:id' => 'product#show_by_id'
  put 'products/:id' => 'product#update_product'
  delete 'products/:id' => 'product#destroy_product'

  post 'categories' => 'product#create_category'
  put 'categories/:id' => 'product#update_category'
  get 'categories' => 'product#show_all_category'
  get 'categories/:id' => 'product#show_by_id_category'
  delete 'categories/:id' => 'product#destroy_category'

  post 'products_by_category' => 'product#show_product_by_category'


end
