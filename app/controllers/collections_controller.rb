# frozen_string_literal: true

# Controller for Collections
class CollectionsController < ApplicationController
  def index
    @collections = Collection.order('title')
  end

  def show
    @collection = Collection.find_by_druid(params[:id])
  end
end
