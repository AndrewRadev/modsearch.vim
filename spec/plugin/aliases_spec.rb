require 'spec_helper'

describe "modsearch" do
  let(:filename) { 'test.rb' }

  it "aliases w to searching for only words" do
    set_file_contents <<-EOF
      foo bar foobar
    EOF

    vim.search 'foo'
    vim.command 'Modsearch w'
    vim.normal 'nn'

    vim.normal('cwchanged').write

    assert_file_contents <<-EOF
      changed bar foobar
    EOF
  end
end
