class CustomLogger < Rails::Rack::Logger
  def initialize(app, opts = {})
    @app = app
    # @opts = opts
    # @opts[:silenced] ||= []
    super
  end

  def call(env)
    # p env
    if env['HTTP_X_SILENCE_LOGGER']
      Rails.logger.silence do
        @app.call(env)
      end
    else
      super(env)
    end
  end
end
