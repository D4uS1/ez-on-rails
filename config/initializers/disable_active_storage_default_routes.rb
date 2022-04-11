# frozen_string_literal: true

# disables the default routes for active storage due to security risks for public uploads
Rails.application.config.active_storage.draw_routes = false
