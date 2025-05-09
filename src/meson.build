foreach theme: themes
  index_theme_conf = configuration_data()
  index_theme_conf.set('theme_name', theme['name'])

  index_theme = configure_file(
    input: 'index.theme.in',
    output: '@0@.index.theme'.format(theme['name']),
    configuration: index_theme_conf,
  )

  install_data(
    index_theme,
    rename: 'index.theme',
    install_dir: theme['dir'],
  )
endforeach

subdir('chrome')
subdir('gtk-2.0')
subdir('gtk-3.0')
subdir('gtk-4.0')
subdir('plank')
subdir('xfwm4')
