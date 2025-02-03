# frozen_string_literal: true

# Tell rails not only to search in the root directory of the locals. It should
# also search in all subdirectories.
Rails.application.config.i18n.load_path += Rails.root.glob('config/locales/**/*.yml')
Rails.application.config.i18n.default_locale = :en
