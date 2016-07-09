class CatchRequestErrors
  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      @app.call(env)
    rescue ActionController::BadRequest => error
      ::Rails.logger.warn("WARN: 400 ActionController::BadRequest: #{env['REQUEST_URI']}")
      puts "CAUGHT"
      @html_400_page ||= File.read(::Rails.root.join('public', '400.html'))
      [
          400, { "Content-Type" => "text/html" },
          [ @html_400_page ]
      ]
    end
  end
end
