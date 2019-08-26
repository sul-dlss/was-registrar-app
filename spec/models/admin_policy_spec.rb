# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdminPolicy, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  let(:collection) { create(:collection) }

  # :admin_policy
  describe 'default admin policy' do
    it 'returns Public policy' do

      debug collection
      expect(collection.admin_policy).to eq('druid:wr005wn5739')
    end
  end
end
