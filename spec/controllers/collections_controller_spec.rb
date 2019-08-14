# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CollectionsController do
  describe 'GET index' do
    let(:collection1) { create(:collection, title: 'zzz collection') }
    let(:collection2) { create(:collection, title: 'aaa collection') }

    it 'assigns @collections ordered by title' do
      get :index
      expect(assigns(:collections)).to eq([collection2, collection1])
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end
  end
end
