class ProductController < ApplicationController
    # skip_before_filter:verify_authenticity_token
    # rescue_from ActiveRecord::RecordNotFound, with: :notFound    
    
    def create_product
        @product = Product.new(product_params)
        if @product.save
            @category_product = CategoryProduct.new(:product_id => @product.id, :category_id => params[:category_id])
            @product_image = ProductImage.new(:product_id => @product.id, :image_id => params[:image_id])
            if @category_product.save && @product_image.save
                render json:{
                    values:{
                        product: @product,
                        category_product: @category_product,
                        image: @product_image
                    },
                    message:"success!"
                },status:200 

            else
                render json:{
                    values:{},
                    message:"Failed!"
                },status:200
            end
        else
            render json:{
                values:{},
                message:"Failed!"
            },status:200
        end
    end

    def update_product
        @product = Product.find(params[:id])
        if @product.update(product_params)
            
            @category_product = CategoryProduct.where({:product_id => @product.id}).update_all({:category_id => params[:category_id]})
            @product_image = ProductImage.where({:product_id => @product.id}).update_all({:image_id => params[:image_id]})
            if @category_product && @product_image
                if @product_image == 0
                    @product_image = ProductImage.new(:product_id => @product.id, :image_id => params[:image_id])
                    if @product_image.save
                        render json:{
                            values:{
                                product: @product,
                                category: @category_product,
                                image: @product_image
                            },
                            message:"success!"
                        },status:200
                    else
                        render json:{
                            values:{},
                            message:"Failed!"
                        },status:400                        
                    end

                else
                    render json:{
                        values:{
                            product: @product,
                            category: @category_product,
                            image: @product_image
                        },
                        message:"success!"
                    },status:200
                end
                
            else
                render json:{
                    values:{},
                    message:"Failed!"
                },status:400
            end
            
        else
            render json:{
                values:{},
                message:"Failed!"
            },status:400
            
        end
    end

    def show_all
        # @product = Product.all
        @product = Product.find_by_sql('SELECT * FROM products where enable =true')

        @products = []
        @product.each do |item|
            @one_product = {}
            @one_product[:id] = item[:id]
            @one_product[:name] = item[:name]
            @one_product[:description] = item[:description]

            @product_image = ProductImage.where({:product_id => item['id']}).limit(1)
            if @product_image.length != 0
                @one_product[:image_id] = @product_image[0]['image_id']

                @image = Image.find(@one_product[:image_id])
                @one_product[:image] = @image.file.url                
                
            else
                @one_product[:image_id] = '-'
                @one_product[:image] = '-'
                
            end

            @category_product = CategoryProduct.where({:product_id => item['id']}).limit(1)
            if @category_product.length != 0
                @one_product[:category_id] = @category_product[0]['category_id']

                @category = Category.find(@one_product[:category_id])

                @one_product[:category] = @category['name']
                @products.push(@one_product)
            else
                @one_product[:category_id] = '-'
                @one_product[:category] = '-'

                @products.push(@one_product)                 
            end


        end
        
        render json:{
            values: @products,
            message: "success!"
        },status:200
    end

    def show_by_id
        @product = Product.where({:id => params[:id]}).limit(1)
        if @product.present?
            @item = {}
            @item[:id] = @product[0][:id]
            @item[:name] = @product[0][:name]
            @item[:description] = @product[0][:description]
            @item[:enable] = @product[0][:enable]
            
            @product_image = ProductImage.where({:product_id => params[:id]}).limit(1)
            if @product_image.length != 0

                @image = Image.find(@product_image[0]['image_id']) 
                @item[:image] = @image.file.url
                
            else
                @item[:image] = '-'
            end

            @category_product = CategoryProduct.where({:product_id => @item[:id]}).limit(1)
            if @category_product.length != 0

                @category = Category.find(@category_product[0][:category_id])
                @item[:image] = @category['name']
            else

                @item[:image] = '-'
            end

            render json:{
                values:@item,
                message: 'Success!'
            }, status:200
        else
            render json:{
                values:"",
                message:"we can't found any data!"
            }, status:400
        end
    end

    def destroy_product
        @product = Product.find(params[:id])        
        if @product.update({enable:0})
            render json:{
                values:{},
                message:"success!",
            },status:200
        end
    end

    def create_category
        @category = Category.new(category_params)
        if @category.save
            render json:{
                values:@category,
                message:"success!"
            },status:200
        else
            render json:{
                values:{},
                message:"Failed!"
            },status:200
        end
    end

    def update_category
        @category = Category.find(params[:id])
        if @category.update(category_params)
            render json:{
                values:{},
                message:"success!"
            },status:200
        else
            render json:{
                values:{},
                message:"Failed!"
            },status:400
            
        end
    end

    def show_all_category

        @category = Category.find_by_sql('SELECT * FROM categories where enable =true')
        
        render json:{
            values: @category,
            message: "success!"
        },status:200
    end

    def show_by_id_category
        @category = Category.find(params[:id])
        if @category.present?
            render json:{
                values:@category,
                message: 'Success!'
            }, status:200
        else
            render json:{
                values:"",
                message:"we can't found any data!"
            }, status:400
        end
    end

    def destroy_category
        @category = Category.find(params[:id])        
        if @category.update({enable:0})
            render json:{
                values:{},
                message:"success!",
            },status:200
        end
    end

    def show_product_by_category
        @category_product = CategoryProduct.where({:category_id => params[:category_id]})

        @id_product_filter_by_category = []

        @category_product.each do |item|
            @id_product_filter_by_category.push(item['product_id'])
        end
        
        @product = Product.where(id:@id_product_filter_by_category)
        @products_enable = []
        @product.each do |item|
            if item.enable
                @products_enable.push(item) 
            end
        end
        

        if @category_product.present?
            render json:{
                products: @products_enable,
                message: 'Success!'
            }, status:200
        else
            render json:{
                values:"",
                message:"we can't found any data!"
            }, status:400
        end
        
    end

    def upload_image
        @image = Image.new
        @image.file = params[:file]
        @image.name = @image.file.identifier
        @image.enable = 1

        if @image.save
            render json:{
                values:@image,
                message:"success!"
            },status:200 

        else
            render json:{
                values:{},
                message:"Failed!"
            },status:200 
        end
    end

    def show_all_images

        @images = Image.find_by_sql('SELECT * FROM images where enable =true')
        
        render json:{
            values: @images,
            message: "success!"
        },status:200
    end

    def destroy_image
        @image = Image.find(params[:id])        
        if @image.update({enable:0})
            render json:{
                values:{},
                message:"success!",
            },status:200
        end
    end   

    private
    def product_params
        params.require(:product).permit(:name,:description,:enable)       
    end

    def category_params
        params.permit(:name,:enable)        
    end      
    
    def notFound
        render json:{
            values:{},
            message: "Data Not Found!",
        }, status:400
    end

end
