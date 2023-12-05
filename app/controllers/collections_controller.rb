# frozen_string_literal: true

# Controller for Collections
class CollectionsController < ApplicationController
  before_action :wasapi_provider_accounts, only: %i[new edit]
  before_action :load_collection, only: %i[edit update fetch retry]

  def index
    @collections = Collection.order('title')
  end

  def new
    @collection = Collection.new do |collection|
      collection.embargo_months = Settings.default_embargo_months
      collection.active = true
    end
  end

  def edit; end

  def create
    @collection = Collection.new(collection_params)

    if @collection.save
      flash[:notice] = 'Collection created.'
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @collection.update(collection_params)
      flash[:notice] = 'Collection updated.'
      redirect_to root_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def fetch
    FetchJobCreator.run(collection: @collection)
    flash[:notice] = 'Queued new fetch jobs.'
    redirect_to action: :edit
  end

  def retry
    FetchJobRetrier.retry(collection: @collection)
    flash[:notice] = 'Queued retry fetch jobs.'
    redirect_to action: :edit
  end

  private

  def collection_params
    params.require(:collection).permit(:title,
                                       :druid,
                                       :embargo_months,
                                       :fetch_start_month,
                                       :active,
                                       :wasapi_provider_account,
                                       :wasapi_collection_id)
  end

  def wasapi_provider_accounts
    @wasapi_provider_accounts = []
    Settings.wasapi_providers.each do |provider, provider_info|
      provider_info.accounts.each do |account, _| # rubocop:disable Style/HashEachMethods rubocop thinks each entry is a regular Hash, but accounts elements are actually Arrays of the form [Symbol, Config::options].  so there's no each_key method.
        @wasapi_provider_accounts << ["#{provider_info.name} (#{provider}) > #{account}",
                                      "#{provider}:#{account}"]
      end
    end
  end

  def load_collection
    @collection = Collection.find(params[:id])
  end
end
