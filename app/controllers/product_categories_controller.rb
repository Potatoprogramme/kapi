# frozen_string_literal: true

class ProductCategoriesController < ApplicationController
  def index
    @categories = ProductCategory.all
  end
end
