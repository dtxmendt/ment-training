class Admin::ProductsController < ApplicationController
  include ApplicationHelper
  layout :dynamic_layout
  before_action :set_product, only: %i[ show edit update destroy get_variants ]
  before_action :check_link
  # GET /products or /products.json
  def index
    @search = Product.ransack(params[:q])
    @products = @search.result
    @products= @products.page(params[:page]).per(10)
    
  end

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
    
  end

  def get_variants
    if @product.variants.count > 0
       @variants= @product.variants
    else
      @variants= @product.variants.new
    end

  end



  # POST /products or /products.json
  def create
    @product = Product.new(product_params)
    respond_to do |format|
      if @product.save
        format.html { render :show, notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { render :show, notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to admin_products_path, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end
   

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:name, :sku, :description, :meta_description, :meta_keywords,:price,{taxon_ids:[]},{pictures:[]},{remove_picture_ids:[]})
    end
end
