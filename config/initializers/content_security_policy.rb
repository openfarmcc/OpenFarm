
Rails.application.config.content_security_policy do |policy|
  # policy.default_src :self, :https
  # policy.font_src    :self, :https, :data
  # policy.img_src     :self, :https, :data
  # policy.object_src  :none

  # WE SHOULD ENABLE THIS ONE - RC 17 APR 19
  # policy.script_src  :self, "http://www.google-analytics.com/analytics.js"

  # policy.style_src   :self, :https, :unsafe_inline
  # policy.report_uri  "/csp-violation-report-endpoint"
end
