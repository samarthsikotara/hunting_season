module ProductHunt
  module API
    module Events

      PATH = "/live"

      def events(options = {})
        process(PATH, options) do |response|
          response["live_events"].map{ |event| Event.new(event, self) }
        end
      end

      def event(id, options = {})
        process(PATH + "/#{id}", options) do |response|
          Event.new(response["live_event"], self)
        end
      end
    
    end
  end
end
