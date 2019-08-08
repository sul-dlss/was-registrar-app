require "rails_helper"

RSpec.describe "collections/index" do
  it "displays all the collections" do
    assign(:collections, [
        Collection.create!(title: 'collection1', druid: 'druid:1', last_fetch_succeeded: true, active: true),
        Collection.create!(title: 'collection2', druid: 'druid:2'),
    ])

    render

    expect(rendered).to match /collection1/
    expect(rendered).to match /druid:1/
    expect(rendered).to match /on/
    expect(rendered).to match /true/
    expect(rendered).to match /collection2/
  end
end