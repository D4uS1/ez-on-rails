# frozen_string_literal: true

# Helper module for the broom closet views, containing the render
# information.
module EzOnRails::Admin::BroomCloset::NilOwnersHelper
  # Defines the render informations for the user_owned reaources
  # refering to no user.
  def render_info_nil_owners
    {
      clazz: {
        label: t(:resource),
        type: :string,
        no_sort: true,
        render_blocks: {
          index: proc { |obj| obj.class.to_s },
          search_form: proc do |_data|
            broom_closet_search_field :clazz
          end
        }
      },
      id: {
        label: t(:'ez_on_rails.id'),
        type: :integer,
        no_sort: true,
        render_blocks: {
          index: :default,
          search_form: proc do |_data|
            broom_closet_search_field :id
          end
        }
      }
    }
  end
end
