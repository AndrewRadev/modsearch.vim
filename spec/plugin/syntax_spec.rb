require 'spec_helper'

describe "modsearch" do
  let(:filename) { 'test.rb' }

  it "can change a search to ignore comments" do
    set_file_contents <<-EOF
      foo
      # foo
    EOF

    vim.search 'foo'
    vim.command 'Modsearch ignore-syntax-comment'
    vim.normal 'nn'

    vim.normal('cwchanged').write

    assert_file_contents <<-EOF
      changed
      # foo
    EOF
  end

  it "can change a search to ignore strings" do
    set_file_contents <<-EOF
      foo
      "foo"
    EOF

    vim.search 'foo'
    vim.command 'Modsearch ignore-syntax-string'
    vim.normal 'nn'

    vim.normal('cwchanged').write

    assert_file_contents <<-EOF
      changed
      "foo"
    EOF
  end
end
