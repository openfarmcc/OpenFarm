class Chef
  class Provider
    class GitClient < Chef::Provider::LWRPBase
      use_inline_resources

      def whyrun_supported?
        true
      end

      include GitCookbook::Helpers
    end
  end
end
