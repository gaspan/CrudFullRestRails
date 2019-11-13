Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post 'products' => 'product#create_product'
  get 'products' => 'product#show_all'
  get 'products/:id' => 'product#show_by_id'
  put 'products/:id' => 'product#update_product'
  delete 'products/:id' => 'product#destroy_product'
end
