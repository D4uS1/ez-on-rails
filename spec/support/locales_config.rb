# frozen_string_literal: true

# see phoet's comment on https://github.com/rspec/rspec-rails/issues/255
# prevents the locale: <#ObjectID> problem where Rails thinks the object is the locale
class ActionView::TestCase::TestController
  def default_url_options(_options = {})
    default_url_options_hash
  end
end

# see phoet's comment on https://github.com/rspec/rspec-rails/issues/255
# prevents the locale: <#ObjectID> problem where Rails thinks the object is the locale
class ActionDispatch::Routing::RouteSet
  def default_url_options(_options = {})
    default_url_options_hash
  end
end

# see phoet's comment on https://github.com/rspec/rspec-rails/issues/255
# returns the default url_options.
def default_url_options_hash
  {
    host: 'app.dev',
    locale: I18n.locale || I18n.default_locale
  }
end
