module IntegrationHelper
  module InstanceMethods
    def see(text)
      expect(page).to have_content(text)
    end

    def wait_for_ajax
      Timeout.timeout(Capybara.default_wait_time) do
        active = page.evaluate_script('angular.element.active')
        until active == 0
          active = page.evaluate_script('angular.element.active')
        end
      end
    end
  end

  def self.included(receiver)
    receiver.send :include, InstanceMethods
    receiver.include Warden::Test::Helpers
    Warden.test_mode!
  end
end
