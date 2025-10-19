return {
  exe = 'bundle',
  args = { 'exec', 'rubocop', '-a', '--stdin', '$FILENAME' },
  stdin = true,
}
