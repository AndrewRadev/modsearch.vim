require 'spec_helper'

describe "modsearch" do
  let(:filename) { 'test.txt' }

  it "can change a search to only include words" do
    set_file_contents <<-EOF
      foo bar foobar
    EOF

    vim.search 'foo'
    vim.command 'Modsearch word'
    vim.normal 'nn'

    vim.normal('cwchanged').write

    assert_file_contents <<-EOF
      changed bar foobar
    EOF
  end

  it "can change a search to not only include words" do
    set_file_contents <<-EOF
      foo bar foobar
    EOF

    vim.search '\<foo\>'
    vim.command 'Modsearch unword'
    vim.normal 'n'

    vim.normal('cwchanged').write

    assert_file_contents <<-EOF
      foo bar changed
    EOF
  end
end
