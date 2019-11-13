class ProductController < ApplicationController
    # skip_before_filter:verify_authenticity_token
    # rescue_from ActiveRecord::RecordNotFound, with: :notFound    
    
    def create_product
        @product = Product.new(product_params)
        if @product.save
            @category_product = CategoryProduct.new(:product_id => @product.id, :category_id => params[:category_id])
            if @category_product.save
                render json:{
                    values:{
                        product: @product,
                        category_product: @category_product
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
            if @category_product
                render json:{
                    values:{
                        product: @product,
                        category: @category_product
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
                values:{},
                message:"Failed!"
            },status:400
            
        end
    end

    def show_all
        # @product = Product.all
        @product = Product.find_by_sql('SELECT * FROM products where enable =true')
        
        render json:{
            values: @product,
            message: "success!"
        },status:200
    end

    def show_by_id
        @product = Product.find(params[:id])
        if @product.present?
            render json:{
                values:@product,
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
    
    

    private
    def product_params
        params.require(:product).permit(:name,:description,:enable)       
    end

    def category_params
        params.permit(:name,:enable)        
    end

    def category_product_params
        params.permit(:category_id)        
    end
    
    

    def notFound
        render json:{
            values:{},
            message: "Data Not Found!",
        }, status:400
    end

end
