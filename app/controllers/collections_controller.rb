# frozen_string_literal: true

# Controller for Collections
class CollectionsController < ApplicationController
  def index
    @collections = Collection.order('title')
  end

  def new
    @collection = Collection.new
  end

  def show
    @collection = Collection.find(params[:id])
  end

  def edit
    @collection = Collection.find(params[:id])
  end

  def create
    collection = Collection.create(collection_params)

    redirect_to collection_path(collection)
  end

  private

  def collection_params
    params.require(:collection).permit(:title, :druid, :embargo_months, :last_successful_fetch)
  end
end
