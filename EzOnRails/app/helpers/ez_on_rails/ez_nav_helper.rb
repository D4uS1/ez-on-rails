# frozen_string_literal: true

# Helper module for the navigation menu generated by the EzOnRails:EzNav generator.
module EzOnRails::EzNavHelper
  # Returns the main menu entries of the navigation.
  # If the current user is not able to access some entry, it will be not included.
  # If the menu entry is invisible, it will be ignored, too.
  # This method will filter sub_menus, too.
  def visible_nav_menus
    # get main menus
    main_menus = menu_structure[:main_menus].clone

    # for each main menu containing target information itsels, reject it if ...
    main_menus.reject! do |main_menu|
      # ... the main menu is invisible
      next true if main_menu[:invisible]

      # skip if this is a submenu, those will be filtered later
      next false if main_menu.key?(:sub_menus)

      # ... the menu defines some namespace and the current user nas no access to it
      next true if main_menu[:namespace] && (!access_to_namespace? main_menu[:namespace])

      # ... the main menu defines some route and the current user has no access to it
      next true unless access_to_action?(main_menu[:namespace], main_menu[:controller], main_menu[:action])
    end

    # filter sub menus
    main_menus.each do |main_menu|
      filter_submenus! main_menu if submenus? main_menu
    end

    # reject main menus having sub menus with no entry
    main_menus.reject! do |main_menu|
      submenus?(main_menu) && main_menu[:sub_menus].empty?
    end

    main_menus
  end

  # Removes the submenu entries from the main menu, which are not visible for the current_user.
  def filter_submenus!(main_menu)
    main_menu[:sub_menus].reject! do |sub_menu|
      # Reject invisible submenu
      next true if sub_menu[:invisible]

      # Reject if the current user cannot access the target
      next true unless access_to_action_in_path?(sub_menu[:controller], sub_menu[:action])
    end
  end

  # returns wether the given main menu has sub menus.
  def submenus?(main_menu)
    main_menu.key? :sub_menus
  end

  # renders the main menus sub menu dropdown.
  def render_submenu_dropdown(main_menu)
    link_to(main_menu[:label], '#',
            class: 'nav-link dropdown-toggle',
            id: submenu_id(main_menu),
            'data-bs-toggle' => 'dropdown',
            'aria-expanded' => 'false',
            style: "color: #{header_text_color};")
  end

  # renders the sub menu items of the given main menu.
  def render_sub_menu_item(menu_item)
    link_to(menu_item[:label],
            {
              controller: "/#{menu_item[:controller]}",
              action: menu_item[:action]
            },
            class: 'dropdown-item')
  end

  # Renders the main menu entry, containing no sub menus.
  def render_main_menu_item(menu_item)
    link_to(menu_item[:label],
            {
              controller: "#{menu_item[:namespace] ? "/#{menu_item[:namespace]}" : ''}/#{menu_item[:controller]}",
              action: menu_item[:action]
            },
            class: 'nav-link',
            style: "color: #{header_text_color};")
  end

  # returns the unique id of the sub menu given by the main menu.
  def submenu_id(main_menu)
    "navbar_submenu_#{main_menu[:label].underscore}"
  end
end
