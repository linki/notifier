class BaseNotifier
  class << self
    def notify(event, *payload)
      return false unless valid?(event)
      __send__(event, *payload)
    end
    
    private

    def valid?(event)
      respond_to?(event) && notify?(event)
    end

    def notify?(event)
      notified_events.include?(event.to_s)
    end
  
    def notified_events
      []
    end
  end
end
