# frozen_string_literal: true

# Changes the responder for devise to make Devise coimpatible with Rails 7.
# This should be deleted if devise was updated.
# The code was from here: https://gorails.com/episodes/devise-hotwire-turbo
module DeviseTurboConcern
  extend ActiveSupport::Concern

  # The responder class that is used to render html responses for devise controllers.
  class Responder < ActionController::Responder
    # The respond method used to render html responses for devise controllers.
    def to_turbo_stream
      controller.render(options.merge(formats: :html))
    rescue ActionView::MissingTemplate => e
      if get?
        raise e
      elsif has_errors? && default_action
        render rendering_options.merge(formats: :html, status: :unprocessable_entity)
      else
        redirect_to navigation_location
      end
    end
  end

  included do
    self.responder = Responder
    respond_to :html, :turbo_stream
  end
end
