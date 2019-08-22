# frozen_string_literal: true

# Controller for Collections
class CollectionsController < ApplicationController
  def index
    @collections = Collection.order('title')
  end

  def new
    @collection = Collection.new do |collection|
      collection.embargo_months = Settings.default_embargo_months
    end
  end

  def edit
    @collection = Collection.find(params[:id])
  end

  def create
    @collection = Collection.new(collection_params) do |collection|
      collection.active = true
    end

    if @collection.save
      flash[:notice] = 'Collection created.'
      redirect_to action: 'index'
    else
      render :new
    end
  end

  def update
    @collection = Collection.find(params[:id])

    if @collection.update_attributes(collection_params)
      flash[:notice] = 'Collection updated.'
      redirect_to action: 'index'
    else
      render :edit
    end
  end

  private

  def collection_params
    params.require(:collection).permit(:title,
                                       :druid,
                                       :embargo_months,
                                       :fetch_start_month,
                                       :active)
  end
end
