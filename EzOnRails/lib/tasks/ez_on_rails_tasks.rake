# frozen_string_literal: true

# BEGIN: Webpacker integratiom from https://github.com/rails/webpacker/blob/master/docs/engines.md
def ensure_log_goes_to_stdout
  old_logger = Webpacker.logger
  Webpacker.logger = ActiveSupport::Logger.new($stdout)
  yield
ensure
  Webpacker.logger = old_logger
end

namespace :ez_on_rails do
  namespace :webpacker do
    desc 'Install deps with yarn'
    task yarn_install: :environment do
      Dir.chdir(File.join(__dir__, '../..')) do
        system 'yarn install --no-progress --production'
      end
    end

    desc 'Compile JavaScript packs using webpack for production with digests'
    task compile: %i[yarn_install environment] do
      Webpacker.with_node_env('production') do
        ensure_log_goes_to_stdout do
          if EzOnRails.webpacker.commands.compile
            # Successful compilation!
          else
            # Failed compilation
            exit!
          end
        end
      end
    end
  end
end

# Returns wether yarn install is available
def yarn_install_available?
  rails_major = Rails::VERSION::MAJOR
  rails_minor = Rails::VERSION::MINOR

  rails_major > 5 || (rails_major == 5 && rails_minor >= 1)
end

# enhance_assets_precompile
def enhance_assets_precompile
  # yarn:install was added in Rails 5.1
  deps = yarn_install_available? ? [] : ['ez_on_rails:webpacker:yarn_install']
  Rake::Task['assets:precompile'].enhance(deps) do
    Rake::Task['ez_on_rails:webpacker:compile'].invoke
  end
end

# Compile packs after we've compiled all other assets during precompilation
skip_webpacker_precompile = %w[no false n f].include?(ENV['WEBPACKER_PRECOMPILE'])

unless skip_webpacker_precompile
  if Rake::Task.task_defined?('assets:precompile')
    enhance_assets_precompile
  else
    Rake::Task.define_task('assets:precompile' => 'ez_on_rails:webpacker:compile')
  end
end
# END: Webpacker integration
