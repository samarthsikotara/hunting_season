require 'spec_helper'

describe "Live Events API" do

  before(:all) do
    @client = ProductHunt::Client.new(ENV['TOKEN'] || 'my-token')
  end

  it 'implements live events#index' do
    stub_request(:get, "https://api.producthunt.com/v1/live").
      to_return(File.new("./spec/support/webmocks/get_live_events.txt"))

    live_events = @client.events  
    live_event = @client.events.first

    expect(live_event['name']).to eq('Justin Bailey')
    expect(live_event['id']).to eq(99)

    expect(live_events.size).to be > 0
  end

  it 'implements live events#index with pagination' do
    stub_request(:get, "https://api.producthunt.com/v1/live?newer=2016-01-01&per_page=1&limit=3").
      to_return(File.new("./spec/support/webmocks/get_live_events_per_page.txt"))

    live_event = @client.events(per_page: 1, limit: 3, newer: "2016-01-01").first

    expect(live_event['name']).to eq('Justin Kan')
    expect(live_event['id']).to eq(382)
  end

  it 'implements live events#index search the live events by category' do
    stub_request(:get, "https://api.producthunt.com/v1/live?search[category]=tech").
      to_return(lambda { |request|
        File.new("./spec/support/webmocks/get_live_events_search_category.txt").read
      })
    
    live_events = @client.events("search[category]" => 'tech').first

    expect(live_events['name']).to eq('Adam Lisagor')
    expect(live_events['id']).to eq(96)
  end

  it 'implements live events#index search the live events by month' do
    stub_request(:get, "https://api.producthunt.com/v1/live?search[date]=2016-01").
      to_return(lambda { |request|
        File.new("./spec/support/webmocks/get_live_events_search_date.txt").read
      })
    
    live_events = @client.events("search[date]" => '2016-01').first

    expect(live_events['name']).to eq('Justin Kan')
    expect(live_events['id']).to eq(382)
  end

  describe 'by id' do
    before(:each) do
      stub_request(:get, "https://api.producthunt.com/v1/live/99").
        to_return(File.new("./spec/support/webmocks/get_live_event.txt"))

      @event = @client.event(99)
    end

    it 'implements live events#show and yields the name of the event' do
      expect(@event['name']).to eq('Justin Bailey')
      expect(@event["tagline"]).to eq("The CEO of Fig, a new crowd-funding site for games that offers equity.")
    end
  end

end