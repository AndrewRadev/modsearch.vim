require 'spec_helper'

describe "modsearch" do
  let(:filename) { 'test.txt' }

  it "allows adding custom mods" do
    vim.command "let g:modsearch_custom_mods = {'custom': ['alias', 'word']}"

    set_file_contents <<-EOF
      foo bar foobar
    EOF

    vim.search 'foo'
    vim.command 'Modsearch custom'
    vim.normal 'nn'

    vim.normal('cwchanged').write

    assert_file_contents <<-EOF
      changed bar foobar
    EOF
  end
end
