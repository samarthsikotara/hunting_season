module ProductHunt
  class Event
    include Entity

    def starts_at
    	Time.parse(self["starts_at"])
    end

    def ends_at
    	Time.parse(self["ends_at"])
    end
  end
end