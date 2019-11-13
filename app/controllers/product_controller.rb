class ProductController < ApplicationController
    # skip_before_filter:verify_authenticity_token
    # rescue_from ActiveRecord::RecordNotFound, with: :notFound    
    
    def create_product
        @product = Product.new(product_params)
        if @product.save
            render json:{
                values:@product,
                message:"success!"
            },status:200
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
