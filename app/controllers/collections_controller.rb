class CollectionsController < ApplicationController
  def index
    @collections = Collection.order('title')
  end
end