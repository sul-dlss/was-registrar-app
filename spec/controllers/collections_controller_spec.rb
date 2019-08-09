# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CollectionsController do
  describe 'GET index' do
    it 'assigns @collections ordered by title' do
      collection1 = Collection.create title: 'zzz collection', druid: 'druid:abc123', embargo_months: 6, active: true
      collection2 = Collection.create title: 'aaa collection', druid: 'druid:def456', embargo_months: 6, active: true
      get :index
      expect(assigns(:collections)).to eq([collection2, collection1])
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end
  end
end
