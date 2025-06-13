project(
  'kOS-theme',
  version: '1.0',
  license: 'GPLv2+',
  meson_version: '>= 1.0.1',
  default_options: ['prefix=/usr'],
)

theme_base_name = get_option('theme_name')
theme_base_dir = join_paths(get_option('datadir'), 'themes', theme_base_name)

# Avoid printing 'Program sh found' multiple times
# if meson version is >= 0.55.0
if meson.version().version_compare('>= 0.55.0')
  sh = find_program('sh')
else
  sh = 'sh'
endif

sass = find_program('sass', required: false)
sass_opts = ['--no-source-map']

if sass.found()
  sass_full_version = run_command(sass, '--version', check:false).stdout()
  sass_is_ruby_sass = sass_full_version.contains('Ruby Sass')
  sass_has_module_system = sass_full_version.version_compare('>= 1.23.0')
endif

if not sass.found() or sass_is_ruby_sass or not sass_has_module_system
  message('dart-sass >= 1.23.0 not found, installing it locally via npm')
  npm = find_program('npm')
  run_command(npm, 'install', check:false)
  sass = find_program('./node_modules/.bin/sass')
endif

themes = []
foreach variant: get_option('variants')
  foreach size: get_option('sizes')
    variant_suffix = variant == 'default' ? '' : '-@0@'.format(variant)
    size_suffix = size == 'default' ? '' : '-@0@'.format(size)

    scss_dark_theme = variant == 'dark' ? 'true' : 'false'
    scss_light_topbar = variant == 'light' ? 'true' : 'false'
    scss_compact = size == 'compact' ? 'true' : 'false'

    foreach color: get_option('colors')
      color_suffix      = color == 'green' ? '' : '-@0@'.format(color)
      scss_purple_theme = color == 'purple' ? 'true' : 'false'
      message('####################################')
      message(color_suffix)

      themes += {
        'name': theme_base_name + variant_suffix + color_suffix + size_suffix,
        'dir': theme_base_dir + variant_suffix + color_suffix + size_suffix,
        'variant': variant_suffix,
        'size': size_suffix,
        'color': color_suffix,
        'scss_dark_theme': scss_dark_theme,
        'scss_light_topbar': scss_light_topbar,
        'scss_compact': scss_compact,
        'scss_purple_theme': scss_purple_theme
      }
    endforeach
  endforeach
endforeach

foreach theme: themes
  install_data(
    [
      'COPYING',
    ],
    install_dir: theme['dir'],
  )
endforeach

if not get_option('flatpak')
  subdir('src')
else
  subdir('src/gtk-3.0')
  subdir('src/gtk-4.0')
endif
