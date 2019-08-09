# frozen_string_literal: true

# Controller for Collections
class CollectionsController < ApplicationController
  before_action :current_collection, only: [:show, :edit]

  def index
    @collections = Collection.order('title')
  end

  def new
    @collection = Collection.new
  end

  def show
  end

  def edit
  end

  def create
    collection = Collection.create(collection_params)

    redirect_to collection_path(collection)
  end

  private

  def collection_params
    params.require(:collection).permit(:title, :druid, :embargo_months, :last_successful_fetch)
  end

  def current_collection
    @collection = Collection.find(params[:id])
  end
end
