module IntegrationHelper
  module ClassMethods
    
  end
  
  module InstanceMethods
    def see(text)
      expect(page).to have_content(text)
    end
  end
  
  def self.included(receiver)
    receiver.extend ClassMethods
    receiver.send :include, InstanceMethods
    receiver.include Warden::Test::Helpers
    Warden.test_mode!
  end
end
